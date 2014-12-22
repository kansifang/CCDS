/*
 * Copyright (C) 2014 hu
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
package com.lmt.app.crawler;

import java.util.ArrayList;

import com.lmt.app.crawler.dao.HtmlBean;
import com.lmt.app.crawler.dao.HtmlDao;
import com.lmt.app.crawler.fetcher.Fetcher;
import com.lmt.app.crawler.generator.DbUpdater;
import com.lmt.app.crawler.generator.DbUpdaterFactory;
import com.lmt.app.crawler.generator.Generator;
import com.lmt.app.crawler.generator.Injector;
import com.lmt.app.crawler.handler.Handler;
import com.lmt.app.crawler.handler.Message;
import com.lmt.app.crawler.model.Page;
import com.lmt.app.crawler.net.RequestFactory;
import com.lmt.app.crawler.parser.ParserFactory;
import com.lmt.app.crawler.util.LogUtils;
import com.lmt.app.crawler.util.RegexRule;

/**
 * 广度遍历爬虫的基类
 * @author hu
 */
public abstract class Crawler implements  RequestFactory, ParserFactory, DbUpdaterFactory {
    protected int status;
    public final static int RUNNING = 1;
    public final static int STOPED = 2;
    protected boolean resumable = false;
    protected int threads = 10;
    //protected ArrayList<String> regexs = new ArrayList<String>();
    protected RegexRule regexRule=new RegexRule();
    protected ArrayList<String> seeds = new ArrayList<String>();
    protected Fetcher fetcher;
    private HtmlDao HD=new HtmlDao();
    private HtmlBean HB=new HtmlBean();
    
    public abstract Injector createInjector();
    public abstract Generator createGenerator();
    /**
     * 生成Fetcher(抓取器)的方法，可以通过Override这个方法来完成自定义Fetcher
     * @return 生成的抓取器
     */
    public abstract Fetcher createFetcher();
    /**
     * 开始深度为depth的爬取
     * @param depth 深度
     * @throws Exception
     */
    public void start(int depth) throws Exception {
        if (!resumable) {
            DbUpdater clearDbUpdater = createDbUpdater();
            if (clearDbUpdater != null) {
                clearDbUpdater.clearHistory();
            }

            if (seeds.isEmpty()) {
                LogUtils.getLogger().info("error:Please add at least one seed");
                return;
            }
        }
        if (regexRule.isEmpty()) {
            LogUtils.getLogger().info("error:Please add at least one positive regex rule");
            return;
        }
        inject();

        status = RUNNING;
        //从顶层链接一层层往下，每做一层，开多个线程爬取，爬取完，进行下一层
        for (int i = 0; i < depth; i++) {
            if (status == STOPED) {
                break;
            }
            LogUtils.getLogger().info("-------------------------starting depth " + (i + 1));
            Generator generator = createGenerator();
            fetcher = createFetcher();
            fetcher = updateFetcher(fetcher);
            if (fetcher == null) {
                return;
            }
            fetcher.fetchAll(generator);
        }
        HD.close();
    }
    /**
     * 停止爬取
     * @throws Exception
     */
    public void stop() throws Exception {
        fetcher.stop();
        status = STOPED;
    }
    protected Fetcher updateFetcher(Fetcher fetcher) {
        try {
            fetcher.setRequestFactory(this);
            fetcher.setParserFactory(this);
            DbUpdater dbUpdater = createDbUpdater();
            if (dbUpdater != null) {
                fetcher.setDbUpdater(dbUpdater);
            }
            fetcher.setHandler(createFetcherHandler());
            return fetcher;
        } catch (Exception ex) {
            LogUtils.getLogger().info("Exception", ex);
            return null;
        }
    }
    /**
     * 生成处理抓取消息的Handler，默认通过Crawler的visit方法来处理成功抓取的页面，
     * 通过failed方法来处理失败抓取的页面
     *
     * @return 处理抓取消息的Handler
     */
    public Handler createFetcherHandler() {
        Handler fetchHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                Page page = (Page) msg.obj;
                switch (msg.what) {
                    case Fetcher.FETCH_SUCCESS:
                        visit(page);
                        break;
                    case Fetcher.FETCH_FAILED:
                        failed(page);
                        break;
                    default:
                        break;
                }
            }
        };
        return fetchHandler;
    }
    /**
     * 爬取成功时执行的方法
     * @param page 成功爬取的网页/文件
     */
    public void visit(Page page) {
    }

    /**
     * 爬取失败时执行的方法
     * @param page 爬取失败的网页/文件
     */
    public void failed(Page page) {
    }
    /**
     * 注入
     * @throws Exception
     */
    public void inject() throws Exception {
        Injector injector = createInjector();
        injector.inject(seeds, true);
    }

    /**
     * 添加一个种子url
     *
     * @param seed 种子url
     */
    public void addSeeds(String seed,String delimiter_regex) {
    	String[]aSeed=seed.split(delimiter_regex);
    	for(String sd:aSeed){
    		seeds.add(sd);
    	}
    }

    /**至少匹配一个
     * 添加一个正则过滤规则
     *
     * @param regex 正则过滤规则
     */
    public void addPRegexs(String regex,String delimiter_regex) {
    	String[]aRegex=regex.split(delimiter_regex);
    	for(String rg:aRegex){
    		regexRule.addPositive(rg);
    	}
    }
    /**
     * 添加正则过滤规则(一个都不能违反)
     *
     * @param regex 正则过滤规则
     */
    public void addNRegexs(String regex,String delimiter_regex) {
    	String[]aRegex=regex.split(delimiter_regex);
    	for(String rg:aRegex){
    		regexRule.addNegative(rg);
    	}
    }
    /**
     * 返回是否为断点爬取模式
     * @return 是否为断点爬取模式
     */
    public boolean isResumable() {
        return resumable;
    }

    /**
     * 设置是否为断点爬取模式
     * @param resumable 是否为断点爬取模式
     */
    public void setResumable(boolean resumable) {
        this.resumable = resumable;
    }

    /**
     * 返回线程数
     * @return 线程数
     */
    public int getThreads() {
        return threads;
    }

    /**
     * 设置线程数
     * @param threads 线程数
     */
    public void setThreads(int threads) {
        this.threads = threads;
    }

    public RegexRule getRegexRule() {
        return regexRule;
    }

    public void setRegexRule(RegexRule regexRule) {
        this.regexRule = regexRule;
    }

    public HtmlDao getHD() {
  		return HD;
  	}

  	public void setHD(HtmlDao hD) {
  		HD = hD;
  	}

  	public HtmlBean getHB() {
  		return HB;
  	}

  	public void setHB(HtmlBean hB) {
  		HB = hB;
  	}

    

    /**
     * 返回种子URL列表
     * @return 种子URL列表
     */
    public ArrayList<String> getSeeds() {
        return seeds;
    }

    /**
     * 设置种子URL列表
     * @param seeds 种子URL列表
     */
    public void setSeeds(ArrayList<String> seeds) {
        this.seeds = seeds;
    }

}

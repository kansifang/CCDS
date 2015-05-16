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



import com.lmt.app.crawler.dao.HtmlBean;
import com.lmt.app.crawler.dao.HtmlDao;
import com.lmt.app.crawler.generator.DbUpdater;
import com.lmt.app.crawler.generator.FSDbUpdater;
import com.lmt.app.crawler.generator.FSGenerator;
import com.lmt.app.crawler.generator.FSInjector;
import com.lmt.app.crawler.generator.Generator;
import com.lmt.app.crawler.generator.Injector;
import com.lmt.app.crawler.generator.filter.IntervalFilter;
import com.lmt.app.crawler.generator.filter.URLRegexFilter;
import com.lmt.app.crawler.model.Page;
import com.lmt.app.crawler.output.FileSystemOutput;
import com.lmt.app.crawler.util.LogUtils;


/**
 * 鍩轰簬鏂囦欢绯荤粺鐨勫箍搴﹂亶鍘嗙埇铏� * @author hu
 */
public class BreadthCrawler extends CommonCrawler{
    private String crawlPath = "crawl";
    private String pageSavePath = "data";
    private String filterKey="";
	
    public String getFilterKey() {
		return filterKey;
	}

	public void setFilterKey(String filterKey) {
		this.filterKey = filterKey;
	}
    @Override
    public DbUpdater createDbUpdater() {
        return new FSDbUpdater(crawlPath);
    }
    @Override
    public Injector createInjector() {
        return new FSInjector(crawlPath);
    }
    
    @Override
    public Generator createGenerator() {
        Generator generator = new FSGenerator(crawlPath);
        generator=new URLRegexFilter(new IntervalFilter(generator), getRegexRule());
        return generator;
    }

    public String getCrawlPath() {
        return crawlPath;
    }

    /**
     * 爬取路径数据存储目录
     * 
     */
    public void setCrawlPath(String crawlPath) {
        this.crawlPath = crawlPath;
    }

	/**
     * 爬取的数据保存目录
     * @return 濡傛灉浣跨敤榛樿鐨剉isit锛屽瓨鍌ㄧ綉椤垫枃浠剁殑璺緞
     */
    @Deprecated
    public String getPageSavePath() {
        return pageSavePath;
    }
    @Deprecated
    public void setPageSavePath(String pageSavePath) {
        this.pageSavePath = pageSavePath;
    }
    //实现的一种保存网页的方式，不推荐
    @Override
    public void visit(Page page) {
        FileSystemOutput fsoutput = new FileSystemOutput(pageSavePath);
        LogUtils.getLogger().info("visit " + page.getUrl());
        fsoutput.output(page);
    }
/*
    public static void main(String[] args) throws Exception {

        String crawl_path = "/home/hu/data/crawl_hfut1";
        String root = "/home/hu/data/hfut1";
        //LogUtils.setLogger(LogUtils.createCommonLogger("hfut"));
        //Config.topN=100;
        BreadthCrawler crawler = new BreadthCrawler() {
            @Override
            public void visit(Page page) {
                System.out.println(page.getUrl() + " " + page.getResponse().getCode());
                System.out.println(page.getDoc().title());

            }
        };

        crawler.addSeed("http://news.hfut.edu.cn/");
        crawler.addRegex("http://news.hfut.edu.cn/.*");
        crawler.addRegex("-.*#.*");
        crawler.addRegex("-.*png.*");
        crawler.addRegex("-.*jpg.*");
        crawler.addRegex("-.*gif.*");
        crawler.addRegex("-.*js.*");
        crawler.addRegex("-.*css.*");

        //crawler.addRegex(".*");
        crawler.setRoot(root);
        crawler.setCrawlPath(crawl_path);

        crawler.setResumable(true);
        crawler.start(4);

    }
    */

}

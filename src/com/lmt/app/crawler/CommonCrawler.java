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

import java.net.Proxy;
import java.net.URL;

import com.lmt.app.crawler.fetcher.Fetcher;
import com.lmt.app.crawler.net.HttpRequest;
import com.lmt.app.crawler.net.Request;
import com.lmt.app.crawler.parser.HtmlParser;
import com.lmt.app.crawler.parser.Parser;
import com.lmt.app.crawler.util.CommonConnectionConfig;
import com.lmt.app.crawler.util.Config;
import com.lmt.app.crawler.util.ConnectionConfig;

/**
 * 一种常用的广度遍历爬虫
 * @author hu
 */
public abstract class CommonCrawler extends Crawler{
    private String cookie = null;
    private String useragent = "Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:26.0) Gecko/20100101 Firefox/26.0";

    private boolean isContentStored = true;
    private Proxy proxy = null;
    private ConnectionConfig conconfig = null;
    
    /**
     * 根据url生成Request(http请求)的方法，可以通过Override这个方法来自定义Request
     * @param url
     * @return 实现Request接口的对象
     * @throws Exception
     */
    @Override
    public Request createRequest(String url) throws Exception {
        HttpRequest request = new HttpRequest();
        URL _URL = new URL(url);
        request.setURL(_URL);
        request.setProxy(proxy);
        request.setConnectionConfig(conconfig);
        return request;
    }

    /**
     * 根据网页的url和contentType，来创建Parser(解析器)，可以通过Override这个方法来自定义Parser
     * @param url
     * @param contentType
     * @return 实现Parser接口的对象
     * @throws Exception
     */
    @Override
    public Parser createParser(String url, String contentType) throws Exception {
        if (contentType == null) {
            return null;
        }
        if (contentType.contains("text/html")) {
            HtmlParser parser=new HtmlParser(Config.topN);
            parser.setRegexRule(getRegexRule());
            return parser;
        }
        return null;
    }
    
    
    @Override
    public Fetcher createFetcher() {
        Fetcher fetcher = new Fetcher();
        fetcher.setNeedUpdateDb(true);
        fetcher.setIsContentStored(isContentStored);
        conconfig = new CommonConnectionConfig(useragent, cookie);
        fetcher.setThreads(getThreads());
        return fetcher;
    }
    
    /**
     * 返回User-Agent
     * @return User-Agent
     */
    public String getUseragent() {
        return useragent;
    }

    /**
     * 设置User-Agent
     * @param useragent
     */
    public void setUseragent(String useragent) {
        this.useragent = useragent;
    }
    
    /**
     * 返回http连接配置对象
     *
     * @return http连接配置对象
     */
    public ConnectionConfig getConconfig() {
        return conconfig;
    }

    /**
     * 设置http连接配置对象
     *
     * @param conconfig http连接配置对象
     */
    public void setConconfig(ConnectionConfig conconfig) {
        this.conconfig = conconfig;
    }
    
    /**
     * 返回是否存储网页/文件的内容
     * @return 是否存储网页/文件的内容
     */
    public boolean getIsContentStored() {
        return isContentStored;
    }

    /**
     * 设置是否存储网页／文件的内容
     * @param isContentStored 是否存储网页/文件的内容
     */
    public void setIsContentStored(boolean isContentStored) {
        this.isContentStored = isContentStored;
    }
    
     /**
     * 返回代理
     * @return 代理
     */
    public Proxy getProxy() {
        return proxy;
    }

    /**
     * 设置代理
     * @param proxy 代理
     */
    public void setProxy(Proxy proxy) {
        this.proxy = proxy;
    }
    
    /**
     * 返回Cookie
     * @return Cookie
     */
    public String getCookie() {
        return cookie;
    }

    /**
     * 设置http请求的cookie
     * @param cookie Cookie
     */
    public void setCookie(String cookie) {
        this.cookie = cookie;
    }
}

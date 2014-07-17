package com.lmt.app.crawler.link.bdb;

import com.lmt.app.crawler.dao.HtmlURL;

public interface Frontier {
	public HtmlURL getNext()throws Exception;
	public boolean putUrl(HtmlURL url) throws Exception;
	//public boolean visited(CrawlUrl url);
}
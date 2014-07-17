package com.lmt.app.crawler.link;
public interface LinkFilter {
	public boolean accept(String url);
}
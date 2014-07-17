package com.lmt.app.crawler.link.analyze;

import com.lmt.app.crawler.dao.HtmlBean;

public  interface  ComputeUrl  {
	public  boolean  accept(String  url,HtmlBean pageContent,HITS hits) ;
}


package com.lmt.app.crawler.link.analyze;

import com.lmt.app.crawler.dao.HtmlBean;

public class PageRankComputeUrl implements ComputeUrl {
	public boolean accept(String url, HtmlBean pageContent,HITS hits) {
		String sContent=pageContent.getContent();
		if(sContent!=null &&sContent.matches("[财经|GDP|李克强|习近平|.]*")&&url.matches(".s?html")){
			double score=hits.authorityScore(url);
			if(score>0.1){
				return true;
			}
		}
		return false;
	}

}

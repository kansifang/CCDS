package com.lmt.app.crawler.link.analyze;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.lmt.app.crawler.dao.HtmlBean;

public class PageRankComputeUrl implements ComputeUrl {
	public boolean accept(String url, HtmlBean pageContent,HITS hits) {
		String sContent=pageContent.getContent();
		if(sContent!=null &&url.matches(".*s?html")){
			Pattern pattern = Pattern.compile(".*(�ƾ�|GDP|CPI|���ǿ|ϰ��ƽ|����|ɽ��|����|����|˰��|Ͷ��)+.*",Pattern.CASE_INSENSITIVE);
			Matcher matcher = pattern.matcher(sContent);
			if (matcher.find()) {
				double score=hits.authorityScore(url);
				if(score>0.1){
					return true;
				}
			}
		}
		return false;
	}

}

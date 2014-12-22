package com.lmt.app.crawler.link.analyze;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.lmt.app.crawler.dao.HtmlBean;

public class PageRankComputeUrl implements ComputeUrl {
	public final static String topic="�ƾ�|GDP|CPI|PPI|���ǿ|ϰ��ƽ|����|ɽ��|����|����|˰��|Ͷ��|����|���|A��|С��|P2P|����������";
	public boolean accept(String url, HtmlBean pageContent) {
		String sContent=pageContent.getContent();
		if(sContent!=null &&url.matches(".*s?html")){
			Pattern pattern = Pattern.compile(topic,Pattern.CASE_INSENSITIVE);
			Matcher matcher = pattern.matcher(sContent);
			if (matcher.find()) {
				return true;
			}
		}
		return false;
	}

}

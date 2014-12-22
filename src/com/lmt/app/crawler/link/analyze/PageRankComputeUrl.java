package com.lmt.app.crawler.link.analyze;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.lmt.app.crawler.dao.HtmlBean;

public class PageRankComputeUrl implements ComputeUrl {
	public final static String topic="财经|GDP|CPI|PPI|李克强|习近平|政策|山西|银行|金融|税收|投资|信托|理财|A股|小康|P2P|互联网金融";
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

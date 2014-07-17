package com.lmt.app.crawler.link;



import java.util.HashSet;
import java.util.Set;

import org.htmlparser.Node;
import org.htmlparser.NodeFilter;
import org.htmlparser.Parser;
import org.htmlparser.filters.NodeClassFilter;
import org.htmlparser.filters.OrFilter;
import org.htmlparser.tags.LinkTag;
import org.htmlparser.util.NodeList;
import org.htmlparser.util.ParserException;

public class ExtractLink {
	// 获取一个网站上的链接,filter 用来过滤链接
	public static Set<String> parse(Parser parser,LinkFilter linkSelffilter) {
		Set<String> links = new HashSet<String>();
		try{
			// 过滤 <frame >标签的 filter，用来提取 frame 标签里的 src 属性所表示的链接
			NodeFilter frameFilter = new NodeFilter() {
				public boolean accept(Node node) {
					if (node.getText().startsWith("frame src=")){
						return true;
					} else {
						return false;
					}
				}
			};
			// OrFilter 来设置过滤 <a> 标签，和 <frame> 标签
			OrFilter linkTagFilter = new OrFilter(new NodeClassFilter(LinkTag.class), frameFilter);
			// 得到所有经过过滤的标签
			NodeList list = parser.extractAllNodesThatMatch(linkTagFilter);
			for (int i = 0; i < list.size(); i++) {
				Node tag = list.elementAt(i);
				if (tag instanceof LinkTag)// <a> 标签
				{
					LinkTag link = (LinkTag) tag;
					String linkUrl = link.getLink();// url
					if (linkSelffilter.accept(linkUrl))
						links.add(linkUrl);
				}else{// <frame> 标签
					// 提取 frame 里 src 属性的链接如 <frame src="test.html"/>
					String frame = tag.getText();
					int start = frame.indexOf("src=");
					frame = frame.substring(start);
					int end = frame.indexOf(" ");
					if (end == -1)
						end = frame.indexOf(">");
					String frameUrl = frame.substring(5, end - 1);//5是因为排除掉 src="
					if (linkSelffilter.accept(frameUrl))
						links.add(frameUrl);
				}
			}
		} catch (ParserException e) {
			e.printStackTrace();
		}
		return links;
	}
}

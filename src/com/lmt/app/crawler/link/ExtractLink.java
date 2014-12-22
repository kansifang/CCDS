package com.lmt.app.crawler.link;

import org.htmlparser.Node;
import org.htmlparser.NodeFilter;
import org.htmlparser.Parser;
import org.htmlparser.filters.AndFilter;
import org.htmlparser.filters.LinkRegexFilter;
import org.htmlparser.filters.OrFilter;
import org.htmlparser.tags.LinkTag;
import org.htmlparser.util.NodeList;
import org.htmlparser.util.ParserException;

import com.lmt.app.crawler.link.analyze.PageRankComputeUrl;
import com.lmt.app.crawler.link.analyze.WebGraphMemory;
public class ExtractLink {
	// 获取一个网站上的链接,filter 用来过滤链接
	public static void parse(Parser parser,WebGraphMemory wg) throws ParserException {
		//1、过滤 <frame >标签的 filter，用来提取 frame 标签里的 src 属性所表示的链接
		NodeFilter frameFilter = new NodeFilter() {
			private static final long serialVersionUID = 1L;
			public boolean accept(Node node) {
				String nodeText=node.getText();
				if (nodeText.startsWith("frame src=")
						&&nodeText.toLowerCase().matches("^([a-zA-z]+://)?([\\w-]+\\.)+[\\w-]+(/[\\w- ./%&=]*)?$")
						&&nodeText.toLowerCase().matches("^(?!.*?app)(?!.*?search)(?!.*?tool).*$")){//后面可以一直写过滤条件
					return true;
				} else {
					return false;
				}
			}
		};
		//2、LinkTag过滤条件 <a>等
		LinkRegexFilter LF=new LinkRegexFilter("^([a-zA-z]+://)?([\\w-]+\\.)+[\\w-]+(/[\\w- ./%&=]*)?$",false);
		LinkRegexFilter RF=new LinkRegexFilter("^(?!.*?app)(?!.*?search)(?!.*?tool).*$",false);
		NodeFilter LinkTagFilter = new AndFilter(LF,RF);
		//3、过滤时间 这个Z针对的是 Text
		//RegexFilter rf=new RegexFilter("[0-9]{4}[年\\-/ ][0-9]{1,2}[月\\-/ ][0-9]{1,2}日?\\s*[012]{1}[0-9]{1}:[0-6]{1}[0-9]{1}");
		//NodeFilter filter = new TagNameFilter("A");  
		NodeFilter[]filters=new NodeFilter[]{frameFilter,LinkTagFilter};
		OrFilter orFilter = new OrFilter(filters);
		// 得到所有经过过滤的标签 之所以要过滤条件是为了减少下面的循环次数
		NodeList list = parser.extractAllNodesThatMatch(orFilter);
		for (int i = 0; i < list.size(); i++) {
			String linkUrl=null;
			Node tag = list.elementAt(i);
			if (tag instanceof LinkTag){// <a> 标签
				LinkTag link = (LinkTag) tag;
				String topic=link.getLinkText();
				if(topic.matches("^.*("+PageRankComputeUrl.topic+")+.*$")){
					linkUrl = link.getLink();// url
				}
			}else{// <frame> 标签
				// 提取 frame 里 src 属性的链接如 <frame src="test.html"/>
				String frame = tag.getText();
				int start = frame.indexOf("src=");
				frame = frame.substring(start);
				int end = frame.indexOf(" ");
				if (end == -1)
					end = frame.indexOf(">");
				if(end!=-1){
					linkUrl = frame.substring(5, end - 1);//5是因为排除掉 src="
				}
			}
			if (linkUrl!=null)
				wg.addLink(parser.getURL(),linkUrl,1.0);
		}
	}
}
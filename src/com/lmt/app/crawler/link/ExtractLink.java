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
	// ��ȡһ����վ�ϵ�����,filter ������������
	public static Set<String> parse(Parser parser,LinkFilter linkSelffilter) {
		Set<String> links = new HashSet<String>();
		try{
			// ���� <frame >��ǩ�� filter��������ȡ frame ��ǩ��� src ��������ʾ������
			NodeFilter frameFilter = new NodeFilter() {
				public boolean accept(Node node) {
					if (node.getText().startsWith("frame src=")){
						return true;
					} else {
						return false;
					}
				}
			};
			// OrFilter �����ù��� <a> ��ǩ���� <frame> ��ǩ
			OrFilter linkTagFilter = new OrFilter(new NodeClassFilter(LinkTag.class), frameFilter);
			// �õ����о������˵ı�ǩ
			NodeList list = parser.extractAllNodesThatMatch(linkTagFilter);
			for (int i = 0; i < list.size(); i++) {
				Node tag = list.elementAt(i);
				if (tag instanceof LinkTag)// <a> ��ǩ
				{
					LinkTag link = (LinkTag) tag;
					String linkUrl = link.getLink();// url
					if (linkSelffilter.accept(linkUrl))
						links.add(linkUrl);
				}else{// <frame> ��ǩ
					// ��ȡ frame �� src ���Ե������� <frame src="test.html"/>
					String frame = tag.getText();
					int start = frame.indexOf("src=");
					frame = frame.substring(start);
					int end = frame.indexOf(" ");
					if (end == -1)
						end = frame.indexOf(">");
					String frameUrl = frame.substring(5, end - 1);//5����Ϊ�ų��� src="
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

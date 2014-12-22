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
	// ��ȡһ����վ�ϵ�����,filter ������������
	public static void parse(Parser parser,WebGraphMemory wg) throws ParserException {
		//1������ <frame >��ǩ�� filter��������ȡ frame ��ǩ��� src ��������ʾ������
		NodeFilter frameFilter = new NodeFilter() {
			private static final long serialVersionUID = 1L;
			public boolean accept(Node node) {
				String nodeText=node.getText();
				if (nodeText.startsWith("frame src=")
						&&nodeText.toLowerCase().matches("^([a-zA-z]+://)?([\\w-]+\\.)+[\\w-]+(/[\\w- ./%&=]*)?$")
						&&nodeText.toLowerCase().matches("^(?!.*?app)(?!.*?search)(?!.*?tool).*$")){//�������һֱд��������
					return true;
				} else {
					return false;
				}
			}
		};
		//2��LinkTag�������� <a>��
		LinkRegexFilter LF=new LinkRegexFilter("^([a-zA-z]+://)?([\\w-]+\\.)+[\\w-]+(/[\\w- ./%&=]*)?$",false);
		LinkRegexFilter RF=new LinkRegexFilter("^(?!.*?app)(?!.*?search)(?!.*?tool).*$",false);
		NodeFilter LinkTagFilter = new AndFilter(LF,RF);
		//3������ʱ�� ���Z��Ե��� Text
		//RegexFilter rf=new RegexFilter("[0-9]{4}[��\\-/ ][0-9]{1,2}[��\\-/ ][0-9]{1,2}��?\\s*[012]{1}[0-9]{1}:[0-6]{1}[0-9]{1}");
		//NodeFilter filter = new TagNameFilter("A");  
		NodeFilter[]filters=new NodeFilter[]{frameFilter,LinkTagFilter};
		OrFilter orFilter = new OrFilter(filters);
		// �õ����о������˵ı�ǩ ֮����Ҫ����������Ϊ�˼��������ѭ������
		NodeList list = parser.extractAllNodesThatMatch(orFilter);
		for (int i = 0; i < list.size(); i++) {
			String linkUrl=null;
			Node tag = list.elementAt(i);
			if (tag instanceof LinkTag){// <a> ��ǩ
				LinkTag link = (LinkTag) tag;
				String topic=link.getLinkText();
				if(topic.matches("^.*("+PageRankComputeUrl.topic+")+.*$")){
					linkUrl = link.getLink();// url
				}
			}else{// <frame> ��ǩ
				// ��ȡ frame �� src ���Ե������� <frame src="test.html"/>
				String frame = tag.getText();
				int start = frame.indexOf("src=");
				frame = frame.substring(start);
				int end = frame.indexOf(" ");
				if (end == -1)
					end = frame.indexOf(">");
				if(end!=-1){
					linkUrl = frame.substring(5, end - 1);//5����Ϊ�ų��� src="
				}
			}
			if (linkUrl!=null)
				wg.addLink(parser.getURL(),linkUrl,1.0);
		}
	}
}
package com.lmt.app.crawler;


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;
import org.htmlparser.Node;
import org.htmlparser.Parser;
import org.htmlparser.nodes.TagNode;
import org.htmlparser.nodes.TextNode;
import org.htmlparser.tags.Div;
import org.htmlparser.tags.Html;
import org.htmlparser.tags.ImageTag;
import org.htmlparser.tags.LinkTag;
import org.htmlparser.tags.ParagraphTag;
import org.htmlparser.tags.ScriptTag;
import org.htmlparser.tags.SelectTag;
import org.htmlparser.tags.Span;
import org.htmlparser.tags.StyleTag;
import org.htmlparser.tags.TableColumn;
import org.htmlparser.tags.TableHeader;
import org.htmlparser.tags.TableRow;
import org.htmlparser.tags.TableTag;
import org.htmlparser.tags.TitleTag;
import org.htmlparser.util.NodeIterator;
import org.htmlparser.util.NodeList;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

//正文抽取主程序
public class ExtractContext {
	protected static final String lineSign = System.getProperty("line.separator");
	protected static final int lineSign_size = lineSign.length();
	private Transaction Sqlca=null;

	/** 定义系统上下文* */
	//public static final ApplicationContext context = new ClassPathXmlApplicationContext(new String[] { "newwatch/persistence.xml", "newwatch/biz-util.xml","newwatch/biz-dao.xml" });

	/**
	 * @param args
	 */
	public ExtractContext(){
	}
	public ExtractContext(Transaction Sqlca){
		this.Sqlca=Sqlca;
	}
	public static void main(String[] args) {
		ExtractContext console = new ExtractContext();
		ChannelLinkDO c = new ChannelLinkDO();
		c.setEncode("utf-8");//
		//c.setLink("http://blog.csdn.net/chl033/article/details/2731471");
		//String link=
		c.setLink("http://shanxi.sina.com.cn/news/report/2014-07-04/075162229.html");
		c.setLinktext("test");
		console.makeContext(c);
	}

	/**
	 * 收集HTML页面信息
	 * 
	 * @param url
	 * @param urlEncode
	 */
	public void makeContext(ChannelLinkDO c) {
		try {
			String siteUrl = getLinkUrl(c.getLink());
			Parser parser = new Parser(c.getLink());
			parser.setEncoding(c.getEncode());
			for (NodeIterator e = parser.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				if (node instanceof Html) {
					PageContext context = new PageContext();
					context.setNumber(0);
					context.setTextBuffer(new StringBuffer());
					// 抓取出内容
					extractHtml(node, context, siteUrl);
					StringBuffer testContext = context.getTextBuffer();
					BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(srcfilePath),"gbk"));
					BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(destfilePath),"gbk"));
					String lineContext = testContext.toString();
					//从内存中取出代码缓冲池（不使用SQL去查询，提高页面效率）
					//ASValuePool vpCode = CurConfig.getSysConfig(ASConfigure.SYSCONFIG_CODE,Sqlca);
					//取出代码对象
					//ASCodeDefinition codeDef = (ASCodeDefinition)vpCode.getAttribute("HtmlDisplayContent");
					//int taskNum = codeDef.items.size();
					ASResultSet rs=Sqlca.getASResultSet("select ItemDescribe from Code_Library where CodeNo='HtmlDisplayContent' and IsInUse='1'");
					while(rs.next()){
						//String ItemNo=	rs.getString(1);	
						String htmlcode=rs.getString("ItemDescribe");	
						String temp = StringUtils.replace(htmlcode,"#title", context.getTitle());
						temp = StringUtils.replace(temp, "#sourcelink",c.getLink());
						temp = StringUtils.replace(temp, "#reporttime",context.getTime());
						temp = StringUtils.replace(temp, "#time",StringFunction.getTodayNow());
						writer.write(temp + lineSign);
						writer.write(lineContext + lineSign);
					}
					rs.getStatement().close();
					writer.flush();
					writer.close();
				}
			}
		} catch (Exception e) {
			System.out.println(e);
		}
	}
	// 从一个字符串中提取出链接
	private String getLinkUrl(String link) {
		String urlDomaiPattern = "(http://[^/]*?" + "/)(.*?)";
		Pattern pattern = Pattern.compile(urlDomaiPattern,Pattern.CASE_INSENSITIVE + Pattern.DOTALL);
		Matcher matcher = pattern.matcher(link);
		String url = "";
		while (matcher.find()) {
			int start = matcher.start(1);
			int end = matcher.end(1);
			url = link.substring(start, end - 1).trim();
		}
		return url;
	}

	/**
	 * 递归钻取正文信息
	 * 
	 * @param nodeP
	 * @return
	 */
	protected List extractHtml(Node nodeP, PageContext context, String siteUrl)
			throws Exception {
		NodeList nodeList = nodeP.getChildren();
		boolean bl = false;
		if ((nodeList == null) || (nodeList.size() == 0)) {
			if (nodeP instanceof ParagraphTag) {
				ArrayList tableList = new ArrayList();
				StringBuffer temp = new StringBuffer();
				temp.append("<p style=\"TEXT-INDENT: 2em\">");
				tableList.add(temp);
				temp = new StringBuffer();
				temp.append("</p>").append(lineSign);
				tableList.add(temp);
				return tableList;
			}
			return null;
		}
		if ((nodeP instanceof TableTag) || (nodeP instanceof Div)) {
			bl = true;
		}
		//P 在<html <table <div 都有可能有这个标签 ,这个事内容提取的主要部分
		if (nodeP instanceof ParagraphTag) {
			ArrayList tableList = new ArrayList();
			StringBuffer temp = new StringBuffer();
			temp.append("<p style=\"TEXT-INDENT: 2em\">");
			tableList.add(temp);
			extractParagraph(nodeP, context,siteUrl, tableList);
			temp = new StringBuffer();
			temp.append("</p>").append(lineSign);
			tableList.add(temp);
			return tableList;
		//提取网页Title
		}else if (nodeP instanceof TitleTag) {
			String title=((TitleTag) nodeP).getChildrenHTML().toString().split("[|\\-_]")[0];
			context.setTitle(title);
		//有的网页 <span 在 <p中 有的则不在
		}else if (nodeP instanceof Span){
			StringBuffer spanWord = new StringBuffer();
			getSpanWord(nodeP, spanWord);
			if ((spanWord != null) && (spanWord.length() > 0)) {
				String text = collapse(spanWord.toString().replaceAll("&nbsp;", "").replaceAll("　", ""));
				StringBuffer temp = new StringBuffer();
				//设置时间戳
				if(context.getTime()==null){
					Pattern p = Pattern.compile("[0-9]{4}[年|\\-|/][0-9]{1,2}[月|\\-|/][0-9]{1,2}日?\\s*[012]{1}[0-9]{1}:[0-6]{1}[0-9]{1}");
					Matcher m = p.matcher(text);		
					if(m.find()) {
						if (!"".equals(m.group())) {
							String time = m.group();	
							time = time.replaceAll("年", "/");	
							time = time.replaceAll("月", "/");	
							time = time.replaceAll("日", " ");
							time = time.replaceAll("-", "/");	
							System.out.println(time);	
							context.setTime(time);
						}
					}
				}
			}
		}
		ArrayList tableList = new ArrayList();
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				if (node instanceof LinkTag) {
					tableList.add(node);
					setLinkImg(node, siteUrl);
				} else if (node instanceof ImageTag) {
					ImageTag img = (ImageTag) node;
					if (img.getImageURL().toLowerCase().indexOf("http://") < 0) {
						img.setImageURL(siteUrl + img.getImageURL());
					} else {
						img.setImageURL(img.getImageURL());
					}
					tableList.add(node);
				}else if (node instanceof ScriptTag|| node instanceof StyleTag|| node instanceof SelectTag) {
					
				} else if (node instanceof TextNode) {
					if (node.getText().length() > 0) {
						StringBuffer temp = new StringBuffer();
						String text = collapse(node.getText().replaceAll("&nbsp;", "").replaceAll("　", ""));
						temp.append(text.trim());
						tableList.add(temp);
					}
				} else {
					if (node instanceof TableTag || node instanceof Div) {
						TableValid tableValid = new TableValid();
						isValidTable(node, tableValid);
						if (tableValid.getTrnum() > 2) {
							tableList.add(node);
							continue;
						}
					}
					List tempList = extractHtml(node, context, siteUrl);
					if ((tempList != null) && (tempList.size() > 0)) {
						Iterator ti = tempList.iterator();
						while (ti.hasNext()) {
							tableList.add(ti.next());
						}
					}
				}
			}
		} catch (Exception e) {
			return null;
		}
		if ((tableList != null) && (tableList.size() > 0)) {
			if (bl){
				StringBuffer temp = new StringBuffer();
				Iterator ti = tableList.iterator();
				int wordSize = 0;
				StringBuffer node;
				int status = 0;
				StringBuffer lineStart = new StringBuffer("<p style=\"TEXT-INDENT: 2em\">");
				StringBuffer lineEnd = new StringBuffer("</p>" + lineSign);
				while (ti.hasNext()) {
					Object k = ti.next();
					if (k instanceof LinkTag) {
						if (status == 0) {
							temp.append(lineStart);
							status = 1;
						}
						node = new StringBuffer(((LinkTag) k).toHtml());
						temp.append(node);
					} else if (k instanceof ImageTag) {
						if (status == 0) {
							temp.append(lineStart);
							status = 1;
						}
						node = new StringBuffer(((ImageTag) k).toHtml());
						temp.append(node);
					} else if (k instanceof TableTag) {
						if (status == 0) {
							temp.append(lineStart);
							status = 1;
						}
						node = new StringBuffer(((TableTag) k).toHtml());
						temp.append(node);
					} else if (k instanceof Div) {
						if (status == 0) {
							temp.append(lineStart);
							status = 1;
						}
						node = new StringBuffer(((Div) k).toHtml());
						temp.append(node);
					} else {
						node = (StringBuffer) k;
						if (status == 0) {
							if (node.indexOf("<p") < 0) {
								temp.append(lineStart);
								temp.append(node);
								wordSize = wordSize + node.length();
								status = 1;
							} else {
								temp.append(node);
								status = 1;
							}
						} else if (status == 1) {
							if (node.indexOf("</p") < 0) {
								if (node.indexOf("<p") < 0) {
									temp.append(node);
									wordSize = wordSize + node.length();
								} else {
									temp.append(lineEnd);
									temp.append(node);
									status = 1;
								}
							} else {
								temp.append(node);
								status = 0;
							}
						}
					}
				}
				if (status == 1) {
					temp.append(lineEnd);
				}
				if (wordSize > context.getNumber()) {
					context.setNumber(wordSize);
					context.setTextBuffer(temp);
				}
				return null;
			} else {
				return tableList;
			}
		}
		return null;
	}

	/**
	 * 设置图象连接
	 * 
	 * @param nodeP
	 * @param siteUrl
	 */
	private void setLinkImg(Node nodeP, String siteUrl) {
		NodeList nodeList = nodeP.getChildren();
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				if (node instanceof ImageTag) {
					ImageTag img = (ImageTag) node;
					if (img.getImageURL().toLowerCase().indexOf("http://") < 0) {
						img.setImageURL(siteUrl + img.getImageURL());
					} else {
						img.setImageURL(img.getImageURL());
					}
				}
			}
		} catch (Exception e) {
			return;
		}
		return;
	}

	/**
	 * 钻取段落中的内容
	 * 
	 * @param nodeP
	 * @param siteUrl
	 * @param tableList
	 * @return
	 */
	private List extractParagraph(Node nodeP, PageContext context, String siteUrl, List tableList) {
		NodeList nodeList = nodeP.getChildren();
		if ((nodeList == null) || (nodeList.size() == 0)) {
			if (nodeP instanceof ParagraphTag) {
				StringBuffer temp = new StringBuffer();
				temp.append("<p style=\"TEXT-INDENT: 2em\">");
				tableList.add(temp);
				temp = new StringBuffer();
				temp.append("</p>").append(lineSign);
				tableList.add(temp);
				return tableList;
			}
			return null;
		}
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				if (node instanceof ScriptTag || node instanceof StyleTag|| node instanceof SelectTag){
					
				} else if (node instanceof LinkTag) {
					tableList.add(node);
					setLinkImg(node, siteUrl);
				} else if(node instanceof ImageTag) {
					ImageTag img = (ImageTag) node;
					if (img.getImageURL().toLowerCase().indexOf("http://") < 0) {
						img.setImageURL(siteUrl + img.getImageURL());
					} else {
						img.setImageURL(img.getImageURL());
					}
					tableList.add(node);
				} else if(node instanceof TextNode) {
					if (node.getText().trim().length() > 0) {
						String text = collapse(node.getText().replaceAll("&nbsp;","").replaceAll("　", ""));
						StringBuffer temp = new StringBuffer();
						temp.append(text);
						tableList.add(temp);
					}
				} else if (node instanceof Span) {//有的网页 <span 在 <p中 有的则不在
					StringBuffer spanWord = new StringBuffer();
					getSpanWord(node, spanWord);
					if ((spanWord != null) && (spanWord.length() > 0)) {
						String text = collapse(spanWord.toString().replaceAll("&nbsp;", "").replaceAll("　", ""));
						StringBuffer temp = new StringBuffer();
						temp.append(text);
						tableList.add(temp);
						//设置时间戳
						if(context.getTime()==null){
							Pattern p = Pattern.compile("[0-9]{4}[年|\\-|/][0-9]{1,2}[月|\\-|/][0-9]{1,2}日?\\s*[012]{1}[0-9]{1}:[0-6]{1}[0-9]{1}");
							Matcher m = p.matcher(text);		
							if(m.find()) {
								if (!"".equals(m.group())) {
									String time = m.group();	
									time = time.replaceAll("年", "/");	
									time = time.replaceAll("月", "/");
									time = time.replaceAll("日", " ");
									time = time.replaceAll("-", "/");	
									System.out.println(time);	
									context.setTime(time);
								}
							}
						}
					}
				} else if (node instanceof TagNode) {
					String tag = node.toHtml();
					if (tag.length() <= 10) {
						tag = tag.toLowerCase();
						if ((tag.indexOf("strong") >= 0)|| (tag.indexOf("b") >= 0)) {
							StringBuffer temp = new StringBuffer();
							temp.append(tag);
							tableList.add(temp);
						}
					} else {
						if (node instanceof TableTag || node instanceof Div) {
							TableValid tableValid = new TableValid();
							isValidTable(node, tableValid);
							if (tableValid.getTrnum() > 2) {
								tableList.add(node);
								continue;
							}
						}
						extractParagraph(node, context,siteUrl, tableList);
					}
				}
			}
		} catch (Exception e) {
			return null;
		}
		return tableList;
	}

	protected void getSpanWord(Node nodeP, StringBuffer spanWord) {
		NodeList nodeList = nodeP.getChildren();
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				if (node instanceof ScriptTag || node instanceof StyleTag|| node instanceof SelectTag) {
				
				} else if (node instanceof TextNode) {
					spanWord.append(node.getText());
				} else if (node instanceof Span) {
					getSpanWord(node, spanWord);
				} else if (node instanceof ParagraphTag) {
					getSpanWord(node, spanWord);
				} else if (node instanceof TagNode) {
					String tag = node.toHtml().toLowerCase();
					if (tag.length() <= 10) {
						if ((tag.indexOf("strong") >= 0)|| (tag.indexOf("b") >= 0)) {
							spanWord.append(tag);
						}
					}
				}
			}
		} catch (Exception e) {
		}
		return;
	}

	/**
	 * 判断TABLE是否是表单
	 * 
	 * @param nodeP
	 * @return
	 */
	private void isValidTable(Node nodeP, TableValid tableValid) {
		NodeList nodeList = nodeP.getChildren();
		/** 如果该表单没有子节点则返回* */
		if ((nodeList == null) || (nodeList.size() == 0)) {
			return;
		}
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				/** 如果子节点本身也是表单则返回* */
				if (node instanceof TableTag || node instanceof Div) {
					return;
				} else if (node instanceof ScriptTag||node instanceof StyleTag||node instanceof SelectTag) {
					return;
				} else if (node instanceof TableColumn) {
					return;
				} else if (node instanceof TableRow) {
					TableColumnValid tcValid = new TableColumnValid();
					tcValid.setValid(true);
					findTD(node, tcValid);//
					if (tcValid.isValid()) {
						if (tcValid.getTdNum() < 2) {
							if (tableValid.getTdnum() > 0) {
								return;
							} else {
								continue;
							}
						} else {
							if (tableValid.getTdnum() == 0) {
								tableValid.setTdnum(tcValid.getTdNum());
								tableValid.setTrnum(tableValid.getTrnum() + 1);
							} else {
								if (tableValid.getTdnum() == tcValid.getTdNum()) {
									tableValid.setTrnum(tableValid.getTrnum() + 1);
								} else {
									return;
								}
							}
						}
					}
				} else {
					isValidTable(node, tableValid);
				}
			}
		} catch (Exception e) {
			return;
		}
		return;
	}
	/**
	 * 判断是否有效TR
	 *寻找一个TR内的td数
	 * @param nodeP
	 * @param TcValid
	 * @return
	 */
	private void findTD(Node nodeP, TableColumnValid tcValid) {
		NodeList nodeList = nodeP.getChildren();
		/** 如果该表单没有子节点则返回* */
		if ((nodeList == null) || (nodeList.size() == 0)) {
			return;
		}
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				/** 如果有嵌套表单* */
				if (node instanceof TableTag || node instanceof Div
						|| node instanceof TableRow
						|| node instanceof TableHeader) {
					tcValid.setValid(false);
					return;
				} else if (node instanceof ScriptTag
						|| node instanceof StyleTag
						|| node instanceof SelectTag) {
					tcValid.setValid(false);
					return;
				} else if (node instanceof TableColumn) {
					tcValid.setTdNum(tcValid.getTdNum() + 1);
				} else {
					findTD(node, tcValid);
				}
			}
		} catch (Exception e) {
			tcValid.setValid(false);
			return;
		}
		return;
	}

	protected String collapse(String string) {
		int chars;
		int length;
		int state;
		char character;
		StringBuffer buffer = new StringBuffer();
		chars = string.length();
		if (0 != chars) {
			length = buffer.length();
			state = ((0 == length) || (buffer.charAt(length - 1) == ' ') || ((lineSign_size <= length) && buffer
					.substring(length - lineSign_size, length).equals(lineSign))) ? 0
					: 1;
			for (int i = 0; i < chars; i++) {
				character = string.charAt(i);
				switch (character) {
				case '\u0020':
				case '\u0009':
				case '\u000C':
				case '\u200B':
				case '\u00a0':
				case '\r':
				case '\n':
					if (0 != state) {
						state = 1;
					}
					break;
				default:
					if (1 == state) {
						buffer.append(' ');
					}
					state = 2;
					buffer.append(character);
				}
			}
		}
		return buffer.toString();
	}
}

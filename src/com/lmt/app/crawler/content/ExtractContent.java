package com.lmt.app.crawler.content;


import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.htmlparser.Node;
import org.htmlparser.NodeFilter;
import org.htmlparser.Parser;
import org.htmlparser.beans.StringBean;
import org.htmlparser.filters.NodeClassFilter;
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
import org.htmlparser.util.ParserException;

import com.lmt.app.crawler.dao.HtmlBean;

//���ĳ�ȡ������
public class ExtractContent{
	protected static final String lineSign = System.getProperty("line.separator");
	protected static final int lineSign_size = lineSign.length();
    private Parser parser = null;   //���ڷ�����ҳ�ķ�������
    private HtmlBean bean = new HtmlBean();
    public ExtractContent(){
    }
    public ExtractContent(Parser parser){
		this.parser = parser;
		this.bean.setURL(this.parser.getURL());
    	this.parse();
    }
	/**
	 * �ռ�HTMLҳ����Ϣ
	 * 
	 * @param url
	 * @param urlEncode
	 */
	public void parse(){
		try {
			parser.reset();
			for (NodeIterator e = parser.elements(); e.hasMoreNodes();){
				Node node = (Node) e.nextNode();
				if (node instanceof Html) {
					// ץȡ������
					extractHtml(node, bean);
					break;//�˴�Ӧ����������Ϊһ��ҳ��ֻ��һ��<html>�ڵ㲻����
				}
			}
		} catch (Exception e) {
			System.out.println(e);
		}
	}
	/**���ݹ��д��һ��ԭ���ǣ�������ÿһ�����Ǵ�����Ǹ��ײ��һ��ѭ���ڵĺ��Ӳ㣬��Զ�������ģ�ѭ������Ȼ������return��
	 * �ݹ���ȡ������Ϣ
	 * 
	 * @param nodeP
	 * @return
	 */
	private List extractHtml(Node nodeP, HtmlBean newsbean)throws Exception {
		NodeList nodeList = nodeP.getChildren();
		boolean bl = false;
		//�Ƿ����Ǹ��ײ�
		if ((nodeList == null) || (nodeList.size() == 0)) {
			if (nodeP instanceof ParagraphTag) {
				ArrayList textList = new ArrayList();
				StringBuffer temp = new StringBuffer();
				temp.append("<p style='TEXT-INDENT: 2em'>");
				textList.add(temp);
				
				temp = new StringBuffer();
				temp.append("</p>").append(lineSign);
				textList.add(temp);
				return textList;
			}
			return null;
		}
		//��<html <table <div ���п�����P�����ǩ ,�����������ȡ����Ҫ����
		//�����������ҳ��Ҫ����<p></p>���Ǵ�����¼�----�κ��ж�����ǰ������
		if (nodeP instanceof ParagraphTag) {
				ArrayList textList = new ArrayList();
				StringBuffer temp = new StringBuffer();
				temp.append("<p style='TEXT-INDENT: 2em'>");
				textList.add(temp);
				
				extractParagraph(nodeP, newsbean, textList);
				
				temp = new StringBuffer();
				temp.append("</p>").append(lineSign);
				textList.add(temp);
				return textList;
		}
		//���ײ��������������ݽ�ʱ�����������Ҫ���⴦��ģ�
		if ((nodeP instanceof TableTag) || (nodeP instanceof Div)) {
			bl = true;
		}
		ArrayList textList = new ArrayList();
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();){
				Node node = (Node) e.nextNode();
				//��ȡ��ҳTitle
				if (nodeP instanceof TitleTag){
					String title=((TitleTag) nodeP).getChildrenHTML().toString().split("[|\\-_]")[0];
					newsbean.setTitle(title);
				}
				//�е���ҳ <span �� <p <div�� �е�����
				else if(nodeP instanceof Div||nodeP instanceof Span){
					StringBuffer spanWord = new StringBuffer();
					extractSpanDivInPWord(nodeP, spanWord);
					if ((spanWord != null) && (spanWord.length() > 0)) {
						String text = collapse(spanWord.toString().replaceAll("&nbsp;", "").replaceAll("��", ""));
						//����ʱ���
						if(newsbean.getLastUpdateTime()==null){
							Pattern p = Pattern.compile("[0-9]{4}[��|\\-|/][0-9]{1,2}[��|\\-|/][0-9]{1,2}��?\\s*[012]{1}[0-9]{1}:[0-6]{1}[0-9]{1}");
							Matcher m = p.matcher(text);		
							if(m.find()) {
								if (!"".equals(m.group())) {
									String time = m.group();	
									time = time.replaceAll("��", "/");	
									time = time.replaceAll("��", "/");	
									time = time.replaceAll("��", " ");
									time = time.replaceAll("-", "/");	
									newsbean.setLastUpdateTime(time);
								}
							}
						}
					}
				}else if (node instanceof LinkTag) {
					textList.add(node);
					setLinkImg(node, this.parser.getURL());
				} else if (node instanceof ImageTag) {
					ImageTag img = (ImageTag) node;
					if (img.getImageURL().toLowerCase().indexOf("http://") < 0) {
						img.setImageURL(this.parser.getURL()+ img.getImageURL());
					} else {
						img.setImageURL(img.getImageURL());
					}
					textList.add(node);
				}else if (node instanceof ScriptTag|| node instanceof StyleTag|| node instanceof SelectTag) {
					
				} else if (node instanceof TextNode) {
					if (node.getText().length() > 0) {
						StringBuffer temp = new StringBuffer();
						String text = collapse(node.getText().replaceAll("&nbsp;", "").replaceAll("��", ""));
						temp.append(text.trim());
						textList.add(temp);
					}
				} else {
					if (node instanceof TableTag || node instanceof Div) {
						TableValid tableValid = new TableValid();
						isValidTable(node, tableValid);
						if (tableValid.getTrnum() > 2) {//>2��Ϊ���о������ݵģ�����tabel��Div�𵽵ľ��ǿ���Ե�����
							textList.add(node);
							continue;
						}
					}
					List tempList = extractHtml(node, newsbean);
					if ((tempList != null) && (tempList.size() > 0)) {
						Iterator ti = tempList.iterator();
						while (ti.hasNext()) {
							textList.add(ti.next());
						}
					}
				}
			}
		} catch (Exception e) {
			return null;
		}
		if ((textList != null) && (textList.size() > 0)) {
			if (bl){
				StringBuffer temp = new StringBuffer();
				Iterator ti = textList.iterator();
				int wordSize = 0;
				StringBuffer node;
				int status = 0;
				StringBuffer lineStart = new StringBuffer("<p style='TEXT-INDENT: 2em'>");
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
				if (wordSize > newsbean.getFileSize()) {
					newsbean.setFileSize(wordSize);
					newsbean.setContent(temp.toString());
				}
				return null;
			} else {
				return textList;
			}
		}
		return null;
	}
	/**
	 * ��ȡ�����е�����
	 * 
	 * @param nodeP
	 * @param siteUrl
	 * @param textList
	 * @return
	 */
	private List extractParagraph(Node nodeP, HtmlBean url, List textList) {
		NodeList nodeList = nodeP.getChildren();
		if ((nodeList == null) || (nodeList.size() == 0)) {
			if (nodeP instanceof ParagraphTag) {
				StringBuffer temp = new StringBuffer();
				temp.append("<p style='TEXT-INDENT: 2em'>");
				textList.add(temp);
				
				temp = new StringBuffer();
				temp.append("</p>").append(lineSign);
				textList.add(temp);
				
				return textList;
			}
			return null;
		}
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();){
				Node node = (Node) e.nextNode();
				if (node instanceof ScriptTag || node instanceof StyleTag|| node instanceof SelectTag){
					
				} else if (node instanceof LinkTag) {
					textList.add(node);
					setLinkImg(node, this.parser.getURL());
				} else if(node instanceof ImageTag) {
					ImageTag img = (ImageTag) node;
					if (img.getImageURL().toLowerCase().indexOf("http://") < 0) {
						img.setImageURL(url.getURL() + img.getImageURL());
					} else {
						img.setImageURL(img.getImageURL());
					}
					textList.add(node);
				} else if(node instanceof TextNode) {
					if (node.getText().trim().length() > 0) {
						String text = collapse(node.getText().replaceAll("&nbsp;","").replaceAll("��", ""));
						StringBuffer temp = new StringBuffer();
						temp.append(text);
						textList.add(temp);
					}
				}//<p>��ǰ���� div �� span
				else if (node instanceof Div||node instanceof Span) {//�е���ҳ <s
					//��ȡ<span>�е�����
					StringBuffer spanWord = new StringBuffer();
					extractSpanDivInPWord(node, spanWord);
					if ((spanWord != null) && (spanWord.length() > 0)) {
						String text = collapse(spanWord.toString().replaceAll("&nbsp;", "").replaceAll("��", ""));
						StringBuffer temp = new StringBuffer();
						temp.append(text);
						textList.add(temp);
						
						//���<span>�е����ݷ���ʱ���ʽ��������ʱ���
						if(url.getLastUpdateTime()==null){
							Pattern p = Pattern.compile("[0-9]{4}[��|\\-|/][0-9]{1,2}[��|\\-|/][0-9]{1,2}��?\\s*[012]{1}[0-9]{1}:[0-6]{1}[0-9]{1}");
							Matcher m = p.matcher(text);		
							if(m.find()) {
								if (!"".equals(m.group())) {
									String time = m.group();	
									time = time.replaceAll("��", "/");	
									time = time.replaceAll("��", "/");
									time = time.replaceAll("��", " ");
									time = time.replaceAll("-", "/");	
									//System.out.println(time);	
									url.setLastUpdateTime(time);
								}
							}
						}
					}
				} else if (node instanceof TagNode) {
					String tag = node.toHtml();
					if (tag.length() <= 10) {
						tag = tag.toLowerCase();
						if ((tag.indexOf("strong") >= 0)|| (tag.indexOf("b") >= 0)) {//strong b ���Ƕ�����Ӵֵı�ǩ
							StringBuffer temp = new StringBuffer();
							temp.append(tag);
							textList.add(temp);
						}
					} else {
						if (node instanceof TableTag || node instanceof Div) {
							TableValid tableValid = new TableValid();
							isValidTable(node, tableValid);
							if (tableValid.getTrnum() > 2) {
								textList.add(node);
								continue;
							}
						}
						extractParagraph(node,url, textList);
					}
				}
			}
		} catch (Exception e) {
			return null;
		}
		return textList;
	}
	////��<p>Ϊ��ǰ���� div �� span���ץȡ
	protected void extractSpanDivInPWord(Node nodeP, StringBuffer spanWord) {
		NodeList nodeList = nodeP.getChildren();
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				if (node instanceof ScriptTag || node instanceof StyleTag|| node instanceof SelectTag) {
					
				} else if (node instanceof TextNode) {
					spanWord.append(node.getText());
				} else if (node instanceof Span) {
					extractSpanDivInPWord(node, spanWord);
				} else if (node instanceof ParagraphTag) {
					extractSpanDivInPWord(node, spanWord);
				} else if (node instanceof Div) {
					extractSpanDivInPWord(node, spanWord);
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
	 * ����ͼ������
	 * 
	 * @param nodeP
	 * @param siteUrl
	 */
	private void setLinkImg(Node nodeP, String url) {
		NodeList nodeList = nodeP.getChildren();
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				if (node instanceof ImageTag) {
					ImageTag img = (ImageTag) node;
					if (img.getImageURL().toLowerCase().indexOf("http://") < 0) {
						img.setImageURL(url + img.getImageURL());
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
     * �����ṩ��URL����ȡ��URL��Ӧ��ҳ���еĴ��ı���Ϣ���η����õ�����Ϣ���Ǻܴ���
     *������õ����ǲ���Ҫ�����ݡ����������ֻ����õ�ĳ��URL ������д��ı���Ϣ���÷������Ǻܺ��õġ�
     * @param url �ṩ��URL����
     * @return RL��Ӧ��ҳ�Ĵ��ı���Ϣ
     * @throws ParserException
     */
    public String getPlainText(){
        StringBean sb = new StringBean();
        //���ò���Ҫ�õ�ҳ����������������Ϣ
        sb.setLinks(false);
        //���ý�����Ͽո�������ո������
        sb.setReplaceNonBreakingSpaces(true);
        //���ý�һ���пո���һ����һ�ո�������
        sb.setCollapse(true);
        //����Ҫ������URL
        this.parser.reset();
        try {
			this.parser.visitAllNodesWith(sb);
		} catch (ParserException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        //sb.setURL(this.parser.getURL());
        //���ؽ��������ҳ���ı���Ϣ
        return sb.getStrings();
    }
	/**
	 * �ж�TABLE�Ƿ��Ǳ�
	 * 
	 * @param nodeP
	 * @return
	 */
	private void isValidTable(Node nodeP, TableValid tableValid) {
		NodeList nodeList = nodeP.getChildren();
		/** ����ñ�û���ӽڵ��򷵻�* */
		if ((nodeList == null) || (nodeList.size() == 0)) {
			return;
		}
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				/** ����ӽڵ㱾��Ҳ�Ǳ��򷵻�* */
				if (node instanceof TableTag 
						||node instanceof Div
						||node instanceof ScriptTag
						||node instanceof StyleTag
						||node instanceof SelectTag
						||node instanceof TableColumn) {
					return;
				}else if (node instanceof TableRow) {
					TableColumnValid tcValid = new TableColumnValid();
					tcValid.setValid(true);
					findTD(node, tcValid);//
					if (tcValid.isValid()) {
						if (tcValid.getTdNum() < 2) {//2������һ��<td></td>,<2��ʾ��������������
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
	 * �ж��Ƿ���ЧTR
	 *Ѱ��һ��TR�ڵ�td��
	 * @param nodeP
	 * @param TcValid
	 * @return
	 */
	private void findTD(Node nodeP, TableColumnValid tcValid) {
		NodeList nodeList = nodeP.getChildren();
		/** ����ñ�û���ӽڵ��򷵻�* */
		if ((nodeList == null) || (nodeList.size() == 0)) {
			return;
		}
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				/** �����Ƕ�ױ�* */
				if (node instanceof TableTag 
						|| node instanceof Div
						|| node instanceof TableRow
						|| node instanceof TableHeader
						|| node instanceof ScriptTag
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
	public static String collapse(String string) {
		int chars;
		int length;
		int state;
		char character;
		StringBuffer buffer = new StringBuffer();
		chars = string.length();
		if (0 != chars) {
			length = buffer.length();
			state = ((0 == length) 
					|| (buffer.charAt(length - 1) == ' ') 
					|| ((lineSign_size <= length) && buffer.substring(length - lineSign_size, length).equals(lineSign))) ? 0: 1;
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
	   
    public HtmlBean getBean() {
		return bean;
	}
	public void setBean(HtmlBean bean) {
		this.bean = bean;
	}
	public static void main(String[] args) {
		//ExtractContent ec=new ExtractContent();
		//String xxx=ec.getLinkUrl("http://www.ifeng.com/sss/xxx");
		//System.out.println(xxx);
		//ExtractContent console = new ExtractContent("http://www.eastmoney.com/","");
		//URL c = new URL();
		//c.setCharSet("utf-8");//
		//c.setLink("http://blog.csdn.net/chl033/article/details/2731471");
		//String link=
		//c.setUrl("http://shanxi.sina.com.cn/news/report/2014-07-04/075162229.html");
		//console.parse(c);
		/*
		NodeVisitor nodeVisitor = new NodeVisitor() {
			private String charset = "";
			public void visitTag(Tag tag) {
				if (tag instanceof MetaTag) {
					// ץȡ������
					String con=((MetaTag) tag).getMetaContent();
					String con1=((MetaTag) tag).getPage().getCharset(tag.getAttribute(s)).getText();
					Pattern pattern=Pattern.compile("charset\\s*=\\s*['\\\"](.*)['\\\"]", Pattern.CASE_INSENSITIVE);
					Matcher matcher=pattern.matcher(con1);
					if(matcher.find()){
						this.charset=matcher.group(1);
					}

				}
			}

			public void visitEndTag(Tag tag) {
				if (tag.getTagName().equals("TBODY")) {
					System.out.println("end........");
					flag = false;
				}
			}
		};
		parser.visitAllNodesWith(nodeVisitor);
		*/
	}
	
}

package com.lmt.app.crawler.content;


import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.htmlparser.Node;
import org.htmlparser.NodeFilter;
import org.htmlparser.Parser;
import org.htmlparser.beans.StringBean;
import org.htmlparser.filters.AndFilter;
import org.htmlparser.filters.HasAttributeFilter;
import org.htmlparser.filters.TagNameFilter;
import org.htmlparser.nodes.TagNode;
import org.htmlparser.nodes.TextNode;
import org.htmlparser.tags.Div;
import org.htmlparser.tags.HeadingTag;
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
import com.lmt.app.crawler.dao.HtmlDao;

//���ĳ�ȡ������
public class ExtractContent{
	protected static final String lineSign = System.getProperty("line.separator");
	protected static final int lineSign_size = lineSign.length();
    private Parser parser = null;   //���ڷ�����ҳ�ķ�������
    private HtmlBean bean = new HtmlBean();
    public ExtractContent(Parser parser){
		this.parser = parser;
    	this.parse();
    }
	/**
	 * �ռ�HTMLҳ����Ϣ
	 * 
	 * @param url
	 * @param urlEncode
	 */
	public void parse() {
        //this.bean.setTitle(this.getTitle());
        //System.out.println(newsDate);
       // this.bean.setLastUpdateTime(this.getNewsDate());
        //System.out.println(newsauthor); 
       // this.bean.setAuthor(this.getNewsAuthor());
        // System.out.println(newsContent);  
        //this.bean.setContent(this.getPlainText());
        parseP();
	}
	public void parseP(){
		try {
			parser.reset();
			for (NodeIterator e = parser.elements(); e.hasMoreNodes();){
				Node node = (Node) e.nextNode();
				if (node instanceof Html) {
					// ץȡ������
					extractHtml(node, bean);
				}
			}
		} catch (Exception e) {
			System.out.println(e);
		}
	}
	/**
     * ��ȡ���ŵ�����
     * @param newsContentFilter
     * @param parser
     * @return  content ��������
     */
    public String getContent() {
    	this.parser.reset();
    	 NodeFilter contentFilter = new AndFilter(new TagNameFilter("div"), new HasAttributeFilter("id", "contentText"));
        String content = null;
        StringBuilder builder = new StringBuilder();
        try {
            NodeList newsContentList = (NodeList) parser.parse(contentFilter);
            for (int i = 0; i < newsContentList.size(); i++) {
                Div newsContenTag = (Div) newsContentList.elementAt(i);
                builder = builder.append(newsContenTag.getStringText());
            }
            content = builder.toString();  //ת��ΪString ���͡�
            if (content != null) {
                parser.reset();
                //parser = Parser.createParser(content, "utf-8");
                StringBean sb = new StringBean();
                sb.setCollapse(true);
                parser.visitAllNodesWith(sb);
                content = sb.getStrings();
                //String s = "\";} else{ document.getElementById('TurnAD444').innerHTML = \"\";} } showTurnAD444(intTurnAD444); }catch(e){}";
                content = content.replaceAll("\\\".*[a-z].*\\}", "");
                content = content.replace("[����˵����]", "");
            } else {
               System.out.println("û�еõ��������ݣ�");
            }
        } catch (ParserException ex) {
            Logger.getLogger(HtmlDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return content;
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
	// ��һ���ַ�������ȡ��host
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
     * ������ŵı���
     * @param titleFilter
     * @param parser
     * @return
     */
    public String getTitle() {
    	this.parser.reset();
    	NodeFilter titleFilter = new TagNameFilter("h1");
        StringBuffer titleName = new StringBuffer("");
        try {
            NodeList titleNodeList = (NodeList) parser.parse(titleFilter);
            for (int i = 0; i < titleNodeList.size(); i++) {
                HeadingTag title = (HeadingTag) titleNodeList.elementAt(i);
                titleName.append(title.getStringText()+"\n");
            }
        } catch (ParserException ex) {
            Logger.getLogger(HtmlDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return titleName.toString();
    }

    /**
     * ������ŵ����α༭��Ҳ�������ߡ�
     * @param newsauthorFilter
     * @param parser
     * @return
     */
    public String getNewsAuthor() {
    	this.parser.reset();
    	NodeFilter newsauthorFilter = new AndFilter(new TagNameFilter("span"), new HasAttributeFilter("class", "editer"));
        String newsAuthor = "";
        try {
            NodeList authorList = (NodeList) parser.parse(newsauthorFilter);
            for (int i = 0; i < authorList.size(); i++) {
                Node authorSpan = authorList.elementAt(i);
                newsAuthor = authorSpan.toPlainTextString();
            }

        } catch (ParserException ex) {
            Logger.getLogger(HtmlDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return newsAuthor;

    }
    /*
     * ������ŵ�����
     */
    public String getNewsDate() {
    	this.parser.reset();
    	NodeFilter newsdateFilter = new AndFilter(new TagNameFilter("div"), new HasAttributeFilter("class", "time"));
        String newsDate = null;
        try {
            NodeList dateList = (NodeList) parser.parse(newsdateFilter);
            for (int i = 0; i < dateList.size(); i++) {
                Node dateTag = dateList.elementAt(i);
                newsDate = dateTag.toPlainTextString();
            }
        } catch (ParserException ex) {
            Logger.getLogger(HtmlDao.class.getName()).log(Level.SEVERE, null, ex);
        }

        return newsDate;
    }


	/**
	 * �ݹ���ȡ������Ϣ
	 * 
	 * @param nodeP
	 * @return
	 */
	private List extractHtml(Node nodeP, HtmlBean newsbean)throws Exception {
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
		//P ��<html <table <div ���п����������ǩ ,�����������ȡ����Ҫ����
		if (nodeP instanceof ParagraphTag) {
			ArrayList tableList = new ArrayList();
			StringBuffer temp = new StringBuffer();
			temp.append("<p style=\"TEXT-INDENT: 2em\">");
			tableList.add(temp);
			extractParagraph(nodeP, newsbean, tableList);
			temp = new StringBuffer();
			temp.append("</p>").append(lineSign);
			tableList.add(temp);
			return tableList;
		//��ȡ��ҳTitle
		}else if (nodeP instanceof TitleTag) {
			String title=((TitleTag) nodeP).getChildrenHTML().toString().split("[|\\-_]")[0];
			newsbean.setTitle(title);
		//�е���ҳ <span �� <p�� �е�����
		}else if (nodeP instanceof Span){
			StringBuffer spanWord = new StringBuffer();
			getSpanWord(nodeP, spanWord);
			if ((spanWord != null) && (spanWord.length() > 0)) {
				String text = collapse(spanWord.toString().replaceAll("&nbsp;", "").replaceAll("��", ""));
				StringBuffer temp = new StringBuffer();
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
							System.out.println(time);	
							newsbean.setLastUpdateTime(time);
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
					setLinkImg(node, this.parser.getURL());
				} else if (node instanceof ImageTag) {
					ImageTag img = (ImageTag) node;
					if (img.getImageURL().toLowerCase().indexOf("http://") < 0) {
						img.setImageURL(this.parser.getURL()+ img.getImageURL());
					} else {
						img.setImageURL(img.getImageURL());
					}
					tableList.add(node);
				}else if (node instanceof ScriptTag|| node instanceof StyleTag|| node instanceof SelectTag) {
					
				} else if (node instanceof TextNode) {
					if (node.getText().length() > 0) {
						StringBuffer temp = new StringBuffer();
						String text = collapse(node.getText().replaceAll("&nbsp;", "").replaceAll("��", ""));
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
					List tempList = extractHtml(node, newsbean);
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
				if (wordSize > newsbean.getFileSize()) {
					newsbean.setFileSize(wordSize);
					newsbean.setContent(temp.toString());
				}
				return null;
			} else {
				return tableList;
			}
		}
		return null;
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
	 * ��ȡ�����е�����
	 * 
	 * @param nodeP
	 * @param siteUrl
	 * @param tableList
	 * @return
	 */
	private List extractParagraph(Node nodeP, HtmlBean url, List tableList) {
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
					setLinkImg(node, this.parser.getURL());
				} else if(node instanceof ImageTag) {
					ImageTag img = (ImageTag) node;
					if (img.getImageURL().toLowerCase().indexOf("http://") < 0) {
						img.setImageURL(url.getURL() + img.getImageURL());
					} else {
						img.setImageURL(img.getImageURL());
					}
					tableList.add(node);
				} else if(node instanceof TextNode) {
					if (node.getText().trim().length() > 0) {
						String text = collapse(node.getText().replaceAll("&nbsp;","").replaceAll("��", ""));
						StringBuffer temp = new StringBuffer();
						temp.append(text);
						tableList.add(temp);
					}
				} else if (node instanceof Span) {//�е���ҳ <span �� <p�� �е�����
					StringBuffer spanWord = new StringBuffer();
					getSpanWord(node, spanWord);
					if ((spanWord != null) && (spanWord.length() > 0)) {
						String text = collapse(spanWord.toString().replaceAll("&nbsp;", "").replaceAll("��", ""));
						StringBuffer temp = new StringBuffer();
						temp.append(text);
						tableList.add(temp);
						//����ʱ���
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
						extractParagraph(node,url, tableList);
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
	 * �ж�TABLE�Ƿ��Ǳ���
	 * 
	 * @param nodeP
	 * @return
	 */
	private void isValidTable(Node nodeP, TableValid tableValid) {
		NodeList nodeList = nodeP.getChildren();
		/** ����ñ���û���ӽڵ��򷵻�* */
		if ((nodeList == null) || (nodeList.size() == 0)) {
			return;
		}
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				/** ����ӽڵ㱾��Ҳ�Ǳ����򷵻�* */
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
	 * �ж��Ƿ���ЧTR
	 *Ѱ��һ��TR�ڵ�td��
	 * @param nodeP
	 * @param TcValid
	 * @return
	 */
	private void findTD(Node nodeP, TableColumnValid tcValid) {
		NodeList nodeList = nodeP.getChildren();
		/** ����ñ���û���ӽڵ��򷵻�* */
		if ((nodeList == null) || (nodeList.size() == 0)) {
			return;
		}
		try {
			for (NodeIterator e = nodeList.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				/** �����Ƕ�ױ���* */
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

	private String collapse(String string) {
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
	   
    public HtmlBean getBean() {
		return bean;
	}
	public void setBean(HtmlBean bean) {
		this.bean = bean;
	}
	public static void main(String[] args) {
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
package com.lmt.app.crawler;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.htmlparser.Node;
import org.htmlparser.Parser;
import org.htmlparser.tags.HeadTag;
import org.htmlparser.tags.Html;
import org.htmlparser.tags.MetaTag;
import org.htmlparser.util.EncodingChangeException;
import org.htmlparser.util.NodeIterator;
import org.htmlparser.util.NodeList;
import org.htmlparser.util.ParserException;

import com.lmt.app.crawler.content.ExtractContent;
import com.lmt.app.crawler.dao.HtmlBean;
import com.lmt.app.crawler.dao.HtmlDao;
import com.lmt.app.crawler.link.ExtractLink;
import com.lmt.app.crawler.link.LinkDB;
import com.lmt.app.crawler.link.LinkFilter;
import com.lmt.app.crawler.link.analyze.ComputeUrl;
import com.lmt.app.crawler.link.analyze.HITS;
import com.lmt.app.crawler.link.analyze.PageRankComputeUrl;
import com.lmt.app.crawler.link.analyze.WebGraphMemory;
public class Crawler {
	private String charset="";
	private Parser parser=null;
	private ComputeUrl  computeUrl  =  null;
    private HtmlDao newsDao = new HtmlDao();
    private LinkFilter linkSelffilter = new LinkFilter() {
        public boolean accept(String url) {
            if (url.matches("http://.*")){///[\\w\\d]*\\.s?html"
                return true;
            } else {
                return false;
            }
        }
    };
    /* 使用种子 url 初始化 URL 队列*/
    public Crawler(){
    	computeUrl=new PageRankComputeUrl();
    }
    private void initCrawlerWithSeeds(){
    	InputStream localInputStream = getClass().getClassLoader().getResourceAsStream("/Seeds.properties");
    	BufferedReader reader = new BufferedReader(new InputStreamReader(localInputStream));
		String line;
		try {
			while ((line = reader.readLine()) != null) {
				if(!line.startsWith("#")){
					LinkDB.addUnvisitedUrl(line.trim());
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("Crawler class 读取Seeds.properties 错误");
		}
    }
    //从种子网址开始，循环解析所包含的网址和内容
    /* 爬取方法*/
    public void crawling() {
    	WebGraphMemory wg =new WebGraphMemory();
    	HITS hits=null;
        //初始化 URL 队列
        initCrawlerWithSeeds();
        //循环条件：待抓取的链接不空且抓取的网页不多于 1000
        while (!LinkDB.unVisitedUrlsEmpty() && LinkDB.getVisitedUrlNum() <= 1000) {
            //队头 URL 出队
            String toVisitUrl = LinkDB.unVisitedUrlDeQueue();
            System.out.println("在Crawler中 要访问的链接："+toVisitUrl);
            if (toVisitUrl == null) {
                continue;
            }
            try {
				this.parser=new Parser(toVisitUrl);
				this.setEncoding();
				this.parser.setEncoding(this.charset);
			} catch (ParserException e) {
				System.out.println("在Crawler中Parser初始化失败！");
				e.printStackTrace();
			}
            ExtractContent EC=new ExtractContent(this.parser);
            HtmlBean nb = EC.getBean();
            System.out.println("在Crawler中 要访问的链接："+toVisitUrl+"内容是："+nb.getContent());
            //1、对网页进行主题过滤---利用PageRank HITS等算法
            if(hits!=null&&computeUrl.accept(toVisitUrl,nb,hits)){
            	newsDao.saveToDB(nb);
            }
            //如果此链接符合要求 把内容保存到数据库 并返回可接受
            //只有真正的内容页面才保存数据库，目录页面不保存
            	
           //该 url 放入到已访问的 URL中
            LinkDB.addVisitedUrl(toVisitUrl);
            //提取出下载网页中的 URL 2、对链接进行过滤
            //this.parser=Parser.createParser(this.charset, toVisitUrl);
            this.parser.reset();
            Set<String> links = ExtractLink.parse(this.parser, linkSelffilter);
            //新的未访问的 URL 入队
            for (String link : links) {
                LinkDB.addUnvisitedUrl(link);
                System.out.println(link);
            }
            wg.addLink(toVisitUrl, links);
            if(hits==null){
            	hits=new HITS(wg);
            }
            if(LinkDB.getVisitedUrlNum()==500){
            	hits.computeHITS();
            }
        }
        newsDao.close();
    }
    private void setEncoding() {
        try {
        	if(this.parser.getEncoding().equals("ISO-8859-1")){
    			this.parser.setEncoding("GBK");
    		}
			label: 
				for (NodeIterator e = parser.elements(); e.hasMoreNodes();) {
				Node node = (Node) e.nextNode();
				if (node instanceof Html) {
					NodeList nodelist1 = node.getChildren();
					for (int i = 0; i < nodelist1.size(); i++) {
						Node node1 = nodelist1.elementAt(i);
						if (node1 instanceof HeadTag) {
							NodeList nodelist2 = node1.getChildren();
							for (int j = 0; j < nodelist2.size(); j++) {
								Node node2 = nodelist2.elementAt(j);
								if (node2 instanceof MetaTag) {
									// 抓取出内容
									String con = ((MetaTag) node2).getText();
									System.out.println(con);
									//String con1 = ((MetaTag) node2).getPage().getCharset(((MetaTag) node2).getAttribute("CONTENT"));
									Pattern pattern = Pattern.compile(
													"charset\\s*=\\s*['\\\"]*(utf-8|gbk|gb2312)['\\\"]*",
													Pattern.CASE_INSENSITIVE);
									Matcher matcher = pattern.matcher(con);
									if (matcher.find()) {
										this.charset = matcher.group(1);
										break label;
									}
								}
							}
						}
					}
				}
			}
        }catch (EncodingChangeException ex) {
            Logger.getLogger(HtmlDao.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("默认编码和页面中meta等指示的charset不一致");
        } 
        catch (ParserException ex) {
            Logger.getLogger(HtmlDao.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    //main 方法入口，更加base url 进行分析
    public static void main(String[] args) {
       // Crawler crawler = new Crawler();
        //crawler.crawling(new String[]{"http://news.sohu.com"});
    }
}


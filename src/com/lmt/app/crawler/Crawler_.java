package com.lmt.app.crawler;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
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

import sun.net.www.protocol.http.HttpURLConnection;

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
public class Crawler_ {
	private LinkDB linkDB=new LinkDB();
	private double thresholdValue=0.0000009;//满足要求的URL的最低分数
	private Parser parser=null;
    private HtmlDao newsDao = new HtmlDao();
    /* 使用种子 url 初始化 URL 队列*/
    public Crawler_(){
    	//初始化 URL 队列
        initCrawlerWithSeeds();
    }
    private void initCrawlerWithSeeds(){
    	InputStream localInputStream = getClass().getClassLoader().getResourceAsStream("/Seeds.properties");
    	BufferedReader reader = new BufferedReader(new InputStreamReader(localInputStream));
		String line;
		try {
			while ((line = reader.readLine()) != null) {
				if(!line.startsWith("#")){
					linkDB.addUnvisitedUrl(line.trim());
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("Crawler class 读取Seeds.properties 错误");
		}
    }
    //从种子网址开始，循环解析所包含的网址和内容
    /* 爬取方法*/
    public void crawling(String sStartDate,String sEndDate) throws FileNotFoundException, IOException {
    	WebGraphMemory wg =new WebGraphMemory("Seeds.properties");
    	//1、生成web图
    	this.pareseLinkN(wg,sStartDate,sEndDate);
    	//2、对所有链接进行综合打分
        HITS hits=new HITS(wg);
        hits.computeHITS();
        //3、对有效内容保存到数据库
        String toVisitUrl="";
   	 	for(int i=1;i<=wg.numNodes();i++){
   	 		toVisitUrl=wg.IdentifyerToURL(i);
   	 		double as=hits.authorityScore(toVisitUrl);
   	 		if(as<this.thresholdValue){
   	 			continue;
   	 		}
   	 		System.out.println("当前连接评分："+hits.authorityScore(toVisitUrl));
	   	 	try {
				this.parser=new Parser(toVisitUrl);
				String Encoding=wg.hostToEncode(toVisitUrl);
				if(Encoding==null){
                	Encoding=this.getEncoding();
                	wg.setHostToEncode(toVisitUrl, Encoding);
                }
				this.parser.reset(); 
				this.parser.setEncoding(Encoding);
		 	} catch (ParserException e) {
				System.out.println("Content:在Crawler中Parser初始化失败！");
				e.printStackTrace();
				continue;//存在链接超时的情况，这时抛出异常，就继续下一个链接
			}   	 		
	   	 	//6、内容解析
   	 		ExtractContent EC=new ExtractContent(this.parser);
   	 		HtmlBean nb = EC.getBean();
   	 		String newsDate=nb.getLastUpdateTime();
   	 		if(newsDate!=null){
   	 			String[]time=newsDate.split("\\s+");
   	 			if(time[0].compareTo(sStartDate)<0||time[0].compareTo(sEndDate)>0){
   	 				continue;
   	 			}
   	 		}
   	 		//System.out.println("Content:获取第："+i+"个链接"+toVisitUrl+"内容是："+nb.getContent());
   	 		//1、对网页进行主题过滤---利用PageRank HITS等算法 对网页进行打分
   	 		//只有真正的内容页面才保存数据库，目录页面不保存等 
   	 		//如果此链接符合要求 把符合主题的分数超过某一个阈值的内容保存到数据库 并返回可接受
   	 		if(new PageRankComputeUrl().accept(toVisitUrl,nb)){
           		newsDao.saveToDB(nb);
   	 		}
   	 	}
   	 	newsDao.close();
   	 	System.out.println("game over!!!");
    }
    private void pareseLinkN(WebGraphMemory wg,String sStartDate,String sEndDate){
        //循环条件：待抓取的链接不空且抓取的网页不多于 1000
        for(int i=1;i<=wg.numNodes()&&i<=1000;i++) {
            //1、队头 URL 出队
            String toVisitUrl = wg.IdentifyerToURL(i);//linkDB.unVisitedUrlDeQueue();
            System.out.println("已访问"+i+"个链接， 要扩展的链接："+toVisitUrl);
            try{
				this.parser=new Parser(toVisitUrl);//和下面效果一样
            	//this.parser=new Parser((HttpURLConnection)new URL(toVisitUrl).openConnection());
            	String Encoding=wg.hostToEncode(toVisitUrl);
            	if(Encoding==null){
                	Encoding=this.getEncoding();
                	wg.setHostToEncode(toVisitUrl, Encoding);
                }
				this.parser.reset();
				this.parser.setEncoding(Encoding);
				//2、提取出下载网页中的 URL （包含对链接进行过滤）
	            //this.parser=Parser.createParser(this.charset, toVisitUrl);
				//5、解析当前URL中的超链接，并更新到web图
	            ExtractLink.parse(this.parser,wg);
			} catch (ParserException e) {
				System.out.println("在Crawler中Parser初始化失败！");
				e.printStackTrace();
				continue;//存在链接超时的情况，这时抛出异常，就继续下一个链接
			}
        }
    }
    private void pareseLink(WebGraphMemory wg){
        //循环条件：待抓取的链接不空且抓取的网页不多于 1000
        while (!linkDB.unVisitedUrlsEmpty() && linkDB.getVisitedUrlNum() <= 10000) {
            //1、队头 URL 出队
            String toVisitUrl = linkDB.unVisitedUrlDeQueue();
            //System.out.println("已访问"+linkDB.getVisitedUrlNum()+"个链接， 要扩展的链接："+toVisitUrl);
            try{
				//this.parser=new Parser(toVisitUrl);//和下面效果一样
            	this.parser=new Parser((HttpURLConnection)new URL(toVisitUrl).openConnection());
				//this.setEncoding();
				this.parser.reset();
				//this.parser.setEncoding(this.charset);
				//2、提取出下载网页中的 URL （包含对链接进行过滤）
	            //this.parser=Parser.createParser(this.charset, toVisitUrl);
	            LinkFilter linkSelffilter = new LinkFilter() {
	                public boolean accept(String url) {
	                    if (url.matches("([a-zA-z]+://)?([\\w-]+\\.)+[\\w-]+(/[\\w- ./%&=]*)?")
	                    		&&url.toLowerCase().contains("finance")
	                    		&&!url.toLowerCase().contains("search")
	                    		&&!url.toLowerCase().contains("tool")){///[\\w\\d]*\\.s?html"
	                        return true;
	                    } else {
	                        return false;
	                    }
	                }
	            };
	            /*
	            Set<String> links = ExtractLink.parse(this.parser,linkSelffilter);
	            //3、新的未访问的 URL 入队
	            for(String link : links){
	            	linkDB.addUnvisitedUrl(link);
	                System.out.println(link);
	            }
	            //4、该 url 放入到已访问的 URL中
	            linkDB.addVisitedUrl(toVisitUrl);
	            //5、更新web图
	            wg.addLink(toVisitUrl, links);
	            */
			} catch (ParserException e) {
				System.out.println("在Crawler中Parser初始化失败！");
				e.printStackTrace();
				continue;//存在链接超时的情况，这时抛出异常，就继续下一个链接
			}catch (MalformedURLException e) {
				System.out.println("在Crawler中Parser初始化失败！");
				e.printStackTrace();
				continue;//存在链接超时的情况，这时抛出异常，就继续下一个链接
			}catch (IOException e) {
				System.out.println("在Crawler中Parser初始化失败！");
				e.printStackTrace();
				continue;//存在链接超时的情况，这时抛出异常，就继续下一个链接
			}
        }
    }
    private String getEncoding() {
    	String charset="GBK";
        try {
        	if(this.parser.getEncoding().equals("ISO-8859-1")){
    			this.parser.setEncoding(charset);
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
										//System.out.println(con);
										//String con1 = ((MetaTag) node2).getPage().getCharset(((MetaTag) node2).getAttribute("CONTENT"));
										Pattern pattern = Pattern.compile(
														"charset\\s*=\\s*['\\\"]*(utf-8|gbk|gb2312)['\\\"]*",
														Pattern.CASE_INSENSITIVE);
										Matcher matcher = pattern.matcher(con);
										if (matcher.find()) {
											charset= matcher.group(1);
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
        return charset;
    }
    //main 方法入口，更加base url 进行分析
    public static void main(String[] args) {
       // Crawler crawler = new Crawler();
        //crawler.crawling(new String[]{"http://news.sohu.com"});
    }
}
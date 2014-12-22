package com.lmt.app.crawler;

import java.util.regex.Pattern;

import com.lmt.app.crawler.dao.HtmlBean;
import com.lmt.app.crawler.dao.HtmlDao;
import com.lmt.app.crawler.model.Page;

public class IfengCrawler extends BreadthCrawler{
    /*visit函数定制访问每个页面时所�?��行的操作*/
    @Override
    public void visit(Page page) {
        String question_regex="^.*s?html$";
        if(Pattern.matches(question_regex, page.getUrl())){
            /*抽取标题*/
            String title=page.getDoc().title();
            //LogUtils.getLogger().info("title: "+title);
            /*抽取提问内容*/
            String content=page.getDoc().select("div[id=main_content]").text();
            String time=page.getDoc().select("span[class=ss01]").text();
            //LogUtils.getLogger().info("content: "+content);
            if(!"".equals(content)){
            	this.getHB().setTitle(title);
            	this.getHB().setLastUpdateTime(time);
            	this.getHB().setContent(content);
            	this.getHB().setURL(page.getUrl());
            	this.getHD().saveToDB(this.getHB());
            }
        }
    }

    /*启动爬虫*/
    public static void main(String[] args) throws Exception{  
    	IfengCrawler crawler=new IfengCrawler();
        crawler.addSeeds("http://www.zhihu.com/question/21003086","");
        crawler.addPRegexs("http://www.zhihu.com/.*","");
        crawler.start(5);  
    }
}
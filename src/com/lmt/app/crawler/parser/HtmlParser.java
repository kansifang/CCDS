/*
 * Copyright (C) 2014 hu
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
package com.lmt.app.crawler.parser;


import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import com.lmt.app.crawler.model.Link;
import com.lmt.app.crawler.model.Page;
import com.lmt.app.crawler.util.CharsetDetector;
import com.lmt.app.crawler.util.RegexRule;

/**
 * 默认的网页解析器
 * @author hu
 */
public class HtmlParser implements Parser {

    public RegexRule getRegexRule() {
        return regexRule;
    }

    public void setRegexRule(RegexRule regexRule) {
        this.regexRule = regexRule;
    }

    private Integer topN;
    private RegexRule regexRule=null;

    /**
     *构造一个默认的网页解析器，做链接分析时没有数量上限
     */
    public HtmlParser() {
        topN = null;
    }

    /**
     * 构造一个默认的网页解析器，做链接分析时只保存前topN条
     * @param topN 保存链接的上限
     */
    public HtmlParser(Integer topN) {
        this.topN = topN;
    }

    /**
     * 对一个页面进行解析，获取解析结果
     * @param page 待解析页面
     * @return 解析结果
     * @throws UnsupportedEncodingException
     */
    @Override
    public ParseResult getParse(Page page) throws UnsupportedEncodingException {
        String url=page.getUrl();
        
        String charset = CharsetDetector.guessEncoding(page.getContent());
        
        String html=new String(page.getContent(), charset);
        page.setHtml(html);
        
        Document doc=Jsoup.parse(page.getHtml());
        doc.setBaseUri(url);      
        page.setDoc(doc);
        
        String title=doc.title();
        String text=doc.text();
        
        ArrayList<Link> links = null;
        if(topN!=null && topN==0){
            links=new ArrayList<Link>();
        }else{
            links=topNFilter(LinkUtils.getAll(page));
        }
        ParseData parsedata = new ParseData(url,title, links);
        ParseText parsetext=new ParseText(url,text);
        
        return new ParseResult(parsedata,parsetext);
    }

    private ArrayList<Link> topNFilter(ArrayList<Link> origin_links) {
        ArrayList<Link> result=new ArrayList<Link>();
        int updatesize;
        if (topN == null) {
            updatesize = origin_links.size();
        } else {
            updatesize = Math.min(topN, origin_links.size());
        }

        int sum = 0;
        for (int i = 0; i < origin_links.size(); i++) {
            if (sum >= updatesize) {
                break;
            }
            Link link = origin_links.get(i);
            if(!regexRule.satisfy(link.getUrl())){
                continue;
            }
            result.add(link);
            sum++;
        }
        return result;
    }

}

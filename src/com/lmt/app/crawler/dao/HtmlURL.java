package com.lmt.app.crawler.dao;

import java.io.Serializable;
import java.util.Date;

import com.lmt.app.crawler.link.LinkFilter;

public class HtmlURL implements Serializable {
	private static final long serialVersionUID = 7931672194843948629L;
	private int urlNo; // URL NUM
	private String oriUrl;// 原始 URL 的值，主机部分是域名
	private String url; // URL 的值，主机部分是 IP，为了防止重复主机的出现 存在 一个IP多个域名的情况
	private LinkFilter linkFilter;
	
	private int statusCode; // 获取 URL 返回的结果码
	private int hitNum; // 此 URL 被其他文章引用的次数
	private String[] urlRefrences; // 引用的链接
	private int layer; // 爬取的层次， 从种子开始， 依次为第0层， 第1层...
	
	private HtmlBean newsBean;
	
	public HtmlBean getNewsBean() {
		return newsBean;
	}

	public void setNewsBean(HtmlBean newsBean) {
		this.newsBean = newsBean;
	}

	public LinkFilter getLinkFilter() {
		return linkFilter;
	}

	public void setLinkFilter(LinkFilter linkFilter) {
		this.linkFilter = linkFilter;
	}

	public final String getOriUrl() {
		return oriUrl;
	}

	public void setOriUrl(String oriUrl) {
		this.oriUrl = oriUrl;
	}
	public int getLayer() {
		return layer;
	}

	public void setLayer(int layer) {
		this.layer = layer;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public int getUrlNo() {
		return urlNo;
	}

	public void setUrlNo(int urlNo) {
		this.urlNo = urlNo;
	}

	public int getStatusCode() {
		return statusCode;
	}

	public void setStatusCode(int statusCode) {
		this.statusCode = statusCode;
	}

	public int getHitNum() {
		return hitNum;
	}

	public void setHitNum(int hitNum) {
		this.hitNum = hitNum;
	}

	public String[] getUrlRefrences() {
		return urlRefrences;
	}

	public void setUrlRefrences(String[] urlRefrences) {
		this.urlRefrences = urlRefrences;
	}
}
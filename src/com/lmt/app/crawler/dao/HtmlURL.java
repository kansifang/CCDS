package com.lmt.app.crawler.dao;

import java.io.Serializable;
import java.util.Date;

import com.lmt.app.crawler.link.LinkFilter;

public class HtmlURL implements Serializable {
	private static final long serialVersionUID = 7931672194843948629L;
	private int urlNo; // URL NUM
	private String oriUrl;// ԭʼ URL ��ֵ����������������
	private String url; // URL ��ֵ������������ IP��Ϊ�˷�ֹ�ظ������ĳ��� ���� һ��IP������������
	private LinkFilter linkFilter;
	
	private int statusCode; // ��ȡ URL ���صĽ����
	private int hitNum; // �� URL �������������õĴ���
	private String[] urlRefrences; // ���õ�����
	private int layer; // ��ȡ�Ĳ�Σ� �����ӿ�ʼ�� ����Ϊ��0�㣬 ��1��...
	
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
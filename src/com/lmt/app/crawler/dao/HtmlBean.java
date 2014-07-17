package com.lmt.app.crawler.dao;

import java.util.Date;

/**
 *
 * @author Administrator
 */
public class HtmlBean {
	private int num;
	private String SerialNo;
	private String abstractText; // 文章摘要
	private String title; // 文章名称
	private String author; // 作者
	private String description; // 文章的描述
    private String content;//文章内容
    private String lastUpdateTime; // 最后修改时间
	private Date timeToLive; // 过期时间
	private int fileSize; // 文章大小
    private String URL;
	private String type; // 文章类型
	private String charSet; // 此 URL 对应文章的汉字编码
	private int weight; // 文章的权重(包含导向词的信息)
	
    public String getAbstractText() {
		return abstractText;
	}

	public void setAbstractText(String abstractText) {
		this.abstractText = abstractText;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getLastUpdateTime() {
		return lastUpdateTime;
	}

	public void setLastUpdateTime(String lastUpdateTime) {
		this.lastUpdateTime = lastUpdateTime;
	}

	public Date getTimeToLive() {
		return timeToLive;
	}

	public void setTimeToLive(Date timeToLive) {
		this.timeToLive = timeToLive;
	}

	public int getFileSize() {
		return fileSize;
	}

	public void setFileSize(int fileSize) {
		this.fileSize = fileSize;
	}
	
	public String getURL() {
		return URL;
	}

	public void setURL(String uRL) {
		URL = uRL;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getCharSet() {
		return charSet;
	}

	public void setCharSet(String charSet) {
		this.charSet = charSet;
	}

	public int getWeight() {
		return weight;
	}

	public void setWeight(int weight) {
		this.weight = weight;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}
	

	public String getSerialNo() {
		return SerialNo;
	}

	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}
}

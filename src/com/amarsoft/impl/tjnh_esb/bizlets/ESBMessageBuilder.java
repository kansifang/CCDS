/**
 * 
 * 打印日志
 * @author xhyong
 */
package com.amarsoft.impl.tjnh_esb.bizlets;


import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

/**
 * 数据组包程序,注意更新sFilePath配置文件存放位置
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ESBMessageBuilder {


	
	public String sFilePath=Thread.currentThread().getContextClassLoader().getResource("").getPath();
	
	public String sCurSlash = System.getProperty("file.separator");

	public String LOG4J_URL = "";


	public final String CONV_CODESET = "CP037";// CP037;CP1047


	public Logger logger = Logger.getLogger(ESBMessageBuilder.class.getName());

	/**
	 * 构造MessageBuilder
	 */
	public ESBMessageBuilder() {
		InitMessageBuilder();
	}

	/**
	 * 初始化数据
	 */
	public void InitMessageBuilder() {
		sFilePath=sFilePath.substring(0,sFilePath.length()-8)+"pro"+sCurSlash;
		LOG4J_URL = sFilePath+"log4jlog.properties";
		PropertyConfigurator.configure(LOG4J_URL);
		logger.debug("日志初始化成功！");
	}

}
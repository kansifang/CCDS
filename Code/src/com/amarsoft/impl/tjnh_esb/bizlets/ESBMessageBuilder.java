/**
 * 
 * ��ӡ��־
 * @author xhyong
 */
package com.amarsoft.impl.tjnh_esb.bizlets;


import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

/**
 * �����������,ע�����sFilePath�����ļ����λ��
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
	 * ����MessageBuilder
	 */
	public ESBMessageBuilder() {
		InitMessageBuilder();
	}

	/**
	 * ��ʼ������
	 */
	public void InitMessageBuilder() {
		sFilePath=sFilePath.substring(0,sFilePath.length()-8)+"pro"+sCurSlash;
		LOG4J_URL = sFilePath+"log4jlog.properties";
		PropertyConfigurator.configure(LOG4J_URL);
		logger.debug("��־��ʼ���ɹ���");
	}

}
package com.amarsoft.impl.tjnh_esb.bizlets;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Hashtable;
import java.util.Properties;
import com.amarsoft.are.sql.Transaction;
import com.ibm.mq.MQC;


import org.apache.log4j.Logger;

import spc.webos.endpoint.ESB;
/**
 * 实现与核心的数据交互,为静态方法,连接常跓内存
 * @author zrli
 *
 */
public class ESBGJTrade {
	static boolean MFTradeInited = false;
	static boolean MFTradeType = true;//如果长连接就置为false;短连接为true,并且在交易结束时要sm.teardownConnection();
	static Properties pro=new Properties();
	static String sFileTradeDate="";
	static String sChannel="";
	static String sQmName="";
	static String sCcsid="";
	static String sPort="";
	static String sHostname="";
	static String sAppCd="";
	static int iMaxCnnNum=2;
	static int iCnnHoldTime=300;
	
	/**
	 	* 初始化ESBGJTrade
	 	* @return
	 	* 与ESB通信客户端设置
	 	* hostname:ESB MQ服务的地址，此值依环境动态配置
	 	* appCd:ESB 为每个接入系统分配的系统编号
		* maxCnnNum:最大连接数
		* cnnHoldTime:长连接有效时间，单位为秒，一般为3到5分钟，-1为连接用不失效，指导队列管理器报告连接错误
		* port:设置MQ访问属性
		* CCSID: MQ CCSID，固定
		* channel:MQ通道配置, 固定
		* qmName:MQ队列管理器配置，固定
	
	 */
	public static boolean initESBGJTrade() throws Exception{
		String sFilePath=Thread.currentThread().getContextClassLoader().getResource("").getPath();
		sFilePath=sFilePath.substring(0,sFilePath.length()-8)+"pro"+System.getProperty("file.separator");
		if(sFilePath.equals(""))
			sFilePath="E:\\workspace\\ALS6\\WebRoot\\WEB-INF\\pro\\";
		String filePath =sFilePath+"socket.properties";
		Properties fileProps = new Properties();
		InputStream in = new BufferedInputStream (new FileInputStream(filePath));
		fileProps.load(in);
        
        sChannel = fileProps.getProperty("esbchannel");
        sQmName = fileProps.getProperty("esbqmName");
        sCcsid = fileProps.getProperty("esbccsid");
        sPort = fileProps.getProperty("esbport");
        sHostname = fileProps.getProperty("esbhostname");
        sAppCd = fileProps.getProperty("esbappcd");
        iMaxCnnNum = Integer.valueOf(fileProps.getProperty("esbmaxcnnnum"));
        iCnnHoldTime = Integer.valueOf(fileProps.getProperty("esbcnnholdtime"));
        
        
        
        
		Hashtable props = new Hashtable(); // MQ队列管理器配置
		props.put("channel", sChannel); // MQ通道配置, 固定
		props.put("qmName", sQmName); // MQ队列管理器配置，固定
		props.put(MQC.CCSID_PROPERTY, new Integer(sCcsid));// MQ CCSID，固定
		props.put(MQC.PORT_PROPERTY, new Integer(sPort)); // MQ端口，固定			
		props.put("hostname", sHostname); // ESB MQ服务的地址，此值依环境动态配置
		ESB esb = ESB.getInstance();
		// 客户端对ESB连接是长连接，此为连接数，类似数据库连接数
		// 测试环境建议配置2，
		// 生产环境依赖交易量大小决定
		// 建议每10TPS交易规模增加2个连接，原则上一个客户端不能超过20，否则需
		//  要向ESB项目组协商,
		esb.setMaxCnnNum(iMaxCnnNum); 
		esb.setCnnHoldTime(iCnnHoldTime); // 长连接有效时间，单位为秒，一般为3到5分钟，-1为连接用不失效，指导队列管理器报告连接错误
		esb.setProps(props); // 设置MQ访问属性
		esb.setAppCd(sAppCd); // ESB 为每个接入系统分配的系统编号
		try {
			esb.init();
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} // 初始化对象，建立和ESB的通讯连接
		
		return true;
	}
	/**
	 * 执行与核心实时交易
	 * @param sOjbectNo
	 * @param sObjectType
	 * @param sTradeType
	 * @return 交易是否成功
	 * @throws Exception 
	 */
	public static String runESBGJTrade(String sObjectNo,String sObjectType,String sTradeType,Transaction sqlca,String sTradeDate) throws Exception{
		String sReturn="";
		initESBGJTrade();

		if(sTradeDate.equals("")) sTradeDate = sFileTradeDate;
		try {
			ESBGJTradeInterface mftr=(ESBGJTradeInterface)Class.forName("com.amarsoft.impl.tjnh_esb.bizlets.ESBGJTrade"+sTradeType).newInstance();
			sReturn=mftr.runESBGJTrade(sObjectNo,sObjectType,sTradeType,sqlca,sTradeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
			System.out.println(sTradeType+"对应交易的类不存在!请首先检查com.amarsoft.impl.tjnh_als.bizlets.ESBGJTrade"+sTradeType+".java是否存在!");
		}
		return sReturn;
	}

}

package com.amarsoft.impl.tjnh_als.bizlets;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import com.amarsoft.are.sql.Transaction;


import org.apache.log4j.Logger;
/**
 * 实现与核心的数据交互,为静态方法,连接常跓内存
 * @author zrli
 *
 */
public class MFTrade {
	static boolean MFTradeInited = false;
	static boolean MFTradeType = true;//如果长连接就置为false;短连接为true,并且在交易结束时要sm.teardownConnection();
	static SocketManager sm =null;
	static Properties pro=new Properties();
	static String sFilePath="";
	static String sFileTradeDate="";
	
	/**
	 * 初始化MFTrade
	 * @return
	 */
	public static boolean initMFTrade(String sFilePath) throws Exception{
		//如果MFTrade未初始化那么就进行初始化
		if(!MFTradeInited||MFTradeType){
			try{
				String filePath =sFilePath+"socket.properties";
				Properties props = new Properties();
				InputStream in = new BufferedInputStream (new FileInputStream(filePath));
		        props.load(in);
		        sFileTradeDate = props.getProperty("mfdate");
				//无超时设置无需第三参数
				sm = new SocketManager(props.getProperty("mfaddress"), props.getProperty("mfport"),props.getProperty("mftimeout"));
	        	//sm = new SocketManager(props.getProperty("mfaddress"), props.getProperty("mfport"));
				sm.setupConnection();
				in.close();
			}catch(Exception ex){
				ex.printStackTrace();
				System.out.println("初始化Socekt失败!");
				return false;
			}
			MFTradeInited=true;
		}
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
	public static String runMFTrade(String sObjectNo,String sObjectType,String sTradeType,Transaction sqlca,String sFilePath,String sTradeDate) throws Exception{
		String sReturn="";
		initMFTrade(sFilePath);
		if(sm == null){
			sReturn="9999997@["+sTradeType+"]交易失败，未得到Socekt连接原因！请检查地址端口是否正确以及超时时间是否合适！";
			return sReturn;
		}
		if(sTradeDate.equals("")) sTradeDate = sFileTradeDate;
		try {
			MFTradeInterface mftr=(MFTradeInterface)Class.forName("com.amarsoft.impl.tjnh_als.bizlets.MFTrade"+sTradeType).newInstance();
			sReturn=mftr.runMFTrade(sm,sObjectNo,sObjectType,sqlca,sFilePath,sTradeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
			System.out.println(sTradeType+"对应交易的类不存在!请首先检查com.amarsoft.impl.tjnh_als.bizlets.MFTrade"+sTradeType+".java是否存在!");
		}
		return sReturn;
	}

}

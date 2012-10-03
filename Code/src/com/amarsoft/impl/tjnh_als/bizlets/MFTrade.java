package com.amarsoft.impl.tjnh_als.bizlets;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import com.amarsoft.are.sql.Transaction;


import org.apache.log4j.Logger;
/**
 * ʵ������ĵ����ݽ���,Ϊ��̬����,���ӳ�ڟ�ڴ�
 * @author zrli
 *
 */
public class MFTrade {
	static boolean MFTradeInited = false;
	static boolean MFTradeType = true;//��������Ӿ���Ϊfalse;������Ϊtrue,�����ڽ��׽���ʱҪsm.teardownConnection();
	static SocketManager sm =null;
	static Properties pro=new Properties();
	static String sFilePath="";
	static String sFileTradeDate="";
	
	/**
	 * ��ʼ��MFTrade
	 * @return
	 */
	public static boolean initMFTrade(String sFilePath) throws Exception{
		//���MFTradeδ��ʼ����ô�ͽ��г�ʼ��
		if(!MFTradeInited||MFTradeType){
			try{
				String filePath =sFilePath+"socket.properties";
				Properties props = new Properties();
				InputStream in = new BufferedInputStream (new FileInputStream(filePath));
		        props.load(in);
		        sFileTradeDate = props.getProperty("mfdate");
				//�޳�ʱ���������������
				sm = new SocketManager(props.getProperty("mfaddress"), props.getProperty("mfport"),props.getProperty("mftimeout"));
	        	//sm = new SocketManager(props.getProperty("mfaddress"), props.getProperty("mfport"));
				sm.setupConnection();
				in.close();
			}catch(Exception ex){
				ex.printStackTrace();
				System.out.println("��ʼ��Socektʧ��!");
				return false;
			}
			MFTradeInited=true;
		}
		return true;
	}
	/**
	 * ִ�������ʵʱ����
	 * @param sOjbectNo
	 * @param sObjectType
	 * @param sTradeType
	 * @return �����Ƿ�ɹ�
	 * @throws Exception 
	 */
	public static String runMFTrade(String sObjectNo,String sObjectType,String sTradeType,Transaction sqlca,String sFilePath,String sTradeDate) throws Exception{
		String sReturn="";
		initMFTrade(sFilePath);
		if(sm == null){
			sReturn="9999997@["+sTradeType+"]����ʧ�ܣ�δ�õ�Socekt����ԭ�������ַ�˿��Ƿ���ȷ�Լ���ʱʱ���Ƿ���ʣ�";
			return sReturn;
		}
		if(sTradeDate.equals("")) sTradeDate = sFileTradeDate;
		try {
			MFTradeInterface mftr=(MFTradeInterface)Class.forName("com.amarsoft.impl.tjnh_als.bizlets.MFTrade"+sTradeType).newInstance();
			sReturn=mftr.runMFTrade(sm,sObjectNo,sObjectType,sqlca,sFilePath,sTradeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
			System.out.println(sTradeType+"��Ӧ���׵��಻����!�����ȼ��com.amarsoft.impl.tjnh_als.bizlets.MFTrade"+sTradeType+".java�Ƿ����!");
		}
		return sReturn;
	}

}

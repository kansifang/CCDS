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
public class GDTrade {
	static boolean GDTradeInited = false;
	static boolean GDTradeType = true;//��������Ӿ���Ϊfalse;������Ϊtrue,�����ڽ��׽���ʱҪsm.teardownConnection();
	static SocketManager sm =null;
	static Properties pro=new Properties();
	static String sFilePath="";
	static String sFileTradeDate="";
	
	/**
	 * ��ʼ��GDTrade
	 * @return
	 */
	public static boolean initGDTrade(String sFilePath) throws Exception{
		//���GDTradeδ��ʼ����ô�ͽ��г�ʼ��
		if(!GDTradeInited||GDTradeType){
			try{
				String filePath =sFilePath+"socket.properties";
				Properties props = new Properties();
				InputStream in = new BufferedInputStream (new FileInputStream(filePath));
		        props.load(in);
		        sFileTradeDate = props.getProperty("gddate");
				//�޳�ʱ���������������
				sm = new SocketManager(props.getProperty("gdaddress"), props.getProperty("gdport"),props.getProperty("gdtimeout"));
	        	//sm = new SocketManager(props.getProperty("gdaddress"), props.getProperty("gdport"));
				if(!sm.setupConnection()){
					System.out.println("��ʼ��Socektʧ��!Ŀǰ��ʱʱ��Ϊ["+props.getProperty("gdtimeout")+"],��ע�⣡");
					return false;
				}
				in.close();
			}catch(Exception ex){
				ex.printStackTrace();
				System.out.println("��ʼ��Socektʧ��!");
				return false;
			}
			GDTradeInited=true;
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
	public static String runGDTrade(String sObjectNo,String sObjectType,String sTradeType,Transaction sqlca,String sFilePath,String sTradeDate) throws Exception{
		String sReturn="";
		initGDTrade(sFilePath);
		if(sm == null){
			sReturn="9999997@["+sTradeType+"]����ʧ�ܣ�δ�õ�Socekt����ԭ�������ַ�˿��Ƿ���ȷ�Լ���ʱʱ���Ƿ���ʣ�";
			return sReturn;
		}
		if(sTradeDate.equals("")) sTradeDate = sFileTradeDate;
		try {
			GDTradeInterface gdtr=(GDTradeInterface)Class.forName("com.amarsoft.impl.tjnh_als.bizlets.GDTrade"+sTradeType).newInstance();
			sReturn=gdtr.runGDTrade(sm,sObjectNo,sObjectType,sqlca,sFilePath,sTradeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
			System.out.println(sTradeType+"��Ӧ���׵��಻����!�����ȼ��com.amarsoft.impl.tjnh_als.bizlets.GDTrade"+sTradeType+".java�Ƿ����!");
		}
		return sReturn;
	}

}

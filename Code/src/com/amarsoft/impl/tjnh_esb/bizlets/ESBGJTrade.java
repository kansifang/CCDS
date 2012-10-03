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
 * ʵ������ĵ����ݽ���,Ϊ��̬����,���ӳ�ڟ�ڴ�
 * @author zrli
 *
 */
public class ESBGJTrade {
	static boolean MFTradeInited = false;
	static boolean MFTradeType = true;//��������Ӿ���Ϊfalse;������Ϊtrue,�����ڽ��׽���ʱҪsm.teardownConnection();
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
	 	* ��ʼ��ESBGJTrade
	 	* @return
	 	* ��ESBͨ�ſͻ�������
	 	* hostname:ESB MQ����ĵ�ַ����ֵ��������̬����
	 	* appCd:ESB Ϊÿ������ϵͳ�����ϵͳ���
		* maxCnnNum:���������
		* cnnHoldTime:��������Чʱ�䣬��λΪ�룬һ��Ϊ3��5���ӣ�-1Ϊ�����ò�ʧЧ��ָ�����й������������Ӵ���
		* port:����MQ��������
		* CCSID: MQ CCSID���̶�
		* channel:MQͨ������, �̶�
		* qmName:MQ���й��������ã��̶�
	
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
        
        
        
        
		Hashtable props = new Hashtable(); // MQ���й���������
		props.put("channel", sChannel); // MQͨ������, �̶�
		props.put("qmName", sQmName); // MQ���й��������ã��̶�
		props.put(MQC.CCSID_PROPERTY, new Integer(sCcsid));// MQ CCSID���̶�
		props.put(MQC.PORT_PROPERTY, new Integer(sPort)); // MQ�˿ڣ��̶�			
		props.put("hostname", sHostname); // ESB MQ����ĵ�ַ����ֵ��������̬����
		ESB esb = ESB.getInstance();
		// �ͻ��˶�ESB�����ǳ����ӣ���Ϊ���������������ݿ�������
		// ���Ի�����������2��
		// ��������������������С����
		// ����ÿ10TPS���׹�ģ����2�����ӣ�ԭ����һ���ͻ��˲��ܳ���20��������
		//  Ҫ��ESB��Ŀ��Э��,
		esb.setMaxCnnNum(iMaxCnnNum); 
		esb.setCnnHoldTime(iCnnHoldTime); // ��������Чʱ�䣬��λΪ�룬һ��Ϊ3��5���ӣ�-1Ϊ�����ò�ʧЧ��ָ�����й������������Ӵ���
		esb.setProps(props); // ����MQ��������
		esb.setAppCd(sAppCd); // ESB Ϊÿ������ϵͳ�����ϵͳ���
		try {
			esb.init();
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} // ��ʼ�����󣬽�����ESB��ͨѶ����
		
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
	public static String runESBGJTrade(String sObjectNo,String sObjectType,String sTradeType,Transaction sqlca,String sTradeDate) throws Exception{
		String sReturn="";
		initESBGJTrade();

		if(sTradeDate.equals("")) sTradeDate = sFileTradeDate;
		try {
			ESBGJTradeInterface mftr=(ESBGJTradeInterface)Class.forName("com.amarsoft.impl.tjnh_esb.bizlets.ESBGJTrade"+sTradeType).newInstance();
			sReturn=mftr.runESBGJTrade(sObjectNo,sObjectType,sTradeType,sqlca,sTradeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
			System.out.println(sTradeType+"��Ӧ���׵��಻����!�����ȼ��com.amarsoft.impl.tjnh_als.bizlets.ESBGJTrade"+sTradeType+".java�Ƿ����!");
		}
		return sReturn;
	}

}

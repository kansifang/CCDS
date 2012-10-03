package com.amarsoft.impl.tjnh_als.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * ���ͺ���SendGD����
 * ע�⣬�����ӿ�ʱ�����ĵ������ֵ����CODE-LIBRARY��Attribute1��
 * @author zrli
 *
 */
public class SendGD extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		if(sObjectType==null) sObjectType="";
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo==null) sObjectNo="";
		String sTradeType = (String)this.getAttribute("TradeType");
		if(sTradeType==null) sTradeType="";
		//��������
		String sReturn="",sReturn0="";
		String sFilePath=Thread.currentThread().getContextClassLoader().getResource("").getPath();
		sFilePath=sFilePath.substring(0,sFilePath.length()-8)+"pro"+System.getProperty("file.separator");
		if(sFilePath.equals(""))
			sFilePath="E:\\workspace\\ALS6\\WebRoot\\WEB-INF\\pro\\";
		
		//Trade001Ϊʵʱ�������001�����к��Ŀͻ��Ż�ȡ��Ȼ����г��˽���
		if(sTradeType.equals("Trade001")){
			String sValue[];
			//���Ŀͻ��ż��
			sReturn=GDTrade.runGDTrade(sObjectNo, sObjectType, "798001",Sqlca,sFilePath,"");
			sValue = sReturn.split("@");
			if(!sValue[0].equals("0000000")) return sReturn;
			
		}
		else{
			sReturn=GDTrade.runGDTrade(sObjectNo, sObjectType, sTradeType,Sqlca,sFilePath,"");
		}
		return (sReturn+sReturn0);
	}
}

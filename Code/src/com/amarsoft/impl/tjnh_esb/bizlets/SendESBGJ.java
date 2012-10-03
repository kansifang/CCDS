package com.amarsoft.impl.tjnh_esb.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * ����ESB����ҵ��Send����
 * ע�⣬�����ӿ�ʱ�����ĵ������ֵ����CODE-LIBRARY��Attribute1��
 * @author xhyong
 *
 */
public class SendESBGJ extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		if(sObjectType==null) sObjectType="";
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo==null) sObjectNo="";
		String sTradeType = (String)this.getAttribute("TradeType");
		if(sTradeType==null) sTradeType="";
		//��������
		String sReturn="",sReturn0="";
		
		//ִ�н���
		sReturn=ESBGJTrade.runESBGJTrade(sObjectNo, sObjectType, sTradeType,Sqlca,"");
		
		return (sReturn+sReturn0);
	}
}

package com.amarsoft.impl.tjnh_esb.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * 发送ESB国际业务Send程序
 * 注意，新增接口时，核心的数据字典放在CODE-LIBRARY的Attribute1中
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
		//反馈数据
		String sReturn="",sReturn0="";
		
		//执行交易
		sReturn=ESBGJTrade.runESBGJTrade(sObjectNo, sObjectType, sTradeType,Sqlca,"");
		
		return (sReturn+sReturn0);
	}
}

package com.amarsoft.impl.tjnh_als.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * 发送核心SendGD程序
 * 注意，新增接口时，核心的数据字典放在CODE-LIBRARY的Attribute1中
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
		//反馈数据
		String sReturn="",sReturn0="";
		String sFilePath=Thread.currentThread().getContextClassLoader().getResource("").getPath();
		sFilePath=sFilePath.substring(0,sFilePath.length()-8)+"pro"+System.getProperty("file.separator");
		if(sFilePath.equals(""))
			sFilePath="E:\\workspace\\ALS6\\WebRoot\\WEB-INF\\pro\\";
		
		//Trade001为实时交易组合001，进行核心客户号获取、然后进行出账交易
		if(sTradeType.equals("Trade001")){
			String sValue[];
			//核心客户号检查
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

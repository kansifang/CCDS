package com.amarsoft.impl.tjnh_esb.bizlets;


import spc.webos.data.CompositeNode;
import spc.webos.data.ICompositeNode;
import spc.webos.data.IMessage;
import spc.webos.data.Status;
import spc.webos.endpoint.ESB;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * ISS000000110出账取消
 * @author hldu
 * 发送 credAcctSeq-信贷出账流水号
 * 接收 flag-标志 0-不成功,1-成功
 */
public class ESBGJTradeISS000000110 implements ESBGJTradeInterface {
	public String runESBGJTrade(String sObjectNo,String sObjectType,String sTradeType,Transaction Sqlca,String sTradeDate){
	
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		if(sTradeType.equals("")) sTradeType = "ISS000000110";
		//定义变量
		String sReturn = "";         //此类的返回参数
		String sSql = "";			 //sql 语句
		String sBPSerialNo = "";	 //信贷出账流水号
		String sFlag = "";			 //成功失败标志0-不成功,1-成功
		String sMessage="";			 //返回报文信息
		ASResultSet rs = null;		 //sql游标
		String sContractSerialNo = ""; //合同流水号
		
		/******************************获取请求数据***********************************/
		sSql = " select BP.SerialNo as BPSerialNo,BP.ContractSerialNo " +
				" from BUSINESS_PUTOUT BP" +
				" where BP.SerialNo='"+sObjectNo+"' ";
		try{
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
		{ 
			sBPSerialNo = rs.getString("BPSerialNo");
			sContractSerialNo = rs.getString("ContractSerialNo");
		}
		rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		/*****************************设置请求报文**************************************/
		ESB esb = ESB.getInstance();
		spc.webos.data.Message reqmsg = esb.newMessage(); // 构造一个空报文
		// 以下是设置请求报文内容
		reqmsg.setMsgCd(sTradeType); 	// 设置此次请求的服务报文编号(必需)
		reqmsg.setRcvAppCd("ISS");		//	设置此次请求的接收系统编号（必需）
		reqmsg.setCallType ("SYN");		//	 调用方式SYN 表示同步调用
		//请求报文体
		reqmsg.setInRequest("credAcctSeq",sBPSerialNo);   //信贷出账流水号
		//打印请求报文
		System.out.println("req msg:请求报文"   + reqmsg.toXml(true));
		
		/******************************获取反馈报文*******************************/
		IMessage repmsg;
		try {
			repmsg = esb.execute(reqmsg);
			ICompositeNode body = repmsg.getBody();	// 获取报文体
			Status status = repmsg.getStatus();	
			sMessage=status.getDesc();
			ICompositeNode response = repmsg.getResponse();
			System.out.println("rep msg:应答报文"   + repmsg.toXml(true));
			sFlag =response.get("flag").toString();
			if(sFlag.equals("1"))
			{
				//如果为非循环合同就取消合同归档。
				Sqlca.executeSQL("Update BUSINESS_CONTRACT set PigeonholeDate=null where SerialNo='"+sContractSerialNo+"' and (CycleFlag <>'1' or CycleFlag is null) and PigeonholeDate is not null");
				//置发送标示为9
				Sqlca.executeSQL(sSql=" Update BUSINESS_PUTOUT set SendFlag='9' where SerialNo='"+sObjectNo+"'" );
				sReturn="0000000";
			}
			else
			{
				sReturn="["+sMessage+"]@["+sTradeType+"]交易失败，该客户在国结系统中没有找到对应的业务！";
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

		ESB.getInstance().destory();

		return sReturn;
	}
}

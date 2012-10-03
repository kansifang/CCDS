package com.amarsoft.impl.tjnh_esb.bizlets;


import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.PropertyConfigurator;

import spc.webos.data.CompositeNode;
import spc.webos.data.ICompositeNode;
import spc.webos.data.IMessage;
import spc.webos.data.Status;
import spc.webos.endpoint.ESB;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;
import com.amarsoft.impl.tjnh_als.bizlets.MFMessageBuilder;


/**
 * ISS000000100出账交易
 * @author hldu
 * 发送 credAcctSeq-信贷出账流水号,credCotSeq-信贷合同流水号,amt-出账金额,currType- 出账币种,bussClass-业务品种，bussConsNo-业务参考号
 *	   credNo-信用证编号,custNo-核心客户号,credDate-信用证效期,credPerdType-信用证期限类型,credPerd-信用证远期天数,nvcNo-发票号
 * 接收 flag-标志 0-不成功,1-成功
 */
public class ESBGJTradeISS000000100 implements ESBGJTradeInterface {
	public String runESBGJTrade(String sObjectNo,String sObjectType,String sTradeType,Transaction Sqlca,String sTradeDate){

		//获取参数：交易日期，交易编码
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		if(sTradeType.equals("")) sTradeType = "ISS000000100";
		
		//定义变量
		String sReturn = "" ;						//此类的返回值
		String sSql = "" ;							//sql语句
		String sBPSerialNo = "" ;					//信贷出账流水号
		String sBCSerialNo = "" ;					//信贷合同流水号
		String sCurrency = "" ;						//出账币种
		String sBusinessType = "" ;					//业务品种
		String sConsultNo = "";						//业务参考号
		String sOldLCNo = "" ;						//信用证编号
		String sMFCustomerID = "" ;					//核心客户号
		String sBusinessSubType = "" ;				//信用证期限类型
		String sInvoiceNo = "" ;					//发票号
		String sFlag="";							//成功失败标志0-不成功,1-成功
		String sOldLCValidDate = "";				//信用证效期
		Double dBusinessSum = 0.0;					//出账金额
		Double dContractSum = 0.0;					//出账合同金额
		int iGracePeriod =0;						//信用证远期天数
		ASResultSet rs = null;						//sql游标
		ASResultSet rs1 = null;						//sql游标
		String sMessage = "" ;						//反馈报文信息
		String sContractSerialNo = "";				//信贷合同流水号
		Double dPutOutTotalSum =0.0;				//出账总金额
		String sIsPigeonholeFlag ="";
		
		/******************************获取请求数据***********************************/
		sSql = " select BP.SerialNo as BPSerialNo,BC.SerialNo as BCSerialNo,BP.BusinessSum,"+
		        " getBankNo('Currency',BP.BusinessCurrency) as BusinessCurrency,BP.BusinessType,BP.ConsultNo,BC.LCNo,"+
		        " CI.MFCustomerID,BC.OldLCValidDate,BP.ContractSerialNo,"+
				" BC.BusinessSubType,BC.GracePeriod,BC.InvoiceNo,BP.ContractSum"+
				" from BUSINESS_CONTRACT BC,BUSINESS_PUTOUT BP,CUSTOMER_INFO CI" +
				" where BP.SerialNo='"+sObjectNo+"' and BP.CustomerID=CI.CustomerID and BP.ContractSerialNo=BC.SerialNo" ;
		try{
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
		{ 
			sBPSerialNo = rs.getString("BPSerialNo");
			sBCSerialNo = rs.getString("BCSerialNo");
			dBusinessSum = rs.getDouble("BusinessSum");
			sCurrency = rs.getString("BusinessCurrency");
			sBusinessType = rs.getString("BusinessType");
			sConsultNo = rs.getString("ConsultNo");
			sOldLCNo = rs.getString("LCNo");
			sMFCustomerID = rs.getString("MFCustomerID");
			sOldLCValidDate = rs.getString("OldLCValidDate");
			sBusinessSubType = rs.getString("BusinessSubType");
			iGracePeriod = rs.getInt("GracePeriod");
			sInvoiceNo = rs.getString("InvoiceNo");
			sContractSerialNo = rs.getString("ContractSerialNo");
			dContractSum=rs.getDouble("ContractSum");
		}
		
		if(sBPSerialNo==null) sBPSerialNo="  ";
		if(sBCSerialNo==null) sBCSerialNo="  ";
		if(sCurrency==null) sCurrency="  ";
		if(sBusinessType==null) sBusinessType="  ";
		if(sConsultNo==null) sConsultNo="  ";
		if(sOldLCNo==null) sOldLCNo="  ";
		if(sMFCustomerID==null) sMFCustomerID="  ";
		if(sBusinessSubType==null) sBusinessSubType="  ";
		if(!sBusinessSubType.equals("01")) sBusinessSubType="02";
		if(sInvoiceNo==null) sInvoiceNo="  ";
		if(sOldLCValidDate==null) sOldLCValidDate="  ";
		if(sContractSerialNo==null) sContractSerialNo="  ";
		
		sSql="  select SUM(BusinessSum) as PutOutTotalSum from BUSINESS_PUTOUT where ContractSerialNo='"+sContractSerialNo+"'";
		rs1=Sqlca.getResultSet(sSql);
		if(rs1.next()){
			dPutOutTotalSum=rs1.getDouble("PutOutTotalSum");
		}
		rs1.close();
		if(dPutOutTotalSum>=dContractSum)
		{
			sIsPigeonholeFlag="True";
		}
		
		rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		/*****************************设置请求报文**************************************/
		ESB esb = ESB.getInstance();
		spc.webos.data.Message reqmsg = esb.newMessage(); // 构造一个空报文
		// 以下是设置请求报文内容
		reqmsg.setMsgCd(sTradeType);    // 设置此次请求的服务报文编号(必需)
		reqmsg.setRcvAppCd("ISS");		//	设置此次请求的接收系统编号（必需）
		reqmsg.setCallType("SYN");		//	 调用方式SYN 表示同步调用
		//请求报文体
		reqmsg.setInRequest("credAcctSeq", sBPSerialNo);        //信贷出账流水号
		reqmsg.setInRequest("credCotSeq", sBCSerialNo);         //信贷合同流水号
		reqmsg.setInRequest("amt", dBusinessSum);               //出账金额      
		reqmsg.setInRequest("currType", sCurrency);             //出账币种      
		reqmsg.setInRequest("bussClass", sBusinessType);        //业务品种      
		reqmsg.setInRequest("bussConsNo", sConsultNo);          //业务参考号    
		reqmsg.setInRequest("credNo", sOldLCNo);                //信用证编号    
		reqmsg.setInRequest("custNo", sMFCustomerID);           //核心客户号    
		reqmsg.setInRequest("credDate", sOldLCValidDate.replace('/', '-'));       //信用证效期   
		reqmsg.setInRequest("credPerdType", sBusinessSubType);  //信用证期限类型
		reqmsg.setInRequest("credPerd", iGracePeriod);          //信用证远期天数
		reqmsg.setInRequest("nvcNo", sInvoiceNo);               //发票号        
		
		System.out.println("req msg:请求报文 " 	+ reqmsg.toXml(true));
		
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
				Sqlca.executeSQL(" Update BUSINESS_PUTOUT set SendFlag='1' where SerialNo='"+sObjectNo+"'" );
				//如果为非循环合同就直接合同归档。
				if("True".equals(sIsPigeonholeFlag))
				{
					Sqlca.executeSQL("Update BUSINESS_CONTRACT set PigeonholeDate='"+StringFunction.getToday()+"' where SerialNo='"+sContractSerialNo+"' and (CycleFlag is null or CycleFlag = '' or CycleFlag ='2')");
				}
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

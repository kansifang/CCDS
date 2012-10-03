package com.amarsoft.impl.tjnh_als.bizlets;


import java.io.UnsupportedEncodingException;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * 公积金组合贷款申请(6020)
 * @author xhyong
 * @date 2010-11-02
 *
 */
public class GDTrade6020 implements GDTradeInterface {
	public String runGDTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "6020";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		GDMessageBuilder mb = new GDMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",sOutMsgID="",BDSerialNo="";
		String BuildAgreement="",CooperateID="",sOrgID="",Cooperator="";
		String sContractSerialNo="",sAccumulationNo="",sCommercialNo="";
		ASResultSet rs,rs1=null;
		int iImpawnGuarantyCount=0,iPawnGuarantyCount=0,iAssurerCount=0;
		try{	
			/////////////商贷号和委贷号//////////////
			sSql = "select CommercialNo,AccumulationNo from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"' order by SerialNo desc";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				sCommercialNo = rs.getString("CommercialNo");
				if(sCommercialNo == null) sCommercialNo ="";
				sAccumulationNo = rs.getString("AccumulationNo");
				if(sAccumulationNo == null) sAccumulationNo ="";
			}
			rs.close();
			//-----------------组合报文----------------------
			try {
				// 从配置文件中读取数据,组成报文头
				sm.write(mb.setValue("WholeLength"));
				sm.write(mb.setValue("MessageType"));
				sm.write(mb.setValue("TradeCode",sTradeID));
				sm.write(mb.setValue("TradeDate",sTradeDate));
				sm.write(mb.setValue("SysDate",sTradeDate));
				sm.write(mb.setValue("TradeTime",StringFunction.getNow()));
				sm.write(mb.setValue("OrgID","909020000"));//取默认业务机构号
				sm.write(mb.setValue("TerminiterID"));
				sm.write(mb.setValue("UserID","908908"));//取默认信贷员编号
				sm.write(mb.setValue("TradeFlag"));
				sm.write(mb.setValue("TradeSerialNo",sObjectNo));//交易流水号
				sm.write(mb.setValue("Flag1"));
				sm.write(mb.setValue("Flag2"));
				sm.write(mb.setValue("Flag3"));
				sm.write(mb.setValue("Flag4"));
				sm.write(mb.setValue("ConfirmUserID","908908"));
				//以上为报文头部分，以下为报文体部分
				sm.write(mb.setValue("CommercialNo",sCommercialNo));//商贷贷款号
				sm.write(mb.setValue("AccumulationNo",sAccumulationNo));//委贷贷款号
				//报文体部分填充完毕
				sm.flush();
				mb.logger.debug("sOldTemp=" + mb.sOldTemp);
				mb.logger.debug("sNewTemp=" + mb.sNewTemp);
				mb.logger.debug("iLeng=" + mb.iLeng);
				mb.logger.info("["+sTradeID+"]发送成功！");
				// 读取返回包长
				byte[] pckbuf = new byte[4];
				sm.read(pckbuf);
				String s = new String(pckbuf, mb.CONV_CODESET);
				mb.logger.debug("Rcv_Head=" + s);
				int pcklen = Integer.parseInt(s);
				// 读取返回包
				byte[] revbuf = new byte[pcklen];
				sm.readFully(revbuf);
				mb.logger.info("["+sTradeID+"]返回数据=" + new String(revbuf, mb.CONV_CODESET));
				// 初始化xml对象
				//mb.initRcv(revbuf, pcklen);
				mb.initRcv_withCyc(revbuf, pcklen);//针对有循环的报文
				mb.logger.debug("["+sTradeID+"]交易标志TradeType（1成功，3失败）=" + mb.getValue("TradeType"));	
				//mb.getChild("BillGuaranty","BillGuaranty0","Attribute1");
				//mb.getValue("TradeType")
				if(mb.getValue("TradeType").equals("3")){
					sOutMsgID=mb.getValue("OutMsgID");
					String sOutMsg="";
					rs1=Sqlca.getASResultSet("select MsgBdy from GD_ErrCode where CodeNo='" + sOutMsgID+ "'");
					if(rs1.next())
						sOutMsg = rs1.getString(1);
					sReturn=sOutMsgID+"@"+sOutMsg;
					rs1.close();
					mb.logger.debug("["+sTradeID+"]错误代码OutMsgID=" + mb.getValue("OutMsgID") + " 错误信息="+sOutMsg);
				//Sqlca.executeSQL("update  business_contract set pigeonholedate =null where serialno='"+sContractSerialNo+"' ");
				}else if(mb.getValue("TradeType").equals("1")){
					insertGDMiddleTable(mb,Sqlca);
					mb.logger.debug("["+sTradeID+"]交易成功");
					sReturn="0000000@";
				}else
					sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！";
				// 短连接时要 关闭连接，长连接时不关闭
				sm.teardownConnection();
			} catch (Exception e) {
				sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！请联系系统管理员！";
				e.printStackTrace();
				sm.teardownConnection();
			}
		}catch(Exception ex){
			ex.printStackTrace();
			mb.logger.error(sSql+"["+sTradeID+"]执行出错!");
		}
		return sReturn;
	}
	public String insertGDMiddleTable(GDMessageBuilder mb,Transaction Sqlca){
		String sReturn="",sSql="";
		ASResultSet rs,rs1=null;
		int iImpawnGuarantyCount=0,iPawnGuarantyCount=0,iAssurerCount=0;
		//贷款信息插入中间表
		try {
			//删除业务中间表
			Sqlca.executeSQL("delete from GD_BUSINESSAPPLY where AccumulationNo = '"+mb.getValue("AccumulationNo")+"'");
			//删除担保中间表
			Sqlca.executeSQL("delete from GD_GUARANTYINFO where  AccumulationNo = '"+mb.getValue("AccumulationNo")+"'");
			
			sSql =  "insert into GD_BUSINESSAPPLY ( "+
						"CommercialNo, " + 
						"AccumulationNo, " +
						"MFCustomerID, " + 
						"CertType, " + 
						"CertID, " + 	
						"CustomerName, " +
						"BusinessType, " + 
						"BusinessCurrency, " + 
						"BusinessSum1, " + 	
						"BusinessSum2, " + 
						"TermMonth, " + 					
						"TermDay, " +
						"CorpusPayMethod, " +
						"PayCyc, " +				
						"PayDateType, " +
						"Type1, " +					
						"AccountNo, " +
						"InterestCType, " +
						"LoanType, " +
						"Type3, " +
						"Type2, " +
						"LoanAccountNo, " +
						"RateFloat1, " +
						"BaseRateType1, " +
						"RateFloat2, " +	
						"BaseRateType2, " +					
						"OverdueAddRate ," +	
						"InputOrgID, " +
						"OperateUserID, " +
						"InputUserID, " +
						"ImpawnGuarantyCount, " +
						"PawnGuarantyCount, " +
						"AssurerCount, " +
						
						"GDInputOrgID,"+
						"GDSerialNo,"+
						"sex,"+
						"RetireAge,"+
						"RetireLoanType,"+
						"IsLocalFlag,"+
						"EduDegree,"+
						"Occupation,"+
						"NativePlace,"+
						"FamilyAdd,"+
						"FamilyZIP,"+
						"FamilyTel,"+
						"MobileTelephone,"+
						"WorkCorp,"+
						"WorkAdd,"+
						"WorkZip,"+
						"WorkTel,"+
						"CommAdd,"+
						"ConsortInstanceFlag,"+
						"ConsortShareHouse,"+
						"ConsortName,"+
						"ConsortCertID,"+
						"ConsortOtherCertID,"+
						"ConsortTel,"+
						"ConsortWorkCorp,"+
						"ConsortWorkAdd,"+
						"ConsortWorkZip,"+
						"ConsortWorkTel,"+
						"ShareName1,"+
						"ShareCertID1,"+
						"ShareConsortName1,"+
						"ShareConsortCertID1,"+
						"ShareConsortSH1,"+
						"ShareName2,"+
						"ShareCertID2,"+
						"ShareConsortName2,"+
						"ShareConsortCertID2,"+
						"ShareConsortSH2,"+
						"CreditSource1,"+
						"CreditSource2,"+
						"CreditSource3,"+
						"CreditSource4,"+
						"CreditSource5,"+
						"CreditSource6,"+
						"CreditSource7,"+
						"CreditSource8,"+
						"CreditSource9,"+
						"CreditSource10,"+
						"CCreditSource1,"+
						"CCreditSource2,"+
						"CCreditSource3,"+
						"CCreditSource4,"+
						"CCreditSource5,"+
						"CCreditSource6,"+
						"CCreditSource7,"+
						"CCreditSource8,"+
						"CCreditSource9,"+
						"CCreditSource10,"+
						"BuyHouseUseType,"+
						"BuyContractNo,"+
						"HouseSeller,"+
						"SellOpenBank,"+
						"SellAccountNo,"+
						"BuyItemName,"+
						"BuyHouseAdd1,"+
						"BuyHouseAdd2,"+
						"BuyHouseAdd3,"+
						"BuyHouseAdd4,"+
						"BuyHouseAdd5,"+
						"BuildArea,"+
						"HousePrice,"+
						"SelfPrice,"+
						"SelfAccounts,"+
						"RightRate,"+
						"EvaluateValue,"+
						"BudgetValue,"+
						"IsUseConsortPact,"+
						"TermUseType,"+
						"MostTermMonth,"+
						"MostLoanValue,"+
						"TotalBusinessSum,"+
						"StartDate,"+
						"EndDate,"+
						"RiseFallRate,"+
						"MonthReturnSum,"+
						"CreditUseInfo,"+
						"OverdueTerms,"+
						"UnusualRecord,"+
						"OverdueTermsSum,"+
						"UnusualDeal,"+
						"ReCreditUseInfo,"+
						"ReOverdueTerms,"+
						"ReUnusualRecord,"+
						"ReOverdueTermsSum,"+
						"ReUnusualDeal,"+
						"VouchType,"+
						"LoanHappenDate "+
						
						") values("+
						"'"+mb.getValue("CommercialNo")+"',"+
						"'"+mb.getValue("AccumulationNo")+"',"+
						"'"+mb.getValue("MFCustomerID")+"',"+
						"'"+mb.getValue("CertType")+"',"+
						"'"+mb.getValue("CertID")+"',"+
						"'"+mb.getValue("CustomerName")+"',"+
						"'"+mb.getValue("BusinessType")+"',"+
						"'"+mb.getValue("BusinessCurrency")+"',"+
						""+Double.parseDouble(mb.getValue("BusinessSum1"))/10000.00+","+
						""+Double.parseDouble(mb.getValue("BusinessSum2"))/10000.00+","+
						""+mb.getValue("TermMonth")+","+
						""+mb.getValue("TermDay")+","+
						"'"+mb.getValue("CorpusPayMethod")+"',"+
						"'"+mb.getValue("PayCyc")+"',"+
						"'"+mb.getValue("PayDateType")+"',"+
						"'"+mb.getValue("Type1")+"',"+
						"'"+mb.getValue("AccountNo")+"',"+
						"'"+mb.getValue("InterestCType")+"',"+
						"'"+mb.getValue("LoanType")+"',"+
						"'"+mb.getValue("Type3")+"',"+
						"'"+mb.getValue("Type2")+"',"+
						"'"+mb.getValue("LoanAccountNo")+"',"+
						""+Double.parseDouble(mb.getValue("RateFloat1"))/10000.00+","+
						"'"+mb.getValue("BaseRateType1")+"',"+
						""+Double.parseDouble(mb.getValue("RateFloat2"))/10000.00+","+
						"'"+mb.getValue("BaseRateType2")+"',"+
						""+Double.parseDouble(mb.getValue("OverdueAddRate"))/10000.00+","+
						"'"+mb.getValue("InputOrgID")+"',"+
						"'"+mb.getValue("OperateUserID")+"',"+
						"'"+mb.getValue("InputUserID")+"',"+
						""+mb.getValue("ImpawnGuarantyCount")+","+
						""+mb.getValue("PawnGuarantyCount")+","+
						""+mb.getValue("AssurerCount")+","+
						
						"'"+mb.getValue("GDInputOrgID")+"',"+
						"'"+mb.getValue("GDSerialNo")+"',"+
						"'"+mb.getValue("sex")+"',"+
						"'"+mb.getValue("RetireAge")+"',"+
						"'"+mb.getValue("RetireLoanType")+"',"+
						"'"+mb.getValue("IsLocalFlag")+"',"+
						"'"+mb.getValue("EduDegree")+"',"+
						"'"+mb.getValue("Occupation")+"',"+
						"'"+mb.getValue("NativePlace")+"',"+
						"'"+mb.getValue("FamilyAdd")+"',"+
						"'"+mb.getValue("FamilyZIP")+"',"+
						"'"+mb.getValue("FamilyTel")+"',"+
						"'"+mb.getValue("MobileTelephone")+"',"+
						"'"+mb.getValue("WorkCorp")+"',"+
						"'"+mb.getValue("WorkAdd")+"',"+
						"'"+mb.getValue("WorkZip")+"',"+
						"'"+mb.getValue("WorkTel")+"',"+
						"'"+mb.getValue("CommAdd")+"',"+
						"'"+mb.getValue("ConsortInstanceFlag")+"',"+
						"'"+mb.getValue("ConsortShareHouse")+"',"+
						"'"+mb.getValue("ConsortName")+"',"+
						"'"+mb.getValue("ConsortCertID")+"',"+
						"'"+mb.getValue("ConsortOtherCertID")+"',"+
						"'"+mb.getValue("ConsortTel")+"',"+
						"'"+mb.getValue("ConsortWorkCorp")+"',"+
						"'"+mb.getValue("ConsortWorkAdd")+"',"+
						"'"+mb.getValue("ConsortWorkZip")+"',"+
						"'"+mb.getValue("ConsortWorkTel")+"',"+
						"'"+mb.getValue("ShareName1")+"',"+
						"'"+mb.getValue("ShareCertID1")+"',"+
						"'"+mb.getValue("ShareConsortName1")+"',"+
						"'"+mb.getValue("ShareCertID1")+"',"+
						"'"+mb.getValue("ShareConsortSH1")+"',"+
						"'"+mb.getValue("ShareName2")+"',"+
						"'"+mb.getValue("ShareCertID2")+"',"+
						"'"+mb.getValue("ShareConsortName2")+"',"+
						"'"+mb.getValue("ShareCertID2")+"',"+
						"'"+mb.getValue("ShareConsortSH2")+"',"+
						"'"+mb.getValue("CreditSource1")+"',"+
						"'"+mb.getValue("CreditSource2")+"',"+
						"'"+mb.getValue("CreditSource3")+"',"+
						"'"+mb.getValue("CreditSource4")+"',"+
						"'"+mb.getValue("CreditSource5")+"',"+
						"'"+mb.getValue("CreditSource6")+"',"+
						"'"+mb.getValue("CreditSource7")+"',"+
						"'"+mb.getValue("CreditSource8")+"',"+
						"'"+mb.getValue("CreditSource9")+"',"+
						"'"+mb.getValue("CreditSource10")+"',"+
						"'"+mb.getValue("CCreditSource1")+"',"+
						"'"+mb.getValue("CCreditSource2")+"',"+
						"'"+mb.getValue("CCreditSource3")+"',"+
						"'"+mb.getValue("CCreditSource4")+"',"+
						"'"+mb.getValue("CCreditSource5")+"',"+
						"'"+mb.getValue("CCreditSource6")+"',"+
						"'"+mb.getValue("CCreditSource7")+"',"+
						"'"+mb.getValue("CCreditSource8")+"',"+
						"'"+mb.getValue("CCreditSource9")+"',"+
						"'"+mb.getValue("CCreditSource10")+"',"+
						"'"+mb.getValue("BuyHouseUseType")+"',"+
						"'"+mb.getValue("BuyContractNo")+"',"+
						"'"+mb.getValue("HouseSeller")+"',"+
						"'"+mb.getValue("SellOpenBank")+"',"+
						"'"+mb.getValue("SellAccountNo")+"',"+
						"'"+mb.getValue("BuyItemName")+"',"+
						"'"+mb.getValue("BuyHouseAdd1")+"',"+
						"'"+mb.getValue("BuyHouseAdd2")+"',"+
						"'"+mb.getValue("BuyHouseAdd3")+"',"+
						"'"+mb.getValue("BuyHouseAdd4")+"',"+
						"'"+mb.getValue("BuyHouseAdd5")+"',"+
						"'"+mb.getValue("BuildArea")+"',"+
						"'"+mb.getValue("HousePrice")+"',"+
						"'"+mb.getValue("SelfPrice")+"',"+
						"'"+mb.getValue("SelfAccounts")+"',"+
						"'"+mb.getValue("RightRate")+"',"+
						"'"+mb.getValue("EvaluateValue")+"',"+
						"'"+mb.getValue("BudgetValue")+"',"+
						"'"+mb.getValue("IsUseConsortPact")+"',"+
						"'"+mb.getValue("TermUseType")+"',"+
						"'"+mb.getValue("MostTermMonth")+"',"+
						"'"+mb.getValue("MostLoanValue")+"',"+
						"'"+mb.getValue("TotalBusinessSum")+"',"+
						"'"+mb.getValue("StartDate")+"',"+
						"'"+mb.getValue("EndDate")+"',"+
						"'"+mb.getValue("RiseFallRate")+"',"+
						"'"+mb.getValue("MonthReturnSum")+"',"+
						"'"+mb.getValue("CreditUseInfo")+"',"+
						"'"+mb.getValue("OverdueTerms")+"',"+
						"'"+mb.getValue("UnusualRecord")+"',"+
						"'"+mb.getValue("OverdueTermsSum")+"',"+
						"'"+mb.getValue("UnusualDeal")+"',"+
						"'"+mb.getValue("ReCreditUseInfo")+"',"+
						"'"+mb.getValue("ReOverdueTerms")+"',"+
						"'"+mb.getValue("ReUnusualRecord")+"',"+
						"'"+mb.getValue("ReOverdueTermsSum")+"',"+
						"'"+mb.getValue("ReUnusualDeal")+"',"+
						"'"+mb.getValue("VouchType")+"',"+
						"'"+mb.getValue("LoanHappenDate")+"'"+
						")";
			Sqlca.executeSQL(sSql);	
			//抵质押物担保信息插入中间表
			iImpawnGuarantyCount=Integer.parseInt(mb.getValue("ImpawnGuarantyCount"));
			iPawnGuarantyCount=Integer.parseInt(mb.getValue("PawnGuarantyCount"));
			iAssurerCount=Integer.parseInt(mb.getValue("AssurerCount"));
			//质押循环
			while(iImpawnGuarantyCount>0){
				sSql =  "insert into GD_GUARANTYINFO ( "+
				"CommercialNo, " + 
				"AccumulationNo, " +
				"SequenceNumber, " + 
				"OwnerName, " + 
				"CertType, " + 	
				"CertID, " +
				"GuarantyType, " + 
				"GuarantyName, " + 
				"EvalCurrency, " + 	
				"GuarantyRightID, " + 			
				"AboutSum1, " +
				"AboutSum2, " +
				"GuarantyRate, " +				
				"GuarantyLocation, " +
				"InputUserID, " +					
				"InputDate, " +
				"EmergeDate, " +     
				"GuarantyContractNo, " +
				"GuarantyInfoFlag " +
				") values("+
				"'"+mb.getValue("CommercialNo")+"',"+
				"'"+mb.getValue("AccumulationNo")+"',"+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"SequenceNumber")+"',"+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"OwnerName")+"',"+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"CertType")+"',"+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"CertID")+"',"+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"GuarantyType")+"',"+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"GuarantyName")+"',"+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"EvalCurrency")+"',"+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"GuarantyRightID")+"',"+
				""+Double.parseDouble(mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"AboutSum1"))/10000.00+","+
				""+Double.parseDouble(mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"AboutSum2"))/10000.00+","+
				""+Double.parseDouble(mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"GuarantyRate"))/10000.00+","+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"GuarantyLocation")+"',"+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"InputUserID")+"',"+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"InputDate")+"',"+
				"'"+mb.getChild("ImpawnGuaranty","ImpawnGuaranty"+(iImpawnGuarantyCount-1),"EmergeDate")+"', "+	
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"GuarantyContractNo")+"', "+
				"'1'"+
				")";
				mb.logger.debug("质押"+sSql);
				Sqlca.executeSQL(sSql);
				iImpawnGuarantyCount = iImpawnGuarantyCount-1;
			}
			//抵押循环
			while(iPawnGuarantyCount>0){
				sSql =  "insert into GD_GUARANTYINFO ( "+
				"CommercialNo, " + 
				"AccumulationNo, " +
				"SequenceNumber, " + 
				"OwnerName, " + 
				"CertType, " + 	
				"CertID, " +
				"GuarantyType, " + 
				"GuarantyName, " + 	
				"GuarantyRightID, " + 				
				"AboutSum1, " +
				"AboutSum2, " +
				"GuarantyRate, " +				
				"GuarantyLocation, " +
				"InputUserID, " +					
				"InputDate, " +
				"EvalDate, " +
				"EvalorgName, " +
				"PolicyHoldFlag, " +
				"BenefitPerson1, " +
				"InsuranceID, " +
				"InsuranceBeginDate, " +
				"InsuranceEndDate, " +
				"ConfirmValue, " +	
				"OtherGuarantyRight, " +					
				"QualityStatus ," +	
				"GuarantyAmount, " +
				"GuarantyUsing, " +
				"InputDepartment, " +
				"GuarantyContractNo, " +   
				"GuarantyInfoFlag, " +
				
				"GuarantyRightID1, " +
				"ShareCustomerName, " +
				"ShareCertID, " +
				"ShareConsortName, " +
				"ShareConsortCertID, " +
				"ShareAddress, " +
				"SharePostalCode, " +
				"SharePhone " +
				
				") values("+
				"'"+mb.getValue("CommercialNo")+"',"+
				"'"+mb.getValue("AccumulationNo")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"SequenceNumber")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"OwnerName")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"CertType")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"CertID")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"GuarantyType")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"GuarantyName")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"GuarantyRightID")+"',"+
				""+Double.parseDouble(mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"AboutSum1"))/10000.00+","+
				""+Double.parseDouble(mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"AboutSum2"))/10000.00+","+
				""+Double.parseDouble(mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"GuarantyRate"))/10000.00+","+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"GuarantyLocation")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"InputUserID")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"InputDate")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"EvalDate")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"EvalorgName")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"PolicyHoldFlag")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"BenefitPerson1")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"InsuranceID")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"InsuranceBeginDate")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"InsuranceEndDate")+"',"+
				"'"+Double.parseDouble(mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"ConfirmValue"))/10000.00+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"OtherGuarantyRight")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"QualityStatus")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"GuarantyAmount")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"GuarantyUsing")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"InputDepartment")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"GuarantyContractNo")+"',"+
				"'2',"+
				
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"GuarantyRightID1")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"ShareCustomerName")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"ShareCertID")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"ShareConsortName")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"ShareConsortCertID")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"ShareAddress")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"SharePostalCode")+"',"+
				"'"+mb.getChild("PawnGuaranty","PawnGuaranty"+(iPawnGuarantyCount-1),"SharePhone")+"' "+
				
				")";
				mb.logger.debug("抵押"+sSql);
				Sqlca.executeSQL(sSql);
				iPawnGuarantyCount=iPawnGuarantyCount-1;
			}
			//担保人
			while(iAssurerCount>0){
				sSql =  "insert into GD_GUARANTYINFO ( "+
				"CommercialNo, " + 
				"AccumulationNo, " +
				"SequenceNumber, " + 
				"CustomerName, " + 
				"MFCustomerID, " + 
				"CertType, " + 	
				"CertID, " +
				"AssureAgreementFlag, " +
				"AssurerType, " +
				"GuarantyValue, " +
				"BeginDate, " +
				"EndDate, " +
				"InputOrgID, " +
				"GuarantyInfoFlag " +
				") values("+
				"'"+mb.getValue("CommercialNo")+"',"+
				"'"+mb.getValue("AccumulationNo")+"',"+
				"'"+mb.getChild("Assurer","Assurer"+(iAssurerCount-1),"SequenceNumber")+"',"+
				"'"+mb.getChild("Assurer","Assurer"+(iAssurerCount-1),"CustomerName")+"',"+
				"'"+mb.getChild("Assurer","Assurer"+(iAssurerCount-1),"MFCustomerID")+"',"+
				"'"+mb.getChild("Assurer","Assurer"+(iAssurerCount-1),"CertType")+"',"+
				"'"+mb.getChild("Assurer","Assurer"+(iAssurerCount-1),"CertID")+"',"+
				"'"+mb.getChild("Assurer","Assurer"+(iAssurerCount-1),"AssureAgreementFlag")+"',"+
				"'"+mb.getChild("Assurer","Assurer"+(iAssurerCount-1),"AssurerType")+"',"+
				""+Double.parseDouble(mb.getChild("Assurer","Assurer"+(iAssurerCount-1),"GuarantyValue"))/10000.00+","+
				"'"+mb.getChild("Assurer","Assurer"+(iAssurerCount-1),"BeginDate")+"',"+
				"'"+mb.getChild("Assurer","Assurer"+(iAssurerCount-1),"EndDate")+"',"+
				"'"+mb.getChild("Assurer","Assurer"+(iAssurerCount-1),"InputOrgID")+"',"+
				"'3'"+
				")";
				mb.logger.debug("保证"+sSql);
				Sqlca.executeSQL(sSql);
				iAssurerCount=iAssurerCount-1;
			}
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sReturn;
	}
}

/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --将合同基本信息复制到出帐中
		Input Param:
				ObjectType: 批复对象
				ObjectNo: 批复流水号
				UserID：用户代码
		Output Param:
				SerialNo：合同流水号
		HistoryLog:    lpzhang 增加出账表中证件号码和类型
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.util.*;
import com.amarsoft.context.*;

public class AddPutOutInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//获得合同对象
		String sObjectType = (String)this.getAttribute("ObjectType");
		//获得合同流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//获得业务品种
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//获得汇票编号
		String sBillNo = (String)this.getAttribute("BillNo");
		//获取当前用户
		String sUserID = (String)this.getAttribute("UserID");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sBillNo == null) sBillNo = "";
		if(sUserID == null) sUserID = "";
		
		//定义变量：出帐流水号
		String sSerialNo = "";
		//定义变量：出帐流水号字符串（@分隔）
		String sSerialNoStr = "";
		//定义变量：Sql语句
		String sSql = "";
		//定义变量：发生类型
		String sOccurType = "";
		//定义变量：交易代码
		String sExchangeType = "";	
		//定义变量：查询结果集
		ASResultSet rs = null;
		//定义变量：客户名称，证件类型，证件号码
		String sCustomerID="",sCertType="",sCertID="";
		//展期关联业务号
		String sDueBillSerialNo = "";
		//批复号
		String sGDCorpusPayMethod = "";//还款方式
		String sApprovalNo = "";
		//查询有多少笔出账
 		String sGDPayCyc = ""; //还款间隔
 		String sGDPayDateType = "";//还款日期确定方式
 		String sGDType1 = "";//还款账号类型
		int iPutOutCount = 0; 
		String sGDAccountNo = "";//还款账号
 		String sGDInterestCType = "";//利息计算标志
 		String sGDloanType = ""; //放款方式
 		String sGDType3 = "";//划款方向
 		String sGDType2 = "";//划款账号类型
 		String sGDLoanAccountNo = "";//划款账号
 		double dPracticeSum = 0.00;//实际用信
		//实例化用户对象
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		//根据合同流水号获取发生类型和客户编号
		
		sSql = "select CustomerID,OccurType from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sCustomerID = rs.getString("CustomerID");
			sOccurType = rs.getString("OccurType");
			//将空值转化为空字符串		
			if(sCustomerID == null) sCustomerID = "";
			if(sOccurType == null) sOccurType = "";
		}
		rs.getStatement().close();
		
		//----------------------获取客户编号和证件号码-------------
		sSql = "select CertID,CertType from Customer_Info where CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sCertID = rs.getString("CertID");
			sCertType = rs.getString("CertType");
			//将空值转化为空字符串		
			if(sCertID == null) sCertID = "";
			if(sCertType == null) sCertType = "";
		}
		rs.getStatement().close();
	/*modify by xhyong 2011/04/30
 		//根据业务品种获取交易代码
		sExchangeType = Sqlca.getString("select SubTypeCode from BUSINESS_TYPE where TypeNo='"+sBusinessType+"'");
		//将空值转化为空字符串
		if(sExchangeType == null) sExchangeType = "";
	*/
		//所有业务通知书公用一套模板
		sExchangeType="C000";
		if(sOccurType.equals("015")) //展期
		{
			//sExchangeType = "6201";
			//取得展期关联业务号
			sSql = "select ObjectNo from CONTRACT_RELATIVE where ObjectType = 'BusinessDueBill'  and SerialNo = '"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sDueBillSerialNo = rs.getString("ObjectNo");
				if(sDueBillSerialNo == null) sDueBillSerialNo = "";
			}
			rs.getStatement().close();
		}
		//生成批复号:
		//查询批复号,实际用信
		sSql = "select ApprovalNo,PracticeSum from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sApprovalNo = rs.getString("ApprovalNo");
			if(sApprovalNo == null) sApprovalNo = "";
			dPracticeSum = rs.getDouble("PracticeSum");
			
		}
		rs.getStatement().close();
		if(!"".equals(sApprovalNo))
		{
			//查询有多少放贷申请
			sSql = "select count(SerialNo) from BUSINESS_PUTOUT where ContractSerialNO = '"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				iPutOutCount = rs.getInt(1);
				sApprovalNo=sApprovalNo+"-"+(iPutOutCount+1);
			}
			rs.getStatement().close();
		}
		//当业务品种为银行承兑汇票贴现、商业承兑汇票贴现、协议付息票据贴现
		if(sBusinessType.equals("1020010") || sBusinessType.equals("1020020") || sBusinessType.equals("1020030"))
		{
			if(!sBillNo.equals("")) //将单张汇票信息拷贝到出帐中
			{
				sSql = 	" select * from BILL_INFO "+
						" where ObjectType = 'BusinessContract' "+
						" and ObjectNo = '"+sObjectNo+"' "+
						" and BillNo = '"+sBillNo+"' "+
						" and BillNo not in "+
						" (select BillNo from BUSINESS_PUTOUT "+
						" where ContractSerialNo = '"+sObjectNo+"')";				
			}else //将贴现合同项下的汇票信息拷贝到出帐中
			{
				sSql = 	" select * from BILL_INFO "+
						" where ObjectType = 'BusinessContract' "+
						" and ObjectNo = '"+sObjectNo+"' "+
						" and BillNo not in "+
						" (select BillNo from BUSINESS_PUTOUT "+
						" where ContractSerialNo = '"+sObjectNo+"')";	
			}
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
			{
				//获得出帐流水号
				sSerialNo = DBFunction.getSerialNo("BUSINESS_PUTOUT","SerialNo","BP",Sqlca);
				
				//将合同信息复制到出帐信息中
				sSql =  "insert into BUSINESS_PUTOUT ( "+
							"SerialNo, " + 
							"ExchangeType, " +
							"BillNo, " +
							"BillSum, " +
							"BusinessSum, " +
							"BusinessRate, " +
							"Maturity, " +
							"FixCyc, " +												
							"OperateOrgID, " + 
							"OperateUserID, " + 
							"OperateDate, " + 	
							"InputOrgID, " +
							"InputUserID, " + 
							"InputDate, " + 
							"UpdateDate, " + 	
							"ContractSerialNo, " + 
							"ArtificialNo, " + 					
							"CustomerID, " +
							"CustomerName, " +
							"BusinessType, " +				
							"BusinessCurrency, " +
							"ContractSum, " +					
							"TermYear, " +
							"TermMonth, " +
							"TermDay, " +
							"PutoutDate, " +
							"ICType, " +
							"ICCyc, " +
							"PayCyc, " +
							"AssureAgreement, " +					
							"CommunityAgreement ," +	
							"CorpusPayMethod, " +
							"CreditAggreement, " +
							"Purpose, " +
							"RateFloatType, " +
							"PdgSum, " +
							"PdgPayMethod, " +
							"ConsignAccountNo, " +
							"AccountNo, " +
							"LoanAccountNo, " +
							"SecondPayAccount, " +					
							"OccurDate, " +					
							"BaseRateType, " +
							"BaseRate, " +
							"RateFloat, " +
							"AdjustRateType, " +
							"AdjustRateTerm, " +
							"AcceptIntType, " +
							"OverIntType, " +
							"RateAdjustCyc, " +
							"GuarantyNo, " +
							"PdgAccountNo, " +
							"BailAccount, " +
							"FZANBalance, " +
							"BailCurrency, " +
							"BailRatio, " +
							"BailSum, " +
							"RiskRate, " +	
							"NationRisk, " +
							"PreIntType, " +
							"ResumeIntType, " +
							"OverdueRateFloat,"+
							"OverdueRate,"+
							"TARateFloat,"+
							"TARate, "+
							"ApprovalNo, "+
							"AFALoanFlag, "+
							"CommercialNo, "+
							"AccumulationNo, "+
							"ChangType, " +
							"ChangeReason,"+
							"ERateDate "+
							") "+
							"select "+ 
							"'"+sSerialNo+"', " + 
							"'"+sExchangeType+"', " +	
							"'"+rs.getString("BillNo")+"', " +
							""+rs.getDouble("BillSum")+", " +
							""+rs.getDouble("BillSum")+", " +
							""+rs.getDouble("Rate")+", " +
							"'"+rs.getString("Maturity")+"', " +							
							""+rs.getInt("EndorseTimes")+", " +	
							"'"+CurUser.OrgID+"', " + 
							"'"+CurUser.UserID+"', " + 
							"'"+StringFunction.getToday()+"', " + 
							"'"+CurUser.OrgID+"', " + 
							"'"+CurUser.UserID+"', " + 
							"'"+StringFunction.getToday()+"', " + 
							"'"+StringFunction.getToday()+"', " + 	
							"SerialNo, " + 
							"ArtificialNo, " + 					
							"CustomerID, " +
							"CustomerName, " +
							"BusinessType, " +				
							"BusinessCurrency, " +
							"BusinessSum, " +
							"TermYear, " +
							"TermMonth, " +
							"TermDay, " +
							"'', " +							
							"ICType, " +
							"ICCyc, " +
							"PayCyc, " +	
							"AssureAgreement, " +					
							"CommunityAgreement ," +	
							"'', " +//CorpusPayMethod 代码来源不一致 关闭复制 added by zrli
							"CreditAggreement, " +
							"Purpose, " +
							"RateFloatType, " +
							"PdgSum, " +
							"PdgPayMethod, " +
							"ThirdPartyAccounts, " +
							"AccountNo, " +
							"LoanAccountNo, " +
							"SecondPayAccount, " +
							"OccurDate, " +					
							"BaseRateType, " +
							"BaseRate, " +
							"RateFloat, " +
							"AdjustRateType, " +
							"AdjustRateTerm, " +
							"AcceptIntType, " +
							"OverIntType, " +
							"RateAdjustCyc, " +
							"GuarantyNo, " +
							"PdgAccountNo, " +
							"BailAccount, " +
							"PdgRatio, " + 
							"BailCurrency, " +
							"BailRatio, " +
							"BailSum, " + 
							"RiskRate, " +	
							"NationRisk, " +	
							"'0', " +
							"'1', " +
							"OverdueRateFloat,"+
							"OverdueRate,"+
							"TARateFloat,"+
							"TARate, "+
							"'"+sApprovalNo+"', "+
							"AFALoanFlag, "+
							"CommercialNo, "+
							"AccumulationNo, "+
							"ChangType, " +
							"ChangeReason,"+
							"ERateDate "+
							"from BUSINESS_CONTRACT " +
							"where SerialNo='"+sObjectNo+"'";
				Sqlca.executeSQL(sSql);	
				
				Sqlca.executeSQL("Update Business_Putout set CertID = '"+sCertID+"',CertType = '"+sCertType+"' where SerialNo ='"+sSerialNo+"'");
				if(sOccurType.equals("015")) //展期
				{
					//更新原账号
					Sqlca.executeSQL("Update Business_Putout set RelativeAccountNo = '"+sDueBillSerialNo+"' where SerialNo ='"+sSerialNo+"'");
				}
				sSerialNoStr = sSerialNoStr + sSerialNo + "@";
			}
			rs.getStatement().close();
		}else
		{			
			//获取合同可用金额
			Bizlet bzGetPutOutSum = new GetPutOutSum();
			bzGetPutOutSum.setAttribute("ContractSerialNo",sObjectNo); 
			bzGetPutOutSum.setAttribute("SerialNo","");				
			String sSurplusPutOutSum = (String)bzGetPutOutSum.run(Sqlca);
			
			//获得出帐流水号
			sSerialNo = DBFunction.getSerialNo("BUSINESS_PUTOUT","SerialNo","BP",Sqlca);
			
			//将合同信息复制到出帐信息中
			sSql =  "insert into BUSINESS_PUTOUT ( "+
						"SerialNo, " + 
						"ExchangeType, " +
						"OperateOrgID, " + 
						"OperateUserID, " + 
						"OperateDate, " + 	
						"InputOrgID, " +
						"InputUserID, " + 
						"InputDate, " + 
						"UpdateDate, " + 	
						"ContractSerialNo, " + 
						"ArtificialNo, " + 					
						"CustomerID, " +
						"CustomerName, " +
						"BusinessType, " +				
						"BusinessCurrency, " +
						"ContractSum, " +					
						"TermYear, " +
						"TermMonth, " +
						"TermDay, " +
						"PutoutDate, " +
						"Maturity, " +
						"BusinessRate, " +
						"ICType, " +
						"ICCyc, " +
						"PayCyc, " +	
						"AssureAgreement, " +					
						"CommunityAgreement ," +	
						"CorpusPayMethod, " +
						"CreditAggreement, " +
						"Purpose, " +
						"RateFloatType, " +
						"PdgSum, " +
						"PdgPayMethod, " +
						"ConsignAccountNo, " +
						"AccountNo, " +
						"LoanAccountNo, " +
						"SecondPayAccount, " +					
						"OccurDate, " +					
						"BaseRateType, " +
						"BaseRate, " +
						"RateFloat, " +
						"AdjustRateType, " +
						"AdjustRateTerm, " +
						"AcceptIntType, " +
						"OverIntType, " +
						"RateAdjustCyc, " +
						"GuarantyNo, " +
						"PdgAccountNo, " +
						"BailAccount, " +
						"FZANBalance, " +
						"BailCurrency, " +
						"BailRatio, " +
						"BailSum, " + 
						"RiskRate, " +	
						"NationRisk, " +	
						"VouchType, " +	
						"BusinessSum, " +
						"PreIntType, " +						
						"ResumeIntType, " +
						"OverdueRateFloat,"+
						"OverdueRate,"+
						"TARateFloat,"+
						"TARate," +
						"ApprovalNo, "+
						"AFALoanFlag, "+
						"CommercialNo, "+
						"AccumulationNo, "+
						"ChangType, " +
						"ChangeReason,"+
						"ERateDate "+
						") "+
						"select "+ 
						"'"+sSerialNo+"', " + 
						"'"+sExchangeType+"', " +					
						"'"+CurUser.OrgID+"', " + 
						"'"+CurUser.UserID+"', " + 
						"'"+StringFunction.getToday()+"', " + 
						"'"+CurUser.OrgID+"', " + 
						"'"+CurUser.UserID+"', " + 
						"'"+StringFunction.getToday()+"', " + 
						"'"+StringFunction.getToday()+"', " + 	
						"SerialNo, " + 
						"ArtificialNo, " + 					
						"CustomerID, " +
						"CustomerName, " +
						"BusinessType, " +				
						"BusinessCurrency, " +
						"BusinessSum, " +
						"TermYear, " +
						"TermMonth, " +
						"TermDay, " +
						"PutoutDate, " +
						"Maturity, " +
						"BusinessRate, " +
						"ICType, " +
						"ICCyc, " +
						"PayCyc, " +
						"AssureAgreement, " +					
						"CommunityAgreement ," +	
						"'', " +//CorpusPayMethod 代码来源不一致 关闭复制 added by zrli
						"CreditAggreement, " +
						"Purpose, " +
						"RateFloatType, " +
						"PdgSum, " +
						"PdgPayMethod, " +
						"ThirdPartyAccounts, " +
						"AccountNo, " +
						"LoanAccountNo, " +
						"SecondPayAccount, " +
						"OccurDate, " +					
						"BaseRateType, " +
						"BaseRate, " +
						"RateFloat, " +
						"AdjustRateType, " +
						"AdjustRateTerm, " +
						"AcceptIntType, " +
						"OverIntType, " +
						"RateAdjustCyc, " +
						"GuarantyNo, " +
						"PdgAccountNo, " +
						"BailAccount, " +
						"PdgRatio, " +
						"BailCurrency, " +
						"BailRatio, " +
						"BailSum, " + 
						"RiskRate, " +	
						"NationRisk, " +	
						"VouchType, " +	
						""+sSurplusPutOutSum+", " +
						"'0', " +
						"'1', " +
						"OverdueRateFloat,"+
						"OverdueRate,"+
						"TARateFloat,"+
						"TARate," +
						"'"+sApprovalNo+"', "+
						"AFALoanFlag, "+
						"CommercialNo, "+
						"AccumulationNo, "+
						"ChangType, " +
						"ChangeReason,"+
						"ERateDate "+
						"from BUSINESS_CONTRACT " +
						"where SerialNo='"+sObjectNo+"'";
			Sqlca.executeSQL(sSql);	
			
			Sqlca.executeSQL("Update Business_Putout set CertID = '"+sCertID+"',CertType = '"+sCertType+"',PutOutOrgID = '"+CurUser.OrgID+"' where SerialNo ='"+sSerialNo+"'");
			if(sOccurType.equals("015")) //展期
			{
				//更新原账号
				Sqlca.executeSQL("Update Business_Putout set RelativeAccountNo = '"+sDueBillSerialNo+"' where SerialNo ='"+sSerialNo+"'");
			}
			//公积金初始化出账信息:
			if(sBusinessType.equals("1110027")||sBusinessType.equals("2110020"))
			{
				//查询公积金系统传过来的中间表信息
				sSql =  " select getFromGDCode('GDCorpusPayMethod',CorpusPayMethod,'') as CorpusPayMethod," +
						"getFromGDCode('GDPayCyc',PayCyc,'') as PayCyc,PayDateType," +
						"getFromGDCode('GDAccountType',Type1,'') as Type1," +
						"AccountNo,InterestCType,loanType," +
						"getFromGDCode('GDPayDirection',Type3,'') as Type3," +
						"getFromGDCode('GDAccountType',Type2,'') as Type2," +
						"LoanAccountNo from GD_BUSINESSAPPLY GB"+
						" where Exists(select 1 from BUSINESS_PUTOUT where " +
						//"CommercialNo =GB.CommercialNo and " +
						"AccumulationNo=GB.AccumulationNo and SerialNo='"+sSerialNo+"') ";
				rs = Sqlca.getASResultSet(sSql);		
				if(rs.next())
				{
					sGDCorpusPayMethod =  rs.getString("CorpusPayMethod");//还款方式
					sGDPayCyc =  rs.getString("PayCyc"); //还款间隔
					sGDPayDateType = "";//还款日期确定方式
					sGDType1 =  rs.getString("Type1");//还款账号类型
					sGDAccountNo = rs.getString("AccountNo");//还款账号
					sGDInterestCType = "";//利息计算标志
					sGDloanType = ""; //放款方式
					sGDType3 = rs.getString("Type3");//划款方向
					sGDType2 = rs.getString("Type2");//划款账号类型
					sGDLoanAccountNo = rs.getString("LoanAccountNo");//划款账号
				}
				rs.getStatement().close();
				//更新
				Sqlca.executeSQL("Update Business_Putout set " +
						"CorpusPayMethod = '"+sGDCorpusPayMethod+"', " +
						"PayCyc = '"+sGDPayCyc+"', " +
						"Type3 = '"+sGDType3+"', " +
						"Type1 = '"+sGDType1+"', " +
						"AccountNo = '"+sGDAccountNo+"', " +
						"Type2 = '"+sGDType2+"', " +
						"LoanAccountNo = '"+sGDLoanAccountNo+"' " +						
						"where SerialNo ='"+sSerialNo+"'");
			}
			//针对进口信用证
			if("2050030".equals(sBusinessType)) 
			{
				//更新出账金额为实际用信
				Sqlca.executeSQL("Update Business_Putout set BusinessSum = "+dPracticeSum+" where SerialNo ='"+sSerialNo+"'");
			}
			sSerialNoStr = sSerialNoStr + sSerialNo + "@";
		}
		
		return sSerialNoStr;
	}	
}

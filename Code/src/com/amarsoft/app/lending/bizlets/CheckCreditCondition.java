/*
		Author: --lpzhang 2009-8-24
		Tester:
		Describe: --检查客户是否有办理此业务的权限
		Input Param:
				BusinessType:业务品种
				CustomID：客户编号
		Output Param:
				
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckCreditCondition extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{

		//获得客户编号
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//获得业务品种
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//获得发生方式
		String sOccurType = (String)this.getAttribute("OccurType");
		//获得关联协议
		String sRelativeAgreement = (String)this.getAttribute("RelativeAgreement");
		//获取申请类型
		String sApplyType = (String) this.getAttribute("ApplyType");
		//将空值转化成空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		if(sRelativeAgreement == null) sRelativeAgreement = "";
		if(sApplyType == null) sApplyType = "";
		
		//定义变量：Sql语句
		String sSql = "";
		//定义变量：查询结果集
		ASResultSet rs = null;
		//定义返回变量
		String sReturn = "PASS";//通过
		//客户类别,是否信用户
		String sIndRPRType = "",sFIsCredited ="";
		int NumTemp =0,iNum=0;
		
		if(sBusinessType.equals("1140130"))//城区信用共同体内信用商户贷款
		{
			String sGTTID = "";
			sSql = "select CustomerID from CUSTOMER_RELATIVE where RelationShip like '0701%'  and RelativeID='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				sGTTID = rs.getString(1);
			if(sGTTID == null) sGTTID =  "";
			rs.getStatement().close();
			
			if(sGTTID.equals("")){
				sReturn = "该客户不是城区信用共同体，不能办理此业务！";
			}else
			{
				String sSuperCertType="";
				sSuperCertType = Sqlca.getString("select SuperCertType from ENT_INFO where CustomerID = '"+sGTTID+"' ");
				if(!sSuperCertType.equals("010"))
				{
					sReturn = "该客户不是城区信用共同体，不能办理此业务！";
				}
			}
			String sCreditLevel = Sqlca.getString("select CGALevel from CUSTOMER_RELATIVE where CustomerID='"+sGTTID+"'and RelationShip like '0701%'");
			//sCreditLevel = Sqlca.getString("select CreditLevel from IND_INFO where CustomerID = '"+sCustomerID+"'");
			if(sCreditLevel == null) sCreditLevel="";
			if("".equals(sCreditLevel))
			{
				sReturn = "该客户没有信用评级，不能办理此业务！";
			}
				
		}
		
		//对于农户特色贷款
		if(sBusinessType.startsWith("1150"))
		{
			//取得该客户是否农户,是否信用户
			sSql ="select IndRPRType,FIsCredited from IND_INFO where CustomerID ='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sIndRPRType = rs.getString("IndRPRType");
				sFIsCredited = rs.getString("FIsCredited");
				if(sIndRPRType == null) sIndRPRType="";
				if(sFIsCredited == null) sFIsCredited="";
			}
			rs.getStatement().close();
			
			if("010".equals(sIndRPRType))//农户
			{
				if(sBusinessType.equals("1150050"))//农村信用共同体内农户贷款
				{
					sSql = "select count(*) from CUSTOMER_RELATIVE where RelationShip like '0701%'  and RelativeID='"+sCustomerID+"'";
					rs = Sqlca.getASResultSet(sSql);
					if(rs.next())
						 NumTemp = rs.getInt(1);
					
					rs.getStatement().close();
					
					if(NumTemp == 0)
						sReturn = "该客户不是信用共同体成员，不能办理此业务！";
				}
				
				if(sBusinessType.equals("1150020"))//农户联保贷款
				{
					//sSql = "select count(*) from CUSTOMER_RELATIVE where RelationShip like '0501%'  and RelativeID='"+sCustomerID+"'";
					sSql = "select count(*) from CUSTOMER_RELATIVE where customerID in(select CustomerID from CUSTOMER_RELATIVE where RelationShip like '0501%'  and RelativeID='"+sCustomerID+"')";
					rs = Sqlca.getASResultSet(sSql);
					if(rs.next())
						 NumTemp = rs.getInt(1);
					
					rs.getStatement().close();
					
					if(NumTemp == 0)
					{
						sReturn = "该客户不是农户联保小组成员，不能办理此业务！";
					}
					if(!sFIsCredited.equals("1"))
					{
						sReturn = "该客户不是信用户，不能办理此业务！";
					}
				}
				
				
			}
		}
		//复审,已经出账审批通过的业务不允许复审
		if(sOccurType.equals("090")){
			sSql = " select count(*) from Business_Apply where RelativeAgreement='"+sRelativeAgreement+"'" +
				   " and OccurType = '090'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){	
				 NumTemp = rs.getInt(1);
			}
			rs.getStatement().close();
			
			if(NumTemp > 0){
				sReturn = "该业务已经被复审，不能再次提起复审！";
			}else
			{
				sSql = " select count(*) from Business_Contract BC,Business_PutOut BP,Flow_Object FO" +
					   " where BC.SerialNo = BP.ContractSerialNo and FO.ObjectNo = BP.SerialNo and FO.ObjectType ='PutOutApply' " +
					   " and FO.PhaseType ='1040' and BC.RelativeSerialNo ='"+sRelativeAgreement+"'  ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
					 NumTemp = rs.getInt(1);
				
				rs.getStatement().close();
				
				if(NumTemp > 0)
					sReturn = "需要复审的业务已经出账审批通过，不能进行复审！";
			}
		}
		
		//------------该客户有逾期金额（合同到期且有业务余额）或欠息金额，则不能办理额度项下业务申请------------------
		if(sApplyType.equals("DependentApply"))
		{
			sSql = " select nvl(sum(nvl(NormalBalance,0) + nvl(OverDueBalance,0)+nvl(DullBalance,0)+nvl(InterestBalance1,0)+nvl(InterestBalance1,0) ),0) as SpecialBalance " +
				   " from Business_Contract where BusinessType not like '30%' and CustomerID ='"+sCustomerID+"' and (FinishDate = '' and FinishDate is null) ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum > 0)
				sReturn  += "该客户存在逾期或者欠息金额，不能办理额度项下业务！";
			
		}
	
		return sReturn;
	}
		
}

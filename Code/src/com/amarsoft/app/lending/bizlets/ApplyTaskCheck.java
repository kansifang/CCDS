/*
		Author: --lpzhang2009-8-17
		Tester:
		Describe: --流程判断
		Input Param:
				ObjectNo:对象流水号
				BusinessType：对象类型
				Flag ：参数类型（1、是否国际业务，2、是否超资本金）
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;


public class ApplyTaskCheck extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{

		//获得对象流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//获得对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//参数类型
		String sFlag = (String)this.getAttribute("Flag");
		//将空值转化成空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sFlag == null) sFlag = "";
		
		//定义变量：Sql语句
		String sSql = "";
		//发起机构
		String sOperateOrgID ="",sCustomerID="",sBusinessType="",sApplyType ="",sCustomerType ="", sCreditAggreement="",
			sCommunityAgreement = "";
		
		String sApplySerialNo = "",sOrgFlag="",sContractNo="";
		String sManageOrgID = "";//管户机构
		//申请金额
		double dBusinessSum =0.0, dBalanceSum =0.0,dOpenBusinessSum = 0.0,dOpenBalanceSum=0.0,dOpenPutOutBusinessSum=0.0;
		//定义变量：查询结果集
		ASResultSet rs = null; ASResultSet rsTemp = null;
		String sRelativeOrgID = "";//上级机构名
		double dNetCapital =0.0;//上级机构资本金
		//定义返回变量
		String sResult = "";
		System.out.println("sObjectType:"+sObjectType+"&sObjectNo:"+sObjectNo+"*sFlag:"+sFlag+"OWWWQWWO"+sObjectType.equals("CreditApply"));
		if(sObjectType.equals("CreditApply"))
		{
			//取得申请信息
			sSql = " select BusinessType,Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum," +
					" nvl(BailRatio,0)*0.01 as BailRatio,"+
				   " CustomerID,getCustomerType(CustomerID) as CustomerType,ApplyType,OperateOrgID from Business_Apply where SerialNo ='"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sBusinessType = rs.getString("BusinessType");
				sOperateOrgID = rs.getString("OperateOrgID");
				dBusinessSum = rs.getDouble("BusinessSum");
				dOpenBusinessSum = dBusinessSum*(1-rs.getDouble("BailRatio"));
				sCustomerID = rs.getString("CustomerID");
				sApplyType = rs.getString("ApplyType");
				sCustomerType = rs.getString("CustomerType");
				if(sBusinessType == null) sBusinessType ="";
				if(sOperateOrgID == null) sOperateOrgID ="";
				if(sCustomerID == null) sCustomerID ="";
				if(sApplyType == null) sApplyType ="";
				if(sCustomerType == null) sCustomerType ="";
			}
			rs.getStatement().close();
			
			//发起机构的上级机构名和资本金信息
			sSql = "select Nvl(NetCapital,0) as NetCapital,OrgID from Org_Info where OrgID = (select RelativeOrgID from Org_Info where OrgID='"+sOperateOrgID+"') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dNetCapital = rs.getDouble("NetCapital");
				sRelativeOrgID = rs.getString("OrgID");
				if(sRelativeOrgID == null) sRelativeOrgID ="";
			}
			rs.getStatement().close();
			System.out.println("dNetCapital"+dNetCapital);	
		}
		if(sObjectType.equals("PutOutApply"))
		{
			//取得申请信息
			sSql = " select SerialNo,RelativeSerialNo,BusinessType,OperateOrgID,Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum," +
					" nvl(BailRatio,0)*0.01 as BailRatio,"+
				   " CustomerID,getCustomerType(CustomerID) as CustomerType,ApplyType," +
				   " CreditAggreement,CommunityAgreement,ManageOrgID " +
				   " from Business_Contract where SerialNo = " +
				   " (select ContractSerialNo from Business_Putout where SerialNo = '"+sObjectNo+"')";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sContractNo = rs.getString("SerialNo");
				sApplySerialNo = rs.getString("RelativeSerialNo");
				sBusinessType = rs.getString("BusinessType");
				sOperateOrgID = rs.getString("OperateOrgID");
				dBusinessSum = rs.getDouble("BusinessSum");
				dOpenBusinessSum = dBusinessSum*(rs.getDouble("BailRatio"));
				sCustomerID = rs.getString("CustomerID");
				sApplyType = rs.getString("ApplyType");
				sCustomerType = rs.getString("CustomerType");
				sCreditAggreement = rs.getString("CreditAggreement");
				sCommunityAgreement = rs.getString("CommunityAgreement");
				sManageOrgID = rs.getString("ManageOrgID");
				if(sBusinessType == null) sBusinessType ="";
				if(sOperateOrgID == null) sOperateOrgID ="";
				if(sCustomerID == null) sCustomerID ="";
				if(sApplyType == null) sApplyType ="";
				if(sCustomerType == null) sCustomerType ="";
				if(sCreditAggreement == null) sCreditAggreement ="";
				if(sCommunityAgreement == null) sCommunityAgreement ="";
				if(sManageOrgID == null) sManageOrgID ="";
			}
			rs.getStatement().close();
			if(!"".equals(sCreditAggreement)){
				sApplySerialNo = Sqlca.getString("select RelativeSerialNo from Business_Contract where Serialno = '"+sCreditAggreement+"'");
				if(sApplySerialNo == null) sApplySerialNo = "";
			}else if(!"".equals(sCommunityAgreement))//信用共同体体额度已额度终审机构做标示
			{
				sApplySerialNo = Sqlca.getString("select RelativeSerialNo from Business_Contract where Serialno = '"+sCommunityAgreement+"'");
				if(sApplySerialNo == null) sApplySerialNo = "";
			}
			sOrgFlag = Sqlca.getString("Select OrgFlag From Business_Apply Where SerialNo ='"+sApplySerialNo+"'");
			if(sOrgFlag==null) sOrgFlag="";
			//取得出账申请信息
			sSql = " select Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as PutOutBusinessSum,nvl(BailRatio,0)*0.01 as BailRatio "+
			" from Business_PutOut where SerialNo = '"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dOpenPutOutBusinessSum = rs.getDouble("PutOutBusinessSum")*(1-rs.getDouble("BailRatio"));
			}
			rs.getStatement().close();
			
			//发起机构的上级机构名和资本金信息
			sSql = "select Nvl(NetCapital,0) as NetCapital,OrgID from Org_Info where OrgID = (select RelativeOrgID from Org_Info where OrgID='"+sManageOrgID+"') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dNetCapital = rs.getDouble("NetCapital");
				sRelativeOrgID = rs.getString("OrgID");
				if(sRelativeOrgID == null) sRelativeOrgID ="";
			}
			rs.getStatement().close();
			System.out.println("dNetCapital"+dNetCapital);
			
		}
		
		if(sObjectType.equals("CreditApply"))
		{
			//是否国际贸易
			if(sFlag.equals("1"))
			{
				if(sBusinessType.startsWith("1080") || sBusinessType.startsWith("1090")||sBusinessType.startsWith("2050") )
				{
					sResult ="TRUE";
				}else
				{
					sResult ="FALSE";
				}
					
			}
			//单一法人是否超资本金（支行信用社取区县金额资本金，直属支行取市合行资本金）
			if(sFlag.equals("2"))
			{
				//历史余额---是否要加上流程中的和等级合同未放款的 dOpenBalanceSum
				sSql ="select nvl(sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)),0) as BalanceSum, "+
				"nvl(sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)*nvl(BailRatio,0)*0.01),0) as BailBalanceSum "+
				" from Business_Contract where CustomerID ='"+sCustomerID+
				"' and (FinishDate='' or FinishDate is null) and BusinessType not like '30%'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					dBalanceSum = rs.getDouble("BalanceSum");
					dOpenBalanceSum = dBalanceSum-rs.getDouble("BailBalanceSum");
				}
				rs.getStatement().close();
				double dTotalSum = dOpenBalanceSum+dOpenBusinessSum;
				System.out.println("dBalanceSum"+dOpenBalanceSum+"dOpenBusinessSum"+dOpenBusinessSum);
				
				//资本金比较
				if(dTotalSum*10>dNetCapital)
					sResult = "TRUE";
				else
					sResult = "FALSE";
				
			}
			
			//机构发起级别sResult='030' 为直属支行 ，020 为区县支行
			if(sFlag.equals("3"))
			{
				 sSql = "select getOrgFlag(OrgID) from Org_Info where OrgID ='"+sOperateOrgID+"'";
				 sResult = Sqlca.getString(sSql);
				 if(sResult == null) sResult ="";
			}
			
			//集团是否超资本金（支行信用社取区县金额资本金，直属支行取市合行资本金）
			if(sFlag.equals("4"))
			{
			
				double dBalanceTotal=0.0;//所有成员余额
				
				//集团所有客户在本行历史余额---是否要加上流程中的和等级合同未放款的
				String RelativeID ="";
				sSql ="select RelativeID from Customer_Relative where CustomerID in (select CustomerID from Customer_Relative where RelativeID = '"+sCustomerID+"')";
				rs = Sqlca.getASResultSet(sSql);
				while(rs.next())
				{
					RelativeID = rs.getString("RelativeID");
					if(RelativeID == null) RelativeID="";
					
					String sSql1 = " select NVL(Sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)),0) as BalanceSum,"+
								   " NVL(Sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)*nvl(BailRatio,0)*0.01),0) as BailBalanceSum "+
								   " from Business_Contract" +
								   " where CustomerID ='"+RelativeID+"' and BusinessType not like '30%' and operateOrgID in " +
								   " (select BelongOrgID from Org_Belong where OrgID ='"+sRelativeOrgID+"')";
					rsTemp = Sqlca.getASResultSet(sSql1);
					if(rsTemp.next())
					{
						dBalanceSum = rsTemp.getDouble(1);
						dOpenBalanceSum = dBalanceSum-rsTemp.getDouble(2);
					}
					rsTemp.getStatement().close();
					
					dBalanceTotal = dBalanceTotal +dOpenBalanceSum;
				} 
				rs.getStatement().close();
				
				double dTotalSum = dBalanceTotal+dOpenBusinessSum;
				System.out.println("dBalanceSum"+dOpenBalanceSum+"&dOpenBusinessSum"+dOpenBusinessSum+"&dTotalSum"+dTotalSum);
				System.out.println("dNetCapital*0.15"+dNetCapital*0.15);
				if(dTotalSum>dNetCapital*0.15)
					sResult = "TRUE";
				else
					sResult = "FALSE";
				
			}
			
			//更新信用等级评估
			if(sFlag.equals("5"))
			{
				String sSerialNo ="";
				
				sSql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='Customer' "+
				       " and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by SerialNo desc fetch first 1 rows only ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					sSerialNo = rs.getString("SerialNo");
					if(sSerialNo == null) sSerialNo ="";
				}
				rs.getStatement().close();
				
				if(!"".equals(sSerialNo))
				{
					AmarInterpreter interpreter = new AmarInterpreter();
				    interpreter.explain(Sqlca,"!WorkFlowEngine.FinishEvaluateBA("+sObjectType+","+sSerialNo+","+sObjectNo+")");
				}
				
			}
			
			//更新协议
			if(sFlag.equals("7"))
			{
				String sEntAgreementNo ="";
				/*if(sBusinessType.equals("3020"))//工程机械
				{
				    sEntAgreementNo = Sqlca.getString("select ObjectNo from Apply_Relative where SerialNo ='"+sObjectNo+"' and ObjectType ='ProjectAgreement' ");
					if(sEntAgreementNo == null) sEntAgreementNo="";
					if(!"".equals(sEntAgreementNo))
					{
						Sqlca.executeSQL("update Ent_Agreement set FreezeFlag ='1' where SerialNo ='"+sEntAgreementNo+"' and  AgreementType ='ProjectAgreement' and (FreezeFlag is null or FreezeFlag ='') ");
					}
				}*/
				if(sBusinessType.startsWith("1050"))//房地产开发、土地开发贷款（楼宇按揭协议）
				{
					sSql = "select ObjectNo from Apply_Relative where SerialNo ='"+sObjectNo+"' and ObjectType ='BuildAgreement' ";
					rs = Sqlca.getASResultSet(sSql);
					if(rs.next())
					{
						sEntAgreementNo = rs.getString("ObjectNo");
						if(sEntAgreementNo == null) sEntAgreementNo="";
						Sqlca.executeSQL("update Ent_Agreement set FreezeFlag ='1' where SerialNo ='"+sEntAgreementNo+"' and  AgreementType ='BuildAgreement' and (FreezeFlag is null or FreezeFlag ='')");
					}
					rs.getStatement().close();
					
				}
				
				
			}
		}
		if(sObjectType.equals("PutOutApply"))
		{
			//单一法人是否超资本金（支行信用社取区县金额资本金，直属支行取市合行资本金）
			if(sFlag.equals("2"))
			{
				//历史余额---是否要加上流程中的和等级合同未放款的 dOpenBalanceSum
				sSql ="select nvl(sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)),0) as BalanceSum, "+
				"nvl(sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)*nvl(BailRatio,0)*0.01),0) as BailBalanceSum "+
				" from Business_Contract where CustomerID ='"+sCustomerID+
				"' and (FinishDate='' or FinishDate is null) and BusinessType not like '30%'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					dBalanceSum = rs.getDouble("BalanceSum");
					dOpenBalanceSum = dBalanceSum-rs.getDouble("BailBalanceSum");
				}
				rs.getStatement().close();
				double dTotalSum = dOpenBalanceSum+dOpenPutOutBusinessSum;
				System.out.println("dBalanceSum"+dOpenBalanceSum+"dOpenBusinessSum"+dOpenBusinessSum);
				
				//资本金比较
				if(dTotalSum*10>dNetCapital)
					sResult = "TRUE";
				else
					sResult = "FALSE";
				
			}
			
			//集团是否超资本金（支行信用社取区县金额资本金，直属支行取市合行资本金）
			if(sFlag.equals("4"))
			{
				double dBalanceTotal=0.0;//所有成员余额
				
				//集团所有客户在本行历史余额---是否要加上流程中的和等级合同未放款的
				String RelativeID ="";
				sSql ="select RelativeID from Customer_Relative where CustomerID in (select CustomerID from Customer_Relative where RelativeID = '"+sCustomerID+"')";
				rs = Sqlca.getASResultSet(sSql);
				while(rs.next())
				{
					RelativeID = rs.getString("RelativeID");
					if(RelativeID == null) RelativeID="";
					
					String sSql1 = " select NVL(Sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)),0) as BalanceSum, "+
									" NVL(Sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)*nvl(BailRatio,0)*0.01),0) as OpenBalanceSum "+
									" from Business_Contract" +
								   " where CustomerID ='"+RelativeID+"' and BusinessType not like '30%' and operateOrgID in " +
								   " (select BelongOrgID from Org_Belong where OrgID ='"+sRelativeOrgID+"')";
					rsTemp = Sqlca.getASResultSet(sSql1);
					if(rsTemp.next())
					{
						dBalanceSum = rsTemp.getDouble(1);
						dOpenBalanceSum = dBalanceSum-rsTemp.getDouble(2);
					}
					rsTemp.getStatement().close();
					
					dBalanceTotal = dBalanceTotal +dOpenBalanceSum;
				} 
				rs.getStatement().close();
				
				double dTotalSum = dBalanceTotal+dOpenPutOutBusinessSum;
				System.out.println("dOpenBalanceSum"+dOpenBalanceSum+"&dOpenBusinessSum"+dOpenBusinessSum+"&dTotalSum"+dTotalSum);
				System.out.println("dNetCapital*0.15"+dNetCapital*0.15);
				if(dTotalSum>dNetCapital*0.15)
					sResult = "TRUE";
				else
					sResult = "FALSE";
				
			}
			//业务终审标志
			if(sFlag.equals("6"))
			{
				sResult = sOrgFlag;
			}
			//是否国际贸易
			if(sFlag.equals("1"))
			{
				if(sBusinessType.startsWith("1080") || sBusinessType.startsWith("1090")||sBusinessType.startsWith("2050") )
				{
					sResult ="TRUE";
				}else
				{
					sResult ="FALSE";
				}
					
			}
		}
		
		System.out.println("sReturn:"+sResult);
		return sResult;
	}
		
}

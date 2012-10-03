/*
		Author: --lpzhang2009-8-17
		Tester:
		Describe: --�����ж�
		Input Param:
				ObjectNo:������ˮ��
				BusinessType����������
				Flag ���������ͣ�1���Ƿ����ҵ��2���Ƿ��ʱ���
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

		//��ö�����ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//��ö�������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//��������
		String sFlag = (String)this.getAttribute("Flag");
		//����ֵת���ɿ��ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sFlag == null) sFlag = "";
		
		//���������Sql���
		String sSql = "";
		//�������
		String sOperateOrgID ="",sCustomerID="",sBusinessType="",sApplyType ="",sCustomerType ="", sCreditAggreement="",
			sCommunityAgreement = "";
		
		String sApplySerialNo = "",sOrgFlag="",sContractNo="";
		String sManageOrgID = "";//�ܻ�����
		//������
		double dBusinessSum =0.0, dBalanceSum =0.0,dOpenBusinessSum = 0.0,dOpenBalanceSum=0.0,dOpenPutOutBusinessSum=0.0;
		//�����������ѯ�����
		ASResultSet rs = null; ASResultSet rsTemp = null;
		String sRelativeOrgID = "";//�ϼ�������
		double dNetCapital =0.0;//�ϼ������ʱ���
		//���巵�ر���
		String sResult = "";
		System.out.println("sObjectType:"+sObjectType+"&sObjectNo:"+sObjectNo+"*sFlag:"+sFlag+"OWWWQWWO"+sObjectType.equals("CreditApply"));
		if(sObjectType.equals("CreditApply"))
		{
			//ȡ��������Ϣ
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
			
			//����������ϼ����������ʱ�����Ϣ
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
			//ȡ��������Ϣ
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
			}else if(!"".equals(sCommunityAgreement))//���ù�ͬ�������Ѷ�������������ʾ
			{
				sApplySerialNo = Sqlca.getString("select RelativeSerialNo from Business_Contract where Serialno = '"+sCommunityAgreement+"'");
				if(sApplySerialNo == null) sApplySerialNo = "";
			}
			sOrgFlag = Sqlca.getString("Select OrgFlag From Business_Apply Where SerialNo ='"+sApplySerialNo+"'");
			if(sOrgFlag==null) sOrgFlag="";
			//ȡ�ó���������Ϣ
			sSql = " select Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as PutOutBusinessSum,nvl(BailRatio,0)*0.01 as BailRatio "+
			" from Business_PutOut where SerialNo = '"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dOpenPutOutBusinessSum = rs.getDouble("PutOutBusinessSum")*(1-rs.getDouble("BailRatio"));
			}
			rs.getStatement().close();
			
			//����������ϼ����������ʱ�����Ϣ
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
			//�Ƿ����ó��
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
			//��һ�����Ƿ��ʱ���֧��������ȡ���ؽ���ʱ���ֱ��֧��ȡ�к����ʱ���
			if(sFlag.equals("2"))
			{
				//��ʷ���---�Ƿ�Ҫ���������еĺ͵ȼ���ͬδ�ſ�� dOpenBalanceSum
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
				
				//�ʱ���Ƚ�
				if(dTotalSum*10>dNetCapital)
					sResult = "TRUE";
				else
					sResult = "FALSE";
				
			}
			
			//�������𼶱�sResult='030' Ϊֱ��֧�� ��020 Ϊ����֧��
			if(sFlag.equals("3"))
			{
				 sSql = "select getOrgFlag(OrgID) from Org_Info where OrgID ='"+sOperateOrgID+"'";
				 sResult = Sqlca.getString(sSql);
				 if(sResult == null) sResult ="";
			}
			
			//�����Ƿ��ʱ���֧��������ȡ���ؽ���ʱ���ֱ��֧��ȡ�к����ʱ���
			if(sFlag.equals("4"))
			{
			
				double dBalanceTotal=0.0;//���г�Ա���
				
				//�������пͻ��ڱ�����ʷ���---�Ƿ�Ҫ���������еĺ͵ȼ���ͬδ�ſ��
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
			
			//�������õȼ�����
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
			
			//����Э��
			if(sFlag.equals("7"))
			{
				String sEntAgreementNo ="";
				/*if(sBusinessType.equals("3020"))//���̻�е
				{
				    sEntAgreementNo = Sqlca.getString("select ObjectNo from Apply_Relative where SerialNo ='"+sObjectNo+"' and ObjectType ='ProjectAgreement' ");
					if(sEntAgreementNo == null) sEntAgreementNo="";
					if(!"".equals(sEntAgreementNo))
					{
						Sqlca.executeSQL("update Ent_Agreement set FreezeFlag ='1' where SerialNo ='"+sEntAgreementNo+"' and  AgreementType ='ProjectAgreement' and (FreezeFlag is null or FreezeFlag ='') ");
					}
				}*/
				if(sBusinessType.startsWith("1050"))//���ز����������ؿ������¥���Э�飩
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
			//��һ�����Ƿ��ʱ���֧��������ȡ���ؽ���ʱ���ֱ��֧��ȡ�к����ʱ���
			if(sFlag.equals("2"))
			{
				//��ʷ���---�Ƿ�Ҫ���������еĺ͵ȼ���ͬδ�ſ�� dOpenBalanceSum
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
				
				//�ʱ���Ƚ�
				if(dTotalSum*10>dNetCapital)
					sResult = "TRUE";
				else
					sResult = "FALSE";
				
			}
			
			//�����Ƿ��ʱ���֧��������ȡ���ؽ���ʱ���ֱ��֧��ȡ�к����ʱ���
			if(sFlag.equals("4"))
			{
				double dBalanceTotal=0.0;//���г�Ա���
				
				//�������пͻ��ڱ�����ʷ���---�Ƿ�Ҫ���������еĺ͵ȼ���ͬδ�ſ��
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
			//ҵ�������־
			if(sFlag.equals("6"))
			{
				sResult = sOrgFlag;
			}
			//�Ƿ����ó��
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

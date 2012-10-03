/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --����ͬ������Ϣ���Ƶ�������
		Input Param:
				ObjectType: ��������
				ObjectNo: ������ˮ��
				UserID���û�����
		Output Param:
				SerialNo����ͬ��ˮ��
		HistoryLog:    lpzhang ���ӳ��˱���֤�����������
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
		//��ú�ͬ����
		String sObjectType = (String)this.getAttribute("ObjectType");
		//��ú�ͬ��ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//���ҵ��Ʒ��
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//��û�Ʊ���
		String sBillNo = (String)this.getAttribute("BillNo");
		//��ȡ��ǰ�û�
		String sUserID = (String)this.getAttribute("UserID");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sBillNo == null) sBillNo = "";
		if(sUserID == null) sUserID = "";
		
		//���������������ˮ��
		String sSerialNo = "";
		//���������������ˮ���ַ�����@�ָ���
		String sSerialNoStr = "";
		//���������Sql���
		String sSql = "";
		//�����������������
		String sOccurType = "";
		//������������״���
		String sExchangeType = "";	
		//�����������ѯ�����
		ASResultSet rs = null;
		//����������ͻ����ƣ�֤�����ͣ�֤������
		String sCustomerID="",sCertType="",sCertID="";
		//չ�ڹ���ҵ���
		String sDueBillSerialNo = "";
		//������
		String sGDCorpusPayMethod = "";//���ʽ
		String sApprovalNo = "";
		//��ѯ�ж��ٱʳ���
 		String sGDPayCyc = ""; //������
 		String sGDPayDateType = "";//��������ȷ����ʽ
 		String sGDType1 = "";//�����˺�����
		int iPutOutCount = 0; 
		String sGDAccountNo = "";//�����˺�
 		String sGDInterestCType = "";//��Ϣ�����־
 		String sGDloanType = ""; //�ſʽ
 		String sGDType3 = "";//�����
 		String sGDType2 = "";//�����˺�����
 		String sGDLoanAccountNo = "";//�����˺�
 		double dPracticeSum = 0.00;//ʵ������
		//ʵ�����û�����
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		//���ݺ�ͬ��ˮ�Ż�ȡ�������ͺͿͻ����
		
		sSql = "select CustomerID,OccurType from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sCustomerID = rs.getString("CustomerID");
			sOccurType = rs.getString("OccurType");
			//����ֵת��Ϊ���ַ���		
			if(sCustomerID == null) sCustomerID = "";
			if(sOccurType == null) sOccurType = "";
		}
		rs.getStatement().close();
		
		//----------------------��ȡ�ͻ���ź�֤������-------------
		sSql = "select CertID,CertType from Customer_Info where CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sCertID = rs.getString("CertID");
			sCertType = rs.getString("CertType");
			//����ֵת��Ϊ���ַ���		
			if(sCertID == null) sCertID = "";
			if(sCertType == null) sCertType = "";
		}
		rs.getStatement().close();
	/*modify by xhyong 2011/04/30
 		//����ҵ��Ʒ�ֻ�ȡ���״���
		sExchangeType = Sqlca.getString("select SubTypeCode from BUSINESS_TYPE where TypeNo='"+sBusinessType+"'");
		//����ֵת��Ϊ���ַ���
		if(sExchangeType == null) sExchangeType = "";
	*/
		//����ҵ��֪ͨ�鹫��һ��ģ��
		sExchangeType="C000";
		if(sOccurType.equals("015")) //չ��
		{
			//sExchangeType = "6201";
			//ȡ��չ�ڹ���ҵ���
			sSql = "select ObjectNo from CONTRACT_RELATIVE where ObjectType = 'BusinessDueBill'  and SerialNo = '"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sDueBillSerialNo = rs.getString("ObjectNo");
				if(sDueBillSerialNo == null) sDueBillSerialNo = "";
			}
			rs.getStatement().close();
		}
		//����������:
		//��ѯ������,ʵ������
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
			//��ѯ�ж��ٷŴ�����
			sSql = "select count(SerialNo) from BUSINESS_PUTOUT where ContractSerialNO = '"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				iPutOutCount = rs.getInt(1);
				sApprovalNo=sApprovalNo+"-"+(iPutOutCount+1);
			}
			rs.getStatement().close();
		}
		//��ҵ��Ʒ��Ϊ���гжһ�Ʊ���֡���ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ������
		if(sBusinessType.equals("1020010") || sBusinessType.equals("1020020") || sBusinessType.equals("1020030"))
		{
			if(!sBillNo.equals("")) //�����Ż�Ʊ��Ϣ������������
			{
				sSql = 	" select * from BILL_INFO "+
						" where ObjectType = 'BusinessContract' "+
						" and ObjectNo = '"+sObjectNo+"' "+
						" and BillNo = '"+sBillNo+"' "+
						" and BillNo not in "+
						" (select BillNo from BUSINESS_PUTOUT "+
						" where ContractSerialNo = '"+sObjectNo+"')";				
			}else //�����ֺ�ͬ���µĻ�Ʊ��Ϣ������������
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
				//��ó�����ˮ��
				sSerialNo = DBFunction.getSerialNo("BUSINESS_PUTOUT","SerialNo","BP",Sqlca);
				
				//����ͬ��Ϣ���Ƶ�������Ϣ��
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
							"'', " +//CorpusPayMethod ������Դ��һ�� �رո��� added by zrli
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
				if(sOccurType.equals("015")) //չ��
				{
					//����ԭ�˺�
					Sqlca.executeSQL("Update Business_Putout set RelativeAccountNo = '"+sDueBillSerialNo+"' where SerialNo ='"+sSerialNo+"'");
				}
				sSerialNoStr = sSerialNoStr + sSerialNo + "@";
			}
			rs.getStatement().close();
		}else
		{			
			//��ȡ��ͬ���ý��
			Bizlet bzGetPutOutSum = new GetPutOutSum();
			bzGetPutOutSum.setAttribute("ContractSerialNo",sObjectNo); 
			bzGetPutOutSum.setAttribute("SerialNo","");				
			String sSurplusPutOutSum = (String)bzGetPutOutSum.run(Sqlca);
			
			//��ó�����ˮ��
			sSerialNo = DBFunction.getSerialNo("BUSINESS_PUTOUT","SerialNo","BP",Sqlca);
			
			//����ͬ��Ϣ���Ƶ�������Ϣ��
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
						"'', " +//CorpusPayMethod ������Դ��һ�� �رո��� added by zrli
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
			if(sOccurType.equals("015")) //չ��
			{
				//����ԭ�˺�
				Sqlca.executeSQL("Update Business_Putout set RelativeAccountNo = '"+sDueBillSerialNo+"' where SerialNo ='"+sSerialNo+"'");
			}
			//�������ʼ��������Ϣ:
			if(sBusinessType.equals("1110027")||sBusinessType.equals("2110020"))
			{
				//��ѯ������ϵͳ���������м����Ϣ
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
					sGDCorpusPayMethod =  rs.getString("CorpusPayMethod");//���ʽ
					sGDPayCyc =  rs.getString("PayCyc"); //������
					sGDPayDateType = "";//��������ȷ����ʽ
					sGDType1 =  rs.getString("Type1");//�����˺�����
					sGDAccountNo = rs.getString("AccountNo");//�����˺�
					sGDInterestCType = "";//��Ϣ�����־
					sGDloanType = ""; //�ſʽ
					sGDType3 = rs.getString("Type3");//�����
					sGDType2 = rs.getString("Type2");//�����˺�����
					sGDLoanAccountNo = rs.getString("LoanAccountNo");//�����˺�
				}
				rs.getStatement().close();
				//����
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
			//��Խ�������֤
			if("2050030".equals(sBusinessType)) 
			{
				//���³��˽��Ϊʵ������
				Sqlca.executeSQL("Update Business_Putout set BusinessSum = "+dPracticeSum+" where SerialNo ='"+sSerialNo+"'");
			}
			sSerialNoStr = sSerialNoStr + sSerialNo + "@";
		}
		
		return sSerialNoStr;
	}	
}

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


public class InsertHistoryInfoLog extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//��ò��������ҳ�����	

	 	String sInstertType = (String)this.getAttribute("InstertType");
	 	String sUpdateUser = (String)this.getAttribute("UpdateUser");
	 	String sUpdateDate = StringFunction.getToday();
	 	//��ȡ�û����ڻ�����ϵͳʱ��
		ASUser CurUser = new ASUser(sUpdateUser,Sqlca);
		String sUpdateOrg = CurUser.OrgID ;
		
	 	//����ͻ�
		if(sInstertType.equals("ChangeCustomer"))
		{	
			//��ò��������ǰ�ͻ����ţ������Ϣ�û�����
		 	String sCustomerID   = (String)this.getAttribute("ObjectNo");
			//�������
			String sSql = "",sCustomerType = "", sCustomerName = "",sCertType = "",sCertID = "",sLoanCardNo = "";
			
			//�����������ѯ�����
			ASResultSet rs = null;
			//���ݿͻ���Ż�ÿͻ���Ϣ
			sSql = " select CustomerName,CustomerType,CertType,CertID,LoanCardNo from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sCustomerName = rs.getString("CustomerName");
				sCustomerType = rs.getString("CustomerType");
				sCertType = rs.getString("CertType");
				sCertID = rs.getString("CertID");
				sLoanCardNo = rs.getString("LoanCardNo");
			}
			rs.getStatement().close();
			
			if (sCustomerType == null) sCustomerType = "";
			

		    sSql = " insert into CUSTOMER_CHANGELOG(CustomerID,CustomerName,CustomerType,CertType,CertID,LoanCardNo,UpdateUser,UpdateOrg,UpdateDate) "+
		    		" values('" +sCustomerID+"','" +sCustomerName+"','" +sCustomerType+"','" +sCertType+"','" +sCertID+"','" +sLoanCardNo+"'," +
		    		" '"+sUpdateUser+"','" +sUpdateOrg+"','" +sUpdateDate+"') ";
		    //ִ�в������
		    Sqlca.executeSQL(sSql);
		}
		//���������
		if(sInstertType.equals("ChangeAccumulationFundRate"))
		{
			//��ȡ����:���ǰ�Ĺ��������ʴ���
			String sRateID = (String)this.getAttribute("ObjectNo");
			//�������
			String sSql = "",sAreaNO="",sCurrency = "",sRateName = "";
			Double dRate = 0.0;//�����������ѯ�����
			ASResultSet rs = null;
			//���ݿ͹��������ʴ��Ż�ù�����������Ϣ
			sSql = " select AreaNO,Currency,RateName,Rate from AFRATE_INFO where RateID = '"+sRateID+"' ";
			
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sAreaNO = rs.getString("AreaNO");
				sCurrency = rs.getString("Currency");
				sRateName = rs.getString("RateName");
				dRate = rs.getDouble("Rate");
			}
			rs.getStatement().close();
			
			sSql = " insert into ACCUMULATIONFUNDRATE_CHANGELOG(AreaNO,Currency,UpdateDate,RateID,RateName,Rate) "+
					" values('"+sAreaNO+"','"+sCurrency+"','"+sUpdateDate+"','"+sRateID+"','"+sRateName+"',"+dRate+") ";
			
			Sqlca.executeSQL(sSql);
		}
		//���������
		if(sInstertType.equals("ChangeBlackList"))
		{
			// ���ҳ�����
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//�������
			String sSql = "",sSectionType = "",sCertID = "",sCertType = "",sCustomerID = "",sCustomerName = "";
			String sAttribute1 = "", sBeginDate = "",sEndDate = "" ;

			//�����������ѯ�����
			ASResultSet rs = null;
			//������ˮ�Ų�������ͻ���Ϣ
			sSql = " select SerialNo,SectionType,CertID,CertType,CustomerID,CustomerName,Attribute1,BeginDate,EndDate from CUSTOMER_SPECIAL where SerialNo = '"+sSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sSectionType = rs.getString("SectionType");
				sCertID = rs.getString("CertID");
				sCertType = rs.getString("CertType");
				sCustomerID = rs.getString("CustomerID");
				sCustomerName = rs.getString("CustomerName");
				sAttribute1 = rs.getString("Attribute1");
				sBeginDate = rs.getString("BeginDate");
				sEndDate = rs.getString("EndDate");				
			}
			rs.getStatement().close();
			
			
			sSql = " insert into CUSTOMER_SPECIALLOG(SerialNo,SectionType,CertID,CertType,CustomerID,CustomerName,Attribute1,BeginDate,EndDate,UpdateUser,UpdateOrg,UpdateDate,InstertType) "+
					" values('"+sSerialNo+"','"+sSectionType+"','"+sCertID+"','"+sCertType+"','"+sCustomerID+"','"+sCustomerName+"','"+sAttribute1+"','"+sBeginDate+"',"+
					" '"+sEndDate+"','"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"','ChangeBlackList') ";
							
			//ִ�в������
		    Sqlca.executeSQL(sSql);
		}
		//�������������
		if(sInstertType.equals("ChangeRelativeList"))
		{
			// ���ҳ�����
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//�������
			String sSql = "",sRelativeName = "";
			 Double dAttribute3=0.0,dSum1=0.0,dSum2=0.0;

			//�����������ѯ�����
			ASResultSet rs = null;
			//������ˮ�Ų�������ͻ���Ϣ
			sSql = " select SerialNo,RelativeName,Attribute3,Sum1,Sum2 from RELATIVE_SPECIAL where SerialNo = '"+sSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sRelativeName = rs.getString("RelativeName");
				dAttribute3 = rs.getDouble("Attribute3");
				dSum1 = rs.getDouble("Sum1");
				dSum2 = rs.getDouble("Sum2");				
			}
			rs.getStatement().close();
			
			sSql = " insert into RELATIVE_SPECIALLOG(SerialNo,RelativeName,Attribute3,Sum2,Sum1,UpdateUser,UpdateOrg,UpdateDate) "+
					" values('"+sSerialNo+"','"+sRelativeName+"',"+dAttribute3+","+dSum1+","+dSum2+",'"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"') ";
							
			//ִ�в������
		    Sqlca.executeSQL(sSql);
		}
		//����ɶ�����
		if(sInstertType.equals("ChangeStockholderList"))
		{
			// ���ҳ�����
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//�������
			String sSql = "",sCustomerName = "";
			 Double dAttribute3=0.0,dSum1=0.0,dSum2=0.0;
			//�����������ѯ�����
			ASResultSet rs = null;
			//������ˮ�Ų�������ͻ���Ϣ
			sSql = " select SerialNo,CustomerName,Attribute3,Sum1,Sum2 from CUSTOMER_SPECIAL where SerialNo = '"+sSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sCustomerName = rs.getString("CustomerName");
				dAttribute3 = rs.getDouble("Attribute3");
				dSum1 = rs.getDouble("Sum1");
				dSum2 = rs.getDouble("Sum2");
				
			}
			rs.getStatement().close();
			
			sSql = " insert into CUSTOMER_SPECIALLOG(SerialNo,CustomerName,Attribute3,Sum2,Sum1,UpdateUser,UpdateOrg,UpdateDate,InstertType) "+
			" values('"+sSerialNo+"','"+sCustomerName+"',"+dAttribute3+","+dSum1+","+dSum2+",'"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"','ChangeStockholderList') ";
							
			//ִ�в������
		    Sqlca.executeSQL(sSql);
		}
		//�����Ͽ��н��������
		if(sInstertType.equals("ChangeAuditList"))
		{
			// ���ҳ�����
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//�������
			String sSql = "",sAttribute1 = "",sCustomerName = "",sAuditOrgType = "",sEffectStartDate = "",sEffectFinishDate = "";

			//�����������ѯ�����
			ASResultSet rs = null;
			//������ˮ�Ų�������ͻ���Ϣ
			sSql = " select SerialNo,Attribute1,CustomerName,AuditOrgType,EffectStartDate,EffectFinishDate from CUSTOMER_SPECIAL where SerialNo = '"+sSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sAttribute1 = rs.getString("Attribute1");
				sCustomerName = rs.getString("CustomerName");
				sAuditOrgType = rs.getString("AuditOrgType");
				sEffectStartDate = rs.getString("EffectStartDate");
				sEffectFinishDate = rs.getString("EffectFinishDate");				
			}
			rs.getStatement().close();
			
			
			sSql = " insert into CUSTOMER_SPECIALLOG(SerialNo,Attribute1,CustomerName,AuditOrgType,EffectStartDate,EffectFinishDate,UpdateUser,UpdateOrg,UpdateDate,InstertType) "+
			" values('"+sSerialNo+"','"+sAttribute1+"','"+sCustomerName+"','"+sAuditOrgType+"','"+sEffectStartDate+"','"+sEffectFinishDate+"','"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"','ChangeAuditList') ";
							
			//ִ�в������
		    Sqlca.executeSQL(sSql);
		}
		//����ͻ�ά��
		if(sInstertType.equals("ChangeSpecialCustList"))
		{
			// ���ҳ�����
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//�������
			String sSql = "",sCustomerName = "",sBeginDate = "",sEndDate = "";

			//�����������ѯ�����
			ASResultSet rs = null;
			//������ˮ�Ų�������ͻ���Ϣ
			sSql = " select SerialNo,CustomerName,BeginDate,EndDate from CUSTOMER_SPECIAL where SerialNo = '"+sSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sCustomerName = rs.getString("CustomerName");
				sBeginDate = rs.getString("BeginDate");
				sEndDate = rs.getString("EndDate");			
			}
			rs.getStatement().close();
			
			sSql = " insert into CUSTOMER_SPECIALLOG(SerialNo,CustomerName,BeginDate,EndDate,UpdateUser,UpdateOrg,UpdateDate,InstertType) "+
			" values('"+sSerialNo+"','"+sCustomerName+"','"+sBeginDate+"','"+sEndDate+"','"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"','ChangeSpecialCustList') ";
							
			//ִ�в������
		    Sqlca.executeSQL(sSql);
		}
		//����ƽ̨����
		if(sInstertType.equals("ChangeFinancePlatFormList"))
		{
			// ���ҳ�����
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//�������
			String sSql = "";
			
			sSql = " insert into CUSTOMER_FINANCEPLATFORMlog(SERIALNO,CUSTOMERNAME,INPUTORGID,INPUTUSERID," +
						"INPUTDATE,REMARK,CERTTYPE,CERTID,CUSTOMERID," +
						"PLATFORMLEVEL,DEALCLASSIFY,LEGALPERSONNATURE,PLATFORMTYPE," +
						"CASHCOVERDEGREE,FINANCECREDITTYPE,LOANCARDNO,FINANCEPLATFORMFLAG,UPDATEUSER,UPDATEORG,UPDATEDATE) " +
						" select SERIALNO,CUSTOMERNAME,INPUTORGID,INPUTUSERID," +
						"INPUTDATE,REMARK,CERTTYPE,CERTID,CUSTOMERID," +
						"PLATFORMLEVEL,DEALCLASSIFY,LEGALPERSONNATURE,PLATFORMTYPE," +
						"CASHCOVERDEGREE,FINANCECREDITTYPE,LOANCARDNO,FINANCEPLATFORMFLAG," +
						"'"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"' " +
					" from CUSTOMER_FINANCEPLATFORM " +
					" where serialno='"+sSerialNo+"' ";
							
			//ִ�в������
		    Sqlca.executeSQL(sSql);
		}
	    return "Success";
	 }

}

package com.amarsoft.app.lending.bizlets;
/**
 * ��ʼ��������Ϣ 2009-7-30 lpzhang
 * 
 * */
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.ASResultSet;


public class InitializeBusiness extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
        		
		//�������:SQL
		String sSql = "";
		String sCustomerID="",sOccurType="",sBusinessType="",sRelativeAgreement="",sCustomerType="",sApplyType="";
		String sCreditAggreement="";
		String sApprovalNo = "";
		//�����������ѯ�����
		ASResultSet rs=null;
		
		//�ͻ���Ϣ
		if(sObjectType == null) sObjectType = "";
		if(sObjectType.equals("CreditApply"))
		{
			//�ҳ�������Ϣ
			sSql = "select CustomerID,getCustomerType(CustomerID) as CustomerType,"+
				" Occurtype,BusinessType,RelativeAgreement,ApplyType,CreditAggreement "
				+" from Business_Apply where SerialNo='"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sCustomerID = rs.getString("CustomerID");
				sCustomerType = rs.getString("CustomerType");
				sOccurType = rs.getString("Occurtype");
				sBusinessType = rs.getString("BusinessType");
				sRelativeAgreement = rs.getString("RelativeAgreement");
				sApplyType = rs.getString("ApplyType");
				sCreditAggreement =  rs.getString("CreditAggreement");
				if(sCustomerID == null) sCustomerID = "";
				if(sOccurType == null) sOccurType = "";
				if(sBusinessType == null) sBusinessType = "";
				if(sRelativeAgreement == null) sRelativeAgreement = "";
				if(sCustomerType == null) sCustomerType = "";
				if(sApplyType == null) sApplyType = "";
				if(sCreditAggreement == null) sCreditAggreement = "";
			}
			rs.getStatement().close();
			
			//ȡ�øÿͻ��Ŀͻ���ҵͶ��
			if(!sCustomerType.startsWith("03"))//��˾��ҵ
			{
				sSql = "select IndustryType from Ent_Info where CustomerID='"+sCustomerID+"'";
				String sIndustryType = Sqlca.getString(sSql);
				if(sIndustryType == null) sIndustryType = "";
				Sqlca.executeSQL("Update Business_Apply  set Direction = '"+sIndustryType+"' where  SerialNo = '"+sObjectNo+"'");
			}
			
			//Ĭ��Ϊ�����
			Sqlca.executeSQL("Update Business_Apply  set BusinessCurrency = '01' where  SerialNo = '"+sObjectNo+"'");
			
			//��������֤Ĭ�ϱ�֤��Ϊ�����
			if("2050030".equals(sBusinessType))
			{
				Sqlca.executeSQL("Update Business_Apply  set  BailCurrency='01'  where  SerialNo = '"+sObjectNo+"'");
			}
			/*delete by xhyong 2011/06/01
			//���״�Ĭ�Ͽ�ѭ��
			if("1140090".equals(sBusinessType) || "1140100".equals(sBusinessType))
			{
				Sqlca.executeSQL("Update Business_Apply  set  CycleFlag='1'  where  SerialNo = '"+sObjectNo+"'");
			}
			*/
			//add by xhyong 2011/06/01 ���Ը���ҵ��Ĭ��Ϊ����ѭ��
			//ȡ�øÿͻ��Ŀͻ���ҵͶ��
			if(sCustomerType.startsWith("03")&&!sBusinessType.startsWith("3"))//���˿ͻ������Ŷ��
			{
				Sqlca.executeSQL("Update Business_Apply  set  CycleFlag='2'  where  SerialNo = '"+sObjectNo+"'");
			}
			//���״�Ĭ�ϲ���ѭ��,��Ҫ������ʽΪ������Ѻ
			if("1140110".equals(sBusinessType))
			{
				Sqlca.executeSQL("Update Business_Apply  set  CycleFlag='2'  where  SerialNo = '"+sObjectNo+"'");
				Sqlca.executeSQL("Update Business_Apply  set  VouchType='005'  where  SerialNo = '"+sObjectNo+"'");
			}
			/*delete by xhyong 2012/06/20
			//�¸�ʧҵ��ԱС�������
			if("1140080".equals(sBusinessType))
			{
				Sqlca.executeSQL("Update Business_Apply  set  VouchType='01050',VouchCorpName='�������С��ҵ���õ��������������'  where  SerialNo = '"+sObjectNo+"'");
			}
			*/
			//ͬҵ��ȵ�����ʽΪ���� added by zrli 2009-12-29
			if("3015".equals(sBusinessType))
			{
				Sqlca.executeSQL("Update Business_Apply  set  VouchType='005' where  SerialNo = '"+sObjectNo+"'");
			}
			//�����飬�ս��ͬ
			if(sOccurType.equals("090"))
			{	
				sSql = 	" select ObjectNo from APPLY_RELATIVE "+
						" where SerialNo = '"+sObjectNo+"' " +
						" and ObjectType = 'BusinessReApply' ";
				String BASerialNo = Sqlca.getString(sSql);
				if(BASerialNo==null) BASerialNo="";
				Sqlca.executeSQL("Update Business_Contract set FreezeFlag = '4',FinishDate = '"+StringFunction.getToday()+"' where RelativeSerialNo = '"+BASerialNo+"'");
				
			}
			//�������
			/*if(sApplyType.equalsIgnoreCase("DependentApply")){
				Sqlca.executeSQL("Update Business_Apply set LowRisk = '1' where SerialNo = '"+sObjectNo+"'");
			}*/
			//���µ�������������Ϊ���������
			if(sApplyType.equalsIgnoreCase("DependentApply")){
				sSql = 	" select ApprovalNo from BUSINESS_CONTRACT "+
				" where SerialNo = '"+sCreditAggreement+"' " ;
				sApprovalNo = Sqlca.getString(sSql);
				if(sApprovalNo==null) sApprovalNo="";
				Sqlca.executeSQL("Update Business_Apply set ApprovalNo = '"+sApprovalNo+"' where SerialNo = '"+sObjectNo+"'");
			}
			
		}
		
	    return "1";
	    
	 }

}

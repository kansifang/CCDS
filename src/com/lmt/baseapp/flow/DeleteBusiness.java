package com.lmt.baseapp.flow;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class DeleteBusiness extends Bizlet 
{
	private String sObjectTable = "";
	private String sRelativeTable = ""; 
	public Object  run(Transaction Sqlca) throws Exception
	{		

		//�Զ���ô���Ĳ���ֵ		
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sDeleteType = (String)this.getAttribute("DeleteType");


		//����ֵת���ɿ��ַ���		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sDeleteType == null) sDeleteType = "";

		//ɾ������
		if(sDeleteType.equals("DeleteTask")){
			//ɾ������
			//��ȡ������
			//ɾ�����̶�����Ϣ				
			deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
			//ɾ������������Ϣ
			deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
			//ɾ�����������Ϣ
			deleteTableData("Flow_Opinion",sObjectType,sObjectNo,Sqlca);

		}
		//ɾ����������������������
		if(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply"))
		{
			//��ȡ������
			getRelativeTable(sObjectType,Sqlca);
			//ɾ����ͬ������
			deleteTableData("Business_Applicant",sObjectType,sObjectNo,Sqlca);
			//ɾ��ҵ����鱨��
			deleteTableData("Business_Report",sObjectType,sObjectNo,Sqlca);
			//ɾ��Ʊ����Ϣ
			deleteTableData("Bill_Info",sObjectType,sObjectNo,Sqlca);
			//����֤��Ϣ
			deleteTableData("LC_Info",sObjectType,sObjectNo,Sqlca);
			//ɾ��ó�׺�ͬ��Ϣ
			deleteTableData("Contract_Info",sObjectType,sObjectNo,Sqlca);
			//ɾ����ֵ˰��Ʊ��Ϣ
			deleteTableData("Invoice_Info",sObjectType,sObjectNo,Sqlca);
			//ɾ�������ṩ��������Ϣ
			deleteTableData("Business_Provider",sObjectType,sObjectNo,Sqlca);
			//ɾ��������Ϣ
			deleteTableData("LG_Info",sObjectType,sObjectNo,Sqlca);
			//ɾ���н���Ϣ
			deleteAgencyInfo(this.sRelativeTable,sObjectNo,Sqlca);
			//ɾ���ᵥ��Ϣ
			deleteTableData("Bol_Info",sObjectType,sObjectNo,Sqlca);
			//ɾ����������װ����Ϣ
			deleteTableData("Building_Deal",sObjectType,sObjectNo,Sqlca);
			//ɾ��������Ϣ
			deleteTableData("Vehicle_Info",sObjectType,sObjectNo,Sqlca);
			//ɾ��������Ϣ
			deleteTableData("Consume_Info",sObjectType,sObjectNo,Sqlca);
			//ɾ���豸��Ϣ
			deleteTableData("Equipment_Info",sObjectType,sObjectNo,Sqlca);
			//ɾ������ѧ��Ϣ
			deleteTableData("Study_Info",sObjectType,sObjectNo,Sqlca);
			//ɾ��������¥����Ϣ
			deleteTableData("Building_Info",sObjectType,sObjectNo,Sqlca);
			//ɾ����������Ϣ
			deleteGuarantyInfo(sObjectType,sObjectNo,Sqlca);
			//ɾ����������ҵ�������ϵ
			deleteTableData("Guaranty_Relative",sObjectType,sObjectNo,Sqlca);
			//ɾ��������ͬ��Ϣ
			deleteGuarantyContract(this.sRelativeTable,sObjectNo,Sqlca);
			//ɾ�����ն�������ϸ��Ϣ
			deleteTableData("Evaluate_Data",sObjectType,sObjectNo,Sqlca);
			//ɾ�����ն�������Ϣ
			deleteTableData("Evaluate_Record",sObjectType,sObjectNo,Sqlca);
			//ɾ����ʽ�����鱨����Ϣ
			deleteTableData("FormatDoc_Data",sObjectType,sObjectNo,Sqlca);
			//ɾ���ĵ���Ϣ
			deleteDocInfo(sObjectType,sObjectNo,Sqlca);	
			//ɾ����Ŀ��Ϣ
			deleteTableData("Project_Relative",sObjectType,sObjectNo,Sqlca);
			//ɾ�����ŷ�����ϸ��Ϣ
			deleteCLInfo(sObjectType,sObjectNo,Sqlca);				
			//ɾ��������Ϣ
			deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
			//ɾ�����������Ϣ
			deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
			//ɾ�����̶�����Ϣ				
			deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
			//ɾ������������Ϣ
			deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);				
		}
		if(sDeleteType.equals("DeleteBusiness"))
		{					
			//ɾ����ͬ��Ϣ
			if(sObjectType.equals("BusinessContract"))
			{
				//��ȡ������
				getRelativeTable(sObjectType,Sqlca);
				//ɾ����ͬ������
				deleteTableData("Business_Applicant",sObjectType,sObjectNo,Sqlca);
				//ɾ��ҵ����鱨��
				deleteTableData("Business_Report",sObjectType,sObjectNo,Sqlca);
				//ɾ��Ʊ����Ϣ
				deleteTableData("Bill_Info",sObjectType,sObjectNo,Sqlca);
				//����֤��Ϣ
				deleteTableData("LC_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ��ó�׺�ͬ��Ϣ
				deleteTableData("Contract_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ����ֵ˰��Ʊ��Ϣ
				deleteTableData("Invoice_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ�������ṩ��������Ϣ
				deleteTableData("Business_Provider",sObjectType,sObjectNo,Sqlca);
				//ɾ��������Ϣ
				deleteTableData("LG_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ���н���Ϣ
				deleteAgencyInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//ɾ���ᵥ��Ϣ
				deleteTableData("Bol_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ����������װ����Ϣ
				deleteTableData("Building_Deal",sObjectType,sObjectNo,Sqlca);
				//ɾ��������Ϣ
				deleteTableData("Vehicle_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ��������Ϣ
				deleteTableData("Consume_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ���豸��Ϣ
				deleteTableData("Equipment_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ������ѧ��Ϣ
				deleteTableData("Study_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ��������¥����Ϣ
				deleteTableData("Building_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ����������Ϣ
				deleteGuarantyInfo(sObjectType,sObjectNo,Sqlca);
				//ɾ����������ҵ�������ϵ
				deleteTableData("Guaranty_Relative",sObjectType,sObjectNo,Sqlca);
				//ɾ��������ͬ��Ϣ
				deleteGuarantyContract(this.sRelativeTable,sObjectNo,Sqlca);
				//ɾ�����ն�������ϸ��Ϣ
				deleteTableData("Evaluate_Data",sObjectType,sObjectNo,Sqlca);
				//ɾ�����ն�������Ϣ
				deleteTableData("Evaluate_Record",sObjectType,sObjectNo,Sqlca);
				//ɾ����ʽ�����鱨����Ϣ
				deleteTableData("FormatDoc_Data",sObjectType,sObjectNo,Sqlca);
				//ɾ���ĵ���Ϣ
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);				
				//ɾ����Ŀ��Ϣ
				deleteTableData("Project_Relative",sObjectType,sObjectNo,Sqlca);
				//ɾ�����ŷ�����ϸ��Ϣ
				deleteCLInfo(sObjectType,sObjectNo,Sqlca);				
				//ɾ��������Ϣ
				deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//ɾ�����������Ϣ
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
			}

			//ɾ�����鷽����Ϣ
			if(sObjectType.equals("NPAReformApply"))	
			{
				//��ȡ������
				getRelativeTable(sObjectType,Sqlca);
				//ɾ��������Ϣ
				deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//ɾ�����������Ϣ
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
			}
			//add by fhuang 2006.11.29 ɾ����������Ĺ�����Ϣ
			if(sObjectType.equals("LawcaseInfo"))
			{
				//ɾ�����������Ϣ
				delFlowInfo(sObjectNo,"LawCaseApply",Sqlca);
				//ɾ��������ͬ�Ĺ�����ϵ
				deleteRelativeInfo("LAWCASE_RELATIVE",sObjectNo,Sqlca);
				//ɾ�����������ˡ�����������Ա����������Ϣ
				deleteTableData("Lawcase_Persons",sObjectType,sObjectNo,Sqlca);
				//ɾ����������ĵ�
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);
				//ɾ��̨����Ϣ
				deleteTableData("Lawcase_Book",sObjectType,sObjectNo,Sqlca);
				//ɾ��ͥ���¼
				deleteTableData("Lawcase_Cognizance",sObjectType,sObjectNo,Sqlca);
				//ɾ������̨��
				deleteTableData("Cost_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ������ʲ�̨��
				deleteTableData("Asset_Info",sObjectType,sObjectNo,Sqlca);

			}
			//add by fhuang 2006.11.30 ɾ����ծ�ʲ��Ĺ�����Ϣ
			if(sObjectType.equals("AssetInfo"))
			{
				//ɾ�����������Ϣ
				delFlowInfo(sObjectNo,"PDAApply",Sqlca);
				//ɾ��������ͬ�Ĺ�����ϵ				
				deleteAssetContract(sObjectNo,Sqlca);
				//ɾ����ر�����Ϣ
				deleteTableData("Insurance_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ����ֵ������¼
				deleteTableData("Evaluate_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ����ֵ�䶯��¼
				deleteTableData("OtherChange_Info",sObjectType,sObjectNo,Sqlca);
				//ɾ����������ĵ�
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);				
			}
		}
		return "1";
	}

	private void delFlowInfo(String objectNo,String objectType, Transaction sqlca) 
	throws Exception
	{
		sqlca.executeSQL(" delete from flow_task where objectno='"+objectNo+"' and objectType = '"+objectType+"' ");
		sqlca.executeSQL(" delete from flow_object where objectno='"+objectNo+"' and objectType = '"+objectType+"' ");
		sqlca.executeSQL(" delete from flow_opinion where objectno='"+objectNo+"' and objectType = '"+objectType+"' ");
	}

	//��ȡ��������
	private void getRelativeTable(String sObjectType,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";	 
		ASResultSet rs = null;
		//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ�������
		sSql = "select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";	 
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			this.sObjectTable = rs.getString("ObjectTable");
			this.sRelativeTable = rs.getString("RelativeTable");
		}
		rs.getStatement().close();	 	 
	}

//	ɾ���н���Ϣ
	private void deleteAgencyInfo(String sRelativeTable,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		sSql = " delete from AGENCY_INFO where SerialNo in (select ObjectNo from "+
		" "+sRelativeTable+" where SerialNo = '"+sObjectNo+"' and ObjectType "+
		" = 'AgencyInfo') ";
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql);	 
	}

//	ɾ����������Ϣ(δ���)
	private void deleteGuarantyInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";

		sSql = " delete from GUARANTY_INFO where GuarantyID in (select GuarantyID "+
		" from GUARANTY_RELATIVE where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"' and Channel = 'New') "+
		" and GuarantyStatus = '01' ";	 
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql);	 
	}
//	ɾ��������Ϣ
	private void deleteGuarantyContract(String sRelativeTable,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";

		sSql = " delete from GUARANTY_CONTRACT "+
		" where SerialNo in (select ObjectNo "+
		" from "+sRelativeTable+" "+
		" where ObjectType = 'GuarantyContract' "+
		" and SerialNo = '"+sObjectNo+"' ) "+
		" and (ContractStatus = '010' or ContractType <> '020')";
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql);	 
	}

//	ɾ���ĵ���Ϣ
	private void deleteDocInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		//ɾ���ĵ��ĸ���
		sSql = " delete from DOC_ATTACHMENT  where DocNo in (select DocNo "+
		" from DOC_RELATIVE where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"') ";
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql);
		//ɾ���ĵ�����
		sSql=  " delete from DOC_LIBRARY where DocNo in (select DocNo "+
		" from DOC_RELATIVE where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"') ";
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql);
		//ɾ���ĵ���ҵ��Ĺ�����ϵ
		sSql= 	" delete from DOC_RELATIVE where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"'";	
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql);	 
	}
//	ɾ�����ŷ�����ϸ��Ϣ
	private void deleteCLInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		//���ݶ������ͽ���ɾ����������
		if(sObjectType.equals("CreditApply"))
		{
			sSql = " select LineID from CL_INFO where ApplySerialNo = '"+sObjectNo+"' ";
			String sLineID = Sqlca.getString(sSql);
			sSql = " delete from CL_LIMITATION_SET where LineID = '"+sLineID+"' ";
			//ִ��ɾ�����
			Sqlca.executeSQL(sSql);
			sSql = " delete from CL_LIMITATION where LineID = '"+sLineID+"' ";
			//ִ��ɾ�����
			Sqlca.executeSQL(sSql);
			sSql = " delete from CL_INFO where LineID = '"+sLineID+"' ";
			//ִ��ɾ�����
			Sqlca.executeSQL(sSql);
		}else
		{
			//���������������¼������ŷ�����ϸû��ɾ��
			if(sObjectType.equals("ApproveApply"))
				sSql = " update CL_INFO set ApproveSerialNo = null "+
				" where ApproveSerialNo = '"+sObjectNo+"' ";
			//�ں�ͬ��¼������ŷ�����ϸû��ɾ��
			if(sObjectType.equals("BusinessContract"))
				sSql = " update CL_INFO set BCSerialNo = null,LineContractNo = null "+
				" where BCSerialNo = '"+sObjectNo+"' ";

			//ִ��ɾ�����
			Sqlca.executeSQL(sSql);	 
		}
	}

//	ɾ��������Ϣ
	private void deleteRelativeInfo(String sRelativeTable,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";

		sSql = " delete from "+sRelativeTable+" where SerialNo = '"+sObjectNo+"' ";
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql);	 
	}

//	ɾ�����������Ϣ
	private void deleteObjectInfo(String sObjectTable,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";

		sSql = " delete from "+sObjectTable+" where SerialNo = '"+sObjectNo+"' ";
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql);	 
	}
//	ɾ��������ͬ�Ĺ�����ϵ	
	private void deleteAssetContract(String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		sSql = " delete from Asset_Contract where SerialNo = '"+sObjectNo+"' ";
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql);	 
	} 
	//ɾ����ObjectType,ObjectNo��Ϊ����ı�
	private void deleteTableData(String sTableName,String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		sSql = " delete from "+sTableName+" where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"' ";
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql); 
	}


}

/**
 * content:������Ӧ�׶ε�ҵ�����,��������Ϣ
 * Author:fhuang
 * Time:2006.10.23
 * Input Param:ObjectType---��������
 * 			   ObjectNo-----������
 * 
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateBusiness extends Bizlet {
	private String sObjectTable = "";
	private String sRelativeTable ="";
	private String sUserID = "";
	private String sOrgID = "";
	private String sUpdateDate = "";
	private String sUpdateTime = "";
	public Object run(Transaction Sqlca) throws Exception
	{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sToUserID = (String)this.getAttribute("ToUserID");
		String sToOrgID = (String)this.getAttribute("ToOrgID");
		//����ֵת��Ϊ���ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sToUserID == null) sToUserID = "";
		if(sToOrgID == null) sToOrgID = "";
		
		//��ȫ��˽�б�����ֵ
		this.sUserID = sToUserID;
		this.sOrgID = sToOrgID;
        this.sUpdateDate = StringFunction.getToday();
        this.sUpdateTime = StringFunction.getTodayNow();
		//��ȡ������
		getRelativeTable(sObjectType,Sqlca);
		//���¹�ͬ��������Ϣ
		updateBusinessApplicant(sObjectType,sObjectNo,Sqlca);
		//���µ��鱨����Ϣ
		if(sObjectType.equals("CreditApply"))
		{
			updateFormatDoc(sObjectType,sObjectNo,Sqlca);
		}
		//����Ʊ����Ϣ
		updateBillInfo(sObjectType,sObjectNo,Sqlca);
		//��������֤��Ϣ
		updateLCInfo(sObjectType,sObjectNo,Sqlca);
		//����ó�׺�ͬ��Ϣ
		updateContractInfo(sObjectType,sObjectNo,Sqlca);
		//������ֵ˰��Ʊ��Ϣ
		updateInvoiceInfo(sObjectType,sObjectNo,Sqlca);
		//���������ṩ��������Ϣ
		updateBusinessProvider(sObjectType,sObjectNo,Sqlca);
		//���±�����Ϣ
		updateLGInfo(sObjectType,sObjectNo,Sqlca);
		//�����н���Ϣ
		if(!(sObjectType.equals("PutOutApply") || sObjectType.equals("BusinessDueBill")))
			updateAgencyInfo(this.sRelativeTable,sObjectNo,Sqlca);
		//�����ᵥ��Ϣ
		updateBolInfo(sObjectType,sObjectNo,Sqlca);
		//���·�������װ����Ϣ
		updateBuildingDeal(sObjectType,sObjectNo,Sqlca);
		//����������Ϣ
		updateVehicleInfo(sObjectType,sObjectNo,Sqlca);
		//����������Ϣ
		updateConsumeInfo(sObjectType,sObjectNo,Sqlca);
		//�����豸��Ϣ
		updateEquipmentInfo(sObjectType,sObjectNo,Sqlca);
		//���µ�������Ϣ
		updateGuarantyInfo(sObjectType,sObjectNo,Sqlca);
		//���µ�����ͬ��Ϣ
		updateGuarantyContract(sObjectType,sObjectNo,Sqlca);
		//���·��ն�������Ϣ
		updateEvaluateRecord(sObjectType,sObjectNo,Sqlca);
		//���¸�ʽ�����鱨����Ϣ		
		updateDocInfo(sObjectType,sObjectNo,Sqlca);			
		//�������ŷ�����ϸ��Ϣ
		if(!(sObjectType.equals("PutOutApply") || sObjectType.equals("BusinessDueBill")))
			updateCLInfo(sObjectType,sObjectNo,Sqlca);	
		
		//�������������Ϣ
		updateObjectInfo(sObjectType,sObjectNo,Sqlca);
		return "SUCCESS";
	}
	//��ȡ������
	 private void getRelativeTable(String sObjectType,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";	 
		 ASResultSet rs = null;
		 //����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ�������
		 sSql = " select ObjectTable,RelativeTable "+
		 		" from OBJECTTYPE_CATALOG "+
		 		" where ObjectType = '"+sObjectType+"'";	 
		 rs = Sqlca.getASResultSet(sSql);
		 if(rs.next())
		 {
			 this.sObjectTable = rs.getString("ObjectTable");
			 this.sRelativeTable = rs.getString("RelativeTable");
		 }
		 rs.getStatement().close();	 	 
	 }
	 
	 //���¹�ͬ�����˵Ļ���
	 private void updateBusinessApplicant(String sObjectType,String sObjectNo,Transaction Sqlca)
	 	throws Exception
	 {
		 String sSql = "";
		 sSql = " update BUSINESS_APPLICANT set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //���¸�ʽ���ĵ���Ϣ
	 private void updateFormatDoc(String sObjectType,String sObjectNo,Transaction Sqlca)
	 	throws Exception
	 {
		 String sSql = "";
		 sSql = " update FORMATDOC_DATA set "+
		 		" OrgID = '"+sOrgID+"', "+
		 		" UserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //����Ʊ��
	 private void updateBillInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update BILL_INFO  set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //��������֤��Ϣ
	 private void updateLCInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update LC_INFO set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //����ó�׺�ͬ��Ϣ
	 private void updateContractInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update CONTRACT_INFO set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //������ֵ˰��Ʊ��Ϣ
	 private void updateInvoiceInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update INVOICE_INFO set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
	 			" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //���������ṩ��������Ϣ
	 private void updateBusinessProvider(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update BUSINESS_PROVIDER set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
				" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);
	 }
	 
	 //���±�����Ϣ
	 private void updateLGInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update LG_INFO set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //�����н���Ϣ
	 private void updateAgencyInfo(String sRelativeTable,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update AGENCY_INFO set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where SerialNo in "+
		 		" (select ObjectNo from "+sRelativeTable+" "+
		 		" where SerialNo = '"+sObjectNo+"' "+
		 		" and ObjectType = 'AgencyInfo') ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //�����ᵥ��Ϣ
	 private void updateBolInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update BOL_INFO set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
	 			" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //���·�������װ����Ϣ
	 private void updateBuildingDeal(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update BUILDING_DEAL set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
			    " and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //����������Ϣ
	 private void updateVehicleInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update VEHICLE_INFO set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //����������Ϣ
	 private void updateConsumeInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update CONSUME_INFO set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
	 			" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //�����豸��Ϣ
	 private void updateEquipmentInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update EQUIPMENT_INFO set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
				" and ObjectNo = '"+sObjectNo+"' ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //���µ�������Ϣ
	 private void updateGuarantyInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 	 
		 sSql = " update GUARANTY_INFO set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where GuarantyID in "+
		 		" (select GuarantyID from GUARANTY_RELATIVE "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"') ";	 
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //���µ�����ͬ��Ϣ
	 private void updateGuarantyContract(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 
		 sSql = " update GUARANTY_CONTRACT  set "+
		 		" InputOrgID = '"+sOrgID+"', "+
		 		" InputUserID = '"+sUserID+"', "+
		 		" UpdateUserID = '"+sUserID+"', "+
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where SerialNo in "+
		 		" (select ContractNo from GUARANTY_RELATIVE "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"') ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //���·��ն�������¼��Ϣ
	 private void updateEvaluateRecord(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update EVALUATE_RECORD set "+
		 		" OrgID = '"+sOrgID+"', "+
		 		" UserID = '"+sUserID+"', "+
		 		" CognOrgID = '"+sOrgID+"', "+
		 		" CognUserID = '"+sUserID+"' "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"' "+
		 		" and ModelNo = 'RiskEvaluate'";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //�����ĵ���Ϣ
	 private void updateDocInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 //�����ĵ��ĸ�����Ϣ
		 sSql = " update DOC_ATTACHMENT set "+
		 		" InputOrg = '"+sOrgID+"', "+
		 		" InputUser = '"+sUserID+"', "+
		 		" UpdateUser = '"+sUserID+"', "+
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" where DocNo in "+
		 		" (select DocNo from DOC_RELATIVE "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"') ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);
		 //�����ĵ�����
		 sSql=  " update DOC_LIBRARY set "+
		 		" OrgID = '"+sOrgID+"', "+		 		
		 		" UserID='"+sUserID+"', "+
		 		" InputOrg = '"+sOrgID+"', "+
		 		" InputUser = '"+sUserID+"', "+
		 		" UpdateUser = '"+sUserID+"', "+
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" where DocNo in "+
		 		" (select DocNo from DOC_RELATIVE "+
		 		" where ObjectType = '"+sObjectType+"' "+
		 		" and ObjectNo = '"+sObjectNo+"') ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);
		 
		 sSql=  " update DOC_LIBRARY set "+
		 		" OrgName = getOrgName(OrgID),"+
		 		" UserName = getUserName(UserID) "+
		 		" where DocNo in "+
		 		" (select DocNo from DOC_RELATIVE "+
		 		" where ObjectType = '"+sObjectType+"' "+
		    	" and ObjectNo = '"+sObjectNo+"') ";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	
	 }
	 
	 //�������Ŷ����Ϣ
	 private void updateCLInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 String sSql1 = "";
		 //���ݶ������ͽ��и��²�������
		 if(sObjectType.equals("CreditApply"))
		 {
			 sSql = " select LineID "+
			 		" from CL_INFO "+
			 		" where ApplySerialNo = '"+sObjectNo+"' ";
			 sSql1 = " update CL_INFO set "+
			 		 " InputOrg = '"+sOrgID+"', "+
			 		 " InputUser = '"+sUserID+"', "+
			 		 " UpdateTime = '"+sUpdateTime+"' "+
			 		 " where ApplySerialNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql1);
		 }else if(sObjectType.equals("ApproveApply"))
		 {
			 sSql = " select LineID "+
			 		" from CL_INFO "+
			 		" where ApproveSerialNo = '"+sObjectNo+"' ";			 
			 sSql1 = " update CL_INFO set "+
			 		 " InputOrg = '"+sOrgID+"', "+
			 		 " InputUser = '"+sUserID+"', "+
			 		 " UpdateTime = '"+sUpdateTime+"' "+
			 		 " where ApproveSerialNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql1);
		 }else if(sObjectType.equals("BusinessContract"))
		 {
			 sSql = " select LineID "+
			 		" from CL_INFO "+
			 		" where BCSerialNo = '"+sObjectNo+"' ";			 
			 sSql1 = " update CL_INFO set "+
			 		 " InputOrg = '"+sOrgID+"', "+
			 		 " InputUser = '"+sUserID+"', "+
			 		 " UpdateTime = '"+sUpdateTime+"' "+
			 		 " where BCSerialNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql1);
		 }
		 
		 String sLineID = Sqlca.getString(sSql);
		 sSql = " update CL_LIMITATION_SET set "+
		 		" InputOrg = '"+sOrgID+"', "+
		 		" InputUser = '"+sUserID+"', "+
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" where LineID = '"+sLineID+"' ";
			 //ִ�и������
			 Sqlca.executeSQL(sSql);
			 sSql = " update CL_LIMITATION set "+
			 		" InputOrg = '"+sOrgID+"', "+
			 		" InputUser = '"+sUserID+"', "+
			 		" UpdateTime = '"+sUpdateTime+"' "+
			 		" where LineID = '"+sLineID+"' ";
			 //ִ�и������
			 Sqlca.executeSQL(sSql);
	 }
	 
	 //�������������Ϣ
	 private void updateObjectInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 if(sObjectType.equals("CreditApply")) //����
		 {
			 //����������Ϣ
			 sSql = " update "+sObjectTable+" set "+
			 		" InputOrgID = '"+sOrgID+"', "+
			 		" InputUserID = '"+sUserID+"', "+
			 		" OperateOrgID = '"+sOrgID+"', "+
			 		" OperateUserID = '"+sUserID+"', "+
			 		" UpdateDate = '"+sUpdateDate+"' "+
			 		" where SerialNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql);
			 			 
			 //�������̶������Ϣ
			 sSql = " update FLOW_OBJECT set "+
			 		" OrgID = '"+sOrgID+"', "+
			 		" UserID = '"+sUserID+"' "+
			 		" where ObjectType = '"+sObjectType+"' "+
			    	" and ObjectNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql);
			 			 
			 sSql = " update FLOW_OBJECT set "+
			 		" OrgName = getOrgName(OrgID), "+
			 		" UserName = getUserName(UserID) "+
			 		" where ObjectType = '"+sObjectType+"' "+
			    	" and ObjectNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql);
			 
			 //��ȡ����ĳ�ʼ�׶�
			 String sPhaseNo = Sqlca.getString("select min(PhaseNo) from FLOW_TASK where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"'");
			 //��������������Ϣ
			 sSql = " update FLOW_TASK set "+
			 		" OrgID = '"+sOrgID+"', "+
			 		" UserID = '"+sUserID+"' "+
			 		" where ObjectType = '"+sObjectType+"' "+
			    	" and ObjectNo = '"+sObjectNo+"' " +
			 		" and PhaseNo = '"+sPhaseNo+"' ";
			 Sqlca.executeSQL(sSql);
			 
			 sSql = " update FLOW_TASK set "+
			 		" OrgName = getOrgName(OrgID), "+
			 		" UserName = getUserName(UserID) "+
			 		" where ObjectType = '"+sObjectType+"' "+
			    	" and ObjectNo = '"+sObjectNo+"' " +
			    	" and PhaseNo = '"+sPhaseNo+"' ";
			 Sqlca.executeSQL(sSql);
		 }
		 
		 //������������������������������¼��Ա¼��ģ���˲���������������Ϣ
		 if(sObjectType.equals("ApproveApply")) //�����������
		 {
			 sSql = " update "+sObjectTable+" set "+			 		
			 		" OperateOrgID = '"+sOrgID+"', "+
			 		" OperateUserID = '"+sUserID+"', "+
			 		" UpdateDate = '"+sUpdateDate+"' "+
			 		" where SerialNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql);
		 }
		 
		 if(sObjectType.equals("BusinessContract")) //��ͬ
		 {
			 //���º�ͬ����Ϣ
			 sSql = " update "+sObjectTable+" set "+
			 		" InputOrgID = '"+sOrgID+"', "+
			 		" InputUserID = '"+sUserID+"', "+
			 		" OperateOrgID = '"+sOrgID+"', "+
			 		" OperateUserID = '"+sUserID+"', "+
			 		" ManageOrgID = '"+sOrgID+"', "+
			 		" ManageUserID = '"+sUserID+"', "+
			 		" UpdateDate = '"+sUpdateDate+"' "+
			 		" where SerialNo = '"+sObjectNo+"'";
			 Sqlca.executeSQL(sSql);
			 
			 //���·��ռ�鱨����Ϣ
			 sSql = " update INSPECT_INFO set "+
			 		" InputOrgID = '"+sOrgID+"', "+
			 		" InputUserID = '"+sUserID+"', "+
			 		" UpdateDate = '"+sUpdateDate+"' "+
			 		" where ObjectType = '"+sObjectType+"' "+
			 		" and ObjectNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql);
			 
			 //���´��պ���Ϣ
			 sSql = " update DUN_INFO set "+
			 		" OperateOrgID = '"+sOrgID+"', "+
			 		" OperateUserID = '"+sUserID+"', "+
			 		" InputOrgID = '"+sOrgID+"', "+
			 		" InputUserID = '"+sUserID+"', "+
			 		" UpdateDate = '"+sUpdateDate+"' "+
			 		" where ObjectType = '"+sObjectType+"' "+
			 		" and ObjectNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql);
		 }
		 
		 if(sObjectType.equals("PutOutApply")) //����
		 {
			 //���³�����Ϣ
			 sSql = " update "+sObjectTable+" set "+
			 		" InputOrgID = '"+sOrgID+"', "+
			 		" InputUserID = '"+sUserID+"', "+
			 		" OperateOrgID = '"+sOrgID+"', "+
			 		" OperateUserID = '"+sUserID+"', "+
			 		" UpdateDate = '"+sUpdateDate+"' "+
			 		" where SerialNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql);
			 
			 //�������̶������Ϣ
			 sSql = " update FLOW_OBJECT set "+
			 		" OrgID = '"+sOrgID+"', "+
			 		" UserID = '"+sUserID+"' "+
			 		" where ObjectType = '"+sObjectType+"' "+
			    	" and ObjectNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql);
			 			 
			 sSql = " update FLOW_OBJECT set "+
			 		" OrgName = getOrgName(OrgID), "+
			 		" UserName = getUserName(UserID) "+
			 		" where ObjectType = '"+sObjectType+"' "+
			    	" and ObjectNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql);
			 
			 //��ȡ����ĳ�ʼ�׶�
			 String sPhaseNo = Sqlca.getString("select min(PhaseNo) from FLOW_TASK where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"'");
			 //��������������Ϣ
			 sSql = " update FLOW_TASK set "+
			 		" OrgID = '"+sOrgID+"', "+
			 		" UserID = '"+sUserID+"' "+
			 		" where ObjectType = '"+sObjectType+"' "+
			    	" and ObjectNo = '"+sObjectNo+"' " +
			    	" and PhaseNo = '"+sPhaseNo+"' ";
			 Sqlca.executeSQL(sSql);
			 
			 sSql = " update FLOW_TASK set "+
			 		" OrgName = getOrgName(OrgID), "+
			 		" UserName = getUserName(UserID) "+
			 		" where ObjectType = '"+sObjectType+"' "+
			    	" and ObjectNo = '"+sObjectNo+"' " +
			    	" and PhaseNo = '"+sPhaseNo+"' ";
			 Sqlca.executeSQL(sSql);
		 }
		 
		 if(sObjectType.equals("BusinessDueBill")) //���
		 {
			 sSql = " update "+sObjectTable+" set "+
			 		" InputOrgID = '"+sOrgID+"', "+
			 		" InputUserID = '"+sUserID+"', "+
			 		" OperateOrgID = '"+sOrgID+"', "+
			 		" OperateUserID = '"+sUserID+"', "+
			 		" UpdateDate = '"+sUpdateDate+"' "+
			 		" where SerialNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql);
		 }
		 		 
		 if(sObjectType.equals("BusinessContract") || sObjectType.equals("BusinessDueBill")) //��ͬ�ͽ��
		 {
			 //���·��շ������Ϣ
			 sSql = " update CLASSIFY_RECORD set "+
			 		" OrgID = '"+sOrgID+"', "+
			 		" UserID = '"+sUserID+"', "+
			 		" ClassifyOrgID = '"+sOrgID+"', "+
			 		" ClassifyUserID = '"+sUserID+"', "+
			 		" UpdateDate = '"+sUpdateDate+"' "+
			 		" where ObjectType = '"+sObjectType+"' "+
			    	" and ObjectNo = '"+sObjectNo+"' ";
			 Sqlca.executeSQL(sSql);
		 }
	 }
}

<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xxge 2004-11-25
 * Tester:
 *
 * Content:  ����ָ����ͬ�Ĳ����ʲ�������
 * Input Param:
 *		SerialNo����ͬ��ˮ��
 *		ShiftType���ƽ����ͣ�01�������ƽ���02���ͻ��ƽ���
 *		RecoveryUserID: �����ʲ�������
 *		RecoveryOrgID�������ʲ���������������
 *		Flag����־��1�������ˣ�
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//��ͬ��ˮ�š��ƽ����͡������ʲ������˻�����˴��롢��������
	String sContractNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 	
	String sShiftType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ShiftType")); 	
	String sRecoveryUser = DataConvert.toRealString(iPostChange,CurPage.getParameter("RecoveryUserID")); 
	String sRecoveryOrg = DataConvert.toRealString(iPostChange,CurPage.getParameter("RecoveryOrgID")); 
	String sFlag=DataConvert.toRealString(iPostChange,CurPage.getParameter("Flag")); 
	//����ֵת��Ϊ���ַ���
	if (sContractNo == null) sContractNo = "";
	if (sShiftType == null) sShiftType = "";
	if (sRecoveryUser == null) sRecoveryUser = "";
	if (sRecoveryOrg == null) sRecoveryOrg = "";
	if (sFlag == null) sFlag = "";
	
	String sSql="";
	String sSerialNo="";
	String	sTableName = "TRACE_INFO";
	String	sColumnName = "SerialNo";
	
	if (sFlag.equals("1"))   //ָ�������˽���
	{
		if (sShiftType.equals("02"))  //����ǿͻ��ƽ��ĺ�ͬ����ôָ�������ˣ����ƽ���
		{
    		sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,Sqlca);
    		//�����ʲ����ٱ��в�������
	        sSql= " Insert into TRACE_INFO(SerialNo,ContractNo,TraceUserid,TraceOrgid,InputUserID,InputOrgID,InputDate) Values('"+sSerialNo+"','"+sContractNo+"','"+sRecoveryUser+"','"+sRecoveryOrg+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+ StringFunction.getToday() + "') ";
	       	Sqlca.executeSQL(sSql);
		}else  //����������ƽ��ĺ�ͬ����ô���Ӹ����ˣ��ƽ���
		{
				sSql= " UPDATE BUSINESS_CONTRACT "+
					 "  SET RecoveryUserID='"+sRecoveryUser+"', RecoveryOrgID='"+sRecoveryOrg+"'" + 
					 "  WHERE  SerialNo='" + sContractNo + "'";   		   
				Sqlca.executeSQL(sSql);

				sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,Sqlca);				
				//�����ʲ����ٱ��в�������
				sSql= " Insert into TRACE_INFO(SerialNo,ContractNo,TraceUserid,TraceOrgid,InputUserID,InputOrgID,InputDate) Values('"+sSerialNo+"','"+sContractNo+"','"+sRecoveryUser+"','"+sRecoveryOrg+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+ StringFunction.getToday() + "') ";
				Sqlca.executeSQL(sSql);
		}
	}
	else  // ָ�������˽���
	{
        sSql= " UPDATE BUSINESS_CONTRACT "+
             "  SET RecoveryUserID='"+sRecoveryUser+"', RecoveryOrgID='"+sRecoveryOrg+"'" + 
             "  WHERE  SerialNo='" + sContractNo + "'";   
   
    	Sqlca.executeSQL(sSql);
    	if(sShiftType.equals("01")) //��������ƽ�ָ�������ˣ���Ҫ��������Ϣ���в�������
    	{
    		sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,Sqlca);
    		//�����ʲ����ٱ��в�������
	        sSql= " Insert into TRACE_INFO(SerialNo,ContractNo,TraceUserid,TraceOrgid,InputUserID,InputOrgID,InputDate) Values('"+sSerialNo+"','"+sContractNo+"','"+sRecoveryUser+"','"+sRecoveryOrg+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+ StringFunction.getToday() + "') ";
	       	Sqlca.executeSQL(sSql);
    	}
	}
%>

<script language=javascript>
    self.returnValue="true";
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>

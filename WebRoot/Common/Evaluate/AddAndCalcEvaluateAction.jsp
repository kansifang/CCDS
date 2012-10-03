<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:   HYLiu  2004.09.16
 * Tester:
 * Content: �������������
 * Input Param:
 *			ObjectType����������
 *			ObjectNo��������
 *			ModelType��ģ������
 *			ModelNo��ģ�ͱ��
 *			AccountMonth������·�
 *					
 * Output param:
 *			
 * History Log:
 *                  
 *                  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.evaluate.*" %>
<%!
public String getSingleStringResult(String SqlString,Transaction Sqlca) throws Exception
{
	ASResultSet rs = null;
	String sReturn = null;
	rs = Sqlca.getASResultSet(SqlString);
	if(rs.next()) sReturn = rs.getString(1);
	rs.getStatement().close();
	return sReturn;
}

%>
<html>
<head>
<title>����������</title>
</head>
<body bgcolor="#DCDCDC" leftmargin="10" topmargin="10" >
</body>
</html>
<%
	//�������
	String sSql = "";
	String sModelTypeAttributes = "",sDefaultModelNoSQL = "",sDefaultModelNo = "";
	ASResultSet rs = null,rs1 = null;
	
	//���ҳ�����
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sModelType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelType"));
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo"));
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sModelType == null) sModelType = "";
	if(sModelNo == null) sModelNo = "";
	if(sAccountMonth == null) sAccountMonth = "";
		
	sSql = "select * from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo='"+sModelType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sModelTypeAttributes = rs.getString("RelativeCode");
	}else{
		throw new Exception("ģ������ ["+sModelType+"] û�ж��塣��鿴CODE_LIBRARY:EvaluateModelType");
	}
	rs.getStatement().close();
	
	if(sModelTypeAttributes==null) throw new Exception("ģ������ ["+sModelType+"] �����Լ� û�ж��壬��鿴CODE_LIBRARY:EvaluateModelType��RelativeCode����");
	sDefaultModelNoSQL = StringFunction.getProfileString(sModelTypeAttributes,"DefaultModelNoSQL");
	//�滻����
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ObjectType",sObjectType);
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ObjectNo",sObjectNo);
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ModelType",sModelType);
	//��ȡģ�ͺ�
	sModelNo = getSingleStringResult(sDefaultModelNoSQL,Sqlca);
    
	sSql = "select count(*) from EVALUATE_CATALOG where  (Method1 is null or Method1 not like '%ͣ��%') and ModelNo = '"+sModelNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		if(rs.getInt(1)<1) throw new Exception("�ÿͻ�ָ����һ��ͣ�õ���������ģ�ͣ����ڿͻ��ſ����޸ġ�ModelNo:"+sModelNo);
	}
	rs.getStatement().close();

	if(sDefaultModelNoSQL!=null && !sDefaultModelNoSQL.equals("")){
		sDefaultModelNo = getSingleStringResult(sDefaultModelNoSQL,Sqlca);
		sModelNo = sDefaultModelNo;
	}
	else{
		%>	
		<script language=javascript> 
			alert(getBusinessMessage('194'));//û��ָ��Ĭ�ϵ�ģ�ͣ�
			self.returnValue="failed";
			self.close();
		</script>		
		<%
		return;
	}


	if (Evaluate.existEvaluate(sObjectType,sObjectNo,sAccountMonth,sModelNo,Sqlca))
	{
%>	
		<script language=javascript> 
			alert(getBusinessMessage('195'));//�������õȼ�������¼�Ѵ��ڣ�
			self.returnValue="failed";
			self.close();
		</script>		
<%
		//return;
	}else
	{
		String sEvaluateDate = StringFunction.getToday();
		String sOrgID = CurOrg.OrgID;
		String sUserID = CurUser.UserID;
		String sEvaDate="",sEvaResult="";
		float dEvaScore=0;
		int iCount=0;
		ASResultSet sReport=null;

		String sSerialNo = Evaluate.newEvaluate(sObjectType,sObjectNo,sAccountMonth,sModelNo,sEvaluateDate,sOrgID,sUserID,Sqlca);
		Evaluate evaluate;
		evaluate  = new Evaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);
		evaluate.evaluate();

		rs = Sqlca.getASResultSet("select EvaluateDate,EvaluateScore,EvaluateResult from EVALUATE_RECORD where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' and SerialNo='"+ sSerialNo + "'");
		if (rs.next())
		{	
			sEvaDate = rs.getString(1);
			dEvaScore = rs.getFloat(2);
			sEvaResult = rs.getString(3);
		}
		rs.getStatement().close();
		sSql = " Update EVALUATE_RECORD Set CognDate='"+ sEvaDate +"',CognScore='" + dEvaScore +"',CognResult='" +sEvaResult+ "',"+
	           " CognOrgID='"+CurOrg.OrgID+"',CognUserID='"+CurUser.UserID+"'" +
	           " where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' and SerialNo='"+ sSerialNo + "'";
		
     	Sqlca.executeSQL(sSql);
	 	rs = Sqlca.getASResultSet(" select AccountMonth,CognResult from EVALUATE_RECORD Where ObjectNo='" + sObjectNo +
		     "' and  modelno in ('210','215','220') and AccountMonth = (select max(AccountMonth) from EVALUATE_RECORD Where ObjectNo='" + sObjectNo +"')");
	 	String sEvaDate1="",sEvaResult1="";
		if (rs.next())
		{	
			sEvaDate1 = rs.getString(1);			
			sEvaResult1 = rs.getString(2);
		}
		rs.getStatement().close();

		sSql = "Update ENT_INFO  Set EvaluateDate='"+sEvaDate1+"',CreditLevel='"+sEvaResult1+ "'"+
		       "where  CustomerID= '"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);        
%>	
		<script language=javascript> 
			self.returnValue="<%=sEvaResult%>@<%=sModelNo%>";
			self.close();
		</script>		
<%
	}
%>
<script language="javascript">
</script>
<%@ include file="/IncludeEnd.jsp"%>
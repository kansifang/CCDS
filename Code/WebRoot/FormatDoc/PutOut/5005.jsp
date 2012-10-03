<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong  2009/08/27
		Tester:
		Content: ����ĵ�0ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   ���� 1:display;2:save;3:preview;4:export
				FirstSection: �ж��Ƿ�Ϊ����ĵ�һҳ
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader1.jsp"%>

<%
	//��õ��鱨������
	String sCustomerName = "",sBusinessTypeName = "",sBusinessSum = "";
	String sCurrency = "",sBailRatio = "",sBusinessRate = "";
	String sClassifyResult = "",sVouchType = "",sPurpose = "";
	String sOrgName = "",sUserName = "",sCurrencyName = "";
	String sVouchTypeName = "",sPutOutDate = "",sMaturity = "";
	String sBalance = "",sInterestBalance = "",sDescribe2 = "";
	String sDutyAttribute = "",sDescribe3 = "",sDescribe1 = "";
	String sUndertakerName = "",sTraceModeName = "",sRemark = "";
	String sCognizePerson = "",sInputOrgName = "",sInputDate = "";
	String sDutyTypeName = "",sExternalReason = "";
	String sSql = "";
	ASResultSet rs = null;
	//ȡ��ͬ��Ϣ
	sSql = " select getOrgName(InputOrgID) as OrgName,"+
			" getitemname('Currency',BusinessCurrency) as CurrencyName,"+
			" SerialNo,CustomerName,getBusinessName(BusinessType) as BusinessTypeName,"+
			" getItemName('VouchType',VouchType) as  VouchTypeName,PutOutDate,"+
			" Maturity,Nvl(BusinessSum,0) as BusinessSum ,"+
			" Nvl(Balance,0) as Balance,(Nvl(InterestBalance1,0)+Nvl(InterestBalance2,0)) as InterestBalance "+
			" from BUSINESS_CONTRACT where serialno='"+sObjectNo+"'";
	rs = Sqlca.getResultSet(sSql);
	
	if(rs.next())
	{
		sOrgName = rs.getString("OrgName");
		sCurrencyName = rs.getString("CurrencyName");
		sSerialNo = rs.getString("SerialNo");
		sCustomerName = rs.getString("CustomerName");
		sBusinessTypeName = rs.getString("BusinessTypeName");
		sVouchTypeName = rs.getString("VouchTypeName");
		sPutOutDate = rs.getString("PutOutDate");
		sMaturity = rs.getString("Maturity");
		sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
		sBalance = DataConvert.toMoney(rs.getDouble("Balance")/10000);
		sInterestBalance = DataConvert.toMoney(rs.getDouble("InterestBalance")/10000);
	}
	rs.getStatement().close();	
	//�����϶�����
	sSql = " select getItemName('YesNo',DutyAttribute) as DutyAttribute,Describe3,"+
			" getItemName('BadnessReason',DutyType) as DutyTypeName, "+
			" Describe1,Describe2,ExternalReason,UndertakerName,"+
			" getItemName('TraceMode',TraceMode) as TraceModeName,Remark,"+
			" CognizePerson,'������',getOrgName(InputOrgID) as InputOrgName,InputDate "+
			" from DUTY_INFO where ObjectType='BusinessContract' and "+
			" ObjectNo='"+sObjectNo+"'";

	rs = Sqlca.getResultSet(sSql);
	
	if(rs.next())
	{
		sDutyAttribute = rs.getString("DutyAttribute");
		sDescribe3 = rs.getString("Describe3");
		sDutyTypeName = rs.getString("DutyTypeName");
		sDescribe1 = rs.getString("Describe1");
		sDescribe2 = rs.getString("Describe2");
		sExternalReason = rs.getString("ExternalReason");
		sUndertakerName = rs.getString("UndertakerName");
		sTraceModeName = rs.getString("TraceModeName");
		sRemark = rs.getString("Remark");
		sCognizePerson = rs.getString("CognizePerson");
		sInputOrgName = rs.getString("InputOrgName");
		sInputDate = rs.getString("InputDate");
	}
	rs.getStatement().close();	
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='5005.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�����ʲ������϶���</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center Bordercolor=#aaaaaa bgcolor=#aaaaaa >���������</td>");
    sTemp.append(" <td width=40% colspan='4' align=left Bordercolor=#aaaaaa bgcolor=#aaaaaa >&nbsp;"+sOrgName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center Bordercolor=#aaaaaa bgcolor=#aaaaaa >���֣�</td>");
    sTemp.append(" <td width=20% colspan='2' align=left Bordercolor=#aaaaaa bgcolor=#aaaaaa >&nbsp;"+sCurrencyName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center Bordercolor=#aaaaaa bgcolor=#aaaaaa >��λ��</td>");
    sTemp.append(" <td width=10% colspan='1' align=left Bordercolor=#aaaaaa bgcolor=#aaaaaa >&nbsp;��Ԫ</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >��ͬ��ˮ��</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sSerialNo+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >�ͻ�����</td>");
    sTemp.append(" <td width=30% colspan='3' align=left class=td1 >&nbsp;"+sCustomerName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >ҵ��Ʒ��</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sBusinessTypeName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >���ʽ</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sVouchTypeName+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >��ͬ��ʼ��</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sPutOutDate+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >��ͬ������</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sMaturity+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >��ͬ���</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sBusinessSum+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >��ͬ���</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sBalance+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >��Ƿ��Ϣ</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sInterestBalance+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >�����</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;1</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >����</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;2</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >������</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;3</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >��������</td>");
    sTemp.append(" <td width=10% colspan='3' align=left class=td1 >&nbsp;4</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% colspan='2' align=center class=td1 >�����Ƿ񰴺�ͬԼ����;ʹ��</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sDutyAttribute+"</td>");
    sTemp.append(" <td width=20% colspan='2' align=center class=td1 >��������˱䶯���</td>");
    sTemp.append(" <td width=20% colspan='2' align=left class=td1 >&nbsp;"+sDescribe3+"</td>");
    sTemp.append(" <td width=20% colspan='2' align=center class=td1 >�����γɲ���ԭ��</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sDutyTypeName+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% rowspan='2' colspan='1' align=center >����ԭ��</td>");
	sTemp.append("   <td colspan=9 align=left class=td1 >����Ż���(���顢��顢����)Υ�����:<br>");
	sTemp.append("&nbsp;"+sDescribe1+"");
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=9 align=left class=td1 >���󻷽ڴ�������:<br>");
	sTemp.append("&nbsp;"+sDescribe2+"");
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >�͹�ԭ��:<br>");
	sTemp.append("&nbsp;"+sExternalReason+"");
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >������</td>");
    sTemp.append(" <td width=60% colspan='6' align=left class=td1 >&nbsp;"+sUndertakerName+"</td>");
    sTemp.append(" <td width=20% colspan='2' align=center class=td1 >��������</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sTraceModeName+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >��ע</td>");
    sTemp.append(" <td width=90% colspan='9' align=left class=td1 >&nbsp;"+sRemark+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >�����϶���</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sCognizePerson+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >������</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sCustomerName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >�Ǽǻ���</td>");
    sTemp.append(" <td width=30% colspan='3' align=left class=td1 >&nbsp;"+sInputOrgName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >�Ǽ�����</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sInputDate+"</td>");
    sTemp.append(" </tr>");

	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='"+CurComp.ClientID+"'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='"+CurPage.ClientID+"'>");
	sTemp.append("</form>");	



	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludeFDFooter.jsp"%>

<script language=javascript>
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//�ͻ���3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  zwhu 2009.08.27
		Tester:
		Content: ����ĵ�?ҳ
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
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//��õ��鱨������
	
	String sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	String sGuarangtorID = "";//�����ͻ�ID��
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();
	
	String sBasicBanck = "";
	String sBasicAccount = "";
	String sMyBank = "";
	String sMyBankAccount = "";
	String sAccountDate = "";
	String sCreditDate = "";
	String sOtherBank = "";
	String sOtherBankAccount = "";
	
	rs2 = Sqlca.getResultSet("select BasicBank,BasicAccount,MyBank,MyBankAccount,"
							+"AccountDate,CreditDate,OtherBank,OtherBankAccount "
							+"from ENT_INFO "
							+"where CustomerID ='"+sGuarangtorID+"'");
	
	if(rs2.next())
	{
		sBasicBanck = rs2.getString(1);
		if(sBasicBanck == null) sBasicBanck = " ";
		
		sBasicAccount = rs2.getString(2);
		if(sBasicAccount == null) sBasicAccount = " ";
		
		sMyBank = rs2.getString(3);
		if(sMyBank == null) sMyBank = " ";
		
		sMyBankAccount = rs2.getString(4);
		if(sMyBankAccount == null) sMyBankAccount = " ";
		
		sAccountDate = rs2.getString(5);
		if(sAccountDate == null) sAccountDate = " ";
		
		sCreditDate = rs2.getString(6);
		if(sCreditDate == null) sCreditDate = " ";
		
		sOtherBank = rs2.getString(7);
		if(sOtherBank == null) sOtherBank = "";
		
		sOtherBankAccount = rs2.getString(8);
		if(sOtherBankAccount == null) sOtherBankAccount = "";
	}
	
	rs2.getStatement().close();	
	
	//��ñ��
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,i=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '07__' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(i=0;i<sNo.length;i++)
	{		
		sNo1[i] = "8."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(i=0;i<sNo.length;i++)
	{
		if(sNo[i].equals(sTreeNo.substring(0,4)))  break;
	}	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='070204.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("<tr>");	
	sTemp.append("<td class=td1 align=left colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sNo1[i]+".4���������ϵ</font></td>"); 		
	sTemp.append("<tr>");
	sTemp.append("<tr>");
    sTemp.append("<td colspan='4' align=left class=td1 nowrap > ���֣����ۣ������ ��λ����Ԫ </td>");
	sTemp.append("</tr>");	
  	sTemp.append("<td width=20% align=left class=td1 > �����˻�������  </td>");
    sTemp.append("<td width=35% align=left class=td1 >"+sBasicBanck+"&nbsp;</td>");
    sTemp.append("<td width=10% align=left class=td1 > �˺� </td>");
    sTemp.append("<td width=35% align=left class=td1 >"+sBasicAccount+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
  	sTemp.append("<td width=20% align=left class=td1 > ������Ҫ����������</td>");
    sTemp.append("<td width=30% align=left class=td1 >"+sOtherBank+"&nbsp;</td>");
    sTemp.append("<td width=20% align=left class=td1 > �˺� </td>");
    sTemp.append("<td width=30% align=left class=td1 >"+sOtherBankAccount+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
  	sTemp.append("<td width=20% align=left class=td1 > ���п���ʱ��  </td>");
    sTemp.append("<td width=30% align=left class=td1 >"+sMyBank+"&nbsp;</td>");
    sTemp.append("<td width=20% align=left class=td1 > �˺� </td>");
    sTemp.append("<td width=30% align=left class=td1 >"+sAccountDate+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
    sTemp.append("<td width=20% align=left class=td1 nowrap > �����н����Ŵ���ϵ���� </td>");
    sTemp.append("<td colspan='3' align=left class=td1 >"+sCreditDate+"&nbsp;</td>");
	sTemp.append("</tr>");	
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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bqliu 2011-04-29
		Tester:
		Content: ����ĵ�0ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   
				FirstSection: 
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
	
	String sBasicBank = "";//�����˻�������
    String sBasicAccount = "";//�˺�
    String sMybankAccount = "";//�˺�
    String sAccountDate = "";//���п���ʱ��
	rs2 = Sqlca.getResultSet("select BasicBank,BasicAccount,MybankAccount,AccountDate from Ent_Info where CustomerID = '"+sGuarangtorID+"'");
    if(rs2.next()){
    	sBasicBank = rs2.getString("BasicBank");
    	if(sBasicBank == null) sBasicBank=" ";
    	
    	sBasicAccount = rs2.getString("BasicAccount");
    	if(sBasicAccount == null) sBasicAccount=" ";
    	
    	sMybankAccount = rs2.getString("MybankAccount");
    	if(sMybankAccount == null) sMybankAccount=" ";
    	
    	sAccountDate = rs2.getString("AccountDate");
    	if(sAccountDate == null) sAccountDate=" ";
    }
    rs2.getStatement().close();
    
    String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,j=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '050_' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(j=0;j<sNo.length;j++)
	{		
		sNo1[j] = "8."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(j=0;j<sNo.length;j++)
	{
		if(sNo[j].equals(sTreeNo.substring(0,4)))  break;
	}	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='03060202.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=4><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >2�������˿������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" <td align=center class=td1 colspan=4>���֣����ۣ������&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��λ����Ԫ&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >�����˻�������&nbsp;</td>");
    sTemp.append(" <td width=30%  align=center class=td1 >"+sBasicBank+"&nbsp;</td>");
    sTemp.append(" <td width=10% align=center class=td1 >�˺�&nbsp;</td>");
    sTemp.append(" <td width=40% align=center class=td1 >"+sBasicAccount+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >���п���ʱ��&nbsp;</td>");
    sTemp.append(" <td width=30%  align=center class=td1 >"+sAccountDate+"&nbsp;</td>");
    sTemp.append(" <td width=10% align=center class=td1 >�˺�&nbsp;</td>");
    sTemp.append(" <td width=40% align=center class=td1 >"+sMybankAccount+"&nbsp;</td>");
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


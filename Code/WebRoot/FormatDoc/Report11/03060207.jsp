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
	
	String sCustomerName = "";//��������ҵ
	String sOccurOrg = "";//���Ž��ڻ���
	String sBusinessSum  = "";//��ͬ���
	String sMaturity = "";//������
	String sVouchType = "";//������ʽ
	String sRemark = "";
	String Temp = "";//��������ҵ��Ϊ��
	
	String sTreeNo = "";
	String[] sNo = null;
	int iNo=1,j=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '050_' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	
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
	sTemp.append("	<form method='post' action='03060207.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >7�������������еĶ��ⵣ�����</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" <td width=20%  align=center class=td1 >��������ҵ&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >���Ž��ڻ���&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >��ͬ����Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >������ʽ&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >������&nbsp;</td>");
    sTemp.append(" </tr>");
    
    sSql = "select '"+Temp+"' as CustomerName,OccurOrg,"+
		    "nvl(BusinessSum,0)*getERate(Currency,'01','') as BusinessSum," +
		    "Maturity,getItemName('VouchType',VouchType)as VouchType,Remark "+
		    "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID = '"+sGuarangtorID+"'";
    rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		sVouchType = rs2.getString("VouchType");
		sOccurOrg = rs2.getString("OccurOrg");
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum")/10000);;
		sMaturity = rs2.getString("Maturity");
		
		sTemp.append("   <tr>");
	    sTemp.append(" <td width=20% align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
	    sTemp.append(" <td width=20% align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
	  	sTemp.append(" <td width=20% align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
	    sTemp.append(" <td width=20% align=center class=td1 >"+sVouchType+"&nbsp;</td>");
	    sTemp.append(" <td width=20% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
	    sTemp.append(" </tr>");
	}
	rs2.getStatement().close();	
	
	sSql = "select sum(nvl(BusinessSum,0)*getERate(Currency,'01','')) "+
	    "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID = '"+sGuarangtorID+"'";
	rs2 = Sqlca.getResultSet(sSql);
	String sSum = "";
	if(rs2.next())
	{
		sSum = DataConvert.toMoney(rs2.getDouble(1)/10000); 
	}	
	rs2.getStatement().close();	
	
    sTemp.append("   <tr>");
    sTemp.append(" <td width=20% align=center class=td1 >�ϼ�&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+"/"+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sSum+"&nbsp;</td>");
  	sTemp.append(" <td align=center class=td1 >��ע&nbsp;</td>");
    sTemp.append(" <td align=center class=td1 >"+sRemark+"&nbsp;</td>");
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


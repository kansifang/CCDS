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

		History Log: pliu 2011-08-03
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
	String sRemark = "";
	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();
	
	String sOccurOrg = "";//���Ž��ڻ���
	String sCURRENCY = "";//����
	String sMaturity = "";//������
	String sBusinessSum = "";//���Ž��
	String sGuarantyTypeName = "";//������ʽ
	
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
	sTemp.append("	<form method='post' action='03060206.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >6��������������δ�����������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >���Ž��ڻ���&nbsp;</td>");
    sTemp.append(" <td width=20%  align=center class=td1 >����&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >���Ž���Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >������ʽ&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >������&nbsp;</td>");
    sTemp.append(" </tr>");

    sSql = "select OccurOrg,Maturity,BusinessSum ,getItemName('VouchType',VouchType) as VouchType, "+
	    "getItemName('Currency',CURRENCY) as CURRENCY,Remark  "+
	    "from CUSTOMER_OACTIVITY where CustomerID = '"+sGuarangtorID+"' and Balance >0 and BusinessType != '08'" ;
    rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sOccurOrg = rs2.getString("OccurOrg");
		if(sOccurOrg == null) sOccurOrg = " ";
		sMaturity = rs2.getString("Maturity");
		if(sMaturity == null) sMaturity = " ";
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum")/10000);
		sGuarantyTypeName = rs2.getString("VouchType");
		if(sGuarantyTypeName == null) sGuarantyTypeName = " ";
		sCURRENCY = rs2.getString("CURRENCY");
		if(sCURRENCY == null) sCURRENCY = " ";
		
		sTemp.append("   <tr>");
	    sTemp.append(" <td width=20% align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
	    sTemp.append(" <td width=20% align=center class=td1 >"+sCURRENCY+"&nbsp;</td>");
	  	sTemp.append(" <td width=20% align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
	    sTemp.append(" <td width=20% align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
	    sTemp.append(" <td width=20% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
	    sTemp.append(" </tr>");
    }
	
    rs2.getStatement().close();	
    
	sSql = "select sum(BusinessSum) "+
	              "from CUSTOMER_OACTIVITY where CustomerID = '"+sGuarangtorID+"' and Balance >0";
	rs2 = Sqlca.getResultSet(sSql);
	String sSum = "";
	while(rs2.next())
	{
		sSum += DataConvert.toMoney(rs2.getDouble(1)/10000); 
	}	
	rs2.getStatement().close();
	
    sTemp.append("   <tr>");
    sTemp.append(" <td width=20% align=center class=td1 >�ϼ�&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+"/"+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sSum+"&nbsp;</td>");
  	sTemp.append(" <td align=center class=td1 >��ע&nbsp;</td>");
    sTemp.append(" <td align=center class=td1 >"+sRemark+"&nbsp;</td>");
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


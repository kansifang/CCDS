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
	sTemp.append("	<form method='post' action='03060205.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >5�������������еĶ��ⵣ�����</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��������ҵ&nbsp;</td>");
  	sTemp.append(" <td width=10% align=center class=td1 >����&nbsp;</td>");
    sTemp.append(" <td width=20%  align=center class=td1 >��ͬ����Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=20%  align=center class=td1 >��ͬ����Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=15% align=center class=td1 >������ʽ&nbsp;</td>");
    sTemp.append(" <td width=15% align=center class=td1 >������&nbsp;</td>");
    sTemp.append(" </tr>");
    sSql =  " select distinct BC.CustomerName,getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName,"
			+" getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResult,"
			+" getItemName('Currency',BC.BUSINESSCURRENCY) as CurrencyType,BC.BusinessSum,BC.BALANCE,BC.Maturity"
			+" from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR"
			+" where CR.ObjectNo = GC.serialNo"
			+" and CR.ObjectType = 'GuarantyContract'"
			+" and BC.SerialNo=CR.SerialNo"
			+" and GC.GuarantorID = '"+sGuarangtorID+"'"
			+" and GC.CustomerID <> '"+sGuarangtorID+"'";
	
	String sGuarantorName = "";
	String sGuarantyTypeName = "";
	String sBusinessSum = "";
	String sBlance = "";
	String sEndDate = "";
	String sClassifyResult = "";
	String sCurrencyType= "";
	
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sGuarantorName = rs2.getString(1);
		if(sGuarantorName == null) sGuarantorName = " ";
		sGuarantyTypeName = rs2.getString(2);
		if(sGuarantyTypeName == null) sGuarantyTypeName = " ";
		sClassifyResult = rs2.getString(3);
		if(sClassifyResult == null ) sClassifyResult = " ";
		sCurrencyType = rs2.getString(4);
		if(sCurrencyType == null) sCurrencyType = " ";
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(5)/10000);
		if(sBusinessSum == null) sBusinessSum = " ";
		sBlance = DataConvert.toMoney(rs2.getDouble(6)/10000);
		if(sBlance == null) sBlance = " ";
		sEndDate = rs2.getString(7);
		if(sEndDate == null ) sEndDate = " ";	
		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=25% align=center class=td1 >"+sGuarantorName+"&nbsp; </td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sCurrencyType+"&nbsp;</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sBlance+"&nbsp;</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sEndDate+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	rs2.getStatement().close();
	
	sSql =  " select sum(nvl(BC.BusinessSum,0)*getERate(BC.BusinessCurrency,'01',BC.ERateDate)) as BusinessSum,"
			+" sum(nvl(BC.Balance,0)*getERate(BC.BusinessCurrency,'01',BC.ERateDate)) "
			+" from BUSINESS_CONTRACT BC where serialno in (select distinct BC.SerialNo "
			+" from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR" 
			+" where CR.ObjectNo = GC.serialNo"
			+" and CR.ObjectType = 'GuarantyContract'"
			+" and BC.SerialNo=CR.SerialNo"
			+" and GC.GuarantorID = '"+sGuarangtorID+"'"
			+" and GC.CustomerID <> '"+sGuarangtorID+"')";
	rs2 = Sqlca.getResultSet(sSql);
	String sSum = "";
	String sSum1 = "" ;
	while(rs2.next())
	{
		sSum += DataConvert.toMoney(rs2.getDouble(1)/10000); 
		sSum1 += DataConvert.toMoney(rs2.getDouble(2)/10000);
	}	
	rs2.getStatement().close();	
	
	sTemp.append("   <tr>");
	sTemp.append(" <td width=25% align=center class=td1 >�ϼ�&nbsp;</td>");
	sTemp.append(" <td width=15% align=center class=td1 >"+"/"+"&nbsp;</td>");
		sTemp.append(" <td width=15% align=center class=td1 >"+sSum+"&nbsp;</td>");
	sTemp.append(" <td width=15% align=center class=td1 >"+sSum1+"&nbsp;</td>");
	sTemp.append(" <td colspan=2 align=center class=td1 >"+"/"+"&nbsp;</td>");
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


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
	sTemp.append("	<form method='post' action='03060204.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >4��������������δ��������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >����Ʒ��&nbsp;</td>");
    sTemp.append(" <td width=20%  align=center class=td1 >��ͬ����Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >��ͬ����Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >���������&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >��������&nbsp;</td>");
    sTemp.append(" </tr>");
    
    String sBusinessTypeName = "";    //ҵ��Ʒ��
	String sBusinessSum = "";    //��ͬ���
	String sBalance= "";    //��ͬ���
	String sMaturity ="" ;//������
	String sOwnerName = "";//�ܻ�����
	
    //�����˻�����Ϣ
    rs2 = Sqlca.getResultSet("select getOrgName(OrgID) as OrgName from Customer_Belong where BELONGATTRIBUTE = '1' and CustomerID = '"+sGuarangtorID+"'");
    if(rs2.next()){
    	sOwnerName = rs2.getString("OrgName");
    	if(sOwnerName == null) sOwnerName=" ";
    }
    rs2.getStatement().close();

    rs2 = Sqlca.getResultSet("select BUSINESSTYPE,getBusinessName(BUSINESSTYPE) as BusinessTypeName,"
			//+" businessSum,Balance,Maturity "
			+"nvl(BusinessSum,0)*geterate(Businesscurrency,'01',ERateDate) as businessSum,"
			+"nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate) as Balance,Maturity"
			+" from BUSINESS_contract where customerID='"+sGuarangtorID+"'" 
			+" and (FinishDate = '' or FinishDate is null) ");
	
	while(rs2.next()){
								
		sBusinessTypeName = rs2.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName=" ";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("businessSum")/10000);
		if(sBusinessSum == null) sBusinessSum="0.00";
		
		sBalance = DataConvert.toMoney(rs2.getDouble("BALANCE")/10000);
		if(sBalance == null) sBalance="0";
		
		sMaturity = rs2.getString("Maturity");
		if(sMaturity == null) sMaturity=" ";
		
		sTemp.append("   <tr>");
		sTemp.append(" <td width=20% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append(" <td width=20% align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append(" <td width=20% align=center class=td1 >"+sBalance+"&nbsp;</td>");
		sTemp.append(" <td width=20% align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append(" <td width=20% align=center class=td1 >"+sOwnerName+"&nbsp;</td>");
		sTemp.append(" </tr>");					
	}	
	rs2.getStatement().close();

	sSql = "select sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)),"+
		    " sum(nvl(BAILSUM,0)*geterate(BAILCURRENCY,'01','')) "+
		    " from BUSINESS_CONTRACT where customerID='"+sGuarangtorID+"'"+
		    " and LOWRISK='2' and (FinishDate = '' or FinishDate is null) ";
	rs2 = Sqlca.getResultSet(sSql);
	String sSumBusinessSum = "";
	String sSumCreditBalance = "";
	while(rs2.next())
	{	
	    sSumCreditBalance = DataConvert.toMoney((rs2.getDouble(1)-rs2.getDouble(2))/10000);
	    if(sSumCreditBalance == null) sSumCreditBalance="0";
	}
	rs2.getStatement().close();
	
	sSql = "select sum(nvl(BusinessSum,0)*geterate(Businesscurrency,'01',ERateDate))"+
	    " from BUSINESS_CONTRACT where customerID='"+sGuarangtorID+"'"+
	    " and (FinishDate = '' or FinishDate is null) ";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{	
		sSumBusinessSum = DataConvert.toMoney(rs2.getDouble(1)/10000);
	    if(sSumBusinessSum == null) sSumBusinessSum="0";
	}
	rs2.getStatement().close();

	sTemp.append("   <tr>");
	sTemp.append(" <td  align=center class=td1 >�ϼ�&nbsp;</td>");
	sTemp.append(" <td  align=left class=td1 >"+sSumBusinessSum+"&nbsp;</td>");
	sTemp.append(" <td  align=center class=td1 >���ų���(��Ԫ)&nbsp;</td>");
	sTemp.append(" <td colspan=2  align=left class=td1 >"+sSumCreditBalance+"&nbsp;</td>");
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


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
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
	String sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	String sGuarangtorID = "";//�����ͻ�ID��
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
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
	
	sTemp.append("<form method='post' action='070206.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left colspan=18 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > "+sNo1[i]+".6�������������еĶ��ⵣ����� </font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=25% align=center class=td1 nowrap > ��������ҵ  </td>");
	sTemp.append("   <td width=10% align=center class=td1 > ���� </td>");
	sTemp.append("   <td width=12% align=center class=td1 > ������ͬ���(��Ԫ) </td>");
	sTemp.append("   <td width=12% align=center class=td1 > ������ͬ���(��Ԫ) </td>");
	sTemp.append("   <td width=15% align=center class=td1 > ������ʽ </td>");
	sTemp.append("   <td width=15% align=center class=td1 > ��ͬ������ </td>");
	sTemp.append("   <td width=10% align=center class=td1 > �弶���� </td>");
	sTemp.append("   </tr>");
	sSql =  " select distinct BC.CustomerName,getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName,"
			+" getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResult,"
			+" getItemName('Currency',BC.BUSINESSCURRENCY) as CurrencyType,BC.BusinessSum,BC.BALANCE,BC.Maturity "
			+" from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR"
			+" where CR.ObjectNo = GC.serialNo"
			+" and CR.ObjectType = 'GuarantyContract'"
			+" and BC.SerialNo=CR.SerialNo"
			+" and GC.GuarantorID = '"+sGuarangtorID+"'";
	
	String sGuarantorName = "";
	String sGuarantyTypeName = "";
	double dBusinessSum = 0.00;
	String sBusinessSum = "";
	double dBlance = 0.00;
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
		dBusinessSum += rs2.getDouble(5)/10000;
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(5)/10000);
		if(sBusinessSum == null) sBusinessSum = " ";
		dBlance += rs2.getDouble(6)/10000;
		sBlance = DataConvert.toMoney(rs2.getDouble(6)/10000);
		if(sBlance == null) sBlance = " ";
		sEndDate = rs2.getString(7);
		if(sEndDate == null ) sEndDate = " ";	
		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=25% align=center class=td1 >"+sGuarantorName+"&nbsp; </td>");
		sTemp.append("   <td width=10% align=center class=td1 >"+sCurrencyType+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=center class=td1 >"+sBlance+"&nbsp;</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sEndDate+"&nbsp;</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	rs2.getStatement().close();
	
	sSql =  " select sum(nvl(BC.BusinessSum,0)*getERate(BC.BusinessCurrency,'01',BC.ERateDate)) as BusinessSum,"
			+" sum(nvl(BC.Balance,0)*getERate(BC.BusinessCurrency,'01',BC.ERateDate)) "
			+" from BUSINESS_CONTRACT BC where BC.SerialNo in (select BC.SerialNo from "
			+" BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR"
			+" where CR.ObjectNo = GC.serialNo"
			+" and CR.ObjectType = 'GuarantyContract'"
			+" and BC.SerialNo=CR.SerialNo"
			+" and GC.GuarantorID = '"+sGuarangtorID+"')";
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
	sTemp.append("   <td align=center class=td1 > �ϼ�: </td>");
	sTemp.append("   <td align=center class=td1 > ����� </td>");
	sTemp.append("   <td align=center class=td1 >"+sSum+"&nbsp</td>");
	sTemp.append("   <td align=center class=td1 >"+sSum1+"&nbsp</td>");
	sTemp.append("   <td colspan='4' align=left class=td1 >"+"/"+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
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
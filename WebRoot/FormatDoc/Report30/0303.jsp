<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu  2009.09.18
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

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	
	sTemp.append("<form method='post' action='0303.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left colspan=18 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.2������������еĶ��ⵣ����� </font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=15% align=center class=td1 nowrap > ��������ҵ  </td>");
	sTemp.append("   <td width=10% align=center class=td1 > ���� </td>");
	sTemp.append("   <td width=12% align=center class=td1 > ������ͬ���(��Ԫ) </td>");
	sTemp.append("   <td width=12% align=center class=td1 > ������ͬ���(��Ԫ) </td>");
	sTemp.append("   <td width=15% align=center class=td1 > ������ʽ </td>");
	sTemp.append("   <td width=15% align=center class=td1 > ��ͬ������ </td>");
	sTemp.append("   <td width=10% align=center class=td1 > �弶���� </td>");
	sTemp.append("   <td width=10% align=center class=td1 > �뱻������ҵ������ϵ </td>");
	sTemp.append("   </tr>");
	String sSql =  " select distinct BC.CustomerName,getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName,"
			+" getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResult,"
			+" getItemName('Currency',BC.BUSINESSCURRENCY) as CurrencyType,BC.BusinessSum,BC.BALANCE,BC.Maturity,BC.CustomerID"
			+" from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR"
			+" where CR.ObjectNo = GC.serialNo"
			+" and CR.ObjectType = 'GuarantyContract'"
			+" and BC.SerialNo=CR.SerialNo"
			+" and GC.GuarantorID = '"+sCustomerID+"'"
			+" and GC.CustomerID <> '"+sCustomerID+"'";	
	String sGuarantorName = "";
	String sGuarantyTypeName = "";
	double dBusinessSum = 0.00;
	String sBusinessSum = "";
	double dBlance = 0.00;
	String sBlance = "";
	String sEndDate = "";
	String sClassifyResult = "";
	String sCurrencyType= "";
	String sRCustomerID = "";
	String sRelativeShip = "";
	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
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
		sRCustomerID = rs2.getString(8);
		if(sRCustomerID == null) sRCustomerID = "";
		if(!"".equals(sRCustomerID))
		{
			String sSql1 = " select getItemName('RelationShip',RelationShip) as RelationShip from Customer_Relative "+
				    " where CustomerID = '"+sCustomerID+"' and RelativeID = '"+sRCustomerID+"'";
			ASResultSet rs3 = Sqlca.getASResultSet(sSql1);
			if(rs3.next()){
				sRelativeShip = rs3.getString(1);
				if(sRelativeShip == null) sRelativeShip = "";
			}	    
			rs3.getStatement().close();
		}		
		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sGuarantorName+"&nbsp; </td>");
		sTemp.append("   <td width=10% align=center class=td1 >"+sCurrencyType+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=center class=td1 >"+sBlance+"&nbsp;</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sEndDate+"&nbsp;</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=center class=td1 >"+sRelativeShip+"&nbsp;</td>");
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
			+" and GC.GuarantorID = '"+sCustomerID+"'"
			+" and GC.CustomerID <> '"+sCustomerID+"')";
	rs2 = Sqlca.getResultSet(sSql);
	String sSum = "";
	String sSum1 = "" ;
	while(rs2.next())
	{
		sSum += DataConvert.toMoney(rs2.getDouble(1)); 
		sSum1 += DataConvert.toMoney(rs2.getDouble(2));
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


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.18
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
	sTemp.append("	<form method='post' action='0401.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4�����ŷ�������ʷ������Ϣ</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4.1������˼��ſͻ��������������</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 > ��ҵ����</td>");
    sTemp.append(" <td width=20% align=center class=td1 > ����Ʒ�� </td>");
    sTemp.append(" <td width=10% align=center class=td1 > ���� </td>");
    sTemp.append(" <td width=10% align=center class=td1 > �������(��Ԫ)</td>");
    sTemp.append(" <td width=10% align=center class=td1 > ��ͬ���(��Ԫ)</td>");
    sTemp.append(" <td width=10% align=center class=td1 > ��ͬ��� (��Ԫ)</td>");
    sTemp.append(" <td width=10% align=center class=td1 > �弶���� </td>");
    sTemp.append(" <td width=10% align=center class=td1 > ���������� </td>");
    sTemp.append(" </tr>");
    String sCustomerName = "";//��ҵ����
    String sBusinessTypeName = "";    //ҵ��Ʒ��
	String sCurrencyTypeName = "";    //����				
	String sBusinessSum = "";    //�������
	double dBusinessSum=0.0;
	String sBalance= "";    //��ͬ���
	double dBalance=0.0;											
	String sClassifyResultName = "" ;		//�弶����
	String sMaturity ="" ;//������
			
	//�����˻�����Ϣ
	ASResultSet rs2 = Sqlca.getResultSet("select BUSINESSTYPE,getBusinessName(BUSINESSTYPE) as BusinessTypeName,"
					+" getItemName('Currency',BUSINESSCURRENCY) as CurrencyTypeName,"
					+" businessSum,BALANCE,CLASSIFYRESULT,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName, "
					+" Maturity,CustomerID,getCustomerName(CustomerID) as CustomerName "
					+" from BUSINESS_contract " 
					+" where CustomerID in "
					+" (select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"'" 
					+" and RelationShip like '04%' )");
	
	while(rs2.next()){
		
		sBusinessTypeName = rs2.getString(2);
		if(sBusinessTypeName == null) sBusinessTypeName=" ";
		
		sCurrencyTypeName = rs2.getString(3);
		if(sCurrencyTypeName == null) sCurrencyTypeName=" ";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(4)/10000);
		if(sBusinessSum == null) sBusinessSum="0";
		
		sBalance = DataConvert.toMoney(rs2.getDouble(5)/10000);
		if(sBalance == null) sBalance="0";
		
		sClassifyResultName = rs2.getString(7);
		if(sClassifyResultName == null) sClassifyResultName=" ";
		
		sMaturity = rs2.getString(8);
		if(sMaturity == null) sMaturity=" ";
		
		sCustomerName = rs2.getString(10);
		if(sCustomerName == null) sCustomerName="";
		
		sTemp.append("   <tr>");
		sTemp.append(" 		<td width=20% align=center class=td1 > "+sCustomerName+"&nbsp;</td>");
	    sTemp.append(" 		<td width=20% align=center class=td1 >  "+sBusinessTypeName+"&nbsp; </td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sCurrencyTypeName+"&nbsp;</td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sBusinessSum+"&nbsp;</td>");
	   	sTemp.append(" 		<td width=10% align=center class=td1 > "+sBusinessSum+"&nbsp;</td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sBalance+"&nbsp;</td>");
		sTemp.append(" 		<td width=10% align=center class=td1 > "+sClassifyResultName+"&nbsp; </td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sMaturity+"&nbsp;</td>");
	    sTemp.append(" 	</tr>");
	}
    rs2.getStatement().close();
    String sSumBusinessSum = "";    //	��������ܺ�
	double dSumBusinessSum = 0.0;    //	��������ܺ�	
	String sSumBalance = "";		//��������ܺ�
	double dSumBalance = 0.0;		//��������ܺ�
    rs2 = Sqlca.getASResultSet("select sum(nvl(BC.BusinessSum,0)*geterate(BC.Businesscurrency,'01',BC.ERateDate)) as SumBusinessSum,"+
    						" sum(nvl(BC.Balance,0)*geterate(BC.Businesscurrency,'01',BC.ERateDate)) as SumBalance "+
							" from BUSINESS_contract BC"+ 
							" where BC.CustomerID in  "+
							" (select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' and RelationShip like '04%' )");
	if(rs2.next()){
		sSumBusinessSum = DataConvert.toMoney(rs2.getDouble(1));
		if(sSumBusinessSum == null) sSumBusinessSum = "0";
		sSumBalance = DataConvert.toMoney(rs2.getDouble(2));
		if(sSumBalance == null) sSumBalance = "0";
	}						
	rs2.getStatement().close();						
	sTemp.append("  <tr>");
  	sTemp.append(" <td colspan='2' align=left class=td1 > �ϼƣ�</td>");
    sTemp.append(" <td width=10% align=center class=td1 > "+"�����"+"&nbsp; </td>");
    sTemp.append(" <td width=10% align=center class=td1 > "+sSumBusinessSum+"&nbsp;</td>");
    sTemp.append(" <td width=10% align=center class=td1 > "+sSumBusinessSum+"&nbsp;</td>");
    sTemp.append(" <td width=10% align=center class=td1 > "+sSumBalance+"&nbsp;</td>");
    sTemp.append(" <td colspan='2' align=center class=td1 > "+"/"+"&nbsp; </td>");
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


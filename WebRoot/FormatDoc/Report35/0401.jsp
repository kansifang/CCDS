<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   Author:   zwhu 2009.08.18
		Tester:
		Content: ����ĵ�?ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
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
	sTemp.append("<form method='post' action='0401.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4�����ŷ�������ʷ������Ϣ</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4.1���������������</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=10% align=center class=td1 > ���ŷ�ʽ </td>");
    sTemp.append(" 		<td width=10% align=center class=td1 > ����Ʒ�� </td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >����</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >��������Ԫ��</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >��ͬ����Ԫ��</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >��ͬ����Ԫ��</td>");
   	sTemp.append(" 		<td width=10% align=center class=td1 >��֤�����%</td>");
   	sTemp.append(" 		<td width=10% align=center class=td1 >���������</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >������ʽ</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >�弶����</td>");
    sTemp.append(" 	</tr>");
    
	String sBusinessTypeName = "";    //ҵ��Ʒ��
	String sCurrencyType = "";    //����					
	String sBusinessSum = "";    //���
	double dBusinessSum=0.0;
	String sBalance= "";    //��ͬ���
	double dBalance=0.0;											
	String sBailRatio = "";   	//��֤�����
	double dBailRatio = 0.00;
	String sClassifyResultName = "" ;		//�弶����
	String sMaturity ="" ;//������
	String sVouchType = "" ;//������ʽ
	String sApplyType = "";//���ŷ�ʽ				
	//�����˻�����Ϣ
	ASResultSet rs2 = Sqlca.getResultSet("select BUSINESSTYPE,getBusinessName(BUSINESSTYPE) as BusinessTypeName,getItemName('Currency',BUSINESSCURRENCY),"
								+" businessSum,BailRatio,Balance,CLASSIFYRESULT,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName, "
								+" Maturity,getItemName('VouchType',VouchType) as VouchType "
								+" ,getItemName('BusinessApplyType',ApplyType) as ApplyType "
								+" from BUSINESS_contract where customerID='"+sCustomerID+"'" );
	while(rs2.next()){
		sBusinessTypeName = rs2.getString(2);
		if(sBusinessTypeName == null) sBusinessTypeName=" ";
	
		sCurrencyType = rs2.getString(3);
		if(sCurrencyType == null) sCurrencyType=" ";
		
		sBusinessSum = rs2.getString(4);
		if(sBusinessSum == null) sBusinessSum="0";
		dBusinessSum = DataConvert.toDouble(sBusinessSum)/10000;
		
		sBailRatio = rs2.getString(5);
		if(sBailRatio == null) sBailRatio="0";
		dBailRatio = DataConvert.toDouble(sBailRatio);
		
		sBalance = rs2.getString(6);
		if(sBalance == null) sBalance="0";
		dBalance = DataConvert.toDouble(sBalance)/10000;
		
		sClassifyResultName = rs2.getString(8);
		if(sClassifyResultName == null) sClassifyResultName=" ";
		
		sMaturity = rs2.getString(9);
		if(sMaturity == null) sMaturity=" ";
		
		sVouchType = rs2.getString(10);
		if(sVouchType == null) sVouchType=" ";
		
		sApplyType = rs2.getString("ApplyType");
		if(sApplyType == null) sApplyType = "";	
		
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td width=10% align=center class=td1 > "+sApplyType+"&nbsp; </td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 >  "+sBusinessTypeName+"&nbsp; </td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sCurrencyType+"&nbsp;</td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+dBusinessSum+"&nbsp;</td>");
	   	sTemp.append(" 		<td width=10% align=center class=td1 > "+dBusinessSum+"&nbsp;</td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+dBalance+"&nbsp;</td>");
	    	sTemp.append(" 		<td width=10% align=center class=td1 > "+dBailRatio+"&nbsp;</td>");
		sTemp.append(" 		<td width=10% align=center class=td1 > "+sMaturity+"&nbsp; </td>");
		sTemp.append(" 		<td width=10% align=center class=td1 > "+sVouchType+"&nbsp; </td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sClassifyResultName+"&nbsp;</td>");
	    sTemp.append(" 	</tr>");
	}
    rs2.getStatement().close();
	String sSql = "select sum(nvl(BusinessSum,0)*geterate(Businesscurrency,'01',ERateDate)),"+
		    " sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)) "+
            " from BUSINESS_CONTRACT where customerID='"+sCustomerID+"'";
    rs2 = Sqlca.getResultSet(sSql);
    String sSumBusinessSum = "";
    double dSumBusinessSum = 0.0;
    String sSumBalance = "";
    double dSumBalance = 0.0;
	while(rs2.next())
	{	sSumBusinessSum = rs2.getString(1);
		if(sSumBusinessSum == null) sSumBusinessSum="0";
		dSumBusinessSum = DataConvert.toDouble(sSumBusinessSum)/10000;
		sSumBalance = rs2.getString(2);
		if(sSumBalance == null) sSumBalance="0";
		dSumBalance = DataConvert.toDouble(sSumBalance)/10000;
	}
    rs2.getStatement().close();
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan='2' align=left class=td1 > �ϼ�: </td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >�����</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >"+dSumBusinessSum+"&nbsp;</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >"+dSumBusinessSum+"&nbsp;</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >"+dSumBalance+"&nbsp;</td>");
   	sTemp.append(" 		<td colspan='2' align=center class=td1 >���ų��ڣ���Ԫ��</td>");
    sTemp.append(" 		<td colspan='2' align=center class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
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

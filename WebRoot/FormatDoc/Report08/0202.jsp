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
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
	String sConditionID = "'"+sCustomerID+"'";
	String sSql = " select RelativeID from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' "+
				  " and RelationShip like '0301%' and EffStatus = '1' ";
	ASResultSet rs2= Sqlca.getASResultSet(sSql);
	while(rs2.next()){
		String sRelativeID = rs2.getString("RelativeID");
		if(sRelativeID == null) sRelativeID = "";
		if(!"".equals(sRelativeID)){
			sConditionID = sConditionID+",'"+rs2.getString("RelativeID")+"'";
		}	
	}
	rs2.getStatement().close();	
	sSql = " select getCustomerName(CustomerID) as CustomerName,getBusinessName(BusinessType) as BusinessTypeName," +
		   		  " Balance,getItemName('Currency',BusinessCurrency) as CurrencyName,"+
		          " BailRatio,BusinessRate,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,TermMonth "+
		          " from BUSINESS_CONTRACT "+
		          " where CustomerID in ("+sConditionID+")"+
		          " and DeleteFlag is null "+
		          " and Balance>0 and (FinishDate = '' or FinishDate is null)";
	String sBusinessTypeName = "";
	double dBalance = 0.0;
	String sBalance = "";
	String sCurrencyName = "";
	String sBailRatio = "";
	String sBusinessRate = "";
	String sClassifyResult = "";
	int iTermMonth = 0;
	String sCustomerName = "";
	
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0202.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2 �����˻�����Ϣ</font></td>"); 	
	sTemp.append(" </tr>");
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2������˼���ż�����е�����ҵ����Ϣ</font></td>"); 	
	sTemp.append(" </tr>");
	sTemp.append(" <tr>");
	sTemp.append(" <td width=15% align=center class=td1 > ����</td>");
  	sTemp.append(" <td width=15% align=center class=td1 > ����ҵ��Ʒ��</td>");
    sTemp.append(" <td width=10% align=center class=td1 > ����Ԫ�� </td>");
    sTemp.append(" <td width=10% align=center class=td1 > ���� </td>");
    sTemp.append(" <td width=10% align=center class=td1 > ��������(�£�</td>");
    sTemp.append(" <td width=15% align=center class=td1 > ��֤�������</td>");
    sTemp.append(" <td width=15% align=center class=td1 > �����ʡ� </td>");
    sTemp.append(" <td width=20% align=center class=td1 > �弶���� </td>");
    sTemp.append(" </tr>");
    
    rs2 = Sqlca.getASResultSet(sSql);
	
	//added by fxie
	NumberFormat nf = NumberFormat.getInstance();
    nf.setMinimumFractionDigits(6);
    nf.setMaximumFractionDigits(6);
    	
	while(rs2.next())
	{	
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "";
		sBusinessTypeName = rs2.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName=" ";
		dBalance += rs2.getDouble("Balance")/10000;
		sBalance = DataConvert.toMoney(rs2.getDouble("Balance")/10000);
		if(sBalance == null) sBalance="0.0";
		sCurrencyName = rs2.getString("CurrencyName");
		if(sCurrencyName == null) sCurrencyName=" ";
		sBailRatio = DataConvert.toMoney(rs2.getDouble("BailRatio"));
		
		//sBusinessRate = DataConvert.toMoney(rs2.getDouble(5));
		//���ʱ���6λС��
		sBusinessRate = nf.format(rs2.getDouble("BusinessRate"));
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult=" ";
		iTermMonth = rs2.getInt("TermMonth");
		sTemp.append(" <tr>");
		sTemp.append(" <td width=15% align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append(" <td width=15% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append(" <td width=10% align=right class=td1 >"+sBalance+"&nbsp;</td>");
		sTemp.append(" <td width=10% align=center class=td1 >�����</td>");
		sTemp.append(" <td width=10% align=right class=td1 >"+iTermMonth+"&nbsp;</td>");		
		sTemp.append(" <td width=15% align=right class=td1 >"+sBailRatio+"&nbsp;</td>");
		sTemp.append(" <td width=15% align=right class=td1 >"+sBusinessRate+"&nbsp;</td>");
		sTemp.append(" <td width=20% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append(" </tr>");
	}
	rs2.getStatement().close();
	
	sSql = " select getItemName('Currency',BusinessCurrency) as CurrencyName,sum(Balance)"+
           " from BUSINESS_CONTRACT "+
           " where CustomerID in("+sConditionID+") and Balance>0 and DeleteFlag is null and (FinishDate = '' or FinishDate is null) group by BusinessCurrency"; 
	rs2 = Sqlca.getResultSet(sSql);
	String sSum = "";
	while(rs2.next())
	{
		sSum += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+DataConvert.toMoney(rs2.getString(2))+"<br>"; 
	}	
	rs2.getStatement().close();	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > �ܼ�: </td>");
	sTemp.append("   <td colspan='7' align=left class=td1 >"+sSum+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	String sContractCondition = "";
	sSql = " select ar.Serialno from  GUARANTY_CONTRACT gc, contract_RELATIVE  ar "+
		   " where GuarantorID in ("+sConditionID+") and gc.serialno = ar.objectno ";
	rs2 = Sqlca.getASResultSet(sSql);
	while(rs2.next()){
		String sTemp1 = rs2.getString(1);
		if(sTemp1 == null) sTemp1  = "";
		if(!"".equals(sTemp1)){
			sContractCondition += ",'"+sTemp1+"'";
		}
	}	 
	if(sContractCondition.length()>1)
		sContractCondition = sContractCondition.substring(1);
	rs2.getStatement().close(); 
	if("".equals(sContractCondition)){
		sContractCondition = "SerialNo = '" + sContractCondition+"'";
	} 
	else{
		sContractCondition = "SerialNo in ("+sContractCondition+")";
	}
	sSql = " select getCustomerName(CustomerID) as CustomerName,getBusinessName(BusinessType) as BusinessTypeName," +
		   		  " Balance,getItemName('Currency',BusinessCurrency) as CurrencyName,"+
		          " BailRatio,BusinessRate,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,TermMonth "+
		          " from BUSINESS_CONTRACT "+
		          " where "+sContractCondition+
		          " and DeleteFlag is null "+
		          " and Balance>0 and (FinishDate = '' or FinishDate is null)";
		          	
	rs2 = Sqlca.getASResultSet(sSql);
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3������˼���ż���ⵣ����Ϣ</font></td>"); 	
	sTemp.append(" </tr>");
	sTemp.append(" <tr>");
	sTemp.append(" <td width=15% align=center class=td1 > ����</td>");
  	sTemp.append(" <td width=15% align=center class=td1 > ����ҵ��Ʒ��</td>");
    sTemp.append(" <td width=10% align=center class=td1 > ����Ԫ�� </td>");
    sTemp.append(" <td width=10% align=center class=td1 > ���� </td>");
    sTemp.append(" <td width=10% align=center class=td1 > ��������</td>");
    sTemp.append(" <td width=15% align=center class=td1 > ��֤�������</td>");
    sTemp.append(" <td width=15% align=center class=td1 > �����ʡ� </td>");
    sTemp.append(" <td width=20% align=center class=td1 > �弶���� </td>");
    sTemp.append(" </tr>");
	while(rs2.next())
	{	
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "";
		sBusinessTypeName = rs2.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName=" ";
		dBalance += rs2.getDouble("Balance")/10000;
		sBalance = DataConvert.toMoney(rs2.getDouble("Balance")/10000);
		if(sBalance == null) sBalance="0.0";
		sCurrencyName = rs2.getString("CurrencyName");
		if(sCurrencyName == null) sCurrencyName=" ";
		sBailRatio = DataConvert.toMoney(rs2.getDouble("BailRatio"));
		
		//sBusinessRate = DataConvert.toMoney(rs2.getDouble(5));
		//���ʱ���6λС��
		sBusinessRate = nf.format(rs2.getDouble("BusinessRate"));
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult=" ";
		iTermMonth = rs2.getInt("TermMonth");
		sTemp.append(" <tr>");
		sTemp.append(" <td width=15% align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append(" <td width=15% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append(" <td width=10% align=right class=td1 >"+sBalance+"&nbsp;</td>");
		sTemp.append(" <td width=10% align=center class=td1 >�����</td>");
		sTemp.append(" <td width=10% align=right class=td1 >"+iTermMonth+"&nbsp;</td>");		
		sTemp.append(" <td width=15% align=right class=td1 >"+sBailRatio+"&nbsp;</td>");
		sTemp.append(" <td width=15% align=right class=td1 >"+sBusinessRate+"&nbsp;</td>");
		sTemp.append(" <td width=20% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append(" </tr>");
	}
	rs2.getStatement().close();
	
	sSql = " select getItemName('Currency',BusinessCurrency) as CurrencyName,sum(Balance)"+
           " from BUSINESS_CONTRACT "+
           " where "+sContractCondition+" and Balance>0 and DeleteFlag is null and (FinishDate = '' or FinishDate is null) group by BusinessCurrency"; 
	rs2 = Sqlca.getResultSet(sSql);
	sSum = "";
	while(rs2.next())
	{
		sSum += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+DataConvert.toMoney(rs2.getString(2))+"<br>"; 
	}	
	rs2.getStatement().close();	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > �ܼ�: </td>");
	sTemp.append("   <td colspan='7' align=left class=td1 >"+sSum+"&nbsp;</td>");
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
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
				Method:   ���� 1:display;2:save;3:preview;4:export
				FirstSection: �ж��Ƿ�Ϊ����ĵ�һҳ
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 12;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[0][0] = "true";
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
	ASResultSet rs = null;
	String sVouchModulus = "";//����ϵ��
	String sEvaluateResult = "";
	double dEvaluateModulus = 0.0 ;
	String sGuarantorName = "";
	String sBusinessTypeName = "";
	String sBusinessCurrency = "";
	String sBusinessSum = "";
	String sTermMonth = "";
	String sPurpose = "";
	String sRateFloat = "";
	String sCorpusPayMethod = "";
	String sVouchType = "";
	String sMonthReturnSum = "";
	String sIndRate = "";
	String sCreditLevel = "";
	double dRiskEvaluate = 0.0;
	String sClassifyResult = "";
	String sOccurType = "";
	String sSql = " select getBusinessName(BusinessType) as BusinessTypeName,getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
				  " BusinessSum,TermMonth,Purpose,RateFloat,getItemName('CorpusPayMethod2',CorPusPayMethod) as CorpusPayMethod, "+
				  " getItemName('VouchType',VouchType) as VouchType,OccurType "+
				  " from Business_Apply where SerialNo = '"+sObjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sBusinessTypeName = rs.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		sBusinessCurrency = rs.getString("BusinessCurrency");
		if(sBusinessCurrency == null) sBusinessCurrency = "";
		sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
		sTermMonth = rs.getString("TermMonth");
		if(sTermMonth == null) sTermMonth = "";
		sPurpose = rs.getString("Purpose");
		if(sPurpose == null) sPurpose = "";
		sRateFloat = rs.getString("RateFloat");
		if(sRateFloat == null) sRateFloat = "";
		sCorpusPayMethod = rs.getString("CorpusPayMethod");
		if(sCorpusPayMethod == null) sCorpusPayMethod = "";
		sVouchType = rs.getString("VouchType");
		if(sVouchType == null) sVouchType = "";
		sOccurType = rs.getString("OccurType");
		if(sOccurType == null) sOccurType = "";
	}
	rs.getStatement().close();			  
	sSql = " select MonthReturnSum,IndRate,getItemName('CreditLevel',CreditLevel) as CreditLevel from Ind_Info where CustomerID = '"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sMonthReturnSum = DataConvert.toMoney(rs.getDouble("MonthReturnSum"));
		sIndRate = rs.getString("IndRate");
		if(sIndRate == null) sIndRate = "";
		sCreditLevel = rs.getString("CreditLevel");
		if(sCreditLevel == null) sCreditLevel = "";		
	}
	rs.getStatement().close();
	sSql = "select distinct GuarantorName from guaranty_contract where serialno in (select objectno from apply_relative where serialno='"+sObjectNo+"' and objecttype='GuarantyContract') and CustomerID = '"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sGuarantorName += rs.getString("GuarantorName")+",";
	}
	if(sGuarantorName == null) sGuarantorName = "";
	if(sGuarantorName != null && !"".equals(sGuarantorName))
		sGuarantorName = sGuarantorName.substring(0,sGuarantorName.length()-1);
	rs.getStatement().close();
	if(sGuarantorName == null) sGuarantorName = "";			  
	sSql = "select EvaluateResult,EvaluateModulus,VouchModulus,RiskEvaluate from Risk_Evaluate where ObjectNo ='"+sObjectNo+"' and ObjectType='CreditApply' "	;	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		dEvaluateModulus = rs.getDouble("EvaluateModulus");
		sVouchModulus = rs.getString("VouchModulus");
		if(sVouchModulus == null) sVouchModulus = "";
		sEvaluateResult = rs.getString("EvaluateResult");
		if(sEvaluateResult == null) sEvaluateResult = "";
		dRiskEvaluate = rs.getDouble("RiskEvaluate");
	}  
	rs.getStatement().close();
	
	if("015".equals(sOccurType) || "020".equals(sOccurType) ||"060".equals(sOccurType))
		sClassifyResult = Sqlca.getString("select getItemName('ClassifyResult',ClassifyResult) from business_contract where serialno in " +
			" (select BD.RelativeSerialno2 from BUSINESS_DUEBILL BD,APPLY_RELATIVE AR where BD.SerialNo = AR.ObjectNo "+
			" and AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType = 'BusinessDueBill' )"+
			" order by  ClassifyResult desc fetch first 1 rows only ");
	else if("030".equals(sOccurType)){
		sClassifyResult = Sqlca.getString("select getItemName('ClassifyResult',ClassifyResult) from business_contract where seriaLno in"+ 
			" (select RR.ObjectNo from APPLY_RELATIVE AR,REFORM_RELATIVE RR where RR.SerialNo = AR.ObjectNo "+
			" and AR.ObjectType = 'CapitalReform' and RR.ObjectType = 'BusinessContract'  and AR.SerialNo = '"+sObjectNo+"') "+
			" order by  ClassifyResult desc fetch first 1 rows only ");
	}				
	if(sClassifyResult == null) sClassifyResult = "";
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���������������</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > ����ҵ��Ʒ�� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > ���� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sBusinessCurrency+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > ����������Ԫ�� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > �������ޣ��£� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sTermMonth+"&nbsp;</td>");
    sTemp.append(" 	</tr>");    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > ������; </td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sPurpose+"&nbsp;</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > ��������ʣ�%�� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sRateFloat+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > ���ʽ </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sCorpusPayMethod+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > �¾������ </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sMonthReturnSum+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > ��Ҫ������Դ </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > �¹�ռ������� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sIndRate+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > ��/��Ѻ������ </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:'70'",getUnitData("describe1",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > ��/��Ѻ��һ��ʹ��<br/>����/����ʹ��ʱ�� </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:'70'",getUnitData("describe2",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > ��/��Ѻ���ܼ�ֵ </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:'70'",getUnitData("describe3",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ��/��Ѻ��ƽ������ </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:'70'",getUnitData("describe4",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ��/��Ѻ����; </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:'70'",getUnitData("describe5",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("  </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ��Ѻ������/��� </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:'70'",getUnitData("describe6",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ��/��Ѻ��</td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:'70'",getUnitData("describe7",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("  </tr>");  
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ��Ѻ���Ƿ��� </td>");
  	sTemp.append("   <td  colspan = '3' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:'70'",getUnitData("describe8",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("  </tr>"); 
	sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > ��֤�� </td>");
    sTemp.append("     <td colspan = '3' align=left class=td1 >"+sGuarantorName+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ������ʽϵ����%�� </td>");
    sTemp.append("     <td align=left class=td1 >"+sVouchModulus+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > �弶������ </td>");
    sTemp.append("     <td align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ������������</td>");
    sTemp.append("     <td align=left class=td1 >"+sEvaluateResult+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ��������ϵ����%��  </td>");
    sTemp.append("     <td align=left class=td1 >"+dEvaluateModulus+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ���ն� </td>");
    sTemp.append("     <td align=left class=td1 >"+dRiskEvaluate+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ��/��Ѻ����; </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:'70'",getUnitData("describe9",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > ����˵���� </td>");
  	sTemp.append("   <td  colspan = '3' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:'70'",getUnitData("describe10",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("	 </tr>");    
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > �����гʱ��� </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:'70'",getUnitData("describe11",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ���к˶��� </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:'70'",getUnitData("describe12",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("  </tr>");  
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

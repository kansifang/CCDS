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
	int iDescribeCount = 3;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessSum = "";
	String sCurrency = "";
	String sBailRatio = "";
	String sBusinessRate = "";
	String sClassifyResult = "";
	String sVouchType = "";
	int sTermMonth = 0;
	String sCorpusPayMethod = "";
	String sMonthReturnSum = "";
	Double dRateFloat = 0.0;
	String sRateFloatType = "";
	
	
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,getBusinessName(BusinessType)as BusinessType,BusinessSum,"
										+"getitemname('Currency',BusinessCurrency) as CurrencyName ,BusinessRate,"
										+"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"
										+"getitemname('VouchType',VouchType) as VouchTypeName,purpose, "
										+"TermMonth,getItemname('CorpusPayMethod2',CorpusPayMethod) as CorpusPayMethod ,"
										+"RateFloat,getItemname('RateFloatType',RateFloatType) as RateFloatType , "
										+"getOrgName(OperateOrgID) as OperateOrgName,"
										+"getUserName(OperateUserID) as OperateUserName "
										+"from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "&nbsp;";
		
		sBusinessTypeName = rs2.getString("BusinessType");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum")/10000);
		
		sCurrency = rs2.getString("CurrencyName");
		if(sCurrency == null) sCurrency = " ";
		sTermMonth = rs2.getInt("TermMonth")/12;
		sBusinessRate = rs2.getString("BusinessRate");
		if(sBusinessRate  == null) sBusinessRate  = " ";
		dRateFloat = rs2.getDouble("RateFloat");
		if(dRateFloat <0) dRateFloat = 0-dRateFloat;
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = " ";
		
		sRateFloatType = rs2.getString("RateFloatType");
		if(sRateFloatType == null) sRateFloatType = " ";
		
		sVouchType = rs2.getString("VouchTypeName");
		if(sVouchType == null) sVouchType = " ";
		
		sCorpusPayMethod = rs2.getString("CorpusPayMethod");
		if(sCorpusPayMethod== null) sCorpusPayMethod = " ";
	
		}
		rs2.getStatement().close();	
		//sMonthReturnSum = DataConvert.toMoney(Sqlca.getString("select MonthReturnSum from IND_INFO where CustomerID='"+sCustomerID+"' "));
		//if(sMonthReturnSum == null) sMonthReturnSum = " ";
%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");

	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >����������ۺ����</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1  >7������˽������������ʵ����ȫ�������˾��л������������ϸ��˴�����������ͬ�⣺");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >��1��<u>"+sBusinessTypeName+"</u>��ҵ��Ʒ�֣����������ʽΪ<u>"+sVouchType+"</u>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >��2�����:<u>"+sBusinessSum+"</u>&nbsp;��Ԫ������:<u>");
	sTemp.append(sCurrency+"</u>&nbsp;������:<u>"+sTermMonth+"</u>&nbsp;�ꣻ");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >��3��������:<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:15%; height:25'",getUnitData("describe0",sData)));
	sTemp.append("</u>%����׼����");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe7'",getUnitData("describe7",sData),"�ϸ�@�¸�"));
	//sTemp.append("&nbsp;<u>"+dRateFloat+"</u>&nbsp;�������ͣ�"+sRateFloatType+"(���Ϊ�������ʣ��ǰٷֱ�)����");
	sTemp.append("&nbsp;<u>"+dRateFloat+"&nbsp </u>%��</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >��4�����ʽ:<u>"+sCorpusPayMethod+"&nbsp;&nbsp;&nbsp;</u>��");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >��5���¾������:<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' ",getUnitData("describe1",sData))+"&nbsp;</u>Ԫ��");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >ǩԼ��֤�˱�֤��");
	sTemp.append("   <br>");
	sTemp.append("   ��ѭ��ʵ��׼ȷ����������Чԭ��<br>");
	sTemp.append("   ��1�����������ṩ�����ϸ�ӡ������ԭ���Ѿ�����˶ԣ���֤������һ�£�<br>");
	sTemp.append("   ��2�����н���������غ�ͬ���ļ��ϵ�ǩ�־�Ϊ�ױ�ǩ�𣬱�֤���н���ļ�������ǩ����Ч��ʧȥ����Ч����");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   &nbsp;������ǩ�֣� &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Э����ǩ�֣�");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
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
	//editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ
	//editor_generate('describe2');
	//editor_generate('describe3');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

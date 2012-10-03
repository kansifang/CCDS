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
	int iDescribeCount = 33;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	//sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
	String sCustomerName = "";			//����������
	String sBusinessType = "";			//ҵ��Ʒ��
	String sBusinessTypeName = "";		//����ҵ��Ʒ������
	String sBusinessSum = "";			//���
	double dBusinessSum = 0.0;
	String sCurrency = "";				//����
	String sBailRatio = "";				//��֤�������
	String sBusinessRate = "";			//����
	String sPdgRatio = "";				//��������
	String sClassifyResult = "";		//�弶����
	String sVouchType = "";				//������ʽ
	String sPurpose = "";				//�ʽ���;
	
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,BusinessType,getBusinessName(BusinessType)as BusinessTypeName,BusinessSum,"
										+"getitemname('Currency',BusinessCurrency) as CurrencyName ,BailRatio,BusinessRate,PdgRatio, "
										+"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"
										+"getitemname('VouchType',VouchType) as VouchTypeName,purpose "
										+"from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "&nbsp;";
		
		sBusinessType = rs2.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = " ";
		
		sBusinessTypeName = rs2.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum"));
		if(sBusinessSum == null) sBusinessSum = "0";
		
		sCurrency = rs2.getString("CurrencyName");
		if(sCurrency == null) sCurrency = " ";
		
		sBailRatio = DataConvert.toMoney(rs2.getDouble("BailRatio"));

		//sBusinessRate = DataConvert.toMoney(rs2.getDouble("BusinessRate"));
		//���ʱ���6λС��
        NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(6);
        nf.setMaximumFractionDigits(6);
		sBusinessRate = nf.format(rs2.getDouble("BusinessRate"));
		
		sPdgRatio = DataConvert.toMoney(rs2.getDouble("PdgRatio"));
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = " ";
		
		sVouchType = rs2.getString("VouchTypeName");
		if(sVouchType == null) sVouchType = " ";
		
		sPurpose = rs2.getString("purpose");
		if(sPurpose == null) sPurpose = "  ";
	}
	
	rs2.getStatement().close();	
	
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >һ�������˻�����Ϣ</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 >���˶Խ����<u>"+sCustomerName+"</u>�Ľ�����뼰�й������Ѿ���ˣ������ʵ��ӳ���£�</td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 >1��������Ϊ��</td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=10 class=td1 >&nbsp;&nbsp;");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"���ؾ���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"���й���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"�Ǳ��й���"));
	sTemp.append("   <br>&nbsp;&nbsp;");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"��ؾ���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe5'",getUnitData("describe5",sData),"���й���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe6'",getUnitData("describe6",sData),"�Ǳ��й���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"�б��о�ס֤��"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"�ޱ��о�ס֤��"));
	sTemp.append("   <br>&nbsp;&nbsp;");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe9'",getUnitData("describe9",sData),"�������"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe10'",getUnitData("describe10",sData),"���й���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe11'",getUnitData("describe11",sData),"�Ǳ��й���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe12'",getUnitData("describe12",sData),"�б��о�ס֤��"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe13'",getUnitData("describe13",sData),"�ޱ��о�ס֤��"));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 >2�����������˽�����޼��㣬����ʱ����������Ϊ<u>");	
	sTemp.append(myOutPut("2",sMethod,"name='describe14' ",getUnitData("describe14",sData))+"&nbsp;</u>����");
	sTemp.append("  </td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 >3������ѯ�����������ϣ������ˣ���ż������������������£�</td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=10 class=td1 >��1��");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe15'",getUnitData("describe15",sData),"�޲������ü�¼"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe16'",getUnitData("describe16",sData),"���������"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe17'",getUnitData("describe17",sData),"�ڸ�������ϵͳ���޼�¼"));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >��2��");
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe18'",getUnitData("describe18",sData),"���������ϼ�<u>"));
    sTemp.append(myOutPut("2",sMethod,"name='describe19' ",getUnitData("describe19",sData))+"&nbsp;</u>�ʣ��ϼ��»���<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe20' ",getUnitData("describe20",sData))+"&nbsp;</u>Ԫ");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >��3��");
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe21'",getUnitData("describe21",sData),"�н�����ڣ����ڽ��ϼ�<u>"));
    sTemp.append(myOutPut("2",sMethod,"name='describe22' ",getUnitData("describe22",sData))+"&nbsp;</u>Ԫ");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    
    String sEvaluateScore=DataConvert.toMoney(Sqlca.getString("select EvaluateScore from Evaluate_Record where ObjectNo='"+sCustomerID+"'  order by AccountMonth DESC fetch first 1 row only "));
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >��4�����������ű������÷�����<u>"+sEvaluateScore+"&nbsp;</u>��");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    
    String sRiskEvaluate = "";		//���ŷ��ն�
	String sEvaluateModulus = "";	//��������ϵ��
	String sVouchModulus = "";      //������ʽϵ��
	String sSql = "select RiskEvaluate,EvaluateModulus,VouchModulus from Risk_Evaluate where ObjectNo ='"+sObjectNo+"'";
    rs2 = Sqlca.getResultSet(sSql);
    if(rs2.next())
    {
    	sRiskEvaluate = rs2.getString("RiskEvaluate");
		if(sRiskEvaluate == null) sRiskEvaluate = " ";
		sEvaluateModulus = rs2.getString("EvaluateModulus");
		if(sEvaluateModulus == null) sEvaluateModulus = " ";
		sVouchModulus = rs2.getString("VouchModulus");
		if(sVouchModulus == null) sVouchModulus = " ";
    }
    rs2.getStatement().close();	
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >4������ҵ�����ŷ��ն�R��<u>"+sRiskEvaluate);
    sTemp.append("&nbsp;</u>&nbsp;&nbsp;��������ϵ����<u>"+sEvaluateModulus);
    sTemp.append("&nbsp;</u>&nbsp;&nbsp;������ʽϵ����<u>"+sVouchModulus+"&nbsp;</u>");
    //sTemp.append(myOutPut("2",sMethod,"name='describe26' style='width:10%; '",getUnitData("describe26",sData))+"&nbsp;");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >5����ϵͳ��ѯ�������ˡ���ͥĿǰ�����д�������������ѷ���δ����ġ����ڰ����еģ���");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >��1�������ˣ����˴����ۼ��������<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe27' ",getUnitData("describe27",sData))+"&nbsp;</u>��Ԫ���ۼƽ������<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe28' ",getUnitData("describe28",sData))+"&nbsp;</u>ƽ����");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >��2����ͥ�����˴����ۼ��������<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe29' ",getUnitData("describe29",sData))+"&nbsp;</u>��Ԫ���ۼƽ������<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe30' ",getUnitData("describe30",sData))+"&nbsp;</u>ƽ����");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >��������ס�������϶�<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe31' ",getUnitData("describe31",sData))+"&nbsp;</u>(����ס������)");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >��3���������������¾������<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe32' ",getUnitData("describe32",sData))+"&nbsp;</u>Ԫ,�»�����<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe33' ",getUnitData("describe33",sData))+"&nbsp;</u>%");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ͥ���ݴ���֧��<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe34' ",getUnitData("describe34",sData))+"&nbsp;Ԫ,</u>�ϼ�֧���������<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe35' ",getUnitData("describe35",sData))+"&nbsp;</u>%");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ͥ��ծ�ܶ�<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe36' ",getUnitData("describe36",sData))+"&nbsp;</u>Ԫ,ȫ��ծ���¾���������������<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe37' ",getUnitData("describe37",sData))+"&nbsp;</u>%");
    sTemp.append("  </td> ");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


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
	String sBusinessType = "";  //ҵ��Ʒ��
	double dBusinessSum = 0.0;  //������
	String sCurrency = "";      //����
	String sVouchTypeName = ""; //������ʽ
	double dTermMonth = 0.0;     //����
	double dBaseRate = 0.0;      //��׼����
	double dBusinessRate = 0.0;  //ִ��������
	double dRateFloat = 0.0;     //���ʸ���ֵ
	String sCorPusPayMethod = "";//���ʽ
	String sCurrencyName = "";    //����
	double dMonthReturnSum = 0.0; //�»����
	
	ASResultSet rs2 = Sqlca.getResultSet("select getBusinessName(BusinessType)as BusinessType,BusinessSum,"
										+"getitemname('Currency',BusinessCurrency) as CurrencyName ,"
										+"getitemname('VouchType',VouchType) as VouchTypeName, "
										+"TermMonth,BaseRate,BusinessRate,RateFloat,getItemName('CorpusPayMethod2',CorPusPayMethod) as CorPusPayMethod "
										+"from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	
	if(rs2.next())
   {
		sBusinessType=rs2.getString("BusinessType");
		if(sBusinessType == null)  sBusinessType ="";
		sVouchTypeName=rs2.getString("VouchTypeName");
		if(sVouchTypeName == null) sVouchTypeName = "";
		dBusinessSum=rs2.getDouble("BusinessSum");
		dTermMonth=rs2.getDouble("TermMonth")/12;
		dBaseRate=rs2.getDouble("BaseRate");
		sCorPusPayMethod=rs2.getString("CorPusPayMethod");
		if(sCorPusPayMethod == null) sCorPusPayMethod = "";
		sCurrencyName=rs2.getString("CurrencyName");
		if(sCurrencyName ==null) sCurrencyName = "";
		dBusinessRate=rs2.getDouble("BusinessRate");
		dRateFloat=rs2.getDouble("RateFloat");
   }
	rs2.getStatement().close();	
	dMonthReturnSum= Sqlca.getDouble("select MonthReturnSum from IND_INFO where CustomerID = (select CustomerID from BUSINESS_APPLY where SerialNo ='"+sObjectNo+"')");
%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	sTemp.append("<table class=table1 width='640'  align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append(" <tr>");	
	sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >8������˽������������ʵ����ȫ�������˾��л������������ϸ��˴�����������ͬ��</font></td>"); 	
	sTemp.append(" </tr>");	
	sTemp.append(" <tr>");
	sTemp.append("   <td  colspan=10 align=left class=td1 >");
	sTemp.append("   (1)&nbsp");
	//sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:15%; height:25'",getUnitData("describe2",sData)));
	sTemp.append("<u>"+sBusinessType+"</u>(ҵ��Ʒ��)���� ��������ʽΪ<u>"+sVouchTypeName+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append(" <br>"); 
	sTemp.append("   (2)&nbsp���");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("<u>"+dBusinessSum/10000+"</u>��Ԫ������<u>"+sCurrencyName+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));  
	sTemp.append("    ������<u>"+dTermMonth+"</u>");;
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));  
	sTemp.append("    ��");
	sTemp.append(" <br>"); 
	sTemp.append("    (3)&nbsp������<u>"); 
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:15%; height:25'",getUnitData("describe2",sData)));
	sTemp.append("</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	//sTemp.append("    %����׼����<u>"+dBaseRate+"</u>");
	sTemp.append("    %����׼����&nbsp;");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe0'",getUnitData("describe0",sData),"�ϸ�@�¸�&nbsp;"));
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));  
	sTemp.append("<u>"+dRateFloat+"</u>%��");
	sTemp.append(" <br>"); 
	sTemp.append("   (4)&nbsp���ʽ<u>"+sCorPusPayMethod+"</u>"); 
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append(" <br>"); 
	sTemp.append("   (5)&nbsp�¾������<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:15%; height:25'",getUnitData("describe1",sData)));
	//sTemp.append(""+dMonthReturnSum+"</u>Ԫ"); 
	sTemp.append("</u>Ԫ&nbsp;</td>"); 
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
	//editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

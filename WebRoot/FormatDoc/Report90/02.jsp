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
   int iDescribeCount = 26;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
//Add by zhaominglei 060308
    double dEvaluateModulus = 0.0; //��������ϵ��
	double dVouchModulus = 0.0;    //������ʽϵ��
    double dRiskEvaluate = 0.0;    //���ŷ��ն�
    String sCustomerName = "";     //�ͻ�����
    String sEvaluateScore = "";   //���ű�����������
	//�����˻�����Ϣ
	sCustomerName = Sqlca.getString("select FullName from IND_INFO where CustomerID = (select CustomerID from BUSINESS_APPLY where SerialNo ='"+sObjectNo+"')");
	ASResultSet rs2 = Sqlca.getResultSet("select VouchModulus,RiskEvaluate,EvaluateModulus from Risk_Evaluate where ObjectNo ='"+sObjectNo+"' and ObjectType='CreditApply'");
	if(rs2.next())
	{
		dVouchModulus = rs2.getDouble("VouchModulus");
		dRiskEvaluate = rs2.getDouble("RiskEvaluate");
		dEvaluateModulus = rs2.getDouble("EvaluateModulus");
	}
	rs2.getStatement().close();	
    sEvaluateScore=DataConvert.toMoney(Sqlca.getString("select EvaluateScore from Evaluate_Record where ObjectNo='"+sCustomerID+"'  order by AccountMonth DESC fetch first 1 row only "));

	//select TermModulus,RiskEvaluate from Risk_Evaluate where ObjectNo ='BA2012013000000001' and ObjectType='CreditApply'
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
StringBuffer sTemp=new StringBuffer();
sTemp.append("	<form method='post' action='02.jsp' name='reportInfo'>");	
sTemp.append("<div id=reporttable style=' FONT-FAMILY:����; '>");	

	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1��������뼰�������</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append("   ���˶Խ����<u>"+sCustomerName+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("�Ľ�����뼰�й������Ѿ���ˣ������ʵ��ӳ���£�");
	

	sTemp.append("   <br>");

    sTemp.append("   (1)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe0'",getUnitData("describe0",sData),"���ؾ���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"���й���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"�Ǳ��й���"));

	sTemp.append("   <br>");
	//sTemp.append("   <td colspan=2 align=left class=td1 >(2)</td>");

    sTemp.append("   (2)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"��ؾ���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"���й���"));
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe5'",getUnitData("describe5",sData),"�Ǳ��й���"));	
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe6'",getUnitData("describe6",sData),"�б��о�ס֤��"));
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"�ޱ��о�ס֤��"));

	sTemp.append("   <br>");
	//sTemp.append("   <td colspan=2 align=left class=td1 >(3)</td>");

    sTemp.append("   (3)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"������ʿ"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe9'",getUnitData("describe9",sData),"���й���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe10'",getUnitData("describe10",sData),"�Ǳ��й���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe11'",getUnitData("describe11",sData),"�б��о�ס֤��"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe12'",getUnitData("describe12",sData),"�ޱ��о�ס֤��"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2�����������˽�����޼���</font></td>"); 	
	sTemp.append(" </tr>");	
	sTemp.append(" <tr>");
    sTemp.append(" <td colspan=10 align=left class=td1 > ����ʱ����������Ϊ��");
	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:15%; height:25'",getUnitData("describe13",sData)));   
	sTemp.append(" ����");
    sTemp.append(" </tr>"); 
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3������ѯ�����������ϣ������ˡ���ż������������������£�</font></td>"); 	
	sTemp.append(" </tr>");
    sTemp.append(" <tr>");
    //sTemp.append(" <td colspan=1 align=left class=td1 >(1)</td>");
	sTemp.append(" <td colspan=10 align=left class=td1 >");
	sTemp.append(" (1)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe14'",getUnitData("describe14",sData),"�޲������ü�¼"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe15'",getUnitData("describe15",sData),"���������"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe16'",getUnitData("describe16",sData),"�ڸ�������ϵͳ���޼�¼"));
    //sTemp.append(" <td colspan=1 align=left class=td1 >(2)</td>");
	sTemp.append(" <br>");
	sTemp.append(" (2)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe17'",getUnitData("describe17",sData),"���������ϼ�"));
	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:15%; height:25'",getUnitData("describe18",sData)));
	sTemp.append("  �ʣ��ϼ��»���");
	sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:15%; height:25'",getUnitData("describe19",sData)));
	sTemp.append("  Ԫ ");	
    sTemp.append("  <br>");
   // sTemp.append("  <td colspan=1 align=left class=td1 >(3)</td>");
	sTemp.append(" (3)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe20'",getUnitData("describe20",sData),"�н�����ڣ����ڽ��ϼ�"));
	sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:15%; height:25'",getUnitData("describe21",sData)));
	sTemp.append("  Ԫ"); 	  
    sTemp.append("  <br>");
    //sTemp.append("  <td colspan=1 align=left class=td1 >(4)</td>");
    sTemp.append("  (4)&nbsp���������ű������÷���:<u>"+sEvaluateScore+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:15%; height:25'",getUnitData("describe22",sData)));	
	sTemp.append("  ��");
	sTemp.append("  &nbsp;</td>");   
    sTemp.append("  </tr>"); 
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=20 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4������ҵ�����ŷ��ն�</font></td>"); 	
	sTemp.append("   </tr>");		
	sTemp.append("   <tr>");     	   
    sTemp.append("   <td  colspan=20 align=left class=td1 > ����ҵ�����ŷ��ն�R��<u>"+dRiskEvaluate+"</u>");	
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("   ��������ϵ����<u>"+dEvaluateModulus+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("   ������ʽϵ����<u>"+dVouchModulus+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("   &nbsp;</td>");   
    sTemp.append("   </tr>"); 
	
	sTemp.append("  <tr>");	
	sTemp.append("  <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5����ϵͳ��ѯ�������ˡ���ͥĿǰ�����д�������������ѷ���δ����ġ����ڰ����еģ�</font></td>"); 	
	sTemp.append("  </tr>");		
	sTemp.append("  <tr>");
    //sTemp.append("  <td colspan=1 align=left class=td1 >(1)</td>");
    sTemp.append("  <td colspan=10  align=left class=td1 > (1)&nbsp�����ˣ����˴����ۼ��������");
	sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:15%; height:25'",getUnitData("describe22",sData)));
	sTemp.append("  ��Ԫ��&nbsp&nbsp�ۼƽ������");    	
	sTemp.append(myOutPut("2",sMethod,"name='describe23' style='width:15%; height:25'",getUnitData("describe23",sData)));
	sTemp.append("  ƽ���� ");  
    //sTemp.append("  <td colspan=1 align=left class=td1 >(2)</td>");
    sTemp.append("  <br>");
    sTemp.append("  (2)&nbsp��&nbsp&nbspͥ�����˴����ۼ��������");
	sTemp.append(myOutPut("2",sMethod,"name='describe24' style='width:15%; height:25'",getUnitData("describe24",sData)));  
	sTemp.append("  ��Ԫ��&nbsp&nbsp�ۼƽ������");	    
	sTemp.append(myOutPut("2",sMethod,"name='describe25' style='width:15%; height:25'",getUnitData("describe25",sData))); 
	sTemp.append("  ƽ���� ");	
	sTemp.append("  &nbsp;</td>");    
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

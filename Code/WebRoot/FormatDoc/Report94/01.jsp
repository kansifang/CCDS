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
	int iDescribeCount = 9;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<% 
   Double dEvaluateScore = 0.0;
   dEvaluateScore = Sqlca.getDouble("select EvaluateScore from Evaluate_Record where ObjectType = 'Customer' and ObjectNo=(select CustomerID from BUSINESS_APPLY where SerialNo ='"+sObjectNo+"') order by AccountMonth DESC fetch first 1 row only ");
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2�����������˽�����޼���</font></td>"); 	
	sTemp.append(" </tr>");	
	sTemp.append(" <tr>");
    sTemp.append(" <td colspan=10 align=left class=td1 > ����ʱ����������Ϊ<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:15%; height:25'",getUnitData("describe0",sData)));   
	sTemp.append("</u>����");
    sTemp.append(" </tr>"); 
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3������ѯ�����������ϣ������ˡ���ż������������������£�</font></td>"); 	
	sTemp.append(" </tr>");
    sTemp.append(" <tr>");
	sTemp.append(" <td colspan=10 align=left class=td1 >");
	sTemp.append(" (1)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"�޲������ü�¼"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"����������"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"�ڸ�������ϵͳ���޼�¼"));
    //sTemp.append(" </td>");
    //sTemp.append(" </tr>");   
    sTemp.append(" <br>"); 	
    //sTemp.append(" <tr>");
	//sTemp.append(" <td colspan=10 align=left class=td1 >");
	sTemp.append(" (2)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"���������"));
	sTemp.append("���ϼ�<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:15%; height:25'",getUnitData("describe5",sData)));
	sTemp.append("</u>�ʣ��ϼ��»���<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:15%; height:25'",getUnitData("describe6",sData)));
	sTemp.append("</u>Ԫ ");
    sTemp.append(" <br>"); 
	sTemp.append(" (3)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"�н������"));
	sTemp.append("�����ڽ��ϼ�<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:15%; height:25'",getUnitData("describe8",sData)));
	sTemp.append("</u>Ԫ");
    sTemp.append(" <br>"); 
    sTemp.append("  (4)&nbsp���������ű������÷���:<u>"+dEvaluateScore+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));	
	sTemp.append("  ��");
	sTemp.append("  &nbsp;</td>");   
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
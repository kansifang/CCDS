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
	int iDescribeCount =13;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%   
    String sCustomerName = "";
    sCustomerName = Sqlca.getString("select FullName from IND_INFO  where CustomerID =(select CustomerID from BUSINESS_APPLY where SerialNo ='"+sObjectNo+"')");
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append(" <td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���˹�ҵ�������Ҵ�����鱨��</font></td> ");	
	sTemp.append("   </tr>	");
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1��������뼰�������</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append("   ���˶Խ����<u>"+sCustomerName+"</u>");
	sTemp.append("   �Ľ�����뼰�й������Ѿ���ˣ������ʵ��ӳ���£�");
	sTemp.append("   <br>");
    sTemp.append("   (1)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe0'",getUnitData("describe0",sData),"���ؾ���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"���й���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"�Ǳ��й���"));
	sTemp.append("   <br>");
    sTemp.append("   (2)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"��ؾ���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"���й���"));
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe5'",getUnitData("describe5",sData),"�Ǳ��й���"));	
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe6'",getUnitData("describe6",sData),"�б��о�ס֤��"));
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"�ޱ��о�ס֤��"));
    sTemp.append("   <br>");
    sTemp.append("   (3)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"������ʿ"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe9'",getUnitData("describe9",sData),"���й���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe10'",getUnitData("describe10",sData),"�Ǳ��й���"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe11'",getUnitData("describe11",sData),"�б��о�ס֤��"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe12'",getUnitData("describe12",sData),"�ޱ��о�ס֤��"));
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

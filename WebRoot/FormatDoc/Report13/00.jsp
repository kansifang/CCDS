<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: ����ĵ�0ҳ
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
	int iDescribeCount = 10;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader1.jsp"%>

<%
	//��õ��鱨������

	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���治�������ص��ر���</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >һ���ͻ�����������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >1���ͻ���״");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>����������ͻ������ʸ���Ч�ԣ�������Ӫ���ʲ�����ծ��������Ȩ��Ȳ���䶯������۲���������״���������ӷ�ծ���߹���Ա���������������Ӱ�����������ش������500���֣�<font color='red'>(*����)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:80'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >2��������ʱЧ��״");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>����������֣��ʣ�Ѻ����֤������ʱЧ����Ч�ԡ���500���֣�<font color='red'>(*����)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:80'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >3�����鷽��ִ�����");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>����鷽��ִ�н��ȣ�ִ����������ʵ�����⼰��һ�����ȡ�Ĵ�ʩ����500���֣�<font color='red'>(*����)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:80'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >4�����鷽���������");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>������鷽���ĵ�����������У��漰�����ش����������·����������룺ԭһ��������Ŀ����Ϊ����������Ŀ��ԭ����������Ŀ�����������Ŷ�ȣ��漰���塢���������ʡ����޵��ش������<font color='red'>(*����)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:80'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >5������������״");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>�����弶������Ķ�������������ŵķ���״����<font color='red'>(*����)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:80'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >6��������������״");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>�ۺ���������������弶������Ķ�������������ķ���״����<font color='red'>(*����)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:80'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
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


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: ����ĵ�02ҳ
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

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//��õ��鱨������

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable style=' FONT-FAMILY:����; '>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�Խ��������</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >1.�����̸��������ǰ�ڵ�������Ƿ�һ�£�</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe1'",getUnitData("describe1",sData),"��@��&nbsp;"));
	sTemp.append("</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >2.�����̸�������Ƿ�������ì��֮����</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe2'",getUnitData("describe2",sData),"��@��&nbsp;"));
	sTemp.append("</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >3.����˵���ϵ��ַ���绰�Ƿ���ʵ��</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe3'",getUnitData("describe3",sData),"��@��&nbsp;"));
	sTemp.append("</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >4.����˶Դ����ʽ������;�Ƿ���ȷ��</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe4'",getUnitData("describe4",sData),"��@��&nbsp;"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�Դ�����;����</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >1.����˵Ĵ�����;�Ƿ���ʵ���Ϲ棺</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe5'",getUnitData("describe5",sData),"��@��"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >2.����˵Ĵ�����;�Ƿ����</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe6'",getUnitData("describe6",sData),"��@��"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�Ի�����Դ����</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >1.����˵Ļ�����Դ�Ƿ���ȷ��</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe7'",getUnitData("describe7",sData),"��@��"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >2.����˵Ļ�����Դ�Ƿ��ȶ���</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe8'",getUnitData("describe8",sData),"��@��"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >3.������Ƿ�������������Դ��</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe9'",getUnitData("describe9",sData),"��@��"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=10 align=left class=td1 >4.����������ԴΪ��<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:52%; height:25'",getUnitData("describe10",sData)));
	sTemp.append("</u></td>");
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


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
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0703.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7.3����Ҫ��Ӫ�Ͳ������</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td rowspan='2' width=30% align=left class=td1 > �� Ŀ </td>");
    sTemp.append(" 		<td width=30% align=left class=td1 > 2009 </td>");
    sTemp.append(" 		<td width=30% align=left class=td1 > 2008 </td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td width=30% align=left class=td1 > ���� </td>");
    sTemp.append(" 		<td width=30% align=left class=td1 > ���� </td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > ���������ʣ�����</td>");
    sTemp.append(" 		<td width=25% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td width=50% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > ��֧��������ʣ�����</td>");
    sTemp.append(" 		<td width=25% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td width=50% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > ��ծ�ϼ�/����ϼƣ�����</td>");
    sTemp.append(" 		<td width=25% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td width=50% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > ��Ϣծ��/��ҵ���𣨱���</td>");
    sTemp.append(" 		<td width=25% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td width=50% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
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
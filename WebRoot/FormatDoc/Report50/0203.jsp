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
	int iDescribeCount = 5;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//�жϸñ����Ƿ����
	String sSql="select finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next())
	{
		FinishFlag = rs.getString("finishdate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null)
	{
		sButtons[1][0] = "false";
	}
	else
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0203.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>��������Ӫ������ش��������</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1����ҵ���г��������������Ͳ�Ʒ����������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe17' style='width:100%; height:150'",getUnitData("describe17",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2����Ӫ����ģʽ�ͷ�չս�Է���<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe18' style='width:100%; height:150'",getUnitData("describe18",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;3����Ա���ʺ��ڲ����Ʒ���<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe19' style='width:100%; height:150'",getUnitData("describe19",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;4���ش��ͻ���¼�����<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe20' style='width:100%; height:150'",getUnitData("describe20",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;5��������Ŀ��������Ͷ�ʺ͹��̽������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe21' style='width:100%; height:150'",getUnitData("describe21",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
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
	editor_generate('describe17');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe18');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe19');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe20');		//��Ҫhtml�༭,input��û��Ҫ   
	editor_generate('describe21');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


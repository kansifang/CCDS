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
	int iDescribeCount = 7;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
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
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=25 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >һ��ҵ��������</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>��һ��</strong>ҵ��Ϲ��ԡ������ļ���Ч��<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>������</strong>��֤�𡢵�Ѻ����Ѻ����ʵ<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>������</strong>��������ǰ����������ʵ<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>���ģ�</strong>������;<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>���壩</strong>�������Ҫ�����ʵ<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>������</strong>ҵ�����ϵ��걸��<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:150'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>���ߣ�</strong>���ڿͻ���ϵ�����ʼ�¼<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:150'",getUnitData("describe7",sData)));
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
	editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe2');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe3');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe4');		//��Ҫhtml�༭,input��û��Ҫ   
	editor_generate('describe5');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe6');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe7');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.18
		Tester:
		Content: ���鱨��������
		Input Param:
			SerialNo: �ĵ���ˮ��
			ObjectNo��ҵ����ˮ��
			Method:   ���� 1:display;2:save;3:preview;4:export
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 1;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0801.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >8.1����Ӫ���������</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='6' align=left class=td1 "+myShowTips(sMethod)+" >"); 
  	sTemp.append("  <p>&nbsp;&nbsp;&nbsp;&nbsp;�����¼���������з�����</p>");
  	sTemp.append("  <p>&nbsp;&nbsp;&nbsp;&nbsp;1���̶��ʲ���Ŀ���ɺ󣬶Խ���˵ĸ����Ʒ���������г��۸�����������з�������ȷ����Щ�����ڲ������ʱ�Ļ���ֵ,�ص�������Щȡֵ�ĺ����ԡ�</p>");
  	sTemp.append("  <p>&nbsp;&nbsp;&nbsp;&nbsp;2�������ɱ���������������Ҫԭ���ϡ��������ϡ���������Դ���˹��ɱ��������ɱ�ȡֵ���ݼ�������ԣ���λ��Ʒ�ľ�Ӫ�ɱ����ܳɱ����ü������ԡ�</p>");
  	sTemp.append("  <p>&nbsp;&nbsp;&nbsp;&nbsp;3������������Խ���˵�ӯ��״���������������뱾��ĿͶ��֮ǰ��ӯ��״������ҵӯ��״���Աȣ�����������ԡ�</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='6' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
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
		editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ 
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

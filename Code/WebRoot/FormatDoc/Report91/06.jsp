<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   wangdw 2012.05.21
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
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='06.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");

	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6�� ǩԼ��֤�˱�֤��</font></td>"); 		sTemp.append("   </tr>");
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >6.1�� ���������ṩ�����ϸ�ӡ������ԭ���Ѿ�����˶ԣ���֤������һ�£�");

	sTemp.append("   <tr>");
	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >6.2�� ���н���������غ�ͬ���ļ��ϵ�ǩ�־�Ϊ�ױ�ǩ�𣬱�֤���н���ļ�����ǩ����Ч��ʧȥ����Ч����");
	sTemp.append("   </tr>"); 

	sTemp.append("   <tr>");
	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >������ǩ�֣�");
	sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	sTemp.append("   Э����ǩ�֣�");
	sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;");
	sTemp.append("   </td>");
	sTemp.append("   </tr>"); 
	
	sTemp.append("   <tr>");
	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��");
	sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	sTemp.append("   ��&nbsp;&nbsp;��&nbsp;&nbsp;��");
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
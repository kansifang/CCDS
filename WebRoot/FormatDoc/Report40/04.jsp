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
	int iDescribeCount = 2;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='04.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='5' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���ģ�����״������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 > ˵�����Ų��ϵ�������"+" "+"&nbsp;</td>");
	sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 > ");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:80'",getUnitData("describe1",sData)));
	sTemp.append("   </td>");	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td  align=left class=td1 > �������ָ�����"+" "+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>1���ʲ���ģ</p>");
  	sTemp.append("     <p>2���桢�������</p>");
  	sTemp.append("     <p>3�����������</p>");
  	sTemp.append("     <p>4����ӪЧ�����</p>");
  	sTemp.append("     <p>5���ɶ�Ȩ��仯���</p>");
  	sTemp.append("     <p>6���������</p>");
  	sTemp.append("     <p>7�����ⵣ��������£�</p>");  	
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");	
    sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 > ");
  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:80'",getUnitData("describe2",sData)));
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
	editor_generate('describe1');		
	editor_generate('describe2');		
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
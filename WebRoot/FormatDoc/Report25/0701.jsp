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
	int iDescribeCount = 7;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0701.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7.1����Ŀ�ſ�</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=20% align=center class=td1 >��Ŀ����</td>");
  	sTemp.append("   <td width=15% align=center class=td1 > ��ģ  </td>");
    sTemp.append("   <td width=10% align=center class=td1 > ��Ҫ�� </td>");
    sTemp.append("   <td width=15% align=center class=td1 > ���� </td>");
    sTemp.append("   <td width=20% align=center class=td1 > ��Ҫ�н���λ </td>");
    sTemp.append("   <td width=20% align=center class=td1 >Ͷ�������</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td width=20% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe2' style='width:100%; height:50'",getUnitData("describe2",sData)));
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe3' style='width:100%; height:50'",getUnitData("describe3",sData)));
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=10% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe4' style='width:100%; height:50'",getUnitData("describe4",sData)));
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe5' style='width:100%; height:50'",getUnitData("describe5",sData)));
	sTemp.append("&nbsp;</td>");	
  	sTemp.append("   <td width=20% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe6' style='width:100%; height:50'",getUnitData("describe6",sData)));
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=20% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe7' style='width:100%; height:50'",getUnitData("describe7",sData)));
	sTemp.append("&nbsp;</td>");	

	sTemp.append("   </tr>");
	
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='6' align=left class=td1 "+myShowTips(sMethod)+" >��Ŀ����������Ŀ������������и�����������������Ŀ���ݡ���ģ����Ҫ�ԡ����ڡ���Ҫ�н���λ��Ͷ��������ȡ�");
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

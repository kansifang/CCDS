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
	int iDescribeCount = 18;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<% 
	//��õ��鱨������

	
%>
   
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='05.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�塢����˳ֹ���ҵ������������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'> ְ�� </td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>����</td>");
    sTemp.append(" 		<td colspan=2 align=center class=td1 width='80'> ����</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>���֤����</td>");
  	sTemp.append(" 		<td colspan=2 align=center class=td1 width='80'> ���빫˾ʱ��</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>�����ҵ��ҵ����</td>");
    sTemp.append(" 		<td colspan=2 align=center class=td1 width='80'>������ְ������</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>���б���˾�ɷ����</td>");
    sTemp.append(" 	</tr>"); 
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:20' ",getUnitData("describe1",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:20' ",getUnitData("describe2",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:20' ",getUnitData("describe3",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:20' ",getUnitData("describe4",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:20' ",getUnitData("describe5",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:20' ",getUnitData("describe6",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:20' ",getUnitData("describe7",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:20' ",getUnitData("describe8",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:20' ",getUnitData("describe9",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:20' ",getUnitData("describe10",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:20' ",getUnitData("describe11",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:20' ",getUnitData("describe12",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:20' ",getUnitData("describe13",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:20' ",getUnitData("describe14",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:20' ",getUnitData("describe15",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:20' ",getUnitData("describe16",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��һ��������������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16  >ͨ��������������������<br><br>");
	sTemp.append("   1���߼������ľ��飬���쵼������רҵˮƽ�������顢���ش���������<br>");
	sTemp.append("   2���߼�������������״������Ӫҵ����<br>");
	sTemp.append("   3��������ҵ�ļ�ְ�����<br>");
	sTemp.append("   4���߼�������ȶ��ԡ����������ش����±䶯�ȣ�<br>");
	sTemp.append("   5����ҵ�Ļ��������ƶȡ����´��µĽ�����н���ƶȵȡ�<br></td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left  colspan=16> ");
	sTemp.append(myOutPut("1",sMethod,"name='describe17' style='width:100%; height:100'",getUnitData("describe17",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=16 align=left bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�������Թ���������ƶȵļ����������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16  >ͨ���������������������<br><br>");
	sTemp.append("   1���ڲ������ƶȣ�������ҵ�Ƿ����������ڲ����Ƶ���֯�ܹ��͹����ƶȣ��������ɷ��桢��졢�ڲ���Ƶȣ���<br>");
	sTemp.append("   2����˾����ṹ��������ҵ�Ƿ���ȫ�������ṹ�ļܹ��������ɶ���ᡢ���»ᡢ���»ᡢ�ܲá���ذ칫�Һ����ίԱ�ᡣ��<br>");
	sTemp.append("   3����˾�Ƿ��г��ĵ�δ��ս�Թ滮�����У���������<br></td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left  colspan=16> ");
	sTemp.append(myOutPut("1",sMethod,"name='describe18' style='width:100%; height:100'",getUnitData("describe18",sData)));
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
	editor_generate('describe17');
	editor_generate('describe18');//��Ҫhtml�༭,input��û��Ҫ
	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

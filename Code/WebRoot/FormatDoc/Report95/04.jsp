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
	int iDescribeCount = 21;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<% 
	

	
%>
   
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='04.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ġ�����˳ֹ���ҵ��Ӫ�������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��һ����Ӫ�����������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left  colspan=16 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:100'",getUnitData("describe1",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=16 align=left bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�������ش�����</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=16 align=left class=td1 > ������ҵ�Ѿ���Ҫ�������ش�����������ҵ�ʽ�Ч���Լ��������ȷ����Ӱ�졣�ش���������ش�������ơ��ش�����Ŀ���ش������Ŀ����ⵣ�����η��ա��ش������ϡ��ش��¹����⳥�ȡ�</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��������Ӧ��������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td   width=5% class=td1 >&nbsp;</td>");
	sTemp.append(" 		<td   width=45% class=td1 >ǰ������Ӧ�̣�������С������</td>");
    sTemp.append(" 		<td   width=25% class=td1 > ����Ԫ��</td>");
    sTemp.append(" 		<td   width=25% class=td1 >ռȫ���ɹ�����%</td>");
    sTemp.append("   </tr>");
   
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 1 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:20' ",getUnitData("describe3",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:20' ",getUnitData("describe4",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:20' ",getUnitData("describe5",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
   
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 2 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:20' ",getUnitData("describe6",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:20' ",getUnitData("describe7",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:20' ",getUnitData("describe8",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 3 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:20' ",getUnitData("describe9",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:20' ",getUnitData("describe10",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:20' ",getUnitData("describe11",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
   
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���ģ�������������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1>&nbsp;</td>");
	sTemp.append(" 		<td width=45% class=td1>ǰ���������̣�������С������</td>");
    sTemp.append(" 		<td width=25% class=td1> ����Ԫ��</td>");
    sTemp.append(" 		<td width=25% class=td1>ռȫ�����۱���%</td>");
    sTemp.append("   </tr>");
   
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 1 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:20' ",getUnitData("describe12",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:20' ",getUnitData("describe13",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:20' ",getUnitData("describe14",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 2 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:20' ",getUnitData("describe15",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:20' ",getUnitData("describe16",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:20' ",getUnitData("describe17",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 3 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:100%; height:20' ",getUnitData("describe18",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:100%; height:20' ",getUnitData("describe19",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:100%; height:20' ",getUnitData("describe20",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=16 align=left class=td1 > ��������������:<br>�����ۼ۸��ȶ��ԡ����������ȷ���������̽���������</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=16 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:100%; height:50' ",getUnitData("describe21",sData))+"&nbsp;</td>");
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
	editor_generate('describe2');//��Ҫhtml�༭,input��û��Ҫ
	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

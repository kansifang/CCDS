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
				Method:   ���� 1:display;2:save;3:preview;4:export
				FirstSection: �ж��Ƿ�Ϊ����ĵ�һҳ
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 34;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	//sButtons[0][0] = "false";
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������

	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0101.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >һ������˳ֹ���ҵ������Ϣ</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=3 align=left class=td1 width='120' > ��֯�������� </td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 width='160' >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:20' ",getUnitData("describe1",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=3 align=center class=td1 width='120' > ��ҵ���� </td>");
    sTemp.append(" 		<td colspan=6 align=left class=td1 width='240' >");
    sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:20'  ",getUnitData("describe2",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=3 align=left class=td1 width='120'> ע���ʱ�����Ԫ�� </td>");
    sTemp.append(" 		<td colspan=3 align=left class=td1 width='120'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:20'  ",getUnitData("describe3",sData))+"&nbsp;</td>");
    
    sTemp.append(" 		<td colspan=1 align=center class=td1 width='40'> ���� </td>");
   
    sTemp.append(" 		<td colspan=1 align=left class=td1 width='40'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:20' ",getUnitData("describe4",sData))+"&nbsp;</td>");
    
  	sTemp.append(" 		<td colspan=3 align=center class=td1 width='120'> ʵ���ʱ�����Ԫ��</td>");
  	
    sTemp.append(" 		<td colspan=3 align=left class=td1 width='120'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:20' ",getUnitData("describe5",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 width='40'> ���� </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 width='40'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:20' ",getUnitData("describe6",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");   
   
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=3 align=left class=td1 > ��ҵ��ģ�������ұ�׼�� </td>");
  	
    sTemp.append(" 		<td colspan=3 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:20' ",getUnitData("describe7",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 > ����ʱ�� </td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:20' ",getUnitData("describe8",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=center class=td1 > ��ҵ���� </td>");
    sTemp.append(" 		<td colspan=5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:20' ",getUnitData("describe9",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=16 align=left class=td1 >��Ӫҵ��:  ");
    sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:50'  ",getUnitData("describe10",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");
  
    sTemp.append("   <tr>");
	sTemp.append("     <td colspan=3 align=left class=td1 > �Ƿ����йɶ� </td>");
    sTemp.append("     <td colspan=4 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:20'  ",getUnitData("describe11",sData))+"&nbsp;</td>");
    sTemp.append("     <td colspan=5 align=center class=td1 > �Ƿ��ѱ�������Ϊ����Ԥ���ͻ� </td>");
    sTemp.append("     <td colspan=4 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:20'  ",getUnitData("describe12",sData))+"&nbsp;</td>");
    sTemp.append("  </tr>");
   
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  colspan=3 align=left class=td1 >�Ƿ����й�˾ </td>");
    sTemp.append(" 		<td colspan=13 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:20'  ",getUnitData("describe13",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");
   
    sTemp.append("   <tr>");
    sTemp.append(" 		<td  rowspan=8  align=left class=td1 >���ſͻ���Ϣ</td>");
    sTemp.append(" 		<td colspan=15 align=left class=td1 >����˳ֹ���ҵ��ǰ����ɶ�<br>���֣������</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=6.5 align=left class=td1 >����������</td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >��֯��������</td>");
    sTemp.append(" 		<td colspan=3.5 align=left class=td1 >���ʷ�ʽ</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >���ʽ���Ԫ��</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >ռ��</td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >����ʱ��</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=6.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:20'  ",getUnitData("describe14",sData))+"&nbsp;</td>"); 
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:20'  ",getUnitData("describe15",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=3.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:20'  ",getUnitData("describe16",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:20'  ",getUnitData("describe17",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:100%; height:20'  ",getUnitData("describe18",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:100%; height:20'  ",getUnitData("describe19",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");
   
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=6.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:100%; height:20'  ",getUnitData("describe20",sData))+"&nbsp;</td>"); 
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:100%; height:20'  ",getUnitData("describe21",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=3.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:100%; height:20'  ",getUnitData("describe22",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe23' style='width:100%; height:20'  ",getUnitData("describe23",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe24' style='width:100%; height:20'  ",getUnitData("describe24",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe25' style='width:100%; height:20'  ",getUnitData("describe25",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=6.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe26' style='width:100%; height:20'  ",getUnitData("describe26",sData))+"&nbsp;</td>"); 
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe27' style='width:100%; height:20'  ",getUnitData("describe27",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=3.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe28' style='width:100%; height:20'  ",getUnitData("describe28",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe29' style='width:100%; height:20'  ",getUnitData("describe29",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe30' style='width:100%; height:20'  ",getUnitData("describe30",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe31' style='width:100%; height:20'  ",getUnitData("describe31",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");
   
  
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=15 align=left class=td1 >����˵��������ſͻ���Ϣ</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=7 align=left class=td1 >���Ź�ϵ��ҵ����</td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 >��֯��������</td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 >�����˹�ϵ</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=7 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe32' style='width:100%; height:20'  ",getUnitData("describe32",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe33' style='width:100%; height:20'  ",getUnitData("describe33",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe34' style='width:100%; height:20'  ",getUnitData("describe34",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");

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

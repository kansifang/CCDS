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
	int iDescribeCount = 18;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0601.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6����Ŀ�����������λ����Ԫ��</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > ָ�� </td>");
    sTemp.append(" 		<td width=25% align=left class=td1 > ָ��ֵ </td>");
    sTemp.append(" 		<td width=50% align=left class=td1 > ��ע </td>");
    sTemp.append(" 	</tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > �����ڣ��꣩</td>");
	sTemp.append("   	<td width=25%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=50%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData)));
	sTemp.append("      &nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > �ۼ��������루��Ԫ��</td>");
	sTemp.append("   	<td width=25%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:25'",getUnitData("describe3",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=50%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
	sTemp.append("      &nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > ��ĿͶ���ܶ��Ԫ��</td>");
	sTemp.append("   	<td width=25%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:25'",getUnitData("describe5",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=50%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:25'",getUnitData("describe6",sData)));
	sTemp.append("      &nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > ���۷��ã���Ԫ��</td>");
	sTemp.append("   	<td width=25%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:25'",getUnitData("describe7",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=50%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:25'",getUnitData("describe8",sData)));
	sTemp.append("      &nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > �ۼƾ�������Ԫ��: </td>");
	sTemp.append("   	<td width=25%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("     &nbsp; </td>");
	sTemp.append("   	<td width=50%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe10' style='width:100%; height:25'",getUnitData("describe10",sData)));
	sTemp.append("      &nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > Ͷ�ʱ����ʣ����� </td>");
	sTemp.append("   	<td width=25%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe11' style='width:100%; height:25'",getUnitData("describe11",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=50%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe12' style='width:100%; height:25'",getUnitData("describe12",sData)));
	sTemp.append("      &nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > �ۼ�ծ���ϱ��������� </td>");
	sTemp.append("   	<td width=25%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe13' style='width:100%; height:25'",getUnitData("describe13",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=50%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe14' style='width:100%; height:25'",getUnitData("describe14",sData)));
	sTemp.append("      &nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > ���������ʣ����� </td>");
	sTemp.append("   	<td width=25%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe15' style='width:100%; height:25'",getUnitData("describe15",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=50%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe16' style='width:100%; height:25'",getUnitData("describe16",sData)));
	sTemp.append("      &nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > �������ۼ۸�Ԫ/ƽ�ף� </td>");
	sTemp.append("   	<td width=25%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe17' style='width:100%; height:25'",getUnitData("describe17",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=50%  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe18' style='width:100%; height:25'",getUnitData("describe18",sData)));
	sTemp.append("      &nbsp;</td>");
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
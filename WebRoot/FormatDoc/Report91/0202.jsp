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
	int iDescribeCount = 31;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
		//��õ��鱨������
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0202.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.5����ҵ�������������������������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 >��ҵ�������ݼ�����ֳ�����Ϊ���������������֤�������񱨱�����ο���</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 nowrap> ��Ŀ </td>");
	sTemp.append("<td width=15% align=left class=td1 nowrap> ����� </td>");
	sTemp.append("<td width=30% align=left class=td1 nowrap> ��ĩ/��ĩ </td>");
	sTemp.append("<td width=20% align=left class=td1 nowrap> ���㹫ʽ </td>");
	sTemp.append("<td width=15% align=left class=td1 nowrap> ������ </td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> ��� </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td align=right class=td1 >(��ĩ��)");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:45%; height:25'",getUnitData("describe2",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td align=left class=td1 nowrap>&nbsp  </td>");
	sTemp.append("<td align=left class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:85%; height:25'",getUnitData("describe3",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> �������� </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(��ĩ��)");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:45%; height:25'",getUnitData("describe5",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  rowspan=2  align=left class=td1 nowrap>��Ʒ����������=[��������-<br>���۳ɱ�(��˰��)] /��������=������</td>");
	sTemp.append("<td align=left rowspan=2 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:85%; height:25'",getUnitData("describe6",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> ���۳ɱ� </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:25'",getUnitData("describe7",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(��ĩ��)");
  	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:45%; height:25'",getUnitData("describe8",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> Ӧ���˿���� </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(��ĩ��)");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:45%; height:25'",getUnitData("describe10",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  rowspan=2  align=left class=td1 nowrap>Ӧ���˿��=Ӧ���˿����<br>-Ԥ���˿����=������</td>");
	sTemp.append("<td align=left rowspan=2 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:85%; height:25'",getUnitData("describe11",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> Ԥ���˿���� </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:25'",getUnitData("describe12",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(��ĩ��)");
  	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:45%; height:25'",getUnitData("describe13",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> Ӧ���˿���� </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:25'",getUnitData("describe14",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(��ĩ��)");
	sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:45%; height:25'",getUnitData("describe15",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  rowspan=2  align=left class=td1 nowrap>Ӧ���˿��=Ӧ���˿�<br>���-Ԥ���˿����=������</td>");
	sTemp.append("<td align=left rowspan=2 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:85%; height:25'",getUnitData("describe16",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> Ԥ���˿���� </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:25'",getUnitData("describe17",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(��ĩ��)");
  	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:45%; height:25'",getUnitData("describe18",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> Ԥ�Ƶ���ĩ�������� </td>");
	sTemp.append("<td align=left class=td1 nowrap> --- </td>");  	
	sTemp.append("   	<td   align=right class=td1 >��ĩԤ����");
	sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:34%; height:25'",getUnitData("describe19",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>Ԥ������������������=��Ԥ�Ƶ�������<br>����-������������룩/�������������=������</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:85%; height:25'",getUnitData("describe20",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> Ŀǰ�����ʽ��� </td>");
	sTemp.append("<td align=left class=td1 nowrap> --- </td>");  	
	sTemp.append("   	<td   align=right class=td1 >(��ĩ��)");
	sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:45%; height:25'",getUnitData("describe21",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>���ڱ���Ŀ��</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:85%; height:25'",getUnitData("describe22",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> ���������ʽ���� </td>");
	sTemp.append("<td align=left class=td1 nowrap> --- </td>");  	
	sTemp.append("   	<td   align=right class=td1 >(��ĩ��)");
	sTemp.append(myOutPut("2",sMethod,"name='describe23' style='width:45%; height:25'",getUnitData("describe23",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>������ҵ��Ӫ��ȫ�������ʽ���������<br>����ҵ��</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe24' style='width:85%; height:25'",getUnitData("describe24",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> ���������ṩ��Ӫ���ʽ� </td>");
	sTemp.append("<td align=left class=td1 nowrap> --- </td>");  
	sTemp.append("   	<td   align=right class=td1 >(��ĩ��)");
	sTemp.append(myOutPut("2",sMethod,"name='describe25' style='width:45%; height:25'",getUnitData("describe25",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>���ڱ���Ŀ���ʵ����������ʽ𣨺�����<br>����ҵ��</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe26' style='width:85%; height:25'",getUnitData("describe26",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> Ӫ���ʽ��� </td>");
	sTemp.append("   	<td   align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe27' style='width:100%; height:25'",getUnitData("describe27",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td   align=right class=td1 >��ʽ���");
	sTemp.append(myOutPut("2",sMethod,"name='describe28' style='width:45%; height:25'",getUnitData("describe28",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>[ƽ��������+��1-���������ʣ�<br>*ƽ��Ӧ���˿��-ƽ��Ӧ���˿��]* <br>(1��Ԥ������������������)</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe29' style='width:85%; height:25'",getUnitData("describe29",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> �ʽ�ȱ�� </td>");
	sTemp.append("<td align=left class=td1 nowrap> --- </td>"); 
	sTemp.append("   	<td   align=right class=td1 >��ʽ���");
	sTemp.append(myOutPut("2",sMethod,"name='describe30' style='width:45%; height:25'",getUnitData("describe30",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>Ӫ���ʽ���-����������ʽ���-��������<br>�ʽ����-���������ṩ��Ӫ���ʽ�=������</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe31' style='width:80%; height:25'",getUnitData("describe31",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td colspan=20 align=left class=td1 nowrap>&nbsp</td>");
	sTemp.append("</tr>");

	
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
	
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
	int iDescribeCount = 42;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//��õ��鱨������
	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2��������;�͵�һ������Դ����</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1����ҵ���������</font></td>"); 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td height='34' width=10% align=left class=td1 >2.1.1</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >��ҵ���ƣ�</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >ע���ʱ�����Ԫ����</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td height='34' width=5% align=left class=td1 >2.1.2</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >��ҵ����ʱ�䣺</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:25'",getUnitData("describe3",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >��Ӫҵ��</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td height='34' width=5% align=left class=td1 >2.1.3</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >�����˻������У�</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:25'",getUnitData("describe5",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >�ʺţ�</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:25'",getUnitData("describe6",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td height='34' width=5% align=left class=td1 >2.1.4</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >���п��������</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:25'",getUnitData("describe7",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >��ǰ������</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:25'",getUnitData("describe8",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2����ҵ��Ӫ�������������</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.1����ҵ��������ҵ��ģ����������</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' colspan=2 align=center class=td1 >��Ӫ��Ʒ</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:25'",getUnitData("describe9",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >�ʲ���ģ����Ԫ��</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:25'",getUnitData("describe10",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' colspan=2 align=center class=td1 >���й̶��ʲ�����Ԫ��</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:25'",getUnitData("describe11",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >�����ʲ�����Ԫ��</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:25'",getUnitData("describe12",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left height='34' colspan=20>���и�ծ���</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='20' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe13' style='width:100%; height:150'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");

    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.2��������չ�׶κ���ҵ��λ����Ʒ�������Լ���Ҫ��Ʒ�������������ë��ռ�����</font></td>"); 	
	sTemp.append("   </tr>");	


	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=20 class=td1 >");
    sTemp.append("   ��ҵ�����׶�"); 
    sTemp.append(myOutPutCheck("3",sMethod,"name='describe14'",getUnitData("describe14",sData),"��ҵ��@�ɳ���@������@˥����@����"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");


    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.3����ҵ������������</font></td>"); 	
	sTemp.append("   </tr>");	

	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=20 class=td1 >");
    sTemp.append(myOutPutCheck("3",sMethod,"name='describe19'",getUnitData("describe19",sData),"����Χ�ھ�������ǿ@����Χ�ھ�������һ��@����Χ�ھ���������@����"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.4����Ʒ�г�����</font></td>"); 	
	sTemp.append("   </tr>");	

	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=20 class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe23'",getUnitData("describe23",sData),"�г�ͬ���Ʒ�࣬���Լ۱Ƚϸ�@�г�ͬ���Ʒ�٣������Ʒ��@����"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3����ҵ��3�������������˰���</font></td>"); 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td  colspan=20  class=td1 >������죺");
	
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe26'",getUnitData("describe26",sData),"��@��@����"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=20   class=td1 >������˰��");
	
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe29'",getUnitData("describe29",sData),"��@��@����"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.4����ҵ������;����˵����֧����ʽ</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left height='34' colspan=20>������;</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='20' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe32' style='width:100%; height:150'",getUnitData("describe32",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left height='34' colspan=20>֧����ʽ</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan='20'  class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe33'",getUnitData("describe33",sData),"����֧��"));
	sTemp.append("   &nbsp;</td>");
	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan='20'  class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe34'",getUnitData("describe34",sData),"����֧��"));
    sTemp.append("&nbsp�տ�������<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe35' style='width:20%; height:25'",getUnitData("describe35",sData)));
	sTemp.append("</u>&nbsp������<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe36' style='width:20%; height:25'",getUnitData("describe36",sData)));
	sTemp.append("</u>&nbsp�˺�<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe37' style='width:20%; height:25'",getUnitData("describe37",sData)));
	sTemp.append("</u>   &nbsp;</td>");


	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan='20'  class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe38'",getUnitData("describe38",sData),"��������֧����������֧��"));
    sTemp.append("&nbsp�տ�������<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe39' style='width:8%; height:25'",getUnitData("describe39",sData)));
    sTemp.append("</u>����֧���տ�������<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe40' style='width:8%; height:25'",getUnitData("describe40",sData)));
	sTemp.append("</u>������<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe41' style='width:8%; height:25'",getUnitData("describe41",sData)));
	sTemp.append("</u>�˺�<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe42' style='width:8%; height:25'",getUnitData("describe42",sData)));
	sTemp.append("</u></td>");
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
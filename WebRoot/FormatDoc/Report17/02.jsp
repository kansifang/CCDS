<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu 20100506
		Tester:
		Content: ����ĵ�0ҳ
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
	int iDescribeCount = 9;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='02.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��������������ʸ��Ƿ����������ع���취Ҫ�������</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >�ṩ���������Ƿ���ȫ���Ϲ�");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:100'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ġ�������;�ĺ���Ϲ������</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >�������ҵ��Ʒ��������Ŀǰ����ҵ���Ƿ���������������;�Ƿ�����ϱ�ҵ��Ʒ��Ҫ�󡣴�����������ȷԭʼ�������ڡ�ԭʼ������;���ñʴ���ĵ������̣�");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�塢��һ������Դ����</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >����˵�һ������Դ��ʲô��<br/>�������ǰ��Ⱦ�Ӫ�������/����������������");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:100'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�����ڶ�������Դ����</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >��Ѻ���������<br/>"+
		"��Ѻ�������ַ�����š��������ʡ�������λ��������Ԥ������ʱ�䡢������Ԥ��������ֵ���������ۡ���Ѻ�ʡ���Ѻ���ۡ�<br/>"+
		"��֤�ˡ���֤���������<br/>"+
		"������������������ҵ����Ӫ���<br/>"+
		"������λ���ơ�������λ������ʲ�����ծ��������Ȩ�桢��Ӫ���롢�������������ҵ�ʲ���ծ�ʡ����ŵȼ������ŷ����޶");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:100'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ߡ��������˵��</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >1������˼��������ڱ�ϵͳ�����������������������ϵͳ���ݣ�<br/>"+
		"2�������˼��������ڱ�ϵͳ�����������������������ϵͳ���ݣ�<br/>"+
		"3���������˵����");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:100'",getUnitData("describe5",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ˡ����ŷ��յ㼰���շ�����ʩ</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:100'",getUnitData("describe6",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�š��������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:100'",getUnitData("describe7",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >ʮ�� ������</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1>������:");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:100'",getUnitData("describe8",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
  	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1>�����ǰ��Ҫ��ʵ��������");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:100'",getUnitData("describe9",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
 	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=right class=td1 >�����Ա��"+CurUser.UserName+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	sTemp.append("���ڣ�"+StringFunction.getToday()+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br/><br/><br/></td>");
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
	editor_generate('describe3');
	editor_generate('describe4');
	editor_generate('describe5');
	editor_generate('describe6');
	editor_generate('describe7');
	editor_generate('describe8');
	editor_generate('describe9');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: ����ĵ�02ҳ
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
	int iDescribeCount = 25;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//��õ��鱨������

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='02.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >������������</td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >1.ְҵ��Ϣ��˵����������ڵ���ҵ��ְ������������ <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >2.�ÿ���ҵ��������У��������ÿ���ҵ�ľ�Ӫ��Χ��ȷ���Ƿ������������������Լ���Ϊ���жԹ����߷���������������ÿ���ҵ��������������磺ע���ʱ�����Ȩ�ṹ����Ӫҵ�����������������롢�������ʲ�����ծ�Ȳ���������ȡ� <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >3.����˸�ծ���ʲ����������<br>"
			+"����˷���˫��������ͬ����ˣ�����Ѻ�ﹲ���ˣ����У��ĸ������ż�¼�У��Ƿ���ڲ�Ʒ����취�涨�Ĳ������ü�¼���Բ������ü�¼�Ƿ��ṩ������ͼ������Է�����<br>"
			+"˵������˼�ͥ�ʲ��������������˼�ͥӵ�еĿ��ṩ֤�����ϵķ������ʲ������ <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >4.����������ҵ���������������������Ƶ�������� <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >5.����ҵ����ۺ���������� <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
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
	editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ 
	editor_generate('describe2');		//��Ҫhtml�༭,input��û��Ҫ 
	editor_generate('describe3');		//��Ҫhtml�༭,input��û��Ҫ 
	editor_generate('describe4');		//��Ҫhtml�༭,input��û��Ҫ 
	editor_generate('describe5');		//��Ҫhtml�༭,input��û��Ҫ 
																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


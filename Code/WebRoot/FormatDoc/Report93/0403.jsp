<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: ����ĵ�0403ҳ
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
	sTemp.append("	<form method='post' action='0403.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >3.�˲����޺�ͬ</br>"
	+"		(1)��ʵ���޺�ͬ����ʵ�ԣ�����δ�������ܲ��ű��������޺�ͬ����ͨ���ֳ���ʵ���绰�����Լ���Ϣ��ѯ��;���ͷ�������ʵ���޺�ͬ����ʵ�ԣ������ֳ��Ե�Ѻ������;�Ӫ����������ա��������޺�ͬ�г��ⷽΪ��ҵ����˾���м�ת�����ģ�������顢��ʵ�м�ת��������ҵʵ�ʾ�Ӫ��ǩ�������޺�ͬ����ʵ�ԡ�</br>"
	+"		(2)��ʵ���ˮƽ����ʵ�ԣ����˷������ˮƽ���֮�⣬��Ҫ�ص��ע�Ƿ�����������ǰ֧�����������ȷ�Ͻ�����ṩ����������У��Ƿ�����ɿ��ŶȽϸߵ����С����������ȳ��ߵ�����ո�ƾ֤���磺����ת��ƾ֤�����Ʊ���������˰���ȡ������޷��ṩ���ƾ֤�ģ����ص���е��顢˵�������⣬�������ˮƽ�����ģ������ܱ�ͬ����ҵ�ȽϷ������޺�ͬ�����ˮƽ�͵��������Ƿ����</br>"
	+"		(3)�������������ȶ��ԣ���ʵ��Ѻ������Ȩ����Ƿ�һ�£�����������Ƿ���������˳��еĻ������˽�Դ�ķ�����������Ѻ���������������г���������������޺�ͬ���ں��Ѻ����������������ˮƽ��</br>"
	+"		(4)���֧�����ڼ���ʽ���������֧�����������˻��������Ƿ�ƥ�䣬���������֧����ʽ���ֽ�֧��������ת�˵ȣ���</br>"
	+"		(5)���ص�˲����޺�ͬ�����Լ������Ƿ����Լ����Ѻ��ת�á���Ѻ������Ƿ����ΥԼ��������Ƿ�������ֿ����ǩ����ͬ˫���Ƿ���з���Ч���������޺�ͬ�д��ڵķ���覴û�����������н�ʾ��</br>"
	+"		(6)���������޲����ͬЭ��ģ�ҲҪ���������������ݽ��е����ʵ�� </br> ");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
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
																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


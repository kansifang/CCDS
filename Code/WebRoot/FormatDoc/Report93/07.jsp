<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: ����ĵ�07ҳ
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
	sTemp.append("	<form method='post' action='07.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ߡ����յ㼰���ջ��ʹ�ʩ</font></td> ");	
	sTemp.append("   </tr>");
	/*
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >1.ȷ���Ƿ�������·��յ㣬�����������ڣ�</td> ");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >(1)������ʵ�Եķ��յ�:</td> ");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"����������֮ⷽ���Ƿ���ڹ�����ϵ������ͬ�����۸��Ƿ���ʵ�ɿ���"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"������ո��Ƿ���п��ŵ��ո�ƾ֤�������޺�ͬ�����ˮƽ�Ƿ�һ�£�</br>"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >(2)���ڵ�һ������Դ�ķ��յ�:</td> ");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"�����޺�ͬ�Ƿ�������ֿۡ�ΥԼ������Ӱ�����������������������������ǰ֧���������"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"�����������Ƿ���Ը��Ǵ������ޣ��粻��ȫ�����ǣ������޺�ͬ���ں��Ƿ���ڶ��������½��ķ��գ�"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe5'",getUnitData("describe5",sData),"���Ƿ�������֧�������뻹�����ڴ���������"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe6'",getUnitData("describe6",sData),"�����֧����ʽΪ�ֽ�֧������ת��֧����ǰ�����������Ƿ��ܸ���Ӧ����Ϣ���Ƿ����������˻����ʽ����뼰����ķ��գ�"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"����ⷽ�ľ�Ӫ����Ƿ��������Ƿ�����ȶ����ɿ������֧��������"));
	sTemp.append("   </br>");
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >(3)���ڵڶ�������Դ�ķ��յ�:</td> ");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"���Ѻ�������ʹ��Ȩ���͡�������;�ͷ�����;���Ƿ��������н�ֹ�����ķ�Χ����Ѻ�ﹲ�������Ƿ�δ�����˵�Ӱ���ѺȨ����ʵ�������"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe9'",getUnitData("describe9",sData),"���Ѻ���غͷ����Ƿ���ڲ�Ȩ���ס��������ϵ�Ӱ�����е�ѺȨ����Ч��ʵ�������"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe10'",getUnitData("describe10",sData),"�����޺�ͬ������Э���У��Ƿ����Լ����Ѻ��ת�á���Ѻ������Ӱ�����е�ѺȨ����Ч��ʵ�������"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe11'",getUnitData("describe11",sData),"���Ѻ���������ֵ���׼�ֵ�Ƿ����������ɣ�"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe12'",getUnitData("describe12",sData),"���Ѻ���Ƿ����ڳ��ո��ʽϸߵĵ�Ѻ���̨�硢�����߷����غ������ٺ����ݣ���ʯ���߷���������ɽ���ݣ�שľ�ṹ���׷������ֵķ��ݣ����ڴ�����ȼ���ױ�����Ʒ�ķ��ݣ���"));
	sTemp.append("   	</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >(4)���ڴ�����;�ķ��յ�:</td> ");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe13'",getUnitData("describe13",sData),"���Ƿ����Υ�����м��ⲿ��ܻ�����ع涨����;��"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe14'",getUnitData("describe14",sData),"���Ƿ����Ӱ�������ʵ����ش����ʽ���;�������"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	*/
	
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >1.ȷ���Ƿ�������·��յ㣬�����������ڣ�</br> ");
	sTemp.append("   (1)������ʵ�Եķ��յ�:</br> ");
	sTemp.append("����������֮ⷽ���Ƿ���ڹ�����ϵ������ͬ�����۸��Ƿ���ʵ�ɿ���</br>");
	sTemp.append("������ո��Ƿ���п��ŵ��ո�ƾ֤�������޺�ͬ�����ˮƽ�Ƿ�һ�£�</br>");
	sTemp.append("   (2)���ڵ�һ������Դ�ķ��յ�:</br> ");
	sTemp.append("�����޺�ͬ�Ƿ�������ֿۡ�ΥԼ������Ӱ�����������������������������ǰ֧���������</br>");
	sTemp.append("�����������Ƿ���Ը��Ǵ������ޣ��粻��ȫ�����ǣ������޺�ͬ���ں��Ƿ���ڶ��������½��ķ��գ�</br>");
	sTemp.append("���Ƿ�������֧�������뻹�����ڴ���������</br>");
	sTemp.append("�����֧����ʽΪ�ֽ�֧������ת��֧����ǰ�����������Ƿ��ܸ���Ӧ����Ϣ���Ƿ����������˻����ʽ����뼰����ķ��գ�</br>");
	sTemp.append("����ⷽ�ľ�Ӫ����Ƿ��������Ƿ�����ȶ����ɿ������֧��������</br>");
	sTemp.append("  (3)���ڵڶ�������Դ�ķ��յ�: </br>");
	sTemp.append("���Ѻ�������ʹ��Ȩ���͡�������;�ͷ�����;���Ƿ��������н�ֹ�����ķ�Χ����Ѻ�ﹲ�������Ƿ�δ�����˵�Ӱ���ѺȨ����ʵ�������</br>");
	sTemp.append("���Ѻ���غͷ����Ƿ���ڲ�Ȩ���ס��������ϵ�Ӱ�����е�ѺȨ����Ч��ʵ�������</br>");
	sTemp.append("�����޺�ͬ������Э���У��Ƿ����Լ����Ѻ��ת�á���Ѻ������Ӱ�����е�ѺȨ����Ч��ʵ�������</br>");
	sTemp.append("���Ѻ���������ֵ���׼�ֵ�Ƿ����������ɣ�</br>");
	sTemp.append("���Ѻ���Ƿ����ڳ��ո��ʽϸߵĵ�Ѻ���̨�硢�����߷����غ������ٺ����ݣ���ʯ���߷���������ɽ���ݣ�שľ�ṹ���׷������ֵķ��ݣ����ڴ�����ȼ���ױ�����Ʒ�ķ��ݣ���</br>");
	sTemp.append("   (4)���ڴ�����;�ķ��յ�:</br> ");
	sTemp.append("���Ƿ����Υ�����м��ⲿ��ܻ�����ع涨����;��</br>");
	sTemp.append("���Ƿ����Ӱ�������ʵ����ش����ʽ���;�������</br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=14 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >2.���ջ��ʹ�ʩ�������������ڵķ��յ㣬�ƶ���������Եķ��ջ��ʹ�ʩ�� ");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=14 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
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
																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


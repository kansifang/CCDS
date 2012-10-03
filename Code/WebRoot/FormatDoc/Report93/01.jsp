<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: ����ĵ�01ҳ
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
	int iDescribeCount = 11;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//��õ��鱨������
	ASResultSet rs2 = null;
	String sCustomerName = "";//�����
	String sCorPusPayMethodName = "";//���ʽ
	String dBusinessSum = "0.00";//������
	String sGuarantyLocation = "";//��Ѻ���ַ
	String sSql = "";
	double dBusinessRate = 0.00;//����0
	double dGuarantyRate = 0.00;//����Ѻ��
	int iTermMonth = 0;//����
	
	//��ȡ������Ϣ 
    sSql = "select CustomerName,getItemName('CorpusPayMethod2',CorPusPayMethod) as CorPusPayMethodName,"+
    		" BusinessSum,BusinessRate,TermMonth from BUSINESS_APPLY where SerialNo='"+sObjectNo+"' ";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{	
	    sCustomerName = rs2.getString("CustomerName");
	    sCorPusPayMethodName = rs2.getString("CorPusPayMethodName");
	    dBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum"));
	    dBusinessRate = rs2.getDouble("BusinessRate");
	    iTermMonth = rs2.getInt("TermMonth");
	}
	rs2.getStatement().close();
	//��ȡ��Ѻ����Ϣ
	sSql = "select GI.GuarantyLocation,GI.GuarantyRate "+
				" from GUARANTY_RELATIVE GR,GUARANTY_INFO GI "+
	" where GR.ObjectType='CreditApply'  and GR.GuarantyID=GI.GuarantyID and GR.ObjectNo='"+sObjectNo+"' ";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{	
	    sGuarantyLocation = rs2.getString("GuarantyLocation");
	    dGuarantyRate = rs2.getDouble("GuarantyRate");
	}
	rs2.getStatement().close();
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���˾�Ӫ����ҵ��Ѻ����ҵ����鱨��</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >һ��ҵ��ſ�</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left colspan=10>���������<u>&nbsp;"+sCustomerName+"&nbsp;</u>��");
	sTemp.append(" ��λ��<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' ",getUnitData("describe1",sData))+"");
	sTemp.append("</u>��");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' ",getUnitData("describe2",sData))+"");
	sTemp.append("</u>����ҵ����Ϊ��Ѻ����Ѻ��Ϊ<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' ",getUnitData("describe3",sData))+"");
	sTemp.append("</u>%��");
	sTemp.append(" ������������˾�Ӫ����ҵ��Ѻ���������<u>&nbsp;"+dBusinessSum+"&nbsp;</u>Ԫ����");
	
	sTemp.append(" ����<u>&nbsp;"+iTermMonth/12+"&nbsp;</u>�꣬������<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:15%; height:25'",getUnitData("describe0",sData)));
	sTemp.append(" %</u>�����ʽΪ<u>&nbsp;"+sCorPusPayMethodName+"&nbsp;</u>��");
	sTemp.append(" ÿ�ڻ����Ϊ&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe4' ",getUnitData("describe4",sData))+"");
	sTemp.append("</u>&nbsp;Ԫ���ſ�(ǰ���)&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' ",getUnitData("describe5",sData))+"");
	sTemp.append("</u>&nbsp;�붳��&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' ",getUnitData("describe6",sData))+"");
	sTemp.append("</u>&nbsp;�ڻ����");
	sTemp.append(" ��Ѻ������Ŀǰ���ⷽΪ&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' ",getUnitData("describe7",sData))+"");
	sTemp.append("</u>&nbsp;�����ǻ�ǣ�&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' ",getUnitData("describe8",sData))+"");
	sTemp.append("</u>&nbsp;���ʳ����ˣ���Ҫ��Ӫ&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' ",getUnitData("describe9",sData))+"");
	sTemp.append("</u>&nbsp;��ÿ�����&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' ",getUnitData("describe10",sData))+"");
	sTemp.append("</u>&nbsp;Ԫ�����֧��Ƶ��&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' ",getUnitData("describe11",sData))+"");
	sTemp.append("</u>&nbsp;��");
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
	//editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ 
																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


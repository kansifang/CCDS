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
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//�жϸñ����Ƿ����
	String sSql="select finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next())
	{
		FinishFlag = rs.getString("finishdate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null)
	{
		sButtons[1][0] = "false";
	}
	else
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	System.out.println(sSerialNo+"#############");
	String[] sName = new String[4];
	sSql = " select getCustomerName(ObjectNo) as CustomerName"+
			" from INSPECT_INFO II"+
			" where II.SerialNo='"+sSerialNo+"'";
	
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sName[0] =(String)rs.getString("CustomerName");
	}
	rs.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=25 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>���ũ������</p>��˾�ͻ������Լ�鱨��</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=20% align=center class=td1 >�ͻ����ƣ�</td>");
    sTemp.append("   <td colspan='4' align=left class=td1 >"+sName[0]+"&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width=20% align=center class=td1 >ҵ��Ʒ�� </td>");
    sTemp.append("   <td width=20% align=left class=td1 >��ͬ����Ԫ��</td>");
    sTemp.append("   <td width=20% align=left class=td1 >������ʽ</td>");
    sTemp.append("   <td width=20% align=left class=td1 >��ʼ��</td>");
    sTemp.append("   <td width=20% align=left class=td1 >������</td>");
    sTemp.append("   </tr>");
    sSql = "select getBusinessName(BusinessType) as BusinessTypeName,Balance,getItemName('VouchType',VouchType) as VouchTypeName,"
    		+"PutOutDate,Maturity from BUSINESS_CONTRACT where CustomerID = '"+sObjectNo+"'";
    rs = Sqlca.getASResultSet(sSql);		
    while(rs.next()){
    	String sBusinessTypeName="";
    	String sBalance="";
    	double dBalance=0.0;
    	String sVouchTypeName="";
    	String sBeginDate="";
    	String sEndDate="";
    	sBusinessTypeName = rs.getString(1);
    	if(sBusinessTypeName == null) sBusinessTypeName="";
    	sBalance = rs.getString(2);
    	if(sBalance == null) sBalance="0";
    	dBalance = DataConvert.toDouble(sBalance)/10000;
    	sVouchTypeName = rs.getString(3);
    	if(sVouchTypeName == null) sVouchTypeName = "";
    	sBeginDate = rs.getString(4);
    	if(sBeginDate == null) sBeginDate = "";
    	sEndDate = rs.getString(5);
    	if(sEndDate == null) sEndDate = "";
	    sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=center class=td1 >"+sBusinessTypeName+"&nbsp; </td>");
	    sTemp.append("   <td width=20% align=left class=td1 >"+dBalance+"&nbsp; </td>");
	    sTemp.append("   <td width=20% align=left class=td1 >"+sVouchTypeName+"&nbsp; </td>");
	    sTemp.append("   <td width=20% align=left class=td1 >"+sBeginDate+"&nbsp; </td>");
	    sTemp.append("   <td width=20% align=left class=td1 >"+sEndDate+"&nbsp; </td>");
	    sTemp.append("   </tr>");
    }
	rs.getStatement().close();
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
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


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
	int iDescribeCount = 2;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0103.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa colspan='7'><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�������������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
  	sTemp.append("   <td align=left class=td1 colspan='7'><font style=' font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;' > 1���������ڽ��ڻ��������������</font>");
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' width=15% align=center class=td1 > ���</td>");
   	sTemp.append("   <td colspan='1' width=15% align=center class=td1 > ���Ż�������</td>");   	
  	sTemp.append("   <td colspan='1' width=14% align=center class=td1 > ���(��Ԫ)</td>");
   	sTemp.append("   <td colspan='1' width=14% align=center class=td1 > ����(��Ԫ)</td>");   
  	sTemp.append("   <td colspan='1' width=15% align=center class=td1 > ������λ/������ʽ</td>");
   	sTemp.append("   <td colspan='1' width=14% align=center class=td1 > ������</td>");   
  	sTemp.append("   <td colspan='1' width=14% align=center class=td1 > ��������</td>");	   	   	  	
	sTemp.append("   </tr>");
	
	ASResultSet rs = Sqlca.getASResultSet(" select getItemName('OtherBusinessType',BusinessType) as BusinessTypeName,OccurOrg,Balance,"+
				  						  " BusinessSum,getItemName('VouchType',VouchType) as VouchTypeName,Maturity,UpToDate "+
				  						  " from CUSTOMER_OACTIVITY where CustomerID= '"+sCustomerID+"'");
	while(rs.next()){
		String sBusinessTypeName = rs.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		String sOccurOrg = rs.getString("OccurOrg");
		if(sOccurOrg == null) sOccurOrg = "";
		String sBalance = DataConvert.toMoney(rs.getDouble("Balance")/10000);
		if(sBalance == null) sBalance = "";
		String sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
		if(sBusinessSum == null) sBusinessSum = "";	
		String sVouchTypeName = rs.getString("VouchTypeName");
		if(sVouchTypeName == null) sVouchTypeName = "";
		String sMaturity = rs.getString("Maturity");
		if(sMaturity == null) sMaturity = "";
		String sUpToDate = rs.getString("UpToDate");
		if(sUpToDate == null) sUpToDate = "";			
		sTemp.append("   <tr>");
	  	sTemp.append("   <td colspan='1' width=15% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	   	sTemp.append("   <td colspan='1' width=15% align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");   	
	  	sTemp.append("   <td colspan='1' width=14% align=center class=td1 >"+sBalance+"&nbsp;</td>");
	   	sTemp.append("   <td colspan='1' width=14% align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");   
	  	sTemp.append("   <td colspan='1' width=15% align=center class=td1 >"+sVouchTypeName+"&nbsp;</td>");
	   	sTemp.append("   <td colspan='1' width=14% align=center class=td1 >"+sMaturity+"&nbsp;</td>");   
	  	sTemp.append("   <td colspan='1' width=14% align=center class=td1 >"+sUpToDate+"&nbsp;</td>");	   	   	  	
		sTemp.append("   </tr>");		
	}
	rs.getStatement().close();
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='7'><font style=' font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;' > 2�������ѯ��Ϣ�����ʱ䶯ԭ�����</font>");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='7'><font style=' font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;' > 3������������״��</font>");
  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
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
	editor_generate('describe1');
	editor_generate('describe2');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
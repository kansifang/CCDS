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
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//��õ��鱨������
	String sCustomerName = "";		//�ͻ�����
	String sPurpose = "";	//��;
	String sBusinessSum = "" ;    //���
	String sTermMonth = ""; //����
	String sBusinessTypeName = "";//ҵ������
	String sBusinessRate = "" ;//����
	String sVouchTypeName = "";//������ʽ
	String sDrawingTypeName = ""; //��ʽ
	String sCorpusPayMethodName = "";//���ʽ
	
	//����ҵ�������Ϣ
	ASResultSet rs2 = Sqlca.getResultSet(" select CustomerName,Purpose,BusinessSum,TermMonth,getBusinessName(BusinessType) as BusinessTypeName,"+
										 " BusinessRate,getItemName('VouchType',VouchType) as VouchTypeName,"+
										 " getItemName('DrawingType',DrawingType) as DrawingTypeName,"+
										 " getItemName('CorpusPayMethod',CorpusPayMethod) as CorpusPayMethodName "+
										 " from BUSINESS_APPLY where Serialno ='"+sObjectNo+"'" );
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName=" ";
		
		sPurpose = rs2.getString("Purpose");
		if(sPurpose == null) sPurpose="";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum"));
		if(sBusinessSum == null) sBusinessSum=" ";
		
		sTermMonth = rs2.getString("TermMonth");
		if(sTermMonth == null) sTermMonth=" ";
		
		sBusinessTypeName = rs2.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName=" ";
		
		sBusinessRate = rs2.getString("BusinessRate");
		if(sBusinessRate == null) sBusinessRate=" ";
		
		sVouchTypeName = rs2.getString("VouchTypeName");
		if(sVouchTypeName == null) sVouchTypeName=" ";
		
		sDrawingTypeName = rs2.getString("DrawingTypeName");
		if(sDrawingTypeName == null) sDrawingTypeName=" ";
		
		sCorpusPayMethodName = rs2.getString("CorpusPayMethodName");
		if(sCorpusPayMethodName == null) sCorpusPayMethodName=" ";
			
	}
	rs2.getStatement().close();	
 %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��һ�������˸ſ�</font></td>"); 	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > �ͻ����ƣ�</td>");
   	sTemp.append("   <td colspan='3' align=left class=td1 > "+sCustomerName+"&nbsp;</td>");  
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > ������;��</td>");
   	sTemp.append("   <td colspan='3' align=left class=td1 > "+sPurpose+"&nbsp;</td>");   	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='1' align=left class=td1 > ���Ž��(��Ԫ)��</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sBusinessSum+"&nbsp;</td>"); 		        
   	sTemp.append("   <td colspan='1' align=left class=td1 > ����(��)��</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sTermMonth+"&nbsp;</td>");    		 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > ҵ��Ʒ�֣�</td>");
   	sTemp.append("   <td colspan='3' align=left class=td1 > "+sBusinessTypeName+"&nbsp;</td>");     		 	
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
   	sTemp.append("   <td colspan='1' align=left class=td1 > ִ�����ʣ��룩��</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sBusinessRate+"&nbsp;</td>"); 
   	sTemp.append("   <td colspan='1' align=left class=td1 > ������ʽ��</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sVouchTypeName+"&nbsp;</td>");    	 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' width=20% align=left class=td1 > ���ʽ��</td>");
   	sTemp.append("   <td colspan='1' width=30% align=left class=td1 > "+sDrawingTypeName+"&nbsp</td>");  
   	sTemp.append("   <td colspan='1' width=20% align=left class=td1 > ��ʽ��</td>");   	
   	sTemp.append("   <td colspan='1' width=30% align=left class=td1 > "+sCorpusPayMethodName+"&nbsp</td>");    	
	sTemp.append("   </tr>");	
		
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > �������ڣ�</td>");
   	sTemp.append("   <td colspan='3' align=left class=td1 > "+StringFunction.getToday()+"&nbsp</td>");    	
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
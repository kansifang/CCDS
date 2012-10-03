<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第?页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	String sCustomerName = "";		//客户名称
	String sPurpose = "";	//用途
	String sBusinessSum = "" ;    //金额
	String sTermMonth = ""; //期限
	String sBusinessTypeName = "";//业务名称
	String sBusinessRate = "" ;//利率
	String sVouchTypeName = "";//担保方式
	String sDrawingTypeName = ""; //提款方式
	String sCorpusPayMethodName = "";//还款方式
	
	//申请业务基本信息
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

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（一）授信人概况</font></td>"); 	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 客户名称：</td>");
   	sTemp.append("   <td colspan='3' align=left class=td1 > "+sCustomerName+"&nbsp;</td>");  
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 贷款用途：</td>");
   	sTemp.append("   <td colspan='3' align=left class=td1 > "+sPurpose+"&nbsp;</td>");   	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='1' align=left class=td1 > 授信金额(万元)：</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sBusinessSum+"&nbsp;</td>"); 		        
   	sTemp.append("   <td colspan='1' align=left class=td1 > 期限(月)：</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sTermMonth+"&nbsp;</td>");    		 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 业务品种：</td>");
   	sTemp.append("   <td colspan='3' align=left class=td1 > "+sBusinessTypeName+"&nbsp;</td>");     		 	
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
   	sTemp.append("   <td colspan='1' align=left class=td1 > 执行利率（‰）：</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sBusinessRate+"&nbsp;</td>"); 
   	sTemp.append("   <td colspan='1' align=left class=td1 > 担保方式：</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sVouchTypeName+"&nbsp;</td>");    	 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' width=20% align=left class=td1 > 还款方式：</td>");
   	sTemp.append("   <td colspan='1' width=30% align=left class=td1 > "+sDrawingTypeName+"&nbsp</td>");  
   	sTemp.append("   <td colspan='1' width=20% align=left class=td1 > 提款方式：</td>");   	
   	sTemp.append("   <td colspan='1' width=30% align=left class=td1 > "+sCorpusPayMethodName+"&nbsp</td>");    	
	sTemp.append("   </tr>");	
		
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 调查日期：</td>");
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
	//客户化3
	var config = new Object();    
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
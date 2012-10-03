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

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//判断该报告是否完成
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

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=25 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>天津农商银行</p>公司客户常规性检查报告</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=20% align=center class=td1 >客户名称：</td>");
    sTemp.append("   <td colspan='4' align=left class=td1 >"+sName[0]+"&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width=20% align=center class=td1 >业务品种 </td>");
    sTemp.append("   <td width=20% align=left class=td1 >合同余额（万元）</td>");
    sTemp.append("   <td width=20% align=left class=td1 >担保方式</td>");
    sTemp.append("   <td width=20% align=left class=td1 >起始日</td>");
    sTemp.append("   <td width=20% align=left class=td1 >到期日</td>");
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
	//客户化3
	var config = new Object();     
	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


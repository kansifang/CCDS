<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   bqliu 2011-04-29
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   
				FirstSection: 
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
	sButtons[0][0] = "false";
	sButtons[1][0] = "false";
%>
<%
	//获得调查报告数据
	String sCustomerName = "";
	String sCorpID = "";//组织机构代码
	String sRegisterCapital = "";//注册资本
	String sRCCurrency = "";//注册资本币种
	String sMostBusiness = "";//经营范围
	String sRegisterAdd = "";//注册地
	String sOfficeAdd = ""; //经营地
	
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName from Customer_Info where CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = " ";
	}
	rs2.getStatement().close();	
	
	rs2 = Sqlca.getResultSet("select EnterpriseName,CorpID,RegisterCapital,getItemName('Currency',RCCurrency) as CurrencyName,MostBusiness,"
										+"RegisterAdd,OfficeAdd "
										+"from ENT_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		//sCustomerName = rs2.getString("EnterpriseName");
		//if(sCustomerName == null) sCustomerName = " ";
		
		sCorpID = rs2.getString("CorpID");
		if(sCorpID == null) sCorpID = "";
		
		sRegisterCapital = rs2.getString("RegisterCapital");
		if(sRegisterCapital == null) sRegisterCapital = "";
		
		sRCCurrency = rs2.getString("CurrencyName");
		if(sRCCurrency == null) sRCCurrency = "";
		
		sMostBusiness = rs2.getString("MostBusiness");
		if(sMostBusiness == null) sMostBusiness = "";
		
		sRegisterAdd = rs2.getString("RegisterAdd");
		if(sRegisterAdd == null) sRegisterAdd = "";
		
		sOfficeAdd = rs2.getString("OfficeAdd");
		if(sOfficeAdd == null) sOfficeAdd = "";
	}
	
	rs2.getStatement().close();	
	
	String sIsDirector = " ";//是否我行股东
	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType = '50' and CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		 if(rs2.getInt(1)==0)sIsDirector = "否";
		 else sIsDirector = "是";
	}
	rs2.getStatement().close();	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 ><font style=' font-size: 25pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >基本情况信息表</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 ><font style=' font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >(一)借款人基本信息</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >客户组织机构代码</td>");
    sTemp.append(" <td colspan=2 align=left class=td1 >"+sCorpID+"&nbsp;</td>");
  	sTemp.append(" <td align=center class=td1 >客户名称</td>");
    sTemp.append(" <td colspan=2 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >注册资本(万元)</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sRegisterCapital+"&nbsp;</td>");
  	sTemp.append(" <td width=10% align=center class=td1 >币种</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sRCCurrency+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >是否我行股东</td>");
    sTemp.append(" <td width=10% align=left class=td1 >"+sIsDirector+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" <td colspan=6 align=left valign=top class=td1 style='width:100%; height:50' >经营范围：<br/>&nbsp;&nbsp;"+sMostBusiness+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" <td colspan=3 align=left valign=top class=td1 style='width:100%; height:50' >注册地：<br/>&nbsp;&nbsp;"+sRegisterAdd+"</td>");
    sTemp.append(" <td colspan=3 align=left valign=top class=td1 style='width:100%; height:50' >经营地：<br/>&nbsp;&nbsp;"+sOfficeAdd+"</td>");
    sTemp.append(" </tr>");
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


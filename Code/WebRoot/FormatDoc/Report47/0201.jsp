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
	int iDescribeCount =6;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//获得调查报告数据
	String sEnterpriseName = "";//客户名称
	String sSuperCertTypeName = "" ;//信用共同体类型 
	String sVillageName = "";//所在区域
	String sSuperCorpName = ""; //信用共同体掌控人
	String sEmployeeNumber = "";//信用共同体总户数,
	String sSetupDate = "";//农户联保小组成立时间
	String sBailRatio = "";//联保小组保证金比例
	String sBusinessType = Sqlca.getString("select BusinessType from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");	
	String sSql = "";
	ASResultSet rs = null;
	if("3050".equals(sBusinessType)){
		sSql = " select EnterpriseName,VillageName,EmployeeNumber,SetupDate,BailRatio from ENT_INFO where CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sEnterpriseName = rs.getString("EnterpriseName");
			sVillageName = rs.getString("VillageName");
			sEmployeeNumber = rs.getString("EmployeeNumber");
			sSetupDate = rs.getString("SetupDate");
			sBailRatio = rs.getString("BailRatio");
			if(sEnterpriseName == null) sEnterpriseName = "";
			if(sVillageName == null) sVillageName = "";
			if(sEmployeeNumber == null) sEmployeeNumber = "";
			if(sSetupDate == null) sSetupDate = "";
			if(sBailRatio == null) sBailRatio = "";
		}	
		rs.getStatement().close();
	}
	else if("3060".equals(sBusinessType)){
		sSql = " select EnterpriseName,getItemName('CreditGroupType',SuperCertType) as SuperCertTypeName ,"+
			   " VillageName,SuperCorpName,EmployeeNumber "+
			   " from ENT_INFO where CustomerID='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sEnterpriseName = rs.getString("EnterpriseName");
			sSuperCertTypeName = rs.getString("SuperCertTypeName");
			sVillageName = rs.getString("VillageName");
			sSuperCorpName = rs.getString("SuperCorpName");
			sEmployeeNumber = rs.getString("EmployeeNumber");
			if(sEnterpriseName == null) sEnterpriseName = "";
			if(sSuperCertTypeName == null) sSuperCertTypeName = "";
			if(sVillageName == null) sVillageName = "";
			if(sSuperCorpName == null) sSuperCorpName = "";
			if(sEmployeeNumber == null) sEmployeeNumber = "";
		}	
		rs.getStatement().close();		   
	}							  
	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2 申请人基本信息</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1、概况</font></td> ");	
	sTemp.append("   </tr>");
	if("3050".equals(sBusinessType)){
		sTemp.append("   <tr>");
		sTemp.append(" <td width=25% align=left class=td1 > 姓名 </td>");
	    sTemp.append(" <td width=25% align=left class=td1 >"+sEnterpriseName+"&nbsp;</td>");
	  	sTemp.append(" <td width=25% align=left class=td1 > 农户所在地 </td>");
	    sTemp.append(" <td width=25% align=left class=td1 >"+sVillageName+"&nbsp;</td>");
	    sTemp.append(" </tr>");
		sTemp.append("   <tr>");
		sTemp.append("     <td colspan='1' align=left class=td1 > 联保小组成员人数  </td>");
	    sTemp.append("     <td colspan='1' align=left class=td1 >"+sEmployeeNumber+"&nbsp;</td>");
		sTemp.append("     <td colspan='1' align=left class=td1 > 联保小组协议签订时间 </td>");
		sTemp.append("     <td colspan='1' align=left class=td1 >"+sSetupDate+"&nbsp;</td>");
		sTemp.append("  </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("     <td colspan='1' align=left class=td1 > 联保小组保证金比例 </td>");
	    sTemp.append("     <td colspan='3' align=left class=td1 >"+sBailRatio+"&nbsp;</td>");
	    sTemp.append("  </tr>");
		
	}else if("3060".equals(sBusinessType)){
		sTemp.append("   <tr>");
		sTemp.append(" <td width=25% align=left class=td1 > 姓名 </td>");
	    sTemp.append(" <td width=25% align=left class=td1 >"+sEnterpriseName+"&nbsp;</td>");
	  	sTemp.append(" <td width=25% align=left class=td1 > 类型 </td>");
	    sTemp.append(" <td width=25% align=left class=td1 >"+sSuperCertTypeName+"&nbsp;</td>");
	    sTemp.append(" </tr>");
		sTemp.append("   <tr>");
		sTemp.append("     <td colspan='1' align=left class=td1 > 所在区域 </td>");
	    sTemp.append("     <td colspan='1' align=left class=td1 >"+sVillageName+"&nbsp;</td>");
		sTemp.append("     <td colspan='1' align=left class=td1 > 掌控人名称 </td>");
		sTemp.append("     <td colspan='1' align=left class=td1 >"+sSuperCorpName+"&nbsp;</td>");
		 sTemp.append("  </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("     <td colspan='1' align=left class=td1 > 总户数 </td>");
	    sTemp.append("     <td colspan='3' align=left class=td1 >"+sEmployeeNumber+"&nbsp;</td>");
     	sTemp.append("  </tr>");
		
	}	

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

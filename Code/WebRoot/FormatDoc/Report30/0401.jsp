<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu  2009.08.18
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


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	//获得调查报告数据
	String sAptitudeLevelInfo = "";   //开发资质级别
	String sUptoDate = ""; //获得时间
	String sAnnualCheck = ""; //是否通过年检
	String sCheckOrgName = "";//开发资质评定机构
	
	String sSql = " select LevelInfo,getItemName('AptitudeLevelInfo',LevelInfo) as AptitudeLevelInfo, "+
				  " UptoDate,getOrgName(InputOrgID) as CheckOrgName from ENT_REALTYAUTH where CustomerID = '"+sCustomerID+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sAptitudeLevelInfo = rs.getString(2);
		if(sAptitudeLevelInfo == null) sAptitudeLevelInfo = "";
		
		sUptoDate = rs.getString(3);
		if(sUptoDate == null) sUptoDate = null;
		
		sCheckOrgName = rs.getString(4);
		if(sCheckOrgName == null) sCheckOrgName = "";
	}
	rs.getStatement().close();			  
%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0401.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4.1、借款人经营情况总体描述</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=20% align=left class=td1 > 开发资质  </td>");
  	sTemp.append("   <td width=20% align=left class=td1 > "+sAptitudeLevelInfo+"&nbsp  </td>");
  	sTemp.append("   <td width=15% align=left class=td1 > 获得时间 </td>");
    sTemp.append("   <td width=15% align=left class=td1 > "+sUptoDate+"&nbsp  </td>");
    sTemp.append("   <td width=15% align=left class=td1 > 是否通过年检 </td>");
	sTemp.append("   <td width=15% align=left class=td1 > "+""+"&nbsp  </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 开发资质评定机构  </td>");
  	sTemp.append("   <td colspan='5' align=left class=td1 > "+sCheckOrgName+"&nbsp  </td>");
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


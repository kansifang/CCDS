<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong  2009/08/27
		Tester:
		Content: 报告的第0页
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

<%@include file="/FormatDoc/IncludeFDHeader1.jsp"%>

<%
	//获得调查报告数据
	String sCustomerName = "",sBusinessTypeName = "",sBusinessSum = "";
	String sCurrency = "",sBailRatio = "",sBusinessRate = "";
	String sClassifyResult = "",sVouchType = "",sPurpose = "";
	String sOrgName = "",sUserName = "",sCurrencyName = "";
	String sVouchTypeName = "",sPutOutDate = "",sMaturity = "";
	String sBalance = "",sInterestBalance = "",sDescribe2 = "";
	String sDutyAttribute = "",sDescribe3 = "",sDescribe1 = "";
	String sUndertakerName = "",sTraceModeName = "",sRemark = "";
	String sCognizePerson = "",sInputOrgName = "",sInputDate = "";
	String sDutyTypeName = "",sExternalReason = "";
	String sSql = "";
	ASResultSet rs = null;
	//取合同信息
	sSql = " select getOrgName(InputOrgID) as OrgName,"+
			" getitemname('Currency',BusinessCurrency) as CurrencyName,"+
			" SerialNo,CustomerName,getBusinessName(BusinessType) as BusinessTypeName,"+
			" getItemName('VouchType',VouchType) as  VouchTypeName,PutOutDate,"+
			" Maturity,Nvl(BusinessSum,0) as BusinessSum ,"+
			" Nvl(Balance,0) as Balance,(Nvl(InterestBalance1,0)+Nvl(InterestBalance2,0)) as InterestBalance "+
			" from BUSINESS_CONTRACT where serialno='"+sObjectNo+"'";
	rs = Sqlca.getResultSet(sSql);
	
	if(rs.next())
	{
		sOrgName = rs.getString("OrgName");
		sCurrencyName = rs.getString("CurrencyName");
		sSerialNo = rs.getString("SerialNo");
		sCustomerName = rs.getString("CustomerName");
		sBusinessTypeName = rs.getString("BusinessTypeName");
		sVouchTypeName = rs.getString("VouchTypeName");
		sPutOutDate = rs.getString("PutOutDate");
		sMaturity = rs.getString("Maturity");
		sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
		sBalance = DataConvert.toMoney(rs.getDouble("Balance")/10000);
		sInterestBalance = DataConvert.toMoney(rs.getDouble("InterestBalance")/10000);
	}
	rs.getStatement().close();	
	//责任认定详情
	sSql = " select getItemName('YesNo',DutyAttribute) as DutyAttribute,Describe3,"+
			" getItemName('BadnessReason',DutyType) as DutyTypeName, "+
			" Describe1,Describe2,ExternalReason,UndertakerName,"+
			" getItemName('TraceMode',TraceMode) as TraceModeName,Remark,"+
			" CognizePerson,'审批人',getOrgName(InputOrgID) as InputOrgName,InputDate "+
			" from DUTY_INFO where ObjectType='BusinessContract' and "+
			" ObjectNo='"+sObjectNo+"'";

	rs = Sqlca.getResultSet(sSql);
	
	if(rs.next())
	{
		sDutyAttribute = rs.getString("DutyAttribute");
		sDescribe3 = rs.getString("Describe3");
		sDutyTypeName = rs.getString("DutyTypeName");
		sDescribe1 = rs.getString("Describe1");
		sDescribe2 = rs.getString("Describe2");
		sExternalReason = rs.getString("ExternalReason");
		sUndertakerName = rs.getString("UndertakerName");
		sTraceModeName = rs.getString("TraceModeName");
		sRemark = rs.getString("Remark");
		sCognizePerson = rs.getString("CognizePerson");
		sInputOrgName = rs.getString("InputOrgName");
		sInputDate = rs.getString("InputDate");
	}
	rs.getStatement().close();	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='5005.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >不良资产责任认定表</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center Bordercolor=#aaaaaa bgcolor=#aaaaaa >贷款机构：</td>");
    sTemp.append(" <td width=40% colspan='4' align=left Bordercolor=#aaaaaa bgcolor=#aaaaaa >&nbsp;"+sOrgName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center Bordercolor=#aaaaaa bgcolor=#aaaaaa >币种：</td>");
    sTemp.append(" <td width=20% colspan='2' align=left Bordercolor=#aaaaaa bgcolor=#aaaaaa >&nbsp;"+sCurrencyName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center Bordercolor=#aaaaaa bgcolor=#aaaaaa >单位：</td>");
    sTemp.append(" <td width=10% colspan='1' align=left Bordercolor=#aaaaaa bgcolor=#aaaaaa >&nbsp;万元</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >合同流水号</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sSerialNo+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >客户名称</td>");
    sTemp.append(" <td width=30% colspan='3' align=left class=td1 >&nbsp;"+sCustomerName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >业务品种</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sBusinessTypeName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >贷款方式</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sVouchTypeName+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >合同起始日</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sPutOutDate+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >合同到期日</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sMaturity+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >合同金额</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sBusinessSum+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >合同余额</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sBalance+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >结欠利息</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sInterestBalance+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >调查岗</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;1</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >审查岗</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;2</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >审批岗</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;3</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >审批机构</td>");
    sTemp.append(" <td width=10% colspan='3' align=left class=td1 >&nbsp;4</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% colspan='2' align=center class=td1 >贷款是否按合同约定用途使用</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sDutyAttribute+"</td>");
    sTemp.append(" <td width=20% colspan='2' align=center class=td1 >贷款管理人变动情况</td>");
    sTemp.append(" <td width=20% colspan='2' align=left class=td1 >&nbsp;"+sDescribe3+"</td>");
    sTemp.append(" <td width=20% colspan='2' align=center class=td1 >贷款形成不良原因</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sDutyTypeName+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% rowspan='2' colspan='1' align=center >主观原因</td>");
	sTemp.append("   <td colspan=9 align=left class=td1 >贷款发放环节(调查、审查、审批)违规情况:<br>");
	sTemp.append("&nbsp;"+sDescribe1+"");
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=9 align=left class=td1 >贷后环节存在问题:<br>");
	sTemp.append("&nbsp;"+sDescribe2+"");
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >客观原因:<br>");
	sTemp.append("&nbsp;"+sExternalReason+"");
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >责任人</td>");
    sTemp.append(" <td width=60% colspan='6' align=left class=td1 >&nbsp;"+sUndertakerName+"</td>");
    sTemp.append(" <td width=20% colspan='2' align=center class=td1 >责任性质</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sTraceModeName+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >备注</td>");
    sTemp.append(" <td width=90% colspan='9' align=left class=td1 >&nbsp;"+sRemark+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=10% colspan='1' align=center class=td1 >责任认定人</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sCognizePerson+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >审批人</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sCustomerName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >登记机构</td>");
    sTemp.append(" <td width=30% colspan='3' align=left class=td1 >&nbsp;"+sInputOrgName+"</td>");
    sTemp.append(" <td width=10% colspan='1' align=center class=td1 >登记日期</td>");
    sTemp.append(" <td width=10% colspan='1' align=left class=td1 >&nbsp;"+sInputDate+"</td>");
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


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
	//获得调查报告数据
	String sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	String sGuarangtorID = "";//担保客户ID号
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();
	
	String sRegisterCapital = "";	//注册资本
	String MostBusiness = "";		//主营业务
	String sCorpID = "" ;            //法人或组织机构 代码
	String sCustomerName = "" ;    //企业名称
	String sMostBusiness = "";        //主营业务	
	String sRccurrency = "";         //注册资本币种
	String sPccurrency= "";         //实收资本币种
	
	rs2 = Sqlca.getResultSet("select CustomerName from Customer_Info where CustomerID='"+sGuarangtorID+"'");
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = " ";
	}
	rs2.getStatement().close();	
	
	
	//申请人基本信息
	rs2 = Sqlca.getResultSet("select RegisterAdd,OfficeAdd,getitemname('OrgType',OrgType) as OrgTypeName,"
							+"getitemName('IndustryType',IndustryType) as IndustryType,RegisterCapital,PaiclUpCapital,getitemname('Scope',Scope) as ScopeName,"
							+"getItemName('CreditLevel',CreditLevel),SetupDate,getItemName('YesNo',ECGroupFlag) as GroupFlag,"
							+"MostBusiness,getItemname('ListingCorpCondition',ListingCorpOrNot) as ListingCorpOrNot,CorpId,EnterpriseName,"
							+"MostBusiness ,getItemName('Currency',RCCURRENCY),getItemName('Currency',PCCURRENCY)  "
							+"from ENT_INFO where CustomerID='"+sGuarangtorID+"'");
	
	if(rs2.next())
	{
		sRegisterCapital = rs2.getString("RegisterCapital");
		if(sRegisterCapital == null) sRegisterCapital=" ";
		
		sCorpID = rs2.getString(13);
		if(sCorpID == null) sCorpID=" ";
		
		//sEnterpriseName = rs2.getString(14);
		//if(sEnterpriseName == null) sEnterpriseName=" ";
		
		sMostBusiness = rs2.getString(15);
		if(sMostBusiness == null) sMostBusiness = " ";
		
		sPccurrency = rs2.getString(17);
		if(sPccurrency == null) sPccurrency = " ";
		
		sRccurrency = rs2.getString(16);
		if(sRccurrency == null) sRccurrency = " ";
	}
	rs2.getStatement().close();	
	
	String sIsDirector = " ";//是否我行股东
	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType = '50' and CustomerID='"+sGuarangtorID+"'");
	if(rs2.next())
	{
		 if(rs2.getInt(1)==0)sIsDirector = "否";
		 else sIsDirector = "是";
	}
	rs2.getStatement().close();	
	
	//获得编号
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,j=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '050_' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(j=0;j<sNo.length;j++)
	{
		if(sNo[j].equals(sTreeNo.substring(0,4)))  break;
	}	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='03060201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >（二）保证担保情况</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >1、担保人基本信息</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >客户组织机构代码&nbsp;</td>");
    sTemp.append(" <td colspan=3 align=center class=td1 >"+sCorpID+"&nbsp;</td>");
    sTemp.append(" <td align=center class=td1 >客户名称&nbsp;</td>");
    sTemp.append(" <td align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 >注册资本（万元）&nbsp;</td>");
    sTemp.append(" <td width=15% align=center class=td1 >"+sRegisterCapital+"&nbsp;</td>");
    sTemp.append(" <td width=10% align=center class=td1 >币种&nbsp;</td>");
    sTemp.append(" <td width=10% align=center class=td1 >"+sPccurrency+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >是否我行股东&nbsp;</td>");
    sTemp.append(" <td width=30% align=center class=td1 >"+sIsDirector+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td colspan=6 align=left valign=top class=td1 style='width:100%; height:50'>主营业务：<br/>&nbsp;&nbsp;&nbsp;&nbsp;"+sMostBusiness+"&nbsp;</td>");
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


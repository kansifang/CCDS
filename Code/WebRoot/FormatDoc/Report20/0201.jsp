<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   Author:   zwhu 2009.08.18
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
	sButtons[0][0] = "false";
	sButtons[1][0] = "false";
%>
<%
	//获得调查报告数据
	String sRegisterAdd = "";		//注册地址
	String sOfficeAdd = "";			//办公地址
	String sOrgType = "";		//企业性质
	String sIndustryType = "";		//行业类型
	String sRegisterCapital = "";	//注册资本
	String sPaiclUpCapital = "";	//实收资本
	String sScopeName = "";			//企业规模
	String CreditLevel = "";		//信用等级
	String SetupDate = "";			//成立时间
	String GroupFlag = "";			//是否集团客户
	String MostBusiness = "";		//主营业务
	String ListingCorpOrNot = "";	//是否上市公司
	String sCorpID = "" ;            //法人或组织机构 代码
	String sEnterpriseName = "" ;    //企业名称
	String sMostBusiness = "";        //主营业务	
	String sRccurrency = "";         //注册资本币种
	String sPccurrency= "";         //实收资本币种
	//申请人基本信息
	ASResultSet rs2 = Sqlca.getResultSet("select RegisterAdd,OfficeAdd,getitemname('OrgType',OrgType) as OrgTypeName,"
							+"getitemName('IndustryType',IndustryType) as IndustryType,RegisterCapital,PaiclUpCapital,getitemname('Scope',Scope) as ScopeName,"
							+"getItemName('CreditLevel',CreditLevel),SetupDate,getItemName('YesNo',ECGroupFlag) as GroupFlag,"
							+"MostBusiness,getItemname('ListingCorpCondition',ListingCorpOrNot) as ListingCorpOrNot,CorpId,EnterpriseName,"
							+"MostBusiness ,getItemName('Currency',RCCURRENCY),getItemName('Currency',PCCURRENCY)  "
							+"from ENT_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		sRegisterAdd = rs2.getString(1);
		if(sRegisterAdd == null) sRegisterAdd=" ";
		
		sOfficeAdd = rs2.getString(2);
		if(sOfficeAdd == null) sOfficeAdd=" ";
		
		sOrgType = rs2.getString(3);
		if(sOrgType == null) sOrgType=" ";
		
		sIndustryType = rs2.getString(4);
		if(sIndustryType == null) sIndustryType=" ";
		
		sRegisterCapital = DataConvert.toMoney(rs2.getDouble(5));
		
		sPaiclUpCapital = DataConvert.toMoney(rs2.getDouble(6));
		
		sScopeName = rs2.getString(7);
		if(sScopeName == null) sScopeName=" ";
		
		CreditLevel = rs2.getString(8);
		if(CreditLevel == null) CreditLevel=" ";
		
		SetupDate = rs2.getString(9);
		if(SetupDate == null) SetupDate=" ";
		
		GroupFlag = rs2.getString(10);
		if(GroupFlag == null) GroupFlag=" ";
		
		MostBusiness = rs2.getString(11);
		if(MostBusiness == null) MostBusiness=" ";
		
		ListingCorpOrNot = rs2.getString(12);
		if(ListingCorpOrNot == null) ListingCorpOrNot=" ";
		
		sCorpID = rs2.getString(13);
		if(sCorpID == null) sCorpID=" ";
		
		sEnterpriseName = rs2.getString(14);
		if(sEnterpriseName == null) sEnterpriseName=" ";
		
		sMostBusiness = rs2.getString(15);
		if(sMostBusiness == null) sMostBusiness = " ";
		
		sPccurrency = rs2.getString(17);
		if(sPccurrency == null) sPccurrency = " ";
		
		sRccurrency = rs2.getString(16);
		if(sRccurrency == null) sRccurrency = " ";
	}
	rs2.getStatement().close();	
	
	String sFictitiousPerson = "";//法人代表
	sFictitiousPerson = Sqlca.getString("select CustomerName from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and RelationShip = '0100'");
	if(sFictitiousPerson == null) sFictitiousPerson = "";
	
	String sNewCustomer = " ";//是否新客户
	rs2 = Sqlca.getResultSet("select count(*) from BUSINESS_CONTRACT where CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		 if(rs2.getInt(1)>0)sNewCustomer = "否";
		 else sNewCustomer = "是";
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
	
	String sIsWarner = "";	//是否我行风险预警客户
	String sSql = " select count(RS1.SerialNo) from RISK_SIGNAL RS1  "+
						  " where RS1.SerialNo not in (select distinct RS2.RelativeSerialNo "+
						  " from RISK_SIGNAL RS2 "+
						  " where RS2.SignalType='02' "+
						  " and RS2.SignalStatus='30') "+
						  " and RS1.ObjectType = 'Customer' "+
						  " and RS1.ObjectNo = '"+sCustomerID+"' "+
						  " and SignalType = '01' "+
						  " and RS1.SignalStatus='30' ";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) 
	{
		if(rs2.getInt(1) >=1 ) sIsWarner = "是";
		else sIsWarner = "否";
	}
	rs2.getStatement().close();
	
	String sBourseName = "";//上市地点
	String sIPODate = "";	//上市时间
	String sStockName = "";	//股票简称
	String sStockCode = "";	//股票代码
	
	rs2 = Sqlca.getResultSet("select getItemName('IPOName',BourseName) as BourseName,IPODate,StockName,StockCode from ENT_IPO where CustomerID='"+sCustomerID+"' Order by IPODate DESC");
	if(rs2.next())
	{
		sBourseName = rs2.getString(1);
		if(sBourseName == null) sBourseName=" ";
		sIPODate = rs2.getString(2);
		if(sIPODate == null) sIPODate=" ";
		sStockName = rs2.getString(3);
		if(sStockName == null) sStockName=" ";
		sStockCode = rs2.getString(4);
		if(sStockCode == null) sStockCode=" ";
	}
	rs2.getStatement().close();
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1、借款人基本信息</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 客户组织机构代码 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sCorpID+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 客户名称 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sEnterpriseName+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 是否新客户 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sNewCustomer+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 行业分类 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sIndustryType+"&nbsp;</td>");
    sTemp.append(" 	</tr>");    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 注册资本（万元）</td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sRegisterCapital+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 币种 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sRccurrency+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 实收资本（万元） </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sPaiclUpCapital+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 币种 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sPccurrency+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 企业规模 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sScopeName+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 成立时间 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+SetupDate+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 借款人客户经理评级结果 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+CreditLevel+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 是否上市公司 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+ListingCorpOrNot+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > 主营业务 </td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sMostBusiness+"&nbsp;</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 是否我行股东 </td>");
    sTemp.append("     <td align=left class=td1 >"+sIsDirector+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > 是否已被我行列为风险预警客户 </td>");
    sTemp.append("     <td align=left class=td1 >"+sIsWarner+"&nbsp;</td>");
    sTemp.append("  </tr>");
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

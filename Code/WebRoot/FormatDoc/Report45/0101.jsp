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
	int iDescribeCount = 2;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	String sRegisterAdd = "";		//注册地址
	String sRegisterCapital = "";	//注册资本
	String sEnterpriseName = "" ;    //企业名称
	String sSetupDate = ""; //成立时间
	String sMostBusiness = "";//经营范围
	String sIndustryName = "" ;//行业分类
	String sEmployeeNumber = "";//职工人数
	String sLicenseNo = ""; //营业执照
	String sBasicBank = "";//基本开户行
	String sLoanCardNo = "";//贷款卡号
	//申请人基本信息
	ASResultSet rs2 = Sqlca.getResultSet(" select EnterpriseName,SetupDate,RegisterCapital,RegisterAdd,MostBusiness,"+
										 " getItemName('IndustryName',IndustryName) as IndustryName,EmployeeNumber,LicenseNo,BasicBank,LoanCardNo "+
										 " from ENT_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		sRegisterAdd = rs2.getString("RegisterAdd");
		if(sRegisterAdd == null) sRegisterAdd=" ";
		
		sRegisterCapital = DataConvert.toMoney(rs2.getDouble("RegisterCapital"));
		if(sRegisterCapital == null) sRegisterCapital="";
		
		sEnterpriseName = rs2.getString("EnterpriseName");
		if(sEnterpriseName == null) sEnterpriseName=" ";
		
		sMostBusiness = rs2.getString("MostBusiness");
		if(sMostBusiness == null) sMostBusiness=" ";
		
		sIndustryName = rs2.getString("IndustryName");
		if(sIndustryName == null) sIndustryName=" ";
		
		sEmployeeNumber = rs2.getString("EmployeeNumber");
		if(sEmployeeNumber == null) sEmployeeNumber=" ";
		
		sLicenseNo = rs2.getString("LicenseNo");
		if(sLicenseNo == null) sLicenseNo=" ";
		
		sBasicBank = rs2.getString("BasicBank");
		if(sBasicBank == null) sBasicBank=" ";
		
		sLoanCardNo = rs2.getString("LoanCardNo");
		if(sLoanCardNo == null) sLoanCardNo=" ";
		
		sSetupDate = rs2.getString("SetupDate");
		if(sSetupDate == null) sSetupDate=" ";		
	}
	rs2.getStatement().close();	
	
	String sFictitiousPerson = "";//法人代表
	sFictitiousPerson = Sqlca.getString("select CustomerName from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and RelationShip = '0100'");
	if(sFictitiousPerson == null) sFictitiousPerson = "";

 %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0101.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >二、受信人基本情况</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（一）授信人概况</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 企业名称：</td>");
   	sTemp.append("   <td colspan='3' align=left class=td1 > "+sEnterpriseName+"&nbsp;</td>");  
   	sTemp.append("   <td colspan='1' align=left class=td1 > 成立时间：</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sSetupDate+"&nbsp;</td>");  	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 注册资本(万元)：</td>");
   	sTemp.append("   <td colspan='1' align=left class=td1 > "+sRegisterCapital+"&nbsp;</td>");  
   	sTemp.append("   <td colspan='1' align=left class=td1 > 注册地址：</td>");   	
  	sTemp.append("   <td colspan='3' align=left class=td1 >"+sRegisterAdd+"&nbsp;</td>");  	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 经营范围：</td>");
   	sTemp.append("   <td colspan='5' align=left class=td1 > "+sMostBusiness+"&nbsp;</td>");  	 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
   	sTemp.append("   <td colspan='1' align=left class=td1 > 行业：</td>");   	
  	sTemp.append("   <td colspan='3' align=left class=td1 >"+sIndustryName+"&nbsp;</td>"); 
   	sTemp.append("   <td colspan='1' align=left class=td1 > 人数：</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sEmployeeNumber+"&nbsp;</td>");    	 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 营业执照：</td>");
   	sTemp.append("   <td colspan='3' align=left class=td1 > "+sLicenseNo+"&nbsp</td>");  
   	sTemp.append("   <td colspan='1' align=left class=td1 > 是否年检：</td>");   	
	sTemp.append("   <td colspan=1 class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:30'",getUnitData("describe1",sData)));
	sTemp.append("   &nbsp;</td>");	
	sTemp.append("   </tr>");		
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' width=15% height=30px align=left class=td1 > 法定代表人：</td>");
    sTemp.append("   <td colspan='1' width=15% align=left class=td1 >"+sFictitiousPerson+"&nbsp;</td>");
  	sTemp.append("   <td colspan='1' width=15% align=left class=td1 > 基本开户行：</td>");
    sTemp.append("   <td colspan='1' width=20% align=left class=td1 >"+sBasicBank+"&nbsp;</td>");
  	sTemp.append("   <td colspan='1' width=15% align=left class=td1 > 贷款卡卡号：</td>");
    sTemp.append("   <td colspan='1' width=25% align=left class=td1 >"+sLoanCardNo+"&nbsp;</td>");        
	sTemp.append("   </tr>");
	String sCustomerName = "";
	String sEngageTerm = "";
	rs2 = Sqlca.getASResultSet("select CustomerName,EngageTerm from CUSTOMER_RELATIVE  where CustomerID='"+sCustomerID+"' and RelationShip = '0109'");
	if(rs2.next()){
		sCustomerName = rs2.getString("CustomerName");
		sEngageTerm = rs2.getString("EngageTerm");
		if(sCustomerName == null) sCustomerName = "";
		if(sEngageTerm == null) sEngageTerm = "";
	}
	rs2.getStatement().close();
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 实际掌控人：</td>");
    sTemp.append("   <td colspan='1' align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 从业年限(年)：</td>");
    sTemp.append("   <td colspan='1' align=left class=td1 >"+sEngageTerm+"&nbsp;</td>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > 是否有不良记录：</td>");
	sTemp.append("   <td colspan='1' class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:30'",getUnitData("describe2",sData)));
	sTemp.append("   &nbsp;</td>");
		       
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
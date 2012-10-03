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
	int iDescribeCount = 1;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	String sRegisterAdd = "";		//注册地址
	String sRegisterCapital = "";	//注册资本
	double dRegisterCapital = 0.0;
	String sSellSum = "";          //净资产
	double dSellSum = 0.0 ;
	String sEnterpriseName = "" ;    //企业名称
	String sCreditLevel = "" ;//授信评级
	
	//申请人基本信息
	ASResultSet rs2 = Sqlca.getResultSet("select RegisterAdd,RegisterCapital,SellSum,EnterpriseName,CreditLevel "
							+"from ENT_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		sRegisterAdd = rs2.getString(1);
		if(sRegisterAdd == null) sRegisterAdd=" ";
		
		sRegisterCapital = DataConvert.toMoney(rs2.getDouble(2)/10000);
		if(sRegisterCapital == null) sRegisterCapital="0";
		
		sSellSum = DataConvert.toMoney(rs2.getDouble(3)/10000);
		if(sSellSum == null) sSellSum="0";
		
		sEnterpriseName = rs2.getString(4);
		if(sEnterpriseName == null) sEnterpriseName=" ";
		
		sCreditLevel = rs2.getString(5);
		if(sCreditLevel == null) sCreditLevel=" ";
	}
	rs2.getStatement().close();	
	
	String sFictitiousPerson = "";//法人代表
	sFictitiousPerson = Sqlca.getString("select CustomerName from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and RelationShip = '0100'");
	if(sFictitiousPerson == null) sFictitiousPerson = "";

 %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='5' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（一）申请人基本信息</font></td>"); 	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='5' align=left class=td1 > 企业名称："+sEnterpriseName+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='2' align=left class=td1 > 法定代表人："+sFictitiousPerson+"&nbsp;</td>");
    sTemp.append("   <td colspan='3' align=left class=td1 > 单位地址： "+sRegisterAdd+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='5' align=left class=td1 > 财务报表审计机构："+" "+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='2' align=left class=td1 > 注册资本 ："+sRegisterCapital+"&nbsp;亿元人民币</td>");
    sTemp.append("   <td colspan='3' align=left class=td1 > 总资产 ："+sSellSum+"&nbsp;亿元人民币</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='5' align=left class=td1 > 授信评级："+sCreditLevel+"&nbsp;</td>");
	sTemp.append("   </tr>");
																	
	//申请人基本信息
	sTemp.append("   <tr>");
  	sTemp.append("   <td  width=10% rowspan='4' align=center class=td1 > 股东情况</td>");
    sTemp.append("   <td  align=left class=td1 > 股东名称</td>");
    sTemp.append("   <td  align=left class=td1 > 股东性质</td>");
    sTemp.append("   <td  align=left class=td1 > 出资比例</td>");
    sTemp.append("   <td  align=left class=td1 > 出资方式</td>");
	sTemp.append("   </tr>");
	String sCustomerName = "";    //股东名称
	String sRelationShipName = "";    //出资方式					
	String sInvestmentProp = "";    //出资比例	
	rs2 = Sqlca.getResultSet("select CustomerName,InvestmentProp,RelationShip,"
							+" getItemName('RelationShip',RelationShip) as RelationShipName "
							+" from CUSTOMER_RELATIVE   where CustomerID = '"+sCustomerID+"'  and RelationShip like '52%'  and length(RelationShip)>2 order by InvestmentSum desc ");
	
	int k=1;
	while(rs2.next()){
	
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName=" ";
		
		sRelationShipName = rs2.getString(4);
		if(sRelationShipName == null) sRelationShipName=" ";
		
		sInvestmentProp = rs2.getString(2);
		if(sInvestmentProp == null) sInvestmentProp=" ";
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td  align=left class=td1 > "+sCustomerName+"&nbsp; </td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+ " "+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+sInvestmentProp+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+sRelationShipName+"&nbsp;</td>");
	    k++;
	    sTemp.append("   </tr>");	    
	}
	rs2.getStatement().close();
	while(k<4){
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td  align=left class=td1 > "+""+"&nbsp; </td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+ " "+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
	    sTemp.append("   </tr>");	 
	    k++; 
	}

	sTemp.append("   <tr>");
  	sTemp.append("   <td  width=10% rowspan='4' align=center class=td1 > 主要下属企业</td>");
    sTemp.append("   <td  align=left class=td1 > 企业名称</td>");
    sTemp.append("   <td  align=left class=td1 > 控股比例</td>");
    sTemp.append("   <td  align=left class=td1 > 注册资本(万元)</td>");
    sTemp.append("   <td  align=left class=td1 > 经营范围</td>");
    sTemp.append("   </tr>");
	String sInvestmentSum="";	//注册资本
	double dInvestmentSum=0.0;
	String sDescribe="";		//主要经营范围
	
	rs2 = Sqlca.getResultSet(" select CustomerName,InvestmentProp,InvestmentSum, Describe" +
					" from CUSTOMER_RELATIVE " +
					" where CustomerID = '"+sCustomerID+"' "+
					" and RelationShip like '56%' "+
					" and length(RelationShip)>2 ");
	k=1;
	while(rs2.next()){
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName=" ";
		
		sInvestmentProp = rs2.getString(2);
		if(sInvestmentProp == null) sInvestmentProp=" ";
		
		sInvestmentSum = rs2.getString(3);
		if(sInvestmentSum == null) sInvestmentSum="0";
		dInvestmentSum = DataConvert.toDouble(sInvestmentSum)/10000;
		
		sDescribe = rs2.getString(4);
		if(sDescribe == null) sDescribe=" ";
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td  align=left class=td1 > "+sCustomerName+"&nbsp; </td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+sInvestmentProp+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+dInvestmentSum+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+sDescribe+"&nbsp;</td>");
	    k++;
	    sTemp.append("   </tr>");
	}
	rs2.getStatement().close();
	while(k<4){
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td  align=left class=td1 > "+""+"&nbsp; </td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+ " "+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
	    sTemp.append("   </tr>");	 
	    k++; 
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
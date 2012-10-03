<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.creditline.bizlets.*,com.amarsoft.biz.bizlet.*" %>

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
	int iDescribeCount = 9;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>
<% 
    //保存按钮,预览按钮可见标识
    String sViewOnly = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewOnly"));
    String sViewPrint = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewPrint"));
    if(sViewOnly == null) sViewOnly = "";
    if(sViewPrint == null) sViewPrint = "";
    if("".equals(sViewOnly))
	{
		sButtons[0][0] = "true";
	}
	else
	{
		sButtons[0][0] = "false";
	}

    String sql = "select PhaseNo from flow_Object where objectno='"+sObjectNo+
    "' and ObjectType='CreditApproveApply' and UserID='"+CurUser.UserID+"'";
    String sPhaseNo = Sqlca.getString(sql);

    if(sPhaseNo == null) sPhaseNo = "";

    if("1000".equals(sPhaseNo) && "".equals(sViewPrint))
	{
		sButtons[1][0] = "true";
	}
	else
	{
		sButtons[1][0] = "false";
	}
%>
<%
    
	//获得调查报告数据
	
	int iMoneyUnit = 10000 ;  //单位万元
	String sApprovalNo = "";
	String sCreditAggreement = "";
	String sBusinessType = "";
	String sBusinessTypeName = "";
	String sOrgName = "";
	String sCustomerID = "";
    String sCustomerName = "";
    int sTermMonth = 0;
    Integer sTermDay = 0;
    String sRateFloat1 = "";
    String sRateFloat2 = "";
    double dRateFloat = 0;
    String sVouchType = "";
    String sMainVouchType = "";
    String sBusinessSum = "";
    String sBusinessSum2 = "";
    String sBusinesscurrency = "";
    String sPurpose = "";
    String sToday = StringFunction.getToday();
    String sYear = sToday.substring(0,4);
    String sMonth = sToday.substring(5,7);
    String sDay = sToday.substring(8);
    String sFinishYear = "";//最终审批年
    String sFinishMonth = "";//最终归审批月
    String sFinishDay = "";//最终审批日
    String sEndTime = "";//申请最终审批时间
    String sRateFloatType = "";
    //取申请中的信息
	sql = "select ApprovalNo,CustomerID,CreditAggreement,getOrgName(OperateOrgID) as OrgName,CustomerName,"+
	             "TermMonth,TermDay,RateFloat,RateFloatType,BusinessType,getBusinessName(BusinessType) as BusinessTypeName, "+
	             " VouchType,Purpose,"+
	             " nvl(BusinessSum,0)*geterate(Businesscurrency,'01',ERateDate) as BusinessSum"+
	             " from Business_Apply where SerialNo ='"+sObjectNo+"'";
	//getItemName('Currency',Businesscurrency) as Businesscurrency,Purpose,
	
    ASResultSet rs2 = Sqlca.getResultSet(sql);
    if(rs2.next()){
    	
    	sRateFloatType =rs2.getString("RateFloatType");
    	if(sRateFloatType == null) sRateFloatType=" ";
    	
    	sApprovalNo = rs2.getString("ApprovalNo");
    	if(sApprovalNo == null) sApprovalNo=" ";
    	
    	sCustomerID = rs2.getString("CustomerID");
    	if(sCustomerID == null) sCustomerID=" ";
    	
    	sCreditAggreement = rs2.getString("CreditAggreement");
    	if(sCreditAggreement == null) sCreditAggreement=" ";
    	
    	sOrgName = rs2.getString("OrgName");
    	if(sOrgName == null) sOrgName=" ";
    	
    	sCustomerName = rs2.getString("CustomerName");
    	if(sCustomerName == null) sCustomerName=" ";
    	
    	sTermMonth = rs2.getInt("TermMonth");
    	
    	sTermDay = rs2.getInt("TermDay");
    	//if(sTermDay != null && sTermDay != 0) sTermMonth=sTermMonth+1;
    	
    	sBusinessType = rs2.getString("BusinessType");
    	if(sBusinessType == null) sBusinessType=" ";
    	
    	dRateFloat = rs2.getDouble("RateFloat");
    	if(dRateFloat >=0){
    		if(sRateFloatType.equals("0"))//浮动百分比
        		sRateFloat2 = "同期基准利率上浮"+DataConvert.toMoney(dRateFloat)+"%";
    		else sRateFloat1 = "同期基准利率上浮"+DataConvert.toMoney(dRateFloat)+"个百分点";
    	}else {
    		dRateFloat = 0-dRateFloat;
    		if(sRateFloatType.equals("0"))//浮动百分比
        		sRateFloat2 = "同期基准利率上浮"+DataConvert.toMoney(dRateFloat)+"%";
    		else sRateFloat1 = "同期基准利率下浮"+DataConvert.toMoney(dRateFloat)+"个百分点";
    	}
    	if(sBusinessType.startsWith("3")){
    		sRateFloat1 = "/";
    	}
    	//if(sBusinessType.equals("2050030"))//进口信用证
    	if(sBusinessType.startsWith("2"))//表外业务
    	  { sRateFloat1 = "/";  }
    	

    	sBusinessTypeName = rs2.getString("BusinessTypeName");
    	if(sBusinessTypeName == null) sBusinessTypeName=" ";
    	
    	sVouchType = rs2.getString("VouchType");
    	if(sVouchType == null) sVouchType=" ";
    	
    	sPurpose = rs2.getString("Purpose");
    	if(sPurpose == null) sPurpose=" ";
    	
    	sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum"));
    }
    rs2.getStatement().close();
  
    if(sVouchType.length() >= 3){
	    sMainVouchType =  Sqlca.getString("select itemname from Code_Library where codeno='VouchType' and itemno='"+sVouchType.substring(0,3)+"'");
	    if(sMainVouchType == null) sMainVouchType=" ";
    }
    
    //获取可用授信余额
    String sSql = "select sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)) "+
	    " from BUSINESS_CONTRACT where customerID='"+sCustomerID+"'"+
	    " and BusinessType not like '30%' and (LOWRISK <> '1' or LOWRISK is null) and (FinishDate = '' or FinishDate is null)  ";
	rs2 = Sqlca.getResultSet(sSql);
	String sSumCreditBalance = "";
	while(rs2.next())
	{	
	    sSumCreditBalance = DataConvert.toMoney(rs2.getDouble(1)/10000);
	    if(sSumCreditBalance == null) sSumCreditBalance="0";
	}
	rs2.getStatement().close();
	
	//取最终审批时间
    sSql = "select EndTime from FLOW_TASK where ObjectType = 'CreditApply' and ObjectNo='"+sObjectNo+"' and phaseno in('1000','8000') ";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sEndTime = rs2.getString("EndTime");
		if(sEndTime.length()>=10)
		{
			sFinishYear = sEndTime.substring(0,4);
	    	sFinishMonth = sEndTime.substring(5,7);
	    	sFinishDay = sEndTime.substring(8,10);
		}
	}
	rs2.getStatement().close();
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='02.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=6 ><font style=' font-size: 25pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;天津农商银行授信业务批复</font><br><br>");	
	sTemp.append("   编号："+sApprovalNo+"&nbsp;</td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >呈报机构</td>");
    sTemp.append(" <td colspan=5 align=left class=td1 >"+sOrgName+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >申请人</td>");
    sTemp.append(" <td colspan=5 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width='15%' align=center class=td1 >申请金额</td>");
    sTemp.append(" <td width='25%' align=left class=td1 >"+sBusinessSum+"元&nbsp;</td>");
    sTemp.append(" <td width='10%' align=center class=td1 >期限</td>");
    sTemp.append(" <td width='15%' align=left class=td1 >"+sTermMonth+"个月"+sTermDay+"天&nbsp;</td>");
    sTemp.append(" <td width='10%' align=center class=td1 >利率</td>");
    sTemp.append(" <td width='25%' align=left class=td1 >"+sRateFloat1+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >业务种类</td>");
    sTemp.append(" <td colspan=5 align=left class=td1 >"+sBusinessTypeName);
    sTemp.append(myOutPut("1",sMethod,"name='describe0' style='width:100%; height:25; ' align=center",getUnitData("describe0",sData)));
    sTemp.append("&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >主要担保方式</td>");
    sTemp.append(" <td colspan=5 align=left class=td1 >"+sMainVouchType+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" <td colspan=6 align=left valign=top class=td1 style='width:100%; height:300' >");
    sTemp.append(" <br>&nbsp;&nbsp;&nbsp;&nbsp;有权审批人于"+sFinishYear+"年"+sFinishMonth+"月"+sFinishDay+"日对该项目进行批复，批复如下:<br>");
    sTemp.append("<br>不同意本次授信申请。<br>");
 	sTemp.append("<br><br>&nbsp;&nbsp;&nbsp;&nbsp;未通过原因：<br>");
    sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150; ' align=center",getUnitData("describe1",sData)));
    
    String sApproveOrgName = "xxxx";//最终批复机构
	String sEndApproveTime = "";//最终批复时间
	String sEndPhaseNo = "";//最终阶段
	String sEndFlowNo = "";//最终流程类型
	String sFinalDepartment = "授信审批部";//最终部门
	sYear = "xx"; sMonth = "xx"; sDay = "xx";
	sql = "select OrgName,EndTime from Flow_Task where SerialNo=(select RelativeSerialNo from Flow_task where ObjectType = 'CreditApproveApply' and ObjectNo='"+sObjectNo+"' and PhaseNo = '1000')";
	rs2 = Sqlca.getResultSet(sql);
	if(rs2.next()){
		sApproveOrgName = rs2.getString("OrgName");
		sEndApproveTime = rs2.getString("EndTime");
		if(sApproveOrgName==null) sApproveOrgName="";
		if(sEndApproveTime==null) sEndApproveTime="";
		if(sEndApproveTime.length()>=10) {
			sYear = sEndApproveTime.substring(0,4);
			sMonth = sEndApproveTime.substring(5,7);
			sDay = sEndApproveTime.substring(8,10);
		}
	}
	rs2.getStatement().close();
	sql = "select FlowNo,PhaseNo from Flow_Task where SerialNo=(select RelativeSerialNo from Flow_task where ObjectType = 'CreditApply' and ObjectNo='"+sObjectNo+"' and PhaseNo = '8000')";
	rs2 = Sqlca.getResultSet(sql);
	if(rs2.next()){
		sEndPhaseNo = rs2.getString("PhaseNo");
		sEndFlowNo = rs2.getString("FlowNo");
		
		if(sEndPhaseNo == null) sEndPhaseNo="";
		if(sEndFlowNo == null) sEndFlowNo="";
	}
	rs2.getStatement().close();
	if("EntCreditFlowTJ01".equals(sEndFlowNo)&&"0230".equals(sEndPhaseNo))
	{
		sFinalDepartment="天津农商银行中小企业审批分部";
	}else if("IndCreditFlowTJ01".equals(sEndFlowNo)&&"0210".equals(sEndPhaseNo))
	{
		sFinalDepartment="天津农商银行个人业务审批分部";
	}else{
		sFinalDepartment = sApproveOrgName+"授信审批部";
	}
	
    sTemp.append("<br><br><br><br><p align=right>"+sFinalDepartment+"<br>"+sYear+"年"+sMonth+"月"+sDay+"日</p><br><br><br>");
    sTemp.append("<font style=' font-size: 7pt;FONT-FAMILY:宋体;color:black;' >");
    sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:630; height:20' align=left",getUnitData("describe2",sData))+"</font></td>");	
    sTemp.append(" </tr>");
    sTemp.append("<tr>");
    sTemp.append(" <td align=left colspan=6 class=td1 >");
    if("天津农商银行中小企业审批分部".equals(sFinalDepartment)||"天津农商银行个人业务审批分部".equals(sFinalDepartment))
    {
    	sTemp.append(" <font style=' font-size:10pt;FONT-FAMILY:宋体;' >"+"经办人："+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;审核人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"</font>");
    }else
    {
    	sTemp.append(" <font style=' font-size:10pt;FONT-FAMILY:宋体;' >"+"经办人："+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;复核人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;审核人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"</font>");
    }
  	sTemp.append(" </td>");
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
	editor_generate('describe1');
	editor_generate('describe2');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

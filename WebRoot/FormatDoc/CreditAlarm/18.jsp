<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
<%
	/*
		Author:   pliu  2011.09.13
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
	int iDescribeCount = 9;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>
<% 
    //保存按钮,预览按钮可见标识
    String sViewOnly = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewOnly"));
    String sViewPrint = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewPrint"));
    if(sViewOnly == null) sViewOnly = "";
    if(sViewPrint == null) sViewPrint = "";
    if("true".equals(sViewOnly))
    {
    	sButtons[1][0] = "true";
    	sButtons[0][0] = "false";
    }
    else
    {
    	sButtons[1][0] = "true";
    	sButtons[0][0] = "true";
    	sButtons[1][0] = "true";

    }


    String sCustomerName = "";//客户名称
    String ssObjectNo = "";//
    String sLoanCardNo = "";//贷款卡号
    String sSignalLevel = "";//预警级别
    String sOrgName = "";//预警报告部门
    String sAlarmApplyDate = "";//预警报告日期
    String sApproveDate = "";//预警批准日期
    String sCustomerOpenBalance = "";//批准金额
    String sCreditLevel = "";//客户信用等级
    String sCustomerType = "";//客户类型
    String sName = "";//公司或个人
    String sSql = " select objectNo,getCustomerName(ObjectNo) as CustomerName,"+
                  " getItemName('SignalLevel',RISK_SIGNAL.SignalLevel) as SignalLevel,"+
                  " GetOrgName(InputOrgID) as InputOrgName,"+
                  " AlarmApplyDate,ApproveDate,CustomerOpenBalance,CreditLevel"+
	              " from RISK_SIGNAL where serialno = '"+sObjectNo+"'";
    ASResultSet rs=Sqlca.getResultSet(sSql);
    if(rs.next()){
	  ssObjectNo = rs.getString("objectNo");
	  sCustomerName = rs.getString("CustomerName");
	  sSignalLevel = rs.getString("SignalLevel");
	  sOrgName = rs.getString("InputOrgName");
	  sAlarmApplyDate = rs.getString("AlarmApplyDate");
	  sApproveDate = rs.getString("ApproveDate");
	  sCustomerOpenBalance = rs.getString("CustomerOpenBalance");
	  sCreditLevel = rs.getString("CreditLevel");
   }
    rs.getStatement().close();
    
    if(sCustomerName == null)sCustomerName = "";
    if(sSignalLevel == null)sSignalLevel = "";
    if(sOrgName == null)sOrgName = "";
    if(sAlarmApplyDate == null)sAlarmApplyDate = "";
    if(sApproveDate == null)sApproveDate = "";
    if(sCustomerOpenBalance == null)sCustomerOpenBalance = "";
    if(sCreditLevel == null)sCreditLevel = "";
    
	//获取客户类型
	sSql = " select CustomerType from CUSTOMER_INFO where CustomerID = '"+ssObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerType = DataConvert.toString(rs.getString("CustomerType"));
		if(sCustomerType == null) sCustomerType = "";		
	}
	rs.getStatement().close();
	
    //查询贷款卡号或身份证号
    if(sCustomerType.substring(0,2).equals("01")){
     sName = "企业";
     sSql =  " select LoanCardNo"+
             " from CUSTOMER_INFO"+
             " where customerid ='"+ssObjectNo+"'";
    rs=Sqlca.getResultSet(sSql);
    if(rs.next()){
	    sLoanCardNo = rs.getString("LoanCardNo");
	    if(sLoanCardNo == null) sLoanCardNo = "";
    }
    rs.getStatement().close();
	}else if(sCustomerType.substring(0,2).equals("03")){
		sName = "个人";
	    sSql =  " select Certid"+
                " from CUSTOMER_INFO"+
                " where customerid ='"+ssObjectNo+"'";
        rs=Sqlca.getResultSet(sSql);
        if(rs.next()){
        sLoanCardNo = rs.getString("Certid");
        if(sLoanCardNo == null) sLoanCardNo = "";
    }
    rs.getStatement().close();
	}

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='18.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=10  ><br><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:white' >天津农商银行授信风险预警处置报告</font><br><br></td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >&nbsp;");
	sTemp.append("   <br>报送机构:（盖章）&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;填报日期：&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;月<br><br>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa><strong>"+sName+"概况</strong> </td>");
    sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >客户名称 </td>");
    sTemp.append("   <td colspan=8 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3.5 align=left class=td1 >贷款卡号(个人类为身份证号)</td>");
	sTemp.append("   <td colspan=6.5 align=left class=td1 >"+sLoanCardNo+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >预警级别</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >"+sSignalLevel+"&nbsp;</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >预警报告部门</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >"+sOrgName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >预警报告日期</td>");
	sTemp.append("   <td colspan=2.5 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' ",getUnitData("describe1",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >授信批准日期</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' ",getUnitData("describe2",sData))+"&nbsp;</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >批准金额</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' ",DataConvert.toMoney(getUnitData("describe3",sData)))+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >客户信用等级</td>");
	sTemp.append("   <td colspan=2.5 align=left class=td1 >"+sCreditLevel+"&nbsp;</td>");
    sTemp.append("   </tr>");

    

	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa><strong>授信业务概况</strong> </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=5% class=td1 >序号</td>");
	sTemp.append("   <td width=15% class=td1 >贷款账号</td>");
	sTemp.append("   <td width=10% class=td1 >授信产品名称</td>");
	sTemp.append("   <td width=15% class=td1 >借据金额</td>");
	sTemp.append("   <td width=15% class=td1 >余额</td>");
	sTemp.append("   <td width=15% class=td1 >发生日</td>");	
	sTemp.append("   <td width=15% class=td1 >到期日</td>");
	sTemp.append("   <td width=10% class=td1 >风险分类形态</td>");	
    sTemp.append("   </tr>");


	
	

    String sBillNo = "";
    String sBusinessType = "";
    Double sBusinessSum =0.0;
    Double sBalance = 0.0;
    String sPutOutDate = "";
    String sMaturity = "";
    String sClassifyresult = "";
    //授信业务概况查询
     sSql = " select SerialNo,getBusinessName(BusinessType)as businessname,businesssum,balance,putoutdate,maturity,getItemname('ClassifyResult',Classifyresult) as ClassifyresultName "+		  
		    " from BUSINESS_DUEBILL where Customerid = '"+ssObjectNo+"' and balance>0 and (finishdate is null or finishdate = '')";
    rs = Sqlca.getResultSet(sSql);
 
    int count = 1;
    Double calbusinesssum = 0.0,calbalance = 0.0;
    while(rs.next()){
    	sBillNo = rs.getString("SerialNo");
    	sBusinessType = rs.getString("businessname");
    	sBusinessSum = rs.getDouble("BusinessSum");
    	sBalance = rs.getDouble("Balance");
    	sPutOutDate = rs.getString("PutOutDate");
    	sMaturity = rs.getString("Maturity");
    	sClassifyresult = rs.getString("ClassifyresultName");
        //}
        if(sBillNo == null) sBillNo = "";
        if(sBusinessType == null) sBusinessType = "";
        if(sBusinessSum == null) sBusinessSum = 0.0;
        if(sBalance == null) sBalance = 0.0;
        if(sPutOutDate == null) sPutOutDate = "";
        if(sMaturity == null) sMaturity = "";
        if(sClassifyresult == null) sClassifyresult = "";
    	sTemp.append("   <tr>");
    	sTemp.append("   <td width=5% class=td1 >"+count+"&nbsp;</td>");
    	sTemp.append("   <td width=15% class=td1 >"+sBillNo+"&nbsp;</td>");
    	sTemp.append("   <td width=10% class=td1 >"+sBusinessType+"&nbsp;</td>");
    	sTemp.append("   <td width=15% class=td1 >"+DataConvert.toMoney(sBusinessSum)+"&nbsp;</td>");
    	sTemp.append("   <td width=15% class=td1 >"+DataConvert.toMoney(sBalance)+"&nbsp;</td>");
    	sTemp.append("   <td width=15% class=td1 >"+sPutOutDate+"&nbsp;</td>");	
    	sTemp.append("   <td width=15% class=td1 >"+sMaturity+"&nbsp;</td>");
    	sTemp.append("   <td width=10% class=td1 >"+sClassifyresult+"&nbsp;</td>");		
        sTemp.append("   </tr>"); 
        count++;
        calbusinesssum += sBusinessSum;
        calbalance += sBalance;
        //rrs.getStatement().close();
    }

    
    rs.getStatement().close();

   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >合计");
	sTemp.append("   </td>");
	sTemp.append("   <td colspan=2 class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+DataConvert.toMoney(calbusinesssum)+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+DataConvert.toMoney(calbalance)+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >风险敞口");
	sTemp.append("   </td>");
	sTemp.append("   <td colspan=4 class=td1 >"+DataConvert.toMoney(sCustomerOpenBalance)+"&nbsp;</td>");
    sTemp.append("   </tr>");
            
	    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>风险预警信号的现状");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>风险预警处置措施的实施效果");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:150'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
   	 
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>处置过程中遇到的问题");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:150'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
   	 
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>下一步实施计划");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:150'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>其他需要说明的事项");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:150'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;");
	sTemp.append("   <br>");
	sTemp.append("   填报人签字：  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("  负责人签字：   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：");
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
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
	editor_generate('describe5');		//需要html编辑,input是没必要
	editor_generate('describe6');		//需要html编辑,input是没必要
	editor_generate('describe7');		//需要html编辑,input是没必要
	editor_generate('describe8');		//需要html编辑,input是没必要
	editor_generate('describe9');		//需要html编辑,input是没必要

<%
	}
%>	
</script>

<%@ include file="/IncludeEnd.jsp"%>




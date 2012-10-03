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
	int iDescribeCount = 116;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//判断该报告是否完成
	String sSql="select finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next())
	{
		FinishFlag = rs.getString("finishdate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null)
	{
		sButtons[1][0] = "true";
	}
	else
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
	String sCustomerID = "";
	String sCustomerName = "";
	String sOrgTypeName = "";
	String sOtheCreditLevel = "";
	sSql = " select ObjectNo"+
			" from INSPECT_INFO II"+
			" where II.SerialNo='"+sSerialNo+"'";
	
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sCustomerID=rs.getString(1);
	}
	rs.getStatement().close();
	if(sCustomerID == null) sCustomerID = "";
	sSql = " select getCustomerName(CustomerID),getItemName('OrgType',OrgType) as OrgTypeName,CreditLevel"+
		   " from ent_info where customerID = '"+sCustomerID+"'";
	rs=Sqlca.getResultSet(sSql);
	if(rs.next()){
		sCustomerName = rs.getString(1);
		sOrgTypeName = rs.getString(2);
		sOtheCreditLevel = rs.getString(3);
	}
	rs.getStatement().close();
	if(sCustomerName == null) sCustomerName = "";
	if(sOrgTypeName == null) sOrgTypeName = "";
	if(sOtheCreditLevel == null) sOtheCreditLevel = "";
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='07.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=25 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>天津农商银行</p>公司客户一般风险常规检查报告</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >填报单位：</td>");
	sTemp.append("   <td colspan=3 class=td1 > "+CurOrg.OrgName);
	//sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:40'",getUnitData("describe5",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >检查时间：</td>");
	sTemp.append("   <td colspan=2 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:40'",getUnitData("describe6",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa><strong>授信项目概况：</strong> </td>");
    sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >客户名称： </td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >企业类型：</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sOrgTypeName+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >检查方式：</td>");
	sTemp.append("   <td colspan=3 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:30'",getUnitData("describe1",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >信用等级：</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sOtheCreditLevel+"&nbsp;</td>");
    sTemp.append("   </tr>");
    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >授信审批日期：</td>");
	sTemp.append("   <td colspan=3 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:30'",getUnitData("describe2",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 rowspan = 2 align=left class=td1 >授信审批内容：</td>");
	sTemp.append("   <td colspan=2 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:30'",getUnitData("describe3",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >逾期、欠息情况：</td>");
	sTemp.append("   <td colspan=3 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe116' style='width:100%; height:30'",getUnitData("describe116",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
	sTemp.append("   <td width=17% class=td1 >授信产品名称</td>");
	sTemp.append("   <td width=10% class=td1 >合同编号</td>");
	sTemp.append("   <td width=10% class=td1 >币种</td>");
	sTemp.append("   <td width=10% class=td1 >余额</td>");
	sTemp.append("   <td width=10% class=td1 >发放日</td>");
	sTemp.append("   <td width=13% class=td1 >到期日</td>");
	sTemp.append("   <td width=20% class=td1 >担保检查情况</td>");		
    sTemp.append("   </tr>"); 
    String sBusinessTypeName = "";
    String sContractSerialNo = "";
    String sCurrencyName = "";
    String sBalance = "0.00";
    String sMaturity = ""; 
    String sVouchTypeName = ""; 
    String sPutOutDate = "";
	sSql = " select getBusinessName(BusinessType) as BusinessTypeName,SerialNo,"+
		   " getItemName('Currency',BusinessCurrency)as CurrencyName,Balance,Maturity,getItemName('VouchType',VouchType)"+ 
		   " as VouchTypeName,PutOutDate"+
		   " from BUSINESS_CONTRACT where CustomerID = '"+sCustomerID+"'";
    rs = Sqlca.getResultSet(sSql);
    int i =3;
    while(rs.next()){
    	i++;
    	String name = "describe"+i;
    	sBusinessTypeName = rs.getString(1);
    	sContractSerialNo = rs.getString(2);
    	sCurrencyName = rs.getString(3);
    	sBalance = DataConvert.toMoney(rs.getDouble(4));
    	sMaturity = rs.getString(5);
    	sVouchTypeName = rs.getString(6);
    	sPutOutDate = rs.getString(7);
    	if(sBusinessTypeName == null) sBusinessTypeName = "";
    	if(sContractSerialNo == null) sContractSerialNo = "";
    	if(sCurrencyName == null)sCurrencyName = "";
   	 	if(sBalance == null) sBalance="0.00";
    	if(sMaturity == null) sMaturity = "";
    	if(sVouchTypeName == null) sVouchTypeName = "";
    	if(sPutOutDate == null) sPutOutDate = "";
    	sTemp.append("   <tr>");
		sTemp.append("   <td colspan=1 class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sCurrencyName+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sBalance+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sMaturity+"&nbsp;</td>");
		//sTemp.append("   <td colspan=1 class=td1 >"+sVouchTypeName+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >");
		sTemp.append(myOutPut("1",sMethod,"name='"+name+"' style='width:100%; height:40'",getUnitData(name,sData)));
		sTemp.append("   &nbsp;</td>");
	    sTemp.append("   </tr>");  
    }
    rs.getStatement().close();
  
    sTemp.append(" <tr>");	     
	sTemp.append("   <td colspan=7 align=center class=td1  bgcolor=#aaaaaa  >上次检查日期及情况概述：<br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan=7 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe100' style='width:100%; height:150'",getUnitData("describe100",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
   	
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa >客户财务经营状况分析");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >客户经营财务状况分析：（盈利能力、经营效率、流动性和短期偿债能力、长期偿债能力等）:<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe101' style='width:100%; height:150'",getUnitData("describe101",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa>客户非财务状况分析");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >客户生产经营状况分析：（宏观经营环境、上游配套供应、生产服务能力、销售情况等））:<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe102' style='width:100%; height:150'",getUnitData("describe102",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");   
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >客户或有负债及他行负债状况分析：<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe103' style='width:100%; height:150'",getUnitData("describe103",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");   
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >客户管理水平分析：<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe104' style='width:100%; height:150'",getUnitData("describe104",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >客户重大事项分析：（人事、股权、组织架构、经营策略、经济、法律纠纷等）<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe105' style='width:100%; height:150'",getUnitData("describe105",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >客户授信产品检查：（参考固定资产贷款、票据业务、贸易融资的相关要求）<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe106' style='width:100%; height:150'",getUnitData("describe106",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1  bgcolor=#aaaaaa>对客户履约能力的总体情况判断<br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan=7 align=left class=td1 >对客户总体评价应为：<br/>");
	sTemp.append(myOutPut("1",sMethod,"name='describe107' style='width:100%; height:150'",getUnitData("describe107",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa >客户担保情况分析");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >担保人担保资格及基本经营状况：<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe108' style='width:100%; height:150'",getUnitData("describe108",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >对担保人担保能力分析：<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe109' style='width:100%; height:150'",getUnitData("describe109",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >对担保人担保意愿分析：<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe110' style='width:100%; height:150'",getUnitData("describe110",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1  bgcolor=#aaaaaa>抵（质）押物情况检查<br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >检查情况：<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe111' style='width:100%; height:150'",getUnitData("describe111",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");    
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >总体评价：<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe112' style='width:100%; height:150'",getUnitData("describe112",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa >保证金管理检查：<br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>"); 
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe113' style='width:100%; height:150'",getUnitData("describe113",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");   
      
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1  bgcolor=#aaaaaa>总体评价及应对措施");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >总体评价及应对措施：<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe114' style='width:100%; height:150'",getUnitData("describe114",sData)));
	sTemp.append("   <br>");
	sTemp.append("   客户经理签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >部门负责人意见：<br>");
	//sTemp.append(myOutPut("1",sMethod,"name='describe115' style='width:100%; height:150'",getUnitData("describe115",sData)));
	sTemp.append("   <br>");
	sTemp.append("   <br/><br/><br/><br/>签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：</td>");
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
	editor_generate('describe100');		//需要html编辑,input是没必要
	editor_generate('describe101');		//需要html编辑,input是没必要
	editor_generate('describe102');		//需要html编辑,input是没必要
	editor_generate('describe103');		//需要html编辑,input是没必要
	editor_generate('describe104');		//需要html编辑,input是没必要
	editor_generate('describe105');		//需要html编辑,input是没必要
	editor_generate('describe106');		//需要html编辑,input是没必要
	editor_generate('describe107');		//需要html编辑,input是没必要
	editor_generate('describe108');		//需要html编辑,input是没必要
	editor_generate('describe109');		//需要html编辑,input是没必要
	editor_generate('describe110');		//需要html编辑,input是没必要		
	editor_generate('describe111');		//需要html编辑,input是没必要
	editor_generate('describe112');		//需要html编辑,input是没必要   
	editor_generate('describe113');		//需要html编辑,input是没必要
	editor_generate('describe114');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


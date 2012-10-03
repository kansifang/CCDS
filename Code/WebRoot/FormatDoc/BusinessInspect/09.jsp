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
	int iDescribeCount = 103;	//这个是页面需要输入的个数，必须写对：客户化1
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
	sSql = " select getCustomerName(CustomerID)"+
		   " from Ind_info where customerID = '"+sCustomerID+"'";
	rs=Sqlca.getResultSet(sSql);
	if(rs.next()){
		sCustomerName = rs.getString(1);
	}
	rs.getStatement().close();
	if(sCustomerName == null) sCustomerName = "";
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='09.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=25 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>天津农商银行</p>个人客户常规检查报告</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa><strong>授信项目概况：</strong> </td>");
    sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >借款人名称： </td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >授信业务类别：</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >检查方式：</td>");
	sTemp.append("   <td colspan=3 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:40'",getUnitData("describe1",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >检查时间：</td>");
	sTemp.append("   <td colspan=2 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:40'",getUnitData("describe2",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >借款人还本付息情况：</td>");
	sTemp.append("   <td colspan=3 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:40'",getUnitData("describe3",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >上次检查日期及结果：</td>");
	sTemp.append("   <td colspan=2 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:40'",getUnitData("describe4",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=17% class=td1 >授信产品名称</td>");
	sTemp.append("   <td width=10% class=td1 >合同编号</td>");
	sTemp.append("   <td width=10% class=td1 >余额</td>");
	sTemp.append("   <td width=13% class=td1 >到期日</td>");
	sTemp.append("   <td width=15% class=td1 >担保方式</td>");
	sTemp.append("   <td width=20% class=td1 >担保情况</td>");
	sTemp.append("   <td width=15% class=td1 >偿还方式</td>");		
    sTemp.append("   </tr>"); 
    String sBusinessTypeName = "";
    String sContractSerialNo = "";
    String sPayCyc = "";
    String sBalance = "0.00";
    String sMaturity = ""; 
    String sVouchTypeName = ""; 
	sSql = " select getBusinessName(BusinessType) as BusinessTypeName,SerialNo,"+
		   " getItemName('CorpusPayMethod1',PayCyc)as PayCyc,Balance,Maturity,getItemName('VouchType',VouchType) as VouchTypeName"+
		   " from BUSINESS_CONTRACT where CustomerID = '"+sCustomerID+"'";
    rs = Sqlca.getResultSet(sSql);
    int i = 4;
    while(rs.next()){
        i++;
    	String name = "describe"+i;
    	sBusinessTypeName = rs.getString(1);
    	sContractSerialNo = rs.getString(2);
    	sPayCyc = rs.getString(3);
    	sBalance = DataConvert.toMoney(rs.getDouble(4));
    	sMaturity = rs.getString(5);
    	sVouchTypeName = rs.getString(6);
    	if(sBusinessTypeName == null) sBusinessTypeName = "";
    	if(sContractSerialNo == null) sContractSerialNo = "";
    	if(sPayCyc == null)sPayCyc = "";
   	 	if(sBalance == null) sBalance="0.00";
    	if(sMaturity == null) sMaturity = "";
    	if(sVouchTypeName == null) sVouchTypeName = "";
    	sTemp.append("   <tr>");
		sTemp.append("   <td colspan=1 class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sBalance+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sVouchTypeName+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >");
		sTemp.append(myOutPut("1",sMethod,"name='"+name+"' style='width:100%; height:40'",getUnitData(name,sData)));
		sTemp.append("   &nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sPayCyc+"&nbsp;</td>");
	    sTemp.append("   </tr>");  
    }
    rs.getStatement().close();
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 bgcolor=#aaaaaa>借款人个人情况调查");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan=7 align=left class=td1 "+myShowTips(sMethod)+" ><p>包括个人收入、健康、婚姻家庭等变化情况：</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");         
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe100' style='width:100%; height:150'",getUnitData("describe100",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 bgcolor=#aaaaaa>借款人行为调查");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe101' style='width:100%; height:150'",getUnitData("describe101",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 bgcolor=#aaaaaa>逾期及催收情况");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe102' style='width:100%; height:150'",getUnitData("describe102",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 bgcolor=#aaaaaa>总体评价及应对措施");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1>总体评价及应对措施:");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe103' style='width:100%; height:150'",getUnitData("describe103",sData)));
	sTemp.append("   <br>");
	sTemp.append("   客户经理签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1>区县行社风险管理部意见:");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	//sTemp.append(myOutPut("1",sMethod,"name='describe104' style='width:100%; height:150'",getUnitData("describe104",sData)));
	sTemp.append("   <br>");
	sTemp.append("  <br/><br/><br/><br/> 签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1>营业部、直属支行及区县行社负责人意见:");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");     
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	//sTemp.append(myOutPut("1",sMethod,"name='describe105' style='width:100%; height:150'",getUnitData("describe105",sData)));
	sTemp.append("   <br>");
	sTemp.append("  <br/><br/><br/><br/> 签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：</td>");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


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

		History Log: zwhu 2009.8.26增加提款和用款记录
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 47;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//判断该报告是否完成
	String sSql="select FinishDate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next())
	{
		FinishFlag = rs.getString("FinishDate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null)
	{
		sButtons[1][0] = "true";		
	}
	else
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "true";
		sButtons[2][0] = "false";
	}
	sButtons[2][0] = "false";	
	String sCustomerName = "";
	String sBusinessSum="0.00";
	String sPurpose = "";
	String sOriginalPutOutDate = "";
	String sApproveDate = "";
	String sContractSerialNo = "";
	String sManageUserName = "";
	sSql = " select BC.PutOutDate ,BC.BusinessSum,BC.CustomerName,BC.Purpose,BC.ApproveDate,BC.SerialNo,getUserName(BC.ManageUserID) as ManageUserName "+
		   " from INSPECT_INFO II,BUSINESS_CONTRACT BC "+
		   " where II.SerialNo = '"+sSerialNo+"'"+
		   " and II.Objectno = BC.SerialNo"+
		   " and II.ObjectType = '"+sObjectType+"'";	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sOriginalPutOutDate = rs.getString(1);
		if(sOriginalPutOutDate == null) sOriginalPutOutDate = "";
		sBusinessSum = DataConvert.toMoney(rs.getDouble(2));
		if(sBusinessSum == null) sBusinessSum ="0.00";
		sCustomerName = rs.getString(3);
		if(sCustomerName == null) sCustomerName = "";
		sPurpose = rs.getString(4);
		if(sPurpose == null) sPurpose = ""; 
		sApproveDate = rs.getString(5);
		if(sApproveDate == null) sApproveDate = "";	
		sContractSerialNo = rs.getString(6);
		if(sContractSerialNo == null) sContractSerialNo = "";	
		sManageUserName = rs.getString(7);
		if(sManageUserName == null) sManageUserName = "";
	}
	rs.getStatement().close();	   

	sOriginalPutOutDate = Sqlca.getString("select putoutdate from business_duebill where relativeserialno2 = '"+sContractSerialNo+"' fetch first 1 rows only");
	if(sOriginalPutOutDate == null) sOriginalPutOutDate = "";
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=19 bgcolor=#aaaaaa ><font style=' font-size: 16pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>天津农商银行</p>授信用途跟踪检查报告</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=19 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;color:black;background-color:#aaaaaa' >授信项目概况</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >客户名称：</td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+sCustomerName+"</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
  	sTemp.append("   <td colspan=2 align=left class=td1 >授信审批日期</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >"+sApproveDate+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >客户经理：</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >"+sManageUserName+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
  	sTemp.append("   <td colspan=2 align=left class=td1 >放款日期：</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >"+sOriginalPutOutDate+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >放款当日客户结算账户存款总额（元）：</td>");
	sTemp.append("   <td colspan=1 class=td1 >");
	sTemp.append(myOutPut1("2",sMethod,"name='describe1' style='width:100%; height:40'",getUnitData("describe1",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >授信合同约定资金用途：</td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+sPurpose+"</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=19 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;color:black;background-color:#aaaaaa' >资金划付去向与用途</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=8% align=left class=td1 >序号</td>");
	sTemp.append("   <td width=22% align=left class=td1 >收款单位名称</td>");
	sTemp.append("   <td width=20% align=left class=td1 >金额（元）</td>");
	sTemp.append("   <td width=20% align=left class=td1 >划付日期</td>");
	sTemp.append("   <td width=30% align=left class=td1 >用途</td>");
    sTemp.append("   </tr>"); 
    for(int i=1;i<11;i++)
    {
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=1 align=center class=td1  >"+i+"</td>");
		for(int j=1;j<5;j++)
		{
			int temp = 4*(i-1)+1;
			temp = temp+j;
			String name = "describe"+temp;
			if(temp==4*(i-1)+3){
				sTemp.append("   <td colspan=1 class=td1 >");
				sTemp.append(myOutPut1("2",sMethod,"name='"+name+"' style='width:100%; height:40'",getUnitData(name,sData)));
				sTemp.append("   &nbsp;</td>");
			}
			else{
				sTemp.append("   <td colspan=1 class=td1 >");
				sTemp.append(myOutPut("1",sMethod,"name='"+name+"' style='width:100%; height:40'",getUnitData(name,sData)));
				sTemp.append("   &nbsp;</td>");
			}	
		}	
		sTemp.append("   </tr>");						
    } 
    sTemp.append("   <tr>");
    sTemp.append("   <td colspan=1 align=center class=td1  >合计：</td>");
	for(int k=41;k<45;k++)
	{	
		String name = "describe"+k;	
		if(k==42){
			sTemp.append("   <td colspan=1 class=td1 >");
			sTemp.append(myOutPut1("2",sMethod,"name='"+name+"' style='width:100%; height:40'",getUnitData(name,sData)));
			sTemp.append("   &nbsp;</td>");
		}else{
			sTemp.append("   <td colspan=1 class=td1 >");
			sTemp.append(myOutPut("1",sMethod,"name='"+name+"' style='width:100%; height:40'",getUnitData(name,sData)));
			sTemp.append("   &nbsp;</td>");
		}
	}
	sTemp.append("   <tr>");
    sTemp.append("   </tr>");  
  	/*
	  	sTemp.append("   <tr>");
		sTemp.append("   <td colspan=5 align=left class=td1  >柜面会计人员审核签字（盖章):<br/><br/>");
		sTemp.append("   </td>");
	    sTemp.append("   </tr>");  
    */    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=5 align=center class=td1 bgcolor=#aaaaaa ><strong>审批意见落实情况</strong><br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=5 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe46' style='width:100%; height:150'",getUnitData("describe46",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=5 align=center class=td1 bgcolor=#aaaaaa ><strong>检查结论</strong><br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=5 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe47' style='width:100%; height:150'",getUnitData("describe47",sData)));
	sTemp.append("    <br/>客户经理签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	
	sTemp.append("   <td colspan=5 align=left class=td1 >部门负责人意见：<br>&nbsp;");
	//sTemp.append(myOutPut("1",sMethod,"name='describe48' style='width:100%; height:150'",getUnitData("describe48",sData)));
	sTemp.append("    <br/><br/><br/><br/>签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	/*
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=5 align=left class=td1 >营业部、直属支行及区县行社负责人意见：<br>&nbsp;");
		//sTemp.append(myOutPut("1",sMethod,"name='describe49' style='width:100%; height:150'",getUnitData("describe49",sData)));
		sTemp.append("    <br/><br/><br/><br/>签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：");
		sTemp.append("   </td>");
	    sTemp.append("   </tr>"); 
	*/    
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
	editor_generate('describe46');		//需要html编辑,input是没必要
	editor_generate('describe47');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


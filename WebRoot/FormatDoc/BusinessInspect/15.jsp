<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2010.05.26
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
	int iDescribeCount = 42;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	String sOrgFlag = Sqlca.getString("select OrgFlag from Org_Info where orgid = '"+CurOrg.OrgID+"'");
	if(sOrgFlag == null) sOrgFlag = "";
	//判断该报告是否完成
	sButtons[0][5] = "my_save1()";
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
		sButtons[1][0] = "false";
		sButtons[3][0] = "true";
	}
	else
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
	if((CurUser.hasRole("210") && "030".equals(sOrgFlag)) || CurUser.hasRole("410")){
		sButtons[0][0] = "true";
	}
	int iCount = 0 ;
	String sCustomerID = "";
	String sCustomerName = "";
	String sOrgTypeName = "";//企业类型
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
	sSql = " select getCustomerName(CustomerID) as CustomerName, getItemName('OrgType',OrgType) as OrgTypeName "+
		   " from ENT_INFO where customerID = '"+sCustomerID+"'";
	rs=Sqlca.getResultSet(sSql);
	if(rs.next()){
		sCustomerName = rs.getString("CustomerName");
		sOrgTypeName = rs.getString("OrgTypeName");
	}
	rs.getStatement().close();
	if(sCustomerName == null) sCustomerName = "";
	if(sOrgTypeName == null) sOrgTypeName = "";
	for(int i=2;i<18;i++){
		String sScore = getUnitData("describe"+i*2,sData);
			if(!("".equals(sScore) || sScore == null)){
			if(sScore.endsWith(";")){
				sScore = sScore.substring(0,1);
			}
			iCount += Integer.parseInt(sScore.trim());
		}	
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='15.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=4 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>天津农商银行</p>微小企业贷后检查报告</font></td>"); 	
	sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 width=30% align=left class=td1 >客户名称： </td>");
    sTemp.append("   <td colspan=1 width=30% align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 width=20% align=left class=td1 >企业类型：</td>");
	sTemp.append("   <td colspan=1 width=20% align=left class=td1 >"+sOrgTypeName+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >检查方式：</td>");
	sTemp.append("   <td colspan=1 class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:30'",getUnitData("describe1",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >检查时间：</td>");
	sTemp.append("   <td colspan=1 class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:30'",getUnitData("describe2",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >一、检查选择项 </td>");
    sTemp.append("   <td colspan=1 align=left class=td1 >是否有此情况</td>");
    sTemp.append("   <td colspan=1 align=left class=td1 >得分情况</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >1、主要股东是否发生变化（5分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe3'",getUnitData("describe3",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe4'",getUnitData("describe4",sData),"0@1@2@3@4@5&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >2、股权结构是否发生变化（3分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe5'",getUnitData("describe5",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe6'",getUnitData("describe6",sData),"0@1@2@3&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >3、营业执照是否年检（3分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe7'",getUnitData("describe7",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe8'",getUnitData("describe8",sData),"0@1@2@3&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >4、企业主营业务是否发生变化（5分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe9'",getUnitData("describe9",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe10'",getUnitData("describe10",sData),"0@1@2@3@4@5&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >5、本季授信人经营场所是否发生变化（4分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe11'",getUnitData("describe11",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe12'",getUnitData("describe12",sData),"0@1@2@3@4&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >6、实际控制人是否出现婚姻危机（5分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe13'",getUnitData("describe13",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe14'",getUnitData("describe14",sData),"0@1@2@3@4@5&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >7、实际控制人是否参与赌、毒、炒股等行为（10分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe15'",getUnitData("describe15",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe16'",getUnitData("describe16",sData),"0@1@2@3@4@5@6@7@8@9@10"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >8、本季度主要财务人员是否发生变更（4分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe17'",getUnitData("describe17",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe18'",getUnitData("describe18",sData),"0@1@2@3@4&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >9、是否出售、变卖主要的生产性、经营性的固定资产（7分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe19'",getUnitData("describe19",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe20'",getUnitData("describe20",sData),"0@1@2@3@4@5@6@7&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >10、授信人经营活动有无停滞（10分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe21'",getUnitData("describe21",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe22'",getUnitData("describe22",sData),"0@1@2@3@4@5@6@7@8@9@10"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >11、抵（质）押物价值是否下降（3分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe23'",getUnitData("describe23",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe24'",getUnitData("describe24",sData),"0@1@2@3&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >12、抵（质）押物是否办理保险，保险第一受益人是否<br/>为我行，保险金额是否能够覆盖我行贷款金额（5分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe25'",getUnitData("describe25",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe26'",getUnitData("describe26",sData),"0@1@2@3@4@5&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >13、保证人担保意愿是否发生不利变化（10分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe27'",getUnitData("describe27",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe28'",getUnitData("describe28",sData),"0@1@2@3@4@5@6@7@8@9@10"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >14、保证人生产经营是否正常，是否具有代偿能力（8分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe29'",getUnitData("describe29",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe30'",getUnitData("describe30",sData),"0@1@2@3@4@5@6@7@8&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >15、是否有其他不利因素影响我行贷款本息正常回收（8分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe31'",getUnitData("describe31",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe32'",getUnitData("describe32",sData),"0@1@2@3@4@5@6@7@8&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >16、其他情况（10分）</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe33'",getUnitData("describe33",sData),"是@否"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe34'",getUnitData("describe34",sData),"0@1@2@3@4@5@6@7@8@9@10"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=3 align=left class=td1 >合计得分</td>");
    sTemp.append("   <td colspan=1 align=left class=td1 >"+iCount+"&nbsp;</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=4 align=left class=td1 >综合分析</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=4 align=left class=td1 >1、存在问题</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe35' style='width:100%; height:150'",getUnitData("describe35",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=4 align=left class=td1 >2、措施及建议</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe36' style='width:100%; height:150'",getUnitData("describe36",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");				
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=4 align=left class=td1 >3、总体评价</td>");
	sTemp.append("   </tr>");
			
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe37' style='width:100%; height:150'",getUnitData("describe37",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1>客户经理签字：</td>");
   	sTemp.append("   <td colspan=1 align=left class=td1 ><br>");
	sTemp.append(myOutPut("2",sMethod,"name='describe38' style='width:100%; height:35'",getUnitData("describe38",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1>日期:</td>");
   	sTemp.append("   <td colspan=1 align=left class=td1 ><br>");
	sTemp.append(myOutPut("2",sMethod,"name='describe39' style='width:100%; height:35'",getUnitData("describe39",sData)));
	sTemp.append("&nbsp;</td>");	
    sTemp.append("   </tr>");    
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=4 align=left class=td1 >经办行行长意见：<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe40' style='width:100%; height:150'",getUnitData("describe40",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
    
       
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1>签字：</td>");
   	sTemp.append("   <td colspan=1 align=left class=td1 ><br>");
	sTemp.append(myOutPut("2",sMethod,"name='describe41' style='width:100%; height:35'",getUnitData("describe41",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1>日期:</td>");
   	sTemp.append("   <td colspan=1 align=left class=td1 ><br>");
	sTemp.append(myOutPut("2",sMethod,"name='describe42' style='width:100%; height:35'",getUnitData("describe42",sData)));
	sTemp.append("&nbsp;</td>");	
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
		editor_generate('describe35');		//需要html编辑,input是没必要
		editor_generate('describe36');		//需要html编辑,input是没必要
		editor_generate('describe37');		//需要html编辑,input是没必要
		editor_generate('describe40');
	<%
		}
	%>	
	function my_cal(){
		iCount = "<%=iCount%>";
		if(iCount<70){
			alert("此客户满足预警分数，请注意贷后管理!");
		}
	}
	
	function my_save1()
	{
		reportInfo.target = "mypost0";
		reportInfo.Method.value = "2"; //1:display;2:save;3:preview;4:export
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();	
		sCompID = "BusinessInspect15";//微小企业常规检查报告
		sCompURL = "/FormatDoc/BusinessInspect/15.jsp";
		sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
		OpenComp(sCompID,sCompURL,sParamString,"TabContentFrame");		
	}
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


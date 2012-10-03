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
	int iDescribeCount = 3;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[0][0] = "true";
	sButtons[1][0] = "false";
%>
<%
	//获得调查报告数据
	String sInputOrgName = "";
	String sCustomerName = "";
	String sBirthday = "";
	String sSex = "";
	String sNativePlace = ""; //户籍地址
	String sWorkCorp = "";//工作单位
	String sUnitKind = "" ;//行业
	String sHeadShip = ""; //职务
	String sEduExperience = "" ;//学历
	String sMarriage = "";
	String sPopulationNum = "";//人口
	String sFamilyAdd = "";//住址
	String sMonthIncome = "";//月收入
	String sFamilyMonthIncome = "";
	String sEvaluateResult = "";//客户近期信用等级
	int iAge = 0;
	//申请人基本信息
	sInputOrgName = Sqlca.getString("select getOrgName(InputOrgID) as InputOrgName from business_apply where SerialNo = '"+sObjectNo+"'");
	String sSql = " select getCustomerName(Customerid) as CustomerName,Birthday,getItemName('Sex',Sex) as Sex ,NativePlace,WorkCorp, "+
				  " getItemName('IndustryType',UnitKind) as UnitKind,getItemName('HeadShip',HeadShip) as HeadShip,"+
				  " getItemName('EducationExperience',EduExperience) as EduExperience, getItemName('Marriage',Marriage) as Marriage,"+
				  " PopulationNum,FamilyAdd,YearIncome,FamilyMonthIncome from IND_INFO where CustomerID = '"+sCustomerID+"'";
				  
				  
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName=" ";
		sBirthday = rs2.getString("Birthday");
		if(sBirthday == null) sBirthday=" ";
		sSex = rs2.getString("Sex");
		if(sSex == null) sSex=" ";
		sNativePlace = rs2.getString("NativePlace");
		if(sNativePlace == null) sNativePlace=" ";
		sWorkCorp = rs2.getString("WorkCorp");
		if(sWorkCorp == null) sWorkCorp = "";
		sUnitKind = rs2.getString("UnitKind");
		if(sUnitKind == null) sUnitKind=" ";
		sHeadShip = rs2.getString("HeadShip");
		if(sHeadShip == null) sHeadShip=" ";
		sEduExperience = rs2.getString("EduExperience");
		if(sEduExperience == null) sEduExperience=" ";
		sMarriage = rs2.getString("Marriage");
		if(sMarriage == null) sMarriage=" ";
		sPopulationNum = rs2.getString("PopulationNum");
		if(sPopulationNum == null) sPopulationNum=" ";
		sFamilyAdd = rs2.getString("FamilyAdd");
		if(sFamilyAdd == null) sFamilyAdd=" ";
		sMonthIncome = DataConvert.toMoney(rs2.getDouble("YearIncome")/12);
		sFamilyMonthIncome = DataConvert.toMoney(rs2.getDouble("FamilyMonthIncome"));		
		if(sBirthday != null && !"".equals(sBirthday) && !" ".equals(sBirthday))
		{
			iAge = Integer.parseInt(StringFunction.getToday().substring(0,4))-Integer.parseInt(sBirthday.substring(0,4));
		}		
	}
	rs2.getStatement().close();	
	//获取客户近期信用评级结果
	sSql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='Customer' "+
	" and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth  desc fetch first 1 rows only ";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sEvaluateResult   = rs.getString("EvaluateResult");
		if(sEvaluateResult == null) sEvaluateResult ="";
	}
	rs.getStatement().close();
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >一、基本情况</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 呈报机构 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sInputOrgName+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 经办行 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sInputOrgName+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 被授信人 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 年龄 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+iAge+"&nbsp;</td>");
    sTemp.append(" 	</tr>");    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 性别</td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sSex+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 户籍所在地 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sNativePlace+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 现工作单位 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sWorkCorp+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 行业 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sUnitKind+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 职务 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sHeadShip+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 学历 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sEduExperience+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 婚姻状况 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sMarriage+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > 供养人口 </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sPopulationNum+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > 现住址 </td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sFamilyAdd+"&nbsp;</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 工资月收入 </td>");
    sTemp.append("     <td align=left class=td1 >"+sMonthIncome+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > 家庭月收入 </td>");
    sTemp.append("     <td align=left class=td1 >"+sFamilyMonthIncome+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 家庭月支出 </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:'70'",getUnitData("describe1",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > 营业执照号 </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:'70'",getUnitData("describe2",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > 商户/企业名称 </td>");
  	sTemp.append("   <td colspan='3' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:'70'",getUnitData("describe3",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("	 </tr>");  
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > 借款人信用等级测算结果 </td>");
  	sTemp.append(" 		<td colspan='3' align=left class=td1 > 系统评级结果："+sEvaluateResult+" </td>");
    sTemp.append("	 </tr>"); 
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

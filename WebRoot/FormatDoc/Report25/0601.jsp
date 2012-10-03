<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.21
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
	//获得调查报告数据
	
	String sRelationName = "";
	String sCustomerName = "";
	String sHoldDate = "";
	String sEngageTerm = "";
	String sEduExperience = "";
	String sHoldStock = "";	
	String sAge = "";
	String sCardID = "";
	String sInvestDate = "";
	int iAge = 0;
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0601.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=22 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6、借款人管理能力分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=22 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6.1、管理层分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=10% align=center class=td1 > 职位 </td>");
	sTemp.append("   <td width=10% align=center class=td1 > 姓名 </td>");
	sTemp.append("   <td width=10% align=center class=td1 > 年龄 </td>");
	sTemp.append("   <td width=18% align=center class=td1 > 身份证号码 </td>");
	sTemp.append("   <td width=12% align=center class=td1 > 加入公司时间 </td>");
	sTemp.append("   <td width=10% align=center class=td1 > 相关行业从业年限</td>");
	sTemp.append("   <td width=12% align=center class=td1 > 担任该职务时间 </td>");
	sTemp.append("   <td width=28% align=center class=td1 > 持有本公司股份情况</td>");
	sTemp.append("   </tr>");
	String sSql = "select  getItemName('RelationShip',RelationShip) as RelationName,"
				   +"CustomerName,HoldDate,EngageTerm,EduExperience,HoldStock ,BIRTHDAY,CERTID,InvestDate "
                   +"from CUSTOMER_RELATIVE "
                   +"where CustomerID='"+sCustomerID+"' "
                   +"and RelationShip in('0100','01020','01030')";
                   
    ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sRelationName = rs2.getString(1);
		if(sRelationName == null) sRelationName=" ";
		sCustomerName = rs2.getString(2);
		if(sCustomerName == null) sCustomerName=" ";
		sHoldDate = rs2.getString(3);
		if(sHoldDate == null) sHoldDate=" ";
		sEngageTerm = rs2.getString(4);
		if(sEngageTerm == null) sEngageTerm=" ";
		sEduExperience = rs2.getString(5);
		if(sEduExperience == null) sEduExperience=" ";
		sHoldStock = rs2.getString(6);
		if(sHoldStock == null) sHoldStock=" ";
		sAge = rs2.getString(7);
		if(sAge == null||sAge.length()<=1){
			sAge=" ";
		}else{
			iAge = Integer.parseInt(StringFunction.getToday().substring(0,4))-Integer.parseInt(sAge.substring(0,4))+1;
		}
		sCardID = rs2.getString(8);
		if(sCardID == null) sCardID=" ";
		sInvestDate = rs2.getString(9);
		if(sInvestDate == null) sInvestDate=" ";
		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=10% align=center class=td1 nowrap>"+sRelationName+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
		if(" ".equals(sAge)){
			sTemp.append("   <td width=10% align=center class=td1 >"+sAge+"&nbsp;</td>");
		}
		else{
			sTemp.append("   <td width=10% align=center class=td1 >"+iAge+"&nbsp;</td>");
		}
		sTemp.append("   <td width=18% align=center class=td1 >"+sCardID+"&nbsp;</td>");		
		sTemp.append("   <td width=12% align=center class=td1 >"+sInvestDate+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=center class=td1 >"+sEngageTerm+"&nbsp;</td>");
		sTemp.append("   <td width=12% align=center class=td1 >"+sHoldDate+"&nbsp;</td>");
		sTemp.append("   <td width=28% align=center class=td1 >"+sHoldStock+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	rs2.getStatement().close();	
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
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
	int iDescribeCount = 4;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
    //获得调查报告数据
	String sBusinessType = "";    //业务种类
	double dBusinessSum = 0.0;    //申请金额
	String sCurrency = "";        //币种   
	String sVouchTypeName = "";   //担保方式
	String sTermMonth = "";       //贷款期限月
	double dTermYear = 0.0 ;       //贷款期限年
	String sBusinessRate = "";        //年利率
	String sCorPusPayMethod = ""; //还款方式

	ASResultSet rs2 = Sqlca.getResultSet("select getBusinessName(BusinessType)as BusinessType,BusinessSum,"
										+"getitemname('Currency',BusinessCurrency) as CurrencyName ,"
										+"getitemname('VouchType',VouchType) as VouchTypeName, "
										+"TermMonth,BusinessRate,getItemName('CorpusPayMethod2',CorPusPayMethod) as CorPusPayMethod "
										+"from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	
	if(rs2.next())
   {
		sBusinessType=rs2.getString("BusinessType");
		if(sBusinessType ==null ) sBusinessType = "" ;
		sVouchTypeName=rs2.getString("VouchTypeName");
		if(sVouchTypeName == null) sVouchTypeName = "";
		dBusinessSum=rs2.getDouble("BusinessSum");
		sTermMonth=rs2.getString("TermMonth");
		if(sTermMonth == null) sTermMonth = ""; 
		sBusinessRate=rs2.getString("BusinessRate");
		if(sBusinessRate == null) sBusinessRate = "";
		sCorPusPayMethod=rs2.getString("CorPusPayMethod");
	    if(sCorPusPayMethod == null) sCorPusPayMethod = "";
   }
	rs2.getStatement().close();	
	if(!sTermMonth.equals(""))
	{
	    dTermYear = Double.parseDouble(sTermMonth)/12 ;	
	}
%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	sTemp.append("<table class=table1 width='640'  align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6、经审核借款申请资料真实、齐全，申请人具有还款能力，符合个人贷款条件，拟同意：</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=10 align=left class=td1 >");
	sTemp.append("   (1)&nbsp<u>"+sBusinessType+"</u>");
	sTemp.append("   (业务品种)贷款 ；担保方式为<u>"+sVouchTypeName+"</u>");
	sTemp.append("  <br>");
	sTemp.append("   (2)&nbsp金额<u>"+dBusinessSum/10000+"</u>");
	sTemp.append("万元，期限<u>"+dTermYear+"</u>");
	sTemp.append("年；年利率<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:15%; height:25'",getUnitData("describe1",sData)));
	sTemp.append("</u>%");
	sTemp.append("  <br>");
	sTemp.append("   (3)&nbsp还款方式<u>"+sCorPusPayMethod+"</u>");
	sTemp.append("  <br>");
	sTemp.append("   (4)&nbsp首期还款额<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("</u>元"); 
	sTemp.append("   &nbsp;</td>"); 
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
	//editor_generate('describe1');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

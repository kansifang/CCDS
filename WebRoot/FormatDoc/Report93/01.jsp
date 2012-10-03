<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: 报告的第01页
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
	int iDescribeCount = 11;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据
	ASResultSet rs2 = null;
	String sCustomerName = "";//借款人
	String sCorPusPayMethodName = "";//还款方式
	String dBusinessSum = "0.00";//申请金额
	String sGuarantyLocation = "";//抵押物地址
	String sSql = "";
	double dBusinessRate = 0.00;//利率0
	double dGuarantyRate = 0.00;//抵质押率
	int iTermMonth = 0;//期限
	
	//获取申请信息 
    sSql = "select CustomerName,getItemName('CorpusPayMethod2',CorPusPayMethod) as CorPusPayMethodName,"+
    		" BusinessSum,BusinessRate,TermMonth from BUSINESS_APPLY where SerialNo='"+sObjectNo+"' ";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{	
	    sCustomerName = rs2.getString("CustomerName");
	    sCorPusPayMethodName = rs2.getString("CorPusPayMethodName");
	    dBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum"));
	    dBusinessRate = rs2.getDouble("BusinessRate");
	    iTermMonth = rs2.getInt("TermMonth");
	}
	rs2.getStatement().close();
	//获取抵押物信息
	sSql = "select GI.GuarantyLocation,GI.GuarantyRate "+
				" from GUARANTY_RELATIVE GR,GUARANTY_INFO GI "+
	" where GR.ObjectType='CreditApply'  and GR.GuarantyID=GI.GuarantyID and GR.ObjectNo='"+sObjectNo+"' ";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{	
	    sGuarantyLocation = rs2.getString("GuarantyLocation");
	    dGuarantyRate = rs2.getDouble("GuarantyRate");
	}
	rs2.getStatement().close();
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >个人经营性物业抵押贷款业务调查报告</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >一、业务概况</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left colspan=10>借款申请人<u>&nbsp;"+sCustomerName+"&nbsp;</u>，");
	sTemp.append(" 以位于<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' ",getUnitData("describe1",sData))+"");
	sTemp.append("</u>市");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' ",getUnitData("describe2",sData))+"");
	sTemp.append("</u>区物业房屋为抵押，抵押率为<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' ",getUnitData("describe3",sData))+"");
	sTemp.append("</u>%，");
	sTemp.append(" 向我行申请个人经营性物业抵押贷款人民币<u>&nbsp;"+dBusinessSum+"&nbsp;</u>元整，");
	
	sTemp.append(" 期限<u>&nbsp;"+iTermMonth/12+"&nbsp;</u>年，年利率<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:15%; height:25'",getUnitData("describe0",sData)));
	sTemp.append(" %</u>，还款方式为<u>&nbsp;"+sCorPusPayMethodName+"&nbsp;</u>，");
	sTemp.append(" 每期还款额为&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe4' ",getUnitData("describe4",sData))+"");
	sTemp.append("</u>&nbsp;元，放款(前或后)&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' ",getUnitData("describe5",sData))+"");
	sTemp.append("</u>&nbsp;须冻结&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' ",getUnitData("describe6",sData))+"");
	sTemp.append("</u>&nbsp;期还款金额。");
	sTemp.append(" 抵押房产的目前承租方为&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' ",getUnitData("describe7",sData))+"");
	sTemp.append("</u>&nbsp;，（是或非）&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' ",getUnitData("describe8",sData))+"");
	sTemp.append("</u>&nbsp;优质承租人，主要经营&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' ",getUnitData("describe9",sData))+"");
	sTemp.append("</u>&nbsp;，每月租金&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' ",getUnitData("describe10",sData))+"");
	sTemp.append("</u>&nbsp;元，租金支付频率&nbsp;<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' ",getUnitData("describe11",sData))+"");
	sTemp.append("</u>&nbsp;。");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	
                          	
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


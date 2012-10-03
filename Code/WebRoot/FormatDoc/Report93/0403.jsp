<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: 报告的第0403页
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
	int iDescribeCount = 25;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0403.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >3.核查租赁合同</br>"
	+"		(1)核实租赁合同的真实性：对于未经过房管部门备案的租赁合同，须通过现场核实、电话访问以及信息咨询等途径和方法，核实租赁合同的真实性，并在现场对抵押物情况和经营情况进行拍照。对于租赁合同中承租方为物业管理公司等中间转包方的，还须调查、核实中间转包方与物业实际经营者签订的租赁合同的真实性。</br>"
	+"		(2)核实租金水平的真实性：除了防范租金水平虚高之外，还要重点关注是否存在租金已提前支付的情况，须确认借款人提供的申请材料中，是否具有由可信度较高的银行、政府机构等出具的租金收付凭证，如：银行转账凭证、租金发票、租金收入税单等。对于无法提供相关凭证的，须重点进行调查、说明。另外，对于租金水平递增的，须与周边同类物业比较分析租赁合同中租金水平和递增幅度是否合理。</br>"
	+"		(3)调查租金收入的稳定性：核实抵押面积与产权面积是否一致，租赁面积中是否存在其他人持有的或出租人私自搭建的房产；分析抵押物所在区域租赁市场的情况，分析租赁合同到期后抵押物的续租能力和租金水平。</br>"
	+"		(4)租金支付周期及方式：分析租金支付周期与借款人还款周期是否匹配，并调查租金支付方式（现金支付、银行转账等）。</br>"
	+"		(5)须重点核查租赁合同中相关约定条款：是否存在约束抵押物转让、抵押等条款，是否存在违约处罚条款，是否存在租金抵扣条款，签订合同双方是否具有法律效力，对租赁合同中存在的法律瑕疵或风险隐患进行揭示。</br>"
	+"		(6)对于有租赁补充合同协议的，也要按照上述调查内容进行调查核实。 </br> ");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
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
	editor_generate('describe1');		//需要html编辑,input是没必要 
																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


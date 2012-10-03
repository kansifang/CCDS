<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 20100506
		Tester:
		Content: 报告的第0页
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
	int iDescribeCount = 17;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	String sEvaluateResult="";
	String sSql = "";
	ASResultSet rs = null;
	
	//获取客户近期信用评级结果
	sSql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='Customer' "+
	" and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth  desc fetch first 1 rows only ";
	rs = Sqlca.getASResultSet(sSql);
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
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >审   查   报   告</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '17' width=50px > 借款人基本情况分析");
	sTemp.append(" </td>");
	sTemp.append(" <td >（一）企业基本情况：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		"企业成立于哪年，经营地点，注册资本多少，法人代表是谁，主要股东是谁，股东的背景大致进行介绍</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:100'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >（二）借款人合规性分析：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" 借款人是否提供营业执照、组织机构代码证、贷款卡等证件，证件是否符合法律规定（如营业执照期限、实际经营范围是否与规定经营范围一致等）；报表是否审计，是否为我行指定事务所（如果不是的原因）</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    

    sTemp.append(" <tr>");
	sTemp.append(" <td  >（三）借款人经营情况：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" 企业主要经营什么，属于哪个行业，其产品属于那种类型，目前企业在行业中的地位，竞争力如何，近年来经营情况如何，对企业的整体经营情况进行总体评价。</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:100'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >（四）借款人行业整体情况分析：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" 行业的整体情况如何，前景如何，行业内竞争是否激烈，对借款企业的整体影响如何。</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:100'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >（五）法人品行及从业经验介绍：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" 法人年龄，学历，从业经验，法人的信用状况，征信的情况，有无不良记录，在我行及他行的个人贷款情况。</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:100'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");     

    sTemp.append(" <tr>");
	sTemp.append(" <td  >（六）和我行的合作前景：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:100'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");      
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '8' width=50px > 借款人的财务分析");
	sTemp.append(" </td>");
	sTemp.append(" <td >（一）主要财务指标：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  				"1、流动性 （主要包括流动比速动比现金比率等）</p>"+
				"<p>&nbsp;&nbsp;&nbsp;&nbsp;2、盈利性（主要包括主营业务利润率、净利润率、净资产收益率等）</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;3、运营能力（主要包括存货周转率、应收帐款周转率等）</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;4、偿债能力 每一项指标后应对该指标进行整体评价</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:100'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >（二）存在的主要问题：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		"指标的波动性及各项财务数据的波动性进行说明、信用评级说明、授信风险限额说明。</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:100'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    

    sTemp.append(" <tr>");
	sTemp.append(" <td  >（三）财务状况总体判断：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:100'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
	
    
    sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '1' width=50px > 借款人信用等级测算结果");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 >系统评级结果："+sEvaluateResult);
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
    
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '14' width=50px > 授信用途及还款来源分析");
	sTemp.append(" </td>");
	sTemp.append(" <td >（一）历史授信情况：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		"我行的历史授信及担保情况，他行的历史授信及对外担保，目前的贷款状态（含所属集团）。</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe10' style='width:100%; height:100'",getUnitData("describe10",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >（二）授信用途：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		"1、 流动资金贷款，对于新增的需对资金的需求进行分析，预计的销售额是否能和企业申请的金额匹配，目前是否有订单，订单的回款方式是什么，订单的价格如何确定，定价是否合理，该订单是否是和借款企业的长期合作的关系，往年的回款记录如何。目前是否签订了采购合同，付款方式是什么，价格是否合理。</p>"+
  		"<p>&nbsp;&nbsp;&nbsp;&nbsp;2、 固定资产贷款，对于技术改造及固定资产投入的贷款需提供可研，对项目的情况进行简要描述，安装的时间，调试时间，正式能够用于生产的时间及何时能产生收益等；并对该项目投入后的整体收益进行描述（可以按现金流进行测算），贷款期间通过该改造或固定资产投入所带来的收益是否与贷款金额匹配，贷款的期限是否合理。</p>"+
  		"<p>&nbsp;&nbsp;&nbsp;&nbsp;3、 土地储备贷款，按土地储备贷款管理办法执行，对项目进行整体描述，增加合规性审查，即对该土地储备所有的批文进行介绍，项目立项资料是否齐全，注明每一个批文的文号，土地价格的分析。</p>"+
  		"<p>&nbsp;&nbsp;&nbsp;&nbsp;4、 房地产开发贷款，按房地产开发贷款管理办法执行，对项目进行整体描述，合规性审查，证件是否齐全，开发面积多少，占地多少，项目总投多少，资金如何筹措，自筹比例为多少，开发公司的资质如何（如借款主体资质差，其股东单位是否有较高的资质，并对其股东进行简要描述，如开发过哪些楼盘等），目前项目进度如何，预计何时封顶，何时能取得销许，何时入住。定价多少，和周边楼盘的比较，整体销售前景如何，预计的客户群是那些。</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe11' style='width:100%; height:100'",getUnitData("describe11",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    

    sTemp.append(" <tr>");
	sTemp.append(" <td  >（三）贷款用途合规性分析：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" 贷款用途是否符合我行政策规定，是否超资本金比例，利率是否符合我行规定</p>"+
		"<p>&nbsp;&nbsp;&nbsp;&nbsp;1、流动资金贷款是否提供相应合同，合同是否合法合理。</p>"+
		"<p>&nbsp;&nbsp;&nbsp;&nbsp;2、项目贷款、房地产开发贷款、土地储备房贷款是否提供相关文件、批文（没有相关文件的说明理由</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe12' style='width:100%; height:100'",getUnitData("describe12",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >（四）还款来源：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" 还款来源是哪些，也应按照不同类贷款用途进行来源的分析</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe13' style='width:100%; height:100'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >（五）该项目能够给我行带来的受益：");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe14' style='width:100%; height:100'",getUnitData("describe14",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");     

	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '2' width=50px > 第二还款来源的总体评价");
	sTemp.append(" </td>");
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>保证情况："+
  				"<p>&nbsp;&nbsp;&nbsp;&nbsp;基本情况、经营情况、财务情况、银行信用记录（参照借款人模式写）</p>"+
				"<p>抵质押情况：</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;抵质押简介（证件号码，面积，使用权类型，用途，终止日期，目前的状态，如设备，注明设备类型，通用还是专用），权属，产权是否明晰，是否存在重复/分割抵押，评估价值（设备还应注明帐面价值），评估事务所，抵质押率，折合多少。</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;抵质押物整体评价，变现能力，评估价值高低等</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe15' style='width:100%; height:100'",getUnitData("describe15",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
 
 	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '2' width=50px > 特别情况说明");
	sTemp.append(" </td>");
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >"+
  				"<p>&nbsp;&nbsp;&nbsp;&nbsp;说明此笔贷款存在的特殊情况，如是否欠息，是否为整合贷款及审查过程中的特殊问题</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe16' style='width:100%; height:100'",getUnitData("describe16",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
 
	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '2' width=50px > 贷款的总体评价");
	sTemp.append(" </td>");
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >"+
  				"<p>&nbsp;&nbsp;&nbsp;&nbsp;（一）综合归纳本次授信的优势和风险点。</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;（二）针对主要的风险隐患，提出具体和有效的防范、控制措施；</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;（三）对本次授信的风险是否可控，以及收益与风险能否平衡做出明确的判断，总结得出客观公正的审查结论。其中：</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe17' style='width:100%; height:100'",getUnitData("describe17",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>"); 
	sTemp.append("   <tr>"); 
  	sTemp.append("   <td colspan ='2' align=right class=td1 >审查人员："+CurUser.UserName+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	sTemp.append("日期："+StringFunction.getToday()+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br/><br/><br/></td>");
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
	editor_generate('describe2');
	editor_generate('describe3');
	editor_generate('describe4');
	editor_generate('describe5');
	editor_generate('describe6');
	editor_generate('describe7');
	editor_generate('describe8');
	editor_generate('describe9');
	editor_generate('describe10');
	editor_generate('describe11');
	editor_generate('describe12');
	editor_generate('describe13');
	editor_generate('describe14');
	editor_generate('describe15');
	editor_generate('describe16');
	editor_generate('describe17');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.18
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
	int iDescribeCount = 25;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader1.jsp"%>

<%
	//获得调查报告数据
	int iDays = 30;
	String sToday = StringFunction.getToday();
	
	String sLawEffectDate = "";
	String sVouchEffectDate = "";
	String sLawEffectDateInfo = "";
	String sVouchEffectDateInfo = "";
	String sBeginString = StringFunction.getRelativeDate(sToday,iDays);
	int dToday = Integer.parseInt(StringFunction.replace(sToday,"/",""));
	int dBeginString = Integer.parseInt(StringFunction.replace(sBeginString,"/",""));
	Calendar calendar1 = new GregorianCalendar(Integer.parseInt(sToday.substring(0,4)),Integer.parseInt(sToday.substring(5,7)),Integer.parseInt(sToday.substring(8,10)));
	String sSql = " select BC.LawEffectDate, BC.VouchEffectDate "+
				  " from MONITOR_REPORT MR,BUSINESS_CONTRACT BC where BC.SerialNo = MR.ObjectNo and MR.SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{	
		sLawEffectDate = rs.getString(1); 
		sVouchEffectDate = rs.getString(2);
	}
	rs.getStatement().close();
	if(sLawEffectDate == null) sLawEffectDate = "";
	if(sVouchEffectDate == null) sVouchEffectDate = "";
	if(!"".equals(sLawEffectDate))
	{
		int dLawEffectDate = Integer.parseInt(StringFunction.replace(sLawEffectDate,"/",""));
		if(dLawEffectDate<dToday)
		{
			Calendar calendar2 = new GregorianCalendar(Integer.parseInt(sLawEffectDate.substring(0,4)),Integer.parseInt(sLawEffectDate.substring(5,7)),Integer.parseInt(sLawEffectDate.substring(8,10)));
			int diff = (int)((calendar1.getTimeInMillis()-calendar2.getTimeInMillis())/1000/60/60/24);
			sLawEffectDateInfo = "超过"+diff+"天";
		}
		else if(dBeginString<=dLawEffectDate)
		{
			sLawEffectDateInfo = "有效";
		}
		else if(dBeginString>dLawEffectDate)
		{
			sLawEffectDateInfo = "中断时效";
		}
	}
	if(!"".equals(sVouchEffectDate))
	{
		int dVouchEffectDate = Integer.parseInt(StringFunction.replace(sVouchEffectDate,"/",""));
		if(dVouchEffectDate<dToday)
		{
			Calendar calendar2 = new GregorianCalendar(Integer.parseInt(sVouchEffectDate.substring(0,4)),Integer.parseInt(sVouchEffectDate.substring(5,7)),Integer.parseInt(sVouchEffectDate.substring(8,10)));
			int diff = (int)((calendar1.getTimeInMillis()-calendar2.getTimeInMillis())/1000/60/60/24);
			sVouchEffectDateInfo = "超过"+diff+"天";
		}
		else if(dBeginString<=dVouchEffectDate)
		{
			sVouchEffectDateInfo = "有效";
		}
		else if(dBeginString>dVouchEffectDate)
		{
			sVouchEffectDateInfo = "中断时效";
		}
	}	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >账面不良贷款重点监控报告</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >一、客户基本情况监控</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >1、生产经营现状");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报客户因管理或不可抗力等原因停产、关闭，严重资不抵债，或经批准实施破产、兼并、重组等情况。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:80'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >2、主要资产现状");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报客户主要股权、固定资产发生转让、抵押或租赁，影响我系统债权实现等情况。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:80'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >3、高管人员现状");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报客户高管人员有无涉嫌违法犯罪等情况。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:80'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >4、涉诉情况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报客户有无涉及重大诉讼等法律纠纷，影响系统债权实现的情况。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:80'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >5、逃废债情况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报客户有无逃废我行债务的意图和行为。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:80'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >6、集团客户及关联企业情况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报集团客户及关联企业的经营、资产、财务状况变动对系统债权实现的影响。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:80'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >7、合规经营状况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报客户是否由于严重违规经营受到工商、税务、外汇管理、海关、环保或其他监管部门处罚等情况。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:80'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >8、主体资格状况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报营业执照是否经年检，是否有效，是否被注销或吊销。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4'  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:80'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >9、其他情况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报其他影响系统债权实现的情况。</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:80'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");      
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >二、保证担保情况监控</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >1、担保人主体资格情况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报担保人营业执照是否年检，是否关联企业担保等情况，评价担保人主体是否具备担保资格。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe10' style='width:100%; height:80'",getUnitData("describe10",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >2、担保人经营现状");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报担保人生产经营及财务现状，评价其是否具备代偿能力。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe11' style='width:100%; height:80'",getUnitData("describe11",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >3、担保人资产现状");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报担保人资产现状，评价担保人的有效资产是否具备代偿能力。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe12' style='width:100%; height:80'",getUnitData("describe12",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >4、担保时效状况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报担保时效是否有效，超时效天数及及担保时效是否存在瑕疵和法律纠纷。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe13' style='width:100%; height:80'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >5、担保人信用状况及其他");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报担保人信用记录，是否积极配合还款及其他影响系统债权实现的情况。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe14' style='width:100%; height:80'",getUnitData("describe14",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >三、抵（质）押担保情况监控</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >1、抵（质）押物实物状况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>评价抵（质）押实物现状是否完好。是否存在变质、丢失、毁损、灭失等情况。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe15' style='width:100%; height:80'",getUnitData("describe15",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >2、抵（质）押物权属状况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>评价抵（质）押物权属是否有效。是否按规定办理了登记手续，登记手续是否过期，是否办理了保险，抵押顺序和优先受偿权等情况。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe16' style='width:100%; height:80'",getUnitData("describe16",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >3、抵（质）押物变现价值状况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>抵（质）押物的评估价或市场公允价，评价其变现能力。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe17' style='width:100%; height:80'",getUnitData("describe17",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >4、抵（质）押人状况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>评价抵（质）押人是否有损害抵（质）押物实物、权属的行为。如：转移隐匿抵（质）押物，重复抵押，擅自转让、出租、处分抵（质）押物，有无使抵（质）押物价值减少的行为等情况。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe18' style='width:100%; height:80'",getUnitData("describe18",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >四、时效情况监控</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=25% align=left class=td1 >1、诉讼时效有效性");
	sTemp.append("   <td width=25% align=left class=td1 >" +sLawEffectDateInfo+"&nbsp;");
	sTemp.append("   <td width=25% align=left class=td1 >2、担保时效有效性");
	sTemp.append("   <td width=25% align=left class=td1 >" +sVouchEffectDateInfo+"&nbsp;");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >3、中断时效措施</font>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报逾期催收通知书、填报履行连带保证责任通知书，现场公证催收，邮寄催收证明，账户扣收，起诉，申请支付令，申请债务人破产，申请仲裁，请求调解、向有关部门主张债权，要求债务人向我行提出同意履行义务的请求，其他催收方式等。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe19' style='width:100%; height:80'",getUnitData("describe19",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >4、超时效补救措施</font>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报超诉讼或担保时效后，采取了何种补救措施。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe20' style='width:100%; height:80'",getUnitData("describe20",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >5、超时效责任人</font>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报超时效贷款责任人。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe21' style='width:100%; height:80'",getUnitData("describe21",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >五、影响清偿的风险因素</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>综合分析评价影响贷款清偿的各种风险因素。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe22' style='width:100%; height:80'",getUnitData("describe22",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >六、不良资产的清收潜力</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>综合分析评价不良资产的清收潜力。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe23' style='width:100%; height:80'",getUnitData("describe23",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >七、不良资产的清收处置措施</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>结合不良资产的清收潜力和影响清偿的风险因素，制定不良资产的清收处置措施。说明清收措施执行中遇到的问题及下一步的工作等情况。<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe24' style='width:100%; height:80'",getUnitData("describe24",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >八、其他情况</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>其他需要说明的情况<font color='red'>(*必须)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4'  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe25' style='width:100%; height:80'",getUnitData("describe25",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
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
	editor_generate('describe18');	
	editor_generate('describe19');	
	editor_generate('describe20');	
	editor_generate('describe21');	
	editor_generate('describe22');	
	editor_generate('describe23');	
	editor_generate('describe24');	
	editor_generate('describe25');																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


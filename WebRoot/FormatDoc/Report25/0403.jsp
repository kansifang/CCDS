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
	int iDescribeCount =0;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	String sBusinessTypeName = "";    //业务品种
	String sCurrencyType = "";    //币种					
	String sBusinessSum = "";    //金额
	double dBusinessSum=0.0;											
	String sBailRatio = "";   	//保证金比例
	double dBailRatio = 0.00;
	String sTermmonth = "" ;		//期限（月）
	String sBusinessRate = "";    //利率		
	String sVouchTypeName="";  //担保方式			
	String sPurpose = "";
	String sCorpusPayMethodName = "" ;//还款方式
	String sDrawingTypeName = "";//提款方式
	String sContextInfo = "";//提款说明
	String sPaySource = ""; //还款说明
	String sSpace = "0.00";	
	String sApplyType = "";//授信方式				
	//申请人基本信息
	ASResultSet rs2 = Sqlca.getResultSet("select BUSINESSTYPE,getBusinessName(BUSINESSTYPE) as BusinessTypeName,getItemName('Currency',BusinessCurrency),"
								+" BusinessSum,BailRatio,TermMonth,BusinessRate ,getItemName('VouchType',VouchType) as VouchTypeName,"
								+" Purpose,getItemName('CorpusPayMethod',CorpusPayMethod),getItemName('DrawingType',DrawingType),"
								+" ContextInfo,PaySource,"
								+" BusinessSum*getErate(BusinessCurrency,'01',ERateDate) as BusinessSum1 ,"
								+" nvl(BailSum,0)*getErate(nvl(BailCurrency,'01'),'01','') as BailSum1 "
								+" ,getItemName('BusinessApplyType',ApplyType) as ApplyType "
								+"  from BUSINESS_apply   where SerialNo='"+sObjectNo+"'" );
	while(rs2.next()){
		String sBusinessType = rs2.getString(1);
		if(sBusinessType == null) sBusinessType = "";
		
		sBusinessTypeName = rs2.getString(2);
		if(sBusinessTypeName == null) sBusinessTypeName=" ";
	
		sCurrencyType = rs2.getString(3);
		if(sCurrencyType == null) sCurrencyType=" ";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(4)/10000);
		if(sBusinessSum == null) sBusinessSum="0";
		
		sBailRatio = rs2.getString(5);
		if(sBailRatio == null) sBailRatio="0";
		dBailRatio = DataConvert.toDouble(sBailRatio);
		
		sTermmonth = rs2.getString(6);
		if(sTermmonth == null) sTermmonth=" ";
		
		sBusinessRate = rs2.getString(7);
		if(sBusinessRate == null) sBusinessRate=" ";
		
		sVouchTypeName = rs2.getString(8);
		if(sVouchTypeName == null) sVouchTypeName = "";
		
		sPurpose = rs2.getString(9);
		if(sPurpose == null) sPurpose = "";
		
		sCorpusPayMethodName = rs2.getString(10);
		if(sCorpusPayMethodName == null) sCorpusPayMethodName = "";
		
		sDrawingTypeName = rs2.getString(11);
		if(sDrawingTypeName == null) sDrawingTypeName = "";
		
		sContextInfo = rs2.getString(12);
		if(sContextInfo == null) sContextInfo = "";
		
		sPaySource = rs2.getString(13);
		if(sPaySource == null) sPaySource = "";		
		
		if(sBusinessType.startsWith("2")){
			sSpace = DataConvert.toMoney(rs2.getDouble("BusinessSum1")/10000-rs2.getDouble("BailSum1")/10000);
		}
		
		sApplyType = rs2.getString("ApplyType");
		if(sApplyType == null) sApplyType = "";				
	}
	rs2.getStatement().close();
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='0403.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4.3、借款人本次授信申请</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > 授信方式 </td>");
    sTemp.append(" 		<td width=15% align=center class=td1 > 授信品种 </td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >币种</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 >金额（万元）</td>");
   	sTemp.append(" 		<td width=15% align=center class=td1 >保证金比例%</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 >期限（月）</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 >利/费率‰(月)</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > "+sApplyType+"&nbsp; </td>");
    sTemp.append(" 		<td width=15% align=center class=td1 >  "+sBusinessTypeName+"&nbsp; </td>");
    sTemp.append(" 		<td width=10% align=center class=td1 > "+sCurrencyType+"&nbsp;</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 > "+sBusinessSum+"&nbsp;</td>");
   	sTemp.append(" 		<td width=15% align=center class=td1 > "+dBailRatio+"&nbsp;</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 > "+sTermmonth+"&nbsp;</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 > "+sBusinessRate+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > 主要担保方式 </td>");
    sTemp.append(" 		<td colspan='3' align=center class=td1 >"+sVouchTypeName+"&nbsp;</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 > 授信敞口（万元） </td>");
    sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sSpace+"&nbsp;</td>");
    sTemp.append(" 	</tr>");   
     
    sTemp.append("   <tr>");
    sTemp.append(" 		<td  align=center class=td1 > 贷款用途： </td>");
  	sTemp.append("   	<td colspan='6' align=left class=td1 >"+sPurpose+"&nbsp;"); 
	sTemp.append("</td>");
    sTemp.append(" 	</tr>");
  
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > 提款及还款方式： </td>");
  	sTemp.append("   	<td colspan='6' align=left class=td1 >"+"还款方式--"+sCorpusPayMethodName+"<br/>"+"提款方式--"+sDrawingTypeName);
	sTemp.append("&nbsp;</td>");
    sTemp.append(" 	</tr>"); 

  
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

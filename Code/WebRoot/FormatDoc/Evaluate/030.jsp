<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
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
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//获得数据
	String sCustomerName = ""; //共同体名称
	String sRelaCustomerName = "" ;//联系人
	String sMobileTelephone = "" ;//联系电话
	String sManageArea = "";//经营项目
	String sManageAdd = "";//坐落地址
	String sAssessNum1 = "";//商户总数
	String sAssessNum2 = "";//信用商户数
	Double dAssessRate1 = 0.0;//信用商户占比
	String sAssessNum3 = "";//贷款总额
	String sAssessNum4 = "";//不良贷款
	Double dAssessRate2 = 0.0;//不良贷款占比
	String sAssessNum5 = "";//贷款户数
	String sAssessNum6 = "";//不良户数
	Double dAssessRate3 = 0.0;//不良户数占比
	String sAssessNum7 = "";//
	String sAssessNum8 = "";//
	String sAssessNum9 = "";//	
	Double dAssessRate4 = 0.0;//	
	String sOpinion = "";//信用共同体情况简介
	String sOpinion1 = "";//支行评定小组意见
	String sOpinion2 = "";//县行社评定小组意见
	String sInputDate = "";//日期
	
	String sSql = " select CustomerName,RelaCustomerName,MobileTelephone,ManageAdd,ManageArea,AssessNum1,"+
				  " AssessNum2,AssessRate1,AssessNum3,AssessNum4,AssessRate2,AssessNum5,AssessNum6,AssessRate3,AssessNum7,AssessNum8,AssessNum9,"+
				  " AssessRate4,Opinion,Opinion1,Opinion2,InputDate "+
				  " from ASSESSFORM_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCustomerName = rs.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "";
		sRelaCustomerName = rs.getString("RelaCustomerName");
		if(sRelaCustomerName == null) sRelaCustomerName = "";
		sMobileTelephone = rs.getString("MobileTelephone");
		if(sMobileTelephone == null) sMobileTelephone = "";
		sManageAdd = rs.getString("ManageAdd");
		if(sManageAdd == null) sManageAdd = "";
		sManageArea = rs.getString("ManageArea");
		if(sManageArea == null) sManageArea = "";
		sAssessNum1 = String.valueOf(rs.getInt("AssessNum1"));
		if(sAssessNum1 == null) sAssessNum1 = "";
		sAssessNum2 = String.valueOf(rs.getInt("AssessNum2"));
		if(sAssessNum2 == null) sAssessNum2 = "";
		dAssessRate1 = rs.getDouble("AssessRate1");
		if(dAssessRate1 == null) dAssessRate1 = 0.0;
		sAssessNum3 = DataConvert.toMoney(rs.getDouble("AssessNum3"));
		if(sAssessNum3 == null) sAssessNum3 = "";
		sAssessNum4 = DataConvert.toMoney(rs.getDouble("AssessNum4"));
		if(sAssessNum4 == null) sAssessNum4 = "";
		dAssessRate2 = rs.getDouble("AssessRate2");
		if(dAssessRate2 == null) dAssessRate2 = 0.0;
		sAssessNum5 = String.valueOf(rs.getInt("AssessNum5"));		
		if(sAssessNum5 == null) sAssessNum5 = "";
		sAssessNum6 = String.valueOf(rs.getInt("AssessNum6"));
		if(sAssessNum6 == null) sAssessNum6 = "";
		dAssessRate3 = rs.getDouble("AssessRate3");
		if(dAssessRate3 == null) dAssessRate3 = 0.0;		
		sAssessNum7 = String.valueOf(rs.getInt("AssessNum7"));		
		if(sAssessNum7 == null) sAssessNum7 = "";		
		sAssessNum8 = String.valueOf(rs.getInt("AssessNum8"));		
		if(sAssessNum5 == null) sAssessNum5 = "";
		sAssessNum9 = String.valueOf(rs.getInt("AssessNum9"));
		if(sAssessNum6 == null) sAssessNum6 = "";
		dAssessRate4 = rs.getDouble("AssessRate4");		
		sOpinion = rs.getString("Opinion");
		if(sOpinion == null) sOpinion = "";
		sOpinion1 = rs.getString("Opinion1");
		if(sOpinion1 == null) sOpinion1 = "";
		sOpinion2 = rs.getString("Opinion2");
		if(sOpinion2 == null) sOpinion2 = "";
		sInputDate = rs.getString("InputDate");
		if(sInputDate == null) sInputDate = "";
	}
	rs.getStatement().close();			  
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='003.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>信用共同体评定审批表<br>&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1' width=13% class=td1 > 共同体名称</td>");
	sTemp.append("   <td align=left colspan='1' width=20% class=td1 >"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' width=13% class=td1 >联系人</td>");
	sTemp.append("   <td align=left colspan='1' width=15% class=td1 >"+sRelaCustomerName+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' width=15% class=td1 >联系电话</td>");
	sTemp.append("   <td align=left colspan='1' width=20% class=td1 >"+sMobileTelephone+"&nbsp;</td>");	
	sTemp.append("   </tr>");
	
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1'  class=td1 > 坐落地址</td>");
	sTemp.append("   <td align=left colspan='2' class=td1>"+sManageAdd+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>主要经营项目</td>");
	sTemp.append("   <td align=left colspan='2' class=td1>"+sManageArea+"&nbsp;</td>");	
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1'  class=td1 > 法人客户数（户）</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sAssessNum7+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>农户户数(户)</td>");
	sTemp.append("   <td align=left colspan='3' class=td1>"+sAssessNum8+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1'  class=td1 > 信用户数（户）</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sAssessNum9+"&nbsp;</td>");	
	sTemp.append("   <td align=left colspan='1' class=td1>信用户占比（%）</td>");
	sTemp.append("   <td align=left colspan='3' class=td1>"+dAssessRate4+"&nbsp;</td>");	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1'  class=td1 > 商户总数（户）</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sAssessNum1+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>信用商户数(户)</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sAssessNum2+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>信用商户占比（%）</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+dAssessRate1+"&nbsp;</td>");	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1'  class=td1 > 贷款总额（万元）</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sAssessNum3+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>不良贷款（万元）</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sAssessNum4+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>不良贷款占比（%）</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+dAssessRate2+"&nbsp;</td>");	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1'  class=td1 > 贷款户数（户）</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sAssessNum5+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>不良户数（户）</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sAssessNum6+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>不良户数占比（%）</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+dAssessRate3+"&nbsp;</td>");	
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='6'> 信用共同体情况简介：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion+"<br/>"+""+"&nbsp;<br/><br/><br/><br/><br/>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='6'> 支行评定小组意见：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion1+"<br/>"+""+"&nbsp;<br/><br/><br/><br/><br/>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日</td>");
    sTemp.append("   </tr>"); 
 	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='6'> 县行社评定小组意见：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion2+"<br/>"+""+"&nbsp;<br/><br/><br/><br/><br/>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日</td>");
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
	
	if(sEndSection.equals("1"))
		sTemp.append("<br clear=all style='mso-special-character:line-break;'>");
	
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


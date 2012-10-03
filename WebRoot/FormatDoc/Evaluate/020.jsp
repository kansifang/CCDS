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
		String sCustomerName = "";//姓名
		String sCertID = "";//身份证号码
		String sSex = "";//性别
		String sFamilyAdd = "";//长住地址
		String sMobileTelephone = "";//联系电话
		String sWorkName = "";//工作单位/行业
		String sEngageTerm = "";//年限
		String sPerFamilySum = "";//家庭人均纯收入
		String sFamilyMainSum = "";//家庭主要资产
		String sFamilyPureSum = "";//家庭净资产
		String sFamilyMember = "";//家庭主要成员
		String sFamilyTotalSum = "";//家庭年总收入
		String sOpinion = "";//信贷人员意见
		String sOpinion1 = "";//管理部门意见
		String sOpinion2 = "";//评定小组意见	
		String sOpinion3 = "";//支行意见
		String sInputDate = "";//日期
	//获得数据
	String sSql = " Select CustomerName,getItemName('Sex','Sex') as Sex,CertID,FamilyAdd,MobileTelephone,"+
				  " WorkName,EngageTerm,PerFamilySum,FamilyMainSum,FamilyPureSum,FamilyMember,"+
				  " FamilyTotalSum,Opinion,Opinion1,Opinion2,Opinion3,InputDate"+
				  " from ASSESSFORM_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCustomerName = rs.getString("CustomerName");//经营者姓名
		if(sCustomerName == null) sCustomerName = "";
		sCertID = rs.getString("CertID");//身份证号码
		if(sCertID == null) sCertID = "";
		sSex = rs.getString("Sex");//性别
		if(sSex == null) sSex = "";
		sFamilyAdd = rs.getString("FamilyAdd");//家庭地址
		if(sFamilyAdd == null) sFamilyAdd = "";
		sMobileTelephone = rs.getString("MobileTelephone");//联系电话
		if(sMobileTelephone == null) sMobileTelephone = "";
		sWorkName = rs.getString("WorkName");//工作单位/行业
		if(sWorkName == null) sWorkName = "";
		sEngageTerm = rs.getString("EngageTerm");//年限
		if(sEngageTerm == null) sEngageTerm = "";
		sPerFamilySum = DataConvert.toMoney(rs.getDouble("PerFamilySum"));//家庭人均纯收入
		if(sPerFamilySum == null) sPerFamilySum = "";
		sFamilyMainSum = DataConvert.toMoney(rs.getDouble("FamilyMainSum"));//家庭主要资产
		if(sFamilyMainSum == null) sFamilyMainSum = "";
		sFamilyPureSum = DataConvert.toMoney(rs.getDouble("FamilyPureSum"));//家庭净资产
		if(sFamilyPureSum == null) sFamilyPureSum = "";
		sFamilyMember = rs.getString("FamilyMember");//家庭主要成员
		if(sFamilyMember == null) sFamilyMember = "";
		sFamilyTotalSum = DataConvert.toMoney(rs.getDouble("FamilyTotalSum"));//家庭年总收入
		if(sFamilyTotalSum == null) sFamilyTotalSum = "";
		sOpinion = rs.getString("Opinion");//信贷人员意见
		if(sOpinion == null) sOpinion = "";
		sOpinion1 = rs.getString("Opinion1");//管理部门意见
		if(sOpinion1 == null) sOpinion1 = "";
		sOpinion2 = rs.getString("Opinion2");//评定小组意见	
		if(sOpinion2 == null) sOpinion2 = "";
		sOpinion3 = rs.getString("Opinion3");//支行意见
		if(sOpinion3 == null) sOpinion3 = "";
		sInputDate = rs.getString("InputDate");//日期
		if(sInputDate == null) sInputDate = "";
	}
	rs.getStatement().close();
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='002.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='7' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>信用等级评定表<br>&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1' width=10% class=td1 > 姓名</td>");
	sTemp.append("   <td align=left colspan='1' width=15% class=td1>"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' width=10% class=td1>性别</td>");
	sTemp.append("   <td align=left colspan='1' width=15% class=td1>"+sSex+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' width=15% class=td1>身份证号码</td>");
	sTemp.append("   <td align=left colspan='1' width=20% class=td1>"+sCertID+"&nbsp;</td>");	
	sTemp.append("   <td align=left colspan='1' rowspan='5' width=15% class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1' class=td1 > 长住地址</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sFamilyAdd+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >联系电话</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sMobileTelephone+"&nbsp;</td>");
	sTemp.append("   </tr>");
		
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1' class=td1 > 工作单位/行业</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sWorkName+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>年限</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sEngageTerm+"&nbsp;</td>");
	sTemp.append("   <td align=left rowspan='1' class=td1>家庭人均纯收入(万元)</td>");
	sTemp.append("   <td align=left rowspan='1' class=td1>"+sPerFamilySum+"&nbsp;</td>");	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1' class=td1 > 家庭主要资产</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sFamilyMainSum+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >家庭净资产(万元)</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sFamilyPureSum+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1' class=td1 > 家庭主要成员</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sFamilyMember+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >家庭年总收入（万元）</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sFamilyTotalSum+"&nbsp;</td>");
	sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='7'> 客户经理调查结论：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion+"<br/>"+""+"&nbsp;<br/><br/><br/><br/><br/>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日</td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='7'> 村（居）委会意见：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion1+"<br/>"+""+"&nbsp;<br/><br/><br/><br/><br/>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日</td>");
    sTemp.append("   </tr>");
    
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='4'> 评定小组意见：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion2+"<br/>"+""+"&nbsp;<br/><br/><br/><br/>");
  	sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签章：<br/><br/>"+
  				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日");
	sTemp.append("   <br/><br/><br/></td>");
  	sTemp.append("   <td align=left class=td1 colspan='3'> 支行（营业部）意见：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion3+"<br/>"+""+"&nbsp;<br/><br/><br/><br/>");
  	sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签章：<br/><br/>"+
  				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日");
	sTemp.append("   <br/><br/><br/></td>");
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


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
		String sRelaCustomerName = "";//商户名称
		String sManageAdd = "";//经营地址
		String sCustomerName = "";//经营者姓名
		String sCertID = "";//身份证号码
		String sSex = "";//性别
		String sAge = "";//年龄
		String sFamilyAdd = "";//家庭地址
		String sMobileTelephone = "";//联系电话
		String sManageArea = "";//经营范围
		String sPermitID = "";//执照号码
		String sAssessItem2Name = "";//经营摊位面积
		Double dAssessItem2 = 0.0;//经营摊位面积
		String sAssessItem1Name = "";//经营摊位所有权
		Double dAssessItem1 = 0.0;//经营摊位所有权分数
		String sAssessItem3Name = "";//商户总资产
		Double dAssessItem3 = 0.0;//商户总资产分数
		String sAssessItem4Name = "";//年经营收入
		Double dAssessItem4 = 0.0;//年经营收入分数
		String sAssessItem5Name = "";//年净利润
		Double dAssessItem5 = 0.0;//年净利润分数
		String sAssessItem6Name = "";//商户的商誉
		Double dAssessItem6 = 0.0;//商户的商誉分数
		String sAssessItem7Name = "";//费用的缴纳
		Double dAssessItem7 = 0.0;//费用的缴纳分数
		String sAssessItem8Name = "";//应付账款情况
		Double dAssessItem8 = 0.0;//应付账款情况分数
		String sAssessItem9Name = "";//在评定行存款交易量
		Double dAssessItem9 = 0.0;//在评定行存款交易量分数
		String sOtherCondition = "";//其他
		String sAssessLevel = "";//评定信用等级
		Double dAssessScore = 0.0;//得分合计
		String sOpinion = "";//信贷人员意见
		String sOpinion1 = "";//管理部门意见
		String sOpinion2 = "";//评定小组意见	
		String sOpinion3 = "";//支行意见
		String sInputDate = "";//日期
	//获得数据
	String sSql = " select RelaCustomerName,ManageAdd,CustomerName,CertID,getItemName('Sex',Sex) as Sex,Age,FamilyAdd,MobileTelephone,ManageArea,PermitID,"+
				  " getItemName('ManageStallArea',AssessItem2) as AssessItem2Name,AssessItem2,"+
				  " getItemName('ManageStallDroit',AssessItem1) as AssessItem1Name,AssessItem1,"+
				  " getItemName('TotalAsset',AssessItem3) as AssessItem3Name,AssessItem3,"+
				  " getItemName('YearEarning',AssessItem4) as AssessItem4Name,AssessItem4,"+
				  " getItemName('YearRetainProfits',AssessItem5) as AssessItem5Name,AssessItem5,"+
     			  " getItemName('BizCredit',AssessItem6) as AssessItem6Name,AssessItem6,"+
				  " getItemName('FeePay',AssessItem7) as AssessItem7Name,AssessItem7,"+
				  " getItemName('FundCircs',AssessItem8) as AssessItem8Name,AssessItem8,"+
                  " getItemName('DepositTradeMete',AssessItem9) as AssessItem9Name,AssessItem9,"+
				  " OtherCondition,getItemName('AssessLevel',AssessLevel) as AssessLevel,AssessScore,"+
				  " Opinion,Opinion1,Opinion2,Opinion3,InputDate "+
				  " from ASSESSFORM_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sRelaCustomerName = rs.getString("RelaCustomerName");//商户名称
		if(sRelaCustomerName == null) sRelaCustomerName = "";
		sManageAdd = rs.getString("ManageAdd");//经营地址
		if(sManageAdd == null) sManageAdd = "";
		sCustomerName = rs.getString("CustomerName");//经营者姓名
		if(sCustomerName == null) sCustomerName = "";
		sCertID = rs.getString("CertID");//身份证号码
		if(sCertID == null) sCertID = "";
		sSex = rs.getString("Sex");//性别
		if(sSex == null) sSex = "";
		sAge = rs.getString("Age");//年龄
		if(sAge == null) sAge = "";
		sFamilyAdd = rs.getString("FamilyAdd");//家庭地址
		if(sFamilyAdd == null) sFamilyAdd = "";
		sMobileTelephone = rs.getString("MobileTelephone");//联系电话
		if(sMobileTelephone == null) sMobileTelephone = "";
		sManageArea = rs.getString("ManageArea");//经营范围
		if(sManageArea == null) sManageArea = "";
		sPermitID = rs.getString("PermitID");//执照号码
		if(sPermitID == null) sPermitID = "";
		sAssessItem2Name = rs.getString("AssessItem2Name");//经营摊位面积
		if(sAssessItem2Name == null) sAssessItem2Name = "";
		dAssessItem2 = rs.getDouble("AssessItem2");//经营摊位面积
		if(dAssessItem2 == null) dAssessItem2 = 0.0;
		sAssessItem1Name = rs.getString("AssessItem1Name");//经营摊位所有权
		if(sAssessItem1Name == null) sAssessItem1Name = "";
		dAssessItem1 = rs.getDouble("AssessItem1");//经营摊位所有权分数
		if(dAssessItem1 == null) dAssessItem1 = 0.0;
		sAssessItem3Name = rs.getString("AssessItem3Name");//商户总资产
		if(sAssessItem3Name == null) sAssessItem3Name = "";
		dAssessItem3 = rs.getDouble("AssessItem3");//商户总资产分数
		if(dAssessItem3 == null) dAssessItem3 = 0.0;
		sAssessItem4Name = rs.getString("AssessItem4Name");//年经营收入
		if(sAssessItem4Name == null) sAssessItem4Name = "";
		dAssessItem4 = rs.getDouble("AssessItem4");//年经营收入分数
		if(dAssessItem4 == null) dAssessItem4 = 0.0;
		sAssessItem5Name = rs.getString("AssessItem5Name");//年净利润
		if(sAssessItem5Name == null) sAssessItem5Name = "";
		dAssessItem5 = rs.getDouble("AssessItem5");//年净利润分数
		if(dAssessItem5 == null) dAssessItem5 = 0.0;
		sAssessItem6Name = rs.getString("AssessItem6Name");//商户的商誉
		if(sAssessItem6Name == null) sAssessItem6Name = "";
		dAssessItem6 = rs.getDouble("AssessItem6");//商户的商誉分数
		if(dAssessItem6 == null) dAssessItem6 = 0.0;
		sAssessItem7Name = rs.getString("AssessItem7Name");//费用的缴纳
		if(sAssessItem7Name == null) sAssessItem7Name = "";
		dAssessItem7 = rs.getDouble("AssessItem7");//费用的缴纳分数
		if(dAssessItem7 == null) dAssessItem7 = 0.0;
		sAssessItem8Name = rs.getString("AssessItem8Name");//应付账款情况
		if(sAssessItem8Name == null) sAssessItem8Name = "";
		dAssessItem8 = rs.getDouble("AssessItem8");//应付账款情况分数
		if(dAssessItem8 == null) dAssessItem8 = 0.0;
		sAssessItem9Name = rs.getString("AssessItem9Name");//在评定行存款交易量
		if(sAssessItem9Name == null) sAssessItem9Name = "";
		dAssessItem9 = rs.getDouble("AssessItem9");//在评定行存款交易量分数
		if(dAssessItem9 == null) dAssessItem9 = 0.0;
		sOtherCondition = rs.getString("OtherCondition");//其他
		if(sOtherCondition == null) sOtherCondition = "";
		sAssessLevel = rs.getString("AssessLevel");//评定信用等级
		if(sAssessLevel == null) sAssessLevel = "";
		dAssessScore = rs.getDouble("AssessScore");//得分合计
		if(dAssessScore == null) dAssessScore = 0.0;
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
	sTemp.append("	<form method='post' action='001.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>商户信用等级评定表<br>&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='2' class=td1 > 商户名称</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sRelaCustomerName+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >经营地址</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sManageAdd+"&nbsp;</td>");
	sTemp.append("   <td align=left rowspan='5' class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='2' class=td1 > 经营者姓名</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >身份证号码</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sCertID+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='2' class=td1 > 性别</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sSex+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >年龄</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sAge+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='2' class=td1 > 家庭地址</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sFamilyAdd+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >联系电话</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sMobileTelephone+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='2' class=td1 > 经营范围</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sManageArea+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >执照号码</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sPermitID+"&nbsp;</td>");
	sTemp.append("   </tr>");	



	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 序号</td>");
	sTemp.append("   <td align=left class=td1 >评定内容</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >评定标准</td>");
	sTemp.append("   <td align=left class=td1 >实际情况</td>");
	sTemp.append("   <td align=center class=td1 >得分</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 1</td>");
	sTemp.append("   <td align=left class=td1 >经营摊位面积</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >经营者具备所有权5分;租赁0分</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem2Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem2+"&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 2</td>");
	sTemp.append("   <td align=left class=td1 >经营摊位所有权</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >面积100㎡以上15分;面积50㎡以上10分;面积10㎡以上5分</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem1Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem1+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 3</td>");
	sTemp.append("   <td align=left class=td1 >商户总资产</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >总资产100万元以上20分;50万元以上15分;20万元以上10分</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem3Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem3+"&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 4</td>");
	sTemp.append("   <td align=left class=td1 >年经营收入</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >年收入100万元以上15分;50万元以上10分;15万元以上5分</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem4Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem4+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 5</td>");
	sTemp.append("   <td align=left class=td1 >年净利润</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >年净利润30万以上10分;15万以上5分;5万以上1分</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem5Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem5+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 6</td>");
	sTemp.append("   <td align=left class=td1 >商户的商誉</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >不经营假冒伪劣产品、不欺行霸市、重合同守信誉5分</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem6Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem6+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 7</td>");
	sTemp.append("   <td align=left class=td1 >费用的缴纳</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >按期缴纳市场管理费、租赁费、税金等各种费用10分</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem7Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem7+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 8</td>");
	sTemp.append("   <td align=left class=td1 >应付账款情况</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >无恶意拖欠应付账款5分</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem8Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem8+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 9</td>");
	sTemp.append("   <td align=left class=td1 >在评定行存款交易量</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >日均存款15万元以上15分;10万元以上12分;5万元以上10分</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem9Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem9+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 10</td>");
	sTemp.append("   <td align=left class=td1 >其他：</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sOtherCondition+"&nbsp;</td>");
	sTemp.append("   <td align=left class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
	sTemp.append("   <td align=left width=5% class=td1 >"+""+"&nbsp;</td>");	
	sTemp.append("   <td align=left width=15% class=td1 > 评定信用等级</td>");
	sTemp.append("   <td align=left width=25% class=td1  >"+sAssessLevel+"&nbsp;</td>");
	sTemp.append("   <td align=left width=15% class=td1 bordercolor=#FFFFFF>"+""+"&nbsp;</td>");	
	sTemp.append("   <td align=left width=25% class=td1  >得分合计</td>");
	sTemp.append("   <td align=center width=10% class=td1 >"+dAssessScore+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='6'> 信贷人员意见：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion+"<br/>"+""+"&nbsp;<br/><br/><br/><br/><br/>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日</td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='6'> 管理部门意见：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion1+"<br/>"+""+"&nbsp;<br/><br/><br/><br/><br/>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日</td>");
    sTemp.append("   </tr>");
    
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='3'> 评定小组意见：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion2+"<br/>"+""+"&nbsp;<br/><br/><br/><br/>");
  	sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签章：<br/><br/>"+
  				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日");
	sTemp.append("   <br/><br/><br/></td>");
  	sTemp.append("   <td align=left class=td1 colspan='3'> 支行意见：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion3+"<br/>"+""+"&nbsp;<br/><br/><br/><br/>");
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


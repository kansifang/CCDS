<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   wangdw 2012.05.21
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
	int iDescribeCount = 100;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%

	StringBuffer sTemp=new StringBuffer();

	sTemp.append("<form method='post' action='0301.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3、第二还款来源分析</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.1、抵押</font></td>"); 	
	sTemp.append("   </tr>");	
	//获得调查报告数据
	String	sGuarantyLocation = "";					//房屋详细地址
	String	sGuarantySubType  = "";					//房屋性质
	String  sGuarantyDescribe3= "";					//土地性质
	String  sGuarantyAmount   = "";					//建筑面积
	String  sEvalNetValue	  = "";					//抵押物评估价值
	String	sGuarantyRate	  = "";					//抵押率
	String  sGUARANTYTYPE	  = "";					//抵押物类型
	
	String  sGuarantyName	  = "";					//抵押物名称
	double dGuarantyAmount 	  = 0.0;
	double dEvalNetValue      = 0.0;
	double dGuarantyRate	  = 0.0;
	int i = 0;
	int j = 0;
	String sql1 = "select GuarantyLocation,"
		+"getItemName('GagaType',GuarantySubType) as GuarantySubType, "
		+" getItemName('GuarantyGroundAttribute1',GuarantyDescribe3) as GuarantyDescribe3,"
		+"GuarantyAmount,EvalNetValue,GuarantyRate from GUARANTY_INFO "
		+"where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where "
		+"ObjectType = 'CreditApply' and ObjectNo = '"+sObjectNo+"' ) and guarantytype = '010010'  Order by UpdateDate";
	//房产抵押	
	ASResultSet rs1 = Sqlca.getResultSet(sql1);
	while(rs1.next()){
		i++;
		//房屋详细地址
		sGuarantyLocation = rs1.getString("GuarantyLocation");
		if(sGuarantyLocation == null) sGuarantyLocation = "";
		//房屋性质
		sGuarantySubType = rs1.getString("GuarantySubType");
		if(sGuarantySubType == null) sGuarantySubType = "";
		//土地性质
		sGuarantyDescribe3 = rs1.getString("GuarantyDescribe3");
		if(sGuarantyDescribe3 == null) sGuarantyDescribe3 = "";
		//建筑面积
		dGuarantyAmount = rs1.getDouble("GuarantyAmount");
		sGuarantyAmount = DataConvert.toMoney(dGuarantyAmount);
		if(sGuarantyAmount == null) sGuarantyAmount = "";
		//抵押物评估价值
		dEvalNetValue = rs1.getDouble("EvalNetValue")/10000;
		sEvalNetValue = DataConvert.toMoney(dEvalNetValue);
		if(sEvalNetValue == null) sEvalNetValue = "";
		//抵押率
		dGuarantyRate = rs1.getDouble("GuarantyRate");
		sGuarantyRate = DataConvert.toMoney(dGuarantyRate);
		if(sGuarantyRate == null) sGuarantyRate = "";
		
		sTemp.append("   <tr>");
	  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >申请人抵押房屋"+i+"：地址：<u>");
	  	sTemp.append(sGuarantyLocation);
		sTemp.append("</u>&nbsp&nbsp房屋性质：<u>");
		sTemp.append(sGuarantySubType);
		sTemp.append("</u>&nbsp&nbsp土地性质：<u>");
		sTemp.append(sGuarantyDescribe3);
		sTemp.append("</u>   </td>");
		sTemp.append("   </tr>");

		sTemp.append("   <tr>");
	  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >建筑面积：<u>");
		sTemp.append(sGuarantyAmount);
		sTemp.append("</u>㎡&nbsp评估价值：<u>");
		sTemp.append(sEvalNetValue);
		sTemp.append("</u>万元，抵押率为<u>");
		sTemp.append(sGuarantyRate);
		sTemp.append("</u>%");
		sTemp.append("   </td>");
		sTemp.append("   </tr>");
		
	}

	String sql2 = "select GuarantyName,EvalNetValue,GuarantyRate,getItemName('GuarantyList',GUARANTYTYPE) AS GUARANTYTYPE from GUARANTY_INFO "
		+"where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where "
		+"ObjectType = 'CreditApply' and ObjectNo = '"+sObjectNo+"' ) and guarantytype in "
		+"('010020','010025','010030','010040','010050')  Order by UpdateDate";
	//房产抵押	
	ASResultSet rs2 = Sqlca.getResultSet(sql2);
	while(rs2.next()){
		j++;
		//抵押物名称
		sGuarantyName = rs2.getString("GuarantyName");
		sGUARANTYTYPE = rs2.getString("GUARANTYTYPE");
		if(sGuarantyName == null) sGuarantyName = "";
		//抵押物评估价值
		dEvalNetValue = rs2.getDouble("EvalNetValue")/10000;
		sEvalNetValue = DataConvert.toMoney(dEvalNetValue);
		if(sEvalNetValue == null) sEvalNetValue = "";
		//抵押率
		dGuarantyRate = rs2.getDouble("GuarantyRate");
		sGuarantyRate = DataConvert.toMoney(dGuarantyRate);
		if(sGuarantyRate == null) sGuarantyRate = "";
		sTemp.append("   <tr>");
	  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >其他抵押"+j+"&nbsp;&nbsp;");
	  	sTemp.append("<u>");
	  	sTemp.append(sGUARANTYTYPE);	
	  	sTemp.append("</u>");
	  	sTemp.append("&nbsp;&nbsp;抵押物名称：<u>");
	  	sTemp.append(myOutPut("2",sMethod,"name='describe"+j+"' style='width:10%; height:25'",getUnitData("describe"+j,sData)));
		sTemp.append("</u>评估价值：<u>");
		sTemp.append(sEvalNetValue);
		sTemp.append("</u>万元，抵押率为<u>");
		sTemp.append(sGuarantyRate);
		sTemp.append("</u>%");
		sTemp.append("   </td>");
		sTemp.append("   </tr>");
		
	}	
	rs1.getStatement().close();	
	rs2.getStatement().close();	
	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >抵押物变现能力分析：");
  	sTemp.append(myOutPutCheck("3",sMethod,"name='describe0'",getUnitData("describe0",sData),"抵押物变现能力强@抵押物变现能力一般@抵押物变现能力差"));
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
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
	int iDescribeCount = 2;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	String sBusinessType = "";				//业务品种
	String sVouchType    = "";				//担保方式
	double sBusinessSum  = 0.0;				//申请金额
	int sTermMonth	 = 0;					//期限
	double sBusinessRate	 = 0.0;				//利率
	String sCorPusPayMethod = "";			//还款方式
	String sSql1="select getBusinessName(BusinessType) as BusinessType,"
		+"getItemName('VouchType',VouchType) as VouchType,BusinessSum,TermMonth,BusinessRate,"
		+"getItemName('CorpusPayMethod2',CorPusPayMethod) as CorPusPayMethod from "
		+"BUSINESS_APPLY where serialno = '"+sObjectNo+"'";
	System.out.println("sql===<><>"+sSql1);
	ASResultSet rs1 = Sqlca.getResultSet(sSql1);
	
	if(rs1.next())
	{
		sBusinessType = rs1.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = " ";
		sVouchType = rs1.getString("VouchType");
		if(sVouchType == null) sVouchType = " ";
		sBusinessSum = rs1.getDouble("BusinessSum");
		sTermMonth = rs1.getInt("TermMonth");
		sBusinessRate = rs1.getDouble("BusinessRate");
		sCorPusPayMethod = rs1.getString("CorPusPayMethod");
		if(sCorPusPayMethod == null) sCorPusPayMethod = " ";
	}	
	rs1.getStatement().close();	
	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='05.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");

    
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.1、 经办客户经理综合评价意见：</font></td>"); 		sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    

	sTemp.append("   <tr>"); 
	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >经审核借款申请资料真实、齐全，申请人具有还款能力，符合个人贷款条件，拟同意：");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >");
  	sTemp.append("（1）<u>");
  	sTemp.append(sBusinessType);
  	sTemp.append("</u>（业务品种）贷款；担保方式为：");
  	sTemp.append(sVouchType);
	sTemp.append("   </td>");
	sTemp.append("   <tr>"); 

	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >");
  	sTemp.append("（2）");
  	sTemp.append("金额：<u>");
  	sTemp.append(sBusinessSum/10000);
  	sTemp.append("</u>万元，期限<u>");
  	sTemp.append(sTermMonth/12);
  	sTemp.append("</u>年；");
  	sTemp.append("年利率<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:15%; height:25'",getUnitData("describe0",sData)));
	sTemp.append("</u>%;");
	sTemp.append("   </td>");
	sTemp.append("   <tr>"); 
	
	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >");
  	sTemp.append("（3）");
  	sTemp.append("首期还款额<u>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:10%; height:25'",getUnitData("describe1",sData)));
  	sTemp.append("</u>元；");
	sTemp.append("   </td>");
	sTemp.append("   <tr>"); 

	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >");
  	sTemp.append("（4）");
  	sTemp.append("还款方式:&nbsp;&nbsp;<u>");
  	sTemp.append(sCorPusPayMethod);
  	sTemp.append("</u>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>"); 

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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.18
		Tester:
		Content: 调查报告主界面
		Input Param:
			SerialNo: 文档流水号
			ObjectNo：业务流水号
			Method:   其中 1:display;2:save;3:preview;4:export
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
	String sRelativeName = "";
	String sInvestDate = "";
	String sDescribe = "";
	String sInvestmentSum = "";
	String sInvestmentProp = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
		StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0503.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.3、供应渠道分析</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=10% align=center class=td1 >"+" &nbsp;</td>");
  	sTemp.append("   <td width=30% align=center class=td1 > 前三名供应商  </td>");
    sTemp.append("   <td width=20% align=center class=td1 > 金额（万元） </td>");
    sTemp.append("   <td width=25% align=center class=td1 > 占全部采购比率％ </td>");
	sTemp.append("   </tr>");
	String sSql = "select CustomerName,"
				   +"InvestDate ,Describe,InvestmentSum,InvestmentProp "
				   +"from CUSTOMER_RELATIVE "
				   +"where CustomerID='"+sCustomerID+"' "
			       +"and RelationShip='9901' "
				   +"order by InvestmentProp desc";
				   
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	int j=1;
	while(true)
	{
		if(rs2.next())
		{
		sRelativeName = rs2.getString(1);
		if(sRelativeName == null) sRelativeName = " ";
		sInvestDate = rs2.getString(2);
		sDescribe = rs2.getString(3);
		if(sDescribe == null) sDescribe = " ";
		sInvestmentSum = DataConvert.toMoney(rs2.getDouble(4));
		sInvestmentProp = DataConvert.toMoney(rs2.getDouble(5));
		sTemp.append("   <tr>");
		sTemp.append("   <td width=10% align=left class=td1 >"+j+"&nbsp; </td>");
  		sTemp.append("   <td width=30% align=left class=td1 >"+sRelativeName+"&nbsp; </td>");
    	sTemp.append("   <td width=20% align=right class=td1 >"+sInvestmentSum+"&nbsp;</td>");
    	sTemp.append("   <td width=25% align=right class=td1 >"+sInvestmentProp+"&nbsp;</td>");
		sTemp.append("   </tr>");
		}
		else
		{
		sTemp.append("   <tr>");
  		sTemp.append("   <td width=10% align=left class=td1 >"+j+"&nbsp; </td>");
    	sTemp.append("   <td width=30% align=left class=td1 >&nbsp;</td>");
    	sTemp.append("   <td width=20% align=left class=td1 >&nbsp;</td>");
    	sTemp.append("   <td width=25% align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		}
		j++;
		if(j==4) break;
	}
	rs2.getStatement().close();	
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" >从供货质量价格、价格稳定性、付款条件等方面对供应商进行描述：");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.4、销售渠道分析</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=10% align=center class=td1 >"+" &nbsp;</td>");
  	sTemp.append("   <td width=30% align=center class=td1 > 前三名销售商  </td>");
    sTemp.append("   <td width=20% align=center class=td1 > 金额（万元） </td>");
    sTemp.append("   <td width=25% align=center class=td1 > 占全部销售比率％ </td>");
	sTemp.append("   </tr>");
	 sSql = "select CustomerName,"
				   +"InvestDate ,Describe,InvestmentSum,InvestmentProp "
				   +"from CUSTOMER_RELATIVE "
				   +"where CustomerID='"+sCustomerID+"' "
			       +"and RelationShip='9951' "
				   +"order by InvestmentProp desc";
				   
	 rs2 = Sqlca.getResultSet(sSql);
	int k=1;
	while(true)
	{
		if(rs2.next())
		{
			sRelativeName = rs2.getString(1);
			if(sRelativeName == null) sRelativeName = " ";
			sInvestDate = rs2.getString(2);
			sDescribe = rs2.getString(3);
			if(sDescribe == null) sDescribe = " ";
			sInvestmentSum = DataConvert.toMoney(rs2.getDouble(4));
			sInvestmentProp = DataConvert.toMoney(rs2.getDouble(5));
			sTemp.append("   <tr>");
			sTemp.append("   <td width=10% align=left class=td1 >"+k+"&nbsp; </td>");
	  		sTemp.append("   <td width=30% align=left class=td1 >"+sRelativeName+"&nbsp; </td>");
	    	sTemp.append("   <td width=20% align=right class=td1 >"+sInvestmentSum+"&nbsp;</td>");
	    	sTemp.append("   <td width=20% align=right class=td1 >"+sInvestmentProp+"&nbsp;</td>");
			sTemp.append("   </tr>");
			}
		else
			{
			sTemp.append("   <tr>");
	  		sTemp.append("   <td width=10% align=left class=td1 >"+k+"&nbsp; </td>");
	    	sTemp.append("   <td width=30% align=left class=td1 >&nbsp;</td>");
	    	sTemp.append("   <td width=20% align=left class=td1 >&nbsp;</td>");
	    	sTemp.append("   <td width=20% align=left class=td1 >&nbsp;</td>");
			sTemp.append("   </tr>");
		}
		k++;
		if(k==4) break;
	}
	rs2.getStatement().close();		
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" >销售商总体评价：从销售价格、稳定性、付款条件等方面对销售商进行描述");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
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
			editor_generate('describe2');		//需要html编辑,input是没必要    
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

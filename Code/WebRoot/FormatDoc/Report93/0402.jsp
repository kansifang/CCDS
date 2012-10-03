<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: 报告的第0402页
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
	int iDescribeCount = 16;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0402.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=8  >2.房产租赁明细：</td> ");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1  align=center class=td1 >业态</td>");
	sTemp.append("   <td colspan=1  align=center class=td1 >楼层</td>");
	sTemp.append("   <td colspan=1  align=center class=td1 >租户名称</td>");
	sTemp.append("   <td colspan=1  align=center class=td1 >出租面积(m2)</td>");
	sTemp.append("   <td colspan=1  align=center class=td1 >租价</br>（元/日.m2)</td>");
	sTemp.append("   <td colspan=1  align=center class=td1 >租期</td>");
	sTemp.append("   <td colspan=1  align=center class=td1 >年度租金</br>收入（万元）</td>");
	sTemp.append("   <td colspan=1  align=center class=td1 >免租期</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%;' ",getUnitData("describe1",sData))+"");
    sTemp.append("  </td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%;' ",getUnitData("describe2",sData))+"");
    sTemp.append("  </td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%;' ",getUnitData("describe3",sData))+"");
    sTemp.append("  </td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%;' ",getUnitData("describe4",sData))+"");
    sTemp.append("  </td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%;' ",getUnitData("describe5",sData))+"");
    sTemp.append("  </td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%;' ",getUnitData("describe6",sData))+"");
    sTemp.append("  </td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%;' ",getUnitData("describe7",sData))+"");
    sTemp.append("  </td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%;' ",getUnitData("describe8",sData))+"");
    sTemp.append("  </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%;' ",getUnitData("describe9",sData))+"");
    sTemp.append("  </td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%;' ",getUnitData("describe10",sData))+"");
    sTemp.append("  </td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%;' ",getUnitData("describe11",sData))+"");
    sTemp.append("  </td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%;' ",getUnitData("describe12",sData))+"");
    sTemp.append("  </td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%;' ",getUnitData("describe13",sData))+"");
    sTemp.append("  </td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%;' ",getUnitData("describe14",sData))+"");
    sTemp.append("  </td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%;' ",getUnitData("describe15",sData))+"");
    sTemp.append("  </td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%;' ",getUnitData("describe16",sData))+"");
    sTemp.append("  </td>");
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
	//editor_generate('describe1');		//需要html编辑,input是没必要 
																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


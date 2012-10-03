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
	int iDescribeCount = 9;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%

	String sCustomerName = Sqlca.getString("Select CustomerName from Customer_Info where CustomerID = '"+sCustomerID+"'");
 %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >天津农商银行微小型企业<br/>授信审查报告</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 客户名称:");
	sTemp.append(" </td>");
	sTemp.append("   <td align=left class=td1 width=80% >"+sCustomerName+"&nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 申报单位:");
	sTemp.append(" </td>");
	sTemp.append("   <td align=left class=td1 width=80% >"+CurOrg.OrgName+"&nbsp;</td>");
    sTemp.append("   </tr>");   

	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 调查人:");
	sTemp.append(" </td>");
	sTemp.append("   <td align=left class=td1 width=80% >"+CurUser.UserName+"&nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 审议事项:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:100'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 合法合规性审查:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 企业概况:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:100'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
 	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 财务因素分析:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:100'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
 	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 非财务因素分析:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:100'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
   	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 担保分析:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:100'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	   
  	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 授信风险分析:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:100'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
   	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 综合效益分析:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:100'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 综合审查结论:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:100'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");	
	sTemp.append(" <td colspan=2 align=left class=td1 width=20% > 审查人签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > 审查人意见:");
	sTemp.append(" </td>");
	sTemp.append("   <td align=left class=td1 width=80% >&nbsp;<br/><br/><br/><br/><br/><br/><br/><br/>审查人签字:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日");
	sTemp.append(" </td>");
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

<script language="javascript">
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

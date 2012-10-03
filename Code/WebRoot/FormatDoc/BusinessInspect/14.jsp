<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu  2010.04.15
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
	int iDescribeCount = 1;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	String sCustomerID = "";
	String sInputOrgName = "";
	String sCustomerName = "";
	String sBusinessSum = "";
    int iTermMonth = 0;
    double dBusinessRate = 0.0;
    String sBusinessTypeName = "";
    String sVouchTypeName = "";
    String sPurpose = "";
    String sSql = "";
    ASResultSet rs = null;
    
    sSql = " select CustomerName,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,"+
    	   " TermMonth,BusinessRate,getBusinessName(BusinessType) as BusinessTypeName,"+
		   " getItemName('VouchType',VouchType) as VouchTypeName,getOrgName(InputOrgID) as InputOrgName,Purpose,CustomerID "+
		   " from Business_Apply where SerialNo = '"+sObjectNo+"'";
    rs = Sqlca.getASResultSet(sSql);
    if(rs.next()){
    	sCustomerName = rs.getString("CustomerName");
    	if(sCustomerName == null) sCustomerName = "";
    	sBusinessSum =  DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
    	if(sBusinessSum == null) sBusinessSum = "";
    	iTermMonth = rs.getInt("TermMonth");
    	dBusinessRate = rs.getDouble("BusinessRate");
    	sBusinessTypeName = rs.getString("BusinessTypeName");
    	if(sBusinessTypeName == null) sBusinessTypeName = "";	
    	sVouchTypeName = rs.getString("VouchTypeName");
    	if(sVouchTypeName == null) sVouchTypeName = "";	
    	sInputOrgName = rs.getString("InputOrgName");
    	if(sInputOrgName == null) sInputOrgName = "";	
    	sPurpose = rs.getString("Purpose");
    	if(sPurpose == null) sPurpose = "";	    
    	sCustomerID = rs.getString("CustomerID");
    	if(sCustomerID == null) sCustomerID = "";	 	    	    	
    }
	rs.getStatement().close();  
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='12.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 bgcolor=#aaaaaa height=40px><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >天津农商银行授信审查委员会批复</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>编号："+sObjectNo+" </td>");
    sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >呈报行、社： </td>");
    sTemp.append("   <td colspan=5 align=left class=td1 >"+sInputOrgName+"&nbsp;</td>");
    sTemp.append("   </tr>");
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >申请人： </td>");
    sTemp.append("   <td colspan=5 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append("   </tr>");  
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 width=15% align=left class=td1 >申请金额（万元）：</td>");
	sTemp.append("   <td colspan=1 width=15% align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 width=17% align=left class=td1 >期限（月）：</td>");
	sTemp.append("   <td colspan=1 width=18% align=left class=td1 >"+iTermMonth+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 width=18% align=left class=td1 >利率（‰）：</td>");
	sTemp.append("   <td colspan=1 width=18% align=left class=td1 >"+dBusinessRate+"&nbsp;</td>");	
    sTemp.append("   </tr>");   
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >业务种类： </td>");
    sTemp.append("   <td colspan=5 align=left class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
    sTemp.append("   </tr>"); 
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >担保方式： </td>");
    sTemp.append("   <td colspan=5 align=left class=td1 >"+sVouchTypeName+"&nbsp;</td>");
    sTemp.append("   </tr>");         
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>天津农村合作银行授信审查委员会于&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日召开第&nbsp;&nbsp;&nbsp;次会议，集体审议此项目。经审查，意见如下：");
	sTemp.append("   <br/><br/>不同意本次授信申请<br/>□	未通过原因："); 
	sTemp.append("   </td>"); 
    sTemp.append("   </tr>");   
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   </td>");
    sTemp.append("   </tr>"); 
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=right class=td1 height=60px >（盖章）：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<br/> 日期:"+StringFunction.getToday()+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
    sTemp.append("   </tr>");   
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=40px >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经办人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"审核人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
    sTemp.append("   </tr>");              
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
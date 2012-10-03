<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   bqliu 2011-04-29
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   
				FirstSection: 
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据
	String sGuarantyNo = "";//担保号
	ASResultSet rs2 = Sqlca.getResultSet("select GuarantyNo from FORMATDOC_DATA where SerialNo='"+sSerialNo+"' and ObjectNo ='"+sObjectNo+"'");
	if(rs2.next())
	{
		sGuarantyNo = rs2.getString(1);
	}
	rs2.getStatement().close();	
	
	
	String sSql = "select getItemName('GuarantyList',GuarantyType) as GuarantyTypeName,GuarantyID,"+
				  "GuarantyName,OwnerName,GuarantyDescribe2,GuarantyPrice,BeginDate,GuarantyAmount,"+
				  "ThirdParty3,getItemName('YesNo',Flag1) as Flag1,EvalNetValue,getOrgName(InputOrgID) as GuarantyRegOrg,ConfirmValue,GuarantyRate "+
				  "from GUARANTY_INFO where GuarantyID = '"+sGuarantyNo+"'";
	
	String sGuarantyTypeName = "";	//抵押物分类
	String sGuarantyID = "";		//抵押物编号
	String sGuarantyName = "";		//抵押物名称
	String sOwnerName = "";			//抵押物的所有权人
	String sEvalNetValue = "";		//正式评估价值
	String sGuarantyRegOrg = "";	//抵押物登记机构
	String sConfirmValue = "";		//我行确认价值
	double dGuarantyRate = 0;		//抵押率
	
	rs2= Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sGuarantyTypeName = rs2.getString("GuarantyTypeName");
		if(sGuarantyTypeName == null) sGuarantyTypeName = "";
		
		sGuarantyID = rs2.getString("GuarantyID");
		if(sGuarantyID == null) sGuarantyID = "";
		
		sGuarantyName = rs2.getString("GuarantyName");
		if(sGuarantyName == null) sGuarantyName = "";
		
		sOwnerName = rs2.getString("OwnerName");
		if(sOwnerName == null) sOwnerName = "";
		
		sEvalNetValue = DataConvert.toMoney(rs2.getDouble("EvalNetValue")/10000);
		
		sGuarantyRegOrg = rs2.getString("GuarantyRegOrg");
		if(sGuarantyRegOrg == null) sGuarantyRegOrg = "";
		
		sConfirmValue = DataConvert.toMoney(rs2.getDouble("ConfirmValue")/10000);
		
		dGuarantyRate = rs2.getDouble("GuarantyRate");
	}
	rs2.getStatement().close();
	
	//获得编号
	String sTreeNo = "";
	String sTreeNo1 = "";
	String[] sNo = null;
	String[] sNo2 = null;
	String[] sNo1 = null; 
	int iNo=1,i=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '070_' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo1 += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo2 = sTreeNo1.split(",");
	iNo = sNo2.length;
	
	int j=0; 
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '04%' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	iNo++;
	for(j=0;j<sNo.length;j++)
	{	
		//iNo++;	
		sNo1[j] = "8."+iNo+"."+(j+1);		
	}
	
	sSql = "select TreeNo,DirName from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	String sTreeName = "";
	if(rs2.next()){
		sTreeNo = rs2.getString(1);
		sTreeName = rs2.getString(2);	
	}	
	rs2.getStatement().close();
	for(j=0;j<sNo.length;j++)
	{
		if(sNo[j].equals(sTreeNo))  break;
	}	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='030601.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=4 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >（一）抵（质）押担保情况</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=25% align=center class=td1 >抵（质）物名称&nbsp;</td>");
  	sTemp.append(" <td width=25% align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
  	sTemp.append(" <td width=25% align=center class=td1 >抵（质）物编号&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+sGuarantyID+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=25% align=center class=td1 >抵（质）物所有人&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+sOwnerName+"&nbsp;</td>");
  	sTemp.append(" <td width=25% align=center class=td1 >抵（质）物价值（万元）&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+sEvalNetValue+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >抵（质）物登记机构&nbsp;</td>");
    sTemp.append(" <td colspan=3 align=center class=td1 >"+sGuarantyRegOrg+"&nbsp;</td>");
  	
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=25% align=center class=td1 >我行确认价值（万元）&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+sConfirmValue+"&nbsp;</td>");
  	sTemp.append(" <td width=25% align=center class=td1 >抵（质）押率（%）&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+dGuarantyRate+"&nbsp;</td>");
    sTemp.append(" </tr>");
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


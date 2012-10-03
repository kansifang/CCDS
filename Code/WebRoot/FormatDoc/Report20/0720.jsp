<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.09.18
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
	int iDescribeCount = 10;	//这个是页面需要输入的个数，必须写对：客户化1
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
	String sGuarantyDescribe2 = "";	//抵押物详细描述
	String sGuarantyPrice = "";		//抵押物原值
	int dGuarantyAmount1 = 0;	//数量
	String sEvalNetValue = "";		//正式评估价值
	String sGuarantyRegOrg = "";	//抵押物登记机构
	String sConfirmValue = "";		//我行确认价值
	double dGuarantyRate = 0;		//抵押率
	String sThirdParty3 = "";		//第三方共有人
	String sFlag1 = "";				//是否同意抵押
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
		
		sGuarantyDescribe2 = rs2.getString("GuarantyDescribe2");
		if(sGuarantyDescribe2 == null) sGuarantyDescribe2 = "";
		
		sGuarantyPrice = DataConvert.toMoney(rs2.getDouble("GuarantyPrice")/10000);
		
		dGuarantyAmount1 = rs2.getInt("GuarantyAmount");
		
		sEvalNetValue = DataConvert.toMoney(rs2.getDouble("EvalNetValue")/10000);
		
		sGuarantyRegOrg = rs2.getString("GuarantyRegOrg");
		if(sGuarantyRegOrg == null) sGuarantyRegOrg = "";
		
		sConfirmValue = DataConvert.toMoney(rs2.getDouble("ConfirmValue")/10000);
		
		dGuarantyRate = rs2.getDouble("GuarantyRate");
		
		sThirdParty3 = rs2.getString("ThirdParty3");
		if(sThirdParty3 == null ) sThirdParty3="";
		
		sFlag1 = rs2.getString("Flag1");
		if(sFlag1 == null) sFlag1 = "";
	}
	rs2.getStatement().close();
	
	//获得编号
	String sTreeNo = "";
	String sTreeNo1 = "";
	String[] sNo = null;
	String[] sNo2 = null;
	String[] sNo1 = null; 
	int iNo=1,i=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '07__' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo1 += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo2 = sTreeNo1.split(",");
	iNo = sNo2.length;
	
	int j=0; 
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '0720__' and ObjectType = '"+sObjectType+"'";
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
	sTemp.append("<form method='post' action='0720.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sNo1[j]+"、"+sTreeName+"</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=34% align=center class=td1 > 抵押物分类</td>");
	sTemp.append("   <td width=18% align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 抵押物编号 </td>");
	sTemp.append("   <td width=20% align=center class=td1 >"+sGuarantyID+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > 抵押物名称</td>");
	sTemp.append("   	<td colspan=3  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr align=left>");
  	sTemp.append("   <td align=center colspan=1 class=td1 > 抵押物详细描述 </td>");
	sTemp.append("   	<td colspan=3  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:25'",getUnitData("describe5",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=34% align=center class=td1 > 抵押物所有人</td>");
	sTemp.append("   <td width=18% align=center class=td1 >"+sOwnerName+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 是否同意抵押 </td>");
	sTemp.append("   <td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:25'",getUnitData("describe6",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr align=left>");
  	sTemp.append("   <td width=28% align=center class=td1 > 抵押物登记机构</td>");
	sTemp.append("   <td colspan=3 align=left class=td1  >"+sGuarantyRegOrg+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > 抵押物数量</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+dGuarantyAmount1+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 抵押物价值（万元） </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sEvalNetValue+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > 股权/股票发行价（元/股）</td>");
	sTemp.append("   <td width=22%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:25'",getUnitData("describe7",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 上年末每股净资产（元) </td>");
	sTemp.append("   <td width=22%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:25'",getUnitData("describe8",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > 每股最近一年均价（流通股，元/股）</td>");
	sTemp.append("   <td width=22%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("  &nbsp; </td>");
	sTemp.append("   <td width=28% align=center class=td1 > 最近一个交易日市价（流通股，元/股）</td>");
	sTemp.append("   <td width=22%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:25'",getUnitData("describe10",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > 我行确认价值(万元)</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sConfirmValue+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 抵押率(%)</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+dGuarantyRate+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >抵押物来源、出抵是否合法</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >抵押物的价格稳定性分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >抵押物变现能力分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
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
	editor_generate('describe3');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
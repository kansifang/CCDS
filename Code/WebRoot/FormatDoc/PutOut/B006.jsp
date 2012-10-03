<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:    xhyong 2010/06/30
		Tester:
		Content: 银行承兑汇票贴现报告的第0页
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
	//获得调查报告数据
	
	String sSql = "select ContractSerialNo,BP.CustomerID,BP.CustomerName,"+
				  " getBusinessName(BusinessType) as BusinessTypeName,"+
				  " getitemname('Currency',BusinessCurrency) as BusinessCurrency,"+
				  " BillNo,BusinessSum,PutOutDate,Maturity,getItemName('IntType',AcceptIntType),BillRisk,BusinessRate,"+
                  " PdgAccountNo,AccountNo,getItemName('BillResource',PdgPayMethod),FixCyc,getOrgName(OperateOrgID),DuebillSerialNo,getOrgName(AboutBankID3),"+
				  " CI.MFCustomerID,getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID,BP.ContractSum "+
				  " from BUSINESS_PUTOUT BP,CUSTOMER_INFO CI where SerialNo = '"+sObjectNo+"' and BP.CustomerID = CI.CustomerID";
	String sTempSql = "select FlowNo from FLOW_OBJECT where ObjectNo='"+sObjectNo+"' and ObjectType='PutOutApply'";
	String sFlowNo = "";
	String sContractSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessCurrency = "";
	String sBillNo = "";
	String sBusinessSum = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sAcceptIntType = "";
	String sBillRisk = "";
	String sBusinessRate = "";
	String sPdgAccountNo = "";
	String sAccountNo = "";
	String sPdgPayMethod = "";
	String sFixCyc = "";
	String sOperateOrgID = "";
	String sDuebillSerialNo = "";
	String sAboutBankID3Name = "";
	String sMFCustomerID = "";
	String sCertTypeName = "";
	String sCertID = "";
	String sContractSum = "";
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='6501.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if( sContractSerialNo==null) sContractSerialNo= "";
		
		sCustomerID = rs2.getString(2);
		if( sCustomerID==null) sCustomerID= "";
		
		sCustomerName = rs2.getString(3);
		if( sCustomerName==null) sCustomerName= "";
		
		sBusinessTypeName = rs2.getString(4);
		if( sBusinessTypeName==null) sBusinessTypeName= "";
		
		sBusinessCurrency = rs2.getString(5);
		if( sBusinessCurrency==null) sBusinessCurrency= "";
		
		sBillNo = rs2.getString(6);
		if( sBillNo==null) sBillNo= "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(7));
		
		sPutOutDate = rs2.getString(8);
		if( sPutOutDate==null) sPutOutDate= "";
		
		sMaturity = rs2.getString(9);
		if( sMaturity==null) sMaturity= "";
		
		sAcceptIntType = rs2.getString(10);
		if(sAcceptIntType == null) sAcceptIntType = "";
		
		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(6);
        nf.setMaximumFractionDigits(6);
		sBusinessRate = nf.format(rs2.getDouble(12));
		
		sBillRisk = nf.format(rs2.getDouble(11));
		
		sPdgAccountNo = rs2.getString(13);
		if(sPdgAccountNo == null) sPdgAccountNo = "";
		
		sAccountNo = rs2.getString(14);
		if(sAccountNo ==null) sAccountNo = "";
		
		sPdgPayMethod = rs2.getString(15);
		if(sPdgPayMethod == null) sPdgPayMethod = "";
		
		sFixCyc = rs2.getString(16);
		if (sFixCyc == null){ 
			sFixCyc = "";
		}else{
			sFixCyc = String.valueOf(Integer.parseInt(sFixCyc));
		}
		
		sOperateOrgID = rs2.getString(17);
		if(sOperateOrgID == null) sOperateOrgID = "";
		
		sDuebillSerialNo = rs2.getString(18);
		if(sDuebillSerialNo == null) sDuebillSerialNo = "";
		
		sAboutBankID3Name = rs2.getString(19);
		if(sAboutBankID3Name == null) sAboutBankID3Name = "";

		sMFCustomerID = rs2.getString("MFCustomerID");
		if(sMFCustomerID == null) sMFCustomerID = "";
		
		sCertTypeName = rs2.getString("CertTypeName");
		if(sCertTypeName == null) sCertTypeName = "";
		
		sCertID = rs2.getString("CertID");
		if(sCertID == null) sCertID="";			
		
		sContractSum = DataConvert.toMoney(rs2.getDouble("ContractSum"));
		ASResultSet rs1 = Sqlca.getResultSet(sTempSql);
		if(rs1.next())
		{
			sFlowNo = rs1.getString("FlowNo");
			if(sFlowNo == null) sFlowNo="";
		}
		rs1.close();
		
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=center colspan=4 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>授信业务通知书<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 > <u>&nbsp;&nbsp;"+sOperateOrgID+"&nbsp;&nbsp;</u>支行会计部门： </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u>（申请人）的授信业务:<u>&nbsp;&nbsp;"+sBusinessTypeName+"&nbsp;&nbsp;</u><br>已经按我行业务审批程序报经有权审批人审批同意，并通过风险管控(理)部审核，请你部按照本通知书要求，办理记账手续：	   </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 > 合同流水号</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >出账流水号</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >核心客户号</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sMFCustomerID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >客户名称</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >证件类型</td>");
		sTemp.append("   <td align=left class=td1 >"+sCertTypeName+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >证件号码</td>");
		sTemp.append("   <td align=left class=td1 >"+sCertID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >币种</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessCurrency+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >贴现金额(元)</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >起始日</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >贴现利率（%）</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >到期日</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >结算帐号</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >&nbsp;</td>");	
		sTemp.append("   </tr>");
		if("SmallPutOutFlow".equals(sFlowNo))
		{
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=4 class=td1 >  放款审核员：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;主管负责人签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p>&nbsp;</p> </td>");
			sTemp.append("   </tr>");
		}else{
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=4 class=td1 > 风险管控(理)部审核员：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;风险管控(理)部负责人:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p>&nbsp;</p> </td>");
			sTemp.append("   </tr>");
		}
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=4 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>部门公章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> 日期："+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >（此通知书共三联，交客户经理、会计和文档管理员各一份）</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
	    
	}
	
	rs2.getStatement().close();		
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

<%@include file="/FormatDoc/IncludePOFooter.jsp"%>

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


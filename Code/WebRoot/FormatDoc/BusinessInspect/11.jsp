<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:    zwhu  2010.04.15
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
	int iDescribeCount = 3;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
    String sSql = "";
    ASResultSet rs = null;
	double dCount = Sqlca.getDouble(" select count(*) from INSPECT_INFO  where SerialNo='"+sSerialNo+"' and ObjectNO='"+sObjectNo+"'"+
		   							" and ObjectType='"+sObjectType+"' and HtmlData is not null");
	if(dCount == 0){
		sData[2][0] = "describe2";
		sData[2][1] = "1、确保所有手续合法、齐全、有效。<br/> 2、上述条件落实后，须经贵行风险管理部审核，有权签字人签字后方可放款。";
	}
	String sCustomerID = "";
	String sInputOrgName = "";
	String sCustomerName = "";
	String sBusinessSum = "";
    int iTermMonth = 0;
    double dBusinessRate = 0.0;
    String sBusinessTypeName = "";
    String sVouchTypeName = "";
    String sFinalBusinessSum = "";
    int iFinalTermMonth = 0;
    double dFinalbusinessRate = 0.0;   
    String sPurpose = "";
    String sTotalBalance = "";
    String sFinalBusinessCurrencyName = "";
    
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
	
	sTotalBalance = DataConvert.toMoney(Sqlca.getDouble(" select sum(nvl(Balance,0)*getERate(BusinessCurrency,'01',ERateDate)) "+
														" from Business_Contract where CustomerID = '"+sCustomerID+"'")); 
	if(sTotalBalance == null) sTotalBalance = "";
	
	String sFinalOpinionSerialNo = Sqlca.getString(" select RelativeSerialNo from flow_task where ObjectNo = '"+sObjectNo+"' and "+
			   									   " ObjectType = '"+sObjectType+"' and PhaseNo ='1000'");	
	if(sFinalOpinionSerialNo == null) sFinalOpinionSerialNo = "";		   									   	
	String sApproveTime = Sqlca.getString(" select EndTime from Flow_Task where SerialNo = '"+sFinalOpinionSerialNo+"'");	
	if(sApproveTime == null) sApproveTime = "";   									   
	sSql = " select getItemName('Currency',BusinessCurrency) as BusinessCurrencyName ,"+
		   " nvl(BusinessSum,0)*getERate(BusinessCurrency,'01','') as BusinessSum,"+
		   " TermMonth,BusinessRate from Flow_Opinion where SerialNo = '"+sFinalOpinionSerialNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sFinalBusinessCurrencyName = rs.getString("BusinessCurrencyName");
		if(sFinalBusinessCurrencyName == null) sFinalBusinessCurrencyName = "";
		sFinalBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
		iFinalTermMonth = rs.getInt("TermMonth");
		dFinalbusinessRate = rs.getDouble("BusinessRate");
	}
	rs.getStatement().close();	   		   									   											
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='11.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 bgcolor=#aaaaaa height=40px><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >天津农商银行授信业务批复</font></td>"); 	
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
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>有权审批人于"+sApproveTime+" 批准，批复如下： </td>");
    sTemp.append("   </tr>");   
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>□ 授信条件：</td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >授信品种：</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >币种：</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >金额（万元）：</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >期限（月）：</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >利率（‰）：</td>");	
    sTemp.append("   </tr>"); 
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+sFinalBusinessCurrencyName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+sFinalBusinessSum+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+iFinalTermMonth+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+dFinalbusinessRate+"&nbsp;</td>");
    sTemp.append("   </tr>");         
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>□ 授信用途： </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:50%'",getUnitData("describe1",sData)));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>□ 现有系统内授信余额： </td>");
    sTemp.append("   </tr>");
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>"+sTotalBalance+"&nbsp;</td>");
    sTemp.append("   </tr>");    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>□ 担保方式：</td>");
    sTemp.append("   </tr>");
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>"+sVouchTypeName+"&nbsp;</td>");
    sTemp.append("   </tr>");    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>□ 在进行授信前，必须确保落实以下条件： </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>□ 要求：</td>");
    sTemp.append("   </tr>");   
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
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
	editor_generate('describe2');		//需要html编辑,input是没必要
	editor_generate('describe3');		//需要html编辑,input是没必要	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
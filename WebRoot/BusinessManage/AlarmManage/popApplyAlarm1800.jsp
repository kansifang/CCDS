<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2010-4-7 
 * Tester:
 *
 * Content: 
 *        “金融机构融资金额”加上“本次申请授信”占“总投资额”的比例不能超过50%
 *           
 * Input Param:
 *      altsce:			从Session中抓取预警对象
 *      sModelNo:		从requst中获取当前处理的模型编号
 *      
 * Output param:
 *      ReturnValue:    预警检查处理通过否，用'$'分割，前两位数字处理方式编号，后提示字符串
 * History Log:
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ page  import="com.amarsoft.script.AmarInterpreter,com.amarsoft.script.Anything"  buffer="64kb"  %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//定义参数
	String sResult="",sSerialNo="";
	String sTip="校验通过！";
	String sDealMethod="99";
	StringBuffer sbTips = new StringBuffer("");			
	ASResultSet rs = null;ASResultSet rs1 = null;
	String sCustomerID="",sRelativeID = "",sAccountMonth="";
	String sSql="",sSql1="";
	double dBusinessSum =0.0 ,dTotalSum =0.0,dPlanTotalCast = 0.0;
	//获得参数
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//风险提示	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$模型编号未指定！";
		else{
		    sCustomerID = altsce.getArgValue("CustomerID");	//客户编号
			String sApplySerialNo = altsce.getArgValue("ApplySerialNo");
		  
		   dBusinessSum = Sqlca.getDouble("select nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum from Business_Apply where SerialNo ='"+sApplySerialNo+"'").doubleValue();
		    
		  //金融机构融资金额总额
		   sSql =  " SELECT I.ProjectNo as ProjectNo, nvl(I.PlanTotalCast,0)*10000 as PlanTotalCast FROM PROJECT_RELATIVE R, PROJECT_INFO I WHERE R.objecttype = 'CreditApply' AND R.ObjectNo = '"+sApplySerialNo+"' "+
   				   "AND I.ProjectNo = R.ProjectNo ORDER BY R.ProjectNo  fetch first 1 rows only ";
		   rs = Sqlca.getASResultSet(sSql);
		   if(rs.next())
		   {
			   sRelativeID = rs.getString("ProjectNo");
			   dPlanTotalCast = rs.getDouble("PlanTotalCast");
			   if(sRelativeID == null) sRelativeID="";
			   sSql = " select sum(nvl(nvl(InverstBalance,0)*getERate(Currency,'01',''),0)) as InvestTotalSum from PROJECT_FUNDS "+
				      " where ProjectNo = '"+sRelativeID+"' "+
				      " and FundSource = '03' ";
			   rs1 = Sqlca.getASResultSet(sSql);
			   if(rs1.next())
			   {
			   		dTotalSum = rs1.getDouble(1);
		       }
		       rs1.getStatement().close();
		       
		       if(dBusinessSum+dTotalSum > dPlanTotalCast*0.5)
		       {
		    	   sDealMethod = "10";
				   sbTips.append("“金融机构融资余额”加上“本次申请授信”占“总投资额”的比例不能超过50%!"+"\r\n");
		       }
			   
		   }
		   rs.getStatement().close();
			
		}
		if( sbTips.length() > 0 )
		{
			//sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
			sTip = SpecialTools.real2Amarsoft(sbTips.toString());	
		}
		//记录日志
		//根据返回结果，判断成功与否，并根据DealMethod判断是否处理
		altsce.writeAlarmLog(sModelNo,sTip,sDealMethod,Sqlca);
		
		//设置返回值
		sResult = sDealMethod+"$"+sTip;
		
	}catch(Exception ea){
		ea.printStackTrace();
		sResult="10$"+ea.getMessage();
	}
%>
<html>
<head>
</head>
<body onkeydown=mykd1 >
	<iframe name="myprint10" width=0% height=0% style="display:none" frameborder=1></iframe>
</body>
</html>

<script language=javascript >
	self.returnValue = "<%=sResult%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>

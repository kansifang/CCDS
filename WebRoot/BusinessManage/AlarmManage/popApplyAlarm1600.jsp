<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2009-8-19 
 * Tester:
 *
 * Content: 
 *        单户余额+本笔≦授信风险限额
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
	double dBusinessSum =0.0 ,dTotalSum =0.0,dRiskSum = 0.0;
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
		   // AmarInterpreter interpreter = new AmarInterpreter();
		   dBusinessSum = Sqlca.getDouble("select nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum from Business_Apply where SerialNo ='"+sApplySerialNo+"'").doubleValue();
		    
		  //全行范围内业务余额
			sSql = 	" select sum(nvl(nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate),0)) as Balance from BUSINESS_CONTRACT "+
					" where CustomerID = '"+sCustomerID+"' "+
					" and BusinessType not like '3%' "+
					" and (FinishDate is null "+
					" or FinishDate = '') ";	
		  
		    rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
			    dTotalSum = rs.getDouble(1);
		    }
		    rs.getStatement().close();
			
			
			//风险限额
			sSql1 = " select CognScore from EVALUATE_RECORD R,EVALUATE_CATALOG C "+
			       " where ObjectType = 'CustomerLimit' and ObjectNo = '"+sCustomerID+"'  and R.ModelNo = C.ModelNo  and C.ModelType='080' "+
			       " order by AccountMonth DESC  fetch first 1 rows only";
		    rs = Sqlca.getASResultSet(sSql1);
		    if(rs.next())
	        {
	     	   dRiskSum = rs.getDouble(1)*10000;
	     	   if(dRiskSum < dTotalSum+dBusinessSum)
				 {
					sDealMethod = "10";
					sbTips.append("单户余额+本笔金额超过授信风险限额!"+"\r\n");
				 }else
				 {
					sDealMethod = "99";
					sbTips.append("校验通过！");
				 }
	        }else
	        {
	        	sDealMethod = "10";
				sbTips.append("未对该客户进行授信风险限额测算!"+"\r\n");
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

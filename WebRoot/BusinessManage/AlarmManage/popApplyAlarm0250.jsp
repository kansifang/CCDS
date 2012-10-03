<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2009-8-19 
 * Tester:
 *
 * Content: 
 *         申请检查之风险度评估信息
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
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//定义参数
	String sResult="";
	String sTip="校验通过！";
	String sDealMethod="99";
	StringBuffer sbTips = new StringBuffer("");			
	ASResultSet rs = null;
	double dRiskEvaluate = 0.0;
	//获得参数
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//风险提示	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$模型编号未指定！";
		else{
			//获得参数
			String sSerialNo = altsce.getArgValue("SerialNo");	//申请编号
			//查询风险度
			String sSql = " select RiskEvaluate from Risk_Evaluate where ObjectNo = '"+sSerialNo+"' and ObjectType ='CreditApply' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dRiskEvaluate = rs.getDouble("RiskEvaluate");
				sbTips.append("该笔业务进行风险度为："+dRiskEvaluate+"\r\n");
				sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
				sTip = SpecialTools.real2Amarsoft(sbTips.toString());	
				if( sbTips.length() > 0 )
				{
					sDealMethod = "81";
					sTip = SpecialTools.real2Amarsoft(sbTips.toString());	
				}
				
			}else
			{
				sbTips.append("没有对该笔业务进行风险度评估！"+"\r\n");
				if( sbTips.length() > 0 )
				{
					sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
					sTip = SpecialTools.real2Amarsoft(sbTips.toString());	
				}
			}
			rs.getStatement().close();
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

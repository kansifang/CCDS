<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: xhyong 2011/09/30
 * Tester:
 *
 * Content: 
 *          预警处理-申请－2000-借款人是否存在预警信号
 *           
 * Input Param:
 *      altsce:			从Session中抓取预警对象
 *      sModelNo:		从requst中获取当前处理的模型编号
 *      
 * Output param:
 *      ReturnValue:    预警检查处理通过否，用'$'分割，前两位数字处理方式编号，后提示字符串
 * History Log:  mjliu 2011-2-16 关闭风险度探测，将其单独作为一个大项
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%
	//定义变量
	String sResult="";
	String sTip="校验通过！";
	String sDealMethod="99";
	String sSql = "";//查询语句
	StringBuffer sbTips = new StringBuffer("");	
	String sAuditDate = "";
	String sEvalDate = "";
	String sEffectStartDate ="";
	String sEffectFinishDate = "";
	String sAuditOrgType = "";
	String sExistFlag = "";
	Date AuditDate=null;
	Date EvalDate=null;
	Date EffectStartDate=null;
	Date EffectFinishDate=null;
	int iCount=0;
	int iCount1=0;
	SimpleDateFormat dd;
	ASResultSet rs = null;
	//获得参数
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//风险提示	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
		{
			sResult = "10$模型编号未指定！";
		}else{
			//获得参数
			String sCustomerID = altsce.getArgValue("CustomerID");	//客户编号
			if (sCustomerID == null) sCustomerID = "";
			
			//查询是否存在该预警信号
			sSql = "select 1  " +
					" from Risk_Signal RS"+
					" where ObjectNo = '"+sCustomerID+"' "+
					" and SignalType='01' "+//发起
					" and not exists(select 1 from Risk_Signal where RelativeSerialNo=RS.SerialNo ) ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sExistFlag="01";//只存在解除并通过的预警
			}
			rs.getStatement().close();
			
			//如果不存在发起的信号则检查是否有解除的信号
			sSql = "select 1  " +
				" from Risk_Signal "+
				" where ObjectNo = '"+sCustomerID+"' "+
				" and SignalType='02' "+//解除
				" and SignalStatus<>'30' ";//已批准
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()&&!"01".equals(sExistFlag))
			{
				sExistFlag="01";//只存在解除并通过的预警
			}
			rs.getStatement().close();
			
			if("01".equals(sExistFlag))
			{
				sbTips.append("该客户存在预警信号;\n\r");
			}
			//设置参数
			//altsce.setArgValue("CustomerID",sCustomerID);			
		}							
			//记录日志
			//根据返回结果，判断成功与否，并根据DealMethod判断是否处理
			if( sbTips.length() > 0 ){
				sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
				sTip = SpecialTools.real2Amarsoft(sbTips.toString());
			}
						
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

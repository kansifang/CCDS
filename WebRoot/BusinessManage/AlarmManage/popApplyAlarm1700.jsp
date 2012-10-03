<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2010-4-7 
 * Tester:
 *
 * Content: 
 *      对于借款人为房地产开发企业的，则其资质应为二级及以上（或相当等级），若借款人资质低于二级，则蓝字进行提示
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
	String sSql="",sSql1="",sLevelInfo="";
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
		   
		   sLevelInfo = Sqlca.getString("SELECT  LevelInfo FROM ENT_REALTYAUTH  WHERE CustomerID = '"+sCustomerID+"' order by UptoDate desc fetch first 1 rows only ");
		   if(sLevelInfo == null) sLevelInfo ="";
		   
		   if(sLevelInfo.equals(""))
		   {
			   sDealMethod = "81";
			   sbTips.append("该客户没有录入房地产资质情况!"+"\r\n");
		   }else{
			   if(sLevelInfo.compareTo("030")>0)
			   {
				   sDealMethod = "81";
				   sbTips.append("该客户房地产资质低于二级!"+"\r\n");
			   }
		   }
		   
		   
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

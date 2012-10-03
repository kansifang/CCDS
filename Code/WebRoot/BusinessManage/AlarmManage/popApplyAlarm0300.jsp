<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-申请－0300－申请人多头贷款检查
 *           
 * Input Param:
 *      altsce:			从Session中抓取预警对象
 *      sModelNo:		从requst中获取当前处理的模型编号
 *      
 * Output param:
 *      ReturnValue:    预警检查处理通过否，用'$'分割，前两位数字处理方式编号，后提示字符串
 * History Log:  
 *		zywei 2007/10/10 将金额展现形式改为三位一逗
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//定义参数
	String sResult="";
	String sTip="校验通过！";
	String sDealMethod="99";
	String sCount="";
	String sSql="";		
	StringBuffer sbTips = new StringBuffer("");		
	ASResultSet rs=null;
	//获得参数	自己按需要获取
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//风险提示	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$模型编号未指定！";
		else{
			//获得参数
			String sCustomerID = altsce.getArgValue("CustomerID");
			String OperateOrgID = altsce.getArgValue("OperateOrgID");
			
			sCount = Sqlca.getString("select count(SerialNo) "+
					" from BUSINESS_CONTRACT "+
					" where CustomerID = '"+sCustomerID+"' "+
					" and (FinishDate is null or FinishDate='') " +
					" and  ((Maturity >='"+StringFunction.getToday()+"' and BusinessType like '3%')" +
					" or BusinessType not like '3%') "+
					" and ManageOrgid<>'"+OperateOrgID+"' "+
					" and ManageOrgid <> '918010100' "+
					" having count(distinct ManageOrgID)>0");
			if( sCount != null && Integer.parseInt(sCount,10) > 0 )
			{			
				sbTips.append("该申请人在本行存在交叉贷款信息；\n\r");
				sSql = 	" select getOrgName(ManageOrgID) as ManageOrgName, "+
						" sum(BusinessSum*getERate(BusinessCurrency,'01',ERateDate)) as BusinessSum, "+
						" sum(Balance*getERate(BusinessCurrency,'01',ERateDate)) as BalanceSum "+
						" from BUSINESS_CONTRACT "+
						" where CustomerID = '"+sCustomerID+"' "+
						" and ManageOrgID<>'"+OperateOrgID+"' "+
						" and (FinishDate is null or FinishDate='') " +
						" and ((Maturity >='"+StringFunction.getToday()+"' and BusinessType like '3%')" +//额度
						" or BusinessType not like '3%')"+//非额度
						" group by ManageOrgID ";
				rs = Sqlca.getResultSet(sSql);
				while(rs.next())
				{
					String sManageOrgName = rs.getString("ManageOrgName");
					String sBusinessSum = rs.getString("BusinessSum");
					String sBalanceSum = rs.getString("BalanceSum");
					if(sManageOrgName == null) sManageOrgName = "";
					if(sBusinessSum == null) sBusinessSum = "0.00";
					if(sBalanceSum == null) sBalanceSum = "0.00";
					sbTips.append("在["+sManageOrgName+"]机构内未结清的授信业务发放总金额（折人民币）："+DataConvert.toMoney(sBusinessSum)+";\n\r");
					sbTips.append("在["+sManageOrgName+"]机构内未结清的授信业务总余额（折人民币）："+DataConvert.toMoney(sBalanceSum)+";\n\r");
				}
				rs.getStatement().close();
			}
			
			//根据返回结果，判断成功与否，并根据DealMethod判断是否处理
			if( sbTips.length() > 0 ){
				sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
				sTip = SpecialTools.real2Amarsoft(sbTips.toString());
			}						
			altsce.writeAlarmLog(sModelNo,sTip,sDealMethod,Sqlca);
			
			//设置返回值
			sResult = sDealMethod+"$"+sTip;
		}
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
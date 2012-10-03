<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2009-8-19 
 * Tester:
 *
 * Content: 
 *         对紧凑型集团,(本笔申请风险总量＋集团授信风险总量）≥集团授信风险限额
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
	double dReturn =0.0 ,dTotalSum =0.0,dRiskSum = 0.0,dEvaluateScore=0.0;
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
		    
		    AmarInterpreter interpreter = new AmarInterpreter();
		    
			String JTCustomerID ="",sGroupOwnType="";
			String sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
				          " and RelationShip ='0401' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				JTCustomerID = rs.getString("CustomerID");
				if(JTCustomerID == null) JTCustomerID ="";
			}
			rs.getStatement().close();
			//集团类型
			sGroupOwnType = Sqlca.getString("select GroupType  from ENT_INFO where CustomerID ='"+JTCustomerID+"'");
			if(sGroupOwnType==null) sGroupOwnType="";
			
			if(!JTCustomerID.equals("") && sGroupOwnType.equals("010"))//属于紧凑型集团
			{
				//集团授信风险限额
				sSql = " select EvaluateScore,AccountMonth from EVALUATE_RECORD where "+
					   " ObjectType ='CustomerLimit' and ObjectNo ='"+sCustomerID+"' order by SerialNo desc " +
					   " fetch first 1 rows only";
				
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					//最近一期风险授信限额
					dEvaluateScore = rs.getDouble("EvaluateScore");
					sAccountMonth = rs.getString("AccountMonth");//会计月份
				
					//集团成员
					sSql ="select RelativeID from Customer_Relative where CustomerID = "+
						 "(select CustomerID from Customer_Relative where RelativeID = '"+sCustomerID+"' and RelationShip ='0401') and  RelationShip ='0401'";
					rs1 = Sqlca.getASResultSet(sSql);
					while(rs1.next())
					{
						sRelativeID = rs1.getString("RelativeID");
						Anything aReturn =  interpreter.explain(Sqlca,"!CustomerManage.ComputeRiskGross("+sRelativeID+")");
						dReturn = aReturn.doubleValue();
						dTotalSum += dReturn;//集团授信风险总量
					}
					rs1.getStatement().close();
				
					//本笔授信风险总量
					Anything aReturn1 =  interpreter.explain(Sqlca,"!风险智能检测.本笔申请风险总量("+sSerialNo+")");
					dRiskSum = aReturn1.doubleValue();
					//本笔申请风险总量＋集团授信风险总量
					dTotalSum =dTotalSum+dRiskSum;
					
					if(dTotalSum>dEvaluateScore)
					{
						sDealMethod = "10";
						sbTips.append("超过集团授信风险限额！（集团授信风险限额会计月份为："+sAccountMonth+"）"+"\r\n");
					}else
					{
						sDealMethod = "99";
						sbTips.append("校验通过！（集团授信风险限额会计月份为："+sAccountMonth+"）"+"\r\n");
					}
					
				}else
				{
					sDealMethod = "10";
					sbTips.append("没有对该集团授信风险限额进行测算！"+"\r\n");
				}
				rs.getStatement().close();
				
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

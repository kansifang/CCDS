<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2009-12-24
 * Tester:
 *
 * Content: 
 *        保易贷抵质押检查
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
	ASResultSet rs = null,rs1 = null;
	String sOperateOrgID ="",sCustomerID="",sApplySerialNo="",sSql="",sSql1="",sSql2 ="",sBusinessType="";
	double iNum =0.0;
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
		    sApplySerialNo = altsce.getArgValue("SerialNo");//业务申请编号
		    sBusinessType = altsce.getArgValue("BusinessType");//业务品种
		    
		    double dBusinessSum=0.0,dGuarantyContractTotalSum =0.0,dGuarantyContractSum=0.0,dGuarantyTotalSum=0.0,dBailSum =0.0,dYCBailSum=0.0;
		    String sGuarantyContractNo = "",sGuarantyType="";
		    sSql ="select NVL(BusinessSum*getERate(BusinessCurrency,'01',ERateDate),0) as BusinessSum, NVL(BailSum*getERate(BusinessCurrency,'01',ERateDate),0) as BailSum from Business_Apply where SerialNo='"+sApplySerialNo+"'";
		    rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	dBusinessSum = rs.getDouble(1);
		    	dBailSum = rs.getDouble(2);
		    }
		    rs.getStatement().close();
		    if(sBusinessType.equals("3010"))//公司综合授信下的银行承兑汇票
		    {
		    	sSql ="select nvl((LineSum1*getERate(Currency,'01',ERateDate)),0)*nvl(BailRatio,0)/100  from CL_INFO  where ApplySerialNo ='"+sApplySerialNo+"' and  ParentLineID is not null and ParentLineID<>'' and BusinessType='2010'";
		    	rs = Sqlca.getASResultSet(sSql);
			    if(rs.next())
			    {
			    	dYCBailSum = rs.getDouble(1);
			    }
			    rs.getStatement().close();
		    }
		    
		    sSql = "select  BR.ObjectNo as GuarantyContractNo from BUSINESS_APPLY BA,APPLY_RELATIVE BR where BA.SerialNo = BR.SerialNo and  BR.ObjectType ='GuarantyContract' and BR.SerialNo='"+sApplySerialNo+"'";
		    rs = Sqlca.getASResultSet(sSql);
		    while(rs.next())
		    {
		    	sGuarantyContractNo = rs.getString("GuarantyContractNo");//担保合同号
		    	sSql1 = "select NVL(GuarantyValue*getERate(GuarantyCurrency,'01',''),0) as GuarantyContractSum,GuarantyType from GUARANTY_CONTRACT where SerialNo='"+sGuarantyContractNo+"'";
		    	rs1=Sqlca.getASResultSet(sSql1);
		    	if(rs1.next())
		    	{
		    		dGuarantyContractSum = rs1.getDouble("GuarantyContractSum");//担保合同总金额
		    		sGuarantyType = rs1.getString("GuarantyType");//担保合同类型
		    		System.out.println("dGuarantyContractSum:"+dGuarantyContractSum);
		    		if(sGuarantyType == null) sGuarantyType ="";
		    		if("060".equals(sGuarantyType))
		    		{
		    			sSql2 = " select Sum(NVL(GI.ConfirmValue*getERate(GI.EvalCurrency,'01',''),0)) as GuarantyTotalSum from Guaranty_Info GI,Guaranty_Relative GR "+
		    					" where GR.GuarantyID = GI.GuarantyID and GR.ObjectType='CreditApply' and GR.ContractNo = '"+sGuarantyContractNo+"' ";
		    			dGuarantyTotalSum = Sqlca.getDouble(sSql2).doubleValue();//质押物合同下押品总金额。
		    			if(dGuarantyTotalSum<dGuarantyContractSum){
		    				sbTips.append("质押物详情中质押物总金额["+DataConvert.toMoney(dGuarantyTotalSum)+"元]不应小于质押合同担保总金额["+DataConvert.toMoney(dGuarantyContractSum)+"元]!"+"\r\n");
		    			}
		    			
		    		}
		    		dGuarantyContractTotalSum = dGuarantyContractTotalSum+dGuarantyContractSum;//担保总金额之和
		    	}
		    	rs1.getStatement().close();
		    }
		    
		    rs.getStatement().close();
		    if(dGuarantyContractTotalSum < (dBusinessSum-dBailSum-dYCBailSum)){
		    	sbTips.append("担保总金额["+DataConvert.toMoney(dGuarantyContractTotalSum)+"元]不应小于（贷款金额-保证金）["+DataConvert.toMoney(dBusinessSum-dBailSum-dYCBailSum)+"元]!"+"\r\n");
		    }
		}
		if( sbTips.length() > 0 )
		{
			sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
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

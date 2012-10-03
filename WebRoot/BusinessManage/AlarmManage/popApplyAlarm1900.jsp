<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-申请－1900－财务报表评估机构是否在有效期
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
			String sApplySerialNo = altsce.getArgValue("ApplySerialNo");//申请流水号
			if (sCustomerID == null) sCustomerID = "";
			if (sApplySerialNo == null) sApplySerialNo = "";
			
			//财务报表评估机构有效性验证
			sSql = "select CF.AuditDate as AuditDate,CS.EffectStartDate AS EffectStartDate,CS.EffectFinishDate AS EffectFinishDate,CF.AuditOffice,CF.ReportDate AS ReportDate from CUSTOMER_SPECIAL CS, CUSTOMER_FSRECORD CF where CS.CustomerName=CF.AuditOffice  and AuditFlag='2' and CS.SectionType='60' and CF.CustomerID = '"+sCustomerID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next() && iCount<1)
			{
				sAuditDate = rs.getString("AuditDate");
				sEffectStartDate = rs.getString("EffectStartDate");
				sEffectFinishDate = rs.getString("EffectFinishDate");	
				dd=new SimpleDateFormat("yyyy/MM/dd");
				if(sAuditDate==null)
				{
					sbTips.append("财务报表选择了已不在有效期之内的中介机构;或者财务报表说明未填写完整;\n\r");
					iCount++;
				}else if(sEffectStartDate!=null && sEffectFinishDate!=null)
				{	
					AuditDate=dd.parse(sAuditDate);
					EffectStartDate=dd.parse(sEffectStartDate);
					EffectFinishDate=dd.parse(sEffectFinishDate);
					if(AuditDate.after(EffectFinishDate)||AuditDate.before(EffectStartDate))
					{
						sbTips.append("财务报表选择了已不在有效期之内的中介机构;或者财务报表说明未填写完整;\n\r");
						iCount++;
					}
				}	
			}
			rs.getStatement().close();
			
			//抵质押评估机构有效性验证
			sSql = "select GI.EvalDate as EvalDate,CS.EffectStartDate AS EffectStartDate,"+
					" CS.EffectFinishDate AS EffectFinishDate  "+
					" from GUARANTY_RELATIVE GR,GUARANTY_INFO GI,CUSTOMER_SPECIAL CS  "+
					" where GR.GuarantyID=GI.GuarantyID  and GR.ObjectType='CreditApply' "+
					" and GI.EvalOrgName=CS.CustomerName and GR.ObjectNo='"+sApplySerialNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next() && iCount1<1)
			{
				sEvalDate = rs.getString("EvalDate");
				sEffectStartDate = rs.getString("EffectStartDate");
				sEffectFinishDate = rs.getString("EffectFinishDate");	
				dd=new SimpleDateFormat("yyyy/MM/dd");
				if(sEffectStartDate!=null && sEffectFinishDate!=null && sEvalDate!=null)
				{	
					EvalDate=dd.parse(sEvalDate);
					EffectStartDate=dd.parse(sEffectStartDate);
					EffectFinishDate=dd.parse(sEffectFinishDate);
					if(EvalDate.after(EffectFinishDate)||EvalDate.before(EffectStartDate))
					{
						sbTips.append("抵质押物选择了已不在有效期之内的中介机构;\n\r");
						iCount1++;
					}
				}	
			}
			rs.getStatement().close();
		}	
			
			//设置参数
			//altsce.setArgValue("CustomerID",sCustomerID);			
									
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

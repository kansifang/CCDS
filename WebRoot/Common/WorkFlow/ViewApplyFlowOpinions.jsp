<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: byhu 2004.12.21
 * Tester:
 *
 * Content: 查看审批详情
 * Input Param:
 *      ObjectType: 对象类型
 *          CreditApply: 申请
 *          ApproveApply: 最终审批意见
 *          PutOutApply:  出帐
 *      ObjectNo:   对象编号
 *		FlowNo：流程号
 *		PhaseNo：阶段号
 		IsPrintFlag:打印标识:true false
 * Output param:
 *
 * History Log:  lpzhang 增加信用等级评估认定信息 2009-8-25 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//获取页面参数
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
    String sObjectNo= DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sCurFlowNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("FlowNo"));
	String sCurPhaseNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("PhaseNo"));
	String sIsPrintFlag = DataConvert.toRealString(iPostChange,CurPage.getParameter("IsPrintFlag"));
	//将空值转化为空字符串
	if(sObjectType==null)sObjectType="";
	if(sObjectNo==null)sObjectNo="";
	if(sCurFlowNo==null)sCurFlowNo="";
	if(sCurPhaseNo==null)sCurPhaseNo="";
	if(sIsPrintFlag==null)sIsPrintFlag="";
	
    String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sTempPrivilegePhases="",sPhaseAction="";
	boolean bRolePrivilege = false; //哪些阶段能看
	boolean bPhasePrivilege = false;//
	boolean bPhaseMatch = false;//判断当前意见所处阶段是否在对应的特权阶段
	
	String sFinalFlowNo = "";//最终阶段
	String sFinalRelativeSerialNo = "";//最终审批阶段管理流水号
	String sFinalUserID = "";//最终审批人
	String sFlowNo = ""; 
	String FOPhaseChoice = "";
	String sSelfOpinionPhase = "";
	String sSelfOpinion = "";
	String sPhaseName = "";
	String sUserName = "";
	String sOrgName = "";
	String sBeginTime = "";
	String sEndTime = "";
	String sCustomerName = "";
	String sApplyCustomerName = "";
	String sBusinessCurrencyName = "";
	String sRateFloatTypeName = "";
	String sCognResult = "";
	String sBusinessTypeName = "";
	String sOccurTypeName = "";
	String sVouchTypeName = "";
	double dBusinessSum = 0.0;
	double dBaseRate = 0.0;
	double dRateFloat = 0.0;
	double dBusinessRate = 0.0;
	double dBailSum = 0.0;
	double dBailRatio = 0.0;
	double dPdgRatio = 0.0;
	double dPdgSum = 0.0;
	int iTermYear = 0;
	int iTermMonth = 0;
	int iTermDay = 0;
	int iCountRecord=0;//用于判断记录是否有审批意见
	int iRow=0,jRow=0;//用于标记行数
	String sReportType = "";
	double dCount = 0;
	ASResultSet rs = null;
	
	sSql =  " select getBusinessName(BusinessType) as BusinessTypeName,"+
			"CustomerName,getItemName('OccurType',OccurType) as OccurTypeName,"+
			"getItemName('VouchType',VouchType) as VouchTypeName "+
		" from BUSINESS_APPLY where SerialNo='"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sBusinessTypeName = DataConvert.toString(rs.getString("BusinessTypeName"));
		sApplyCustomerName = DataConvert.toString(rs.getString("CustomerName"));
		sOccurTypeName = DataConvert.toString(rs.getString("OccurTypeName"));
		sVouchTypeName = DataConvert.toString(rs.getString("VouchTypeName"));
	}
	rs.getStatement().close();
	
	if("CreditApply".equals(sObjectType) && CurUser.hasRole("0B3")){
		sSql = " select Phaseno,RelativeSerialno from flow_task "+
			   " where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"' and (PhaseNo ='1000' or PhaseNo ='8000')";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sFinalFlowNo = rs.getString("Phaseno");
			if(sFinalFlowNo == null) sFinalFlowNo = "";
			sFinalRelativeSerialNo = rs.getString("RelativeSerialno");
			if(sFinalRelativeSerialNo == null) sFinalRelativeSerialNo = "";
		}	   
		rs.getStatement().close();
		if(!"".equals(sFinalRelativeSerialNo))
			sFinalUserID = Sqlca.getString("select Userid from Flow_task where SerialNo = '"+sFinalRelativeSerialNo+"'");
		if(sFinalUserID == null) sFinalUserID = "";
		dCount = Sqlca.getDouble("select count(*) from User_Role where UserID = '"+sFinalUserID+"' and (RoleID = '012' or RoleID = '0B1')");
		if(dCount>0 && "1000".equals(sFinalFlowNo)){
			sReportType = "11";
		}else if(dCount>0 && "8000".equals(sFinalFlowNo)){
			sReportType = "12";
		}
		if(dCount == 0){
			dCount = Sqlca.getDouble("select count(*) from User_Role where UserID = '"+sFinalUserID+"' and RoleID = '010'");
			if(dCount>0 && "1000".equals(sFinalFlowNo)){
			sReportType = "13";
			}else if(dCount>0 && "8000".equals(sFinalFlowNo)){
				sReportType = "14";
			}
		}
	
	}
	//获取仅查看自己签署的意见所对应的阶段
	sSql = 	" select Attribute6 from FLOW_MODEL "+
			" where FlowNo = '"+sCurFlowNo+"' "+
			" and PhaseNo = '"+sCurPhaseNo+"' ";
	sSelfOpinionPhase = Sqlca.getString(sSql);
	if(sSelfOpinionPhase == null) sSelfOpinionPhase = "";
	//获取仅查看自己签署的意见信息
	if(!sSelfOpinionPhase.equals(""))
	{
		sSql =  " select FO.CustomerName,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName, "+
				" FO.BusinessSum,FO.TermYear,FO.TermMonth,FO.TermDay,FO.BaseRate,FO.RateFloat,FO.BusinessRate, "+
				" getItemName('RateFloatType',FO.RateFloatType) as RateFloatTypeName,FO.BailSum,FO.BailRatio, getItemName('PhaseChoice',FO.PhaseChoice) as FOPhaseChoice,"+
				" FO.SystemScore as SystemScore,FO.SystemResult as SystemResult,"+//系统评估得分，系统评估结果
	 			" FO.CognScore as CognScore,FO.CognResult as CognResult,"+//人工评分，人工评定结果
				" FO.PdgRatio,FO.PdgSum,FO.PhaseOpinion,FT.PhaseName,FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime "+
				" from FLOW_TASK FT,FLOW_OPINION FO "+
				" where FT.Serialno=FO.SerialNo "+				
				" and (FO.PhaseOpinion is not null) "+
				" and FO.InputUser = '"+CurUser.UserID+"' "+
				" and FT.ObjectNo='" + sObjectNo + "' "+
				" and FT.ObjectType='"+ sObjectType +"'"+
				" and FT.FlowNo = '"+sCurFlowNo+"' "+
				" and FT.PhaseNo= '"+sCurPhaseNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{			
			sCustomerName = rs.getString("CustomerName");
			sBusinessCurrencyName = rs.getString("BusinessCurrencyName");
			dBusinessSum = rs.getDouble("BusinessSum");
			dBaseRate = rs.getDouble("BaseRate");
			sRateFloatTypeName = rs.getString("RateFloatTypeName");
			dRateFloat = rs.getDouble("RateFloat");
			dBusinessRate = rs.getDouble("BusinessRate");			
			dBailSum = rs.getDouble("BailSum");
			dBailRatio = rs.getDouble("BailRatio");
			dPdgRatio = rs.getDouble("PdgRatio");
			dPdgSum = rs.getDouble("PdgSum");			
			iTermYear = rs.getInt("TermYear");
			iTermMonth = rs.getInt("TermMonth");
			iTermDay = rs.getInt("TermDay");
			sSelfOpinion = rs.getString("PhaseOpinion");
			sPhaseName = rs.getString("PhaseName");
			sUserName = rs.getString("UserName");
			sOrgName = rs.getString("OrgName");
			sBeginTime = rs.getString("BeginTime");
			sEndTime = rs.getString("EndTime");
			FOPhaseChoice = rs.getString("FOPhaseChoice");
			iCountRecord = iCountRecord + 1;
		}
		rs.getStatement().close();
	}
	
	//各级人员意见保存在 FLOW_OPINION 中 ,如果需要显示一些其他意见需要修改签署意见界面进行配套
	//FLOW_MODEL添加的读于意见查看权限的判断，通过 Attribute2,
	sSql = 	" select FO.CustomerName,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName, "+
			" FO.BusinessSum,FO.TermYear,FO.TermMonth,FO.TermDay,FO.BaseRate,FO.RateFloat,FO.BusinessRate, "+
			" getItemName('RateFloatType',FO.RateFloatType) as RateFloatTypeName,FO.BailSum,FO.BailRatio,getItemName('PhaseChoice',FO.PhaseChoice) as FOPhaseChoice, "+
			" FO.PdgRatio,FO.PdgSum,FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction, "+
			" FT.BeginTime,FT.EndTime,FT.PhaseChoice,FO.PhaseOpinion,FO.PhaseOpinion1,FO.PhaseOpinion2,FO.PhaseOpinion3, "+
			" FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles,"+
			" FO.SystemScore as SystemScore,FO.SystemResult as SystemResult,"+//系统评估得分，系统评估结果
 			" FO.CognScore as CognScore,FO.CognResult as CognResult"+//人工评分，人工评定结果
			" from FLOW_TASK FT,FLOW_OPINION FO,FLOW_MODEL FM "+
			" where FT.Serialno=FO.SerialNo "+
			" and FT.FlowNo=FM.FlowNo "+
			" and FT.PhaseNo=FM.PhaseNo ";
	//如果是客户经理就只显示自己意见以及补充资料意见，这段是因为在点申请详情时没有正确的sCurPhaseNo传入。2D3
	if(CurUser.hasRole("480")||CurUser.hasRole("280")||CurUser.hasRole("080")||CurUser.hasRole("080")||CurUser.hasRole("2D3") ){
		sSql += "and (FT.UserID='"+CurUser.UserID+"' or FT.PhaseNo='3000' or FT.PhaseNo='0010' or FT.PhaseAction='否决'  or FT.PhaseAction='退回补充资料' or FT.PhaseAction='批准') ";
	}
	sSql +=	" and ( FT.PhaseNo<='"+sCurPhaseNo+"' or FT.PhaseNo='3000' or FT.PhaseAction='否决' or FT.PhaseAction='退回补充资料' or FT.PhaseAction='批准') "+//只能查看下级意见，不能看上级意见,可以看补充资料和批准意见 add by zrli 
			" and (FO.PhaseOpinion is not null) "+
			" and FT.ObjectNo='" + sObjectNo + "' "+
			" and FT.ObjectType='"+ sObjectType +"'";
	if("true".equals(sIsPrintFlag))
	{
		sSql += "  and FT.OrgID='"+CurOrg.OrgID+"' ";
	}
	if(sSelfOpinionPhase.equals(""))
		sSql += " ORDER BY FT.SerialNo";
	else
		sSql += " and FT.PhaseNo <> '"+sSelfOpinionPhase+"' ORDER BY FT.SerialNo";
	rs=Sqlca.getASResultSet(sSql);
	
	String sButtons[][] = {
		{"false","","Button","打印批复","打印批复","print()",sResourcesPath},
		{"false","","Button","打印决议","打印决议","print()",sResourcesPath},
	};
	
	if("1000".equals(sFinalFlowNo) && "CreditApply".equals(sObjectType) && CurUser.hasRole("0B3") && dCount>0 ){
		sButtons[0][0] = "true";
	}else if("8000".equals(sFinalFlowNo) && "CreditApply".equals(sObjectType)&& CurUser.hasRole("0B3") && dCount>0){
		sButtons[0][1] = "true";
	}
%>

<html>
<head>
<title>审批详情</title>
</head>
<body leftmargin="0" topmargin="0" class="pagebackground">
<form name="opinion">
  <table width="100%" cellpadding="3" cellspacing="0" border="0" >
    	<tr height=1 valign=top id="buttonback" >
		<td colspan=2>
			<table>
				<tr>
					<td>
						&nbsp;
	    		</td>
				<td class="buttonback">
				<% //审批意见打印员:
					if(CurUser.hasRole("4P1")||CurUser.hasRole("2P1")||CurUser.hasRole("0P1")){ %>
				    	<table>
						<tr>
				  		<td>
							<%=
								HTMLControls.generateButton("打印","打印","spreadsheetPrintout(formatContent());",sResourcesPath)
							%>
						</td> 
						</tr>
				    	</table>
				   <% }%>
				</td>
				</tr>
			</table>
		</td>
	</tr>
	
	
	<tr>
		<td>
			<table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
				<tr> 
					<td width=50%><b>申请流水号:</b><%=sObjectNo%></td>
					<td width=50%><b>客户名称:</b><%=sApplyCustomerName%></td>
				</tr>
				<tr>            
					<td width=50%><b>发生类型:</b><%=sOccurTypeName%></td>
					<td width=50%><b>业务品种:</b><%=sBusinessTypeName%></td>
				</tr> 
				<tr>            
					<td colspan=2 width=50%><b>主要担保方式:</b><%=sVouchTypeName%></td>
				</tr>  
			</table>
		</td>
	</tr>
    <%
        
        while (rs.next())
        {
			sOpinionRightType = rs.getString("OpinionRightType");    //查看意见方式 all_except(排除一些阶段) none_except(选择一些阶段)
			sOpinionRightPhases = rs.getString("OpinionRightPhases");//不同查看意见方式对应的阶段
			sOpinionRightRoles = rs.getString("OpinionRightRoles");  //意见查看特权角色
			sPhaseAction = rs.getString("PhaseAction");
			sCognResult = rs.getString("CognResult");//认定结果
			//将空值转化为空字符串
			if(sOpinionRightType == null) sOpinionRightType = "";
			if(sOpinionRightPhases == null) sOpinionRightPhases = "";
			if(sOpinionRightRoles == null) sOpinionRightRoles = "";
			if(sPhaseAction == null) sPhaseAction = "";
			if(sCognResult == null) sCognResult = "";

			//1、判断该用户是否拥有特权角色
			if(sOpinionRightRoles.equals("")) bRolePrivilege = false;
			else{
				Object[] roles = CurUser.roles.getKeys();
				for(int i=0;i<roles.length;i++){
					if(sOpinionRightRoles.indexOf((String)roles[i])>=0){
						bRolePrivilege = true;
						break;
					}
				}
			}
			
			//2、判断当前意见所处阶段是否在模型对应的特权阶段
			if(sOpinionRightPhases.equals("")) bPhaseMatch = false;			
			else{
				int iCountPhases = StringFunction.getSeparateSum(sOpinionRightPhases,",");
				
				String sTempFlowPhase,sTempFlow,sTempPhase;
				for(int i=0;i<iCountPhases;i++){
					sTempFlowPhase = StringFunction.getSeparate(sOpinionRightPhases,",",i+1);					
					if(sTempFlowPhase.indexOf(".")<0) sTempFlowPhase = sCurFlowNo + "." + sTempFlowPhase;					
					if(sTempFlowPhase.equals(sCurFlowNo+"."+sCurPhaseNo)){
						bPhaseMatch = true;
						break;
					}
				}
			}
			
			//3、根据查看意见方式的不同，判断是否可以显示
			if(sOpinionRightType.equals("") || sOpinionRightType.equals("none_except")){
				bPhasePrivilege = bPhaseMatch;
			}else{
				bPhasePrivilege = !bPhaseMatch;				
			}
			
			//bPhasePrivilege = true; bRolePrivilege = true;
			//4、最终判断是否显示意见，如果不需要显示，则继续判断下一条意见
			//该用户是否具有特权角色、该阶段意见是否属于该意见可查看阶段、该阶段是否属于			
			if(!bPhasePrivilege && !bRolePrivilege && sPhaseAction.indexOf("补充资料")<0) continue;
			iCountRecord++;						
    %>
    <tr>
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr id=<%=iRow++%>>            
			<td width=50%><b>阶段名称:</b><%=DataConvert.toString(rs.getString("PhaseName"))%><input type=hidden value='阶段名称：<%=DataConvert.toString(rs.getString("PhaseName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>处理人:</b><%=DataConvert.toString(rs.getString("UserName"))%><input type=hidden value='处理人：<%=DataConvert.toString(rs.getString("UserName"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>处理人所属机构:</b><%=DataConvert.toString(rs.getString("OrgName"))%><input type=hidden value='处理人所属机构:<%=DataConvert.toString(rs.getString("OrgName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>客户名称:</b><%=DataConvert.toString(rs.getString("CustomerName"))%><input type=hidden value='客户名称:<%=DataConvert.toString(rs.getString("CustomerName"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>业务币种:</b><%=DataConvert.toString(rs.getString("BusinessCurrencyName"))%><input type=hidden value='业务币种:<%=DataConvert.toString(rs.getString("BusinessCurrencyName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>>
			</td>
			<% if("客户经理调查".equals(rs.getString("PhaseName"))||
	              "协办客户经理".equals(rs.getString("PhaseName"))||
            	  "支行协办员审查".equals(rs.getString("PhaseName"))){%>
            	<td width=50%><b>申请金额(元):</b><%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%><input type=hidden value='申请金额(元):<%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
            <%}else{%>
            	<td width=50%><b>审批金额(元):</b><%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%><input type=hidden value='审批金额(元):<%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
            <% }%>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>期限(月):</b><%=rs.getInt("TermMonth")%><input type=hidden value='期限(月):<%=rs.getInt("TermMonth")%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>零(天):</b><%=rs.getInt("TermDay")%><input type=hidden value='零(天):<%=rs.getInt("TermDay")%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <%if(!(sCurFlowNo.equals("CreditFlow") || sCurFlowNo.equals("CreditFlow03")) ){ //lpzhang 2009-12-23 %> 
        <tr id=<%=iRow++%>>            
			<td width=50%><b>基准年利率(%):</b><%=rs.getDouble("BaseRate")%><input type=hidden value='基准年利率(%):<%=rs.getDouble("BaseRate")%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>利率浮动方式:</b><%=DataConvert.toString(rs.getString("RateFloatTypeName"))%><input type=hidden value='利率浮动方式:<%=DataConvert.toString(rs.getString("RateFloatTypeName"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>利率浮动值:</b><%=rs.getDouble("RateFloat")%><input type=hidden value='利率浮动值:<%=rs.getDouble("RateFloat")%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>执行月利率(‰):</b><%=rs.getDouble("BusinessRate")%><input type=hidden value='执行月利率(‰):<%=rs.getDouble("BusinessRate")%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>保证金金额(元):</b><%=DataConvert.toMoney(rs.getDouble("BailSum"))%><input type=hidden value='保证金金额(元):<%=DataConvert.toMoney(rs.getDouble("BailSum"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>保证金比例(%):</b><%=rs.getDouble("BailRatio")%><input type=hidden value='保证金比例(%):<%=rs.getDouble("BailRatio")%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>手续费金额(元):</b><%=DataConvert.toMoney(rs.getDouble("PdgSum"))%><input type=hidden value='手续费金额(元):<%=DataConvert.toMoney(rs.getDouble("PdgSum"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>手续费率(‰):</b><%=rs.getDouble("PdgRatio")%><input type=hidden value='手续费率(‰):<%=rs.getDouble("PdgRatio")%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
     <%} %>  
     <%if(!sCognResult.equals("")){ %>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>信用等级认定得分:</b><%=DataConvert.toMoney(rs.getDouble("CognScore"))%><input type=hidden value='信用等级认定得分:<%=DataConvert.toMoney(rs.getDouble("CognScore"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>信用等级认定结果:</b><%=DataConvert.toString(sCognResult)%><input type=hidden value='信用等级认定结果:<%=DataConvert.toString(sCognResult)%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
     <%} %>
        <tr id=<%=iRow++%>>
            <td width=50%><b>收到时间:</b><%=DataConvert.toString(rs.getString("BeginTime"))%><input type=hidden value='收到时间:<%=DataConvert.toString(rs.getString("BeginTime"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>完成时间:</b><%=DataConvert.toString(rs.getString("EndTime"))%><input type=hidden value='完成时间:<%=DataConvert.toString(rs.getString("EndTime"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>
        <% if("0010".equals(rs.getString("PhaseNo"))||"0020".equals(rs.getString("PhaseNo"))){%>
            <td width=50% ><b>调查意见:</b><%=DataConvert.toString(rs.getString("FOPhaseChoice"))%><input type=hidden value='调查意见:<%=DataConvert.toString(rs.getString("FOPhaseChoice"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
        <%} else{%>    
        	 <td width=50% ><b>审查审批意见:</b><%=DataConvert.toString(rs.getString("FOPhaseChoice"))%><input type=hidden value='审查审批意见:<%=DataConvert.toString(rs.getString("FOPhaseChoice"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
        <%} %>	 
            <td width=50% ><input type=hidden value='' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n【意见说明】"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            	<input type=hidden value='<%="\r\n【意见】"+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(iRow)+"L"%>>
            	<input type=hidden value='' name=<%="R"+String.valueOf(iRow)+"R"%>>	<!--用于判断是否插入一行一列-->
            </td>
        </tr>        
      </table>
	  </td>
    </tr>
    <tr>
	<td>&nbsp;
	  </td>
    </tr>
    <%
    }
    rs.getStatement().close();
    
    //展现背靠背审批自己签署的意见
    if(!sSelfOpinionPhase.equals(""))
    {
    %>
    <tr>
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr id=<%=jRow++%>>            
			<td width=50%><b>阶段名称:</b><%=DataConvert.toString(rs.getString("PhaseName"))%><input type=hidden value='阶段名称：<%=DataConvert.toString(rs.getString("PhaseName"))%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>处理人:</b><%=DataConvert.toString(rs.getString("UserName"))%><input type=hidden value='处理人：<%=DataConvert.toString(rs.getString("UserName"))%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>处理人所属机构:</b><%=DataConvert.toString(sOrgName)%><input type=hidden value='处理人所属机构:<%=DataConvert.toString(sOrgName)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>客户名称:</b><%=DataConvert.toString(sCustomerName)%><input type=hidden value='客户名称:<%=DataConvert.toString(sCustomerName)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>业务币种:</b><%=DataConvert.toString(sBusinessCurrencyName)%><input type=hidden value='业务币种:<%=DataConvert.toString(sBusinessCurrencyName)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <% if("客户经理调查".equals(rs.getString("PhaseName"))||
            	  "协办客户经理".equals(rs.getString("PhaseName"))||
            	  "支行协办员审查".equals(rs.getString("PhaseName"))){%>
            	<td width=50%><b>申请金额(元):</b><%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%><input type=hidden value='申请金额(元):<%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
            <%}else{%>
            	<td width=50%><b>审批金额(元):</b><%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%><input type=hidden value='审批金额(元):<%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
            <% }%>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>期限(月):</b><%=iTermMonth%><input type=hidden value='期限(月):<%=iTermMonth%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>零(天):</b><input type=hidden value='零(天):' name=<%="R"+String.valueOf(jRow)+"R"%>><%=iTermDay%></td>
        </tr>
      <%if(!(sCurFlowNo.equals("CreditFlow") || sCurFlowNo.equals("CreditFlow03")) ){ //lpzhang 2009-12-23 %> 
        <tr id=<%=jRow++%>>            
			<td width=50%><b>基准年利率(%):</b><%=dBaseRate%><input type=hidden value='基准年利率(%):<%=dBaseRate%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>利率浮动方式:</b><%=DataConvert.toString(sRateFloatTypeName)%><input type=hidden value='利率浮动方式:<%=DataConvert.toString(sRateFloatTypeName)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>利率浮动值:</b><%=dRateFloat%><<input type=hidden value='利率浮动值:<%=dRateFloat%>' name=<%="R"+String.valueOf(jRow)+"L"%>>/td>
            <td width=50%><b>执行月利率(‰):</b><%=dBusinessRate%><input type=hidden value='执行月利率(‰):<%=dBusinessRate%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>保证金金额(元):</b><%=dBailSum%><input type=hidden value='保证金金额(元):<%=dBailSum%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>保证金比例(%):</b><%=dBailRatio%><input type=hidden value='保证金比例(%):<%=dBailRatio%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>手续费金额(元):</b><%=dPdgSum%><input type=hidden value='手续费金额(元):<%=dPdgSum%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>手续费率(‰):</b><%=dPdgRatio%><input type=hidden value='手续费率(‰):<%=dPdgRatio%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
     <%} %>  
     <%if(!sCognResult.equals("")){ %>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>信用等级认定得分:</b><%=DataConvert.toMoney(rs.getDouble("CognScore"))%><input type=hidden value='信用等级认定得分:<%=DataConvert.toMoney(rs.getDouble("CognScore"))%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>信用等级认定结果:</b><%=DataConvert.toString(sCognResult)%><input type=hidden value='信用等级认定结果:<%=DataConvert.toString(sCognResult)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
     <%} %>
        <tr id=<%=jRow++%>>
            <td width=50%><b>收到时间:</b><%=DataConvert.toString(sBeginTime)%><input type=hidden value='收到时间:<%=DataConvert.toString(sBeginTime)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>完成时间:</b><%=DataConvert.toString(sEndTime)%><input type=hidden value='完成时间:<%=DataConvert.toString(sEndTime)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>
        <% if("0010".equals(rs.getString("PhaseNo"))||"0020".equals(rs.getString("PhaseNo"))){%>
            <td width=50% ><b>调查意见:</b><%=DataConvert.toString(rs.getString("FOPhaseChoice"))%><input type=hidden value='调查意见:<%=DataConvert.toString(rs.getString("FOPhaseChoice"))%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
        <%} else{%>    
        	 <td width=50% ><b>审查审批意见:</b><%=DataConvert.toString(rs.getString("FOPhaseChoice"))%><input type=hidden value='审查审批意见:<%=DataConvert.toString(rs.getString("FOPhaseChoice"))%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
        <%} %>	 
            <td width=50% ><input type=hidden value='' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        
        <tr id=<%=jRow++%>>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n【意见说明】"+ StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
                <input type=hidden value='<%="\r\n【意见】"+StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(jRow)+"L"%>>
            <input type=hidden value='' name=<%="R"+String.valueOf(jRow)+"R"%>>	<!--用于判断是否插入一行一列-->
            </td>
        </tr>        
      </table>
	  </td>
    </tr>
    <tr>
	<td>&nbsp;
	  </td>
    </tr>    
    <%
    }
    %>
 
  </table>
  </form>
</body>
</html>
<%
	//如果没有意见或者没有找到对应的对象，则自动关闭
	if (iCountRecord==0||sObjectNo.equals("")){
%>
<script>
    alert("目前此业务还没有您可以查看的审批意见！");
</script>
<%
	}
%>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function print()
	{
		var sObjectNo = "<%=sObjectNo%>";
		var sObjectType = "<%=sObjectType%>";
		var sReportType = "<%=sReportType%>";
		var sSerialNo = "";
		sSerialNo = RunMethod("BusinessManage","SelectInpcetReport",sObjectNo+","+sObjectType);
		if(typeof(sSerialNo) == "undefined" || sSerialNo == "" || sSerialNo == "Null" || sSerialNo == "null" || sSerialNo == "NULL") {
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddAVAction.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		}	
		sCompID = "InspectTab";
		sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
		sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&ReportType="+sReportType+"&SerialNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function formatContent()
	{
		var sContentNew = "",i=0;
		var iRowCount = 1;
		if("<%=sSelfOpinionPhase%>" != "")	iRowCount =<%=jRow%>;
		else	iRowCount =<%=iRow%>;
	
		var iColCount = 2;
		sContentNew +="<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=gb_2312-80\">";
		sContentNew += "<STYLE>"; 
		sContentNew += ".table {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}";
		sContentNew += ".td {  font-size: 9pt;border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}.inputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}.pt16songud{font-family: '黑体','宋体';font-size: 16pt;font-weight:bold;text-decoration: none}.myfont{font-family: '黑体','宋体';font-size: 9pt;font-weight:bold;text-decoration: none}"
		sContentNew += "</STYLE>";
		
		sContentNew += "<table align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF >";
		sContentNew += "<tr>";
		sContentNew += "    <td colspan="+iColCount+" align=middle style='color:black;padding-left:2px;background:silver;font-size:18.0pt;font-weight:700;font-family:黑体;' height=53>业务审查审批意见</td>";
		sContentNew += "</tr>";
		sContentNew += "<tr>";
		sContentNew += "    <td align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>【申请流水号】<%=sObjectNo%></td>";
		sContentNew += "    <td align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>【客户名称】<%=sApplyCustomerName%></td>";
		sContentNew += "</tr>";
		sContentNew += "<tr>";
		sContentNew += "    <td align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>【发生类型】<%=sOccurTypeName%></td>";
		sContentNew += "    <td align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>【业务品种】<%=sBusinessTypeName%></td>";
		sContentNew += "</tr>";
		sContentNew += "<tr>";
		sContentNew += "    <td colspan="+iColCount+" align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>【主要担保方式】"+"<%=sVouchTypeName%></td>";
		sContentNew += "</tr>";
		
		for(i=1;i<=iRowCount;i++)
		{
			
			if(document.forms("opinion").elements("R"+i+"R").value == "amarsoft")	//意见框只插入一行一列
			{
				sContentNew += "<tr height=50 style='mso-height-source:userset;height:38.1pt'>";
				sContentNew += "    <td colspan="+iColCount+" align=left style='background-color:#CCC8EB;color:black;padding-left:2px;mso-font-charset:0;vertical-align:top;text-align:left;'>"+document.forms("opinion").elements("R"+i+"L").value+"</td>";
				sContentNew += "</tr>";
			}
			else
			{
				sContentNew += "<tr>";
				sContentNew += "    <td align=left>"+document.forms("opinion").elements("R"+i+"L").value+"</td>";
				sContentNew += "    <td align=left>"+document.forms("opinion").elements("R"+i+"R").value+"</td>";
				sContentNew += "</tr>";
			}
		}	
		
		sContentNew += "</table>";
		//防止因导出数据量太小，导出EXCEL时变成乱码
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		
		return(sContentNew);		
	}
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
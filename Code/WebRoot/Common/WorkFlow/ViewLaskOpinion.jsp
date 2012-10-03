<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 *查看最终审批意见 2010-4-6 lpzhang
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
	//将空值转化为空字符串
	if(sObjectType==null)sObjectType="";
	if(sObjectNo==null)sObjectNo="";
	if(sCurFlowNo==null)sCurFlowNo="";
	if(sCurPhaseNo==null)sCurPhaseNo="";
	
    String sSql="",sLaskFlowSerialNo="",sBASerialNo ="";

	int iCountRecord=0;//用于判断记录是否有审批意见

	ASResultSet rs = null;

	//查询申请流水号
	sSql = " select RelativeSerialNo from Business_Contract where SerialNo = "+
           " (select ContractSerialNo From Business_PutOut where SerialNo ='" + sObjectNo + "' ) ";
	sBASerialNo= Sqlca.getString(sSql);
	if(sBASerialNo==null) sBASerialNo="";
	//批复
	if("CreditApproveApply".equals(sObjectType))
	{
		sBASerialNo = sObjectNo;
	}
	//获取最终审批人的审批流水
	sSql = 	" select SerialNo from Flow_Task "+
			" where  SerialNo =( select RelativeSerialNo  from Flow_Task where PhaseNo in('1000','8000') and ObjectNo='" + sBASerialNo + "' and ObjectType='CreditApply')"+ 
			" and ObjectNo='" + sBASerialNo + "' "+
			" and ObjectType='CreditApply' ";

    sLaskFlowSerialNo= Sqlca.getString(sSql);
	
	
	//各级人员意见保存在 FLOW_OPINION 中 ,如果需要显示一些其他意见需要修改签署意见界面进行配套
	//FLOW_MODEL添加的读于意见查看权限的判断，通过 Attribute2,
	sSql = 	" select FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction,FT.BeginTime, "+
			" FT.EndTime,getItemName('PhaseChoice',FO.PhaseChoice) as PhaseChoice,FO.PhaseOpinion,FO.PhaseOpinion1,FO.PhaseOpinion2,FO.PhaseOpinion3, "+
			" FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles, "+
			" FO.BusinessSum,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName,FO.TermMonth,FO.TermDay, "+
			" FO.BaseRate,getItemName('RateFloatType',FO.RateFloatType) as RateFloatTypeName ,FO.RateFloat,FO.BusinessRate,FO.BailSum,"+
			" FO.BailRatio,FO.PdgRatio,FO.PdgSum"+
			" from FLOW_TASK FT,FLOW_OPINION FO,FLOW_MODEL FM "+
			" where FT.Serialno=FO.SerialNo "+
			" and FT.FlowNo=FM.FlowNo "+
			" and FT.PhaseNo=FM.PhaseNo "+
			" and (FO.PhaseOpinion is not null) "+
			" and FT.ObjectNo='" + sBASerialNo + "' "+
			" and FT.ObjectType='CreditApply' " +
			" and FT.SerialNo = '"+sLaskFlowSerialNo+"'";
	
	rs=Sqlca.getASResultSet(sSql);
%>
<html>
<head>
<title>审批详情</title>
</head>
<body leftmargin="0" topmargin="0" class="pagebackground">
  <table width="100%" cellpadding="3" cellspacing="0" border="0" >
    <%
        
        while (rs.next())
        {
			
			iCountRecord++;						
    %>
    <tr>
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr>
            <td colspan=2 bgcolor="#CCCCCC">
                <b>阶段名称:</b><%=DataConvert.toString(rs.getString("PhaseName"))%>&nbsp;&nbsp;
                <b>处理人:</b><%=DataConvert.toString(rs.getString("UserName"))%>&nbsp;&nbsp;
                <b>处理人所属机构:</b><%=DataConvert.toString(rs.getString("OrgName"))%>&nbsp;&nbsp;
            </td>
        </tr>
        <tr>
            <td width=50%><b>收到时间:</b><%=DataConvert.toString(rs.getString("BeginTime"))%>
            <td width=50%><b>完成时间:</b><%=DataConvert.toString(rs.getString("EndTime"))%></td>
        </tr>
        
        <tr>
            <td width=50%><b>审批意见:</b><%=DataConvert.toString(rs.getString("PhaseChoice"))%>
            <td width=50%></td>
        </tr>
                <tr>            
			<td width=50%><b>业务币种:</b><%=DataConvert.toString(rs.getString("BusinessCurrencyName"))%></td>
            <td width=50%><b>申请金额(元):</b><%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%></td>
        </tr>
        <tr>            
			<td width=50%><b>期限(月):</b><%=rs.getInt("TermMonth")%></td>
            <td width=50%><b>零(天):</b><%=rs.getInt("TermDay")%></td>
        </tr>
        <tr>            
			<td width=50%><b>基准年利率(%):</b><%=rs.getDouble("BaseRate")%></td>
            <td width=50%><b>利率浮动方式:</b><%=DataConvert.toString(rs.getString("RateFloatTypeName"))%></td>
        </tr>
        <tr>            
			<td width=50%><b>利率浮动值:</b><%=rs.getDouble("RateFloat")%></td>
            <td width=50%><b>执行月利率(‰):</b><%=rs.getDouble("BusinessRate")%></td>
        </tr>
        <tr>            
			<td width=50%><b>保证金金额(元):</b><%=DataConvert.toMoney(rs.getDouble("BailSum"))%></td>
            <td width=50%><b>保证金比例(%):</b><%=rs.getDouble("BailRatio")%></td>
        </tr>
        <tr>            
			<td width=50%><b>手续费金额(元):</b><%=DataConvert.toMoney(rs.getDouble("PdgSum"))%></td>
            <td width=50%><b>手续费率(‰):</b><%=rs.getDouble("PdgRatio")%></td>
        </tr>
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n【意见说明】"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
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
    
    
    %>
 
  </table>
</body>
</html>
<%
	//如果没有意见或者没有找到对应的对象，则自动关闭
	if (iCountRecord==0||sObjectNo.equals("")){
%>
<script>
    alert("目前此业务还未最终审批，不能查看意见！");
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>
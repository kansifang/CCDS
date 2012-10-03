<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   FSGong 2004-12-09
 * Tester:
 *
 * Content:   直接插入一条资产纪录
 * Input Param:
 *		AssetType：资产类型
 *		SerialNo：资产类型
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//获取页面参数
	String sAssetType = DataConvert.toRealString(iPostChange,CurPage.getParameter("AssetType")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 
	//将空值转化为空字符串
	if(sAssetType == null) sAssetType = "";
	if(sSerialNo == null) sSerialNo = "";	
	
	//定义变量	
	String sSql = "";
	
	sSql = "insert into ASSET_INFO(SerialNo,"+
		"ObjectType,"+
		"ObjectNo,"+
		"AssetNo,"+
		"AssetBalance,"+
		"OutInitBalance,"+
		"OutNowBalance,"+
		"AssetAmount,"+
		"AssetSum,"+
		"IntoCashRatio,"+
		"IntoCashSum,"+
		"LossesSum,"+
		"FinancialLossesSum,"+
		"PershareValue,"+
		"EnterValue,"+
		"UnDisposalSum,"+
		"AssetStatus,"+  //已比准拟抵入。
		"AssetAttribute,"+
		"AssetType,"+
		"OperateOrgID,"+
		"OperateUserID,"+
		"ManageUserID,"+
		"ManageOrgID,"+
		"InputOrgID,"+
		"InputUserID,"+
		"InputDate,"+
		"UpdateDate) "+
		"values('"+sSerialNo+"','AssetInfo','"+sSerialNo+"',null,0,0,0,'0',0,0,0,0,0,0,0,0,'02','01','"+
		sAssetType+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+
		CurUser.UserID+"','"+CurOrg.OrgID+"','"+CurOrg.OrgID+"','"+
		CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";

	Sqlca.executeSQL(sSql);
%>

<script language=javascript>   
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>

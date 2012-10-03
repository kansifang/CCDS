<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xxge 2004-11-25
 * Tester:
 *
 * Content:  将不良资产移交保全机构并更新合同表
 * Input Param:
 *		SerialNo：合同流水号
 *		TraceOrgID：保全机构
 *		ShiftType: 移交类型（01：审批移交；02：账户移交）
 *		Type：移交方向（1：正向移交；2：逆向移交）
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//定义变量
	String sSql = "";    
	ASResultSet rs = null;
	double sBalance = 0;
	
	//合同流水号、保全机构、移交类型、移交方向
	String sSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 	
	String sTraceOrgID = DataConvert.toRealString(iPostChange,CurPage.getParameter("TraceOrgID"));
	String sShiftType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ShiftType"));
	String sType = DataConvert.toRealString(iPostChange,CurPage.getParameter("Type"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sTraceOrgID == null) sTraceOrgID = "";
	if(sShiftType == null) sShiftType = "";
	if(sType == null) sType = "";
	
   	if(sType.equals("1"))//由信贷部移交保全部
   	{	        
        sSql = " select Balance from BUSINESS_CONTRACT where SerialNo='"+sSerialNo+"' ";
  		rs = Sqlca.getASResultSet(sSql);    
   		if(rs.next())
   		 	sBalance = rs.getDouble("Balance");        
		 rs.getStatement().close();
		       
        //更新合同表
        sSql = " update BUSINESS_CONTRACT set ShiftBalance = "+sBalance+",ShiftType = '"+sShiftType+"',RecoveryOrgID = '"+sTraceOrgID+"' where SerialNo = '"+sSerialNo+"' ";
       	Sqlca.executeSQL(sSql);	 	
	%>
		<script language=javascript>
		    self.returnValue="true";
		    self.close();    
		</script>	
	<%
	}else //从保全部退回到信贷部
	{	
		//更新合同表
        sSql= " update BUSINESS_CONTRACT set ShiftBalance = 0.0,ShiftType = null,RecoveryOrgID = null where SerialNo = '"+sSerialNo+"' ";
       	Sqlca.executeSQL(sSql);	 	
	%>
		<script language=javascript>
		    self.returnValue="true";
		    self.close();    
		</script>
	<%
	}
	%>
	
<%@ include file="/IncludeEnd.jsp"%>

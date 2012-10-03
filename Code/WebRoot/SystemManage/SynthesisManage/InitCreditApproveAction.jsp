<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  zywei 2006.10.25
 * Tester:
 *
 * Content: 批复初始化
 * Input Param:
 * 			 SerialNo：申请编号

 * Output param:
 *
 * History Log:
 *  		
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.lending.bizlets.*,com.amarsoft.biz.bizlet.Bizlet" %>


<%
    //获取参数：
    String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sInitFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sMaxSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MaxSerialNo"));
	String sMaxPhaseNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MaxPhaseNo"));
	String sMaxPhaseType    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MaxPhaseType"));
	String sMaxPhaseName    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MaxPhaseName"));
    if(sInitFlag == null) sInitFlag = "";
    if(sMaxSerialNo == null) sMaxSerialNo = "";
    if(sMaxPhaseNo == null) sMaxPhaseNo = "";
    if(sMaxPhaseType == null) sMaxPhaseType = "";
    if(sMaxPhaseName == null) sMaxPhaseName = "";
    
    String sFlag="",sPhaseNo="",sPhaseType="",sPhaseName="";
    String sSql="";
	//定义变量：查询结果集
	ASResultSet rs = null;
   	//事务处理开始	
    boolean bOld = Sqlca.conn.getAutoCommit();
    Sqlca.conn.setAutoCommit(false);
    try{
			Sqlca.executeSQL("update FLOW_TASK set EndTime=null,PhaseAction=null  where ObjectNo = '"+sSerialNo+"' and ObjectType = 'CreditApproveApply' and  PhaseNo='0020' ");
			Sqlca.executeSQL("delete from  FLOW_TASK where ObjectNo = '"+sSerialNo+"' and ObjectType = 'CreditApproveApply' and  PhaseNo<>'0020' ");
			Sqlca.executeSQL("update FLOW_OBJECT set PhaseNo='0020',PhaseType='1020',PhaseName='经办人调查' where ObjectNo = '"+sSerialNo+"' and ObjectType = 'CreditApproveApply'  ");
			Sqlca.executeSQL("update BUSINESS_APPLY set FinishApproveUserID=null where SerialNo = '"+sSerialNo+"'  ");
			//Sqlca.executeSQL("delete from flow_opinion where objectno='"+sSerialNo+"' and objecttype='CreditApproveApply'  ");
		
		//事务提交
        Sqlca.conn.commit();
        Sqlca.conn.setAutoCommit(bOld);
        sFlag="00";
	}catch(Exception e)
	{
		sFlag="99";
		//事务失败回滚
        Sqlca.conn.rollback();
        Sqlca.conn.setAutoCommit(bOld);
		throw new Exception("申请初始化！"+e.getMessage());
	}
%>

<script language=javascript>
	self.returnValue = "<%=sFlag%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>
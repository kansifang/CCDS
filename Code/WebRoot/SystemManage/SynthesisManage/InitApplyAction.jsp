<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  zywei 2006.10.25
 * Tester:
 *
 * Content: 申请初始化
 * Input Param:
 * 			 SerialNo：合同编号

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
    	//add by xhyong 2011/05/13初始化删除批复信息
    	Sqlca.executeSQL("delete from  FLOW_TASK where ObjectNo = '"+sSerialNo+"' and ObjectType = 'CreditApproveApply' ");
    	Sqlca.executeSQL("delete from  FLOW_OBJECT where ObjectNo = '"+sSerialNo+"' and ObjectType = 'CreditApproveApply' ");
    	Sqlca.executeSQL("update BUSINESS_APPLY set ApprovalNo=null,IsApproveFLag=null,finishApproveUserID=null where SerialNo = '"+sSerialNo+"'  ");
    	//删除批复报告
    	Sqlca.executeSQL("delete from INSPECT_Info where ObjectNo ='"+sSerialNo+"' and ObjectType = 'ApproveApproval'") ;

    	if("1".equals(sInitFlag)){
			Sqlca.executeSQL("update FLOW_TASK set EndTime=null,PhaseAction=null  where ObjectNo = '"+sSerialNo+"' and ObjectType = 'CreditApply' and  PhaseNo='0010' ");
			Sqlca.executeSQL("delete from  FLOW_TASK where ObjectNo = '"+sSerialNo+"' and ObjectType = 'CreditApply' and  PhaseNo<>'0010' ");
			Sqlca.executeSQL("update FLOW_OBJECT set PhaseNo='0010',PhaseType='1010',PhaseName='调查阶段' where ObjectNo = '"+sSerialNo+"' and ObjectType = 'CreditApply'  ");
			Sqlca.executeSQL("update BUSINESS_APPLY set ApproveUserID=null,ApproveOrgID=null,OrgFlag=null,ApproveDate=null where SerialNo = '"+sSerialNo+"'  ");
			Sqlca.executeSQL("delete from flow_opinion where objectno='"+sSerialNo+"' and objecttype='CreditApply'  ");
		}else if("2".equals(sInitFlag)){
			Sqlca.executeSQL("delete from  FLOW_TASK where ObjectNo = '"+sSerialNo+"' and ObjectType = 'CreditApply' and  PhaseNo in('8000','1000') ");
			Sqlca.executeSQL("update FLOW_TASK set EndTime=null,PhaseAction=null  where SerialNo = '"+sMaxSerialNo+"'");
			Sqlca.executeSQL("update FLOW_OBJECT set PhaseNo='"+sMaxPhaseNo+"',PhaseType='"+sMaxPhaseType+"',PhaseName='"+sMaxPhaseName+"'"+
							" where ObjectNo = '"+sSerialNo+"' and ObjectType = 'CreditApply'  ");
			Sqlca.executeSQL("update BUSINESS_APPLY set ApproveUserID=null,ApproveOrgID=null,OrgFlag=null,ApproveDate=null where SerialNo = '"+sSerialNo+"'  ");
		
		}	
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
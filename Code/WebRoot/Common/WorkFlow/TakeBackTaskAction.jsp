<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: CChang 2003.8.28
 * Tester:
 *
 * Content: 提示下一阶段信息 
 * Input Param:
 * 				SerialNo：	当前任务的流水号
 * Output param:
 *				sReturnValue:	返回值Commit表示完成操作
 * History Log: 2003-12-2:cwzhan
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>
<% 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));//从上个页面得到传入的任务流水号
	String sReturnMessage = "";//执行后返回的信息
	String sSql = "";
    String sObjectNo = "";
    String sObjectType = "";
    boolean hasContract = false;
    String sTakeBackFlag = "";
    ASResultSet rs = null;
    String sNextSerialNo = "";//下级任务流水号
    
    //根据任务流水号获得对象类型和对象编号
    sSql = "select ObjectType,ObjectNo from FLOW_TASK where SerialNo='"+ sSerialNo +"' ";
    rs = Sqlca.getASResultSet(sSql);
    if(rs.next())
    {
        sObjectType = DataConvert.toString(rs.getString("ObjectType"));
        sObjectNo = DataConvert.toString(rs.getString("ObjectNo"));
        //将空值转化为空字符串
        if(sObjectType == null) sObjectType = "";
        if(sObjectNo == null) sObjectNo = "";
    }
    rs.getStatement().close();
    
  	//根据任务流水号获得上一级任务流水号
    sSql = "select SerialNo from FLOW_TASK where RelativeSerialNo='"+ sSerialNo +"' ";
    rs = Sqlca.getASResultSet(sSql);
    if(rs.next())
    {
    	sNextSerialNo = DataConvert.toString(rs.getString("SerialNo"));
        //将空值转化为空字符串
        if(sNextSerialNo == null) sNextSerialNo = "";
    }
    rs.getStatement().close();
    
    //申请收回时必须判断该申请是否已经登记了最终审批意见，如果是则不能收回
    if(sObjectType.equals("CreditApply"))
    {
    	sSql = " select SerialNo from BUSINESS_APPROVE where RelativeSerialNo = '"+ sObjectNo +"' ";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
        {
            hasContract = true;
            sReturnMessage = "该笔申请已经登记了最终审批意见，不能收回！";
            sTakeBackFlag = "hasApprove";
        }
        rs.getStatement().close();
    }
    
    //最终审批意见的收回操作必须判断该笔最终审批意见是否已经签署了合同，如果是则不能收回
    if(sObjectType.equals("ApproveApply"))
    {
        sSql = " select SerialNo from BUSINESS_CONTRACT where RelativeSerialNo = '"+ sObjectNo +"' ";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
        {
            hasContract = true;
            sReturnMessage = "该笔最终审批意见已经签定合同，不能收回！";
            sTakeBackFlag = "hasContract";
        }
        rs.getStatement().close();
    }
	
    //预警查看上级是否签署意见,如果签署则不能收回
    if(sObjectType.equals("RiskSignalApply"))
    {
    	 sSql = " select SerialNo from RISKSIGNAL_OPINION where SerialNo = '"+ sNextSerialNo +"' ";
         rs = Sqlca.getASResultSet(sSql);
         if(rs.next())
         {
             hasContract = true;
             sReturnMessage = "下阶段任务已提交或已签署意见，不能收回！";
             sTakeBackFlag = "hasContract";
         }
         rs.getStatement().close();
    }
    
    
    if(hasContract == false)
    {       
        FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);//初始化任务对象
        ftBusiness.takeBack(CurUser);//执行退回操作
        sReturnMessage = ftBusiness.takeBack(CurUser).ReturnMessage;	
        if (sReturnMessage.equals("收回完成"))
        {
            sTakeBackFlag = "Commit";
        }        
    }
    
%>
<script language=javascript>
	alert("<%=sReturnMessage%>");
	self.returnValue = "<%=sTakeBackFlag%>";
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>
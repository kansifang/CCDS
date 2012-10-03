<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: FSGong 2004-12-30
 * Tester:
 * Content: 
 *从Business_Apply中删除一个申请记录之后，必须删除其相关联的其他信息。
 * Input Param:
 *		  
 *  
 * Output param:
 *		无	
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	
	//申请流水号、申请大类型
	String 	sSerialNo		= DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String 	sObjectType	= DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	
	//流程编号
	String	sFlowNo		= DataConvert.toRealString(iPostChange,(String)request.getParameter("FlowNo"));
	
	ASResultSet               rs;

	boolean bOldTransaction = Sqlca.conn.getAutoCommit(); 
	try 
		{
			//如果事务尚未提交，则事先提交。
			if(!bOldTransaction) Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(false);

			//删除FLOW_TASK表中相关数据：删除流程运行历史。
			String	sSql1 = " Delete from FLOW_TASK  where FlowNo='"+sFlowNo+"' and ObjectNo='"+sSerialNo+"'";
			Sqlca.executeSQL(sSql1);

			//删除FLOW_OBJECT表中相关数据：删除流程当前运行点。
			String	sSql2 = " Delete from Flow_Object where ObjectType='"+sObjectType+"' and ObjectNo='"+sSerialNo+"'";
			Sqlca.executeSQL(sSql2);  				
			
			//删除APPLY_RELATIVE中的关联纪录：SerialNo为申请编号。ObjectNo为合同编号。
			String	sSql3 = " Delete from Apply_Relative where ObjectType='BusinessContract'  and  SerialNo='"+sSerialNo+"'";
			Sqlca.executeSQL(sSql3);  

			//删除Business_Apply表中相关数据
			String	sSql4= " Delete from Business_Apply where SerialNo='"+sSerialNo+"'";
			Sqlca.executeSQL(sSql4);  			


			//提交自定义事务
			Sqlca.conn.commit();
			//恢复系统事务
			Sqlca.conn.setAutoCommit(bOldTransaction);
		}
		catch(Exception e)
		{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bOldTransaction);
			throw new Exception("事务处理失败！"+e.getMessage());
		}		
%>

<script language=javascript>
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
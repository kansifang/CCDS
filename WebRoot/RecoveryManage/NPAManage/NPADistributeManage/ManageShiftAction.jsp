<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xxge 2004-11-25
 * Tester:
 *
 * Content:  更新指定合同的不良资产管理人
 * Input Param:
 *	SerialNo	：合同流水号
 *	RecoveryUserID	: 移交类型
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	 //合同流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,request.getParameter("SerialNo"));  
	//原移交类型、新移交类型	
	String sOldShiftType = DataConvert.toRealString(iPostChange,request.getParameter("OldShiftType")); 
	String sShiftType = DataConvert.toRealString(iPostChange,request.getParameter("ShiftType")); 
	String sSql = "";
	
	//选择所选合同的原移交类型
	ASResultSet rs = null;
	ASResultSet rs1 = null;
	int sCount = 0;
	String sOldShift = "";
	String sRecoveryOrgid = "";
	String sRecoveryUserid = "";
	boolean AddFlag = false;
	
	sSql= " select  ShiftType,RecoveryOrgid,RecoveryUserid from BUSINESS_CONTRACT "+
          " WHERE  SerialNo='" + sSerialNo + "'";
                
    rs = Sqlca.getASResultSet(sSql); 
  	if(rs.next())
	{
       AddFlag = true;
       sOldShift = DataConvert.toString(rs.getString("ShiftType"));
       sRecoveryOrgid = DataConvert.toString(rs.getString("RecoveryOrgid")); 
       sRecoveryUserid = DataConvert.toString(rs.getString("RecoveryUserid"));        
	}
	rs.getStatement().close();
	
	if (AddFlag) 
	{		
		boolean bOld = Sqlca.conn.getAutoCommit(); 
		try 
		{
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(false);	
			//更新对应合同的移交类型
	        sSql= " UPDATE BUSINESS_CONTRACT "+
	              " SET ShiftType='"+sShiftType+"' "+
	              " WHERE  SerialNo='" + sSerialNo + "'";   
		   	Sqlca.executeSQL(sSql);
		    	
		    String sSql1 = "";
		    	
		    //向SHIFTCHANGE_INFO表中插入移交类型变更记录
			String sSerialNo1 = DBFunction.getSerialNo("SHIFTCHANGE_INFO","SerialNo",Sqlca);
	        sSql1= " insert into SHIFTCHANGE_INFO(SerialNo,ContractNo,OldShift,NewShift,InputUserID,InputOrgID,InputDate) "+
			       " values('"+sSerialNo1+"','"+sSerialNo+"','"+sOldShift+"','"+sShiftType+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+ StringFunction.getToday() + "')"; 
		   	Sqlca.executeSQL(sSql1);
		   			   	
		   	if(sOldShiftType.equals("020")) //如果是客户移交变成审批移交
		   	{
		   		
		   		String sSql2 = 	" select count(*) from TRACE_INFO "+
				   				" where ContractNo = '"+sSerialNo+"' "+
				   				" and TraceUserid = '"+sRecoveryUserid+"' "+
				   				" and TraceOrgid = '"+sRecoveryOrgid+"' "+
				   				" and (CancelFlag='' or CancelFlag is null)" ;
		   		
		   		rs1 = Sqlca.getASResultSet(sSql2); 
			    if(rs1.next()) sCount = rs1.getInt(1);
				if(sCount <= 0)
				{
					//向Trace_Info表中数据
					String sSerialNo2 = DBFunction.getSerialNo("Trace_Info","SerialNo",Sqlca);
			        sSql= " Insert into TRACE_INFO(SerialNo,ContractNo,TraceUserid,TraceOrgid,InputUserID,InputOrgID,InputDate) "+
			        	  " Values('"+sSerialNo2+"','"+sSerialNo+"','"+sRecoveryUserid+"','"+sRecoveryOrgid+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+ StringFunction.getToday() + "') ";
			       	Sqlca.executeSQL(sSql);
				  }
			      rs1.getStatement().close();
		   	}
		 	
		 	//事物提交
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(bOld);
		}catch(Exception e)
		{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bOld);
			throw new Exception("事务处理失败！"+e.getMessage());
		}
	}
%>

<script language=javascript>
    self.returnValue="true";
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>

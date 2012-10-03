<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xxge 2004-11-25
 * Tester:
 *
 * Content:  ����ָ����ͬ�Ĳ����ʲ�������
 * Input Param:
 *	SerialNo	����ͬ��ˮ��
 *	RecoveryUserID	: �ƽ�����
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	 //��ͬ��ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,request.getParameter("SerialNo"));  
	//ԭ�ƽ����͡����ƽ�����	
	String sOldShiftType = DataConvert.toRealString(iPostChange,request.getParameter("OldShiftType")); 
	String sShiftType = DataConvert.toRealString(iPostChange,request.getParameter("ShiftType")); 
	String sSql = "";
	
	//ѡ����ѡ��ͬ��ԭ�ƽ�����
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
			//���¶�Ӧ��ͬ���ƽ�����
	        sSql= " UPDATE BUSINESS_CONTRACT "+
	              " SET ShiftType='"+sShiftType+"' "+
	              " WHERE  SerialNo='" + sSerialNo + "'";   
		   	Sqlca.executeSQL(sSql);
		    	
		    String sSql1 = "";
		    	
		    //��SHIFTCHANGE_INFO���в����ƽ����ͱ����¼
			String sSerialNo1 = DBFunction.getSerialNo("SHIFTCHANGE_INFO","SerialNo",Sqlca);
	        sSql1= " insert into SHIFTCHANGE_INFO(SerialNo,ContractNo,OldShift,NewShift,InputUserID,InputOrgID,InputDate) "+
			       " values('"+sSerialNo1+"','"+sSerialNo+"','"+sOldShift+"','"+sShiftType+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+ StringFunction.getToday() + "')"; 
		   	Sqlca.executeSQL(sSql1);
		   			   	
		   	if(sOldShiftType.equals("020")) //����ǿͻ��ƽ���������ƽ�
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
					//��Trace_Info��������
					String sSerialNo2 = DBFunction.getSerialNo("Trace_Info","SerialNo",Sqlca);
			        sSql= " Insert into TRACE_INFO(SerialNo,ContractNo,TraceUserid,TraceOrgid,InputUserID,InputOrgID,InputDate) "+
			        	  " Values('"+sSerialNo2+"','"+sSerialNo+"','"+sRecoveryUserid+"','"+sRecoveryOrgid+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+ StringFunction.getToday() + "') ";
			       	Sqlca.executeSQL(sSql);
				  }
			      rs1.getStatement().close();
		   	}
		 	
		 	//�����ύ
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(bOld);
		}catch(Exception e)
		{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bOld);
			throw new Exception("������ʧ�ܣ�"+e.getMessage());
		}
	}
%>

<script language=javascript>
    self.returnValue="true";
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>

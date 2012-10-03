<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  xhyong 2012/02/17
 * Tester:
 *
 * Content: Ԥ�����̳�ʼ��
 * Input Param:
 * 			 SerialNo��������

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
    //��ȡ������
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
    
    String sFlag="";
    String sSql="";
	//�����������ѯ�����
	ASResultSet rs = null;
	int iCount = 0;
	sSql = "select count(1) "+
    " from RISK_SIGNAL where RelativeSerialNo ='"+sSerialNo+"'";

	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		iCount=rs.getInt(1);
	}
	rs.getStatement().close();
	if(iCount<1)
	{
	   	//������ʼ	
	    boolean bOld = Sqlca.conn.getAutoCommit();
	    Sqlca.conn.setAutoCommit(false);
	    try{
				Sqlca.executeSQL("update FLOW_TASK set EndTime=null,PhaseAction=null  where ObjectNo = '"+sSerialNo+"' and ObjectType = 'RiskSignalApply' and  PhaseNo='0010' ");
				Sqlca.executeSQL("delete from  FLOW_TASK where ObjectNo = '"+sSerialNo+"' and ObjectType = 'RiskSignalApply' and  PhaseNo<>'0010' ");
				Sqlca.executeSQL("update FLOW_OBJECT set PhaseNo='0010',PhaseType='1010',PhaseName='����ͻ�������Ԥ��' where ObjectNo = '"+sSerialNo+"' and ObjectType = 'RiskSignalApply'  ");
				Sqlca.executeSQL("update RISK_SIGNAL set signalstatus='10' where SerialNo = '"+sSerialNo+"'  ");
				Sqlca.executeSQL("delete from risksignal_opinion where objectno='"+sSerialNo+"'  ");
			
			//�����ύ
	        Sqlca.conn.commit();
	        Sqlca.conn.setAutoCommit(bOld);
	        sFlag="00";
		}catch(Exception e)
		{
			sFlag="99";
			//����ʧ�ܻع�
	        Sqlca.conn.rollback();
	        Sqlca.conn.setAutoCommit(bOld);
			throw new Exception("�����ʼ����"+e.getMessage());
		}
	}else
	{
		sFlag="���ڽ�������Ѿ����,���ܳ�ʼ��!";
	}
%>

<script language=javascript>
	self.returnValue = "<%=sFlag%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>
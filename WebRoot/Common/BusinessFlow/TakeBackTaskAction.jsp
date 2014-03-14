<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: CChang 2003.8.28
 * Tester:
 *
 * Content: ��ʾ��һ�׶���Ϣ 
 * Input Param:
 * 				SerialNo��	��ǰ�������ˮ��
 * Output param:
 *				sReturnValue:	����ֵCommit��ʾ��ɲ���
 * History Log: 2003-12-2:cwzhan
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.lmt.baseapp.flow.*" %>
<%
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));//���ϸ�ҳ��õ������������ˮ��
	String sReturnMessage = "";//ִ�к󷵻ص���Ϣ
	String sSql = "";
    String sObjectNo = "";
    String sObjectType = "";
    boolean hasContract = false;
    String sTakeBackFlag = "";
    ASResultSet rs = null;
    
    //����������ˮ�Ż�ö������ͺͶ�����
    sSql = "select ObjectType,ObjectNo from FLOW_TASK where SerialNo='"+ sSerialNo +"' ";
    rs = Sqlca.getASResultSet(sSql);
    if(rs.next())
    {
        sObjectType = DataConvert.toString(rs.getString("ObjectType"));
        sObjectNo = DataConvert.toString(rs.getString("ObjectNo"));
        //����ֵת��Ϊ���ַ���
        if(sObjectType == null) sObjectType = "";
        if(sObjectNo == null) sObjectNo = "";
    }
    rs.getStatement().close();
    
    //�����ջ�ʱ�����жϸ������Ƿ��Ѿ��Ǽ��������������������������ջ�
    if(sObjectType.equals("CreditApply"))
    {
    	sSql = " select SerialNo from BUSINESS_APPROVE where RelativeSerialNo = '"+ sObjectNo +"' ";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
        {
            hasContract = true;
            sReturnMessage = "�ñ������Ѿ��Ǽ���������������������ջأ�";
            sTakeBackFlag = "hasApprove";
        }
        rs.getStatement().close();
    }
    
    //��������������ջز��������жϸñ�������������Ƿ��Ѿ�ǩ���˺�ͬ������������ջ�
    if(sObjectType.equals("ApproveApply"))
    {
        sSql = " select SerialNo from BUSINESS_CONTRACT where RelativeSerialNo = '"+ sObjectNo +"' ";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
        {
            hasContract = true;
            sReturnMessage = "�ñ�������������Ѿ�ǩ����ͬ�������ջأ�";
            sTakeBackFlag = "hasContract";
        }
        rs.getStatement().close();
    }

    if(hasContract == false)
    {       
        FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);//��ʼ���������
        ftBusiness.takeBack(CurUser);//ִ���˻ز���
        sReturnMessage = ftBusiness.takeBack(CurUser).ReturnMessage;	
        if (sReturnMessage.equals("�ջ����"))
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
<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:      ndeng 2005.02.01
 * Tester:
 *
 * Content: 	������õȼ��ļ���ȷ�����µ�ֵ
 * Input Param:
 *			        sCognResult:ѡ�����õȼ�����
 *                  sCognLevel���϶��˼���
 * Output param:
 * History Log:   
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<% 
    //�������
    //֮ǰ��ֵ
    String sCurResult = "";
    String sCurLevel = "";  
    String sCurSortNo = ""; 
    //ȷ����ֵ
    String sResult = "";
    String sLevel = ""; 
    //�Ƿ���Ҫ����
    boolean isUpdate = true;
    String sCognSortNo = "";
    
    //��ȡҳ�����
    String sObjectNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
    String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sAccountMonth  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
    //�϶���ֵ
    String sCognResult   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CognResult"));
    String sCognLevel  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CognLevel"));
            
    //�õ��û���ǰ���õȼ�
    String sSql = "select CreditLevel,EvaluateLevel from ENT_INFO where CustomerID='"+sObjectNo+"'";
    ASResultSet rs = Sqlca.getResultSet(sSql);
    if(rs.next())
    {
        sCurResult = rs.getString("CreditLevel");
        sCurLevel = rs.getString("EvaluateLevel");
    }
    rs.getStatement().close();
    
    //�����ǰ�û���û���������õȼ�ֱ�Ӹ���
    if(sCurResult==null || sCurLevel==null) 
    {
        sResult=sCognResult;
        sLevel=sCognLevel;
    }else
    {
        //ͨ���ͻ����õȼ��ҵ���Ӧ��sortno
        String sSql0="select SortNo from CODE_LIBRARY where CodeNo = 'CreditLevel' and ItemName = '"+sCognResult+"'";
        ASResultSet rs0 = Sqlca.getResultSet(sSql0);
        if(rs0.next())
        {
            sCognSortNo = rs0.getString("sortno");
        }
        rs0.getStatement().close();
        
        //ͨ���õ��Ŀͻ���ǰ���õȼ��õ���Ӧ��sortno
        String sSql2 = "select sortno from code_library where codeno = 'CreditLevel' and itemname = '"+sCurResult+"'";
        ASResultSet rs2 = Sqlca.getResultSet(sSql2);
        if(rs2.next())
        {
            sCurSortNo = rs2.getString("sortno");
        }
        rs2.getStatement().close();
        
        //�Ƚϵõ���sortno���϶��˵ļ���
        //�϶��ļ������ǰ������£��������ǰ��Ҫ�ж��϶��˵ļ��𣬼���������
        if(sCognSortNo.compareTo(sCurSortNo)<=0) 
        {
            if(sCognLevel.compareTo(sCurLevel)<=0)
            {
                sResult=sCognResult;
                sLevel=sCognLevel;
            }else
            {
                isUpdate = false;//����ִ��Update���
            }
        }else
        {
            sResult=sCognResult;
            sLevel=sCognLevel;
        }
    }
    if(isUpdate)
    {
        String sSql3 = "select UR.UserID from USER_ROLE UR,USER_INFO UI where UR.UserID = UI.UserID and UR.RoleID = '442' and UI.BelongOrg = '"+CurOrg.OrgID+"'";
        ASResultSet rs3 = Sqlca.getResultSet(sSql3);
        if(!rs3.next())
        {
            Sqlca.executeSQL("update EVALUATE_RECORD set FinishDate4='"+StringFunction.getToday()+"' where SerialNo='"+sSerialNo+"'");
        }
        rs3.getStatement().close();
        
        String sSql1="update ENT_INFO set CreditLevel = '"+sResult+"',EvaluateLevel='"+sLevel+
                "',EvaluateDate = '"+sAccountMonth+"' where CustomerID = '"+sObjectNo+"'";
        Sqlca.executeSQL(sSql1);
    }
%>
<script language=javascript>     
    self.close();
</script>		
<%@ include file="/IncludeEnd.jsp"%>
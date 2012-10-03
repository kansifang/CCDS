<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:      ndeng 2005.02.01
 * Tester:
 *
 * Content: 	检查信用等级的级别确定更新的值
 * Input Param:
 *			        sCognResult:选定信用等级级别
 *                  sCognLevel：认定人级别
 * Output param:
 * History Log:   
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<% 
    //定义变量
    //之前的值
    String sCurResult = "";
    String sCurLevel = "";  
    String sCurSortNo = ""; 
    //确定的值
    String sResult = "";
    String sLevel = ""; 
    //是否需要更新
    boolean isUpdate = true;
    String sCognSortNo = "";
    
    //获取页面参数
    String sObjectNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
    String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sAccountMonth  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
    //认定的值
    String sCognResult   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CognResult"));
    String sCognLevel  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CognLevel"));
            
    //得到用户当前信用等级
    String sSql = "select CreditLevel,EvaluateLevel from ENT_INFO where CustomerID='"+sObjectNo+"'";
    ASResultSet rs = Sqlca.getResultSet(sSql);
    if(rs.next())
    {
        sCurResult = rs.getString("CreditLevel");
        sCurLevel = rs.getString("EvaluateLevel");
    }
    rs.getStatement().close();
    
    //如果当前用户还没有评定信用等级直接更新
    if(sCurResult==null || sCurLevel==null) 
    {
        sResult=sCognResult;
        sLevel=sCognLevel;
    }else
    {
        //通过客户信用等级找到相应的sortno
        String sSql0="select SortNo from CODE_LIBRARY where CodeNo = 'CreditLevel' and ItemName = '"+sCognResult+"'";
        ASResultSet rs0 = Sqlca.getResultSet(sSql0);
        if(rs0.next())
        {
            sCognSortNo = rs0.getString("sortno");
        }
        rs0.getStatement().close();
        
        //通过得到的客户当前信用等级得到相应的sortno
        String sSql2 = "select sortno from code_library where codeno = 'CreditLevel' and itemname = '"+sCurResult+"'";
        ASResultSet rs2 = Sqlca.getResultSet(sSql2);
        if(rs2.next())
        {
            sCurSortNo = rs2.getString("sortno");
        }
        rs2.getStatement().close();
        
        //比较得到的sortno和认定人的级别
        //认定的级别比以前低则更新，级别比以前高要判断认定人的级别，级别高则更新
        if(sCognSortNo.compareTo(sCurSortNo)<=0) 
        {
            if(sCognLevel.compareTo(sCurLevel)<=0)
            {
                sResult=sCognResult;
                sLevel=sCognLevel;
            }else
            {
                isUpdate = false;//不用执行Update语句
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
<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   hxli 2005-8-17
 * Tester:
 *
 * Content:   额度项下业务转移动作
 * Input Param:
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//获取页面参数
	String sSerialNo    = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 
	String sLineID      = DataConvert.toRealString(iPostChange,CurPage.getParameter("LineID"));
	//将空值转化为空字符串	
	if(sSerialNo==null) sSerialNo="";
	if(sLineID==null) sLineID="";
	
	//定义变量
	String sSql="";
	String sSerialNo1[]=sSerialNo.split(",");
	
	boolean bOld = Sqlca.conn.getAutoCommit(); 
	Sqlca.conn.setAutoCommit(false);
	try
	{	
		for(int m=0;m<sSerialNo1.length;m++)
		{
			sSql=" UPDATE BUSINESS_CONTRACT  SET CreditAggreement='"+sLineID+"'  WHERE  SerialNo='"+sSerialNo1[m]+"'";
			Sqlca.executeSQL(sSql);
		}
	
		//事物提交
		Sqlca.conn.commit();
		Sqlca.conn.setAutoCommit(bOld);
		%>
        <script language=javascript>	
            alert(getBusinessMessage('412'));//业务关联关系成功转移！
        </script>	
        <%
	}
	catch(Exception e)
	{
		//事物失败，数据回滚
		Sqlca.conn.rollback();
		Sqlca.conn.setAutoCommit(bOld);
		throw new Exception("事务处理失败！"+e.getMessage());
	}
%>

<script language=javascript>
        parent.close();   
</script>
<%@ include file="/IncludeEnd.jsp"%>

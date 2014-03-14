<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-09
 * Tester:
 *
 * Content: 
 *          同步数据库与缓存中的数据，调用ASConfigure.reloadConfig(sCacheName)
 *           
 * Input Param:
 *      ConfigName:		需要重新reload的缓存集市名称
 *      
 * Output param:
 *
 * History Log:  
 */%>
<!--使用实例
    sReturn = popPage("/Common/ToolsB/reloadCacheConfig.jsp?ConfigName="+sCacheName,"","dialogWidth=15;dialogHeight=8;center:yes;status:no;statusbar:no");
    if (typeof(sReturn3)== 'undefined' || sReturn3.length == 0) 
    {
        return;
    }else if (sReturn3 == 1) //成功 
    {
        ......;    
    }else if (sReturn3 == 2) //失败
    {
        ......;
    }
-->

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>同步缓存</title>
<%
	String sReturn = "1";
		try{
	ASConfigure.clearXDoc(application);
		}catch(Exception er){
	out.println("清空缓存失败："+er);
	sReturn = "2";
	throw er;
		}
%>

<script language=javascript >
	self.returnValue = "<%=sReturn%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>

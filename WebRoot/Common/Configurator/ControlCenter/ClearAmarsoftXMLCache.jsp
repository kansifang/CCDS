<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-09
 * Tester:
 *
 * Content: 
 *          ͬ�����ݿ��뻺���е����ݣ�����ASConfigure.reloadConfig(sCacheName)
 *           
 * Input Param:
 *      ConfigName:		��Ҫ����reload�Ļ��漯������
 *      
 * Output param:
 *
 * History Log:  
 */%>
<!--ʹ��ʵ��
    sReturn = popPage("/Common/ToolsB/reloadCacheConfig.jsp?ConfigName="+sCacheName,"","dialogWidth=15;dialogHeight=8;center:yes;status:no;statusbar:no");
    if (typeof(sReturn3)== 'undefined' || sReturn3.length == 0) 
    {
        return;
    }else if (sReturn3 == 1) //�ɹ� 
    {
        ......;    
    }else if (sReturn3 == 2) //ʧ��
    {
        ......;
    }
-->

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>ͬ������</title>
<%
	String sReturn = "1";
		try{
	ASConfigure.clearXDoc(application);
		}catch(Exception er){
	out.println("��ջ���ʧ�ܣ�"+er);
	sReturn = "2";
	throw er;
		}
%>

<script language=javascript >
	self.returnValue = "<%=sReturn%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>

<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-17
 * Tester:
 *
 * Content: 计算损失率
 * Input Param:
 *           LossScope: Q-平均损失率
 *                      W-加权损失率
 * Output param:
 *           ReturnValue: 00-更新成功
 *                        
 *         
 * History Log: 
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>

<%@ include file="/IncludeBeginMD.jsp"%>

<%
	String sLossScope = DataConvert.toRealString(iPostChange,(String)request.getParameter("LossScope"));//借据编号
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)request.getParameter("AccountMonth"));//会计月份
	
	String sReturnValue="";
	if(sLossScope==null) sLossScope = "";
    ASResultSet rs=null;
	try{
	    com.amarsoft.ReserveManage.ReservePara rp = new com.amarsoft.ReserveManage.ReservePara(Sqlca);
	    ArrayList al = rp.getAandBLossRate(sAccountMonth,"A", sLossScope);
	    for(int i =0; i< al.size(); i++){
	       System.out.println(al.get(i));
	       sReturnValue = sReturnValue + al.get(i) + "@";
	    }
	    sReturnValue = sReturnValue.substring(0, sReturnValue.length()-1);
    }catch(Exception ex){
	   sReturnValue = "01";
	   System.out.println(ex.getMessage());
	}
%>
<script language=javascript>
    self.returnValue = "<%=sReturnValue%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>
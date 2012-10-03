<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-15
 * Tester:
 *
 * Content: 检查录入预测现金流前，必须先上传附件
 * Input Param:
 *         
 * Output param:
 *          00-有附件
 *          
 *          01-缺少附件
 *          02-数据库出错
 * History Log:

 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sReturnValue="00";
	if(sObjectNo==null) sObjectNo = "";
	try
	{
	   //判断该笔贷款是否是损失贷款,，如果是损失类贷款，不预测现金流
	   boolean bPredict = true;
       String selSql = "select MClassifyResult,AClassifyResult from reserve_record where serialno = '" + sObjectNo + "'";
       ASResultSet rsSel = Sqlca.getASResultSet(selSql);
       if(rsSel.next()){
          String sMClassifyResult = rsSel.getString("MClassifyResult") == null ? "" : rsSel.getString("MClassifyResult");
          String sAClassifyResult = rsSel.getString("AClassifyResult") == null ? "" : rsSel.getString("AClassifyResult");
          if(sMClassifyResult.equals("05")&& sAClassifyResult.equals("05")){
             bPredict = false;
          }
       }
       rsSel.getStatement().close();
	
      //查看是否有工作底稿
      if(bPredict){
	    String sSelSql = " select count(*) from doc_attachment1 DA "+
			    " where DA.DOCno = '"+sObjectNo+"' " ;
		  ASResultSet rs = Sqlca.getASResultSet(sSelSql);
		  if(rs.next()){
			  if(rs.getInt(1)==0) sReturnValue = "01";
		  }
		  rs.getStatement().close();
	  }
    }catch(Exception ex){
	    sReturnValue = "02";
		System.out.println(ex.getMessage());
	}
%>
<script language=javascript>
    self.returnValue = "<%=sReturnValue%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>
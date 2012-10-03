<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   slliu 2004-11-22
 * Tester:
 *
 * Content: 
 * Global Param:
 *	
 *	
 * 
 * Input Param:
 *	ContractNo：合同流水号
 *	
 * Output param:
 *       
 *       
 * History Log:  
 *
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//获得页面参数
	//合同流水号
	String sContractNo = DataConvert.toRealString(iPostChange,request.getParameter("ContractNo")); 
	
	//标志；Flag=ReformScheme重组方案详情、Flag=ReformApply重组申请详情
	String sFlag = DataConvert.toRealString(iPostChange,request.getParameter("Flag")); 
	
	String sSql="";
	 
	ASResultSet rs;
  
  	if(sFlag.equals("ReformScheme")) //重组方案详情
  	{
      		sSql = " select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType"+
	      		" from BUSINESS_APPLY BA,APPLY_RELATIVE AR "+
	      		" where  BA.SerialNo = AR.SerialNo "+
	      		" and AR.ObjectNo ='"+sContractNo+"' "+
	      		" and AR.ObjectType='BusinessContract' ";
		      	
	        	rs = Sqlca.getASResultSet(sSql); 
	        	if(rs.next())
	 		{
	 			//获得申请流水号、申请类型（一般重组、还是扩盘重组）
	 			 String sSerialNo = DataConvert.toString(rs.getString("SerialNo"));		
		        	 String sApplyType = DataConvert.toString(rs.getString("ApplyType"));
		        	 
	%>	        		 
				<script language=javascript>
					self.returnValue="<%=sSerialNo%>"+"@"+"<%=sApplyType%>"; //返回申请号、申请类型
					self.close();    
				</script>
	<%
	 		}
	 	rs.getStatement().close(); 
	 }
	
	 if(sFlag.equals("ReformApply")) //重组贷款详情
  	{
      		sSql = " select ObjectNo "+
	      		" from CONTRACT_RELATIVE  "+
	      		" where  SerialNo = '"+sContractNo+"' "+
	      		" and ObjectType='CreditApply' ";
		      	
	        	rs = Sqlca.getASResultSet(sSql); 
	        	if(rs.next())
	 		{
	 			//获得申请流水号
	 			 String sObjectNo = DataConvert.toString(rs.getString("ObjectNo"));		
		        	
	%>	        		 
				<script language=javascript>
					self.returnValue="<%=sObjectNo%>"; //返回申请号
					self.close();    
				</script>
	<%
	 		}
	 	rs.getStatement().close(); 
	 }
 	 
 
 %>
<%@ include file="/IncludeEnd.jsp"%>

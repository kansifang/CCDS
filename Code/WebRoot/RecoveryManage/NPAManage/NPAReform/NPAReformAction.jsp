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
 *	ContractNo����ͬ��ˮ��
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
	//���ҳ�����
	//��ͬ��ˮ��
	String sContractNo = DataConvert.toRealString(iPostChange,request.getParameter("ContractNo")); 
	
	//��־��Flag=ReformScheme���鷽�����顢Flag=ReformApply������������
	String sFlag = DataConvert.toRealString(iPostChange,request.getParameter("Flag")); 
	
	String sSql="";
	 
	ASResultSet rs;
  
  	if(sFlag.equals("ReformScheme")) //���鷽������
  	{
      		sSql = " select BA.SerialNo as SerialNo,BA.ApplyType as ApplyType"+
	      		" from BUSINESS_APPLY BA,APPLY_RELATIVE AR "+
	      		" where  BA.SerialNo = AR.SerialNo "+
	      		" and AR.ObjectNo ='"+sContractNo+"' "+
	      		" and AR.ObjectType='BusinessContract' ";
		      	
	        	rs = Sqlca.getASResultSet(sSql); 
	        	if(rs.next())
	 		{
	 			//���������ˮ�š��������ͣ�һ�����顢�����������飩
	 			 String sSerialNo = DataConvert.toString(rs.getString("SerialNo"));		
		        	 String sApplyType = DataConvert.toString(rs.getString("ApplyType"));
		        	 
	%>	        		 
				<script language=javascript>
					self.returnValue="<%=sSerialNo%>"+"@"+"<%=sApplyType%>"; //��������š���������
					self.close();    
				</script>
	<%
	 		}
	 	rs.getStatement().close(); 
	 }
	
	 if(sFlag.equals("ReformApply")) //�����������
  	{
      		sSql = " select ObjectNo "+
	      		" from CONTRACT_RELATIVE  "+
	      		" where  SerialNo = '"+sContractNo+"' "+
	      		" and ObjectType='CreditApply' ";
		      	
	        	rs = Sqlca.getASResultSet(sSql); 
	        	if(rs.next())
	 		{
	 			//���������ˮ��
	 			 String sObjectNo = DataConvert.toString(rs.getString("ObjectNo"));		
		        	
	%>	        		 
				<script language=javascript>
					self.returnValue="<%=sObjectNo%>"; //���������
					self.close();    
				</script>
	<%
	 		}
	 	rs.getStatement().close(); 
	 }
 	 
 
 %>
<%@ include file="/IncludeEnd.jsp"%>

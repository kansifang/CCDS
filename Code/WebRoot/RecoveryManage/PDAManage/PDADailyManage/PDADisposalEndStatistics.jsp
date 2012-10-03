<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   FSGong 2004-12-16
 * Tester:
 *
 * Content:  
 * Input Param:
 *		ObjectNo�������� 
 *		ObjectType: ��������
 * Output param	��ͳ�ƽ����
 *
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo")); //�ʲ���ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	
	//�������
	String sSql = "";
	double  dSum1 = 0;//ͳ���ۼƳ�����ս��
	double  dSum2 = 0;//ͳ���ۼƳ��ۻ��ս��
	double  dSum3 = 0;//ͳ���ۼƷ���֧���ܶ�
	double  dSum4 = 0;//ͳ�ƴ�������
	ASResultSet rs = null;

 	//ͳ���ۼƳ�����ս��:�����
	sSql = 	" select sum(RMBSum) as my_Sum  from RECLAIM_INFO "+
			" where  ObjectNo = '"+sObjectNo+"' "+
			" and ObjectType = '"+sObjectType+"' "+
			" and CashBackType = '01' ";
	rs = Sqlca.getASResultSet(sSql);
	if (rs.next())
		dSum1=rs.getDouble(1);	
	rs.getStatement().close(); 
 	
 	//ͳ���ۼƳ��ۻ��ս��:�����
	sSql = 	" select sum(RMBSum) as my_Sum  from RECLAIM_INFO "+
			" where ObjectNo = '"+sObjectNo+"' "+
			" and ObjectType = '"+sObjectType+"' "+
			" and CashBackType in ('02','03','04','05') ";
	rs = Sqlca.getASResultSet(sSql);
	if (rs.next())
		dSum2=rs.getDouble(1);
	rs.getStatement().close(); 
 	
 	//ͳ���ۼƷ���֧���ܶ�:�����
	sSql = 	" select sum(CostSum) as my_Sum from COST_INFO "+
			" where  ObjectNo = '"+ sObjectNo+"' "+
			" and ObjectType = '"+sObjectType+"' "+
			" and AccountDesc <> '02' ";//��������ΪӪҵ��֧���ķ���.
	rs = Sqlca.getASResultSet(sSql);
	if (rs.next())
	  	dSum3=rs.getDouble(1);
	rs.getStatement().close(); 

   	//ͳ�ƴ�������
	dSum4=dSum1+dSum2-dSum3;	
%>


<script language=javascript>
   self.returnValue = "<%=dSum1%>"+"@"+"<%=dSum2%>"+"@"+"<%=dSum3%>"+"@"+"<%=dSum4%>";
   self.close();    
</script>


<%@ include file="/IncludeEnd.jsp"%>
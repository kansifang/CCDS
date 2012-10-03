
<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   zywei 2005/09/09
 * Tester:
 *
 * Content:   �����ʲ����շ�����Ϣ
 * Input Param:
 *		AccountMonth������·�
 *		ObjectType����������
 *		ObjectNo��������
 *		ModelNo��ģ�ͺ�
 * Output param:
 * History Log:  
 *	      
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.lending.bizlets.InitializeFlow" %>
<%@page import="com.amarsoft.app.lending.bizlets.Classify_TJNH" %>
<%
	//���������Sql���
	String sSql = "";
	//���������������ˮ��
	String sSerialNo = "";
	//������������
	double dBalance = 0.0;
	//�����������ѯ�����
	ASResultSet rs = null;
	
	//��ȡҳ�����������·ݡ��������͡������š����͡�ģ�ͺ�
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo")); 
	String sLockClassifyResult = "";
	//����ֵת��Ϊ���ַ���
	if(sAccountMonth == null) sAccountMonth = ""; 
	if(sObjectType == null) sObjectType = ""; 
	if(sObjectNo == null) sObjectNo = ""; 
	if(sType == null) sType = ""; 
	if(sModelNo == null) sModelNo = ""; 
	
	//���ݶ����������������
	String sTableName = "";
	if(sObjectType.equals("BusinessContract"))
	{
		sTableName = "BUSINESS_CONTRACT";
	}			
	if(sObjectType.equals("BusinessDueBill"))
	{
		sTableName = "BUSINESS_DUEBILL";
	}
	
	boolean bOld = Sqlca.conn.getAutoCommit(); 
	Sqlca.conn.setAutoCommit(false);
	try
	{	
		
		//�������������
		if(sType.equals("Batch"))
		{
			sSql = 	" select SerialNo,nvl(Balance,0) as Balance "+
					" from "+sTableName+" "+
					" where not exists (select 1 "+
					" from CLASSIFY_RECORD "+
					" where ObjectType = '"+sObjectType+"' "+
					" and AccountMonth = '"+sAccountMonth+"' and ObjectNo="+sTableName+".SerialNo) "+
					" and Balance > 0 ";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
			{
				sObjectNo = rs.getString("SerialNo");
				dBalance = rs.getDouble("Balance");
				//����ʲ����շ�����ˮ��
				sSerialNo = DBFunction.getSerialNo("CLASSIFY_RECORD","SerialNo",Sqlca);
				//�����ʲ����շ�����Ϣ	
				sSql = 	" insert into CLASSIFY_RECORD(SerialNo,ObjectType,ObjectNo,AccountMonth,ModelNo,"+
					   	" BusinessBalance,Sum1,Sum2,Sum3,Sum4,Sum5,UserID,OrgID,InputDate,ClassifyDate,UpdateDate)"+		
					   	" values('"+sSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sAccountMonth+"','"+sModelNo+"',"+dBalance+","+
					   	" 0.00,0.00,0.00,0.00,0.00,'"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"',"+
					   	" '"+StringFunction.getToday()+"') ";			
				Sqlca.executeSQL(sSql);		    	
		//delete by xhyong ���ý���ģ�ͷ��� 				
				//sSql = 	" insert into CLASSIFY_DATA(ObjectType,ObjectNo,SerialNo,ItemNo) " + 
				//		" select '"+sObjectType+"','"+sObjectNo+"','"+sSerialNo+"'," +   
		        //		" ItemNo from EVALUATE_MODEL where ModelNo = '"+sModelNo+"' ";
				//Sqlca.executeSQL(sSql);
		//delete end 
				//add by xhyong 2009/08/19 ���շ��������
				InitializeFlow InitializeFlow_ContractClassify = new InitializeFlow();
				InitializeFlow_ContractClassify.setAttribute("ObjectType","ClassifyApply");
				InitializeFlow_ContractClassify.setAttribute("ObjectNo",sSerialNo); 
				InitializeFlow_ContractClassify.setAttribute("ApplyType","ClassifyApply");//���õȼ�����ģ����
				InitializeFlow_ContractClassify.setAttribute("FlowNo","ClassifyFlow");
				InitializeFlow_ContractClassify.setAttribute("PhaseNo","0010");
				InitializeFlow_ContractClassify.setAttribute("UserID",CurUser.UserID);
				InitializeFlow_ContractClassify.setAttribute("OrgID",CurUser.OrgID);
				InitializeFlow_ContractClassify.run(Sqlca);
				//add end 
			}
			rs.getStatement().close();			
		}else
		{
			//��ѯ��ͬ/��ݵ����
			sSql = 	" select Balance "+
					" from "+sTableName+" "+
					" where SerialNo = '"+sObjectNo+"' ";					
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				dBalance = rs.getDouble("Balance");
	
			rs.getStatement().close();
			
			//����ʲ����շ�����ˮ��
			//��ѯ���·��շ����Ƿ��м�¼
			sSql = 	" select SerialNo "+
					" from CLASSIFY_RECORD "+
					" where ObjectType = '"+sObjectType+"' "+
					" and AccountMonth = '"+sAccountMonth+"' and ObjectNo='"+sObjectNo+"' "
					;					
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				sSerialNo = rs.getString("SerialNo");
			rs.getStatement().close();

			//���û��������
			if(sSerialNo.equals("")||sSerialNo == null)
			{
				sLockClassifyResult = Sqlca.getString("select LockClassifyResult from business_contract where serialno ='"+sObjectNo+"'");
				if(sLockClassifyResult == null) sLockClassifyResult = "";
				if(sLockClassifyResult.equals("")){
					Classify_TJNH CT = new Classify_TJNH();
					CT.setAttribute("SerialNo",sObjectNo);
					String[] sReturn = ((String)CT.run(Sqlca)).split(",");
					String sReturn1 = sReturn[0];//���ֽ��
					String sResultOpinion1 = sReturn[1]; //�������
					sSerialNo = DBFunction.getSerialNo("CLASSIFY_RECORD","SerialNo","CR",Sqlca);
					//�����ʲ����շ�����Ϣ	
					sSql = 	" insert into CLASSIFY_RECORD(SerialNo,ObjectType,ObjectNo,AccountMonth,ModelNo,"+
						   	" BusinessBalance,Sum1,Sum2,Sum3,Sum4,Sum5,UserID,OrgID,InputDate,ClassifyDate,UpdateDate,Result1,ResultOpinion1)"+		
						   	" values('"+sSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sAccountMonth+"','"+sModelNo+"',"+dBalance+","+
						   	" 0.00,0.00,0.00,0.00,0.00,'"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"',"+
						   	" '"+StringFunction.getToday()+"','"+sReturn1+"','"+sResultOpinion1+"') ";			
					Sqlca.executeSQL(sSql);
				}	
			}
		//delete by xhyong ���ý���ģ�ͷ���     				
			//sSql = 	" insert into CLASSIFY_DATA(ObjectType,ObjectNo,SerialNo,ItemNo) " + 
					//" select '"+sObjectType+"','"+sObjectNo+"','"+sSerialNo+"'," +   
	        		//" ItemNo from EVALUATE_MODEL where ModelNo = '"+sModelNo+"' ";
			//Sqlca.executeSQL(sSql);
		//delete end
			//add by xhyong 2009/08/19 ���շ��������
			if(sLockClassifyResult.equals("")){
				InitializeFlow InitializeFlow_ContractClassify = new InitializeFlow();
				InitializeFlow_ContractClassify.setAttribute("ObjectType","ClassifyApply");
				InitializeFlow_ContractClassify.setAttribute("ObjectNo",sSerialNo); 
				InitializeFlow_ContractClassify.setAttribute("ApplyType","ClassifyApply");//���õȼ�����ģ����
				InitializeFlow_ContractClassify.setAttribute("FlowNo","ClassifyFlow");
				InitializeFlow_ContractClassify.setAttribute("PhaseNo","0010");
				InitializeFlow_ContractClassify.setAttribute("UserID",CurUser.UserID);
				InitializeFlow_ContractClassify.setAttribute("OrgID",CurUser.OrgID);
				InitializeFlow_ContractClassify.run(Sqlca);
			}	
			//add end
		}
		//�����ύ
		Sqlca.conn.commit();
		Sqlca.conn.setAutoCommit(bOld);
	}catch(Exception e)
	{
		//����ʧ�ܣ����ݻع�
		Sqlca.conn.rollback();
		Sqlca.conn.setAutoCommit(bOld);
		throw new Exception("������ʧ�ܣ�"+e.getMessage());
	}    	
%>

<script language=javascript>
	if(!"<%=sLockClassifyResult%>"==""){
		self.returnValue = "1";
	}else{
	    self.returnValue = "<%=sSerialNo%>";
	} 
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>

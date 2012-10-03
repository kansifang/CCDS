
<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   zywei 2005/09/09
 * Tester:
 *
 * Content:   新增资产风险分类信息
 * Input Param:
 *		AccountMonth：会计月份
 *		ObjectType：对象类型
 *		ObjectNo：对象编号
 *		ModelNo：模型号
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
	//定义变量：Sql语句
	String sSql = "";
	//定义变量：分类流水号
	String sSerialNo = "";
	//定义变量：余额
	double dBalance = 0.0;
	//定义变量：查询结果集
	ASResultSet rs = null;
	
	//获取页面参数：会计月份、对象类型、对象编号、类型、模型号
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo")); 
	String sLockClassifyResult = "";
	//将空值转化为空字符串
	if(sAccountMonth == null) sAccountMonth = ""; 
	if(sObjectType == null) sObjectType = ""; 
	if(sObjectNo == null) sObjectNo = ""; 
	if(sType == null) sType = ""; 
	if(sModelNo == null) sModelNo = ""; 
	
	//根据对象类型设置其表名
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
		
		//如果是批量分类
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
				//获得资产风险分类流水号
				sSerialNo = DBFunction.getSerialNo("CLASSIFY_RECORD","SerialNo",Sqlca);
				//新增资产风险分类信息	
				sSql = 	" insert into CLASSIFY_RECORD(SerialNo,ObjectType,ObjectNo,AccountMonth,ModelNo,"+
					   	" BusinessBalance,Sum1,Sum2,Sum3,Sum4,Sum5,UserID,OrgID,InputDate,ClassifyDate,UpdateDate)"+		
					   	" values('"+sSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sAccountMonth+"','"+sModelNo+"',"+dBalance+","+
					   	" 0.00,0.00,0.00,0.00,0.00,'"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"',"+
					   	" '"+StringFunction.getToday()+"') ";			
				Sqlca.executeSQL(sSql);		    	
		//delete by xhyong 不用进行模型分类 				
				//sSql = 	" insert into CLASSIFY_DATA(ObjectType,ObjectNo,SerialNo,ItemNo) " + 
				//		" select '"+sObjectType+"','"+sObjectNo+"','"+sSerialNo+"'," +   
		        //		" ItemNo from EVALUATE_MODEL where ModelNo = '"+sModelNo+"' ";
				//Sqlca.executeSQL(sSql);
		//delete end 
				//add by xhyong 2009/08/19 风险分类该流程
				InitializeFlow InitializeFlow_ContractClassify = new InitializeFlow();
				InitializeFlow_ContractClassify.setAttribute("ObjectType","ClassifyApply");
				InitializeFlow_ContractClassify.setAttribute("ObjectNo",sSerialNo); 
				InitializeFlow_ContractClassify.setAttribute("ApplyType","ClassifyApply");//信用等级评定模板编号
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
			//查询合同/借据的余额
			sSql = 	" select Balance "+
					" from "+sTableName+" "+
					" where SerialNo = '"+sObjectNo+"' ";					
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				dBalance = rs.getDouble("Balance");
	
			rs.getStatement().close();
			
			//获得资产风险分类流水号
			//查询当月风险分类是否有记录
			sSql = 	" select SerialNo "+
					" from CLASSIFY_RECORD "+
					" where ObjectType = '"+sObjectType+"' "+
					" and AccountMonth = '"+sAccountMonth+"' and ObjectNo='"+sObjectNo+"' "
					;					
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				sSerialNo = rs.getString("SerialNo");
			rs.getStatement().close();

			//如果没有则新增
			if(sSerialNo.equals("")||sSerialNo == null)
			{
				sLockClassifyResult = Sqlca.getString("select LockClassifyResult from business_contract where serialno ='"+sObjectNo+"'");
				if(sLockClassifyResult == null) sLockClassifyResult = "";
				if(sLockClassifyResult.equals("")){
					Classify_TJNH CT = new Classify_TJNH();
					CT.setAttribute("SerialNo",sObjectNo);
					String[] sReturn = ((String)CT.run(Sqlca)).split(",");
					String sReturn1 = sReturn[0];//初分结果
					String sResultOpinion1 = sReturn[1]; //初分意见
					sSerialNo = DBFunction.getSerialNo("CLASSIFY_RECORD","SerialNo","CR",Sqlca);
					//新增资产风险分类信息	
					sSql = 	" insert into CLASSIFY_RECORD(SerialNo,ObjectType,ObjectNo,AccountMonth,ModelNo,"+
						   	" BusinessBalance,Sum1,Sum2,Sum3,Sum4,Sum5,UserID,OrgID,InputDate,ClassifyDate,UpdateDate,Result1,ResultOpinion1)"+		
						   	" values('"+sSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sAccountMonth+"','"+sModelNo+"',"+dBalance+","+
						   	" 0.00,0.00,0.00,0.00,0.00,'"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"',"+
						   	" '"+StringFunction.getToday()+"','"+sReturn1+"','"+sResultOpinion1+"') ";			
					Sqlca.executeSQL(sSql);
				}	
			}
		//delete by xhyong 不用进行模型分类     				
			//sSql = 	" insert into CLASSIFY_DATA(ObjectType,ObjectNo,SerialNo,ItemNo) " + 
					//" select '"+sObjectType+"','"+sObjectNo+"','"+sSerialNo+"'," +   
	        		//" ItemNo from EVALUATE_MODEL where ModelNo = '"+sModelNo+"' ";
			//Sqlca.executeSQL(sSql);
		//delete end
			//add by xhyong 2009/08/19 风险分类该流程
			if(sLockClassifyResult.equals("")){
				InitializeFlow InitializeFlow_ContractClassify = new InitializeFlow();
				InitializeFlow_ContractClassify.setAttribute("ObjectType","ClassifyApply");
				InitializeFlow_ContractClassify.setAttribute("ObjectNo",sSerialNo); 
				InitializeFlow_ContractClassify.setAttribute("ApplyType","ClassifyApply");//信用等级评定模板编号
				InitializeFlow_ContractClassify.setAttribute("FlowNo","ClassifyFlow");
				InitializeFlow_ContractClassify.setAttribute("PhaseNo","0010");
				InitializeFlow_ContractClassify.setAttribute("UserID",CurUser.UserID);
				InitializeFlow_ContractClassify.setAttribute("OrgID",CurUser.OrgID);
				InitializeFlow_ContractClassify.run(Sqlca);
			}	
			//add end
		}
		//事物提交
		Sqlca.conn.commit();
		Sqlca.conn.setAutoCommit(bOld);
	}catch(Exception e)
	{
		//事物失败，数据回滚
		Sqlca.conn.rollback();
		Sqlca.conn.setAutoCommit(bOld);
		throw new Exception("事务处理失败！"+e.getMessage());
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

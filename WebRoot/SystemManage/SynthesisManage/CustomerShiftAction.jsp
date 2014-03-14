<%/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  zywei 2006.10.25
 * Tester:
 *
 * Content: 交接客户动作
 * Input Param:
 *			CustomerID：待交接的客户编号
 *			FromOrgID：交接前机构代码
 *			FromOrgName：交接前机构名称
 *          FromUserID：交接前客户经理代码
 *          FromUserName：交接前客户经理名称
 *          ToUserID：交接后客户经理代码
 *          ToUserName：交接后客户经理代码
 *			ChangeObject：修改对象
 * Output param:
 *
 *
 * History Log:  
 *				 
 *
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.lmt.app.lending.bizlets.*,com.amarsoft.biz.bizlet.Bizlet" %>


<%
	//获取参数：交接客户、交接前机构代码、交接前机构名称、交接前客户经理代码、交接前客户经理名称、交接后客户经理代码、交接后客户经理名称、修改对象
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));
	String sFromUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserID"));
	String sFromUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserName"));	
	String sToUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserID"));
	String sToUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserName"));
	String sChangeObject = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ChangeObject"));
	
    //变量定义   
    String sInputDate   = StringFunction.getToday();
    //交接后的机构代码和名称
    String sToOrgID = "",sToOrgName = "";
	ASResultSet rs = null; //查询结果集
	int iCount = 0; //记录数
	int i = 0;//计数器
    String sSql = ""; //SQL语句
    String sFlag = ""; //交接是否成功标志
    
    //交接日志信息
	String sChangeReason = "客户交接操作人员代码:"+CurUser.UserID+"   姓名："+CurUser.UserName+"   机构代码："+CurOrg.OrgID+"   机构名称："+CurOrg.OrgName;
    //判断是否有未审批通过的申请
    sSql = 	" select count(BA.SerialNo) "+
    		" from FLOW_OBJECT FB,BUSINESS_APPLY BA "+
    		" where BA.SerialNo = FB.ObjectNo "+
    		" and FB.ObjectType = 'CreditApply' "+
    		" and FB.UserID = '"+ sFromUserID +"' "+
    		" and BA.CustomerID = '"+sCustomerID+"' "+
    		" and FB.PhaseNo <> '1000' "+
    		" and FB.PhaseNo <> '8000' ";
    rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
      iCount=rs.getInt(1);
    }
    rs.getStatement().close();
    if(iCount==0)
    {		
		StringTokenizer st = new StringTokenizer(sChangeObject,"|");
	    String [] ChangeObject = new String[st.countTokens()];
		while (st.hasMoreTokens()) 
	    {
	        ChangeObject[i] = st.nextToken();                
	        i++;
	    } 	    
	            
        //查询交接后客户经理所在机构代码和名称
        sSql =  " select BelongOrg,getOrgName(BelongOrg) as BelongOrgName "+
	        	" from USER_INFO " +
	        	" where UserID = '"+sToUserID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
		    sToOrgID = DataConvert.toString(rs.getString("BelongOrg"));
		    sToOrgName = DataConvert.toString(rs.getString("BelongOrgName"));
		}
		rs.getStatement().close();
		
		//事务处理开始	
        boolean bOld = Sqlca.conn.getAutoCommit();
        Sqlca.conn.setAutoCommit(false);
        try
        {
           	for(int j = 0 ; j < ChangeObject.length ; j ++)
	    	{
	        	if(ChangeObject[j].equals("Customer")) //客户
	        	{
	        		Bizlet bzUpdateCustomerRelaInfo = new UpdateCustomerRelaInfo();
			bzUpdateCustomerRelaInfo.setAttribute("CustomerID",sCustomerID); 
			bzUpdateCustomerRelaInfo.setAttribute("FromUserID",sFromUserID);	
			bzUpdateCustomerRelaInfo.setAttribute("ToUserID",sToUserID);		
			bzUpdateCustomerRelaInfo.run(Sqlca);
	        	}else
	        	{
	        		Bizlet bzUpdateBusiness = new UpdateBusiness();
	        		if(ChangeObject[j].equals("Apply")) //申请
	        		{
	        			sSql = 	" select distinct SerialNo "+
	        					" from BUSINESS_APPLY "+
	        					" where CustomerID = '"+sCustomerID+"' "+
	        					" and (OperateUserID = '"+sFromUserID+"' "+
	        					" or InputUserID = '"+sFromUserID+"') ";
	        			rs = Sqlca.getASResultSet(sSql);
	        			while(rs.next())
	        			{
	        				bzUpdateBusiness.setAttribute("ObjectType","CreditApply");
	        				bzUpdateBusiness.setAttribute("ObjectNo",rs.getString(1));
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}
	        			rs.getStatement().close();
	        		}
	        		
	        		if(ChangeObject[j].equals("Approve")) //最终审批意见
	        		{
	        			sSql = 	" select distinct SerialNo "+
	        					" from BUSINESS_APPROVE "+
	        					" where CustomerID = '"+sCustomerID+"' "+
	        					" and (OperateUserID = '"+sFromUserID+"' "+
	        					" or InputUserID = '"+sFromUserID+"') ";
	        			rs = Sqlca.getASResultSet(sSql);
	        			while(rs.next())
	        			{
	        				bzUpdateBusiness.setAttribute("ObjectType","ApproveApply");
	        				bzUpdateBusiness.setAttribute("ObjectNo",rs.getString(1));
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}
	        			rs.getStatement().close();
	        		}
	        		
	        		if(ChangeObject[j].equals("Contract")) //合同
	        		{
	        			sSql = 	" select distinct SerialNo "+
	        					" from BUSINESS_CONTRACT "+
	        					" where CustomerID = '"+sCustomerID+"' "+
	        					" and (ManageUserID = '"+sFromUserID+"' "+
	        					" or OperateUserID = '"+sFromUserID+"' "+
	        					" or InputUserID = '"+sFromUserID+"') ";
	        			rs = Sqlca.getASResultSet(sSql);
	        			while(rs.next())
	        			{
	        				bzUpdateBusiness.setAttribute("ObjectType","BusinessContract");
	        				bzUpdateBusiness.setAttribute("ObjectNo",rs.getString(1));
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}
	        			rs.getStatement().close();
	        		}
	        		
	        		if(ChangeObject[j].equals("PutOut")) //出账
	        		{
	        			sSql = 	" select distinct SerialNo "+
	        					" from BUSINESS_PUTOUT "+
	        					" where CustomerID = '"+sCustomerID+"' "+
	        					" and (OperateUserID = '"+sFromUserID+"' "+
	        					" or InputUserID = '"+sFromUserID+"') ";
	        			rs = Sqlca.getASResultSet(sSql);
	        			while(rs.next())
	        			{
	        				bzUpdateBusiness.setAttribute("ObjectType","PutOutApply");
	        				bzUpdateBusiness.setAttribute("ObjectNo",rs.getString(1));
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}
	        			rs.getStatement().close();
	        		}
	        		
	        		if(ChangeObject[j].equals("DueBill")) //借据
	        		{
	        			sSql = 	" select distinct SerialNo "+
	        					" from BUSINESS_DUEBILL "+
	        					" where CustomerID = '"+sCustomerID+"' "+
	        					" and (OperateUserID = '"+sFromUserID+"' "+
	        					" or InputUserID = '"+sFromUserID+"') ";
	        			rs = Sqlca.getASResultSet(sSql);
	        			while(rs.next())
	        			{
	        				bzUpdateBusiness.setAttribute("ObjectType","BusinessDueBill");
	        				bzUpdateBusiness.setAttribute("ObjectNo",rs.getString(1));
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}
	        			rs.getStatement().close();
	        		}
	        	}
	        }
	        
            //在MANAGE_CHANGE表中插入记录，用于记录这次变更操作
            String sSerialNo =  DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca);
            sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
            		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
                    " VALUES('Customer','"+sCustomerID+"','"+sSerialNo+"','"+sFromOrgID+"','"+sFromOrgName+"','"+sToOrgID+"', "+
                    " '"+sToOrgName+"','"+sFromUserID+"','"+sFromUserName+"','"+sToUserID+"','"+sToUserName+"','"+sChangeReason+"', "+
                    " '"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sInputDate+"')";
            Sqlca.executeSQL(sSql);

	sFlag = "TRUE";
            //事务提交
            Sqlca.conn.commit();
            Sqlca.conn.setAutoCommit(bOld);
        }
        catch(Exception e)
        {
           	sFlag = "FALSE";
            //事务失败回滚
            Sqlca.conn.rollback();
            Sqlca.conn.setAutoCommit(bOld);
        }	
	}else
	{
		sFlag = "UNFINISHAPPLY";//存在在途申请
	}
%>
  

<script language=javascript>
	self.returnValue = "<%=sFlag%>";
    self.close();
</script>

  
<%@ include file="/IncludeEnd.jsp"%>
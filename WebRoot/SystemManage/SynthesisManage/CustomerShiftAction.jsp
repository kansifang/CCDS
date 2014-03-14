<%/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  zywei 2006.10.25
 * Tester:
 *
 * Content: ���ӿͻ�����
 * Input Param:
 *			CustomerID�������ӵĿͻ����
 *			FromOrgID������ǰ��������
 *			FromOrgName������ǰ��������
 *          FromUserID������ǰ�ͻ��������
 *          FromUserName������ǰ�ͻ���������
 *          ToUserID�����Ӻ�ͻ��������
 *          ToUserName�����Ӻ�ͻ��������
 *			ChangeObject���޸Ķ���
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
	//��ȡ���������ӿͻ�������ǰ�������롢����ǰ�������ơ�����ǰ�ͻ�������롢����ǰ�ͻ��������ơ����Ӻ�ͻ�������롢���Ӻ�ͻ��������ơ��޸Ķ���
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));
	String sFromUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserID"));
	String sFromUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserName"));	
	String sToUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserID"));
	String sToUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserName"));
	String sChangeObject = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ChangeObject"));
	
    //��������   
    String sInputDate   = StringFunction.getToday();
    //���Ӻ�Ļ������������
    String sToOrgID = "",sToOrgName = "";
	ASResultSet rs = null; //��ѯ�����
	int iCount = 0; //��¼��
	int i = 0;//������
    String sSql = ""; //SQL���
    String sFlag = ""; //�����Ƿ�ɹ���־
    
    //������־��Ϣ
	String sChangeReason = "�ͻ����Ӳ�����Ա����:"+CurUser.UserID+"   ������"+CurUser.UserName+"   �������룺"+CurOrg.OrgID+"   �������ƣ�"+CurOrg.OrgName;
    //�ж��Ƿ���δ����ͨ��������
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
	            
        //��ѯ���Ӻ�ͻ��������ڻ������������
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
		
		//������ʼ	
        boolean bOld = Sqlca.conn.getAutoCommit();
        Sqlca.conn.setAutoCommit(false);
        try
        {
           	for(int j = 0 ; j < ChangeObject.length ; j ++)
	    	{
	        	if(ChangeObject[j].equals("Customer")) //�ͻ�
	        	{
	        		Bizlet bzUpdateCustomerRelaInfo = new UpdateCustomerRelaInfo();
			bzUpdateCustomerRelaInfo.setAttribute("CustomerID",sCustomerID); 
			bzUpdateCustomerRelaInfo.setAttribute("FromUserID",sFromUserID);	
			bzUpdateCustomerRelaInfo.setAttribute("ToUserID",sToUserID);		
			bzUpdateCustomerRelaInfo.run(Sqlca);
	        	}else
	        	{
	        		Bizlet bzUpdateBusiness = new UpdateBusiness();
	        		if(ChangeObject[j].equals("Apply")) //����
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
	        		
	        		if(ChangeObject[j].equals("Approve")) //�����������
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
	        		
	        		if(ChangeObject[j].equals("Contract")) //��ͬ
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
	        		
	        		if(ChangeObject[j].equals("PutOut")) //����
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
	        		
	        		if(ChangeObject[j].equals("DueBill")) //���
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
	        
            //��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
            String sSerialNo =  DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca);
            sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
            		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
                    " VALUES('Customer','"+sCustomerID+"','"+sSerialNo+"','"+sFromOrgID+"','"+sFromOrgName+"','"+sToOrgID+"', "+
                    " '"+sToOrgName+"','"+sFromUserID+"','"+sFromUserName+"','"+sToUserID+"','"+sToUserName+"','"+sChangeReason+"', "+
                    " '"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sInputDate+"')";
            Sqlca.executeSQL(sSql);

	sFlag = "TRUE";
            //�����ύ
            Sqlca.conn.commit();
            Sqlca.conn.setAutoCommit(bOld);
        }
        catch(Exception e)
        {
           	sFlag = "FALSE";
            //����ʧ�ܻع�
            Sqlca.conn.rollback();
            Sqlca.conn.setAutoCommit(bOld);
        }	
	}else
	{
		sFlag = "UNFINISHAPPLY";//������;����
	}
%>
  

<script language=javascript>
	self.returnValue = "<%=sFlag%>";
    self.close();
</script>

  
<%@ include file="/IncludeEnd.jsp"%>
<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  zywei 2006.10.25
 * Tester:
 *
 * Content: ת�ƺ�ͬ����̨�����ݿ�Ĳ�����
 * Input Param:
 * 			 SerialNo����ͬ���
 *           FromOrgID��ת��ǰ��������
 *           FromOrgName��ת��ǰ��������
 * 			 FromUserID��ת��ǰ�ͻ��������
 *           FromUserName��ת��ǰ�ͻ���������
 *           ToUserID��ת�ƺ�ͻ��������
 * 			 ToUserName��ת�ƺ�ͻ���������
 *			 ChangeObject���޸Ķ���
 * Output param:
 *
 * History Log:
 *  		
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.lending.bizlets.*,com.amarsoft.biz.bizlet.Bizlet" %>


<%
    //��ȡ������ת�ƺ�ͬ��ת��ǰ�������롢ת��ǰ�������ơ�ת��ǰ�ͻ�������롢ת��ǰ�ͻ��������ơ�ת�ƺ�ͻ�������롢ת�ƺ�ͻ��������ơ��޸Ķ���
    String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));
	String sFromUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserID"));
	String sFromUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserName"));	
	String sToUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserID"));
	String sToUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserName"));
	String sChangeObject = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ChangeObject"));
	
	//ת�ƺ�������������
	String sToOrgID = "",sToOrgName = "";
	//�ͻ���š�������ˮ�š��������������ˮ��
	String sCustomerID = "",sApplySerialNo = "",sApproveSerialNo = "";
	//������ˮ�š������ˮ��
	String[] sPutOutSerialNo = null;
	//�����ˮ��
	String[] sDueBillSerialNo = null;
	//�Ǽ�����	
	String sInputDate   = StringFunction.getToday();
	int i = 0,iRiskSignalCount = 0;//������
	int iCountPutPut = 0;//���ʼ�¼��
	int iCountDueBill = 0;//��ݼ�¼��
	//ת����־��Ϣ
	String sChangeReason = "��ͬת�Ʋ�����Ա����:"+CurUser.UserID+"   ������"+CurUser.UserName+"   �������룺"+CurOrg.OrgID+"   �������ƣ�"+CurOrg.OrgName;
	//ҵ�����Ȩ���Ƿ�ɹ���־
	String sBelongAttribute3 = "",sFlag = "";
    String sSql = " select CB.BelongAttribute3 from BUSINESS_CONTRACT BC,CUSTOMER_BELONG CB where "+
				  " BC.SerialNo = '"+sSerialNo+"' and BC.CustomerID = CB.CustomerID and CB.UserID "+
				  " = '"+sToUserID+"' ";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
	    sBelongAttribute3 = DataConvert.toString(rs.getString(1));
        if(sBelongAttribute3 == null)
            sBelongAttribute3 = "";
	}
	//�رս����
	rs.getStatement().close();

	//�ж��Ƿ���δ����ͨ����Ԥ������
    sSql = 	" select count(RS.SerialNo) "+
    		" from FLOW_OBJECT FO,RISK_SIGNAL RS"+
    		" where RS.SerialNo = FO.ObjectNo "+
    		" and FO.ObjectType = 'RiskSignalApply' "+
    		" and RS.ObjectNo = (select CustomerID from BUSINESS_CONTRACT where SerialNO='"+sSerialNo+"') "+
    		" and FO.PhaseNo <> '1000' "+
    		" and FO.PhaseNo <> '8000' ";
    rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
      iRiskSignalCount=rs.getInt(1);
    }
    rs.getStatement().close();
    
    
	if(!sBelongAttribute3.equals("1"))
	{
		sFlag = "NOT";
	}else if(iRiskSignalCount>0){
		sFlag = "UNFINISHRISKSIGNAL";
	}else	
    {//���к�ͬ��ת��
    	StringTokenizer st = new StringTokenizer(sChangeObject,"|");
	    String [] ChangeObject = new String[st.countTokens()];
		while (st.hasMoreTokens()) 
	    {
	        ChangeObject[i] = st.nextToken();                
	        i++;
	    } 
	    
	    //���ݺ�ͬ��ˮ�Ż�ȡ�ͻ���š��������������ˮ��
	    sSql = 	" select CustomerID,RelativeSerialNo "+
	    		" from BUSINESS_CONTRACT "+
	    		" where SerialNo = '"+sSerialNo+"' ";
	    rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    {
	    	sCustomerID = rs.getString("CustomerID");
	    	sApproveSerialNo = rs.getString("RelativeSerialNo");
	    }
	    rs.getStatement().close();
	    
	    //�����������������ˮ�Ż�ȡ������ˮ��
	    sApplySerialNo = Sqlca.getString("select RelativeSerialNo from BUSINESS_APPROVE where SerialNo = '"+sApproveSerialNo+"'");
	    
	    //���ݺ�ͬ��ˮ�Ż�ȡ������ˮ��
	    sSql = 	" select count(SerialNo) "+
	    		" from BUSINESS_PUTOUT "+
	    		" where ContractSerialNo = '"+sSerialNo+"' ";
	    rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			iCountPutPut = rs.getInt(1);
		}   
		rs.getStatement().close();
		sPutOutSerialNo = new String[iCountPutPut];
		
	    sSql = 	" select SerialNo "+
	    		" from BUSINESS_PUTOUT "+
	    		" where ContractSerialNo = '"+sSerialNo+"' ";
	    sPutOutSerialNo = Sqlca.getStringArray(sSql);	
	   
	    //���ݺ�ͬ��ˮ�Ż�ȡ�����ˮ��
	    sSql = 	" select count(SerialNo) "+
    			" from BUSINESS_DUEBILL "+
	    		" where RelativeSerialNo2 = '"+sSerialNo+"' ";
    	rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			iCountDueBill = rs.getInt(1);
		}   
		rs.getStatement().close();
		sDueBillSerialNo = new String[iCountDueBill];
		
	    sSql = 	" select SerialNo "+
	    		" from BUSINESS_DUEBILL "+
	    		" where RelativeSerialNo2 = '"+sSerialNo+"' ";
	    sDueBillSerialNo = Sqlca.getStringArray(sSql);
	   	    
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
    	try{
    		for(int j = 0 ; j < ChangeObject.length ; j ++)
	    	{
	        	if(ChangeObject[j].equals("Customer")) //�ͻ�
	        	{
	        		System.out.println("----------Customer--------"+sCustomerID);
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
	        			System.out.println("---------Apply--------"+sApplySerialNo);
        				bzUpdateBusiness.setAttribute("ObjectType","CreditApply");
        				bzUpdateBusiness.setAttribute("ObjectNo",sApplySerialNo);
        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
        				bzUpdateBusiness.run(Sqlca);
	        		}
	        		
	        		if(ChangeObject[j].equals("Approve")) //�����������
	        		{	
	        			System.out.println("---------Approve--------"+sApproveSerialNo);        			
        				bzUpdateBusiness.setAttribute("ObjectType","ApproveApply");
        				bzUpdateBusiness.setAttribute("ObjectNo",sApproveSerialNo);
        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
        				bzUpdateBusiness.run(Sqlca);	        			
	        		}
	        		
	        		if(ChangeObject[j].equals("Contract")) //��ͬ
	        		{	
	        			System.out.println("---------Contract--------"+sSerialNo);   			
        				bzUpdateBusiness.setAttribute("ObjectType","BusinessContract");
        				bzUpdateBusiness.setAttribute("ObjectNo",sSerialNo);
        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
        				bzUpdateBusiness.run(Sqlca);	        			
	        		}
	        		
	        		if(ChangeObject[j].equals("PutOut") && iCountPutPut > 0) //����
	        		{	        	
        				for(int k = 0;k < sPutOutSerialNo.length;k++)
        				{
	        				System.out.println("---------PutOut--------"+sPutOutSerialNo[k]);  		
	        				bzUpdateBusiness.setAttribute("ObjectType","PutOutApply");
	        				bzUpdateBusiness.setAttribute("ObjectNo",sPutOutSerialNo[k]);
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);	
	        			}        			
	        		}
	        		
	        		if(ChangeObject[j].equals("DueBill") && iCountDueBill > 0) //���
	        		{	          					
        				for(int l = 0;l < sPutOutSerialNo.length;l++)
        				{
	        				System.out.println("---------DueBill--------"+sDueBillSerialNo[l]);
	        				bzUpdateBusiness.setAttribute("ObjectType","BusinessDueBill");
	        				bzUpdateBusiness.setAttribute("ObjectNo",sDueBillSerialNo[l]);
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}	        			
	        		}
	        	}
	        }
    	
    		//��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
            String sSerialNo1 =  DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca);
            sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
            		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
                    " VALUES('BusinessContract','"+sSerialNo+"','"+sSerialNo1+"','"+sFromOrgID+"','"+sFromOrgName+"','"+sToOrgID+"', "+
                    " '"+sToOrgName+"','"+sFromUserID+"','"+sFromUserName+"','"+sToUserID+"','"+sToUserName+"','"+sChangeReason+"', "+
                    " '"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sInputDate+"')";
            Sqlca.executeSQL(sSql);

            		
			sFlag = "TRUE";
			
			//�����ύ
            Sqlca.conn.commit();
            Sqlca.conn.setAutoCommit(bOld);
		}catch(Exception e)
		{
			sFlag = "FALSE";
			//����ʧ�ܻع�
            Sqlca.conn.rollback();
            Sqlca.conn.setAutoCommit(bOld);
			throw new Exception("��ͬת�ƴ���ʧ�ܣ�"+e.getMessage());
		}
	}
%>

<script language=javascript>
	self.returnValue = "<%=sFlag%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>
<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: kfb  2005.03.10
 * Tester:
 *
 * Content: �����ɫȨ�޲���
 * Input Param:
 * Output param:
 *
 * History Log:
 *			
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%

	//��ȡ��������ɫ��š�ת��ǰ�ͻ������š�������ֵ��ת����ͻ������š�ת��ǰ�������
	String sRoleID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RoleID"));	
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));	
	String sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));	
	String sValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Value"));	
	String sToUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserID"));	
	String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));		
   	
   	//�������
   	ASResultSet rs = null;	
	if (sValue == null)  sValue = "";
	int iCount = 0;
	String sFlag = "";
	String sSql = "";
	String sRoleStr = "";
	//ת����־��Ϣ
	String sChangeReason = "��ɫת�Ʋ�����Ա����:"+CurUser.UserID+"   ������"+CurUser.UserName+"   �������룺"+CurOrg.OrgID+"   �������ƣ�"+CurOrg.OrgName;
	String sInputDate   = StringFunction.getToday();
	
	//��ɫ�����û�
	if(sAction!=null && sAction.equals("UserRole"))
	{
		String sRole[] = StringFunction.toStringArray(sValue,"|");
		try{
					
					sSql = " select RoleID from USER_ROLE where UserID ='"+sUserID+"' ";
					rs = Sqlca.getASResultSet(sSql);
					while(rs.next())
						sRoleStr = sRoleStr + "'" + rs.getString("RoleID") + "',";
					rs.getStatement().close();
					if(sRoleStr.length() > 0)
					{
						sRoleStr = sRoleStr.substring(0,sRoleStr.length() - 1);						
						sSql = " delete from USER_ROLE where UserID = '"+sToUserID+"' and "+
						       " RoleID in ("+sRoleStr+") ";
						Sqlca.executeSQL(sSql);
						if (!sValue.equals(""))
						{
							for(iCount=0;iCount<sRole.length;iCount++)
							{	
								if (sRole[iCount]!="" )
								{
								   sSql = "select count(RoleID) from USER_ROLE where RoleID ='"+sRole[iCount]+"' and UserID ='"+sToUserID+"' ";
								   rs = Sqlca.getASResultSet(sSql);
	
								   int num=0;
								   while(rs.next())
								   {	
									   num = rs.getInt(1);
								   }
								   rs.getStatement().close();
								   if (num<=0)
								   {
										sSql = "insert into USER_ROLE(RoleID,UserID,Grantor,BeginTime,Status,Remark)"+
												" values('"+sRole[iCount]+"','"+sToUserID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+" "+StringFunction.getNow()+"','1','1')";
										Sqlca.executeSQL(sSql);
								   }
								}
							}
						}
						//��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
				        String sSerialNo1 =  DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca);
				        sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
				        		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
				                " VALUES('TransferRole','"+sRoleID+"','"+sSerialNo1+"','"+sFromOrgID+"','','', "+
				                " '','"+sUserID+"','','','','"+sChangeReason+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sInputDate+"')";
				        Sqlca.executeSQL(sSql);
						Sqlca.conn.commit();	
						sFlag = "TRUE";
					}
		   }catch(Exception e)
		   {
			  sFlag = "FALSE";
			  throw new Exception("��ɫת��������ʧ�ܣ�"+e.getMessage());
		   }	
	}

%>

<script language=javascript>
	
	if("<%=sFlag%>" == "FALSE")	
	{
			alert("����ʧ�ܣ������²�����");
			
	}
	
	self.returnValue = '<%=sFlag%>';
	self.close();	
</script>

<%@ include file="/IncludeEnd.jsp"%>
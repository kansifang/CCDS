<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=ע����;]~*/%>
<%
/* 
  Tester:
  Content:  ������Ŀ����
  Input Param:
			ObjectType  ����������
			ObjectNo:   : ������
			ProjectType : ��Ŀ����
			ProjectName : ��Ŀ����
  Output param:
 			sProjectNo  :��Ŀ���
 
  History Log:     
      DATE	  CHANGER		CONTENT
      2005-7-25 fbkang     ����ע��
       2005/09/13 zywei ����������         
 */
 %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>

<%     	
    //�������
   	String sSql = "";
    //���ҳ�����
	String sObjectType     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo       =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sProjectType    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectType"));
	String sProjectName    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectName"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sProjectType == null) sProjectType = "";
	if(sProjectName == null) sProjectName = "";
   //����������

	//��ʼ����Ŀ���
    String sProjectNo  = DBFunction.getSerialNo("PROJECT_INFO","ProjectNo",Sqlca);
 %>
<%/*~END~*/%>	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=ִ��sql����*/%>    
<%
   	boolean bOld = Sqlca.conn.getAutoCommit(); 
	try {
			if(!bOld) Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(false);
			
		   	//������Ŀ���Ͽ�
		    sSql = " insert into PROJECT_INFO(ProjectNo,InputUserID,InputOrgID,InputDate,UpdateDate,ProjectType,ProjectName) " +
		    	   " values('"+sProjectNo+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"','"+sProjectType+"','"+sProjectName+"')" ;
		    Sqlca.executeSQL(sSql);    
    
		   	//������Ŀ���������
		    sSql = " insert into PROJECT_RELATIVE(ProjectNo,ObjectType,ObjectNo) " +
		    	   " values('"+sProjectNo+"','"+sObjectType+"','"+sObjectNo+"')";
		    Sqlca.executeSQL(sSql);
			//�����ύ
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(bOld);
		}catch(Exception e)
		{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bOld);
			throw new Exception("������ʧ�ܣ�"+e.getMessage());
		}
%>
<%/*~END~*/%>	

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main04;Describe=���ز���*/%>  
<html>
<head> 
<title>������Ŀ����</title>
</head>   	
<body>
<script language=javascript>
	
	self.returnValue="<%=sProjectNo%>";	
	self.close();
		
</script>
</body>
</html>
<%/*~END~*/%>	
<%@ include file="/IncludeEnd.jsp"%>
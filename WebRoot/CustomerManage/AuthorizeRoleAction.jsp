<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   --fbkang  2005.07.27
		Tester:
		Content:  --�õ��ͻ���
		Input Param:
	        CustomerID���ͻ�����
	        UserID���û�����
	        ApplyAttribute������ͻ�����Ȩ��־
	        ApplyAttribute1��������Ϣ�鿴Ȩ��־
	        ApplyAttribute2��������Ϣά����־
	        ApplyAttribute3����������ҵ�����Ȩ��־	
	        ApplyAttribute4��������Ȩ�ޱ�־		                
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�Ȩ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������   
    String sOrgName = "";//--//���ڻ�������
    String sUserName = "";//--�û�����
    String sBelongUserID = "";//--�����û�
    String sSql = ""; //--Sql���
    String sHave = "_FALSE_";      //�ÿͻ��Ƿ�������Ȩ
	//����������,�ͻ����롢�û����롢����ͻ�����Ȩ��־��������Ϣ�鿴Ȩ��־��������Ϣά����־����������ҵ�����Ȩ��־������Ȩ�ޱ�־
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String sApplyAttribute  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute"));
	String sApplyAttribute1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute1"));
	String sApplyAttribute2 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute2"));
	String sApplyAttribute3 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute3"));
	String sApplyAttribute4 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute4"));
	//����ֵת��Ϊ���ַ���
	if(sCustomerID == null) sCustomerID = "";           
    if(sUserID == null) sUserID = "";
	if(sApplyAttribute == null) sApplyAttribute = "";           
    if(sApplyAttribute1 == null) sApplyAttribute1 = "";
    if(sApplyAttribute2 == null) sApplyAttribute2 = "";
    if(sApplyAttribute3 == null) sApplyAttribute3 = "";
    if(sApplyAttribute4 == null) sApplyAttribute4 = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ȡ����ֵ ;]~*/%>
<%     
    //�ͻ�����Ȩ
	if(sApplyAttribute.equals("1"))
	{
	    //�ж��Ƿ��������ͻ������Ѿ��иÿͻ�������Ȩ
	    sSql = " select BelongAttribute,getOrgName(OrgID) as OrgName, "+
			   " getUserName(UserID) as UserName,UserID "+
               " from CUSTOMER_BELONG "+
               " where CustomerID='"+sCustomerID+"' "+
               " and UserID <> '"+sUserID+"' "+
               " and BelongAttribute = '1'";
	    ASResultSet rs = Sqlca.getResultSet(sSql);
	    if(rs.next()) 
	    {
	        sHave = "_TRUE_";  //��������Ȩ
	        sOrgName = rs.getString("OrgName");
	        sUserName = rs.getString("UserName");
	        sBelongUserID = rs.getString("UserID");
	    }
	    rs.getStatement().close();	    
	}
	
	//����ÿͻ�������Ȩ��û���û�ӵ�У���ֱ�Ӹ�������������пͻ�Ȩ�޵ĸ���
	if(sHave.equals("_FALSE_"))
	{  
    	sSql = 	" Update CUSTOMER_BELONG set BelongAttribute = '"+sApplyAttribute+"', "+
    			" BelongAttribute1 = '"+sApplyAttribute1+"',BelongAttribute2 = '"+sApplyAttribute2+"', "+
    			" BelongAttribute3 = '"+sApplyAttribute3+"',BelongAttribute4 = '"+sApplyAttribute4+"' "+
    			" where CustomerID = '"+sCustomerID+"' "+
    			" and UserID = '"+sUserID+"' ";
    	Sqlca.executeSQL(sSql);
    	ASResultSet rs = null;
    	String sSql1 = "select * From CUSTOMER_BELONG where customerid = '"+sCustomerID+"' and userid = '"+sUserID+"'";
    	rs = Sqlca.getASResultSet(sSql1);
    	if(rs.next())
    	{	String sSerialNo1 = DBFunction.getSerialNo("CUSTOMER_BELONGLOG","SerialNo","CBL",Sqlca);
    		String sSql2 = "insert into CUSTOMER_BELONGLOG values "+
    		" ('"+sSerialNo1+"','"+rs.getString("CUSTOMERID")+"','"+rs.getString("ORGID")+"','"+rs.getString("USERID")+"', "+
    		" '"+rs.getString("BELONGATTRIBUTE")+"','"+rs.getString("BELONGATTRIBUTE1")+"','"+rs.getString("BELONGATTRIBUTE2")+"', "+
    		" '"+rs.getString("BELONGATTRIBUTE3")+"','"+rs.getString("BELONGATTRIBUTE4")+"','"+rs.getString("INPUTUSERID")+"', "+
    		" '"+rs.getString("INPUTORGID")+"','"+rs.getString("INPUTDATE")+"','"+rs.getString("UPDATEDATE")+"', "+
    		" '"+rs.getString("APPLYATTRIBUTE")+"','"+rs.getString("APPLYATTRIBUTE1")+"','"+rs.getString("APPLYATTRIBUTE2")+"', "+
    		" '"+rs.getString("APPLYATTRIBUTE3")+"','"+rs.getString("APPLYATTRIBUTE4")+"','"+rs.getString("REMARK")+"', "+
    		" '"+rs.getString("APPLYSTATUS")+"','"+rs.getString("APPLYREASON")+"','"+rs.getString("APPLYRIGHT")+"', "+
    		" '"+CurUser.UserID+"','"+CurUser.OrgID+"','"+StringFunction.getToday()+" "+StringFunction.getNow()+"')";
    		Sqlca.executeSQL(sSql2);
    	}
    	rs.close();
    } 
%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "<%=sHave%>@<%=sOrgName%>@<%=sUserName%>@<%=sBelongUserID%>";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>

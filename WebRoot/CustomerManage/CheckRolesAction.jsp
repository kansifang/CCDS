<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   --fbkang  2005.07.26
	Tester:
	Content: --У��ͻ��Ƿ��пͻ�����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ
	Input Param:
		CustomerID��  --��ѡ�ͻ���š�             
	Output param:
		                
	History Log: 
	                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�Ȩ��У��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%  
    //�������
    ASResultSet rs = null;//��Ž����    
    String sBelongAttribute = "";//--�ͻ�����Ȩ    
    String sBelongAttribute1 = "";//--��Ϣ�鿴Ȩ
    String sBelongAttribute2 = "";//--��Ϣά��Ȩ
    String sBelongAttribute3 = "";//--ҵ�����Ȩ    
    String sReturnValue = "";//--����Ƿ��пͻ�����Ȩ��־   
    String sReturnValue1 = "";//--����Ƿ�����Ϣ�鿴Ȩ��־
    String sReturnValue2 = "";//--����Ƿ�����Ϣά��Ȩ��־
    String sReturnValue3 = "";//--����Ƿ���ҵ�����Ȩ��־
        
    String sReturn = "";   //����������־
    //���ҳ�����
    String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
    //����������
    
    String sSql = " select BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3 "+
                  " from CUSTOMER_BELONG "+
                  " where CustomerID = '"+sCustomerID+"' "+
                  " and UserID = '"+CurUser.UserID+"' ";
	
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
	   sBelongAttribute = rs.getString("BelongAttribute");
	   sBelongAttribute1 = rs.getString("BelongAttribute1");
	   sBelongAttribute2 = rs.getString("BelongAttribute2");
	   sBelongAttribute3 = rs.getString("BelongAttribute3");	   
	}
	rs.getStatement().close();
	if(sBelongAttribute == null) sBelongAttribute = "";
	if(sBelongAttribute1 == null) sBelongAttribute1 = "";
	if(sBelongAttribute2 == null) sBelongAttribute2 = "";
	if(sBelongAttribute3 == null) sBelongAttribute3 = "";
	
	//ȷ���Ƿ���Ȩ�ޣ�010����
	//����пͻ�����Ȩ����Y�����򷵻�N	
    if(sBelongAttribute.equals("1")) 
        sReturnValue = "Y";
    else 
    	sReturnValue = "N";
        
    //�������Ϣ�鿴Ȩ����Y�����򷵻�N	
    if(sBelongAttribute1.equals("1")) 
        sReturnValue1 = "Y1";
    else 
    	sReturnValue1 = "N1";
    
    //�������Ϣά��Ȩ����Y�����򷵻�N	
    if(sBelongAttribute2.equals("1")) 
        sReturnValue2 = "Y2";
    else 
    	sReturnValue2 = "N2";
    
    //�����ҵ�����Ȩ����Y�����򷵻�N	
    if(sBelongAttribute3.equals("1")) 
        sReturnValue3 = "Y3";
    else 
    	sReturnValue3 = "N3";
        
    sReturn = sReturnValue+"@"+sReturnValue1+"@"+sReturnValue2+"@"+sReturnValue3;

%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "<%=sReturn%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>
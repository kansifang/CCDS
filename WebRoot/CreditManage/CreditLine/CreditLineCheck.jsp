<%@ page contentType="text/html; charset=GBK"%>
<%@ page  import="com.amarsoft.app.creditline.*" %>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:jbye 2005-09-01 9:43
		Tester:
		Content: ִ�ж�ȼ��
		Input Param:
			LineID������Э����
			ObjectType��У���������
				CreditApply �������
				AgreeApproveApply ��������
				BusinessContract ��ͬ����
			sObjectNo�� У�������
				��Ӧ����� SerialNo
		Output param:
			sReturnValue : �Ƿ����ͨ�����
				Pass ͨ��
				Refuse �ܾ�
		History Log: 
			jbye ����ʵ�ʵ���Ҫ�����޸�У����ƺʹ���չ�ֻ���
			zywei �ؼ���� 2005/12/23

	 */
	%>
<%/*~END~*/%>

<%
	
	String []sErrorLog = new String[30];
	int i = 0,num = 0,iCount = 0;
	String sSql = "",sReturnValue = "Pass",sLineID = "";
	String sObjectType = "",sObjectNo = "",sErrorTypeID = "",sErrorTypeName = "";
	ASResultSet rs = null;
	
	sLineID = DataConvert.toRealString(iPostChange,CurPage.getParameter("LineID"));
	sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	
	CreditLine line = new CreditLine(Sqlca,sLineID);

	//�����������
	//double dBalance = line.getBalance(Sqlca);
	
	//�������ų������
	String dBalance2 = DataConvert.toMoney(line.getBalance(Sqlca,"LineSum2"));
	
	try
	{		
		//������ģʽ
		line.enterCheckMode(Sqlca);
		//��ʼ���м��
		Vector errors = line.check(Sqlca,"LOG=Y",sObjectType,sObjectNo);
	    StringBuffer sbErrorNotes = new StringBuffer(); 
	    
	    //������������
	    if(errors.size()>0){	    	
	    	for(i=0;i<errors.size();i++){
	    		sbErrorNotes.append((String)errors.get(i)+";");
	    		sErrorTypeID = (String)errors.get(i);
	    		//ȡ��sSource �� ; �ָ�ĵ� 1 ������
	    		sErrorTypeID = StringFunction.getSeparate(sErrorTypeID,";",1);
	    		//ȡ���ַ���data�����ַ��� ErrorType= ��ʼ���ַ��� ; �������ַ���
	    		sErrorTypeID = StringFunction.getProfileString(sErrorTypeID,"ErrorType",";");
	    		//ת����������Ϊ����
	    		sSql = "select ErrorTypeName from CL_ERROR_TYPE where  ErrorTypeID='"+sErrorTypeID+"'";
		        rs = Sqlca.getASResultSet(sSql);
		        if(rs.next())
				{ 
		        	sErrorTypeName = rs.getString("ErrorTypeName");
				}
				rs.getStatement().close();

				//��������ʾ����
				sErrorLog[i] = sErrorTypeName;
				sReturnValue = "Refuse";
	    	}
	    	iCount = i;
	    }
	}finally
	{
		//������ģʽ
		line.exitCheckMode(Sqlca);
	}
	
	if(sReturnValue.equals("Pass"))	
	{
%>
	<script language=javascript>
		self.returnValue = "<%=sReturnValue%>";
		self.close();
	</script>
<%
	}else
	{
%>
<html>

<head>
<title>���Ŷ�ȼ����</title>
</head>

<body bgcolor="#EAEAEA" >
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td width="62%" valign="top"> 
	<p>ϵͳ�Զ���⵱ǰҵ������ռ�õ����Ŷ�Ȳ�����Ҫ��Ϊ��</p>
	<table width="100%" border="1" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">
	<%	
   	for(i=0;i<iCount;i++)
   	{
	%>    
    	<tr bgcolor=#fafafa>
			<td >
				<font color=red>
    			<%   
	    			num = i + 1;     			
	    			out.print(num+":"+sErrorLog[i]);
    			%>
				</font>
			</td>	
		</tr>
	<%}%>	
	</table>
	<table width="100%" border="1" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">
		<tr>
			<td align = center> 
		    	<input type="button" style="width:50px"  value=" ��  �� " class="button" onclick="javascipt: self.returnValue = '<%=sReturnValue%>';self.close();">
		    </td>
	    </tr>
    </table>
</table>

</body>
</html>
<%
}
%>

<%@ include file="/IncludeEnd.jsp"%>

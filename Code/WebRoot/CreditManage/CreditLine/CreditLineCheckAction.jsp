<%@ page  import="com.amarsoft.app.creditline.*" %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:jbye 2005-09-01 9:43
		Tester:
		Content: ִ�ж�ȼ��
		Input Param:
			LineID�� 	����Э����
			ObjectType��У���������
				BusinessApply �������
				BusinessApprove ��������
				BusinessContract ��ͬ����
			sObjectNo�� У�������
				��Ӧ����� SerialNo
		Output param:
			sReturnValue : �Ƿ����ͨ�����
				Pass ͨ��
				Refuse �ܾ�
		History Log: 
			jbye ����ʵ�ʵ���Ҫ�����޸�У����ƺʹ���չ�ֻ���

	 */
	%>
<%/*~END~*/%>

<%
	
	String []sErrorLog;
	sErrorLog = new String[30];
	int i = 0,num = 0;
	String sSql = "",sCheckResult = "",sReturnValue = "Refuse",sLineID = "",sObjectType = "",sObjectNo = "";
	ASResultSet rs = null;
	
	sLineID = DataConvert.toRealString(iPostChange,CurPage.getParameter("LineID"));
	sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	
	CreditLine line = new CreditLine(Sqlca,sLineID);
	sObjectType = "BusinessApply";
	sObjectNo = "BA20050714000001";
	/*
	double dBalance = line.getBalance(Sqlca);
	out.println("���1��"+dBalance);
	*/
	try
	{
		String sResult = "pass",sError = "";
		//������ģʽ
		line.enterCheckMode(Sqlca);
		//��ʼ���м��
		Vector errors = line.check(Sqlca,"LOG=Y",sObjectType,sObjectNo);
	    StringBuffer sbErrorNotes = new StringBuffer(); 
	    //������������
	    if(errors.size()>0){
	    	sResult = "fail";
	    	for(i=0;i<errors.size();i++){
	    		sbErrorNotes.append((String)errors.get(i)+";");
	    		sError = (String)errors.get(i);
	    		//ȡ��sSource �� ; �ָ�ĵ� 1 ������
	    		sError = StringFunction.getSeparate(sError,";",1);
	    		//ȡ���ַ���data�����ַ��� ErrorType= ��ʼ���ַ��� ; �������ַ���
	    		sError = StringFunction.getProfileString(sError,"ErrorType",";");
	    		//ת����������Ϊ����
	    		sSql = "select ErrorTypeName from CL_ERROR_TYPE where  ErrorTypeID='"+sError+"'";
		        rs = Sqlca.getASResultSet(sSql);
		        if(rs.next())
				{ 
		        	sError = rs.getString("ErrorTypeName");
				}
				rs.getStatement().close();
				//��������ʾ����
				sErrorLog[i] = sError;
	    	}
	    }
		sCheckResult = sResult+"@"+sbErrorNotes.toString();
	}finally
	{
		//������ģʽ
		line.exitCheckMode(Sqlca);
	}
	//if(sResult.equals("pass"))	sCheckResult = "�ɹ�";
	num=i;
%>
<html>

<head>
<title>���ż�� <%=sLineID%></title>
</head>

<body bgcolor="#EAEAEA" >
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td width="62%" valign="top"> 

<p>ϵͳ̽�⵽���������³��ֵ����������</p>

<table width="100%" border="1" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">

<%
	
   	for(i=0;i<num;i++)
   	{
%>    
    	<tr bgcolor=#fafafa>
			<td >
				<font color=red>
	        			<%        			
	        			out.print((i+1)+"��"+sErrorLog[i]);
	        			%>
				</font>
			</td>	
		</tr>
<%  }
	//��ʾû���κ������򷵻�ֵΪ Pass
	if(i==0) {
		out.println("--        ��");
		sReturnValue = "Pass";
	}
	
%>
	
</table>
	<tr>
		<td align = center> 
	       		 <input type="button" style="width:50px"  value=" ��  �� " class="button" onclick="javascipt:go_back()">
	    </td>
    </tr>
</table>


</body>
</html>
<script language=javascript>
	function go_back()
	{
	    self.returnValue = "<%=sReturnValue%>";
	    self.close()
	}
	<%
	//���û���κ������Զ��ر� add by jbye 2005-09-01 10:08
	/*
	if(i==0){	
		out.println("self.returnValue ='"+sReturnValue+"'");	
		out.println("self.close();");	
	}
	*/
	%>
</script>

<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: �ͻ���Ϣ¼�����
		Input Param:
			CustomerType���ͻ�����
					01����˾�ͻ���
					0201��һ��������ţ�
					0202������������ţ�
					03�����˿ͻ���
		Output param:
			CustomerType���ͻ�����
				��˾�ͻ���	
					0101��������ҵ��
					0102���Ƿ�����ҵ��
					0103�����幤�̻�����ϵͳ�ݲ��ã���
					0104����ҵ��λ��
					0105��������壻
					0106���������أ�
					0107�����ڻ�����
					0199��������
				�������ţ�
					0201��һ�༯�ţ�
					0202�����༯�ţ�
				���˿ͻ���
					03�����˿ͻ�
			CustomerName���ͻ�����
			CertType��֤������
			CertID��֤������
		History Log: zywei 2005/09/10 �ؼ����
	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>������ͻ���Ϣ</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	���ͻ�����
	String sCustomerType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";
		
	%>
<%/*~END~*/%>


<script language=javascript>

	function newCustomer()
	{
		var sCustomerType = "";
		var sCustomerName = document.all("CustomerName").value;
		
		//�ǹ������ſͻ���ȡ��֤�����͡�֤������
		if("<%=sCustomerType.substring(0,2)%>" != '02'&&"<%=sCustomerType%>" != '0401'&&"<%=sCustomerType%>" != '0501')
		{
			var sCertType = document.all("CertType").value;
			var sCertID = document.all("CertID").value;
			var sCertID1 = document.all("CertID1").value;
		}else
		{
			var sCertType = "";
			var sCertID = "";
			var sCertID1 = "";
		}
		
		//��ȡ�ͻ����ͣ�С�ࣩ
		sCustomerType = document.all("CustomerType").value;			
		//���ͻ������Ƿ�ѡ��
		if (sCustomerType == '')
		{
			alert(getBusinessMessage('147'));//��ѡ��ͻ����ͣ�
			document.all("CustomerType").focus();
			return;
		}
		
		//�ǹ������ſͻ�����֤�����͡�֤������
		if("<%=sCustomerType.substring(0,2)%>" != '02'&&"<%=sCustomerType%>" != '0401'&&"<%=sCustomerType%>" != '0501')
		{
			//���֤�������Ƿ�ѡ��
			if (sCertType == '')
			{
				alert(getBusinessMessage('148'));//��ѡ��֤�����ͣ�
				document.all("CertType").focus();
				return;
			}
			//���֤�������Ƿ�����
			if (sCertID == '')
			{
				alert(getBusinessMessage('149'));//֤������δ���룡
				document.all("CertID").focus();
				return;
			}
			//���֤�������Ƿ�����һ��
			if (sCertID != sCertID1)
			{
				alert(getBusinessMessage('152'));//֤���������벻һ�£�
				document.all("CertID1").focus();
				return;
			}
		}
		
		//�ж���֯��������Ϸ���
		if(sCertType =='Ent01')
		{			
			if(!CheckORG(sCertID))
			{
				alert(getBusinessMessage('102'));//��֯������������
				document.all("CertID").focus();
				return;
			}			
		}	
			
		//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
		if(sCertType == 'Ind01' || sCertType =='Ind08')
		{
			if (!CheckLisince(sCertID))
			{
				alert(getBusinessMessage('156'));//���֤��������
				document.all("CertID").focus();
				return;
			}
		}		
		
		//���ͻ������Ƿ�����
		if (sCustomerName == '')
		{
			alert(getBusinessMessage('104'));//�ͻ����Ʋ���Ϊ�գ�
			document.all("CustomerName").focus();
			return;
		}
		
		//���ر�����ϸ���Ŀͻ����͡��ͻ����ơ��ͻ�֤�����͡�֤����
		self.returnValue=sCustomerType+"@"+sCustomerName+"@"+sCertType+"@"+sCertID;
		self.close();
	}
	

</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
     <%	    
	    if(sCustomerType.substring(0,2).equals("01")) //��˾�ͻ���Ҫѡ��С��
	    {
	    	String sSql="";
	    	if(sCustomerType.equals("01"))
	    	{
	    		sSql="select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerType' and ItemNo <> '01' and ItemNo like '"+sCustomerType+"%' and ItemNo<>'0107' and IsInUse = '1' order by SortNo ";
	    	}else{
	    		sSql="select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerType' and ItemNo <> '01' and ItemNo like '"+sCustomerType+"%' and IsInUse = '1' order by SortNo ";
	    	}
	 %>
    <tr> 
      
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >ѡ��ͻ�����&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <select name="CustomerType">
        	<%=HTMLControls.generateDropDownSelect(Sqlca,sSql,1,2,"")%> 
        </select>
      </td>
    </tr> 
     <%
		}else
		{
	 %>
	  <tr>  
       <input name="CustomerType" value='<%=sCustomerType%>' type=hidden>  
    </tr> 	    
	 <%	
		}
		//�ǹ������ſͻ���ѡ��֤������
	    if(!sCustomerType.substring(0,2).equals("02")&&!sCustomerType.equals("0401")&&!sCustomerType.equals("0501"))//add by xhyong 2009/08/10 ��������С������ù�ͬ���ж�
	    {
     %>
     <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >ѡ��֤������&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <select name="CertType"">
	    <%
	    //ѡ��֤������
	    if(sCustomerType.substring(0,2).equals("01"))//ѡ��˾�ͻ���֤������
	    {
	    %>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and SortNo like 'Ent%' order by SortNo ",1,2,"")%> 
	    <%
		}
		else if(sCustomerType.substring(0,2).equals("03"))//ѡ����˿ͻ���֤������
		{
	    %>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and ItemNo like 'Ind%' order by SortNo ",1,2,"")%> 
	    <%
		}		
	    %>
        </select>
      </td>
    </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >֤������&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="CertID" value="" onpaste="return false">
      </td>
    </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >֤������ȷ��&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="CertID1" value="" onpaste="return false">
      </td>
    </tr>
    <%
    }
    %>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF"  >�ͻ�����&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="CustomerName" value="" <%=(sCustomerType.equals("04")?"style='width:100px'":"style='width:200px'")%> >
      </td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:newCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>
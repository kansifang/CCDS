<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui  2003.8.18
		Tester:
		Content: ��ҵծȯ������Ϣ_List
		Input Param:
			                CustomerID���ͻ����
			                CustomerRight:Ȩ�޴���----01�鿴Ȩ��02ά��Ȩ��03����ά��Ȩ
		Output param:
		                CustomerID����ǰ�ͻ�����Ŀͻ���
		              	Issuedate:��������
		              	BondType:ծȯ����
		                CustomerRight:Ȩ�޴���
		                EditRight:�༭Ȩ�޴���----01�鿴Ȩ��02�༭Ȩ
		History Log: 
		                 2003.08.20 CYHui
		                 2003.08.28 CYHui
		                 2003.09.08 CYHui 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
<html>
<head>
<title></title> 
</head>
<body class="ListPage" leftmargin="0" topmargin="0" >
<div id="CoverTipDiv" style="position:absolute; left:1px; top:1px; width:99%; height:35px; z-index:2; display:none"> 
 <table width="100%" height="100%" align=center border="0" cellspacing="0" cellpadding="1" bgcolor="#333333">
    <tr> 
      <td>
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
		<tr> 
		  <td width=1><img class=clockimg src=<%=sResourcesPath%>/1x1.gif width="1" height="1"></td>
		  <td id="CoverTipTD" style="background-color: #FFFFFF;"></td>
		</tr>
		</table>
	</td>
	</tr>
</table>
</div>
<table border="0" width="100%" cellspacing="0" cellpadding="4">
	<tr>
	    <td>
		�ڲ���������
	    </td>
	    <td>
		<input type=text name=CreditRating1>
	    </td>
	    <td>
		<input type=button value="����">
	    </td>
	    <td>
		ΥԼ���� (PD)
	    </td>
	    <td>
		<input type=text name=PD>
	    </td>
	    <td>
		<input type=button value="����">
	    </td>
	</tr>
	<tr>
	    <td colspan=6 height=1 bgcolor=#FFFFFF>
	    </td>
	</tr>
	<tr>
	    <td>
		����ΥԼ��ʧ�� (LGD)
	    </td>
	    <td>
		<input type=text name=LGD>
	    </td>
	    <td>
		<input type=button value="����">
	    </td>
	    <td>
		ΥԼ���ճ���
	    </td>
	    <td>
		<input type=text name=EAD>
	    </td>
	    <td>
		<input type=button value="����">
	    </td>
	</tr>
	<tr>
	    <td colspan=6 height=1 bgcolor=#FFFFFF>
	    </td>
	</tr>
	<tr>
	    <td>
		����
	    </td>
	    <td>
		<input type=text name=TERM>
	    </td>
	    <td>
	    </td>
	    <td>
		Ԥ����ʧ (EL)
	    </td>
	    <td>
		<input type=text name=EL>
	    </td>
	    <td>
		<input type=button value="����">
	    </td>
	</tr>
	<tr>
	    <td colspan=6 height=1 bgcolor=#FFFFFF>
	    </td>
	</tr>
</table>
</body>
</html>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function showCoverTip(sTipText){
		oDiv = document.all("CoverTipDiv");
		oTD = document.all("CoverTipTD");
		oDiv.style.display="";
		oTD.innerHTML=sTipText;
	}
	function hideCoverTip(){
		oDiv = document.all("CoverTipDiv");
		oTD = document.all("CoverTipTD");
		oDiv.style.display="none";
		oTD.innerHTML="";
	}

	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sSql     = " ";


	String sHeaders[][] = {{"LoginID","�û���"},
							{"UserName","�û���"},
							{"OrgName","������"},
							{"ServerName","��������"},
							{"Remoteaddr","�û�IP"},
							{"BeginTime","�Ự��ʼʱ��"}
							};


	sSql =" Select b.LoginID as LoginID,a.UserName as UserName,a.OrgName as OrgName, "+
		  "        a.Remoteaddr as Remoteaddr,a.BeginTime as BeginTime,a.ServerName as ServerName "+
	      " From User_List a,User_Info b "+
	      " Where a.begintime like '"+StringFunction.getToday()+"%' and a.endtime is null "+
	      "   and b.UserID =  a.UserID " +
	      " order by a.begintime";
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setHTMLStyle("LoginID,Remoteaddr"," style={width:100px} ");
	doTemp.setHTMLStyle("UserName,OrgName"," style={width:200px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


%>
<head>
<title>�����û��б�</title>
</head>
<body class="pagebackground"  leftmargin="0" topmargin="0" onload="" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr height=1 valign=top >
    <td>
    	<table>
	    	<tr>
	    		<td>
	                       <%=HTMLControls.generateButton("�ر�","�ر�","javascript:self.close()",sResourcesPath)%>
	    		</td>
    		</tr>
    	</table>
    </td>
</tr>
<tr>
    <td colspan=3>
	<iframe name="myiframe0" width=100% height=100% frameborder=0></iframe>
    </td>
</tr>
</table>
</body>
</html>
<script>

</script>



<script language=javascript>
	AsOne.AsInit();
	init();
	setPageSize(0,100);
	my_load(2,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>

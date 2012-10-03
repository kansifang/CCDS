<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sSql     = " ";


	String sHeaders[][] = {{"LoginID","用户号"},
							{"UserName","用户名"},
							{"OrgName","机构名"},
							{"ServerName","服务器名"},
							{"Remoteaddr","用户IP"},
							{"BeginTime","会话开始时间"}
							};


	sSql =" Select b.LoginID as LoginID,a.UserName as UserName,a.OrgName as OrgName, "+
		  "        a.Remoteaddr as Remoteaddr,a.BeginTime as BeginTime,a.ServerName as ServerName "+
	      " From User_List a,User_Info b "+
	      " Where a.begintime like '"+StringFunction.getToday()+"%' and a.endtime is null "+
	      "   and b.UserID =  a.UserID " +
	      " order by a.begintime";
	//利用Sql生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setHTMLStyle("LoginID,Remoteaddr"," style={width:100px} ");
	doTemp.setHTMLStyle("UserName,OrgName"," style={width:200px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


%>
<head>
<title>在线用户列表</title>
</head>
<body class="pagebackground"  leftmargin="0" topmargin="0" onload="" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr height=1 valign=top >
    <td>
    	<table>
	    	<tr>
	    		<td>
	                       <%=HTMLControls.generateButton("关闭","关闭","javascript:self.close()",sResourcesPath)%>
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

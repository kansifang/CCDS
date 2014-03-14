<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
<title>申请信息列表</title>
</head>

<%
	String sObjectType  = DataConvert.toString(CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toString(CurComp.getParameter("ObjectNo"));
	String sUserID = DataConvert.toString(request.getParameter("UserID"));
	String sOrgID = DataConvert.toString(request.getParameter("OrgID"));
	String sRightViewID = DataConvert.toString(request.getParameter("RightViewID"));
	String sOrgOrInd = DataConvert.toString(request.getParameter("OrgOrInd"));
	String sSql="";
	String sAvailableRightType=null,sRightTypeDDDWString=",";
	ASResultSet rs=null;
	
	sSql = "select * from VIEW_LIBRARY where ViewType = (select ViewType from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"') and ViewCode='"+sRightViewID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sAvailableRightType = rs.getString("AllowedShareType");
	}
	rs.getStatement().close();
	if(sAvailableRightType==null) sAvailableRightType="";
	
	if(sAvailableRightType.indexOf("All")>=0){
		sRightTypeDDDWString = sRightTypeDDDWString + ",All,可修改";
	}
	if(sAvailableRightType.indexOf("Append")>=0){
		sRightTypeDDDWString = sRightTypeDDDWString + ",Append,可补充";
	}
	if(sAvailableRightType.indexOf("ReadOnly")>=0){
		sRightTypeDDDWString = sRightTypeDDDWString + ",ReadOnly,只读";
	}

	String sHeaders[][] = { 
		{"ObjectType","对象类型"},
		{"ObjectNo","编号"},
		{"OrgName","机构"},
		{"RoleID","角色"},
		{"UserName","用户"},
		{"ViewID","可访问视图"},
		{"InputUser","录入人"},
		{"InputOrg","录入机构"},
		{"InputTime","录入时间"},
		{"UpdateUser","更新人"},
		{"UpdateTime","更新时间"},
		{"RightType","权限"}
		};
	
        sSql = "select ObjectType,ObjectNo,OrgID,GetOrgName(OrgID) as OrgName,UserID,GetUserName(UserID) as UserName,ViewID,InputUser,InputOrg,InputTime,UpdateUser,UpdateTime,RightType from OBJECT_USER where ObjectType='"+sObjectType+"' and ObjectNo='"+sObjectNo+"' "+
		"and UserID='"+sUserID+"' and OrgID='"+sOrgID+"' and ViewID='"+sRightViewID+"'"
		;
	

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="OBJECT_USER";
	doTemp.setKey("ObjectType,ObjectNo,OrgID,UserID,ViewID",true); 
	doTemp.setHeader(sHeaders);
	if(sOrgOrInd!=null&&sOrgOrInd.equals("1"))//赋给个人
		doTemp.setVisible("OrgName",false);
	else if(sOrgOrInd!=null&&sOrgOrInd.equals("2"))//赋给机构
		doTemp.setVisible("UserName",false);
	doTemp.setVisible("ObjectType,ObjectNo,OrgID,UserID,InputUser,InputOrg,InputTime,UpdateUser,UpdateTime",false);
	doTemp.setDDDWSql("ViewID","select ViewCode,ViewName from VIEW_LIBRARY where ViewType = (select ViewType from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"')");
	doTemp.setRequired("ObjectType,ObjectNo,UserID,ViewID,OrgName,UserName,RightType",true);
	doTemp.setReadOnly("OrgName,UserName,InputUser,InputOrg,InputTime,UpdateUser,UpdateTime,ViewID",true);
	doTemp.setUpdateable("OrgName,UserName",false);
	doTemp.setUnit("OrgName","<input type=button value=\"..\" class=inputDate onClick=\"parent.selectOrg()\">");
	doTemp.setUnit("UserName","<input type=button value=\"..\" class=inputDate onClick=\"parent.selectUser()\">");
	doTemp.setDDDWCodeTable("RightType",sRightTypeDDDWString);
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	//如果使用CUSTOMER_BELONG，则需要更新CUSTOMER_BELONG表
	dwTemp.Style="2";      //设置为Grid风格
	dwTemp.ReadOnly = "0"; //设置为可写
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

 
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >


<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr height=1 valign=top id="buttonback">
	<td>
		<table>
			<tr>
					<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","保存","保存","javascript:my_save()",sResourcesPath)%></td>
					<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","返回","返回","javascript:doCancel()",sResourcesPath)%></td>
			</tr>
		</table>
	</td>
	<td align=right>
		<table border="0" width="10" height="100%" cellspacing="0" cellpadding="0" >
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td colspan=2>
	<iframe name="myiframe0" width=100% height=100% frameborder=0></iframe>
	</td>
</tr>
</table>

<iframe name=myform0 frameborder=0 width=1 height=1 style="display:none"> </iframe>
</body>
</html>

<script language=javascript> 
	var bIsInsert=false;
	
	function selectOrg()
	{
		setObjectInfo("Org","OrgID=11@OrgID@0@OrgName@1",0,0);
		setItemValue(0,getRow(),"UserID","000000");
		setItemValue(0,getRow(),"UserName","缺省用户");
	}
	function selectUser()
	{
		sReturn = setObjectInfo("User","",0,0);
		sReturns = sReturn.split('@');
		sValue=sReturns[0];
		sName =sReturns[1];
		sBelongOrg =sReturns[2];
		sBelongOrgName =sReturns[3];
		setItemValue(0,getRow(),"UserID",sValue);
		setItemValue(0,getRow(),"UserName",sName);
		setItemValue(0,getRow(),"OrgID",sBelongOrg);
		setItemValue(0,getRow(),"OrgName",sBelongOrgName);		
	}
	
	function my_save()
	{  
		sRightType= getItemValue(0,getRow(),"RightType");
		sUserID = getItemValue(0,getRow(),"UserID") ;
	  
	  
		if(bIsInsert)
		{
			if (sUserID == "")
			{
				setItemValue(0,getRow(),"UserID","000000");
				setItemValue(0,getRow(),"UserName","任意用户");
			}
			sOrgID= getItemValue(0,getRow(),"OrgID");
			sUserID = getItemValue(0,getRow(),"UserID");
			sMessage = PopPage("/Common/ObjectRight/CheckUniqueAction.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&UserID="+sUserID+"&OrgID="+sOrgID,"","");
			if (sMessage != "succeeded") return;

			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sObjectNo%>");

			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"UpdateTime","<%=StringFunction.getToday()%>");

		}

		setItemValue(0,getRow(),"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,getRow(),"UpdateTime","<%=(StringFunction.getToday()+" "+StringFunction.getNow())%>");
		as_save("myiframe0"); 
	}

	function my_del(myiframename)
	{
		if(confirm("您真的想删除该申请及其相关信息吗？")) 
		{
			as_del(myiframename);
			as_save(myiframename);  //如果单个删除，则要调用此语句
		}
	}
	function initRow()
	{
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");
			setItemValue(0,getRow(),"ViewID","<%=sRightViewID%>");
			bIsInsert = true;
        } 		
	}
	
	function doCancel()
	{
		OpenPage("/Common/ObjectRight/ObjectRightList.jsp","_self","")
	}
</script>	
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>

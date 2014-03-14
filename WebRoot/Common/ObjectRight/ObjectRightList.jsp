<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<html>
<head>
<title>权限信息列表</title>
</head>

<%
	String sObjectType  = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	String sFinishedFlag = DataConvert.toRealString(iPostChange,CurComp.getParameter("FinishedFlag"));
	String sSql="";
	
	String sHeaders[][] = { {"ObjectType","对象类型"},{"ObjectNo","编号"},{"OrgName","机构"},{"RoleID","角色"},{"UserName","用户"},{"RightType","权限类型"},
		{"ViewName","可访问视图"},{"InputUser","录入人"},{"InputOrg","录入机构"},
		{"InputTime","录入时间"},{"UpdateUser","更新人"},{"UpdateTime","更新时间"}
		};
	

	sSql = "select ObjectType,ObjectNo,OrgID,GetOrgName(OrgID) as OrgName,UserID,GetUserName(UserID) as UserName,GetViewName(ObjectType,ViewID) as ViewName,ViewID,GetItemName('RightType',RightType) as RightType,getUserName(InputUser) as InputUser,getOrgName(InputOrg) as InputOrg,InputTime,getUserName(UpdateUser) as UpdateUser,UpdateTime from OBJECT_USER where ObjectType='"+sObjectType+"' and ObjectNo='"+sObjectNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="OBJECT_USER";
	doTemp.setKey("ObjectType,ObjectNo,OrgID,UserID,ViewID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setVisible("ObjectType,ObjectNo,OrgID,UserID,ViewID",false);
	doTemp.setRequired("ObjectType,ObjectNo,OrgID,UserID,ViewID",true);
	
	doTemp.setColumnAttribute("ObjectType,ObjectNo,OrgID,UserID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
%>
	<%
		//依次为：
			//0.是否显示
			//1.注册目标组件号(为空则自动取当前组件)
			//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
			//3.按钮文字
			//4.说明文字
			//5.事件
			//6.资源图片路径
		String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","my_add()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","my_mod()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","my_del()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>

<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<script language=javascript> 

	function my_add()
	{
		sReturn = PopPage("/Common/ObjectRight/ObjectRightDialog.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewID%>&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		sss = sReturn.split("@");
		sRightViewID=sss[0];
		sOrgOrInd=sss[1];
		if(sOrgOrInd==''|| sOrgOrInd.length<=0)
			return;
		OpenPage("/Common/ObjectRight/ObjectRightInfo.jsp?RightViewID="+sRightViewID+"&OrgOrInd="+sOrgOrInd+"&AddorChg=1&rand="+randomNumber(),"_self","");
		<!--AddorChg 用来判断是新增还是修改 Creat by whyu-->
	}
	function my_mod()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sUserID = getItemValue(0,getRow(),"UserID");
		sRightViewID = getItemValue(0,getRow(),"ViewID");
		sArgString = "&OrgID="+sOrgID+"&UserID="+sUserID+"&RightViewID="+sRightViewID;
		
		if(typeof(sOrgID)=="undefined" || sOrgID.length==0)
		{
			alert("请选择一条记录");
			return;
		}
		if(sUserID=="000000")
			OpenPage("/Common/ObjectRight/ObjectRightInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewID%>"+sArgString+"&OrgOrInd=2&AddorChg=2&rand="+randomNumber(),"_self","");
		else
			OpenPage("/Common/ObjectRight/ObjectRightInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewID%>"+sArgString+"&OrgOrInd=1&AddorChg=2&rand="+randomNumber(),"_self","");
		
	}
	function my_save()
	{
		as_save('myiframe0');
	}

	
	
	
	function my_del(myiframename)
	{
		
		if(confirm("您真的想删除该申请及其相关信息吗？")) 
		{
			as_del(myiframename);
			as_save(myiframename);  //如果单个删除，则要调用此语句
		}

	}
	
</script>	 
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');

</script>

<%@ include file="/IncludeEnd.jsp"%>

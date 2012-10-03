<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui  2003.8.18
		Tester:
		Content: 企业债券发行信息_List
		Input Param:
			                CustomerID：客户编号
			                CustomerRight:权限代码----01查看权，02维护权，03超级维护权
		Output param:
		                CustomerID：当前客户对象的客户号
		              	Issuedate:发行日期
		              	BondType:债券类型
		                CustomerRight:权限代码
		                EditRight:编辑权限代码----01查看权，02编辑权
		History Log: 
		                 2003.08.20 CYHui
		                 2003.08.28 CYHui
		                 2003.09.08 CYHui 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	
	//获得组件参数	
	String sUsersSelected =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UsersSelected",1));
	String sAlertID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertID",10));
	if(sAlertID==null) sAlertID="";
	//out.println(sUsersSelected);
	
	//获得页面参数	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ExampleList";
	String sTempletFilter = "1=1";

	//String[][] sHeaders = {
	//	{"CustomerID","客户编号"},
	//	{"CustomerName","客户名称"},
	//	{"UserID","人员"},
	//	{"UserName","人员"},
	//	{"BelongAttribute","有效"},
	//	};
	//	
	//sSql = "select GetUserName(CB.UserID) as UserName,CI.CustomerID,CI.CustomerName,CB.UserID,CB.OrgID,CB.BelongAttribute "+
	//	"from CUSTOMER_INFO CI,CUSTOMER_BELONG CB "+
	//	"where CI.CustomerID=CB.CustomerID and '"+sUsersSelected+"' not like '%'||CB.UserID||'%' and CB.UserID not in (select UserID from ALERT_HANDLE where SerialNo='"+sAlertID+"')";
	
	String sHeaders[][] = {	{"UserID","用户号"},
							{"UserName","用户名"},
							{"BelongOrg","所属机构号"},
							{"BelongOrgName","所属机构名"}
						  };

	sSql =	" select UserID,UserName,getOrgName(BelongOrg) as BelongOrgName,BelongOrg " +
					" from USER_INFO " +
					" where 1 = 1 and (BelongOrg != '' or BelongOrg is not null) ";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.multiSelectionEnabled=true;
	doTemp.setHeader(sHeaders);
	//doTemp.setVisible("",false);
	//doTemp.setDDDWCode("BelongAttribute","BelongAttribute");
	//生成查询
	doTemp.setFilter(Sqlca,"1","UserID","");
	doTemp.setFilter(Sqlca,"2","UserName","");
	doTemp.setFilter(Sqlca,"3","BelongOrg","");
	doTemp.setFilter(Sqlca,"4","BelongOrgName","");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
	//out.println(doTemp.SourceSql);
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","加入列表","将选中的人员加入分发目标用户列表","distribute()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	
	function distribute(){
		var sUsers = getItemValueArray(0,"UserID");
		var sUserString="";
		for(i=0;i<sUsers.length;i++){
			sUserString += "@" + sUsers[i];
		}
		if (typeof(sUserString)=="")
		{
			alert("请双击多选区，选择一条以上记录！");
			return;
		}

		parent.saveParaToComp("UsersSelected=<%=DataConvert.toString(sUsersSelected)%>"+sUserString,"reloadLeftAndRight()");
	}
    function filterAction(sObjectID,sFilterID,sObjectID2)
	{
		oMyObj = document.all(sObjectID);
		oMyObj2 = document.all(sObjectID2);
		if(sFilterID=="1")
		{
			sReturn = setObjectInfo("User","@UserID@0@UserName@1",0,0);
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_")
			{
				return;
			}else if(sReturn=="_CLEAR_")
			{
				oMyObj.value="";
			}else
			{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				oMyObj2.value=sReturns[1];
			}
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

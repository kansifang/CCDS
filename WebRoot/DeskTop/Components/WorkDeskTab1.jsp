
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	String sFlag = "0";
	String bForceDeleteTab = "true";
	String bForceAddTab = "true";
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
	};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="Tab09.jsp"%>
<%/*~END~*/%>


<script language="JavaScript">
	var bForceRefreshTab = false;
	var bForceDeleteTab = true;
	var bForceAddTab = true;
	var tabstrip = new Array();
	var tabType = new Array();
	var strip_id_increment = -1;
	var hangtableID="tabtd"
	function doTabAction(sArg){
		var sReturn="";
		if(sArg=="WorkTips")
		{
			sReturn="/DeskTop/WorkTips.jsp";
		}
		else if(sArg=="BusinessAlert")
		{
			sReturn="/CreditManage/CreditAlarm/AlarmHandleMain.jsp";
		}
		else if(sArg=="WorkRecordMain")
		{
			sReturn="/DeskTop/WorkRecordMain.jsp";
		}
		else if(sArg=="UserDefine")
		{
			sReturn="/DeskTop/UserDefineMain.jsp";
		}
		//add by lzhang 2011-03-21新增贷款发放和回收提示
		else if(sArg=="BalanceAlert")
		{
			sReturn="/CreditManage/CreditAlarm/AlarmBalanceMain.jsp";
		}
		return sReturn;
	}
	function newTab(tabname,url,para){
		addTab(tabname,url,para);
		var beginti=calBiginIndex(strip_id_increment,GbeginTabIndex);
		hc_drawTabToTable_plus_ex(tabstrip,strip_id_increment,beginti,iMaxTabLength,hangtableID);
		myTabAction(hangtableID,strip_id_increment,false,beginti);
		window.focus();
	}
	function addTab(tabname,url,para){
		tabstrip[++strip_id_increment] = new Array(strip_id_increment,
				tabname,
				"AsControl.OpenView('"+url+"','TextToShow="+tabname+para+"&ToInheritObj=y','"+(hangtableID+strip_id_increment)+"')",
				"AsControl.OpenView('"+url+"','TextToShow="+tabname+para+"&ToInheritObj=y','"+(hangtableID+strip_id_increment)+"')","1","1");
	}
	//第一个参数为Tab唯一标识，第二个参数为Tab显示名称，第三个参数为Tab的OnClick事件，第四个参数为oncontextmenu事件，
	var sMarrow = false;
	var tabname="",url="",para="";
	<%
	String sSql = " select ItemNo,ItemName,ItemAttribute from CODE_LIBRARY CL"+
			" where CodeNo = 'TabStrip'  and IsInUse = '1' ";
	//add by lzhang 2011/04/12 增加查看角色权限控制
	if(CurUser.UserID.equals("9999999")||CurUser.hasRole("062")||CurUser.hasRole("262")||CurUser.hasRole("462")){
		sSql += " order by SortNo ";
	}else{
		sSql += " and ItemNo <> '050'  Order by SortNo ";
	}	
	ASResultSet rs = Sqlca.getASResultSet(sSql);	 
	while(rs.next()){
 %> 
   	tabname="<%=rs.getString("ItemName")%>";
   	url=eval("<%=rs.getString("ItemAttribute")%>");
   	para="";
   	addTab(tabname,url,para);
 <%
  	}
   	rs.getStatement().close();
	%>
	var initTab = 1;
	var iMaxTabLength = 6;
</script>

<script	language=javascript>
	//参数依次为： tab定义数组,默认显示第几项,开始标签,最大显示数,目标单元格
	hc_drawTabToTable_plus_ex(tabstrip,1,1,iMaxTabLength,hangtableID);
	//设定默认页面
	var iIndex = 0;
	myTabAction(hangtableID,iIndex,false,1);
	window.focus();
</script>



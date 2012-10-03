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
	if(sUsersSelected==null) sUsersSelected="";
	//out.println(sUsersSelected);
	
	//获得页面参数	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ExampleList";
	String sTempletFilter = "1=1";

	String[][] sHeaders = {
		{"CustomerID","客户编号"},
		{"CustomerName","客户名称"},
		{"UserName","人员"},
		{"BelongAttribute","有效"},
		};
		
	sSql = "select UserID,UserName "+
		"from USER_INFO "+
		"where  '"+sUsersSelected+"@' like '%@'||UserID||'@%'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.multiSelectionEnabled=true;
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("UserID,OrgID,BelongAttribute",false);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	
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
		{"true","","Button","确认分发","将该警示信息分发至选中的人员","confirmDistribution()",sResourcesPath},
		{"true","","Button","从列表中去除","从已选择用户列表中去除","removeUsers()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------

	function removeUsers(){
		var sUsers = getUnselectedItemValueArray(0,"UserID");
		var sUserString="";
		for(i=0;i<sUsers.length;i++){
			//alert(sUsers[i]);
			sUserString += "@" + sUsers[i];
		}
		parent.saveParaToComp("UsersSelected="+sUserString,"reloadLeftAndRight()");
	}
	function confirmDistribution(){
		sRequirement = PopPage("/CreditManage/CreditAlarm/GetRequirementDialog.jsp","","dialogWidth:400px;dialogHeight:300px");
		if(typeof(sRequirement)=="undefined" || sRequirement=="" || sRequirement=="_CANCEL_") return;
		sReturn = PopPage("/CreditManage/CreditAlarm/ConfirmAlertDistributeAction.jsp?UserSelected=<%=sUsersSelected%>&Requirement="+sRequirement,"","dialogWidth:400px;dialogHeight:300px");
		if(typeof(sReturn)=="undefined"||sReturn=="failed") return;
		if(sReturn=="succeeded") self.close();
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	function getUnselectedItemValueArray(iDW,sColumnID){
		var b = getRowCount(iDW);
		var countSelected = 0;
		var sMemberIDTemp = "";
		var sSelected = new Array(1000);
		for(var iMSR = 0 ; iMSR < b ; iMSR++)
		{
			var a = getItemValue(iDW,iMSR,"MultiSelectionFlag");
			if(a != "√"){
				sSelected[countSelected] = getItemValue(iDW,iMSR,sColumnID);
				countSelected++;
			}
		}
		var sReturn = new Array(countSelected);
		for(var iReturnMSR = 0;iReturnMSR < countSelected; iReturnMSR++){
			sReturn[iReturnMSR] = sSelected[iReturnMSR];
		}
		return sReturn;
	}
	
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

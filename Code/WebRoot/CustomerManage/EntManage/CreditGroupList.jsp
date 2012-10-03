<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/10
		Tester:
		Describe: 信用共同体成员信息列表;
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			CustomerID：当前客户编号
			RelativeID：关联客户编号
			Relationship：关联关系

		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信用共同体成员信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"RelativeID","信用共同体成员编号"},
							{"CustomerName","成员名称"},
							{"CertID","证件号码"},
							{"CGALevelName","信用共同体内评定级别"},
							{"AssureGroupName","该成员所在联保小组"},
							{"OrgName","登记机构"},
							{"UserName","登记人"},	
							{"InputDate","登记日期"}
						  };

	String sSql =   " select CustomerID,RelativeID,CustomerName,CertID,"+
					" RelationShip,getItemName('AssessLevel',CGALevel) as CGALevelName,"+
					" getCustomerName(AssureGroupID) as AssureGroupName,"+
					" InputOrgId,getOrgName(InputOrgId) as OrgName,"+
					" InputUserId,getUserName(InputUserId) as UserName," +
					" InputDate" +
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"'"+
					" and RelationShip like '0701%'";

   //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	//设置主键。用于后面的删除
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	//设置不可见项
	doTemp.setVisible("CustomerID,RelationShip,InputUserId,InputOrgId",false);
	//格式设置
	doTemp.setCheckFormat("InputDate","3");
	doTemp.appendHTMLStyle("UserName,CGALevelName","style={width:80px}");		
	doTemp.appendHTMLStyle("OrgName"," style={width:200px} ");	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","新增","新增信用共同体成员信息","newRecord()",sResourcesPath},
		{"true","","Button","新增(按联保小组)","按联保小组新增信用共同体成员信息","newGroupRecord()",sResourcesPath},
		{"true","","Button","详情","查看联保小组成员信息详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除联保小组成员信息","deleteRecord()",sResourcesPath},
		{"true","","Button","客户详情","查看联保小组成员客户信息详情","viewCustomer()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/CreditGroupInfo.jsp","_self","");
	}
	
	/*~[Describe=新增记录(按联保小组);InputParam=无;OutPutParam=无;]~*/
	function newGroupRecord()
	{
		sParaString = "BelongOrg,<%=CurOrg.OrgID%>";
		sCustomerID = "<%=sCustomerID%>";
		sReturnValue=setObjectValue("SelectAssureGroup1",sParaString,"",0,0,"");
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
		{
				sReturnValue = sReturnValue.split("@");
				sGroupSerialNo=sReturnValue[0];
				sReturnValue = RunMethod("CustomerManage","BatchAddCreditGroup",sGroupSerialNo+","+sCustomerID+",<%=CurUser.UserID%>,<%=CurOrg.OrgID%>");
		}
		reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		sRelationShip = getItemValue(0,getRow(),"RelationShip");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/CustomerManage/EntManage/CreditGroupInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip, "_self","");
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomer()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			openObject("Customer",sRelativeID,"001");
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

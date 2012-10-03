<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-12-27
		Tester:
		Describe: 关联集团成员信息列表;
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			CustomerID：当前客户编号
			RelativeID：关联客户组织机构代码
			Relationship：关联关系
		HistoryLog:
					
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联集团成员信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
							{"CustomerName","集团成员名称"},
							{"CertType","证件类型"},
							{"CertID","证件号码"},
							{"RelationShipName","成员类型"},
							{"EntKeyMan","法定代表人"},
							{"UnfinishedBusiness","是否存在未结清业务或授信申请"},
							{"ManageOrgName","管户机构"},
							{"ManageUserName","管户客户经理"}
						  };

	String sSql =   " select CustomerID,RelativeID,CustomerName, "+
					" getItemName('CertType',CertType) as CertType, "+
					" CertID,RelationShip,getItemName('RelationShip',RelationShip) as RelationShipName, "+
					" getEntKeyMan(RelativeID,'0100') as EntKeyMan, "+
					" getItemName('HaveNot',getNotEndBusiness(RelativeID)) as UnfinishedBusiness, "+
					" getManageOrgName(RelativeID) as ManageOrgName, "+
					" getManageUserName(RelativeID) as ManageUserName, " +
					" InputOrgID,InputUserID "+
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"' "+
					" and RelationShip like '04%' " ;
				// 	" and length(RelationShip)>2 ";

   	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	//设置主键。用于后面的删除
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	//设置不可见项
	doTemp.setVisible("RelationShip,CustomerID,RelativeID,InputOrgID,InputUserID",false);
	//格式设置
	doTemp.setHTMLStyle("UnfinishedBusiness"," style={width:150px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setAlign("CertType,UnfinishedBusiness","2");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//删除反向关联信息
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.DeleteGroupInfo(#CustomerID,#RelativeID,#InputUserID)");

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

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
		{"true","","Button","新增","新增关联企业成员信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看关联企业成员信息详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除关联企业成员信息","deleteRecord()",sResourcesPath},
		{"true","","Button","客户详情","查看关联企业成员客户信息详情","viewCustomer()",sResourcesPath},
		{"true","","Button","集团客户搜索","集团客户搜索","listRelative()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/GroupMemberInfo.jsp?","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sCustomerName   = getItemValue(0,getRow(),"CustomerName");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
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
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/GroupMemberInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip, "_self","");
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomer()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			openObject("Customer",sRelativeID,"001");
		}
	}
	
	/*~[Describe=集团客户搜索;InputParam=无;OutPutParam=无;]~*/
	function listRelative()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
		}else 
		{					
			sSelectRelativeCustomer =PopPage("/CustomerManage/EntManage/SelectRelativeCustomer.jsp?CustomerID="+sRelativeID,"","top=40;dialogWidth=26;dialogHeight=30;resizable=yes;status:no;maximize:yes;help:no;");
			if(typeof(sSelectRelativeCustomer)!="undefined" && sSelectRelativeCustomer.length!=0 && sSelectRelativeCustomer != '_none_')
			{
				sUserID = "<%=CurUser.UserID%>" ;
			    sReturn=RunMethod("CustomerManage","AddListRelative",sSelectRelativeCustomer+","+<%=sCustomerID%>+","+sUserID);	
			    if(sReturn != "")
			    {
			      alert(sReturn);
			      reloadSelf();
			    }			
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
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --FMWu 2004-11-29
		Tester:
		Describe: --股东情况列表;
		Input Param:
			CustomerID：--当前客户编号
		Output Param:
			CustomerID：--当前客户编号
			RelativeID：--关联客户组织机构代码
			Relationship：--关联关系      
			EditRight:--权限代码（01：查看权；02：维护权）      
		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	参数、格式			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "股东情况列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
     String sSql = "";//--存放sql语句
	//获得页面参数

	//获得组件参数，客户代码
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = { 
							{"CustomerName","股东名称"},
							{"RelationShipName","出资方式"},
							{"InvestmentProp","出资比例(%)"},
							{"CurrencyTypeName","币种"},
							{"OughtSum","应出资金额"},
							{"InvestmentSum","实际投资金额"},
							{"InvestDate","投资时间"},
							{"EffStatus","是否有效"},
							{"OrgName","登记机构"},						
							{"UserName","登记人"}
						  };

	      sSql =	" select CustomerID,RelativeID,CustomerName,InvestmentProp,RelationShip,getItemName('RelationShip',RelationShip) as RelationShipName, " +
					" getItemName('Currency',CurrencyType) as CurrencyTypeName,OughtSum,InvestmentSum,InvestDate,getItemName('YesNo',EffStatus) as EffStatus, " +
					" InputOrgId,getOrgName(InputOrgId) as OrgName,InputUserId,getUserName(InputUserId) as UserName " +
					" from CUSTOMER_RELATIVE " +
					" where CustomerID = '"+sCustomerID+"' "+
					" and RelationShip like '52%' "+
					" and length(RelationShip)>2 ";


	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置修改的表
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
    //设置主键值
	doTemp.setKey("CustomerID,RelativeID,CustomerName,RelationShip",true);
	//设置不可见
	doTemp.setVisible("CustomerID,RelativeID,RelationShip,InputUserId,InputOrgId",false);
	//设置不可修改列
	doTemp.setUpdateable("UserName,OrgName,RelationName",false);
    //设置列类型
	doTemp.setType("InvestmentProp,OughtSum,InvestmentSum","Number");
	//设置列的宽度
	doTemp.setHTMLStyle("CurrencyTypeName,InvestDate,InvestmentProp"," style={width:80px} ");
    doTemp.setHTMLStyle("OrgName"," style={width:200px} ");  
    doTemp.setHTMLStyle("CustomerName"," style={width:200px} "); 
    doTemp.setHTMLStyle("UserName"," style={width:100px} "); 
    doTemp.setHTMLStyle("EffStatus"," style={width:30px} "); 
	doTemp.setAlign("RelationShipName,CurrencyTypeName,UserName","2");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	//设置setEvent
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

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
			{"true","","Button","新增","新增资本构成","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看资本构成详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除资本构成","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
	    sUserID=getItemValue(0,getRow(),"InputUserId");//--用户代码
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--客户代码
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(sUserID == '<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}
		}else alert(getHtmlMessage('3'));
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{      
		sUserID=getItemValue(0,getRow(),"InputUserId");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='02'; 
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");//--客户代码
		sRelationShip = getItemValue(0,getRow(),"RelationShip");//--客户关联
		sRelativeID   = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight="+sEditRight, "_self","");
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

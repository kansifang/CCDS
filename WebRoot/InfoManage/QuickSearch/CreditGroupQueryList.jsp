<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: 公司客户快速查询
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：公司客户快速查询
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;//--存放sql语句
	String sComponentName;//--组件名称
	String PG_CONTENT_TITLE;
	//获得组件参数	
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	//定义表头文件
	String sHeaders[][] = { 							
								{"CustomerID","客户编号"},
								{"EnterpriseName","名称"},
								{"VillageName","所在区域"},
								{"SuperCorpName","掌控人名称"},
								{"EmployeeNumber","总户数"},
								{"VouchCorpName","担保人名称"},
								{"InputOrgName","登记机构"},
								{"InputUserName","登记人"},
								{"InputDate","登记日期"},
								{"UpdateUserName","更新人员"},
								{"UpdateOrgName","更新机构"},
								{"UpdateDate","更新日期"},
				   }; 
		sSql =	" select CustomerID,EnterpriseName,getVillageName(VillageCode) as VillageName,SuperCorpName, EmployeeNumber,VouchCorpName,"+
				" getUserName(InputUserID) as InputUserName, "+
				" getOrgName(InputOrgID) as InputOrgName,InputDate, "+
				" getUserName(UpdateUserID) as UpdateUserName,"+
				" getOrgName(UpdateOrgID) as UpdateOrgName,UpdateDate "+
				" from ENT_INFO" +
				" where CustomerID in (select CustomerID from CUSTOMER_BELONG "+
				" where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')) "+
				" and OrgNature like '05%'";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);   
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	doTemp.UpdateTable= "ENT_INFO";
	doTemp.setKey("CustomerID",true);	 

	//设置字段类型
    doTemp.setHTMLStyle("EnterpriseName","style={width:200px}");
    doTemp.setHTMLStyle("EmployeeNumber","style={width:30px}");    
    doTemp.setHTMLStyle("InputOrgName,UpdateOrgName","style={width:200px}"); 
       
    doTemp.setCheckFormat("UpdateDate,InputDate","3");
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerID","");
	doTemp.setFilter(Sqlca,"2","EnterpriseName","");
	

	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);  //服务器分页
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteCustomer(#CustomerID)") ;
	//生成HTMLDataWindow
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
		{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","客户交易流水信息","客户交易流水信息","viewBusinessSerialInfo()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
		//{"true","","Button","彻底删除客户信息","删除高管信息","deleteRecord()",sResourcesPath},
	};
	
	if(CurUser.hasRole("095")||CurUser.hasRole("0A2")||CurUser.hasRole("0B5")||CurUser.hasRole("0C2")||
	 CurUser.hasRole("0D2")||CurUser.hasRole("0E9")||CurUser.hasRole("0F4")||CurUser.hasRole("0H5")||
	 CurUser.hasRole("0I4")||CurUser.hasRole("0J1")||CurUser.hasRole("282")||CurUser.hasRole("295")||
	 CurUser.hasRole("2A4")||CurUser.hasRole("2B9")||CurUser.hasRole("2C2")||CurUser.hasRole("2D4")||
	 CurUser.hasRole("2E4")||CurUser.hasRole("2G5")||CurUser.hasRole("2H5")||CurUser.hasRole("2I2")||
	 CurUser.hasRole("421")||CurUser.hasRole("495"))
	{
		sButtons[2][0] = "false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得客户编号
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");
		}

	}	
	
	/*~[Describe=查看客户交易流水信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewBusinessSerialInfo()
	{
		//获得客户编号
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			popComp("BusinessSerialInfoList","/InfoManage/QuickSearch/BusinessSerialInfoList.jsp","ComponentName=公司客户交易流水信息列表&CustomerID="+sCustomerID,"","");
		}

	}
    	
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
    	if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    	{
   			as_del('myiframe0');
   			as_save('myiframe0');  //如果单个删除，则要调用此语句
   		}	
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

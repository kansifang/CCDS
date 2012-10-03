<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2004-12-23
		Tester:
		Describe: 代理机构列表;
		Input Param:

		Output Param:
				
		HistoryLog:zywei 2005/09/07 重检代码
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "代理机构列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	
	//获得组件参数
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {	
							{"AgencyName","代理机构名称"},
							{"AgencyLicense","营业执照编号"},
							{"AgencyTel","联系电话"},				
							{"AgencyAdd","地址"},
							{"PrincipalName","负责人姓名"},
							{"UserName","登记人"},
							{"OrgName","登记机构"},
							{"InputDate","登记日期"}								
						  };

	String sSql =	" select SerialNo,AgencyName,AgencyLicense,AgencyTel,AgencyAdd, "+
				    " PrincipalName,InputUserID,getUserName(InputUserID) as UserName, "+
				    " InputOrgID,getOrgName(InputOrgID) as OrgName,InputDate "+
				    " from AGENCY_INFO "+			
				    " where AgencyType='02' "+
				    " order by InputDate desc ";

	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "AGENCY_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("SerialNo,InputUserID,InputOrgID",false);	

	doTemp.setHTMLStyle("UserName,OrgName,InputDate,AgencyTel"," style={width:80px} ");
	doTemp.setHTMLStyle("AgencyName,AgencyLicense,AgencyAdd,PrincipalName","style={width=120px} ");
	//生成查询框
	doTemp.setColumnAttribute("AgencyName,AgencyLicense","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页

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
				{"true","","Button","新增","新增代理机构","newRecord()",sResourcesPath},
				{"true","","Button","详情","查看代理机构","viewAndEdit()",sResourcesPath},
				{"true","","Button","下属代理人","查看下属代理人","my_agent()",sResourcesPath},
				{"true","","Button","已代理案件","查看已代理案件","my_lawcase()",sResourcesPath},
				{"true","","Button","删除","删除代理机构","deleteRecord()",sResourcesPath}
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
		OpenPage("/RecoveryManage/Public/AgencyInfo.jsp","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
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

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		OpenPage("/RecoveryManage/Public/AgencyInfo.jsp?SerialNo="+sSerialNo, "_self","");
	}

	/*~[Describe=下属代理人信息;InputParam=无;OutPutParam=无;]~*/
	function my_agent()
	{
		//获得代理机构流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		OpenPage("/RecoveryManage/Public/AgentList.jsp?BelongNo="+sSerialNo+"&Flag=Y&rand="+randomNumber(),"_self","");           	
	}
	
	/*~[Describe=已代理案件信息;InputParam=无;OutPutParam=无;]~*/
	function my_lawcase()
	{
		//获得法院流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		OpenPage("/RecoveryManage/Public/SupplyLawCase.jsp?QuaryName=OrgNo&QuaryValue="+sSerialNo+"&Back=1&rand="+randomNumber(),"_self","");           			
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

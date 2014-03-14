<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   --CYHui 2005-1-25
			Tester:
			Content: --关联集合快速查询
			Input Param:
				--下列参数作为组件参数输入
				--ComponentName	组件名称：关联集团客户快速查询
		          
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "关联集团快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "";//--标题
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//定义表头文件
	String sHeaders[][] = { 							
					{"CustomerID","客户编号"},
					{"EnterpriseName","集团名称"},
					{"EnglishName","集团简称"},
					{"RegionCodeName","集团总部所在地"},
					{"RelativeType","主管客户经理联系电话"},
					{"OrgName","管户机构"},
					{"UserName","管户客户经理"},
					{"InputOrgName","登记机构"},
					{"InputUserName","登记人"},
					{"InputDate","登记日期"},
					{"UpdateUserName","更新人员"},
					{"UpdateOrgName","更新机构"},
					{"UpdateDate","更新日期"}
				  }; 
	
	sSql =	" select EI.CustomerID as CustomerID,EI.EnterpriseName,EI.EnglishName, "+
	" getItemName('AreaCode',EI.RegionCode) as RegionCodeName, "+
	" RelativeType,getOrgName(CB.OrgID) as OrgName, "+
	" getUserName(CB.UserID) as UserName, "+
	" getOrgName(EI.InputOrgID) as InputOrgName, "+
	" getUserName(EI.InputUserID) as InputUserName, "+
	" EI.InputDate as InputDate, "+
	" getUserName(EI.UpdateUserID) as UpdateUserName, "+
	" getOrgName(EI.UpdateOrgID) as UpdateOrgName, "+
	" EI.UpdateDate as UpdateDate "+
	" from ENT_INFO EI,CUSTOMER_BELONG CB "+
	" where EI.CustomerID = CB.CustomerID "+
	" and CB.BelongAttribute = '1' "+
	" and  EI.OrgNature like '02%' "+
	" and CB.OrgID in (select OrgId "+
	" from ORG_INFO "+
	" where SortNo like '"+CurOrg.SortNo+"%')";
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("EI.CustomerID");
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ENT_INFO";	
	//设置关键字
	doTemp.setKey("CustomerID",true);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	//设置下拉框内容
	doTemp.setDDDWCode("OrgNature","CustomerType");

	//生成查询框
	doTemp.setColumnAttribute("CustomerID,EnterpriseName,EnglishName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
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
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath}
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


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得抵债资产流水号、抵债资产类型
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
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

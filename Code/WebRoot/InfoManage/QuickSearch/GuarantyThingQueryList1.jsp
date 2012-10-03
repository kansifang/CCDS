<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-26
		Tester:
		Content: 担保物信息快速查询
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：担保物信息快速查询
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "担保物信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	String sComponentName = "";//--存放组件名称
	String PG_CONTENT_TITLE = "";
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
		String sHeaders[][] =	{ 							
									{"OwnerName","权利人名称"},
									{"GuarantyID","质押物编号"},
									{"GuarantyName","质押物名称"},
									{"GuarantyType","质押物类型"},
									{"GuarantyTypeName","质押物类型"},
									{"GuarantyRightID","权证号"},//new
									{"OwnerType","权属人类型"},
									{"EvalCurrencyName","质押物币种"},
									{"EvalNetValue","质押物金额"},
									{"ConfirmValue","贷款本息总额"},
									{"GuarantyRate","质押率"}
								}; 
		
		sSql =	" select GI.GuarantyID,GI.GuarantyName,GI.GuarantyType,getItemName('GuarantyList',GI.GuarantyType) as GuarantyTypeName,GI.OwnerName, " +
				" GI.GuarantyRightID,getItemName('SecurityType',GI.OwnerType) as OwnerType," +
				" GI.EvalCurrency,getItemName('Currency',GI.EvalCurrency) as EvalCurrencyName,GI.EvalNetValue,"+
				" GI.ConfirmValue,GI.GuarantyRate ,GR.ObjectNo" +
		       	" from GUARANTY_INFO GI,GUARANTY_RELATIVE GR " +
				" where GI.GuarantyID = GR.GuarantyID and GR.ObjectType='BusinessContract' "+
				" and GuarantyType like '020%' and InputOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("GI.GuarantyID");
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_INFO";	
	//设置关键字
	doTemp.setKey("GuarantyID",true);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("OwnerName","style={width:250px} ");  
	//设置不可见项
	doTemp.setVisible("EvalCurrency,GuarantyType,GuarantyCurrency,ObjectNo",false);		
	//设置对齐方式
	doTemp.setAlign("EvalNetValue,ConfirmValue","3");
	doTemp.setType("EvalNetValue,ConfirmValue","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("EvalNetValue,ConfirmValue","2");	
	//设置下拉框
	doTemp.setDDDWSql("GuarantyType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'GuarantyList' and ItemNo  like '020%' and length(ItemNo) > 3");

	//生成查询框
	doTemp.setFilter(Sqlca,"1","GuarantyName","");
	doTemp.setFilter(Sqlca,"2","GuarantyType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"3","EvalNetValue","");
	doTemp.setFilter(Sqlca,"4","GuarantyID","");
	doTemp.setFilter(Sqlca,"5","GuarantyRightID","");
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
		{"true","","Button","业务合同详情","业务合同详情","viewTab()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
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
		//获得担保物流水号
		sGuarantyID    =getItemValue(0,getRow(),"GuarantyID");	
		sGuarantyType=getItemValue(0,getRow(),"GuarantyType");
		if (typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
		    popComp("GuarantyThingQueryInfo","/InfoManage/QuickSearch/GuarantyThingQueryInfo.jsp","GuarantyType="+sGuarantyType+"&GuarantyID="+sGuarantyID,"","");
		}			 
	}	
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
    	
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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

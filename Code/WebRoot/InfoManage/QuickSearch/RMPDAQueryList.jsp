<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   FSGong 2004.12.07
		Tester:
		Content: 抵债资产快速查询
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：抵债资产快速查询
					ObjectType		对象类型：ASSET_INFO
												上述参数的目的是保持扩展性,将来可能还会考虑其他资产。
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;//存放sql语句
	String sComponentName;//--组件名称
	String PG_CONTENT_TITLE;//--题头
	String sObjectType="ASSET_INFO";//--对象类型
	
	//获得组件参数	,组件名称
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","资产编号"},										
							{"AssetName","资产名称"},
							{"AssetStatus","资产状态"},
							{"AssetStatusName","资产状态"},
							{"Flag","抵入表内/表外"},
							{"FlagName","抵入表内/表外"},
							{"AssetType","资产类别"},	
							{"AssetTypeName","资产类别"},	
							{"AssetSum","抵债金额(元)"},
							{"AssetBalance","资产余额(元)"},
							{"ManageUserID","管理人"},
							{"ManageOrgID","管理机构"}
						}; 

	//从抵债资产信息表ASSET_INFO中选出已抵入/处置中的资产

	sSql = 	" select SerialNo,"+
			" AssetName,"+
			" AssetStatus,"+
			" getItemName('AssetStatus',trim(AssetStatus)) as AssetStatusName,"+
			" AssetType,"+
			" getItemName('PDAType',trim(AssetType)) as AssetTypeName,"+
			" Flag ,"+
			" getItemName('Flag',Flag) as FlagName,"+
			" AssetSum, " +	
			" AssetBalance, " +	
			" getUserName(ManageUserID) as ManageUserID, " +	
			" getOrgName(ManageOrgID) as ManageOrgID"+			
			" from ASSET_INFO" +
			" where AssetAttribute='01' "+
			" and ObjectType='AssetInfo' "+
			" order by AssetName desc";
	//AssetAttribute：01－抵债资产、02－查封资产
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("SerialNo");

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";
	
	//设置关键字
	doTemp.setKey("SerialNo",true);	 

	//设置不可见项
	doTemp.setVisible("AssetType,Flag,AssetStatus",false);

	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("SerialNo","style={width:100px} ");  
	doTemp.setHTMLStyle("AssetTypeName,FlagName","style={width:85px} ");  
	doTemp.setHTMLStyle("AssetName,ManageUserID,ManageOrgID,AssetSum,AssetBalance,AssetNo,AssetStatusName"," style={width:80px} ");
	
	//设置对齐方式
	doTemp.setAlign("AssetSum,AssetBalance","3");
	doTemp.setType("AssetSum,AssetBalance","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("AssetSum,AssetBalance","2");
		
	//生成查询框*************************************************************************************
	doTemp.setDDDWCode("AssetType","PDAType");
	doTemp.setDDDWCode("AssetStatus","AssetStatus");

	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","AssetName","");
	doTemp.setFilter(Sqlca,"2","AssetType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"3","AssetStatus","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"4","ManageOrgID","");
	doTemp.setFilter(Sqlca,"5","ManageUserID","");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
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
		{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath}
	};
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
		//获得抵债资产流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");			
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo+"&RightType=ReadOnly","");
		reloadSelf();
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

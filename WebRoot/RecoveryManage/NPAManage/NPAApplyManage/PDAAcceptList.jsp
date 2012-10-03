<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/09/08
		Tester:
		Describe: 抵债资产信息(收取)列表
		Input Param:
			ObjectType: 对象类型
			ObjectNo：对象编号
		Output Param:
			SerialNo：业务流水号
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产信息(收取)列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";//sql语句
	ASResultSet rs = null;
	//获得页面参数
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";

%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
	String sHeaders[][] = 	{
				{"SerialNo","抵债资产编号"},	
				{"ObjectNo","以资抵债申请编号"},
				{"CustomerName","客户名称"},
				{"BorrowerName","抵偿人名称"},
				{"BorrowerTypeName","抵偿人类别"},
				{"AssetTypeName","资产类型"},				
				{"AssetName","资产名称"},
				{"AssetAmount","抵债资产数量"},
				{"AssetMarketSum","抵债资产市价"},
				{"AssetEvaluateSum","抵债资产评估价"},
				{"EnterAccountSum","抵债资产拟入帐价格"},
				{"Number","拟抵偿贷款笔数"},
				{"AssetSum","拟抵偿贷款本金(元)"},
				{"AssetIBalance1","拟抵偿表内利息(元)"},
				{"AssetIBalance2","拟抵偿表外利息(元)"},
				{"OrgName","登记机构"},
				{"UserName","登记人"},
			      	};
	
	
			      		
	sSql =	" select ObjectNo,SerialNo,CustomerName,BorrowerName,getItemName('BorrowerType1',BorrowerType) as BorrowerTypeName,"+
			" AssetType,getItemName('PDAAssetType',AssetType) as AssetTypeName,AssetName,"+
			" AssetAmount,"+
			" AssetMarketSum,AssetEvaluateSum,EnterAccountSum,"+
			" Number,AssetSum,AssetBalance,AssetIBalance1,AssetIBalance2, "+
			" InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName,AssetFlag " +
			" from ASSET_INFO " +
			" where ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' " ;


	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	doTemp.setVisible("AssetBalance,ObjectType,AssetType,AssetFlag,InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);

	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	
	//设置小数显示状态,
	doTemp.setAlign("AssetSum,AssetBalance,AssetIBalance1,AssetIBalance2,AssetMarketSum,AssetEvaluateSum,EnterAccountSum","3");
	doTemp.setType("AssetSum,AssetBalance,AssetIBalance1,AssetIBalance2,AssetMarketSum,AssetEvaluateSum,EnterAccountSum","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("AssetSum,AssetBalance,,AssetIBalance1,AssetIBalance2,AssetMarketSum,AssetEvaluateSum,EnterAccountSum","2");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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

	String sButtons[][] = 
		{
		{"true","","Button","新增","新增抵债资产信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看抵债资产信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除抵债资产信息","deleteRecord()",sResourcesPath},
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
		OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/PDAAcceptInfo.jsp","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
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
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sAssetType   = getItemValue(0,getRow(),"AssetType");
		sAssetFlag   = getItemValue(0,getRow(),"AssetFlag");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/PDAAcceptInfo.jsp?SerialNo="+sSerialNo+"&AssetType="+sAssetType+"&AssetFlag="+sAssetFlag, "_self","");
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

<%@include file="/IncludeEnd.jsp"%>

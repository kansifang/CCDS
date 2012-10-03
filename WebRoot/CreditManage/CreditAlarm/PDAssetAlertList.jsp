<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/10/20
*	Tester:
*	Describe: 抵债资产信息提示列表
*	Input Param:
*	Output Param:  
*		DealType:树图节点号
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产信息提示列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%
	//定义变量	    
	String sSql = "";
	//获得组件参数
	String sAlarmType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AlarmType"));
	if(sAlarmType == null) sAlarmType="";
	//获得页面参数
			
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义标题
	String sHeaders[][] = {
							{"SerialNo","以资抵债申请编号"},
							{"AssetTypeName","抵债资产类别"},
							{"AssetName","抵债资产名称"},
							{"AccountDescribe","抵债资产规格"},
							{"PayDate","取得时间"},
							{"PayTypeName","取得方式"},
							{"AssetAmount","抵债资产数量"},
							//{"","抵债资产入账金额"},
							{"AssetSum","抵偿贷款本金"},
							{"AssetBalance","拟抵偿贷款利息"},
							//{"","抵偿表内利息"},
							//{"","抵偿表外利息"},
							{"ManageUserName","管户人"},
							{"ManageOrgName","管户机构"}
						}; 

 	sSql = " select AI.SerialNo as SerialNo, AI.ObjectNo as ObjectNo,AI.ObjectType as ObjectType ," + 	
		   " getItemName('PDAAssetType',AI.AssetType) as AssetTypeName,AI.AssetName as AssetName," + 
		   " AI.AccountDescribe as AccountDescribe,AI.PayDate as PayDate,getItemName('PDAGainType',AI.PayType) as PayTypeName,"+
		   " AI.AssetAmount as AssetAmount,AI.AssetSum as AssetSum,AI.AssetBalance as AssetBalance,"+
		   " BA.ManageUserID as ManageUserID,getUserName(BA.ManageUserID) as ManageUserName," + 
		   " BA.ManageOrgID as ManageOrgID,getOrgName(BA.ManageOrgID) as ManageOrgName " + 
		   " from ASSET_INFO AI,BADBIZ_APPLY BA "+
		   " where BA.SerialNo=AI.ObjectNo and AI.ObjectType='BadBizApply' and BA.ApplyType='010' "+
		   " and BA.ManageUserID='"+CurUser.UserID+"' "+
		   " and BA.ManageOrgID='"+CurOrg.OrgID+"'";
	
		   
	//根据树图取不同结果集	   
	if(sAlarmType.equals("010140"))//台账信息未维护
	{
		sSql+=" and BA.ManageFlag='030' "+
				" and (AI.VindicateDate is  null or AI.VindicateDate ='' or "+
				" days(replace(AI.VindicateDate,'/','-'))<=days(current date)-20)";
	}if(sAlarmType.equals("010150"))//盘点未清查
	{
		sSql+=" and BA.ManageFlag='030' "+
				" and (AI.LiquidateDate is  null or AI.LiquidateDate ='' or "+
				" days(replace(AI.LiquidateDate,'/','-'))<=days(current date)-20)";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("ObjectNo,ObjectType,ManageUserID,ManageOrgID",false);
    
	//设置行宽
	doTemp.setHTMLStyle("InputDate"," style={width:65px} ");
	doTemp.setHTMLStyle("OperateOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("OperateUserName"," style={width:60px} ");

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,InterestBalance ","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,InterestBalance","2");
	doTemp.setCheckFormat("Number","5");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,InterestBalance,Number","3");
	
	//生成查询框
	doTemp.setColumnAttribute("SerialNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(20); 	//服务器分页
	
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
		{"true","","Button","抵债详情","抵债详情","viewTab()",sResourcesPath},
		};

%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>


<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		//获得申请类型、申请流水号
		sObjectType = "BadBizApply";
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
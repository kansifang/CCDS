<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: zwhu 2009/10/13
*	Tester:
*	Describe: 台帐维护抵债资产信息列表
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
	String PG_TITLE = "台帐维护抵债资产信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";
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
	if(sDealType.equals("020010"))//已抵入待处置资产
	{
		sSql+=" and AI.AssetFlag in('040','020')  ";
	}else if(sDealType.equals("020020"))//处置中资产
	{
		sSql+=" and AI.AssetFlag='050'  ";
	}else if(sDealType.equals("020030"))//已处置资产
	{
		sSql+=" and AI.AssetFlag='060'  ";
	}else
	{
		sSql+=" and 1=2";
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
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
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
		{"false","","Button","新增","新增","new_Record()",sResourcesPath},
		{"true","","Button","抵债详情","抵债详情","viewTab()",sResourcesPath},
		{"false","","Button","抵入账面登记","抵入账面登记","account_Register()",sResourcesPath},
		{"false","","Button","处置登记","处置登记","dispose_Register()",sResourcesPath},
		{"false","","Button","处 置","处置中","deal_With()",sResourcesPath},
		{"false","","Button","处置完毕","处置完毕","do_Done()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","export_Excel()",sResourcesPath}	
		};
	if(sDealType.equals("020010"))//已抵入待处置资产
	{
		sButtons[getBtnIdxByName(sButtons,"新增")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"抵入账面登记")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"处 置")][0]="true";
	}else if(sDealType.equals("020020"))//处置中资产
	{
		sButtons[getBtnIdxByName(sButtons,"新增")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"抵入账面登记")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"处置完毕")][0]="true";
	}else if(sDealType.equals("020030"))//已处置资产
	{
		sButtons[getBtnIdxByName(sButtons,"处置登记")][0]="true";
	}
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
	
	/*~[Describe=处置;InputParam=无;OutPutParam=无;]~*/   
	function deal_With()
	{
		//获得合同流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//以资抵债编号
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//抵债资产编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");//对象类型
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			//验证补登信息是否填写
			sReturn=RunMethod("PublicMethod","GetColValue","AccountSum,ASSET_INFO,String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null") 
			{	
				alert("请进行抵入账面登记再点击!");
				return;
			}else
			{
				//抵债资产信息):处置中
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ASSETFLAG@050,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
					//查询抵债资产是否全部处置
					//sReturn=RunMethod("PublicMethod","GetColValue","count(*),ASSET_INFO,String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType+"@String@ASSETFLAG@040");
					//sReturnInfo=sReturn.split("@")
					//if(sReturnInfo[1] == "0")// 
					//{	
					//	//更新不良资产申请表(抵债资产基本表):处置中
					//	sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ManageFlag@040,BADBIZ_APPLY,String@SerialNo@"+sObjectNo);	
					//}
					alert(getHtmlMessage('71'));//操作成功
					self.location.reload();
				}else
				{
					alert(getHtmlMessage('72'));//操作失败
					return;
				}
			}
		}
	}
	
	/*~[Describe=处置完毕;InputParam=无;OutPutParam=无;]~*/   
	function do_Done()
	{
		//获得合同流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//以资抵债编号
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//抵债资产编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");//对象类型
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			//验证补登信息是否填写
			sReturn=RunMethod("PublicMethod","GetColValue","AccountSum,ASSET_INFO,String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null") 
			{	
				alert("请进行抵入账面登记再点击!");
				return;
			}else
			{
				//抵债资产信息):处置完毕
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ASSETFLAG@060,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
					////查询抵债资产是否全部处置
					//sReturn=RunMethod("PublicMethod","GetColValue","count(*),ASSET_INFO,String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType+"@String@ASSETFLAG@050");
					//sReturnInfo=sReturn.split("@")
					//if(sReturnInfo[1] == "0")// 
					//{	
					//	//更新不良资产申请表(抵债资产基本表):处置完毕
					//	sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ManageFlag@050,BADBIZ_APPLY,String@SerialNo@"+sObjectNo);
					//}
					alert(getHtmlMessage('71'));//操作成功
					self.location.reload();
				}else
				{
					alert(getHtmlMessage('72'));//操作失败
					return;
				}
			}
		}
	}

	/*~[Describe=抵入账面登记;InputParam=无;OutPutParam=无;]~*/
	function account_Register()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/AccountManage/APDAssetAccountInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_self",""); 
		}
	}
	
	/*~[Describe=处置登记;InputParam=无;OutPutParam=无;]~*/    
	function dispose_Register()
	{
		//获得还款流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			popComp("DisposeRegisterList","/RecoveryManage/AccountManage/DisposeRegisterList.jsp","ComponentName=资产处置登记列表&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
	}
	
	/*~[Describe=导出Excel;InputParam=无;OutPutParam=无;]~*/
	function export_Excel()
	{
		amarExport("myiframe0");
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
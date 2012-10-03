<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/09/23
*	Tester:
*	Describe: 抵债资产信息列表
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
	String PG_TITLE = "抵债资产信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	System.out.println("sDealType="+sDealType);
	//获得页面参数
			
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义标题
	String sHeaders[][] = {
							{"BadSerialNo","以资抵债申请编号"},
							{"SerialNo","抵债资产编号"},
							{"AssetCustomerName","抵偿人名称"},
							{"AssetContractNo","抵偿贷款合同流水号"},
							{"AssetTypeName","资产类型"},
							{"AssetName","抵债资产名称"},
							{"AccountDescribe","抵债资产规格"},
							{"PayDate","取得时间"},
							{"PayTypeName","取得方式"},
							{"AssetAmount","抵债资产数量"},
							{"InAccontSum","抵债资产入账金额"},
							{"AssetSum","抵偿贷款本金"},
							{"AssetBalance","拟抵偿贷款利息"},
							{"InterestBalance1","抵偿表内利息"},
							{"InterestBalance2","抵偿表外利息"},
							{"KeepTypeName","抵债资产保管方式"},
							{"PracticeKeepPlace","抵债资产实物保管地点"},
							{"PracticeKeeper","实物保管人"},
							{"RightCardKeepPlace","抵债资产权证保管地点"},
							{"RightCardKeeper","权证保管人"},
							{"AssetLocation","坐落(保管)地点"},
							{"AssetStatus","抵债资产现状"},
							{"AssetArea","土地面积(亩)"},
							{"AssetArea1","房产面积(平方米)"},
							{"AssetAna","土地性质"},
							{"TransferFlag","是否过户"},
							{"AssetOccurType","发生类型"},
							{"AssetAccountSum","抵债资产入账金额"},
							{"AssetAccountBalance","抵债资产账面余额"},
							{"MainManager","经营管理主责任人"},
							{"ManageUserName","管户人"},
							{"ManageOrgName","管户机构"}
						}; 

 	sSql = " select AI.SerialNo as SerialNo, BA.Serialno as BadSerialNo,AI.ObjectNo as ObjectNo,AI.ObjectType as ObjectType ," + 	
		   " AI.AssetType as AssetType,"+
		   " AI.AssetCustomerName as AssetCustomerName,AI.AssetContractNo as AssetContractNo,"+
		   " getItemName('PDAAssetType',AI.AssetType) as AssetTypeName,"+
		   " AI.AssetName as AssetName," + 
		   " AI.AccountDescribe as AccountDescribe,AI.PayDate as PayDate,getItemName('PDAGainType',AI.PayType) as PayTypeName,"+
		   " BA.InAccontSum as InAccontSum,"+
		   " AI.AssetAmount as AssetAmount,AI.AssetSum as AssetSum,AI.AssetBalance as AssetBalance,"+
		   " BA.InterestBalance1 as InterestBalance1,BA.InterestBalance2 as InterestBalance2,"+
		   " getItemName('PDAKeepType',AI.KeepType) as KeepTypeName,"+
		   " AI.RightCardKeepPlace as RightCardKeepPlace,"+
		   " AI.PracticeKeepPlace as PracticeKeepPlace,AI.PracticeKeeper as PracticeKeeper,"+
		   " AI.RightCardKeeper as RightCardKeeper,"+
		   " AI.AssetLocation as AssetLocation,getItemName('AssetActualStatus',AI.AssetStatus) as AssetStatus,"+
		   " AI.AssetArea as AssetArea,AI.AssetArea as AssetArea1,"+
		   " getItemName('SoilProperty',AI.AssetAna) as AssetAna,getItemName('YesNo',AI.TransferFlag) as TransferFlag,"+
		   " getItemName('ExistNewType',AI.AssetOccurType) as AssetOccurType,AI.AssetAccountSum as AssetAccountSum,"+
		   " AI.AssetAccountBalance as AssetAccountBalance,"+
		   " AI.MainManager as MainManager,"+
		   " BA.ManageUserID as ManageUserID,getUserName(BA.ManageUserID) as ManageUserName," + 
		   " BA.ManageOrgID as ManageOrgID,getOrgName(BA.ManageOrgID) as ManageOrgName,AI.AssetFlag as AssetFlag  " + 
		   " from ASSET_INFO AI,BADBIZ_APPLY BA "+
		   " where BA.SerialNo=AI.ObjectNo and AI.ObjectType='BadBizApply' and BA.ApplyType='010' "+
		   " and BA.ManageUserID='"+CurUser.UserID+"' "+
		   " and BA.ManageOrgID='"+CurOrg.OrgID+"'";
	
		   
	//根据树图取不同结果集	   
	if(sDealType.equals("050"))//未处置抵债资产
	{
		sSql+=" and AI.AssetFlag ='020' ";
	}else if(sDealType.equals("060"))//已处置抵债资产
	{
		sSql+=" and DisposeFlag='010' ";
	}else
	{
		sSql+=" and 1=2";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("AssetAccountBalance,AssetAccountSum,AssetOccurType,TransferFlag,AssetAna,AssetArea1,AssetArea,AssetStatus,AssetLocation,AssetCustomerName,AssetContractNo,InAccontSum,AssetType,AssetFlag,AssetBalance,RightCardKeeper,RightCardKeepPlace,PracticeKeeper,PracticeKeepPlace,KeepTypeName,ManageUserName,ManageOrgName,ObjectNo,ObjectType,ManageUserID,ManageOrgID",false);
	
	if(sDealType.equals("020010010")){
		//doTemp.setHeader("ManageUserName","管理责任人");
		doTemp.setVisible("AccountDescribe,ManageUserName,AssetAmount,AssetSum,InterestBalance1,InterestBalance2,KeepTypeName,RightCardKeepPlace",false);
		doTemp.setVisible("AssetAccountBalance,AssetAccountSum,AssetOccurType,TransferFlag,AssetAna,AssetArea1,AssetArea,AssetStatus,AssetLocation,AssetCustomerName,AssetContractNo,",true);
	}else if(sDealType.equals("020010020"))
	{	
		//doTemp.setHeader("ManageUserName","管理责任人");
		doTemp.setVisible("AccountDescribe,ManageUserName,AssetAmount,AssetSum,InterestBalance1,InterestBalance2,KeepTypeName,RightCardKeepPlace",false);
		doTemp.setVisible("AssetAccountBalance,AssetAccountSum,AssetOccurType,TransferFlag,AssetAna,AssetArea1,AssetArea,AssetStatus,AssetLocation,AssetCustomerName,AssetContractNo,",true);
	}
	//设置行宽
	doTemp.setHTMLStyle("InputDate"," style={width:65px} ");
	doTemp.setHTMLStyle("OperateOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("OperateUserName"," style={width:60px} ");

	//设置金额为三位一逗数字
	doTemp.setType("AssetAccountBalance,AssetAccountSum,BusinessSum,InterestBalance,InAccontSum,AssetArea1,AssetArea,InterestBalance1,InterestBalance2","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("AssetAccountBalance,AssetAccountSum,BusinessSum,InterestBalance,InAccontSum,AssetArea1,AssetArea,InterestBalance1,InterestBalance2","2");
	doTemp.setCheckFormat("Number","5");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("AssetAccountBalance,AssetAccountSum,BusinessSum,InterestBalance,Number,InAccontSum,AssetArea1,AssetArea,InterestBalance1,InterestBalance2","3");
	
	//生成查询框
	doTemp.setColumnAttribute("SerialNo,BadSerialNo","IsFilter","1");
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
		{"flase","","Button","台账信息维护","台账信息维护","mend_Info()",sResourcesPath},
		{"flase","","Button","台账信息补登","台账信息补登","mend_Info()",sResourcesPath},
		{"flase","","Button","新增台账维护信息","新增台账维护信息","new_Vindicate()",sResourcesPath},
		{"flase","","Button","进行盘点清查","进行盘点清查","new_Liquidate()",sResourcesPath},
		{"flase","","Button","台账维护信息详情","台账维护信息详情","vindicate_List()",sResourcesPath},
		{"flase","","Button","盘点清查信息详情","盘点清查信息详情","liquidate_List()",sResourcesPath},
		{"flase","","Button","以资抵债申请详情","以资抵债申请详情","viewTab()",sResourcesPath},
		{"flase","","Button","审查审批详情","审查审批详情","viewOpinions()",sResourcesPath},
		{"flase","","Button","接收登记","接收登记","incept_Rgister()",sResourcesPath},
		{"flase","","Button","接收详情","接收详情","incept_Rgister()",sResourcesPath},
		{"flase","","Button","台账信息详情","台账信息详情","mend_Info()",sResourcesPath},
		{"flase","","Button","完成维护","完成维护","vindicate_Complete()",sResourcesPath},
		{"flase","","Button","完成盘点清查","完成盘点清查","liquidate_Complete()",sResourcesPath},
		{"flase","","Button","接收完成","接收完成","incept_Complete()",sResourcesPath},
		{"flase","","Button","补登完成","补登完成","mend_Complete()",sResourcesPath},
		{"false","","Button","导出EXCEL","导出EXCEL","export_Excel()",sResourcesPath},
		};

	
		if(sDealType.equals("050"))//抵债资产未接收
		{	
			sButtons[getBtnIdxByName(sButtons,"以资抵债申请详情")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"审查审批详情")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"接收详情")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"盘点清查信息详情")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		}else if(sDealType.equals("060"))//抵债资产已接收
		{	
			sButtons[getBtnIdxByName(sButtons,"以资抵债申请详情")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"审查审批详情")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"接收详情")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
		}
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>


<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=台账信息补登;InputParam=无;OutPutParam=无;]~*/
	function mend_Info()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sAssetType   = getItemValue(0,getRow(),"AssetType");
		sAssetFlag   = getItemValue(0,getRow(),"AssetFlag");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/	PDAAcceptMendInfo.jsp?SerialNo="+sSerialNo+"&AssetType="+sAssetType+"&AssetFlag="+sAssetFlag, "_self","");
		}
	}
	
	/*~[Describe=新增台账维护信息;InputParam=无;OutPutParam=无;]~*/
	function new_Vindicate()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/VindicateReportInfo.jsp?OpenFlag=1&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","_self","");
		}
	}
	
	/*~[Describe=进行盘点清查;InputParam=无;OutPutParam=无;]~*/
	function new_Liquidate()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/LiquidateReportInfo.jsp?OpenFlag=1&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","_self","");
		}
	}
	
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
	
	/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = "BadBizApply";
		sObjectNo = getItemValue(0,getRow(),"BadSerialNo");
		sFlowNo = "BadBizApply";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewBadBizOpinions","/Common/WorkFlow/ViewBadBizOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=台帐维护;InputParam=无;OutPutParam=无;]~*/    
	function vindicate_List()
	{
		//获得以资抵债号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			popComp("VindicateReportList","/RecoveryManage/PDAManage/PDADailyManage/VindicateReportList.jsp","ComponentName=抵债资产日常监控报告列表&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
	}
	
	/*~[Describe=盘点清查;InputParam=无;OutPutParam=无;]~*/    
	function liquidate_List()
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
			popComp("LiquidateReportList","/RecoveryManage/PDAManage/PDADailyManage/LiquidateReportList.jsp","ComponentName=抵债资产日常监控盘点清查报告列表&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
	}
	
	/*~[Describe=接收登记;InputParam=无;OutPutParam=无;]~*/
	function incept_Rgister()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAssetInceptInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DealType=<%=sDealType%>","_self",""); 
		}
	}
	
	
	/*~[Describe=完成维护;InputParam=无;OutPutParam=无;]~*/   
	function vindicate_Complete()
	{
		//获得合同流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//以资抵债编号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			//完成监控
			sReturnValue=RunMethod("BadBizManage","FinishNPAReport",sSerialNo+",010");
			if(sReturnValue=="True")
			{
				alert(getHtmlMessage('71'));//操作成功
				self.location.reload();
			}else if(sReturnValue=="None")
			{
				alert("请进行台帐维护再点击!");
			}else
			{
				alert(getHtmlMessage('72'));//操作失败
			}
		}
	}
	
	/*~[Describe=完成清查;InputParam=无;OutPutParam=无;]~*/   
	function liquidate_Complete()
	{
		//获得合同流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//以资抵债编号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			//完成监控
			sReturnValue=RunMethod("BadBizManage","FinishNPAReport",sSerialNo+",020");
			if(sReturnValue=="True")
			{
				alert(getHtmlMessage('71'));//操作成功
				self.location.reload();
			}else if(sReturnValue=="None")
			{
				alert("请进行盘点清查再点击!");
			}else
			{
				alert(getHtmlMessage('72'));//操作失败
			}
		}
	}
	
	/*~[Describe=接收完成;InputParam=无;OutPutParam=无;]~*/   
	function incept_Complete()
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
			sReturn=RunMethod("PublicMethod","GetColValue","KeepType,ASSET_INFO,String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null") 
			{	
				alert("请进行接收登记后再点击!");
				return;
			}else
			{
				//抵债资产信息):已接收
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ASSETFLAG@040,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
					//查询抵债资产是否全部接收完成
					sReturn=RunMethod("PublicMethod","GetColValue","count(*),ASSET_INFO,String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType+"@String@ASSETFLAG@010");
					sReturnInfo=sReturn.split("@")
					if(sReturnInfo[1] == "0")// 
					{	
						//更新不良资产申请表(抵债资产基本表):接收完成
						sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ManageFlag@030,BADBIZ_APPLY,String@SerialNo@"+sObjectNo);
					
					}
					alert(getHtmlMessage('71'));//操作成功
					self.location.reload();
				}
			}
		}
	}
	
	/*~[Describe=补登完成;InputParam=无;OutPutParam=无;]~*/   
	function mend_Complete()
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
			sReturn=RunMethod("PublicMethod","GetColValue","PayDate,ASSET_INFO,String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null") 
			{	
				alert("请进行台账信息补登后再点击!");
				return;
			}else
			{
				//抵债资产信息):已补登
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ASSETFLAG@020,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
					alert(getHtmlMessage('71'));//操作成功
					self.location.reload();
				}
			}
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
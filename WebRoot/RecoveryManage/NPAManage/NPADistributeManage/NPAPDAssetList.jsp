<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/09/15
*	Tester:
*	Describe: 抵债资产信息列表
*	Input Param:
*	Output Param:  
*		RecoveryUserID  :保全部管理员ID
*   	SerialNo	:合同流水号
*		sShiftType	:移交类型
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
	//定义变量：SQL语句,查询结果集,机构直属、区县标志
	String sSql1 = "";
	ASResultSet rs1 = null;
	String sOrgFlag = "";
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
							{"SerialNo","抵债资产编号"},	
							{"CurrencyName","币种"},
							{"OperateTypeName","抵债资产取得方式"},
							{"BorrowerName","借款人名称"},
							{"Number","抵偿贷款笔数"},
							{"BusinessSum","抵偿贷款本金"},
							{"InAccontSum","抵债资产入账金额"},
							{"InterestBalance","抵偿利息金额"},
							{"InterestBalance1","抵偿贷款表内利息"},
							{"InterestBalance2","抵偿贷款表外利息"},
							{"AssetName","抵债资产名称"},
							{"ManageUserName","指定抵债资产管理人"},
							{"ManageOrgName","指定抵债资产指定机构"},
							{"OperateUserName","原管户人"},	
							{"OperateUserID","原管户人"},	
							{"OperateOrgName","原管户机构"},
							{"InputDate","登记时间"}
						}; 

 	sSql = " select SerialNo,getItemName('Currency',Currency) as CurrencyName," + 	
		   " OperateType,getItemName('PDAGainType',OperateType) as OperateTypeName," + 
		   " BorrowerName,"+
		   " Number,BusinessSum,InterestBalance1,InterestBalance2,InterestBalance,InAccontSum,AssetName," + 
		   " ManageUserID,getUserName(ManageUserID) as ManageUserName," + 
		   " ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,"+
		   " OperateUserID,getUserName(OperateUserID) as OperateUserName," + 
		   " OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,InputDate" + 
		   " from BADBIZ_APPLY "+
		   " where ApplyType='010' ";//责任认定审批通过的合同
	
		   
	//根据树图取不同结果集	   
	if(sDealType.equals("030010"))//抵债资产未分发
	{
		sSql+=" and ManageFlag='010' and (ManageUserID is null or ManageUserID ='')  ";
	}else if(sDealType.equals("030020"))//抵债资产已分发
	{
		sSql+=" and ManageFlag in('020','030') and ManageUserID is not null and ManageUserID !='' ";
	}else if(sDealType.equals("030020010"))//抵债资产已分发已接收
	{
		sSql+=" and ManageFlag='030' and ManageUserID is not null and ManageUserID !='' ";
	}else if(sDealType.equals("030020020"))//抵债资产已分发未接收
	{
		sSql+=" and ManageFlag='020' and ManageUserID is not null and ManageUserID !=''  ";
	}else if(sDealType.equals("050"))//抵债资产管理人变更
	{
		sSql+=" and ManageFlag in ('020','030') and ManageUserID is not null and ManageUserID !=''  ";
	}else
	{
		sSql+=" and 1=2";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("ManageUserID,ManageOrgID,ManageOrgName,ManageUserName,InterestBalance,InputDate,OperateTypeName,OperateType,OperateUserID,OperateOrgID",false);
	doTemp.setKeyFilter("SerialNo");		//add by hxd in 2005/02/20 for 加快速度
	
	if(!sDealType.equals("030010"))//抵债资产未分发
	{
		doTemp.setVisible("ManageOrgName,ManageUserName",true);
	}
	//设置行宽
	doTemp.setHTMLStyle("InputDate"," style={width:65px} ");
	doTemp.setHTMLStyle("OperateOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("OperateUserName"," style={width:60px} ");
	doTemp.setHTMLStyle("BorrowerName"," style={width:300px} ");

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,InterestBalance,InAccontSum,InterestBalance1,InterestBalance2, ","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,InterestBalance,InAccontSum,InterestBalance1,InterestBalance2,","2");
	doTemp.setCheckFormat("Number","5");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,InterestBalance,Number,InAccontSum,InterestBalance1,InterestBalance2,","3");
	
	//重设header
	 if(sDealType.equals("030020010"))//抵债资产已分发已接收
	{
		doTemp.setHeader("ManageUserName","抵债资产管理人");
		doTemp.setHeader("ManageOrgName","抵债资产管理机构");
	}else if(sDealType.equals("030020020"))//抵债资产已分发未接收
	{
		doTemp.setHeader("ManageUserName","抵债资产管理人");
		doTemp.setHeader("ManageOrgName","抵债资产管理机构");
	}else if(sDealType.equals("050"))//抵债资产管理人变更
	{
		doTemp.setHeader("ManageUserName","现抵债资产管理人");
		doTemp.setHeader("ManageOrgName","现抵债资产管理机构");
	}
	
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
		{"true","","Button","审批意见详情","审批意见详情","viewOpinions()",sResourcesPath},
		{"false","","Button","指定管理人","指定抵债资产管户人，转为已分发","my_Distribute()",sResourcesPath},
		{"false","","Button","变更管理人","不良合同保全部管理人更改","change_User()",sResourcesPath},
		{"false","","Button","查看管理人变更记录","不良合同保全部管理人更改记录","my_ChangeUserRec()",sResourcesPath},
		};
	
	if(sDealType.equals("030010"))//抵债资产未分发
	{
		sButtons[getBtnIdxByName(sButtons,"指定管理人")][0]="true";
	}else if(sDealType.equals("050"))
	{
		sButtons[getBtnIdxByName(sButtons,"变更管理人")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"查看管理人变更记录")][0]="true";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>


<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=指定保全部管理人;InputParam=无;OutPutParam=无;]~*/   
	function my_Distribute()
	{
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else
		{
			//弹出对话选择框
			var sRecovery = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
			{
				sRecovery = sRecovery.split("@");
				var sRecoveryUserID = sRecovery[0];
				var sRecoveryUserName = sRecovery[1];
				var sRecoveryOrgID = sRecovery[2];
				var sBadBizProjectFlag = sRecovery[3];
				
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ManageUserID@"+sRecoveryUserID+"@String@ManageOrgID@"+sRecoveryOrgID+"@String@ManageFlag@020,BADBIZ_APPLY,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
						alert("该抵债资产成功分发给『"+sRecoveryUserName+"』管户！");
						self.location.reload();
				}
			}
		}
	}
	
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		//获得申请类型、申请流水号
		sObjectType = "BadBizApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
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
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewBadBizOpinions","/Common/WorkFlow/ViewBadBizOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=更改保全部管理人;InputParam=无;OutPutParam=无;]~*/
	function change_User()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{
			sOldOrgID = getItemValue(0,getRow(),"ManageOrgID");
			sOldUserID = getItemValue(0,getRow(),"ManageUserID");
			sOldOrgName	= getItemValue(0,getRow(),"ManageOrgName");
			sOldUserName = getItemValue(0,getRow(),"ManageUserName");
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserInfo.jsp?OldOrgName="+sOldOrgName+"&OldUserName="+sOldUserName+"&OldOrgID="+sOldOrgID+"&OldUserID="+sOldUserID+"&ObjectType=BadBizAsset&ObjectNo="+sSerialNo,"right",OpenStyle);
		}
	}
	
	 /*~[Describe=查看管理人历次变更记录;InputParam=无;OutPutParam=无;]~*/
	function my_ChangeUserRec()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserList.jsp?ObjectType=BadBizAsset&ObjectNo="+sSerialNo,"right",OpenStyle);			
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
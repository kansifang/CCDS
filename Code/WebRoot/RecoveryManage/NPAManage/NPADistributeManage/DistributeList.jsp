<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: hxli 2005-8-4
*	Tester:
*	Describe:已分发不良资产信息列表
*	Input Param:
*
*	Output Param:     
*		sShiftType：移交类型
*		sOldOrgID：原管理机构ID
*		sOldUserID：原管理人ID
*		sOldOrgName：原管理机构
*		sOldUserName：原管理人
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "已分发不良资产信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sCurItemID ;    
	String sWhereClause=""; //Where条件
	String sSql="";

	//获得组件参数
	sCurItemID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemMenuNo"));
	if(sCurItemID == null) sCurItemID = "";
	System.out.println(sCurItemID);
 	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义表头文件
	//客户移交表头
	String sHeaders[][] = {
						{"RecoveryUserName","管户人"},
						{"RecoveryOrgName","管户人所属机构"},						
						{"SerialNo","合同流水号"},						
						{"BusinessTypeName","业务品种"},
						{"OccurTypeName","发生类型"},
						{"CustomerName","客户名称"},
						{"BusinessCurrencyName","币种"},
						{"BusinessSum","金额"},
						{"ShiftBalance","移交余额"},
						{"Balance","当前余额"},
						{"Maturity","到期日期"},
						{"ClassifyResult","五级分类"},
						{"ShiftTypeName","移交类型"},
						{"ManageUserName","原管户人"},
						{"ManageOrgName","原管户机构"}
					}; 
	
	//审批移交表头
	String sHeaders1[][] = {						
						{"RecoveryUserName","第一跟踪人"},
						{"RecoveryOrgName","第一跟踪人机构"},
						{"SerialNo","合同流水号"},					
						{"BusinessTypeName","业务品种"},
						{"OccurTypeName","发生类型"},
						{"CustomerName","客户名称"},
						{"BusinessCurrencyName","币种"},
						{"BusinessSum","金额"},
						{"ShiftBalance","移交余额"},
						{"Balance","当前余额"},
						{"Maturity","到期日期"},
						{"ClassifyResultName","五级分类"},
						{"ShiftTypeName","移交类型"},						
						{"ManageUserName","原管户人"},
						{"ManageOrgName","原管户机构"}
					}; 

	//从合同表中选出不良资产管户机构为登录用户所在机构及下级机构的不良资产
 	if(sCurItemID.equals("010"))	//客户移交
	{	
		sSql =	 " select BC.SerialNo,getUserName(BC.RecoveryUserID) as RecoveryUserName," + 	
				 " getOrgName(BC.RecoveryOrgID) as RecoveryOrgName," +					
				 " BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName," + 
				 " getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
				 " BC.CustomerName,getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
				 " BC.BusinessSum,BC.ShiftBalance,BC.Balance,BC.Maturity,BC.ClassifyResult,BC.ShiftType," +  
				 " getItemName('ShiftType',BC.ShiftType) as ShiftTypeName," + 
				 " getUserName(BC.ManageUserID) as ManageUserName," + 
				 " getOrgName(BC.ManageOrgID) as ManageOrgName," + 
				 " BC.RecoveryUserID,BC.RecoveryOrgID,BC.ManageUserID,BC.ManageOrgID " + 
				 " from BUSINESS_CONTRACT BC " +
				 " Where exists (select OI.OrgID from ORG_INFO OI "+
				 " where OI.OrgID = BC.RecoveryOrgID "+
				 " and OI.SortNo like '"+CurOrg.SortNo+"%') "+
				 " and BC.ShiftType='02' and BC.RecoveryUserID ='"+CurUser.UserID+"' order by BC.SerialNo desc ";		
	}else if(sCurItemID.equals("020"))	//审批移交
	{
		sSql =	 	 " select BC.SerialNo, "+					 
					 " getUserName(BC.RecoveryUserID) as RecoveryUserName," + 
					 " getOrgName(BC.RecoveryOrgID) as RecoveryOrgName," + 
					 " BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName," + 
					 " getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
					 " BC.CustomerName," + 
					 " getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
					 " BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName," +   
					 " BC.ShiftType,getItemName('ShiftType',BC.ShiftType) as ShiftTypeName," + 
					 " getUserName(BC.ManageUserID) as ManageUserName," + 
					 " getOrgName(BC.ManageOrgID) as ManageOrgName" + 
					 " from BUSINESS_CONTRACT BC " +
					 " Where exists (select OI.OrgID from ORG_INFO OI "+
					 " where OI.OrgID = BC.RecoveryOrgID "+
					 " and OI.SortNo like '"+CurOrg.SortNo+"%') "+
					 " and BC.ShiftType='01' order by BC.SerialNo desc ";
	}
	
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	if(sCurItemID.equals("010"))	//客户移交
		doTemp.setHeader(sHeaders);
	
	if(sCurItemID.equals("020"))	//审批移交
		doTemp.setHeader(sHeaders1);

	//doTemp.setKey("RecoveryUserID",true);	 //设置关键字
	//设置共用格式
	doTemp.setVisible("SerialNo,FinishType,BusinessType,ShiftType,FinishDate,ManageUserID,ManageOrgID",false);
	doTemp.setVisible("RecoveryOrgID,RecoveryUserID,ClassifyResult",false);
    	
	//设置选项双击及行宽	
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName"," style={width:65px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName,TraceUserName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("Balance,ShiftBalance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResult"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum","Number");
	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum","2");
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,Balance,ActualPutOutSum","3");
	
	//生成查询框
	doTemp.setColumnAttribute("RecoveryUserName,CustomerName","IsFilter","1");
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
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		{"true","","Button","变更管理人","不良合同保全部管理人更改","my_ChangeUser()",sResourcesPath},
		{"false","","Button","变更移交类型","合同管理性质转换","my_ShiftManage()",sResourcesPath},
		{"true","","Button","查看管理人变更记录","不良合同保全部管理人更改记录","my_ChangeUserRec()",sResourcesPath},
		{"false","","Button","查看移交类型变更记录","查看移交类型变更记录","my_ChangeType()",sResourcesPath}
		};
	
	if(sCurItemID.equals("020"))	//审批移交
	{
		sButtons[1][0]="false";
		sButtons[3][0]="false";
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script language=javascript>

	//---------------------定义按钮事件------------------------------------
   	
   	/*~[Describe=更改保全部管理人;InputParam=无;OutPutParam=无;]~*/
	function my_ChangeUser()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{
			sOldOrgID = getItemValue(0,getRow(),"RecoveryOrgID");
			sOldUserID = getItemValue(0,getRow(),"RecoveryUserID");
			sOldOrgName	= getItemValue(0,getRow(),"RecoveryOrgName");
			sOldUserName = getItemValue(0,getRow(),"RecoveryUserName");
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserInfo.jsp?OldOrgName="+sOldOrgName+"&OldUserName="+sOldUserName+"&OldOrgID="+sOldOrgID+"&OldUserID="+sOldUserID+"&ObjectType=BusinessContract&ObjectNo="+sSerialNo,"right",OpenStyle);
		}
	}

	/*~[Describe=变更移交类型;InputParam=无;OutPutParam=无;]~*/
	function my_ShiftManage()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			//弹出对话选择框
			sOldShiftType = getItemValue(0,getRow(),"ShiftType");
			sShiftType = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/ManageShiftChoice.jsp","","dialogWidth=19;dialogHeight=07;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sShiftType)!="undefined" && sShiftType.length!=0)
			{
				if(sShiftType == sOldShiftType)
				{
					alert(getBusinessMessage("761"));	//您未改变移交管理类型，操作取消！
					return;
				}else if(confirm(getBusinessMessage("762")))   //是否真的替换移交管理类型?
				{
					sReturn = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/ManageShiftAction.jsp?ShiftType="+sShiftType+"&SerialNo="+sSerialNo+"&OldShiftType="+sOldShiftType+"","","");
					if(sReturn == "true")//刷新页面
					{
						alert(getBusinessMessage("763"));//移交类型变更成功！
						reloadSelf();
					}
				}
			}
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
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserList.jsp?ObjectNo="+sSerialNo,"right",OpenStyle);			
		}
	}

	/*~[Describe=查看移交类型历次变更记录;InputParam=无;OutPutParam=无;]~*/
	function my_ChangeType()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserList.jsp?ObjectNo="+sSerialNo+"&Flag=ShiftType","right",OpenStyle);			
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
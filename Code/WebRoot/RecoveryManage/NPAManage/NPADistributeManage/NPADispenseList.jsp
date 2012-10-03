<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/09/02
*	Tester:
*	Describe: 不良资产信息列表
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
	String PG_TITLE = "不良资产信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	//取机构直属、区县标志
	sSql1 = " select NVL(OrgFlag,'') "+
			" from ORG_INFO "+
			" where OrgID = '"+CurOrg.OrgID+"' ";
	sOrgFlag = Sqlca.getString(sSql1);	
	//定义标题
	String sHeaders[][] = {
							{"SerialNo","合同流水号"},				
							{"BusinessTypeName","业务品种"},
							{"OccurTypeName","发生类型"},
							{"CustomerName","客户名称"},
							{"BusinessCurrencyName","币种"},
							{"BusinessSum","合同金额"},
							{"ShiftBalance","移交余额"},
							{"Balance","当前余额"},
							{"CAVSum","核销金额"},
							{"Maturity","到期日期"},							
							{"ClassifyResultName","风险分类"},
							{"BadBizProjectFlagName","分发类型"},
							{"ShiftTypeName","移交类型"},
							{"RecoveryUserName","不良资产管理人"},
							{"RecoveryOrgName","不良资产管理机构"},
							{"ManageUserName","原管户人"},
							{"ManageOrgName","原管户机构"},
							{"RecoveryDate","操作日期"},
						}; 

 	sSql = " select SerialNo," + 	
		   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
		   " getItemName('OccurType',OccurType) as OccurTypeName," + 
		   " CustomerName,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
		   " BusinessSum,ShiftBalance,Balance, Cancelsum+CancelInterest as CAVSum,"+
		   " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName," + 
		   " BadBizProjectFlag,getItemName('BadBizProjectFlag',BadBizProjectFlag) as BadBizProjectFlagName," + 
		   " ShiftType,getItemName('ShiftType',ShiftType) as ShiftTypeName," + 
		   " RecoveryUserID,getUserName(RecoveryUserID) as RecoveryUserName,"+
		   " RecoveryOrgID,getOrgName(RecoveryOrgID) as RecoveryOrgName,"+
		   " getUserName(ManageUserID) as ManageUserName," + 
		   " getOrgName(ManageOrgID) as ManageOrgName,Maturity,RecoveryDate " + 
		   " from BUSINESS_CONTRACT "+
		   " where BadAssetLcFlag='020' ";//责任认定审批通过的合同
	//根据机构直属、区县标志取不同的结果集
	if(sOrgFlag.equals("020"))//区县联社/合行
	{
		sSql+=" and GETORGFLAG(ManageOrgID) = '020' ";
	}else if(sOrgFlag.equals("030"))//城区直属支行
	{
		sSql+=" and GETORGFLAG(ManageOrgID) = '030' ";
	}
		   
	//根据树图取不同结果集	   
	if(sDealType.equals("010010"))//不良资产转入未分发
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (RecoveryUserID is null or RecoveryUserID ='') ";
	}else if(sDealType.equals("010020"))//不良资产转入已分发
	{
		sSql+=" and RecoveryUserID is not null and RecoveryUserID <>'' ";// and ManageFlag = '010'";
	}else if(sDealType.equals("020010"))//不良资产转出未分发
	{
		sSql+=" and substr(ClassifyResult,1,2)='01' and RecoveryUserID is not null and RecoveryUserID <>'' ";
	}else if(sDealType.equals("020020"))//不良资产转出已分发
	{
		sSql+=" and (RecoveryUserID is null or RecoveryUserID ='') and  ManageFlag = '090' ";
	}else if(sDealType.equals("040"))//不良资产管理人变更
	{
		sSql+=" and RecoveryUserID is not null and RecoveryUserID <>'' ";
	}else
	{
		sSql+=" and 1=2";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("BadBizProjectFlag,BadBizProjectFlagName,RecoveryUserID,RecoveryOrgID,CAVSum,RecoveryUserName,RecoveryOrgName,ShiftBalance,ShiftType,BusinessType,FinishType,FinishDate,ClassifyResult,ShiftType,ShiftTypeName",false);
	doTemp.setKeyFilter("SerialNo");		//add by hxd in 2005/02/20 for 加快速度
    if(!sDealType.equals("010010"))
    {
    	doTemp.setVisible("RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName",true);
    }
	//设置行宽
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName,BadBizProjectFlagName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:250px} ");
	doTemp.setHTMLStyle("ManageUserName,RecoveryUserName"," style={width:100px} ");

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum,CAVSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,CAVSum,Balance,ActualPutOutSum","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,BusinessCurrencyName","2");
	//重设header
	 if(sDealType.equals("020020"))//不良资产转出已分发
	{
		 doTemp.setHeader("ClassifyResultName","转出后风险分类");
		 doTemp.setHeader("ManageUserName","转出后管户人");
		 doTemp.setHeader("ManageOrgName","转出后管户机构");

	}else if(sDealType.equals("040"))//不良资产管理人变更
	{
		doTemp.setHeader("RecoveryUserName","现不良资产管理人");
		doTemp.setHeader("RecoveryOrgName","现不良资产管理机构");
	}

	//生成查询框
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName","IsFilter","1");
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
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		{"false","","Button","责任认定详情","责任认定","dutyCogn_Info()",sResourcesPath},
		{"false","","Button","风险认定详情","风险认定","classify_Info()",sResourcesPath},
		{"false","","Button","变更管理人","不良合同保全部管理人更改","change_User()",sResourcesPath},
		{"false","","Button","查看管理人变更记录","不良合同保全部管理人更改记录","my_ChangeUserRec()",sResourcesPath},
		{"false","","Button","指定管理人","指定合同管户人或者跟踪人，转为已分发","my_Distribute()",sResourcesPath},
		{"false","","Button","转出","将合同退回给原管户人","my_ReverseHandover()",sResourcesPath},
		{"false","","TestFiled","提示信息","提示信息","<font style='color:red;'>余额500万以上市行，100-500万元区县，100万元以下基层</font>",sResourcesPath}
		};
	
	if(sDealType.equals("010010"))//不良资产转入未分发
	{
		sButtons[getBtnIdxByName(sButtons,"责任认定详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"风险认定详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"指定管理人")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"提示信息")][0]="true";
	}else if(sDealType.equals("010020"))//不良资产转入已分发
	{
		sButtons[getBtnIdxByName(sButtons,"责任认定详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"风险认定详情")][0]="true";
	}else if(sDealType.equals("020010"))//不良资产转出未分发
	{	
		sButtons[getBtnIdxByName(sButtons,"转出")][0]="true";
	}else if(sDealType.equals("040"))//不良资产管理人变更
	{	
		sButtons[getBtnIdxByName(sButtons,"责任认定详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"风险认定详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"变更管理人")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"查看管理人变更记录")][0]="true";
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
	/*~[Describe=指定保全部管理人;InputParam=无;OutPutParam=无;]~*/   
	function my_Distribute()
	{
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			retrun;
		}
		else
		{
			//弹出对话选择框
			var sRecovery = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserChoice.jsp?ShowFlag=010","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
			{
				sRecovery = sRecovery.split("@");
				var sRecoveryUserID = sRecovery[0];
				var sRecoveryUserName = sRecovery[1];
				var sRecoveryOrgID = sRecovery[2];
				var sBadBizProjectFlag = sRecovery[3];
				
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoveryUserID@"+sRecoveryUserID+"@String@RecoveryOrgID@"+sRecoveryOrgID+"@String@BadBizProjectFlag@"+sBadBizProjectFlag+"@String@ManageFlag@010@String@RecoveryDate@<%=StringFunction.getToday()%>,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
						alert("该不良资产成功分发给『"+sRecoveryUserName+"』管户！");
						self.location.reload();
				}
			}
		}
	}
	
	/*~[Describe=责任认定详情;InputParam=无;OutPutParam=无;]~*/
	function dutyCogn_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			sCompID = "NPAssetDutyList";
			sCompURL = "/CreditManage/CreditPutOut/NPADutyList.jsp";
			sParamString = "EditRight=2&ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=风险分类详情;InputParam=无;OutPutParam=无;]~*/
	function classify_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			sCompID = "ClassifyHistoryList";
			sCompURL = "/CreditManage/CreditPutOut/ClassifyHistoryList.jsp";
			sParamString = "ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=转出;InputParam=无;OutPutParam=无;]~*/	
	function my_ReverseHandover()
	{ 
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else
		{	
			if(confirm(getBusinessMessage('785')))//您真的想将此不良资产退回给原管户人吗？
    		{	
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoveryUserID@None@String@RecoveryOrgID@None@String@ManageFlag@090,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")//刷新页面
				{
					alert(getBusinessMessage('784')); //该不良资产已成功退回给原管户人！
					self.location.reload();
				}
			}
		}
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
			sOldOrgID = getItemValue(0,getRow(),"RecoveryOrgID");
			sOldUserID = getItemValue(0,getRow(),"RecoveryUserID");
			sOldOrgName	= getItemValue(0,getRow(),"RecoveryOrgName");
			sOldUserName = getItemValue(0,getRow(),"RecoveryUserName");
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserInfo.jsp?OldOrgName="+sOldOrgName+"&OldUserName="+sOldUserName+"&OldOrgID="+sOldOrgID+"&OldUserID="+sOldUserID+"&ObjectType=BusinessContract&ObjectNo="+sSerialNo,"right",OpenStyle);
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
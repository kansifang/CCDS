<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/10/10
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
							{"SerialNo","资产编号"},
							{"AssetTypeName","资产类别"},
							{"AssetName","资产名称"},
							{"PayDate","取得时间"},
							{"PayTypeName","取得方式"},
							{"AssetStatusName","抵债资产现状"},
							{"CurrencyName","抵债币种"},
							{"AssetSum","抵债金额"},
							{"InAccontDate","入账日期"},
							{"DisposeDate","处置日期"},
							{"SaleSum","出售金额"},
							{"LeaseSum","出租金额"},
							{"OtherTypeSum","其他处置金额"},
							{"DisposeLossSum","处置损失金额"},
							{"AccountSum","账面金额"},
							{"ManageUserName","管理人"},
							{"ManageOrgName","管理机构"},
							{"AccountFlag","完成状态"}
						}; 

 	sSql = "select A.SerialNo as SerialNo,A.ObjectNo as ObjectNo,A.ObjectType as ObjectType,"+
 	 		" A.AssetTypeName as AssetTypeName,A.AssetName as AssetName," +
 	 		" A.PayDate as PayDate,A.PayTypeName as PayTypeName,"+
 	 		" A.AssetStatusName as AssetStatusName,A.AssetSum as AssetSum,"+
 	 		" A.CurrencyName as CurrencyName,"+
 			" A.InAccontDate as InAccontDate, "+
 			" B.DisposeDate as DisposeDate,Nvl(B.SaleSum,0) as SaleSum,"+
 			" Nvl(B.LeaseSum,0) as LeaseSum,Nvl(B.OtherTypeSum,0) as OtherTypeSum,"+
 			" Nvl(B.DisposeLossSum,0) as DisposeLossSum,"+
 			" A.AccountSum as AccountSum,"+
 			" A.ManageUserID as ManageUserID,A.ManageUserName as ManageUserName," + 
 			" A.ManageOrgID as ManageOrgID,A.ManageOrgName as ManageOrgName,A.AccountFlag as AccountFlag " + 
 			" from ("+
	 			" select AI.SerialNo as SerialNo, AI.ObjectNo as ObjectNo,AI.ObjectType as ObjectType ," + 	
			   	" getItemName('PDAAssetType',AI.AssetType) as AssetTypeName,AI.AssetName as AssetName," + 
			  	" AI.PayDate as PayDate,getItemName('PDAGainType',AI.PayType) as PayTypeName,"+
			  	" getItemName('AssetActualStatus',AI.AssetStatus) as AssetStatusName,"+
			    " AI.AssetSum as AssetSum,"+
			    " getItemName('Currency',BA.Currency) as CurrencyName,"+
			    " AI.InAccontDate as InAccontDate, "+
			    " AI.AccountSum as AccountSum,"+
			    " BA.ManageUserID as ManageUserID,getUserName(BA.ManageUserID) as ManageUserName," + 
			    " BA.ManageOrgID as ManageOrgID,getOrgName(BA.ManageOrgID) as ManageOrgName,nvl(AI.AccountFlag,'000') as AccountFlag " + 
		   		" from ASSET_INFO AI,BADBIZ_APPLY BA "+
		  		" where AI.ObjectNo=BA.SerialNo  and AI.ObjectType='BadBizApply' and BA.ApplyType='010' "+
		  		" and BA.ManageUserID='"+CurUser.UserID+"' "+
		   		" and BA.ManageOrgID='"+CurOrg.OrgID+"'";
	
	//根据树图取不同结果集	   
	if(sDealType.equals("020010"))//已抵入待处置资产
	{
		sSql+=" and AI.AssetFlag in('040','020') order by AccountFlag";
	}else if(sDealType.equals("020030"))//已处置资产
	{
		sSql+=" and AI.AssetFlag in('040','020') and AI.AccountFlag is not null and  AI.AccountFlag!='' order by AccountFlag" ;
	}else
	{
		sSql+=" and 1=2";
	}
	//左链接
	sSql+=") A LEFT OUTER JOIN ASSET_DISPOSE B "+
		 " ON  A.serialno=B.ObjectNo ORDER BY A.AccountFlag ";
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);

	//设置共用格式
	doTemp.setVisible("DisposeLossSum,OtherTypeSum,LeaseSum,SaleSum,DisposeDate,AccountFlag,InAccontDate,AssetSum,CurrencyNameAssetStatusName,ObjectNo,PayDate,PayTypeName,ObjectType,ManageUserID,ManageOrgID",false);
	
	if(sDealType.equals("020010"))//已抵入待处置资产
	{
		doTemp.setVisible("InAccontDate,AssetSum,CurrencyNameAssetStatusName,PayDate,PayTypeName",true);
	}else if(sDealType.equals("020030"))//已处置资产
	{
		doTemp.setVisible("DisposeLossSum,OtherTypeSum,LeaseSum,SaleSum,DisposeDate",true);
	}
	//设置行宽
	doTemp.setHTMLStyle("InputDate"," style={width:65px} ");
	doTemp.setHTMLStyle("OperateOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("OperateUserName"," style={width:60px} ");

	//设置金额为三位一逗数字
	doTemp.setType("SaleSum,LeaseSum,OtherTypeSum,DisposeLossSum,AssetSum,BusinessSum,InterestBalance ","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("SaleSum,LeaseSum,OtherTypeSum,DisposeLossSum,AssetSum,BusinessSum,InterestBalance","2");
	doTemp.setCheckFormat("Number","5");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("SaleSum,LeaseSum,OtherTypeSum,DisposeLossSum,AssetSum,BusinessSum,InterestBalance,Number","3");
	
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
		{"false","","Button","新增","新增","new_Record()",sResourcesPath},
		{"true","","Button","抵债详情","抵债详情","viewTab()",sResourcesPath},
		{"false","","Button","抵入账面登记","抵入账面登记","account_Register()",sResourcesPath},
		{"false","","Button","处置登记","处置登记","dispose_Register()",sResourcesPath},
		{"false","","Button","登记完成","登记完成","deal_With()",sResourcesPath},
		{"false","","Button","处置完毕","处置完毕","do_Done()",sResourcesPath},
		};
	if(sDealType.equals("020010"))//已抵入待处置资产
	{
		sButtons[getBtnIdxByName(sButtons,"新增")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"抵入账面登记")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"登记完成")][0]="true";
	}else if(sDealType.equals("020030"))//已处置资产
	{
		sButtons[getBtnIdxByName(sButtons,"处置登记")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"处置完毕")][0]="true";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>


<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function new_Record()
	{
		//使用GetSerialNo.jsp来抢占一个流水号
		var sTableName = "BADBIZ_APPLY";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
								
		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		PopPage("/RecoveryManage/AccountManage/AddBadBizAssetAction.jsp?SerialNo="+sSerialNo,"","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			
        //根据新增申请的流水号，打开申请详情界面
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=BadBizApply&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();		
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
		//reloadSelf();
	}
	
	/*~[Describe=登记完成;InputParam=无;OutPutParam=无;]~*/   
	function deal_With()
	{
		//获得合同流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//资产编号
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//抵债资产申请编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");//对象类型
		var sAccountFlag = getItemValue(0,getRow(),"AccountFlag");//处置状态
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			if(typeof(sAccountFlag) != "undefined" || sAccountFlag.length != 0)//登记完成
			{
				alert("已进行登记,不需重复点击!");
				return;
			}
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
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@AccountFlag@010,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
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
		var sAccountFlag = getItemValue(0,getRow(),"AccountFlag");//处置状态
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			if(sAccountFlag == "020")//登记完成
			{
				alert("已进行处置,不需重复点击!");
				return;
			}
			//验证补登信息是否填写
			sReturn=RunMethod("PublicMethod","GetColValue","Count(SerialNo),ASSET_DISPOSE,String@ObjectNo@"+sSerialNo);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null" || sReturnInfo[1] == 0) 
			{	
				alert("请进行处置登记后再点击!");
				return;
			}else
			{
				//抵债资产信息):处置完毕
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@AccountFlag@020,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
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
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sAccountFlag = getItemValue(0,getRow(),"AccountFlag");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sEditRight = "01";
		//如果进行了抵入账面登记则不可编辑
		if(sAccountFlag > "000")
		{
			sEditRight="02";
		}
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/RecoveryManage/AccountManage/APDAssetAccountInfo.jsp?EditRight="+sEditRight+"&SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_self",""); 
		}
	}
	
	/*~[Describe=处置登记;InputParam=无;OutPutParam=无;]~*/    
	function dispose_Register()
	{
		//获得还款流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sAccountFlag = getItemValue(0,getRow(),"AccountFlag");//处置状态
		var sEditRight = "01";
		//如果进行了抵入账面登记则不可编辑
		if(sAccountFlag == "020")
		{
			sEditRight="02";
		}
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			popComp("DisposeRegisterList","/RecoveryManage/AccountManage/DisposeRegisterList.jsp","ComponentName=资产处置登记列表&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>&EditRight="+sEditRight,"","");
		}
		reloadSelf();
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
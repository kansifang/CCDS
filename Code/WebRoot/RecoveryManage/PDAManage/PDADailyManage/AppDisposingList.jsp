<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-3
		Tester:
		Content: 已抵入/处置中的资产列表AppDisposingList.jsp
		Input Param:
				ObjectType：对象类型（AssetInfo）	
				InOut：表内外标志	          
		Output param:
				SerialNo：抵债资产编号
		History Log: zywei 2005/09/07 重检代码	                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "处置中的资产列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sInOut = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InOut"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sInOut == null) sInOut = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","资产编号"},							
							{"AssetName","资产名称"},
							{"Flag","表内/外"},
							{"FlagName","表内/外"},
							{"AssetType","资产类别"},	
							{"AssetTypeName","资产类别"},	
							{"PayType","抵债方式"},
							{"PayTypeName","抵债方式"},
							{"Currency","抵债币种"},
							{"CurrencyName","抵债币种"},
							{"AssetSum","抵债金额"},
							{"InAccontDate","入账日期"},
							{"EnterValue","入账价值(元)"},
							{"AssetBalance","科目余额(元)"},
							{"OutInitBalance","抵债时贷款余额(元)"},
							{"OutNowBalance","当前贷款余额(元)"},
							{"ManageUserID","管理人"},
							{"ManageOrgID","管理机构"}
						}; 
						
	//从抵债资产信息表ASSET_INFO中选出已抵入/处置中的资产
	sSql =  " select SerialNo,ObjectNo,"+
			" AssetName,"+
			" AssetType,getItemName('PDAType',AssetType) as AssetTypeName,"+
			" PayType, getItemName('PayType',PayType) as PayTypeName," +	
			" Flag ,"+
			" getItemName('Flag',Flag) as FlagName,"+
			" Currency, getItemName('Currency',Currency) as CurrencyName," +	
			" AssetSum, " +	
			" InAccontDate, "+
			" EnterValue, " +	
			" AssetBalance, " +	
			" OutInitBalance, " +	
			" OutNowBalance, " +	
			" getUserName(ManageUserID) as ManageUserID, " +	
			" getOrgName(ManageOrgID) as ManageOrgID"+			
			" from ASSET_INFO" +
			" where ManageUserID = '"+CurUser.UserID+"' "+
			" and AssetStatus = '03' "+
			" and AssetAttribute = '01' "+
			" and PigeonholeDate is null "+
			" and ObjectType = '"+sObjectType+"' ";
			//管户人为当前用户
			//抵债资产处置现状：03－已抵入
			//AssetAttribute：01－抵债资产、02－查封资产
			//归档日期为空

	if (sInOut.equals("In"))   //获取表内资产
		sSql = sSql + " and Flag='010'  order by AssetName desc ";
	else					   //获取表外资产
		sSql = sSql + " and Flag='020'  order by AssetName desc ";
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";	
	//设置关键字
	doTemp.setKey("SerialNo",true);	 
	//设置不可见项
	doTemp.setVisible("AssetType,Flag,FlagName,PayType,PayTypeName,Currency,ObjectNo",false);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("FlagName","style={width:50px} ");  
	doTemp.setHTMLStyle("AssetTypeName","style={width:80px} ");  
	doTemp.setHTMLStyle("CurrencyName,InAccontDate","style={width:70px} ");  
	doTemp.setHTMLStyle("AssetName,ManageUserID,ManageOrgID"," style={width:80px} ");
	doTemp.setHTMLStyle("AssetSum,EnterValue,AssetBalance,OutInitBalance,OutNowBalance"," style={width:80px} ");
	doTemp.setHTMLStyle("OutInitBalance,OutNowBalance"," style={width:110px} ");
	doTemp.setUpdateable("AssetTypeName,PayTypeName,CurrencyName",false); 
	//设置对齐方式
	doTemp.setAlign("AssetSum,EnterValue,AssetBalance,OutInitBalance,OutNowBalance","3");
	doTemp.setType("AssetSum,EnterValue,AssetBalance,OutInitBalance,OutNowBalance","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("AssetSum,EnterValue,AssetBalance,OutInitBalance,OutNowBalance","2");
	//生成查询框
	doTemp.setColumnAttribute("AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页

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
			{"true","","Button","处置终结","处置终结","PDADisposed()",sResourcesPath},	
			{"true","","Button","转表内","转表内","my_Intable()",sResourcesPath},
			{"true","","Button","转表外","转表外","my_Outtable()",sResourcesPath},
		};

	if (sInOut.equals("In"))  //表内资产只能转表外
		sButtons[2][0]="false";
	else							  //表外资产只能转表内
		sButtons[3][0]="false";
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=转表内信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_Intable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{			
			myFlag = getItemValue(0,getRow(),"Flag");
			if (myFlag == "020")
			{
				//弹出信息窗口,提示用户输入新的入账价值与待处理抵债资产科目余额
				var myReturn=popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"&InOut=In","dialogWidth:600px;dialogheight:440px","");
				if (myReturn == "true") reloadSelf();
			}else
			{
				alert("该资产已经转入表内!");
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=转表外信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_Outtable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			myFlag = getItemValue(0,getRow(),"Flag");
			if (myFlag == "010")
			{
				//弹出信息窗口,提示用户输入新的抵债时贷款余额与当前贷款余额
				var myReturn=popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"~InOut=Out","dialogWidth:600px;dialogheight:440px","");
				if (myReturn == "true")	 reloadSelf();
			}else
			{
				alert("该资产已经转入表外!");
			}
			reloadSelf();
		}
	}
	
	
	//处置终结：自动设置AssetStatus状态和终结日期。
	function PDADisposed()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		//type=1 意味着从AppDisposingList中执行处置终结并且汇总。
		//type=2 意味着从PDADisposalEndList中察看汇总。
		//type=3 意味着从PDADisposalBookList中察看汇总。
        sReturn = popComp("PDADisposalEndInfo","/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndInfo.jsp","SerialNo="+sSerialNo+"~Type=1","dialogWidth:720px;dialogheight:580px","");
		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得抵债资产流水号、抵债资产类型
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");			
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo,"");
		reloadSelf();
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>	
	
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
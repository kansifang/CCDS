<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*   
		Author:   hxli 2005-8-3
		Tester:
		Content: 待处置的资产列表
		Input Param:
				ObjectType	对象类型(AssetInfo)		          
		Output param:
				SerialNo   : 抵债资产编号
				AssetType: 抵债资产类型 
		History Log: zywei 2005/09/07 重检代码		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "已批准拟抵入的资产列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","资产编号"},							
							{"AssetName","资产名称"},
							{"AssetType","资产类别"},	
							{"AssetTypeName","资产类别"},	
							{"PayType","抵债方式"},
							{"PayTypeName","抵债方式"},
							{"AssetSum","抵债金额"},
							{"Currency","抵债币种"},
							{"CurrencyName","抵债币种"},
							{"ManageUserID","管理人"},
							{"ManageOrgID","管理机构"}
						}; 
						
	//从抵债资产信息表ASSET_INFO中选出未处置且未归档的抵债资产
	sSql =  " select SerialNo,ObjectNo,"+
			" AssetName,"+
			" AssetType,getItemName('PDAType',AssetType) as AssetTypeName,"+
			" PayType, getItemName('PayType',PayType) as PayTypeName," +	
			" Currency, getItemName('Currency',Currency) as CurrencyName," +
			" AssetSum, " +	
			" getUserName(ManageUserID) as ManageUserID, " +	
			" getOrgName(ManageOrgID) as ManageOrgID"+			
			" from ASSET_INFO" +
			" where ManageUserID = '"+CurUser.UserID+
			"' and AssetStatus = '02'  "+
			" and AssetAttribute = '01' "+
			" and PigeonholeDate is null "+
			" and ObjectType = '"+sObjectType+"' "+
			" order by AssetName desc";
			//管户人为当前用户
			//抵债资产处置现状：02－待处置
			//资产类别：01－抵债资产、02－查封资产
			//归档日期为空
		
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";
	
	//设置关键字
	doTemp.setKey("SerialNo",true);	 

	//设置不可见项
	doTemp.setVisible("AssetType,Currency,PayType,ObjectNo",false);

	doTemp.setHTMLStyle("AssetTypeName,CurrencyName,PayTypeName","style={width:60px} ");  
	doTemp.setHTMLStyle("AssetName,AssetSum,ManageOrgID"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserID"," style={width:80px} ");
	doTemp.setUpdateable("AssetTypeName,CurrencyName,PayTypeName",false); 
	
	//设置对齐方式
	doTemp.setAlign("AssetSum,AssetBalance","3");
	doTemp.setType("AssetSum,AssetBalance","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("AssetSum","2");
	
	//生成查询框
	doTemp.setColumnAttribute("AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页
	
	//删除抵债资产后删除关联信息
    dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(AssetInfo,#SerialNo,DeleteBusiness)");

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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","抵入转表内","抵入转表内","my_Intable()",sResourcesPath},
			{"true","","Button","抵入转表外","抵入转表外","my_Outtable()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		var sAssetInfo =PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDATypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=10;center:yes;status:no;statusbar:no");
		sAssetInfo = sAssetInfo.split("@");
		var sSerialNo=sAssetInfo[1];
		if(typeof(sSerialNo) != "undefined" && sSerialNo.length != 0)
		{			
			popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo,"");
			reloadSelf();
		} 		
	}
			
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");			
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

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
		
		popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo,"");
		reloadSelf();
	}	
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	/*~[Describe=抵入转表内信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_Intable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{			
			//弹出信息窗口,提示用户输入新的入账价值与待处理抵债资产科目余额
			popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"~InOut=In","dialogWidth:600px;dialogheight:440px","");
			reloadSelf();
		}
	}

	/*~[Describe=抵入转表外信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_Outtable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{			
			//弹出信息窗口,提示用户输入新的抵债时贷款余额与当前贷款余额
			popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"~InOut=Out","dialogWidth:600px;dialogheight:440px","");
			reloadSelf();
		}
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

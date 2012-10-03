<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   hxli 2005.8.11
		Content: 抵债资产基本信息PDABasicInfo.jsp
					  资产流水号在选择资产类型对话框中已经产生，所以这里不存在新增的问题。
		Input Param:
				SerialNo:抵债资产流水号
				AssetType：抵债资产类型				
				ObjectType：对象类型						
		Output param:		
		History Log: 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo ="";
			
	//获得组件参数(抵债资产流水号、抵债资产类型、对象类型)
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sAssetType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetType"));//资产类型，否则无法定位模板
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//out.println(sSerialNo);
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sAssetType == null) sAssetType = "";	
	if(sObjectType == null) sObjectType = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	if (sAssetType.equals("01"))
		sTempletNo="PDAHouseInfo"; //房产类
	if (sAssetType.equals("02"))
		sTempletNo="PDASoilInfo"; //土地类
	if (sAssetType.equals("03"))
		sTempletNo="PDAVehicleInfo"; //交通运输工具类
	if (sAssetType.equals("04"))
		sTempletNo="PDAMachineryInfo"; //机器设备类
	if (sAssetType.equals("05"))
		sTempletNo="PDAStockInfo"; //有价证券类
	if (sAssetType.equals("06"))
		sTempletNo="PDAProceedsInfo"; //收益权类
	if (sAssetType.equals("07"))
		sTempletNo="PDAMaterialsInfo"; //物资类
	if (sAssetType.equals("08"))
		sTempletNo="PDAOthersInfo"; //其他类
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//获得该资产的表外/表内/未抵入标志,已决定显示风格
	String mySql = " select flag from ASSET_INFO Where  SerialNo = '" + sSerialNo +"' ";
	String myFlag = Sqlca.getString(mySql);
	if (myFlag == null) myFlag = "";
	
	//根据表内/表外/未抵入标志,决定如何显示AssetBalance,EnterValue,OutInitBalance,OutNowBalance字段.
	doTemp.setUpdateable("AssetBalance,EnterValue,OutInitBalance,OutNowBalance",false);
	//控制文本只能输入数字
	doTemp.appendHTMLStyle("AssetAmount"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");

	if (myFlag.equals(""))   //未抵入,拟抵入
		doTemp.setVisible("AssetBalance,EnterValue,OutInitBalance,OutNowBalance,InAccontDate,TransferStatus,NotTransferStatus,NotTransferReasons",false);		
	if (myFlag.equals("010")) //表内
	{
		doTemp.setVisible("OutInitBalance,OutNowBalance",false);		
		doTemp.setUpdateable("AssetBalance,EnterValue",true); 
	}
	if (myFlag.equals("020"))  //表外:没有入账日期.
	{
		doTemp.setVisible("AssetBalance,EnterValue,InAccontDate",false);		
		doTemp.setUpdateable("OutInitBalance,OutNowBalance",true); 
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写	
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
 
	%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		if(!checkDate()) return;	
		beforeUpdate();
		as_save("myiframe0");	
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
		
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{		
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=日期比较;InputParam=date1,data2,rule;OutPutParam=无;]~*/
	function compareDate(date1,date2,rule)
	{
		if(typeof(date1) != "undefined" && date1 != "" && typeof(date2) != "undefined" && date2 != "")
		{
			if(rule == "1")
			{
				if(date1 > date2) return true;
			}
			if(rule == "2")
			{
				if(date1 >= date2) return true;
			}
			if(rule == "3")
			{
				if(date1 < date2) return true;

			}
			if(rule == "4")
			{
				if(date1 <= date2) return true;
			}
		}
		return false;
	}
	
	/*~[Describe=日期校验;InputParam=无;OutPutParam=无;]~*/
	function checkDate()
	{	
		sBeginDate = getItemValue(0,getRow(),"BeginDate");
		sEndDate = getItemValue(0,getRow(),"EndDate");
		sInuseDate = getItemValue(0,getRow(),"InuseDate");
		
		if(compareDate(sBeginDate,sEndDate,"1")) 
		{
			alert("开工日期晚于竣工日期！");
			return false;
		}
		if(compareDate(sEndDate,sInuseDate,"1")) 
		{
			alert("竣工日期晚于投入使用日期！");
			return false;
		}
		return true;
	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
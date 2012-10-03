<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong  2009/09/08
		Tester:
		Describe: 抵债资产信息(处置)详情
		Input Param:
			SerialNo：业务申请流水号
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产信息(处置)详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	ASResultSet rs = null;//-- 存放结果集
	String sSql = "";
	String sRelativeSerialNo = "",sAssetName = "",sAssetAmount = "";
	String sAssetType = "",sEvalOrgName = "";
	double dAssetMarketSum = 0.00,dAssetEvaluateSum = 0.00,dAssetAccountSum = 0.00;
	//获得组件参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";
	
	//获得页面参数		
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));	
	if(sSerialNo == null ) sSerialNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//取得客户类型
	sSql = "select SerialNo,AssetName,AssetAmount,AssetType,AssetMarketSum,"+
			" AssetEvaluateSum,EvalOrgName,AssetAccountSum"+
			" from ASSET_INFO "+
			" where SerialNo in(Select RelativeSerialNo "+
			" from BADBIZ_APPLY　where SerialNo='"+sObjectNo+"') ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sRelativeSerialNo = rs.getString("SerialNo");
		sAssetName = rs.getString("AssetName");
		sAssetAmount = rs.getString("AssetAmount");
		sAssetType = rs.getString("AssetType");
		dAssetMarketSum = rs.getDouble("AssetMarketSum");
		dAssetEvaluateSum = rs.getDouble("AssetEvaluateSum");
		sEvalOrgName = rs.getString("EvalOrgName");
		dAssetAccountSum = rs.getDouble("AssetAccountSum");
	}
	rs.getStatement().close();
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "PDADisposeInfo";

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//设置比率范围
	//doTemp.appendHTMLStyle("RightProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"权益分担比例的范围为[0,100]\" ");
	//doTemp.appendHTMLStyle("DebtProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"债务分担比例的范围为[0,100]\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	dwTemp.setEvent("AfterUpdate","!PublicMethod.UpdateColValue(String@TempSaveFlag@2,BADBIZ_APPLY,String@SerialNo@#ObjectNo)");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);
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
		{"flase","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{				
		if(bIsInsert)
		{
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/PDADisposeList.jsp","_self","");
		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	/*~[Describe=自动计算值;InputParam=无;OutPutParam=无;]~*/
	function automCompute()
	{	
		sAssetSum = getItemValue(0,getRow(),"AssetSum");//抵债资产账面价
		sPershareValue = getItemValue(0,getRow(),"PershareValue");//拟处置(自用)价格
		sLossesSum = getItemValue(0,getRow(),"LossesSum");//预计处置费用
		setItemValue(0,0,"ProfitLossSum",sPershareValue-sAssetSum);
		setItemValue(0,0,"IntoCashSum",sPershareValue-sAssetSum-sLossesSum);
		if(sAssetSum!=0)
		{
			setItemValue(0,0,"IntoCashRatio",roundOff((sPershareValue-sAssetSum-sLossesSum)*100/sAssetSum,2));
		}
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		setItemValue(0,0,"ObjectType","<%=sObjectType%>");
		setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}


	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		setItemValue(0,0,"RelativeSerialNo","<%=sRelativeSerialNo%>");
		setItemValue(0,0,"AssetName","<%=sAssetName%>");
		setItemValue(0,0,"AssetAmount","<%=sAssetAmount%>");
		setItemValue(0,0,"AssetType","<%=sAssetType%>");
		setItemValue(0,0,"AssetMarketSum","<%=dAssetMarketSum%>");
		setItemValue(0,0,"EvalNetValue","<%=dAssetEvaluateSum%>");
		setItemValue(0,0,"EvalOrgName","<%=sEvalOrgName%>");
		setItemValue(0,0,"AssetSum","<%=dAssetAccountSum%>");
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"AssetFlag","030");
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSET_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

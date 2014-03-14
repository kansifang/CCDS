
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:zywei 2005/08/28
			Tester:
			Content: 新增授权方案页面
			Input Param:
			Output param:
			History Log: 

		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "新增授权方案"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	
	//获得组件参数

	//获得页面参数
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String[][] sHeaders = {					
				{"FormerPolicyName","前身方案名称"},
				{"PolicyName","方案名称"},
				{"EffDate","启用日期"},
				{"EffStatus","生效状态"},
				{"PolicyDescribe","方案说明"}
				};
		String sSql = 	" select PolicyID,FormerPolicyID,'' as FormerPolicyName,PolicyName,EffDate,EffStatus,PolicyDescribe, "+
				" InputUser,InputTime,UpdateUser,UpdateTime "+
				" from AA_POLICY "+
				" where 1 = 2 ";	
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.UpdateTable = "AA_POLICY";
		doTemp.setKey("PolicyID",true);	
		doTemp.setHeader(sHeaders);
		//设置不可见
		doTemp.setVisible("FormerPolicyID,FormerPolicyName,PolicyID,InputUser,InputTime,UpdateUser,UpdateTime",false);
		//设置下拉框
		doTemp.setDDDWCode("EffStatus","EffStatus");
		//设置必输项
		doTemp.setRequired("PolicyName,EffDate,EffStatus",true);
		doTemp.setCheckFormat("EffDate","3");
		//设置备注框
		doTemp.setEditStyle("PolicyDescribe","3");	
		doTemp.setHTMLStyle("PolicyDescribe","  style={height:150px;width:400px}  ");
		//设置不可更新
		doTemp.setUpdateable("FormerPolicyName",false);
		//设置只读
		doTemp.setReadOnly("FormerPolicyID,FormerPolicyName",true);
		//设置弹出式选择窗口
		doTemp.setUnit("FormerPolicyName","<input type=button value=\"...\" onClick=parent.getFormerPolicyID()>");
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		session.setAttribute(dwTemp.Name,dwTemp);
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/
%>
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
			{"true","","Button","确定","保存所有修改并返回","saveRecordAndReturn()",sResourcesPath},
			{"true","","Button","取消","返回","cancel()",sResourcesPath},
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
	
	/*~[Describe=保存所有修改,并返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function saveRecordAndReturn()
	{
		saveRecord("goBack()");
	}
	
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

	<script language=javascript>

	function goBack(){
		top.close();
	}
	
	function cancel(){
		top.close();
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
		setItemValue(0,0,"InputTime",sNow);
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sNow);
	}	

	/*~[Describe=弹出授权方案选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getFormerPolicyID(){
		//获得当前授权方案ID
		sPolicyID = getItemValue(0,getRow(),"PolicyID");
		sToday = "<%=StringFunction.getToday()%>";	
		if(typeof(sPolicyID) != "undefined" && sPolicyID != "") //修改和查看详情时，查询有效的且生效日期在当前日期之前的授权方案（除去本身之外）
		{	
			sParaString = "PolicyID"+","+sPolicyID+"@Today,"+sToday;
			alert(sParaString);
			setObjectValue("SelectFormerPolicy",sParaString,"@FormerPolicyID@0@FormerPolicyName@1",0,0,"");			
		}else //新增时，查询有效的且生效日期在当前日期之前的授权方案
		{
			sParaString = "Today,"+sToday;
			setObjectValue("SelectPolicy",sParaString,"@FormerPolicyID@0@FormerPolicyName@1",0,0,"");			
		}
		
	}
		
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "AA_POLICY";//表名
		var sColumnName = "PolicyID";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

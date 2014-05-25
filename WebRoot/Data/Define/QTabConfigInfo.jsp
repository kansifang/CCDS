<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
						
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "具体分数项配置列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";//Sql语句
	ASResultSet rs = null;//结果集
	//获得组件参数：对象类型、对象编号、对象权限
	String sCodeNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo")));
	String sItemNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo")));
	String sType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.compParentComponent.getParameter("type")));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = {
					{"ItemNo","流水号"},
					{"ItemName","模板名称"},
					{"Attribute1","要素Excel标题"},
					{"Attribute3","是否识别标签"},
					{"ItemDescribe","要素对应表字段"},
					{"Attribute6","要素所在表"},
					{"ItemAttribute","要素注释"},
					{"Attribute8","要素名称"},
					{"Attribute2","要素类型"},
					{"Attribute4","要素长度"},
					{"Attribute5","要素精度"},
					{"Attribute7","操作要素方式"},
					{"SortNo","序号"},
					{"IsInUse","有效"},
					{"InputUserName","登记人"},
					{"InputTime","登记时间"},
					{"UpdateUserName","更新人"},
					{"UpdateTime","更新时间"}
				};
	sSql =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
				" Attribute1,Attribute3,ItemDescribe,"+
				" Attribute6,ItemAttribute,Attribute8,Attribute2,Attribute4,Attribute5,"+
				" Attribute7,IsInUse,"+
				" InputUser,getUserName(InputUser) as InputUserName,InputTime,"+
				" UpdateUser,getUserName(UpdateUser) as UpdateUserName, UpdateTime"+
				" from Code_Library "+
				" where  CodeNo = '"+sCodeNo+"'"+
				" and ItemNo='"+sItemNo+"' order by SortNo asc";
	//用sSql生成数据窗体对象
	ASDataObject doTemp = null;
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWSql("Attribute2","select ItemNo,ItemName from Code_Library where CodeNo='DataType' and ItemNo in('Number','String') and IsInUse='1'");
	doTemp.setDDDWCode("Attribute3", "YesNo");
	doTemp.UpdateTable = "Code_Library";
	doTemp.setKey("CodeNo,ItemNo",true);
	//设置格式
	doTemp.setAlign("Attribute2,Attribute4,","1");
	doTemp.setRequired("Attribute2", true);
	doTemp.setVisible("CodeNo,ItemName,InputUser,UpdateUser,Attribute8",false);
	if("01".equals(sType)){
		doTemp.setVisible("Attribute6,ItemAttribute,Attribute7", false);
	}else{
		doTemp.setVisible("Attribute1,Attribute3,ItemDescribe", false);
	}
	doTemp.setUnit("ItemDescribe","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectColumn();\"> ");
	doTemp.setHTMLStyle("Attribute8"," style={width:200px} ");
	doTemp.setDDDWCode("IsInUse","YesNo");
	doTemp.setDDDWCode("Attribute7", "AlterType");
	doTemp.setUpdateable("InputUserName,UpdateUserName",false);
	doTemp.setReadOnly("ItemNo,InputUserName,UpdateUserName,InputTime,UpdateTime",true);
	//设置字段显示宽度	
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative(#SerialNo,#RelativeObjectType,#RelativeAgreement,APPLY_RELATIVE) + !WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")");
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
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
			{"true","","Button","保存并新增","新增另一条记录","saveRecord('newRecord()')",sResourcesPath},
			{"true","","Button","保存","保存","saveRecord('doReturn()')",sResourcesPath},
			{"false","","Button","返回","返回列表页面","doReturn()",sResourcesPath}
		};
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
		var bIsInsert=false;
		function saveRecord(sPostEvents){
			if (!ValidityCheck()) return;
			if(bIsInsert){
				beforeInsert();
			}else{
				//backupHis();
			}
			beforeUpdate();
			var ColumnName=getItemValue(0,getRow(),"ItemDescribe");//Excel对应的表字段
			if("<%=sType%>"=="02"){
				addColumn();
			}else if("<%=sType%>"=="01"){
				if(ColumnName.length==0){
					ColumnName=addColumn();
					setItemValue(0,0,"ItemDescribe",ColumnName);
				}
				var ItemNo=getItemValue(0,getRow(),"ItemNo");//Excel对应的表字段
				var ColumnType = getItemValue(0,getRow(),"Attribute2");
				var ColumnLong = getItemValue(0,getRow(),"Attribute4");
				var ColumnPrecision = getItemValue(0,getRow(),"Attribute5");
				var sReturn=RunMethod("PublicMethod","GetColValue","Count(1) as Count,Code_Library,String@CodeNo@b20140323000001@String@Attribute8@"+ColumnName+"@String@Attribute6@Batch_Import@String@Attribute7@AddColumn@String@IsInUse@1,Code_Library");
				if(sReturn.split('@')[1]==0){
					RunMethod("PublicMethod","InsertColValue","String@CodeNo@b20140323000001@String@ItemNo@"+ItemNo+"@String@Attribute8@"+ColumnName+"@String@Attribute2@"+ColumnType+"@String@Attribute4@"+ColumnLong+"@String@Attribute5@"+ColumnPrecision+"@String@Attribute6@Batch_Import@String@Attribute7@AddColumn@String@IsInUse@1,Code_Library");
				}
			}
			var sortNo=getItemValue(0,getRow(),"SortNo").toUpperCase();
			if(sortNo.length==1){
				sortNo='00'+sortNo;
			}else if(sortNo.length==2){
				sortNo='0'+sortNo;
			}
			setItemValue(0,0,"SortNo",sortNo);
			as_save("myiframe0",sPostEvents+"");
		}
		function addColumn(){
			var AlterType = getItemValue(0,getRow(),"Attribute7");
			var ColumnType = getItemValue(0,getRow(),"Attribute2");
			var ColumnLong = getItemValue(0,getRow(),"Attribute4");
			var ColumnPrecision = getItemValue(0,getRow(),"Attribute5");
			var ColumnTable = getItemValue(0,getRow(),"Attribute6");
			if(ColumnType=="String"){
				ColumnName=ColumnType+ColumnLong;
			}else{
				ColumnName=ColumnType+ColumnLong+ColumnPrecision;
			}
			var date=new Date();
			var prefix=date.getFullYear()+""+(date.getMonth()+1)+""+date.getDate()+""+date.getHours()+""+date.getMinutes()+""+date.getSeconds();
			ColumnName=ColumnName+prefix;//给字段名字加上后缀以避免重复
			setItemValue(0,0,"Attribute8",ColumnName);
			setItemValue(0,0,"Attribute6",ColumnTable.toUpperCase());
			RunMethod("PublicMethod","AlterColumnInDB",AlterType+","+ColumnTable+","+ColumnName+","+ColumnType+","+ColumnLong+","+ColumnPrecision);
			return ColumnName;
		}
		function newRecord()
		{
			OpenPage("/BusinessManage/BatchConfigInfo.jsp?CodeNo=<%=sCodeNo%>","_self","");
		}
	    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	    function doReturn(sIsRefresh){
			sObjectNo = getItemValue(0,getRow(),"CodeNo");
			parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
			parent.closeAndReturn();
		}
	    /*~[Describe=修改前保存一份备份;InputParam=无;OutPutParam=无;]~*/
	   	function backupHis(){
	   		var CodeNo = getItemValue(0,getRow(),"CodeNo");
	   		var ItemNo = getItemValue(0,getRow(),"ItemNo");
	   		RunMethod("SystemManage","InsertScoreConfigInfo",CodeNo+","+ItemNo);
		}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
<script language=javascript>
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		 setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	     setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
	}

	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		var patrn=/^(-?\d+)(\.\d{0,16})?$/;
		/*
		var sAttribute2=getItemValue(0,0,"Attribute2");
		if(sAttribute2.length>0){
			if(patrn.exec(sAttribute2)==null){
				alert("下限边界值必须为最多16位小数的数字！");
				setItemValue(0,getRow(),"Attribute2","");
				return false;
			}
		}
		var sAttribute4=getItemValue(0,0,"Attribute4");
		if(sAttribute4.length>0){
			if(patrn.exec(sAttribute4)==null){
				alert("上限边界值必须为最多16位小数的数字！");
				setItemValue(0,getRow(),"Attribute4","");
				return false;
			}
		}
		*/
		//校验编制日期是否大于当前日期
		sDocDate = getItemValue(0,0,"DocDate");//编制日期
		sToday = "<%=StringFunction.getToday()%>";//当前日期
		if(typeof(sDocDate) != "undefined" && sDocDate != "")
		{
			if(sDocDate > sToday)
			{
				alert(getBusinessMessage('161'));//编制日期必须早于当前日期！
				return false;
			}
		}
		return true;
	}
	function selectColumn()
	{		
		sParaString = "CodeNo,b20140323000001,CurrCodeNo,<%=sCodeNo%>";
		setObjectValue("SelectColumn",sParaString,"@ItemDescribe@2@Attribute2@3@Attribute4@4@Attribute5@5",0,0,"");			
	}
   /*~[Describe=初始化选择标记;InputParam=无;OutPutParam=无;]~*/
   function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CodeNo","<%=sCodeNo%>");
			setItemValue(0,0,"Attribute3","2");
			setItemValue(0,0,"Attribute2","String");
			setItemValue(0,0,"Attribute5","0");
			setItemValue(0,0,"Attribute6","Batch_Import");
			setItemValue(0,0,"Attribute7","AddColumn");
	        setItemValue(0,0,"IsInUse","1");
	        setItemValue(0,0,"SortNo","000");
	        setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"InputTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
	        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
		    bIsInsert = true;
		}
   }
   /*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo()
	{
		var sTableName = "Code_Library";//表名
		var sColumnName = "ItemNo";//字段名
		var sPrefix = "";//前缀
		//使用GetSerialNo.jsp来抢占一个流水号
		var sItemNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sItemNo);
	}
	function randomNumber()
	{
		today = new Date();
		num = Math.abs(Math.sin(today.getTime()));
		return num;  
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	var bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow();
	//var bCheckBeforeUnload=false;
</script>
<%
	/*~END~*/
%>
<%@	include file="/IncludeEnd.jsp"%>
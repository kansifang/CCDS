<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: zywei 2005-11-27
			Tester:
			Describe: 业务申请所对应的新增的担保信息列表;
			Input Param:
			ObjectType：对象类型（CreditApply）
			ObjectNo: 对象编号（申请流水号）
			Output Param:
			
			HistoryLog:
						
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
	String sModelNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo")));
	String sItemNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo")));
	String sValueCode = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ValueCode")));
	//CreditLevelToTotalScore 评级配置   ScoreToItemValue 项目配置
	String sCodeNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo")));
	String sCItemNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CItemNo")));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders0[][] = {
					{"ItemNo","流水号"},
					{"ItemDescribe","a"},
					{"Attribute1","b"},
					{"Attribute2","c"},
					{"Attribute3","d"},
					{"Attribute4","Median"},
					{"Attribute5","StDev"},
					{"Attribute6","LowerLimit"},
					{"Attribute7","UpperLimit"},
					{"IsInUse","是否有效"},
					{"UpdateUserName","更新人"},
					{"UpdateTime","更新时间"}
				};
	String sSql0 =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
				" ItemDescribe,"+
				" Attribute1,"+
				" Attribute2,"+
				" Attribute3,"+
				" Attribute4,"+
				" Attribute5,"+
				" Attribute6,"+
				" Attribute7,"+
				" IsInUse,"+
				" InputUser,"+
				" getUserName(UpdateUser) as UpdateUserName,"+
				" InputTime,"+
				" UpdateUser,"+
				" getUserName(UpdateUser) as UpdateUserName,"+
				" UpdateTime"+
				" from Code_Library "+
				" where  CodeNo = '"+sCodeNo+"'"+
				" and ItemName='"+sModelNo+"'"+
				" and SortNo='"+sItemNo+"'";
	String sHeaders1[][] = {
					{"ItemNo","流水号"},
					{"ItemDescribe","分值"},
					{"Attribute1","下限操作符（定量）"},
					{"Attribute2","下限边界值（定量）"},
					{"Attribute3","上限操作符（定量）"},
					{"Attribute4","上限边界值（定量）"},		
					{"Attribute5","取值（定性）"},
					{"IsInUse","有效"},
					{"InputUserName","登记人"},
					{"InputTime","登记时间"},		
					{"UpdateUserName","更新人"},
					{"UpdateTime","更新时间"}
				};
	String sHeaders2[][] = {
					{"ItemNo","流水号"},
					{"ItemDescribe","评级"},
					{"Attribute1","下限操作符"},
					{"Attribute2","下限边界值"},
					{"Attribute3","上限操作符"},
					{"Attribute4","上限边界值"},		
					{"IsInUse","有效"},
					{"InputUserName","登记人"},
					{"InputTime","登记时间"},		
					{"UpdateUserName","更新人"},
					{"UpdateTime","更新时间"}
		  				};
	sSql =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
		" ItemDescribe,"+
		" Attribute1,"+
		" Attribute2,"+
		" Attribute3,"+
		" Attribute4,"+
		" Attribute5,"+
		" IsInUse,"+
		" InputUser,"+
		" getUserName(InputUser) as InputUserName,"+
		" InputTime,"+
		" UpdateUser,"+
		" getUserName(UpdateUser) as UpdateUserName,"+
		" UpdateTime"+
	" from Code_Library "+
	" where  CodeNo = '"+sCodeNo+"'"+
	" and ItemNo='"+sCItemNo+"'"+
	" and ItemName='"+sModelNo+"'";
	//用sSql生成数据窗体对象
	ASDataObject doTemp = null;
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	if("311".equals(sModelNo)&&sItemNo.endsWith("TJMX")){//制造业中小有统计模型公式
	doTemp = new ASDataObject(sSql0);
	doTemp.setHeader(sHeaders0);
	}else{
		if("ScoreToItemValue".equals(sCodeNo)){
	sSql+=" and SortNo='"+sItemNo+"' order by Double(ItemDescribe) asc ";
	doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders1);
	if(!"".equals(sValueCode)){
		doTemp.setVisible("Attribute1,Attribute2,Attribute3,Attribute4",false);
		doTemp.setDDDWCode("Attribute5",sValueCode);
		doTemp.setRequired("Attribute5",true);
		doTemp.setHTMLStyle("Attribute5"," style={width:1000px} ");
		if("标普主权国家评级".equals(sValueCode)){
			doTemp.setDDDWCode("ItemDescribe","标准普尔主标尺得分表");
		}
	}else{
		doTemp.setVisible("Attribute5",false);
	}
		}else if("CreditLevelToTotalScore".equals(sCodeNo)){
	sSql+=" order by ItemDescribe asc ";
	doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders2);
	doTemp.setVisible("Attribute5",false);
	doTemp.setDDDWSql("ItemDescribe","select ItemNo,ItemName from Code_Library where CodeNo='CreditLevel'");
		}
		doTemp.setDDDWSql("Attribute1","select ItemNo,ItemName from Code_Library where CodeNo='ArithmeticOpe' and ItemNo in('030','040','050') and IsInUse='1'");
		doTemp.setDDDWSql("Attribute3","select ItemNo,ItemName from Code_Library where CodeNo='ArithmeticOpe' and ItemNo in('010','020','050') and IsInUse='1'");
	}
	doTemp.UpdateTable = "Code_Library";
	doTemp.setKey("CodeNo,ItemNo",true);
	//设置格式
	doTemp.setAlign("Attribute2,Attribute4,","1");
	doTemp.setVisible("CodeNo,ItemName,SortNo,InputUser,UpdateUser",false);
	//doTemp.setHTMLStyle("Attribute1,Attribute2,Attribute3,Attribute4"," style={width:auto} ");
	doTemp.setDDDWCode("IsInUse","YesNo");
	doTemp.setRequired("IsInUse",true);
	//doTemp.setCheckFormat("InputTime,UpdateTime","3");
	doTemp.setUpdateable("InputUserName,UpdateUserName",false);
	doTemp.setReadOnly("ItemNo,InputUserName,UpdateUserName,InputTime,UpdateTime",true);
	//设置字段显示宽度	
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
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
			{"true","","Button","新增","新增另一条记录","newRecord()",sResourcesPath},
			{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
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
	function saveRecord()
	{
		var patrn=/^(-?\d+)(\.\d{0,16})?$/;
		var sItemDescribe=getItemValue(0,0,"ItemDescribe");
		if(sItemDescribe.length>0&&"<%=sCodeNo%>"=="ScoreToItemValue"){
			if (patrn.exec(sItemDescribe)==null){
				alert("分值必须为最多16位小数的数字！");
				setItemValue(0,getRow(),"ItemDescribe","");
				return false;
			}
		}
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
		if(!bIsInsert){
			backupHis();
		}
		as_save("myiframe0","");
	}
	 /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd()
	{
        as_save("myiframe0","newRecord()");
	}
	function newRecord()
	{
		OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp?CodeNo=<%=sCodeNo%>","_self","");
		//OpenComp("EvaluateScoreConfigInfo","/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp","CodeNo=<%=sCodeNo%>","_self","");
	}
	 /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
   	function goBack(){
		OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigList.jsp","_self","");
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
   /*~[Describe=初始化选择标记;InputParam=无;OutPutParam=无;]~*/
   function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CodeNo","<%=sCodeNo%>");
	        var sItemNo=PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=Code_Library&ColumnName=ItemNo","","");
	        setItemValue(0,0,"ItemNo",sItemNo);
	        setItemValue(0,0,"ItemName","<%=sModelNo%>");
	        setItemValue(0,0,"SortNo","<%=sItemNo%>");
	        setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"InputTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
	        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
		    bIsInsert = true;
		}else{
			 setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		     setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
		}
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
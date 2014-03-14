
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:zywei 2005/08/30
			Tester:
			Content: 例外条件基本信息页面
			Input Param:
		ExceptionID：例外点ID
		AuthID：授权点ID
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
		String PG_TITLE = "例外条件信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sExceptionID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExceptionID"));
	String sAuthID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthID"));
	if(sExceptionID == null) sExceptionID = "";
	if(sAuthID == null) sAuthID = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String[][] sHeaders = {
				{"AuthID","授权点ID"},
				{"TypeID","例外类型ID"},
				{"TypeName","例外类型说明"},
				{"SortNo","排序号"},					
				{"VariableA","变量A"},					
				{"VariableB","变量B"},		
				{"BizBalanceCeiling","终批单笔金额上限（元）"},
				{"BizExposureCeiling","终批单笔敞口授权上限（元）"},
				{"CustBalanceCeiling","终批单户金额授权上限（元）"},
				{"CustExposureCeilin","终批单户敞口授权上限（元）"},
				{"InterestRateFloor","终批利率下限（%）"},
				{"IsInUse","是否可用"},
				};
		String sSql = 	" select ExceptionID,AuthID,TypeID,'' as TypeName,VariableA,VariableB,SortNo, "+
				" BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling, "+
				" CustExposureCeilin,InterestRateFloor,IsInUse,InputUser, "+
				" InputTime,UpdateUser,UpdateTime "+
				" from AA_EXCEPTION "+
				" where AuthID = '"+sAuthID+"' "+
				" and ExceptionID = '"+sExceptionID+"' ";	
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.UpdateTable = "AA_EXCEPTION";
		doTemp.setKey("ExceptionID",true);	
		doTemp.setHeader(sHeaders);
		//设置不可见
		doTemp.setVisible("AuthID,ExceptionID,InputUser,InputTime,UpdateUser,UpdateTime",false);
		//设置下拉框
		doTemp.setDDDWCode("IsInUse","YesNo");
		//设置必输项
		doTemp.setRequired("TypeID,SortNo,IsInUse",true);	
		//设置不可更新
		doTemp.setUpdateable("TypeName",false);
		//设置只读
		doTemp.setReadOnly("AuthID,TypeID,TypeName",true);
		//设置数据输入项格式
		doTemp.setAlign("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin,InterestRateFloor","3");
		doTemp.setCheckFormat("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,InterestRateFloor,CustExposureCeilin","2");
		//设置例外类型的弹出选择窗口模式
		doTemp.setUnit("TypeID","<input class=inputdate type=button value=\"...\" onClick=parent.getTypeID()>");

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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}		
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
	function saveRecord()
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0");
		
	}	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/Common/Configurator/AAManage/ExceptionSettingList.jsp?AuthID=<%=sAuthID%>","_self","");
	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

	<script language=javascript>

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

	/*~[Describe=弹出例外类型选择窗口;InputParam=无;OutPutParam=无;]~*/
	function getTypeID(){
		setObjectValue("SelectExceptionType","","@TypeID@0@TypeName@1",0,0,"");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"AuthID","<%=sAuthID%>");
			bIsInsert = true;
		}
		//获得例外类型ID
		sTypeID = getItemValue(0,getRow(),"TypeID");
		if(typeof(sTypeID) != "undefined" && sTypeID != "") 
		{
			sReturn=RunMethod("PublicMethod","GetColValue","TypeName,AA_EXCEPTIONTYPE,String@TypeID@"+sTypeID);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				sExceptionTypeInfo = sReturn.split('@');
				sTypeName = sExceptionTypeInfo[1];				
				setItemValue(0,getRow(),"TypeName",sTypeName);
			}
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "AA_EXCEPTION";//表名
		var sColumnName = "ExceptionID";//字段名
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
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

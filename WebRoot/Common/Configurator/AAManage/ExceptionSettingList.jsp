
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2005/08/28
		Tester:
		Content: 授权点列表页面
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权点列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	
	//获得页面参数	
	String sAuthID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthID"));
	if(sAuthID == null) sAuthID = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {
							{"SortNo","顺序号"},
							{"ExceptionID","例外点ID"},
							{"AuthID","授权点ID"},														
							{"TypeID","例外类型ID"},
							{"TypeName","例外类型"},
							{"VariableA","变量A"},
							{"BizBalanceCeiling","终批单笔金额上限（元）"},
							{"BizExposureCeiling","终批单笔敞口授权上限（元）"},
							{"CustBalanceCeiling","终批单户金额授权上限（元）"},
							{"CustExposureCeilin","终批单户敞口授权上限（元）"},
							{"InterestRateFloor","授权利率下限（%）"},
							{"VariableB","变量B"},
							{"IsInUse","是否可用"}
						  };
	sSql =  " select AE.SortNo,AE.ExceptionID,AE.AuthID,AE.TypeID,AET.TypeName, "+
			" AE.VariableA,AE.VariableB,AE.BizBalanceCeiling,AE.BizExposureCeiling, "+
			" AE.CustBalanceCeiling,AE.CustExposureCeilin,AE.InterestRateFloor, "+
			" getItemName('YesNo',AE.IsInUse) as IsInUse "+
			" from AA_EXCEPTION AE,AA_EXCEPTIONTYPE AET "+
			" Where AE.TypeID=AET.TypeID "+
			" and AE.AuthID = '"+sAuthID+"' "+
			" order by SortNo";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "AA_EXCEPTION";
	doTemp.setKey("ExceptionID",true);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("ExceptionID,AuthID,TypeID",false);
	doTemp.setHTMLStyle("TypeName"," style={width:250px} ");
	doTemp.setType("BizBalanceCeiling","Number");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{		
		sAuthID = "<%=sAuthID%>";
		if(typeof(sAuthID) == "undefined" || sAuthID.length == 0)
		{
			alert("请在授权点设定列表中先选择一条信息后，再新增例外条件！");
			return;
		}else
			OpenPage("/Common/Configurator/AAManage/ExceptionSettingInfo.jsp?AuthID=<%=sAuthID%>","_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		//例外条件ID   
	    sExceptionID = getItemValue(0,getRow(),"ExceptionID");			
		if (typeof(sExceptionID) == "undefined" || sExceptionID.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		//例外条件ID  
		sExceptionID = getItemValue(0,getRow(),"ExceptionID");
		if (typeof(sExceptionID) == "undefined" || sExceptionID.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenPage("/Common/Configurator/AAManage/ExceptionSettingInfo.jsp?AuthID=<%=sAuthID%>&ExceptionID="+sExceptionID,"_self","");
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

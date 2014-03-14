<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.are.util.SpecialTools" %>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:ljma   2011-02-24
			Tester:
			Content: 贷款控制信息
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
		String PG_TITLE = "业务限制信息页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";
	//获得组件参数

	//获得页面参数	
	String sIndustryType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IndustryType"));
	if(sIndustryType==null) sIndustryType="";
	String sScope =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope"));
	if(sScope==null) sScope="";
%>
<%
	/*~END~*/
%>

<%
	String sHeaders[][] = { 
	{"IndustryType","国标行业"},
	{"IndustryTypeName","国标行业"},
	{"Scope","企业规模"},
	{"EmployeeNumberMin","从业人数下限（含）"},
	{"EmployeeNumberMax","从业人数上限"},
	{"SaleSumMin","销售额下限（含）（万元）"},
	{"SaleSumMax","销售额上限（万元）"},
	{"AssetSumMin","资产总额下限（含）（万元）"},
	{"AssetSumMax","资产总额上限（万元）"},
	{"InputUserName","登记人员"},
	{"InputOrgName","登记机构"},
	{"InputDate","登记日期"},
	{"UpdateUserName","更新人员"},
	{"UpdateOrgName","更新机构"},
	{"UpdateDate","更新日期"}
	
		};
	sSql = " select IndustryType,getItemName('IndustryType',nvl(IndustryType,'')) as IndustryTypeName,Scope,"+
		  " EmployeeNumberMin,EmployeeNumberMax, "+ 
		  " SaleSumMin,SaleSumMax, "+
		  " AssetSumMin,AssetSumMax, "+
		  " InputUserID,getUserName(InputUserID) as InputUserName, "+
		  " InputOrgID,getOrgName(InputOrgID) as InputOrgName,"+
		  "	InputDate, "+
		  " UpdateUserID,getUserName(UpdateUserID) as UpdateUserName, "+
		  " UpdateOrgID,getOrgName(UpdateOrgID) as UpdateOrgName,"+
		  " UpdateDate "+
		  " from ENT_SCOPE_STANDARD where IndustryType='"+sIndustryType+"' and Scope='"+sScope+"'";
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		//通过显示模版产生ASDataObject对象doTemp
		//设置DataObject				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);

		//设置更新表及其主键
		doTemp.UpdateTable="ENT_SCOPE_STANDARD";
		doTemp.setKey("IndustryType,Scope",true);

		//设置必输项
		doTemp.setRequired("Scope,IndustryType,EmployeeNumberMin,EmployeeNumberMax,SaleSumMin,SaleSumMax,AssetSumMin,AssetSumMax",true);
		doTemp.setUpdateable("IndustryTypeName,InputUserName,InputOrgName,UpdateUserName,UpdateOrgName",false);
		
		//设置不可见
		doTemp.setVisible("SerialNo,IndustryType,InputUserID,InputOrgID,UpdateUserID,UpdateOrgID",false);
		//设置下拉列表
	    doTemp.setDDDWCode("Scope","Scope");
		//设置选择树图
		doTemp.setUnit("IndustryTypeName","<input class=\"inputdate\" value=\"...\" type=button value=.. onclick=parent.getIndustryType()>");
		//设置只读列
		doTemp.setReadOnly("IndustryTypeName,InputOrgName,InputUserName,InputDate,UpdateDate,UpdateUserName,UpdateOrgName",true); 
		//设置宽度
		//doTemp.setEditStyle("OrgName,OrgID,BusinessType,BusinessTypeName,OccurType,OccurTypeName","3");
		//设置格式，对应显示模版中的格式1、字符串，2数字（带小数），3、日期，4、时间，5、整型数字
		doTemp.setCheckFormat("EmployeeNumberMin,EmployeeNumberMax","5");
		doTemp.setCheckFormat("SaleSumMin,SaleSumMax,AssetSumMin,AssetSumMax","2");
		doTemp.setCheckFormat("InputDate,UpdateDate","3");
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		//session.setAttribute(dwTemp.Name,dwTemp);
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
	function saveRecord(sPostEvents)
	{
		//进行相关检查
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		var sScope = getItemValue(0,getRow(),"Scope");
		var bIsHaveInserted =RunMethod("BusinessManage","CheckIndustryAndScope",sIndustryType+","+sScope);
		if(bIsHaveInserted=='exist'){
			alert("此国标行业此规模已存在！");
			return;
		}else if(bIsHaveInserted=='ldifferent'){
			alert("与此国标行业分类层次不一致的国标行业已存在！");
			return;
		}
		as_save("myiframe0");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/EntScoptStandardList.jsp","_self","");
	}

	

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateOrgID","<%=CurUser.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=(多选)弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
    function AddBusinessType(){
    	var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	var sReturn =  PopPage("/SystemManage/CreditTypeLimit/AddBusinessType.jsp?SerialNo="+sSerialNo,"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin");       	
		var temp = "";
		var sBusinessTypeValue = "";
		var sBusinessTypeName = "";
		if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn != "_none_")
		{
			sBusinessTypeInfo = sReturn.split('@');
			for(i=0;i<sBusinessTypeInfo.length-1;i=i+2){
				sBusinessTypeValue=sBusinessTypeValue+sBusinessTypeInfo[i]+";" ;
			}
			for(i=1;i<sBusinessTypeInfo.length-1;i=i+2){
				sBusinessTypeName = sBusinessTypeName + sBusinessTypeInfo[i]+";"
			}
			setItemValue(0,getRow(),"BusinessType",sBusinessTypeValue);
			setItemValue(0,getRow(),"BusinessTypeName",sBusinessTypeName);				
		}
    }


	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	/*~[Describe=弹出国标行业类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType()
	{

		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelectNew.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo.search("OK") >0){
			if(sIndustryTypeInfo == "NO")
			{
				setItemValue(0,getRow(),"IndustryType","");
				setItemValue(0,getRow(),"IndustryTypeName","");
			}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
			{
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
				sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
				setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
				setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);	
			}
		}else{
			if(sIndustryTypeInfo == "NO")
			{
				setItemValue(0,getRow(),"IndustryType","");
				setItemValue(0,getRow(),"IndustryTypeName","");
			}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
			{
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
				sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
	
				sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelectNew.jsp?IndustryTypeValue="+sIndustryTypeValue+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
				if(sIndustryTypeInfo == "NO")
				{
					setItemValue(0,getRow(),"IndustryType","");
					setItemValue(0,getRow(),"IndustryTypeName","");
				}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
				{
					sIndustryTypeInfo = sIndustryTypeInfo.split('@');
					sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
					sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
					setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
					setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);	
				}
			}
		}
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "ENT_SCOPE_STANDARD";//表名
		var sColumnName = "SerialNo";//字段名
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
	//var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

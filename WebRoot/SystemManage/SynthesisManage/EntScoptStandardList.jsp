<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:	ljma  2011-02-24
			Tester:
			Content: 贷款管理列表
			Input Param:
			Output param:
			History Log: 
		

		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "企业规模标准"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sHeaders[][] = { 
	{"Scope","企业规模"},
	{"ScopeName","企业规模"},
	{"IndustryType","国标行业"},
	{"IndustryTypeName","国标行业"},
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
	String sSql = " select IndustryType,getItemName('IndustryType',IndustryType) as IndustryTypeName, "+
		  "Scope,getItemName('Scope',Scope) as ScopeName,"+
		  " EmployeeNumberMin,EmployeeNumberMax, "+ 
		  " SaleSumMin,SaleSumMax, "+
		  " AssetSumMin,AssetSumMax, "+
		  " getUserName(InputUserID) as InputUserName, "+
		  " getOrgName(InputOrgID) as InputOrgName,"+
		  "	InputDate, "+
		  " getUserName(UpdateUserID) as UpdateUserName, "+
		  " getOrgName(UpdateOrgID) as UpdateOrgName,"+
		  " UpdateDate "+
		  " from ENT_SCOPE_STANDARD where 1=1 ";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//设置DataObject				
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	//doTemp.setColumnAttribute("ExampleName","IsFilter","1");


	doTemp.UpdateTable="ENT_SCOPE_STANDARD";
	doTemp.setKey("SERIALNO",true);

	//设置不可见
	doTemp.setVisible("SerialNo,Scope,IndustryType",false);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("IndustryTypeName","style={width:200px} ");  
	
	//doTemp.setDDDWSql("BusinessType"," select TypeNo,TypeName from Business_Type where IsInUse = '1' order by SortNo ");
	//doTemp.setDDDWSql("OrgID"," select OrgID,OrgName from org_info where orglevel = '6' and status = '1' or OrgID in ('3200','3400') order by orglevel ");
	doTemp.setDDDWCode("Scope","Scope");
	doTemp.setDDDWCode("IndustryType","IndustryType");
	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","Scope","");
	//doTemp.setFilter(Sqlca,"2","IndustryType","style={editables}");
	doTemp.setFilter(Sqlca,"2","IndustryType","HtmlTemplate=PopSelect");
	doTemp.parseFilterData(request,iPostChange);
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=1";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath}	,
			{"true","","PlainText","(数字类型的非控制项请填写“-1”)","(数字类型的非控制项请填写“-1”)","style={color:red}",sResourcesPath}		
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

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/SystemManage/SynthesisManage/EntScoptStandardInfo.jsp","_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")) 
		{		
			//进行日志记录
			RunMethod("BusinessManage","CreditLimitLog",sSerialNo+",DELETE(删除),<%=CurUser.UserID%>");
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		var sScope = getItemValue(0,getRow(),"Scope");
		if (typeof(sIndustryType)=="undefined" || sIndustryType.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		OpenPage("/SystemManage/SynthesisManage/EntScoptStandardInfo.jsp?IndustryType="+sIndustryType+"&Scope="+sScope,"_self","");
	}
	
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	/*~[Describe=查询条件;InputParam=无;OutPutParam=SerialNo;]~*/
	function filterAction(sObjectID,sFilterID,sObjectID2)
	{
		oMyObj = document.all(sObjectID);
		oMyObj2 = document.all(sObjectID2);
		if(sFilterID=="2"){
			getIndustryType(oMyObj,oMyObj2);
		}
	}
	/*~[Describe=弹出国标行业类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType(id,name)
	{
		//由于行业分类代码有几百项，分两步显示行业代码
		var sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelectNew.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(typeof(sIndustryTypeInfo)=="undefined" || sIndustryTypeInfo.length==0){
			return;
		}
		if(sIndustryTypeInfo.search("OK") >0){
			if(sIndustryTypeInfo == "NO")
			{
				id.value="";
				name.value="";
			}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
			{
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
				sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
				id.value=sIndustryTypeValue;
				name.value=sIndustryTypeName;
			}
		}else{
			if(sIndustryTypeInfo == "NO")
			{
				id.value="";
				name.value="";
			}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
			{
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
				sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
	
				sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelectNew.jsp?IndustryTypeValue="+sIndustryTypeValue+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
				if(sIndustryTypeInfo == "NO")
				{
					id.value="";
					name.value="";
				}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
				{
					sIndustryTypeInfo = sIndustryTypeInfo.split('@');
					sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
					sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
					id.value=sIndustryTypeValue;
					name.value=sIndustryTypeName;
				}
			}
		}
	}
	</script>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>

	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.07      
		Tester:	
		Content: 数据采集 汇总数据录入
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "汇总数据录入"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//存放 sql语句
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//获取关联客户信息表数据	
	String sHeaders[][] = { 
					{"AccountMonth","会计月份"},
					{"AccountMonth1","会计月份"},
					{"RptType","报表类型"},
					{"RptTypeName","报表类型"},
					{"OrgBelongID","所属机构"},
					{"OrgBelongIDName","所属机构"},
					{"InputUserID","录入人"},
					{"InputUserIDName","录入人"},
					{"InputDate","录入时间"}
	        }; 
    sSql = "select AccountMonth,AccountMonth as AccountMonth1,RptType,getItemName('RptType',RptType) as RptTypeName,"+
    	   " OrgBelongID,getOrgName(OrgBelongID) as OrgBelongIDName,InputUserID,getUserName(InputUserID) as InputUserIDName,InputDate " + 
  	       " from Reserve_Stat " +
  	       " where 1=1 ";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Stat";
    doTemp.setKey("AccountMonth,RptType",true);
    doTemp.setDDDWSql("RptType","select ItemNo,ItemName from code_library where codeno = 'RptType'");
  //  doTemp.setDDDWSql("AccountMonth","select distinct AccountMonth,AccountMonth from Reserve_Stat desc ");
//    doTemp.setColumnAttribute("AccountMonth,OrgBelongID","IsFilter","1");
    doTemp.setVisible("AccountMonth,OrgBelongID,RptType,InputUserID",false);
	//doTemp.setCheckFormat("AccountMonth","6");
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","AccountMonth","");
	doTemp.setFilter(Sqlca,"2","RptType","");
	doTemp.setFilter(Sqlca,"3","OrgBelongID","");
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()){
	//	doTemp.WhereClause += " and AccountMonth In (Select max(AccountMonth) from Reserve_Stat )";
	//}
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//设置在datawindows中显示的行数
	dwTemp.setPageSize(20); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "1"; 
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("AccountMonth");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //调试datawindow的Sql常用方法
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
		//6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","查看详情","查看/修改详情","viewAndEdit()",sResourcesPath},
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
	function newRecord()
	{
		var sAccountMonth = '';
		var sRptType = '';
		var sReturnValue = '';//--存放客户输入信息
		var sReturnValue = PopPage("/BusinessManage/ReserveDataPrepare/AddReport.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sReturnValue) != "undefined" && sReturnValue.length != 0 && sReturnValue != '_CANCEL_')
		{
			sReturnValue = sReturnValue.split("@");
			sAccountMonth = sReturnValue[0];
			sRptType = sReturnValue[1];
		}
		else {
			return;
		}
		var sReturnValue = PopComp("ReportInfo","/BusinessManage/ReserveDataPrepare/ReportInfo.jsp","AccountMonth="+sAccountMonth+"&RptType="+sRptType,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");

		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sRptType = getItemValue(0,getRow(),"RptType");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReportInfo","/BusinessManage/ReserveDataPrepare/ReportInfo.jsp","AccountMonth="+sAccountMonth+"&RptType="+sRptType,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function deleteRecord(sPostEvents)
	{
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sInputUserID = getItemValue(0,getRow(),"InputUserID");
		if (typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		if(sInputUserID == "<%=CurUser.UserID%>"){
			if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
			{
				as_del("myiframe0");
				as_save("myiframe0",sPostEvents);  //如果单个删除，则要调用此语句
			}
		}else
		{
			alert("此条数据不是您录入的,不能删除");
		}
	}
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	function filterAction(sObjectID,sFilterID,sObjectID2){
	oMyObj = document.all(sObjectID);
	oMyObj2 = document.all(sObjectID2);
	if(sFilterID=="1"){
		
	}else if(sFilterID=="3"){
			//弹出模态窗口选择框，并将返回值赋给sReturn
			sReturn = selectObjectInfo("Code","CodeNo=OrgInfo^请选择所属机构^","");
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_"){
				return;
			}else if(sReturn=="_CLEAR_"){
				oMyObj.value="";
				oMyObj2.value="";
			}else{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				oMyObj2.value=sReturns[1];
			}
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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.07      
		Tester:	
		Content: 数据采集——对公数据维护
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "对公数据维护"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sHeaders[][]={
							{"AccountMonth","会计月份"},
							{"AccountMonth1","会计月份"},
	                        {"LoanAccount","借据号"},
	                        {"DuebillNo","借据编号"},
	                        {"CustomerOrgCode","客户组织机构代码"},
	                        {"CustomerOrgCodeName","客户组织机构名称"},
	                        {"CustomerID","客户编号"},
	                        {"CustomerName","客户名称"},
	                        {"IndustryType","行业类型"},
	                        {"Scope","企业规模"},
	                        {"PutoutDate","发放日"},
	                        {"Maturity","到期日"},
	                        {"RMBBalance","余额(元)"},
	                        {"MFiveClassify","五级分类"},
	                        {"MFiveClassifyName","五级分类"},
//	                        {"AFiveClassify","审计五级分类"},
//	                        {"AFiveClassifyName","审计五级分类"},
	                        {"AuditStatFlag","是否审计"},
	                        {"AuditStatFlagName","是否审计"},
	                        {"ManageStatFlag","计提模式"},
	                        {"ManageStatFlagName","计提模式"},                     
	                        {"Manageuserid","管户人"},
	                        {"ManageuserName","管户人"},
	                        {"ManageOrgID","管户机构"},
	                        {"ManageOrgName","管户机构"},
	                        {"Region","客户所在地区"},
	                        {"LoanType","业务类别"}
                        };
    sSql = " select AccountMonth,AccountMonth as AccountMonth1,LoanAccount,DuebillNo,CustomerID,CustomerName,PutoutDate,"+
    	   " CustomerOrgCode,getOrgName(CustomerOrgCode) as CustomerOrgCodeName,IndustryType,Scope,"+
    	   " Maturity,RMBBalance,MFiveClassify,getItemName('MFiveClassify',MFiveClassify) as MFiveClassifyName,"+
    	   " AFiveClassify,getItemName('MFiveClassify',AFiveClassify) as AFiveClassifyName,"+
    	   " AuditStatFlag,getItemName('AuditStatFlag',AuditStatFlag) as AuditStatFlagName,ManageStatFlag,getItemName('ManageStatFlag',ManageStatFlag) as ManageStatFlagName,"+
    	   " Manageuserid,getUserName(Manageuserid) as ManageuserName, " +
    	   " ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName, "+
    	   " Region,LoanType "+
    	   " from Reserve_Total  " +
    	   " where BusinessFlag = '1'";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
//	doTemp.setColumnAttribute("AccountMonth,LoanAccount,CustomerName,AuditStatFlag,ManageStatFlag,ManageuserName","IsFilter","1");
	
    doTemp.UpdateTable="Reserve_Total";
    doTemp.setKey("AccountMonth,LoanAccount",true);
    doTemp.setVisible("AccountMonth,DuebillNo,CustomerOrgCode,CustomerOrgCodeName,CustomerID,IndustryType,"+
     	              "Scope,MFiveClassify,AFiveClassify,AFiveClassifyName,AuditStatFlag,ManageStatFlag,Manageuserid,ManageOrgID,"+
     	              "Region,LoanType",false);
    doTemp.setType("RMBBalance","Number") ;	              
    doTemp.setCheckFormat("AccountMonth1,PutoutDate,Maturity","3"); 	              
    //doTemp.setCheckFormat("AccountMonth","6");
    doTemp.setHTMLStyle("LoanAccount","style={width:150}");
    doTemp.setHTMLStyle("ManageOrgName,CustomerName","style={width:200}");    
    //doTemp.setDDDWSql("Scope","select ItemNo,ItemName from code_library where codeno = 'Scope'");
    //doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from code_library where codeno = 'IndustryType1'");
    //doTemp.setDDDWSql("AccountMonth","select distinct AccountMonth,AccountMonth from Reserve_Total desc ");
    doTemp.setDDDWSql("MFiveClassify","select ItemNo,ItemName from code_library where codeno = 'MFiveClassify'");
    doTemp.setDDDWSql("AFiveClassify","select ItemNo,ItemName from code_library where codeno = 'MFiveClassify'");
    doTemp.setHTMLStyle("AccountMonth,MFiveClassifyName,AuditStatFlagName,ManageStatFlagName,ManageuserName","style={width:80}");
    doTemp.setHTMLStyle("PutoutDate,Maturity,AFiveClassifyName","style={width:100}");
	doTemp.setDDDWSql("AuditStatFlag","select ItemNo,ItemName from code_library where codeno = 'AuditStatFlag' and isinuse='1'");
   	doTemp.setDDDWSql("ManageStatFlag","select ItemNo,ItemName from code_library where codeno = 'ManageStatFlag'");
   	
   	
    doTemp.generateFilters(Sqlca);
    doTemp.setFilter(Sqlca,"1","AccountMonth","");
    doTemp.setFilter(Sqlca,"2","LoanAccount","");
    doTemp.setFilter(Sqlca,"3","CustomerOrgCode","");
    doTemp.setFilter(Sqlca,"4","CustomerName","");
    doTemp.setFilter(Sqlca,"5","Region","");
    doTemp.setFilter(Sqlca,"6","IndustryType","");    
    doTemp.setFilter(Sqlca,"7","Scope","");        
    doTemp.setFilter(Sqlca,"8","RMBBalance","");
    doTemp.setFilter(Sqlca,"9","LoanType",""); 
    doTemp.setFilter(Sqlca,"10","MFiveClassify","Operators=EqualsString;");
    doTemp.setFilter(Sqlca,"11","AuditStatFlag","Operators=EqualsString;");    
    doTemp.setFilter(Sqlca,"12","ManageOrgID","");
    //doTemp.setFilter(Sqlca,"12","ManageOrgID","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()){
	//	doTemp.WhereClause += " and AccountMonth In (Select max(AccountMonth) from Reserve_Total )";
	//}
	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//设置在datawindows中显示的行数
	dwTemp.setPageSize(25); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "1"; 
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("LoanAccount");
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
//			{"true","","Button","修改","修改","update()",sResourcesPath},
			{"true","","Button","查看详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","导出Excel","导出Excel","exportAll()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=修改;InputParam=无;OutPutParam=无;]~
	function update()
	{
		var sIsManageUser = false;
		var sManageUserID = getItemValue(0,getRow(),"Manageuserid");
		if(sManageUserID == "<%=CurUser.UserID%>")
		{
			sIsManageUser = true;
		}
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataEntInfo","/BusinessManage/ReserveDataPrepare/ReserveDataEntInfo.jsp","LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth+"&IsUpdate=true&IsManageUser="+sIsManageUser,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	*/
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sIsManageUser = false;
		var sManageUserID = getItemValue(0,getRow(),"Manageuserid");
		if(sManageUserID == "<%=CurUser.UserID%>")
		{
			sIsManageUser = true;
		}
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataEntInfo","/BusinessManage/ReserveDataPrepare/ReserveDataEntInfo.jsp","LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth+"&IsManageUser="+sIsManageUser,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
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
		
		}else if(sFilterID=="6"){
			//弹出模态窗口选择框，并将返回值赋给sReturn
			sReturn = selectObjectInfo("Code","CodeNo=IndustryType^请选择行业类型^length(ItemNo)=1","");
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
		}else if(sFilterID=="5"){
			//弹出模态窗口选择框，并将返回值赋给sReturn
			sReturn = selectObjectInfo("Code","CodeNo=AreaCode^请选择客户所在地^IsInUse=1","");
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
		}else if(sFilterID=="9"){
			//弹出模态窗口选择框，并将返回值赋给sReturn
			sReturn = selectObjectInfo("Code","CodeNo=IndustryType^请选择行业类型^length(ItemNo)=1","");
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
		}else if(sFilterID=="12"){
			//弹出模态窗口选择框，并将返回值赋给sReturn
			sReturn = selectObjectInfo("Code","CodeNo=OrgInfo^请选择管户机构^","");
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
		}else if(sFilterID="7"){
			//弹出模态窗口选择框，并将返回值赋给sReturn
			sReturn = selectObjectInfo("Code","CodeNo=Scope^请选择企业规模^","");
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
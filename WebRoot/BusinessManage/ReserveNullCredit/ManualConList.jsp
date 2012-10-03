<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.08      
		Tester:	
		Content: 新会计准则——公司业务
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "公司业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//存放 sql语句
	String sCondition = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Condition"));
	if(sCondition==null) sCondition="";
	String sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	if(sAction==null) sAction="";
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sType==null) sType="";
	String sCondition1 = "";
	String sRightCondi = "";
	String sEqualRightCondi = "";//用于权限条件的参数传递
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//获取关联客户信息表数据	
	String sHeaders[][]={
							{"AccountMonth","会计月份"},
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
	                        {"RMBBalance","余额"},
	                        {"MFiveClassify","五级分类"},
	                        {"MFiveClassifyName","五级分类"},
	                        {"AFiveClassify","审计五级分类"},
	                        {"AFiveClassifyName","审计五级分类"},
	                        {"AuditStatFlag","是否审计"},
	                        {"AuditStatFlagName","是否审计"},
	                        {"ManageStatFlag","计提模式"},
	                        {"ManageStatFlagName","计提模式"},                       
	                        {"Manageuserid","管户人"},
	                        {"ManageuserName","管户人"}
                        };
    sSql = " select AccountMonth,LoanAccount,DuebillNo,CustomerID,CustomerName,PutoutDate,"+
    	   " CustomerOrgCode,getOrgName(CustomerOrgCode) as CustomerOrgCodeName,IndustryType,Scope,"+
    	   " Maturity,RMBBalance,MFiveClassify,getItemName('MFiveClassify',MFiveClassify) as MFiveClassifyName,"+
    	   " AFiveClassify,getItemName('MFiveClassify',AFiveClassify) as AFiveClassifyName,"+
    	   " AuditStatFlag,getItemName('AuditStatFlag',AuditStatFlag) as AuditStatFlagName,ManageStatFlag,getItemName('ManageStatFlag',ManageStatFlag) as ManageStatFlagName,"+
    	   " Manageuserid,getUserName(Manageuserid) as ManageuserName " +
    	   " from Reserve_Total  " +
    	   " where BusinessFlag = '1'";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Total";
    doTemp.setKey("AccountMonth,LoanAccount",true);
    doTemp.setColumnAttribute("AccountMonth,CustomerName,LoanAccount","IsFilter","1");
	//doTemp.setCheckFormat("AccountMonth","6");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//设置在datawindows中显示的行数
	dwTemp.setPageSize(20); //add by hxd in 2005/02/20 for 加快速度
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
			{"true","","Button","减值准备更新","减值准备更新","update_Reserve()",sResourcesPath},
			{"true","","Button","业务详情","业务详情","viewAndEdit()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	
	function update_Reserve(){
		if(confirm("确认要进行减值准备数据更新吗？")){
			sAccountMonth  = getItemValue(0,getRow(),"AccountMonth");
			sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
			alert(sAccountMonth);
			if (typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0){
				alert("请选择要更新的会计月份");//请选择
				return;
			}
			sGrade = PopComp("GradeSelect","/BusinessManage/ReserveManage/GradeSelect.jsp","rand="+randomNumber()," ","dialogWidth=35;dialogHeight=18;center:yes;status:no;statusbar:no");
			if (typeof(sGrade)=="undefined" || sGrade.length==0){
				alert("请选择预测现金流级别");//请选择
				return;
			}
			sReturn = PopComp("PrepareAction","/BusinessManage/ReserveManage/PrepareAction.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&UpdateFlag=2&Grade="+sGrade+"&rand="+randomNumber()," ","dialogWidth=20;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;close:no");			
			if(sReturn == "00"){
				alert("数据更新成功！");
			}
			else{
				alert("数据更新失败！");
			}
			reloadSelf();
		}		
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		if (typeof(sSubjectNo) == "undefined" || sSubjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		
		var sReturn = PopComp("ReserveDataInfo","/BusinessManage/ReserveDataPrepare/ReserveDataInfo.jsp","AccountMonth="+sAccountMonth+"&AssetNo="+sAssetNo,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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
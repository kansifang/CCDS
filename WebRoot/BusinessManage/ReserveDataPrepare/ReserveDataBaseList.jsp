<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.12      
		Tester:	
		Content: 新会计准则——公司业务_减值准备预测
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "减值准备预测"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>

<%
	//定义变量
	String sSql = "";//存放 sql语句

	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sType == null) sType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//获取关联客户信息表数据	
	String sHeaders[][] = {
				 {"SerialNo","序号"},
	             {"AccountMonth","会计月份"},
				 {"LoanAccount","借据号"},
				 {"ObjectNo","借据号"},
				 {"Statorgid","贷款机构代码"},
				 {"StatOrgName","贷款机构名称"},
				 {"CustomerName","客户名称"},
				 {"BusinessSum","贷款金额"},
				 {"Balance","贷款余额"},
				 {"PutoutDate","发放日"},
				 {"MaturityDate","到期日"},
				 {"AuditRate","实际利率（‰）"},
				 {"VouchType","主要担保方式"},
				 {"VouchTypeName","主要担保方式"},
				 {"MClassifyResultName","五级分类"},
				 {"MClassifyResult","五级分类"},
				 {"AClassifyResultName","审计五级分类"},
				 {"AClassifyResult","审计五级分类"},
				 {"Result1","管户员测算结果"},
				 {"Result2","支行预测结果"},
				 {"Result3","分行预测结果"},
				 {"Result4","总行认定结果"},
				 {"MResult","总行最终认定结果"},
				 {"AResult","审计认定结果"}
			};
	String sSql1 = "";
	String sSql2 = "";
	if("Ent".equals(sType))
	{
		 sSql1 = "select  SerialNo, LoanAccount, AccountMonth, getorgname(Statorgid) as StatOrgName, ObjectNo, CustomerName,BusinessSum, Balance," + 
	       		" getItemName('MFiveClassify', MClassifyResult) as MClassifyResultName,MClassifyResult, "+
	       		" getItemName('MFiveClassify', AClassifyResult) as AClassifyResultName,AClassifyResult, "+
	       		" PutoutDate,MaturityDate,getItemName('VouchType', RR.VouchType) as VouchTypeName, "+
	       		" Result1, Result2, Result3, Result4, MResult, AResult " +
	       		" from Reserve_Record RR where RR.BusinessFlag = '1' ";
    	 sSql2 = " union select 'unInput' as SerialNo, RT.LoanAccount as LoanAccount, RT.AccountMonth as AccountMonth, getorgname(RT.Statorgid) as StatOrgName, RT.DuebillNo as ObjectNo, RT.CustomerName as CustomerName, RT.BusinessSum as BusinessSum , RT.Balance as Balance, " + 
                        " getItemName('MFiveClassify', RT.MFiveClassify) as MClassifyResultName, RT.MFiveClassify as MClassifyResult, " +
                        " getItemName('MFiveClassify', RT.AFiveClassify) as AClassifyResultName, RT.AFiveClassify as AClassifyResult, " +
	                    " RT.PutoutDate as PutoutDate,RT.Maturity as MaturityDate,getItemName('VouchType', RT.VouchType) as VouchTypeName , " + 
	                    " '' as Result1, '' as Result2, '' as Result3, '' as Result4, '' as MResult, '' as AResult from Reserve_Total RT " + 
	                    " where not exists (select * from Reserve_Record RR where RR.LoanAccount = RT.LoanAccount and RR.AccountMonth = RT.AccountMonth) "+
	                    " and RT.ManageStatFlag = '2' " + //2-逐笔计提
	                    " and RT.BusinessFlag = '1' " ;
	}else if("Ind".equals(sType))
	{
		 sSql1 = "select  SerialNo, LoanAccount, AccountMonth, getorgname(Statorgid) as StatOrgName, ObjectNo, CustomerName,BusinessSum, Balance," + 
	       		" getItemName('MFiveClassify', MClassifyResult) as MClassifyResultName,MClassifyResult, "+
	       		" getItemName('MFiveClassify', AClassifyResult) as AClassifyResultName,AClassifyResult, "+
	       		" PutoutDate,MaturityDate,getItemName('VouchType', RR.VouchType) as VouchTypeName, "+
	       		" Result1, Result2, Result3, Result4, MResult, AResult " +
	       		" from Reserve_Record RR where RR.BusinessFlag = '2' ";
    	 sSql2 = " union select 'unInput' as SerialNo, RT.LoanAccount as LoanAccount, RT.AccountMonth as AccountMonth, getorgname(RT.Statorgid) as StatOrgName, RT.DuebillNo as ObjectNo, RT.CustomerName as CustomerName, RT.BusinessSum as BusinessSum , RT.Balance as Balance, " + 
                        " getItemName('MFiveClassify', RT.MFiveClassify) as MClassifyResultName, RT.MFiveClassify as MClassifyResult, " +
                        " getItemName('MFiveClassify', RT.AFiveClassify) as AClassifyResultName, RT.AFiveClassify as AClassifyResult, " +
	                    " RT.PutoutDate as PutoutDate,RT.Maturity as MaturityDate,getItemName('VouchType', RT.VouchType) as VouchTypeName , " + 
	                    " '' as Result1, '' as Result2, '' as Result3, '' as Result4, '' as MResult, '' as AResult from Reserve_Total RT " + 
	                    " where not exists (select * from Reserve_Record RR where RR.LoanAccount = RT.LoanAccount and RR.AccountMonth = RT.AccountMonth) "+
	                    " and RT.ManageStatFlag = '2' " + //2-逐笔计提
	                    " and RT.BusinessFlag = '2' " ;
	}
	sSql = sSql1 + sSql2;
	ASDataObject doTemp = new ASDataObject(sSql);
	String sTemp = doTemp.WhereClause;
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Record,Reserve_Total";
    doTemp.setKey("SerialNo,AccountMonth,LoanAccount",true);
    doTemp.setColumnAttribute("AccountMonth,CustomerName,LoanAccount","IsFilter","1");
    //doTemp.setCheckFormat("AccountMonth","6");
    doTemp.setHTMLStyle("LoanAccount","style={width:150px}");
    //add by jjwang 2009.01.07  设置小数位，及数据格式（三位一逗）
	doTemp.setCheckFormat("BusinessSum,Balance,Result1,Result2,Result3,Result4,AResult","2");
	//end by jjwang 2009.01.07
    doTemp.setHTMLStyle("Result1,Result2,Result3,Result4,AResult","style={width:100px}");
    doTemp.setHTMLStyle("AccountMonth,PutoutDate,MaturityDate,MClassifyResultName,AClassifyResultName","style={width:80px}");
	doTemp.setVisible("SerialNo,ObjectNo,MClassifyResult,AClassifyResult,PutoutDate,MaturityDate,VouchTypeName,StatOrgName,MResult",false);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	//产生datawindows
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);	
	if(doTemp.haveReceivedFilterCriteria()){
	        sSql1 += doTemp.WhereClause.substring(sTemp.length());
	        sSql2 += doTemp.WhereClause.substring(sTemp.length());
	        String sSql3= sSql1 +sSql2;
	        doTemp = null;
	        dwTemp = null;
	        doTemp = new ASDataObject(sSql3);
	     	doTemp.setHeader(sHeaders);
			doTemp.UpdateTable="Reserve_Record,Reserve_Total";
			doTemp.setKey("SerialNo,AccountMonth,LoanAccount",true);
			doTemp.setColumnAttribute("AccountMonth,CustomerName,LoanAccount","IsFilter","1");
			doTemp.setCheckFormat("AccountMonth","6");
			doTemp.setHTMLStyle("LoanAccount","style={width:150px}");
			//add by jjwang 2009.01.07  设置小数位，及数据格式（三位一逗）
			doTemp.setCheckFormat("BusinessSum,Balance,Result1,Result2,Result3,Result4,AResult","2");
			//end by jjwang 2009.01.07
			doTemp.setHTMLStyle("Result1,Result2,Result3,Result4,AResult","style={width:100px}");
			doTemp.setHTMLStyle("AccountMonth,PutoutDate,MaturityDate,MClassifyResultName,AClassifyResultName","style={width:80px}");
			doTemp.setVisible("SerialNo,ObjectNo,MClassifyResult,AClassifyResult,PutoutDate,MaturityDate,VouchTypeName,StatOrgName,MResult",false);
			doTemp.generateFilters(Sqlca);
			doTemp.parseFilterData(request,iPostChange);
			doTemp.multiSelectionEnabled = false;
			CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
			dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	}

	//设置在datawindows中显示的行数
	dwTemp.setPageSize(20); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "1";  
	//out.println(doTemp.SourceSql);
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
			{"true","","Button","业务详情","业务详情","viewAndEdit()",sResourcesPath},
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
	
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataEntInfo","/BusinessManage/ReserveDataPrepare/ReserveDataEntInfo.jsp","LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
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
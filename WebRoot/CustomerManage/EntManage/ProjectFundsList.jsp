<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29
		Tester:
		Describe:  项目资金来源
		Input Param:
			ProjectNo：当前项目编号
		Output Param:
			ProjectNo：当前项目编号
			

		HistoryLog:
					2005.7.28	hxli   界面改写
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "项目资金来源"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数	 
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	//获得组件参数	
	String sProjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = { {"ProjectNo","项目编号"},
							{"FundSourceName","资金来源方式"},
							{"INVESTORNAME","资金来源机构名称"},
							{"Currency","币种"},
							{"InvestSum","金额"},
							//{"InvestRatio","投资占比(%)"},
							{"OrgName","登记机构"},
						    {"UserName","登记人"}
						};   		   		
	
	String sSql =	"  select ProjectNo,SerialNo,FundSource,"+
					"  getItemName('CapitalsourceStyle',FundSource) as FundSourceName,INVESTORNAME,"+
					"  getItemName('Currency',Currency) as Currency,"+
					"  InvestSum,InvestRatio,"+
					"  InputOrgId,getOrgName(InputOrgId) as OrgName ,"+
					"  InputUserId,getUserName(InputUserId) as UserName" +
					"  from PROJECT_FUNDS "+
					"  where ProjectNo='"+sProjectNo+"'";
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "PROJECT_FUNDS";
	doTemp.setKey("ProjectNo,SerialNo",true);	 //为后面的删除
	doTemp.setAlign("FundSourceName,Currency","2");
	//设置不可见项
	doTemp.setVisible("ProjectNo,SerialNo,InputOrgId,InputUserId,FundSource,InvestRatio",false);	    
	//通常用于外部存储函数得到的字段
	doTemp.setUpdateable("UserName,OrgName,FundSourceName",false);   
	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	doTemp.setHTMLStyle("FundSourceName,InvestSum,InvestRatio"," style={width:80px} ");
	doTemp.setHTMLStyle("Currency"," style={width:60px} ");
	doTemp.setHTMLStyle("FundSourceName"," style={width:180px} ");
	doTemp.setHTMLStyle("OrgName","style={width=250px}");	
	//靠右对齐
	doTemp.setAlign("InvestSum,InvestRatio","3");
	//如果设置数字（小数）型
	doTemp.setType("InvestSum,InvestRatio","Number");//设置数字型，对应设置模版“值类型”
	doTemp.setCheckFormat("InvestSum,InvestRatio","2");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String InvestSum = Sqlca.getString("select Sum(InvestSum) From PROJECT_FUNDS"+doTemp.WhereClause);
	if(InvestSum == null) InvestSum = "";
	String[][] sListSumHeaders = {	{"CurrencyName","币种"},
									{"FundSourceName","资金来源方式"},
									{"InvestSum","金额"},
									{"Currency","币种"},
									{"InvestRatio","投资占比(%)"}
								 };
	String sListSumSql = "Select FundSource,getItemName('CapitalsourceStyle',FundSource) as FundSourceName,"
						+ " Currency,getItemName('Currency',Currency) as CurrencyName,Sum(InvestSum) as InvestSum, "
						+ "Sum(InvestSum)*100"+"/"+DataConvert.toMoney(InvestSum).replaceAll(",","") +" as InvestRatio"
						+ " From PROJECT_FUNDS "
						+ doTemp.WhereClause
						+ " Group By FundSource,Currency";
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);	
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
		{"true","","Button","新增","新增项目资金来源信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看项目资金来源详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除项目资金来源信息","deleteRecord()",sResourcesPath},
		{"true","","Button","汇总","金额汇总","listSum()",sResourcesPath}		
		};
	if("".equals(InvestSum)){
		sButtons[3][0] = "false";
	}	
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
		//资金来源方式录入模态框调用
		sReturnValue = PopPage("/CustomerManage/EntManage/AddFundSrcDialog.jsp?","","resizable=yes;dialogWidth=20;dialogHeight=8;center:yes;status:no;statusbar:no");

		//判断是否返回有效信息
		if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
			OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp?FundSource="+sReturnValue,"_self","");
	}
	

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sProjectNo = getItemValue(0,getRow(),"ProjectNo");		
		if (typeof(sProjectNo)=="undefined" || sProjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}		
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{

		sProjectNo = getItemValue(0,getRow(),"ProjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sFundSource = getItemValue(0,getRow(),"FundSource");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)		
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{       
			OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp?SerialNo="+sSerialNo+"&FundSource="+sFundSource, "_self","");
		}
	}
	/*~[Describe=金额汇总;InputParam=无;OutPutParam=无;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
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

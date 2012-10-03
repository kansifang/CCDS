<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: lpzhang 2010-5-27 
		Tester:
		Describe: 风险分类状态管理
		Input Param:	
			
		Output Param:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "风险分类状态管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量	
	String sSql="";
	String sWhere = "";	

	//获得页面参数
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		
	//显示标题				
	String[][] sHeaders = {		
							{"SerialNo","合同流水号"},              	
							{"CustomerName","客户名称"},              
							{"BusinessTypeName","业务品种名称"},  
							{"LockClassifyResultName","锁定分类结果"}, 
							{"ClassifyResultName","资产风险分类结果"}, 
							{"CurrencyName","币种"},                    
							{"BusinessSum","合同金额"},           	
							{"Balance","合同余额"},  
							{"PutOutDate","合同起始日"}, 
							{"Maturity","合同到期日"}, 
							{"ManageUserName","贷后管理人员"},                  
							{"ManageOrgName","贷后管机构"},                
						 };
	

	sSql =  " select SerialNo,CustomerID,getCustomerType(CustomerID) as CustomerType,getCustomerName(CustomerID) as CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
			" BusinessSum,Balance,BusinessCurrency,getItemName('Currency',BusinessCurrency) as CurrencyName, LockClassifyResult,getItemName('ClassifyResult',LockClassifyResult) as LockClassifyResultName, "+
			" ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName, PutOutDate,Maturity, ManageUserID,ManageOrgID, "+
			" getUserName(ManageUserID) as ManageUserName,getOrgName(ManageOrgID) as ManageOrgName "+
			" from Business_Contract where Balance >0 " +
			" and businesstype is not null " +
			" and businesstype <>'' " +
			" and vouchtype is not null " +
			" and vouchtype <>'' " +
			" and (finishdate is null or finishdate = '') " +
			" and left(BusinessType,1) <>'3'"+
			" and PutOutDate is not null and PutOutDate<>'' ";
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//添加机构项下
	sWhere += OrgCondition.getOrgCondition("ManageOrgID",CurOrg.OrgID,Sqlca); 
	doTemp.WhereClause+=sWhere;
	
	doTemp.UpdateTable="Business_Contract";
	doTemp.setKey("SerialNo",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("CurrencyName","2");
	
	doTemp.setType("BusinessSum,Balance","Number");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("CurrencyName"," style={width:80px} ");
	
	doTemp.setVisible("CustomerID,BusinessCurrency,LockClassifyResult,ManageUserID,ManageOrgID,ClassifyResult,BusinessType,CustomerType",false);
	//设置Filter			
	doTemp.setColumnAttribute("SerialNo","IsFilter","1");
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.setColumnAttribute("ManageUserName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	dwTemp.setPageSize(10);
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{"true","","Button","修改锁定分类结果","修改锁定分类结果","ModifiedLockResult()",sResourcesPath},
			{"true","","Button","取消锁定","取消锁定","Cancel()",sResourcesPath},
			{"true","","Button","查看合同","查看合同详情","contractInfo()",sResourcesPath},
			
		};		
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=修改锁定分类结果;InputParam=无;OutPutParam=无;]~*/
	function ModifiedLockResult()
	{    		
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sReturn = popComp("ModifiedLockResultDialog","/CreditManage/CreditCheck/ModifiedLockResultDialog.jsp","ObjectNo="+sObjectNo+"&CustomerType="+sCustomerType,"dialogWidth=30;dialogHeight=15;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=取消锁定;InputParam=无;OutPutParam=无;]~*/
	function Cancel()
	{    		
		 sObjectNo = getItemValue(0,getRow(),"SerialNo");
		 if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)	
		 {
			 alert(getHtmlMessage('1'));//请选择一条信息！
			 return;
		 }
		 alert(sObjectNo);
		 sReturn = RunMethod("五级分类","取消锁定资产风险分类",sObjectNo);
		 if (typeof(sObjectNo) != "undefined" && sObjectNo.length != 0)	
		 {
		 	 alert("操作成功！");
			 reloadSelf();
		 }
	    
	}
	
	/*~[Describe=合同详情;InputParam=无;OutPutParam=无;]~*/
	function contractInfo()
	{ 
		//合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //请选择一条信息！
			return;
		}
		
		openObject("AfterLoan",sSerialNo,"002");
	}

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>

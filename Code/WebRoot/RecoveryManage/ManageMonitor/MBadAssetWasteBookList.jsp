<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/09/28
*	Tester:
*	Describe: 不良资产流水信息监控列表
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产流水信息监控列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%
	//定义变量	    
	String sSql = "";
	//定义变量：SQL语句,查询结果集,机构直属、区县标志
	String sSql1 = "";
	ASResultSet rs1 = null;
	String sOrgFlag = "";
	//获得组件参数
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";
	//获得页面参数
			
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义标题
	String sHeaders[][] = {
							{"SerialNo","还款流水号"},
							{"RelativeContractNo","合同流水号"},
							{"BusinessTypeName","业务品种"},
							{"OccurTypeName","发生类型"},
							{"CustomerName","客户名称"},
							{"BusinessCurrencyName","币种"},
							{"BusinessSum","合同金额"},
							{"Balance","当前余额"},
							{"ClassifyResultName","风险分类"},
							{"BadLoanCaliberName","不良贷款口径"},
							{"OccurDate","发生日期"},
							{"TransactionFlag","交易标志"},
							{"OccurDirection","发生方向"},
							{"OccurType","发生类型"},
							{"OccurSubject","发生摘要"},
							{"BusinessDesc","交易描述"},
							{"ActualSum","实际发生额"}
						}; 

 	sSql =  " select BW.SerialNo as SerialNo," + 	
			   " BW.RelativeContractNo as RelativeContractNo,"+
			   " getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			   " getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
			   " BC.CustomerID as CustomerID,BC.CustomerName as CustomerName," + 
			   " getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
			   " BC.BusinessSum as BusinessSum,BC.Balance as Balance,"+
			   " getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
			   " getItemName('BadLoanCaliber',BC.BadLoanCaliber) as BadLoanCaliberName," + 
			   " BW.OccurDate as OccurDate,BW.TransactionFlag as TransactionFlag,"+
			   " BW.OccurDirection as OccurDirection,BW.OccurType as OccurType,"+
			   " BW.OccurSubject as OccurSubject,BC.BusinessType as BusinessType," + 
			   " BW.BusinessDesc as BusinessDesc,BW.ActualSum as ActualSum " + 
		   	" from BUSINESS_WASTEBOOK BW,BUSINESS_CONTRACT BC "+
		   	" where BW.RelativeContractNo=BC.SerialNo and substr(BC.ClassifyResult,1,2)>'02'";
		   
	//根据树图取不同结果集	   
	if(sDealType.equals("020010"))//还款方式补登未补登
	{
		sSql+=" and (BW.ManageFlag1 is  null or BW.ManageFlag1 ='') ";
	}else if(sDealType.equals("020020"))//还款方式补登已补登
	{
		sSql+=" and BW.ManageFlag1 ='010' ";
	}else
	{
		sSql+=" and 1=2";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	//设置隐藏
	doTemp.setVisible("CustomerID,BusinessType,OccurDate,TransactionFlag,OccurDirection,OccurType,OccurSubject,BusinessDesc,ActualSum",false);	
    
	//设置行宽
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("ActualSum,ClassifyResultName"," style={width:95px} ");
	//设置金额为三位一逗数字
	doTemp.setType("ActualSum,BusinessSum,Balance","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("ActualSum,BusinessSum,Balance","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("ActualSum,BusinessSum,Balance","3");
	
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,RelativeContractNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(20); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","客户详情","客户详情","customer_Info()",sResourcesPath},
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		{"true","","Button","补登还款方式","补登还款方式列表","account_Vindicate()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","export_Excel()",sResourcesPath}
		};
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=补登还款方式列表;InputParam=无;OutPutParam=无;]~*/    
	function account_Vindicate()
	{
		//获得还款流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			popComp("WasteBookMendList","/RecoveryManage/NPAManage/NPADailyManage/WasteBookMendList.jsp","ComponentName=补登界面列表&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
	}
	
	/*~[Describe=查看及修改合同详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得合同流水号
		var sContractNo=getItemValue(0,getRow(),"RelativeContractNo");  		
		//获得业务品种
		var sBusinessType=getItemValue(0,getRow(),"BusinessType"); 
		if (typeof(sContractNo)=="undefined" || sContractNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			
			if(sBusinessType=="8010" || sBusinessType=="8020" || sBusinessType=="8030")
			{
				OpenComp("DataInputDetailInfo","/InfoManage/DataInput/DataInputDetailInfo.jsp","ComponentName=列表&ComponentType=MainWindow&SerialNo="+sContractNo+"&Flag=Y&CurItemDescribe3="+sBusinessType+"","_blank",OpenStyle);
			}else
			{
			  sObjectType = "AfterLoan";
				sObjectNo = sContractNo;
				sViewID = "002";
				sCompID = "CreditTab";
				sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
				sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
		}
	}
	
	/*~[Describe=查看客户详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function customer_Info()
	{
		//获得客户编号
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");
		}

	}
	
	/*~[Describe=导出Excel;InputParam=无;OutPutParam=无;]~*/
	function export_Excel()
	{
		amarExport("myiframe0");
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

<%@include file="/IncludeEnd.jsp"%>
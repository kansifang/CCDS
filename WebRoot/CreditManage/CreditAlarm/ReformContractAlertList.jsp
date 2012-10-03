<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/12/08
*	Tester:
*	Describe: 重组贷款合同提示信息列表
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "重组贷款合同信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sOrgFlag = "",sReportType = "";
	//获得组件参数
	String sAlarmType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AlarmType"));
	if(sAlarmType == null) sAlarmType="";
	//获得页面参数
			
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义标题
	String sHeaders[][] = {
							{"SerialNo","合同编号"},
							{"OccurTypeName","发生类型"},
							{"CustomerName","客户名称"},
							{"BusinessTypeName","业务品种"},
							{"VouchTypeName","主要担保方式"},
							{"BusinessCurrencyName","币种"},
							{"BusinessSum","合同金额"},
							{"Balance","合同余额"},
							{"PutOutDate","起始日"},
							{"Maturity","到期日"}
							
						}; 

 	sSql = " select SerialNo," + 	
		   " getItemName('OccurType',OccurType) as OccurTypeName," + 
		   " CustomerID,CustomerName," +
		   " getBusinessName(BusinessType) as BusinessTypeName,"+
		   " getItemName('VouchType',VouchType) as VouchTypeName,"+
		   " getItemName('BusinessCurrency',BusinessCurrency) as BusinessCurrencyName,"+
		   " BusinessSum,Balance,PutOutDate,Maturity "+
		   " from BUSINESS_CONTRACT  "+
		   " where RecoveryUserID='"+CurUser.UserID+"'"+
		   " and RecoveryOrgID ='"+CurOrg.OrgID+"'";
		   
	//根据树图取不同结果集	 
	if(sAlarmType.equals("010130"))//观察期重组贷款监控管理未提交分类认定
	{
		sSql+=" and days(replace(PutOutDate,'/','-'))<=days(current date)-180 and "+
			" (ClassifyResult is null or ClassifyResult='') and OccurType='030' "+
			" and (FinishDate is  null or FinishDate ='') ";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("CustomerID",false);
	//doTemp.setKeyFilter("SerialNo");		
    
	//设置行宽
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,Balance","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setAlign("OccurTypeName","2");
	
	//生成查询框
	//doTemp.setColumnAttribute("CustomerName,SerialNo","IsFilter","1");
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
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		{"false","","Button","导出EXCEL","导出EXCEL","export_Excel()",sResourcesPath}
		};
	
	
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script language=javascript>

	//---------------------定义按钮事件------------------------------------
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
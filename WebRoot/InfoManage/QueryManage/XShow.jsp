<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.xquery.*,org.w3c.dom.*"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Content: 对查询条件进行处理，并且显示数据窗口
		Input Param:
	           --StatResult:结果类型
	                        1--汇总查询
	                        2--明细查询
	           --querySql：  查询语句
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "查询结果显示"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String argumentString="";//--合计字段的列
	String sumString2="";//--各个计算列
	String sumString1="";//--汇总列
	String argumentValue="100";//--汇总参数的值

	//获得组件参数	，传入要执行的sql语句、表头、查询类型
	String querySql   =DataConvert.toRealString(iPostChange,(String)session.getAttribute("querySql"));
	String[][] header = (String[][])session.getAttribute("header");
	String sStatResult = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("StatResult")).trim();
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sNumberString="",sSumString="",sUnVisibleString=""; 
	XQuery xQuery = (XQuery)session.getAttribute("XQuery");
	Vector vColumn=xQuery.getAllColumnsList();
	for(int ii=0;ii<vColumn.size();ii++){
		String[] sColumn=(String[])vColumn.get(ii);
		if(sColumn[6].equals("NUMBER")||sColumn[6].equals("NUMBERSCOPE")){
			sNumberString+=sColumn[3]+",";
		}
		if(sColumn[9].length()>0){
			if(sColumn[4].length()==0)
				sUnVisibleString+=sColumn[3]+",";
			else
				sUnVisibleString+=sColumn[4]+",";
		}
		if(xQuery.availableSummaryColumns.indexOf("."+sColumn[3])>=0){
			sSumString+=sColumn[3]+",";
		}
	}

	if(sNumberString.length()>=2) sNumberString=sNumberString.substring(0,sNumberString.length()-1);
	if(sSumString.length()>=2) sSumString=sSumString.substring(0,sSumString.length()-1);
	if(sUnVisibleString.length()>=2) sUnVisibleString=sUnVisibleString.substring(0,sUnVisibleString.length()-1);
  // out.print(querySql);
	ASDataObject doTemp = new ASDataObject(querySql);
	doTemp.setHeader(header);
	
	if(sStatResult.equals("1")){//汇总查询
		argumentString = (String)session.getAttribute("Arguments");
		sumString2     = (String)session.getAttribute("sumString2");
		sumString1     = (String)session.getAttribute("sumString1");
		argumentValue  = (String)session.getAttribute("argumentValue");
		doTemp.Arguments= argumentString;
		doTemp.setAlign(sumString2,"3");
		doTemp.setColumnType("Sum0,"+sumString1,"2");
		doTemp.setType("Sum0,"+sumString2,"Number");
		doTemp.setCheckFormat(sumString2,"2");
	}
	//设number类型的内容
	if(!sNumberString.equals("")){
		doTemp.setAlign(sNumberString,"3");
		doTemp.setType(sNumberString,"Number");
		doTemp.setCheckFormat(sNumberString,"2");
	}
	doTemp.setColumnType(sSumString,"2");
	doTemp.setCheckFormat("ERate","14");
	doTemp.setVisible(sUnVisibleString,false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.ReadOnly = "1";
	dwTemp.ShowSummary="1";//设置合计列
	dwTemp.setPageSize(40);
	Vector vTemp = dwTemp.genHTMLDataWindow(argumentValue);
	for(int i = 0;i < vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	//out.println(doTemp.SourceSql);
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
			{"false","","Button","查看客户详情","查看客户详情","my_CustomerInfo()",sResourcesPath},
			{"false","","Button","查看业务详情","查看合同的详细信息","my_ContractInfo()",sResourcesPath},
			{"true","","Button","转出至电子表格","转出至电子表格","saveResult()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看客户详情;InputParam=无;OutPutParam=无;]~*/
	function my_CustomerInfo(){
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
		}
		else{
			openObject("Customer",sCustomerID,"002");
		}
	}
   /*~[Describe=查看业务详情;InputParam=无;OutPutParam=无;]~*/
	function my_ContractInfo(){

	}
   /*~[Describe=转出电子表格;InputParam=无;OutPutParam=无;]~*/
	function saveResult(){
		amarExport("myiframe0");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	//init_show();
	my_load(1,0,'myiframe0');
	
	//my_load_show(1,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
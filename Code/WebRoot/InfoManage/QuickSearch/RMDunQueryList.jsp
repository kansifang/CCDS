<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   	FSGong  2004.12.05
		Tester:
		Content:  	催收函快速查询
		Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：催收函快速查询
				ComponentType		组件类型：ListWindow												
			        
		Output param:
		                	
		History Log: 
		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "催收函快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";		
	String sObjectType = "BusinessContract"; //对象类型
	String sComponentName = "";
	
	//获得组件参数	
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = {
							{"SerialNo","催收函流水号"},
							{"ObjectNo","对象编号"},
							{"BCSerialNo","合同流水号"},
							{"Maturity","合同到期日"},
							{"CustomerName","客户名称"},
							{"DunLetterNo","催收函编号"},
							{"DunDate","催收日期"},
							{"ServiceMode","送达方式"},
							{"ServiceModeName","送达方式"},
							{"DunObjectName","催收对象名称"},
							{"OperateUserName","催收人"},
							{"OperateOrgName","催收机构"},
							{"DunCurrency","催收币种"},
							{"DunSum","催收金额"},	
							{"Corpus","本金"},	
							{"InterestInSheet","表内息"},	
							{"InterestOutSheet","表外息"},
							{"ElseFee","其他"}	
					   };  
			       			
	sSql = 	" select di.ObjectNo,di.SerialNo as SerialNo,"+
			" bc.SerialNo as BCSerialNo,"+
			" bc.Maturity as Maturity,"+
			" bc.CustomerName as CustomerName,"+
			" di.DunLetterNo,"+
			" di.DunDate,"+
			" di.ServiceMode as ServiceMode, "+
			" getItemName('DunMode',di.ServiceMode) as ServiceModeName, "+	
			" di.DunObjectName,"+
			" getUserName(di.OperateUserID) as OperateUserName, " +	
			" getOrgName(di.OperateOrgID) as OperateOrgName,"+			
			" getItemName('Currency',di.DunCurrency) as DunCurrency, "+	
			" di.DunSum,"+			
			" di.Corpus,"+			
			" di.InterestInSheet,"+			
			" di.InterestOutSheet,"+
			" di.ElseFee "+			
			" from BUSINESS_CONTRACT bc, DUN_INFO di" +
			" where di.ObjectType='"+sObjectType+"' "+
			" and di.ObjectNo = bc.SerialNo "+
			" order by DunDate desc ";
	       			
   	
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("di.SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "DUN_INFO";
	doTemp.setKey("SerialNo",true);	 
	//设置不可见项
	doTemp.setVisible("SerialNo,ServiceMode,ObjectNo",false);	    
	//设置显示文本框的长度
	doTemp.setHTMLStyle("DunLetterNo"," style={width:70px} ");
	doTemp.setHTMLStyle("DunObjectName"," style={width:100px} ");
	doTemp.setHTMLStyle("DunDate,ServiceModeName,DunDate,Maturity"," style={width:70px} ");
	doTemp.setHTMLStyle("DunCurrency"," style={width:60px} ");
	doTemp.setHTMLStyle("DunSum,Corpus,InterestInSheet,InterestOutSheet,BCSerialNo,OperateUserName,ElseFee"," style={width:80px} ");
	//设置小数显示状态,
	doTemp.setAlign("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","3");
	doTemp.setType("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","2");
	
	
	//生成查询框
	doTemp.setDDDWCode("ServiceMode","DunMode");


	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","DunObjectName","");
	doTemp.setFilter(Sqlca,"2","DunDate","");
	doTemp.setFilter(Sqlca,"3","OperateOrgName","");
	doTemp.setFilter(Sqlca,"4","OperateUserName","");
	doTemp.setFilter(Sqlca,"5","ServiceMode","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"6","BCSerialNo","");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(16);  //服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","业务合同详情","业务合同详情","viewTab()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
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
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			popComp("RMDunQueryInfo","/InfoManage/QuickSearch/RMDunQueryInfo.jsp","SerialNo="+sSerialNo,"","");
		}
	}
   	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
    	
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
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
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	//showFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

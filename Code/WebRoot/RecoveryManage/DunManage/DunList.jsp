<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   	王业罡 2005-08-18
		Tester:
		Content:  	催收函列表
		Input Param:												
				ObjectType	对象类型
				ObjectNo	对象编号        
		Output param:
		                	
		History Log: 
		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "催收函列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%		
	//获得组件参数	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));	
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = {
								{"SerialNo","催收函流水号"},
								{"OverdueDate","逾期时间"},
								{"DunLetterNo","催收函编号"},
								{"DunDate","催收日期"},
								{"DunObjectTypeName","催收对象类型"},
								{"DunObjectName","催收对象名称"},
								{"DunCurrency","催收币种"},
								{"DunSum","催收金额"},	
								{"Corpus","本金"},	
								{"InterestInSheet","表内欠息"},	
								{"InterestOutSheet","表外欠息"},
								{"DunForm","催收形式"},
								{"ServiceMode","送达方式"},
								{"FeedbackValitityName","反馈方式"},
								{"OperateUserName","经办人"},
								{"OperateOrgName","经办机构"},
								{"Signature","债务人签字"}
						   };  
	
	String sSql =  " select SerialNo,"+
					" OverdueDate,DunLetterNo,"+
					" DunDate,"+
					" getItemName('DunObjectType',DunObjectType) as DunObjectTypeName,"+
					" DunObjectName,"+
					" getItemName('Currency',DunCurrency) as DunCurrency, " +	
					" DunSum,"+			
					" Corpus,"+			
					" InterestInSheet,"+			
					" InterestOutSheet,"+
					" getItemName('DunForm',DunForm) as DunForm, " +	
					" getItemName('DunMode',ServiceMode) as ServiceMode, " +	
					" getItemName('DunAcknowledge',FeedbackValitity) as FeedbackValitityName, " +	
					" getUserName(OperateUserID) as OperateUserName,getOrgName(OperateOrgID) as OperateOrgName,"+
					" '' as Signature "+			
					" from DUN_INFO" +
					" where ObjectType='"+sObjectType+"' "+
					" and ObjectNo='"+sObjectNo+"' "+
					" order by DunDate desc ";		       			       

    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "DUN_INFO";
	doTemp.setKey("SerialNo",true);	 
	//设置不可见项
	doTemp.setVisible("SerialNo,DunForm",false);	    
	//设置显示文本框的长度
	doTemp.setHTMLStyle("DunObjectName"," style={width:200px} ");
	doTemp.setHTMLStyle("DunLetterNo,DunDate,DunForm,ServiceMode,DunDate,DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee"," style={width:80px} ");
	//设置小数显示状态,
	doTemp.setAlign("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","3");
	doTemp.setType("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","Number");
	doTemp.setAlign("ServiceMode,DunCurrency","2");
	//小数为2，整数为5
	doTemp.setCheckFormat("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","2");
	
	//指定双击事件
	//生成查询框
	//doTemp.setColumnAttribute("DunObjectName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
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
			{"true","","Button","新增","新增催收函","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除当前催收函","deleteRecord()",sResourcesPath},
			{"false","","Button","打印","打印","my_Print()",sResourcesPath},
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
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/DunManage/DunInfo.jsp?SerialNo="+sSerialNo,"_self","");
		}
	}


	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/	
	function newRecord()
	{
		OpenPage("/RecoveryManage/DunManage/DunInfo.jsp","_self","");
	}	
	
	/*~[Describe=导出Excel;InputParam=无;OutPutParam=无;]~*/
	function export_Excel()
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
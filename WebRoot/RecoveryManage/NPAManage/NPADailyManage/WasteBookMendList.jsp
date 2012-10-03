<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/09/17
		Tester:
		Describe: 还款方式补登列表;
			一笔还款流水对应多笔补登信息
		Input Param:
			ObjectNo：还款流水号
		Output Param:
			SerialNo: 自身流水号类型。

		HistoryLog:
				
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "还款方式补登列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数:还款流水号,树图标识

	//获得组件参数
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sObjectNo == null) sObjectNo = "";
	if(sDealType == null) sDealType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"RelativeWasteBookNo","还款流水号"},
							{"RelativeContractNo","合同流水号"},
							{"CustomerName","客户名称"},
							{"ReturnTypeName","回收方式"},
							{"ReturnSum","回收金额"},
							{"ReturnDate","回收日期"},
							{"InputDate","登记日期"},
						  };

	String sSql =   " select SerialNo,"+
					" RelativeWasteBookNo,RelativeContractNo,"+
					" CustomerID,CustomerName,getItemName('ReturnType',ReturnType) as ReturnTypeName,"+
					" ReturnSum,InputDate "+
					" from BUSINESS_WASTEBOOK_MEND"+
					" where RelativeWasteBookNo='"+sObjectNo+"' ";
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置主键,可更新表
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "BUSINESS_WASTEBOOK_MEND";
	
	//设置不可见项
	doTemp.setVisible("CustomerID,SerialNo,InputDate",false);
	doTemp.setAlign("ReturnSum","3");
	doTemp.setCheckFormat("ReturnSum","2");
	//设置html格式
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	
   //生成过滤器
	doTemp.setColumnAttribute("RelativeContractNo,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
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
		{sDealType.equals("020020010")?"true":"false","","Button","登记还款方式","登记还款方式","newRecord()",sResourcesPath},
		{"true","","Button","还款方式详情","还款方式详情","viewAndEdit()",sResourcesPath},
		{sDealType.equals("020020010")?"true":"false","","Button","取消登记","取消登记","deleteRecord()",sResourcesPath},
		{"true","","Button","返回","返回","go_Back()",sResourcesPath}
    };
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
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/WasteBookMendInfo.jsp?ObjectNo=<%=sObjectNo%>&DealType=<%=sDealType%>","_self","");
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

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/WasteBookMendInfo.jsp?SerialNo="+sSerialNo+"&DealType=<%=sDealType%>&ObjectNo=<%=sObjectNo%>","_self","");
		}
	}
	
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function go_Back()
	{
		self.close();
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

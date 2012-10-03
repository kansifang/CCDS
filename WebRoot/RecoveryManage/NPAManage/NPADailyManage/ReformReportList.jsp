<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/12/08
		Tester:
		Describe: 重组贷款监控报告列表;
			
		Input Param:
			ObjectNo：合同流水号
			DealType:树图节点号
		Output Param:
			SerialNo: 自身流水号类型。
			DealType:树图节点号
		HistoryLog:
				
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "重组贷款监控报告列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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

	//获得页面参数:还款流水号,树图标识,不良类型
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DealType"));
	//将空值转化为字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sDealType == null) sDealType = "";
	//获得组件参数
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"CustomerName","客户名称"},
							{"ObjectNo","合同流水号"},
							{"ReportDate","报告日期"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"}
						  };

	String sSql =   " select SerialNo,ObjectNo,ReportDate,"+
					" CustomerID,CustomerName,FinishDate,"+
					" InputUserID,getUserName(InputUserID) as InputUserName,"+
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName "+
					" from MONITOR_REPORT "+
					" where ObjectNo='"+sObjectNo+"' and ReportType='030' ";
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置主键,可更新表
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "MONITOR_REPORT";
	
	//设置不可见项
	doTemp.setVisible("CustomerID,FinishDate,InputUserID,SerialNo,InputOrgID",false);
	//设置html格式
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	
   //生成过滤器
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
		{"false","","Button","新增","新增","newRecord()",sResourcesPath},
		{"true","","Button","详情","详情","viewAndEdit()",sResourcesPath},
		{"false","","Button","删除","删除","deleteRecord()",sResourcesPath},
		{"true","","Button","返回","返回","go_Back()",sResourcesPath}
    };
	//根据不同树图显示按钮
	if(sDealType.equals("020030050010"))
	{
		sButtons[getBtnIdxByName(sButtons,"新增")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"删除")][0]="true";
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
			//获得申请类型、申请流水号
		sObjectType = "ReformContract";
		sObjectNo = "<%=sObjectNo%>";
		sCompID = "ReformReportCreationInfo";
		sCompURL = "/RecoveryManage/NPAManage/NPADailyManage/ReformReportCreationInfo.jsp";			
		sReturn = popComp(sCompID,sCompURL,"ObjectNo="+sObjectNo+"&DealType=<%=sDealType%>","dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sSerialNo=sReturn[0];
		var sDocID = "13";		
		sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sSerialNo+"&ObjectType="+sObjectType,"","");
		
		if(typeof(sReturn)!='undefined' && sReturn!="")
		{
			sReturnSplit = sReturn.split("?");
			var sFormName=randomNumber().toString();
			sFormName = "AA"+sFormName.substring(2);
			OpenComp("ReformFormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
		}
		reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sFinishDate = getItemValue(0,getRow(),"FinishDate");//完成时间(用于记录是否有效)
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
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sObjectType = "ReformContract";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			var sDocID = "13";		
			sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");	
			if(typeof(sReturn)!='undefined' && sReturn!="")
			{
				sReturnSplit = sReturn.split("?");
				var sFormName=randomNumber().toString();
				sFormName = "AA"+sFormName.substring(2);
				OpenComp("ReformFormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
			}
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

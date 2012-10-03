<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hlzhang 2012-07-17
		Tester:
		Describe: 出账修改列表
		Input Param:
				ObjectType：对象类型（PutOutApply）
				ObjectNo: 对象编号（出账流水号）
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "出账申请修改列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	//获得组件参数：对象类型、对象编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","出账流水号"},
							{"ContractSerialNo","合同流水号"},							
							{"CustomerName","客户名称"},
							{"BusinessType","业务品种"},	
							{"BusinessTypeName","业务品种"},				            
							{"BusinessCurrency","币种"},
							{"Businesssum","金额"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"}
						  };

	sSql =  " select SerialNo,ContractSerialNo, "+
			" CustomerID,CustomerName,"+
			" BusinessType, "+
			" getBusinessName(BusinessType) as BusinessTypeName, "+
			" Businesssum,"+
			" getItemName('Currency',BusinessCurrency) as BusinessCurrency, "+
			" InputUserID,getUserName(InputUserID) as InputUserName, "+
			" InputOrgID,getOrgName(InputOrgID) as InputOrgName "+
			" from BUSINESS_PUTOUT  "+
			//" where exists (select 'X' from DATA_MODIFY DM,FLOW_OBJECT FO where DM.SerialNo=FO.ObjectNo and FO.ObjectType='DataModApply' and FO.PhaseNo='1000' and BUSINESS_PUTOUT.ContractSerialNo=DM.RelativeNo) "+
			" where 1=1 ";
	
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_PUTOUT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("CustomerID,InputUserID,InputOrgID",false);
	//设置格式
	doTemp.setAlign("Businesssum","3");
	//doTemp.setHTMLStyle("BP.CustomerName"," style={width:180px} ");
	doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where IsinUse='1' and ContractDetailNo is not null  order by SortNo");
	doTemp.setVisible("BusinessType",false);
	//生成查询框
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
	doTemp.setFilter(Sqlca,"3","BusinessType","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
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
			{(CurUser.hasRole("0ZZ")?"true":"false"),"","Button","出账详情","出账详情","viewTab()",sResourcesPath},
			{(CurUser.hasRole("0ZZ")?"true":"false"),"","Button","查看出账历史记录","历史出账修改记录信息","HistoryContract()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "PutOutApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenComp("PutOutManageInfo","/SystemManage/SynthesisManage/PutOutManageInfo.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"_blank");
	}
	
	/*~[Describe=使用OpenComp历史合同修改记录信息;InputParam=无;OutPutParam=无;]~*/
	function HistoryContract()
	{
		sObjectType = "PutOutApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{								
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenComp("HistoryPutOutList","/SystemManage/SynthesisManage/HistoryPutOutList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"_blank");	
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_PUTOUT_BAK";//表名
		var sColumnName = "BPBSerialNo";//字段名
		var sPrefix = "BPB";//前缀
       
		//使用GetSerialNo.jsp来抢占一个流水号
		var sBPBSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		//将流水号返回
		return sBPBSerialNo;
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
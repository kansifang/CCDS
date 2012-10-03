<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zwhu 2010/03/29
		Tester:
		Content: 额度项下业务列表
		Input Param:
		Output param:
		History Log:   

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "额度项下业务列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sCustomerID = DataConvert.toRealString(iPostChange,CurComp.getParameter("CustomerID"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectType"));
	String sCreditLineID = DataConvert.toRealString(iPostChange,CurComp.getParameter("ParentLineID"));
	if(sObjectType == null) sObjectType= "";
	if(sCreditLineID == null) sCreditLineID= "";
	if(sCustomerID == null) sCustomerID= "";
	if(sObjectNo == null) sObjectNo = "";	
	//获得页面参数	
	CurComp.setAttribute("IsCreditLine","true");
	String sRightType = (String)CurPage.getAttribute("RightType");
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {	
							{"SerialNo","申请流水号"},
							{"CustomerName","客户名称"},
							{"BusinessTypeName","业务品种"},
							{"Currency","业务币种"},
							{"BusinessSum","合同金额"},
							{"TermMonth","期限（月）"},
							{"InputUserName","申请人"},
							{"InputOrgName","申请机构"},
					};
	sSql = "select SerialNo,CustomerID,CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
		 " BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
		 " BusinessSum,InputUserID,getUserName(InputUserID) as InputUserName, "+
		 " InputOrgID,getOrgName(InputOrgID) as InputOrgName "+
		 " from BUSINESS_APPLY where BAAgreement ='"+sObjectNo+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="BUSINESS_APPLY";
	doTemp.setKey("SerialNo",true);
	doTemp.setHeader(sHeaders);
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("Currency","3");
	doTemp.setVisible("InputUserID,InputOrgID,BusinessCurrency,BusinessType,CustomerID",false);
	doTemp.setFilter(Sqlca,"1","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"2","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
		{"true","","Button","新增","新增","newApply()",sResourcesPath},	
		{"true","","Button","详情","详情","viewTab()",sResourcesPath},	
		{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newApply()
	{
		//将jsp中的变量值转化成js中的变量值
		sObjectNo = "<%=sObjectNo%>";	
		sObjectType = "<%=sObjectType%>";		
		sCustomerID = "<%=sCustomerID%>";
		sCompID = "CreditLineApplyCreation";
		sCompURL = "/CreditManage/CreditLine/CreditLineApplyCreation.jsp";			
		sReturn = popComp(sCompID,sCompURL,"ParentLineID=<%=sCreditLineID%>&ObjectNo="+sObjectNo+"&CustomerID="+sCustomerID+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sObjectNo=sReturn[0];

        //根据新增申请的流水号，打开申请详情界面
        if((<%=CurUser.hasRole("280")%> || <%=CurUser.hasRole("480")%> || <%=CurUser.hasRole("080")%> )&& "<%=sRightType%>" == "All"){
   	        openObject(sObjectType,sObjectNo,"000");
        }else {
        	openObject(sObjectType,sObjectNo,"002");
        } 
		
		reloadSelf();		
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sLineID = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}	
	
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		//获得申请类型、申请流水号
		sObjectType = "<%=sObjectType%>";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
        if((<%=CurUser.hasRole("280")%> || <%=CurUser.hasRole("480")%> || <%=CurUser.hasRole("080")%> )&& "<%=sRightType%>" == "All"){
   	        openObject(sObjectType,sObjectNo,"000");
        }else {
        	openObject(sObjectType,sObjectNo,"002");
        } 
		reloadSelf();
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	setDialogTitle("授信额度项下业务列表");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

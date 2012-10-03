<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/03
		Tester:
		Describe: 授信风险总量列表;
		Input Param:
			--CustomerID：当前客户编号
		Output Param:
			--SerialNo:流水号
			--ObjectNo：当前客户编号
			--ObjectType：对象类型
			--EditRight:权限代码（01：查看权；02：维护权）
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信风险总量列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数	
	
	//获得组件参数	，当前客户代码,对象类型
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sObjectType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sCustomerID == null) sCustomerID = "";
	if(sObjectType == null) sObjectType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = {
							  {"AccountMonth","月份"},
					          {"EvaluateScore","授信风险总量"},
					          {"OrgName","测算单位"},
					          {"UserName","测算客户经理"}						    
			         	};   		   		
	
	String sSql =	" select ObjectType,ObjectNo,SerialNo,AccountMonth, "+
					" EvaluateScore,OrgID,getOrgName(OrgID) as OrgName, "+
					" UserID,getUserName(UserID) as UserName "+
					" from EVALUATE_RECORD " + 
				    " where ObjectType='RiskGross' and ObjectNo='"+ sCustomerID + "' ";	


    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);	 //为后面的删除
	//设置不可见项
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,OrgID,UserID",false);	    
	doTemp.setAlign("RelationName","2");
	doTemp.setType("EvaluateScore","Number");
	doTemp.setCheckFormat("EvaluateScore","2");
	doTemp.setAlign("EvaluateScore","3");
    doTemp.setHTMLStyle("OrgName","style={width:200px}");	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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
		{"true","","Button","新增","新增授信风险总量","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看授信风险总量详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除授信风险总量","deleteRecord()",sResourcesPath},
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
		sObjectType = "RiskGross";
		sObjectNo = "<%=sCustomerID%>";	
		sAccountMonth = "<%=StringFunction.getToday().substring(0,7)%>"
		sReturn = RunMethod("CustomerManage","getRiskGross",sObjectType+","+sObjectNo+","+sAccountMonth);
		if(typeof(sReturn) != "undefined" && sReturn != "") {
			OpenPage("/CustomerManage/EntManage/CustomerRiskGrossInfo.jsp?SerialNo="+sReturn+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&EditRight=02", "_self","");
		}
		else{
			OpenPage("/CustomerManage/EntManage/CustomerRiskGrossInfo.jsp?EditRight=02","_self","");
		}	
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"UserID");//--用户代码
		sCustomerID = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}	
    	}else
        	alert(getHtmlMessage('3'));	
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sUserID=getItemValue(0,getRow(),"UserID");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)		
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{       
			OpenPage("/CustomerManage/EntManage/CustomerRiskGrossInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&EditRight="+sEditRight, "_self","");
		}
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
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

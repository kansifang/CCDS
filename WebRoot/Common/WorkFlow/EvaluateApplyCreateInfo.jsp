<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   bwang
		Tester:
		Content: 信用等级评估新增信息
		Input Param:
		
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信用等级评估新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号、对象编号、客户编号、模型编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sModelType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelType"));
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sCustomerID == null ) sCustomerID="";
	if(sObjectNo == null ) sObjectNo="";
	if (sModelType==null) 
		sModelType = "015"; //缺省模型类型为"个人信用等级评估"

	
	//定义变量：SQL语句
	String sSql = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String[][] sHeaders = {
							{"CustomerType","客户类型"},
							{"CustomerID","客户编号"},
							{"CustomerName","客户名称" } 
						  };
	sSql = 	" select '' as CustomerType,CustomerID,CustomerName from CUSTOMER_INFO where 1=2 ";
			
	//通过SQL产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);	
	//设置标题
	doTemp.setHeader(sHeaders);

	//设置下拉框选择内容
	doTemp.setDDDWSql("CustomerType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='CustomerType' and (ItemNo='03') and IsInUse='1' order by SortNo");	
	//注意,先设HTMLStyle，再设ReadOnly，否则ReadOnly不会变灰
	doTemp.setReadOnly("CustomerType",true);
	//设置弹出框
	doTemp.setUnit("CustomerID","<input type=button value=\"...\" onClick=parent.selectCustomer()>");	
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","下一步","新增授信额度申请的下一步","nextStep()",sResourcesPath},
		{"true","","Button","取消","取消新增授信额度申请","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{			
		sCustomerType = getItemValue(0,0,"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert("请先选择客户类型!");
			return;
		}
		//具有业务申办权的客户信息
		sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+sCustomerType;
		if(sCustomerType == "02")
			setObjectValue("SelectApplyCustomer2",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		else
			setObjectValue("SelectApplyCustomer5",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
	}
	
	/*~[Describe=下一步;InputParam=无;OutPutParam=无;]~*/
	function nextStep()
	{
		sCustomerID = getItemValue(0,0,"CustomerID");
		sCustomerType = getItemValue(0,0,"CustomerType");
		var stmp = CheckRole();
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert("请先选择客户类型!");
			return;
		}
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert("请先选择客户!");
			return;
		}
		//发生方式
		if("true"==stmp)
		{  	
	   		sReturn = PopPage("/Common/Evaluate/AddEvaluateMessage.jsp?Action=display&ObjectType=<%=sObjectType%>&ObjectNo="+sCustomerID+"&ModelType=<%=sModelType%>&EditRight=100","","dialogWidth:550px;dialogHeight:350px;resizable:yes;scrollbars:no");
	   		if(sReturn==null || sReturn=="" || sReturn=="undefined") return;
	   		sReturns = sReturn.split("@");
	   		sObjectType = sReturns[0];
	   		sObjectNo = sReturns[1];
	   		sModelType = sReturns[2];
	   		sModelNo = sReturns[3];
	   		sAccountMonth = sReturns[4];
	   		sReturn=PopPage("/Common/Evaluate/ConsoleEvaluateAction.jsp?Action=add&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ModelType="+sModelType+"&ModelNo="+sModelNo+"&AccountMonth="+sAccountMonth,"","dialogWidth=20;dialogHeight=20;resizable=yes;center:no;status:no;statusbar:no");
	   		if (typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn == "EXIST")
	   		{
	   			alert(getBusinessMessage('189'));//本期信用等级评估记录已存在，请选择其他月份！
	   			return;
	   		}
	   		if(typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn != "failed")
	   		{
	   			var sEditable="true";
				OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID="+sCustomerID+"&ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&SerialNo="+sReturn+"&Editable="+sEditable,"_blank",OpenStyle);
	   		}
	   	    self.close();
   	    }else
	    {
	        alert(getBusinessMessage('190'));//对不起，你没有信用等级评估的权限！
	    }
    }
    /*~[Describe=取消;InputParam=无;OutPutParam=无;]~*/
    function doCancel(){		
			top.close();
		}		
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录			
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");	
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");	
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");		
			setItemValue(0,0,"CustomerType","03");	
		}
		
    }
	function CheckRole()
	{
	    sCustomerID = getItemValue(0,0,"CustomerID");
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
  
        if (typeof(sReturn)=="undefined" || sReturn.length==0){
        	return n;
        }
        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];        //客户主办权
        sReturnValue2 = sReturnValue[1];        //信息查看权
        sReturnValue3 = sReturnValue[2];        //信息维护权
        sReturnValue4 = sReturnValue[3];        //业务申办权

        if(sReturnValue3 =="Y2")
            return "true";
        else
            return "n";
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();	
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化	
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
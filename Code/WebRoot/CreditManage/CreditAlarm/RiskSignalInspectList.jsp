<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei 2006/03/27
		Tester:
		Content: 预警信号检查报告信息_info
		Input Param:
			  ObjectType:对象类型
			  ObjectNo：对象编号   
		Output param:
		       
		History Log: 
		       
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警信号检查报告信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得页面参数	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomeID"));
	String sViewOnly = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("viewOnly"));
	if(sViewOnly == null) sViewOnly = "";
	if(sCustomerID == null) sCustomerID = "";
	String sInspectType = "030010";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%		
    	String sHeaders[][] = {
								{"CustomerName","客户名称"},
								{"ObjectNo","客户编号"},
								{"InspectType","检查类型"},
								{"UpdateDate","报告日期"},
								{"InputUserName","检查人"},
								{"InputOrgName","所属机构"}							
							  };

	  	String sSql =  " select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName,"+
						" getItemName('InspectType',InspectType) as InspectType,"+
			            " UpdateDate,InputUserID,InputOrgID,"+
			            " getUserName(InputUserID) as InputUserName,"+
			            " getOrgName(InputOrgID) as InputOrgName,ReportType"+
						" from INSPECT_INFO"+
						" where ObjectType='CustomerRisk' "+
		                " and InspectType  like '030%' "+
		                " and ObjectNo = '"+sCustomerID+"'";
		if("".equals(sViewOnly)){                
			sSql += " and InputUserID='"+CurUser.UserID+"'";
		}	
	//通过SQL语句产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "INSPECT_INFO";
		//设置关键字
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
 	doTemp.setVisible("SerialNo,InputUserID,InputOrgID,ObjectNo,ObjectType,InspectType,ReportType",false);
	doTemp.setUpdateable("CustomerName,InputUserName,InputOrgName",false);

	doTemp.setHTMLStyle("UpdateDate,InputUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
	doTemp.setHTMLStyle("ObjectNo,CustomerName"," style={width:250px} ");
//	doTemp.setCheckFormat("UpdateDate","3");
	
	doTemp.setColumnAttribute("ObjectNo,CustomerName,UpdateDate","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
	//生成HTMLDataWindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
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
			{"true","","Button","新增","新增报告","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看报告详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除该报告","deleteRecord()",sResourcesPath},
			{"true","","Button","客户基本信息","查看客户基本信息","viewCustomer()",sResourcesPath}
		};
	if("1".equals(sViewOnly)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
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
		sInspectType = "<%=sInspectType%>";
		sCustomerID = "<%=sCustomerID%>";
		if(sInspectType == '030010')
		{
			sSerialNo = PopPage("/CreditManage/CreditAlarm/AddRiskInspectAction.jsp?ObjectNo="+sCustomerID+"&InspectType="+sInspectType,"","");
			sCompID = "InspectTab";
			sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sCustomerID+"&ObjectType=CustomerRisk";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);	
		}
		reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"ObjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
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
		sInspectType = "<%=sInspectType%>";
		sViewOnly = "<%=sViewOnly%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		if(sInspectType == '030010' || sInspectType == '030020')
		{
			sCompID = "InspectTab";
			sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly="+sViewOnly;
			
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
    /*~[Describe=查看客户详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomer()
	{
		var sCustomerID;
		if("<%=sInspectType%>"=="030010" || "<%=sInspectType%>"=="030020")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			openObject("Customer",sCustomerID,"001");
		}
    		
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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jytian 2004-12-02
		Tester:
		Describe:其他负债情况
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			CustomerID：当前客户编号
			SerialNo:	流水号
			EditRight:权限代码（01：查看权；02：维护权）
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "其他负债情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数
	//获得组件参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = 	{
								{"UpToDate","统计截止日期"},		
								{"DEBTTYPE","负债类别"},
								{"DEBTVALUE","负债余额(元)"},
								{"OrgName","登记机构"},
								{"UserName","登记人"},
								{"INPUTDATE","登记日期"},
								{"UPDATEDATE","更新日期"},
							};

	String sSql =	" select CustomerID,SerialNo,UpToDate,getItemName('OtherDebtType',DEBTTYPE) as DEBTTYPE, "+
					" DEBTVALUE,InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID, "+
					" getUserName(InputUserID) as UserName,INPUTDATE,UPDATEDATE" +
					" from IND_ODEBT " +
					" where CustomerID='"+sCustomerID+"' ";


	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新的表
	doTemp.UpdateTable = "IND_ODEBT";
	//设置关键字
	doTemp.setKey("CustomerID,SerialNo",true);
	//设置格式
	doTemp.setVisible("CustomerID,SerialNo,InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setHTMLStyle("OrgName" ,"style={width:200px} ");
	doTemp.setAlign("UpToDate,DEBTTYPE,OrgName,UserName,INPUTDATE,UPDATEDATE","2");
	doTemp.setHTMLStyle("UserName,UpToDate,INPUTDATE,UPDATEDATE"," style={width:80px} ");
	doTemp.setCheckFormat("UPDATEDATE,INPUTDATE","3");
	//设置小数显示状态,
	doTemp.setAlign("DEBTVALUE","3");
	doTemp.setType("DEBTVALUE","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("DEBTVALUE","2");

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
		{"true","","Button","新增","新增其他负债情况","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看其他负债情况","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除其他负债情况","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/IndManage/OtherDebtInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"InputUserID");//--用户代码
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
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
		sUserID=getItemValue(0,getRow(),"InputUserID");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/CustomerManage/IndManage/OtherDebtInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
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

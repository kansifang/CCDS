<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: 共同申请人列表
		Input Param:
			ObjectType: 阶段编号
			SerialNo：业务流水号
		Output Param:
			SerialNo：业务流水号
			CustomerID:客户流水号
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "共同申请人列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//out.println(sObjectType+"@"+sObjectNo);

%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	String sHeaders[][] = 	{
				{"ApplicantID","申请人代码"},		
				{"ApplicantName","申请人名称"},				
				{"RightProp","权益分担比例(%)"},
				{"DebtProp","债务分担比例(%)"},
				{"OrgName","登记机构"},
				{"UserName","登记人"},
			      	};
	
	
			      		
	String sSql =	" select ObjectType,ObjectNo,SerialNo,ApplicantID,ApplicantName,RightProp,DebtProp,InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName " +
			" from BUSINESS_APPLICANT " +
			" where ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' " ;


	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	doTemp.UpdateTable = "BUSINESS_APPLICANT";

	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);

	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	
	//设置小数显示状态,
	doTemp.setAlign("RightProp,DebtProp","3");
	doTemp.setType("RightProp,DebtProp","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("RightProp,DebtProp","2");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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

	String sButtons[][] = 
		{
		{"true","","Button","新增","新增共同申请人","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看共同申请人情况","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除共同申请人情况","deleteRecord()",sResourcesPath},
		{"true","","Button","共同申请人详细信息","查看共同申请人详细信息","viewCustomerInfo()",sResourcesPath},
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
		OpenPage("/CreditManage/CreditApply/SameApplyInfo.jsp","_self","");
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

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/CreditManage/CreditApply/SameApplyInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}

	/*~[Describe=查看担保客户详情详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"ApplicantID");
		//alert(sSerialNo);
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			if (sSerialNo.length == 1)
				alert("客户无详细信息！");
			else
				openObject("Customer",sSerialNo,"002");
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

<%@include file="/IncludeEnd.jsp"%>

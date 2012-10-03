<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/08/27
*	Tester:
*	Describe: 责任认定记录信息列表;
*	Input Param:
*		ObjectType:对象类型															
*		ObjectNo  :合同编号
		EditRight :修改权限
*	Output Param:     
*		ObjectType:对象类型															
*		ObjectNo  :合同编号
*        	SerialNo  :收现流水号
			EditRight :修改权限
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "责任认定记录信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得组件参数
	String sEditRight = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EditRight"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sEditRight == null) sEditRight="";
	if(sObjectType == null) sObjectType="";
	if(sObjectNo == null) sObjectNo="";
	//获得页面参数 修改权利,对象类型,合同编号

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
   	String sHeaders[][] = {
				{"SerialNo","记录号"},       
				{"DutyType","形成不良原因"},          
				{"TraceMode","责任性质"},     
				{"UndertakerName","责任人"},  
				{"BelongOrgName","责任人所在机构"},
				{"CognizeOrgName","责任认定机构"},
				{"InputUserName","登记人"},
				{"InputOrgName","登记机构"},
				{"InputDate","登记日期"}
			       };  

	String sSql = " select  SerialNo,"+
				" getItemName('BadnessReason',DutyType) as DutyType," +
				" getItemName('TraceMode',TraceMode) as TraceMode," +
				" UndertakerName," +
				" BelongOrgName," +
				" CognizeOrgName," +
				" getUserName(InputUserID) as InputUserName," +	
				" getOrgName(InputOrgID) as InputOrgName," +																																																							
				" InputDate " +																																																								
	       			" from DUTY_INFO " +
	       			" where OBJECTTYPE='"+sObjectType+"' AND objectno='"+sObjectNo+"' order by InputDate desc";
                
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "DUTY_INFO";

	doTemp.setType("ReturnSum","Number");
	
	//靠右
	doTemp.setAlign("ReturnSum","3");
	
	//设置共用格式
	doTemp.setVisible("SerialNo",false);
    
	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("ReturnSum","2");
	doTemp.setHTMLStyle("DutyType"," style={width:100px} ");
	doTemp.setHTMLStyle("UndertakerName"," style={width:70px} ");
	doTemp.setHTMLStyle("SerialNo,DutyAttribute,InputUserName,InputDate"," style={width:80px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);  //服务器分页

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

	String sButtons[][] = {
		{(sEditRight.equals("1")?"true":"false"),"","Button","新增","新增责任认定信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看责任认定信息","viewAndEdit()",sResourcesPath},
		{(sEditRight.equals("1")?"true":"false"),"","Button","删除","删除责任认定信息","deleteRecord()",sResourcesPath},
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
		OpenPage("/CreditManage/CreditPutOut/NPADutyInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&EditRight=<%=sEditRight%>","_self","");
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
			OpenPage("/CreditManage/CreditPutOut/NPADutyInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&EditRight=<%=sEditRight%>","_self","");
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

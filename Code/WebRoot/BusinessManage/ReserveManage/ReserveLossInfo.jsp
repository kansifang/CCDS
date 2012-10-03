<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.12
		Tester:
		Content: 公司业务  损失识别
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "损失识别"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量

	//获得组件参数

	//获得页面参数
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	if(sLoanAccount==null) sLoanAccount="";
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));
	if(sCustomerName==null) sCustomerName="";
	String sMClassifyResult = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MClassifyResult"));
	if(sMClassifyResult==null) sMClassifyResult="";
	String sBalance = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Balance"));
	if(sBalance==null) sBalance="";
	String sPutoutDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PutoutDate"));
	if(sPutoutDate==null) sPutoutDate="";
	String sMaturityDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MaturityDate"));
	if(sMaturityDate==null) sMaturityDate="";

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ReserveLossInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "Reserve_Loss";
	//doTemp.setUnit("BeginDate"," <input type=button class=inputDate value=... onclick=parent.selectAccountMonth() > ");
    //doTemp.setUnit("ConfirmDate"," <input type=button class=inputDate value=... onclick=parent.selectAccountMonth() > ");
  	doTemp.setType("Balance","Number");
    doTemp.setHTMLStyle("Describes","style={width:200px;height:100px}overflow:scroll");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sLoanAccount);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//session.setAttribute(dwTemp.Name,dwTemp);
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=损失识别期间（天);InputParam=无;OutPutParam=无;]~*/
	function getTermDay()
	{
	    sBeginDate = getItemValue(0,getRow(),"BeginDate");
	    sConfirmDate = getItemValue(0,getRow(),"ConfirmDate");
	    BeginDate1 = sBeginDate.split("/")
	    BeginDate2 = new Date(BeginDate1[1]+'-'+BeginDate1[2]+'-'+BeginDate1[0]);
	    ConfirmDate1 = sConfirmDate.split("/")
	    ConfirmDate2 = new Date(ConfirmDate1[1]+'-'+ConfirmDate1[2]+'-'+ConfirmDate1[0]);	 
	    iTermDay = parseInt(Math.abs(ConfirmDate2 - BeginDate2)/1000/60/60/24) ;
		setItemValue(0,0,"TermDay",iTermDay);	
	}
	
	function selectAccountMonth()
	{
		
		var sAccountMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=21;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sAccountMonth)!="undefined" && sAccountMonth!="")
		{	
			setItemValue(0,0,"AccountMonth",sAccountMonth);
		}
		else
			setItemValue(0,0,"AccountMonth","");
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}
		else{
			beforeUpdate();
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function goBack()
	{
		self.close();
	}
	/*~[Describe=保存并新增一条记录;InputParam=无;OutPutParam=无;]~*/
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
		
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		
	}
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"Inputuserid","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateOrgid","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputuserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	
			setItemValue(0,0,"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,0,"LoanAccount","<%=sLoanAccount%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"MClassifyResult","<%=sMClassifyResult%>");
			setItemValue(0,0,"Balance","<%=sBalance%>");
			setItemValue(0,0,"PutoutDate","<%=sPutoutDate%>");
			setItemValue(0,0,"MaturityDate","<%=sMaturityDate%>");	
		}	
    }
   
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

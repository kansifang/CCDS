
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2005/08/29
		Tester:
		Content: 授信额度基本信息页面
		Input Param:
			LineID：授信额度编号			
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信额度信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","300");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数

	//获得页面参数	
	String sLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LineID"));
	//将空值转化为空字符串
	if(sLineID == null) sLineID = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String[][] sHeaders = {											
					{"CustomerID","客户编号"},
					{"CustomerName","客户名称"},
					{"LineSum1","额度金额"},
					{"Currency","币种"},	
					{"LineEffDate","生效日"},
					{"BeginDate","起始日"},
					{"EndDate","到期日"},			
					{"PutOutDeadLine","额度使用最迟日期"},				
					{"MaturityDeadLine","额度项下业务最迟到期日期"},				
					{"InputOrgName","登记机构"},
					{"InputUserName","登记人"},
					{"InputTime","登记日期"},
					{"UpdateTime","更新日期"}															
					};
	String sSql = 	" select LineID,CLTypeID,CLTypeName,BCSerialNo,CustomerID,CustomerName, "+
					" Currency,LineSum1,LineEffDate,BeginDate,EndDate,PutOutDeadLine, "+
					" MaturityDeadLine,GetOrgName(InputOrg) as InputOrgName,InputOrg,InputUser, "+
					" GetUserName(InputUser) as InputUserName,InputTime,UpdateTime "+
					" from CL_INFO "+
					" Where LineID = '"+sLineID+"' ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	//设置不可见属性
	doTemp.setVisible("LineID,CLTypeID,CLTypeName,BCSerialNo,InputUser,InputOrg",false);
	//设置不可更新属性
	doTemp.setUpdateable("InputUserName,InputOrgName",false);
	//设置格式
	doTemp.setType("LineSum1","Number");	
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//设置setEvent
		
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
			{"true","","Button","授信额度项下业务","相关授信额度项下业务","lineSubList()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=授信额度项下业务;InputParam=无;OutPutParam=无;]~*/
	function lineSubList()
	{		
		sLineID = getItemValue(0,getRow(),"BCSerialNo");
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","CreditAggreement="+sLineID,"","");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');	
	OpenPage("/CreditManage/CreditLine/SubCreditLineAccountList.jsp?ParentLineID=<%=sLineID%>","DetailFrame","");
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

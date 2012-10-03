<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  pliu 2011-12-02 
		Tester:
		Content: 
		Input Param:
			
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = ""; // 浏览器窗口标题 <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量：SQL语句
	String sSql = "";
	
	//获得组件参数	：对象类型、模型号、类型
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	
	//将空值转化为空字符串	
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerType == null) sCustomerType = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	
	String[][] sHeaders = {
		            {"CustomerID","客户号码"},
		            {"EnterpriseName","客户名称"},
		            {"Scope","更改企业规模"}
			      };
	sSql = 	" select CustomerID,EnterpriseName,Scope "+	
			" from Ent_INFO "+
			" where CustomerID ='"+sCustomerID+"' ";	
	//,getItemName('ClassifyResult',LockClassifyResult) as LockClassifyResultName
	//通过SQL产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);	
	//设置按合同分类的标题

	doTemp.setHeader(sHeaders);
		
	doTemp.UpdateTable = "Ent_Info";
	doTemp.setKey("CustomerID",true);	
	//设置必输项
	doTemp.setRequired("Scope",true);
	//if(sCustomerType.startsWith("03")){
	doTemp.setDDDWSql("Scope","select itemNo,itemName from Code_Library where CodeNo ='Scope' and  itemno in('2','3','4','5') and isinuse ='1' ");
	//}else{
		//doTemp.setDDDWSql("LockClassifyResult","select itemNo,itemName from Code_Library where CodeNo ='ClassifyResult' and  itemno not in('01','02','03','04','05') and isinuse ='1' ");
	//}
	//设置只读属性
	doTemp.setReadOnly("CustomerID",true);
	doTemp.setReadOnly("EnterpriseName",true);
	//设置默认值
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
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
		{"true","","Button","确定","修改企业规模","doSubmit()",sResourcesPath},
		{"true","","Button","取消","取消修改企业规模","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=新增资产风险分类;InputParam=无;OutPutParam=无;]~*/	
	function doSubmit()
	{
	     sScope   = getItemValue(0,getRow(),"Scope");
		 as_save("myiframe0","");
		 if (typeof(sScope )=="undefined" || sScope .length==0)
		 {
			return;
		 }
		 top.returnValue = "_ACCEPT_";
		 top.close();
    }
    
	/*~[Describe=取消新增资产风险分类;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{	
		top.returnValue = "_CANCEL_";
		top.close();

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
	my_load(2,0,'myiframe0');
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
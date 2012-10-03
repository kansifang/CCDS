<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29
		Tester:
		Describe: 纳税信息
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			CustomerID：当前客户编号
			SerialNo：信息流水号
			EditRight：权限代码（01：查看权；02：维护权）
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "纳税信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	//获得页面参数	
	//获得组件参数	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = { 
                            {"CustomerID","客户编号"},
                            {"SerialNo","流水号"},
                            {"UpToDate","账务截至日期"},
                            {"TaxName","税种"},
                            {"TaxPayingDate","纳税日期"},
                            {"BeginDate","区间开始日期"},
                            {"EndDate","区间结束日期"},
                            {"TaxCurrencyName","纳税币种"},
                            {"TaxSum","纳税金额"},
                            {"OrgName","登记机构"},
                            {"UserName","登记人"}
			               };   
			                    		   		
	sSql =	" select CustomerID,SerialNo,UpToDate,getItemName('TaxType',TaxType) as TaxName, " +
			" TaxPayingDate,BeginDate,EndDate,getItemName('Currency',TaxCurrency) as TaxCurrencyName,TaxSum,"+
			" InputOrgId,getOrgName(InputOrgId) as OrgName ,"+
			" InputUserId,getUserName(InputUserId) as UserName" +
			" from CUSTOMER_TAXPAYING " +
			" where CustomerID='"+sCustomerID+"' ";

    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setCheckFormat("BeginDate,EndDate,TaxPayingDate","3");
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新的表
	doTemp.UpdateTable = "CUSTOMER_TAXPAYING";
	//设置关键字
	doTemp.setKey("CustomerID,SerialNo",true);	 //为后面的删除
	//设置不可见项
	doTemp.setVisible("CustomerID,SerialNo,InputOrgId,InputUserId,BeginDate,EndDate",false);	    
	//通常用于外部存储函数得到的字段
	doTemp.setUpdateable("UserName,OrgName,TaxCurrencyName",false);   
	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName" ,"style={width:200px} ");	
	//靠右对齐
	doTemp.setAlign("TaxSum","3");
	doTemp.setAlign("TaxName,TaxCurrencyName,UserName,TaxPayingDate,EndDate,TaxCurrencyName","2");
	//如果设置数字（小数）型
	doTemp.setType("TaxSum","Number");//设置数字型，对应设置模版“值类型”
	doTemp.setCheckFormat("TaxSum","2");
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
		{"true","","Button","新增","新增纳税信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看纳税信息详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除纳税信息","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntTaxInfo.jsp?EditRight=02","_self","");
	}
	

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserId");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}
		}else alert(getHtmlMessage('3'));		
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
    	sUserID=getItemValue(0,getRow(),"InputUserId");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)		
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{       
			OpenPage("/CustomerManage/EntManage/EntTaxInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: bliu 2004-12-03
		Tester:
		Describe: 客户在其他金融机构业务活动;
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			CustomerID：当前客户编号
			SerialNo:	流水号
			EditRight:权限代码（01：查看权；02：维护权）
			
		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	增加过滤器					
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户在其他金融机构业务活动"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sHeaders[][] = {	
							{"SerialNo","流水号"},
							{"OccurOrg","发生行"},
							{"BusinessType","业务类型"},
							{"VouchTypeName","担保方式"},
							{"CurrencyName","币种"},
							{"BusinessSum","授信金额"},
							{"Balance","授信余额"},
							{"ClassifyResult","五级分类"},
							{"BeginDate","授信日期"},
							{"Maturity","到期日"},
							{"OrgName","登记机构"},
							{"UserName","登记人"}
						  };

	String sSql =	" select CustomerID,SerialNo," +
	                " OccurOrg,getItemName('OtherBusinessType',BusinessType) as BusinessType,getItemName('VouchType',VouchType) as VouchTypeName,getItemName('Currency',Currency) as CurrencyName,BusinessSum,Balance," +
					" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,BeginDate,Maturity ,InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName" +
					" from CUSTOMER_OACTIVITY " +
					" where CustomerID='"+sCustomerID+"' ";


	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_OACTIVITY";
	//设置关键字
	doTemp.setKey("CustomerID,SerialNo",true);
	//设置不可见项
	doTemp.setVisible("CustomerID,SerialNo,InputOrgID,InputUserID",false);
	doTemp.setUpdateable("BusinessType,UserName,OrgName",false);
	//设置字段类型
	doTemp.setType("BusinessSum,Balance","Number");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName，BusinessType" ,"style={width:200px} ");	
	doTemp.setAlign("BusinessType,CurrencyName,UserName,OccurOrg","2");
	doTemp.setCheckFormat("Maturity,BeginDate","3");
    doTemp.setHTMLStyle("OrgName，BusinessType","style={width:200px}"); 	
    //生成过滤器
	doTemp.setColumnAttribute("OccurOrg","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);

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
		{"true","","Button","新增","新增在其他金融机构业务活动情况","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看在其他金融机构业务活动情况","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除在其他金融机构业务活动情况","deleteRecord()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/CreditOtherBankInfo.jsp?EditRight=02","_self","");
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
			OpenPage("/CustomerManage/EntManage/CreditOtherBankInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
		}
	}
	
 	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

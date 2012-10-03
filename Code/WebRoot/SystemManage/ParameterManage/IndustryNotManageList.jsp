<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	 /*
		Author: pliu 2011-12-02
		Tester:
		Describe: 企业规模认定调整
		Input Param:
		Output Param:
		HistoryLog:  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "调整企业规模"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量：sql语句
	String sSql = "";			 
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
								{"CustomerID","客户编号"},
								{"EnterpriseName","客户名称"},
								{"CertTypeName","证件类型"},
								{"CertID","证件号码"},
								{"IndustryName","企业规模划分行业分类"},
								{"EmployeeNumber","从业人员(人)"},
								{"SellSum","营业收入(万元)"},
								{"TotalAssets","资产总额(万元)"},
								{"Scope","企业规模"},	
								{"LockEntScale","锁定标识"}
				      		};

    sSql = 	" select EI.CustomerID,EI.EnterpriseName,getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID,getItemName('IndustryName',IndustryName) as IndustryName,EI.EmployeeNumber,EI.SellSum,EI.TotalAssets,getItemName('Scope',EI.scope) as Scope,getItemName('EntScale',EI.LockEntScale) as LockEntScale"+
            " from ENT_INFO EI,CUSTOMER_INFO CI " +
            " where CI.CustomerType like '01%'  and CI.CustomerType<>'0107' " +
            " and CI.CustomerID = EI.CustomerID and lockentscale = '01' ";

    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	//doTemp.UpdateTable = "ENT_INFO";
	//设置主键
	doTemp.setKey("CustomerID",true);	
	
	//置字段是否可更新，主要是外部函数产生的，类似UserName\OrgName	    
	//doTemp.setUpdateable("CertTypeName,CustomerTypeName,UserName",false);
	//设置html格式
	doTemp.setHTMLStyle("CustomerID"," style={width:100px} ");
	doTemp.setHTMLStyle("EnterpriseName"," style={width:200px} ");
		
	//增加过滤器
	doTemp.setColumnAttribute("CustomerID,EnterpriseName,CertID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	//设置在datawindows中显示的行数
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
			{"true","","Button","查看客户详情","查看客户详情","CustomerInfo()",sResourcesPath},
			{"true","","Button","取消企业规模调整","取消锁定","Cancel()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function CustomerInfo()
	{
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			var sReturn = PopPage("/InfoManage/DataInput/CustomerQueryAction.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("要查询的客户信息不存在！");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("要查询的客户类型为空，请选择客户类型！");
			}
			
			////openObject("ReinforceCustomer",sCustomerID,"002");
			openObject("Customer",sCustomerID,"001");
		}
	}		
	function Cancel()
	{
	    sEntSignal = "02";
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		//sReturn =	RunMethod("CustomerManage","CheckLockEntScale",sCustomerID);		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{   
		    //if(confirm(getHtmlMessage('73')))
		    //{	   
			   RunMethod("CustomerManage","RelativeEntScale",sCustomerID+","+sEntSignal);
               reloadSelf();
            //}
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

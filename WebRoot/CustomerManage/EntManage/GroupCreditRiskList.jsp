<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hldu 2012-06-15
		Tester:
		Describe: 集团授信风险限额;     
		HistoryLog:			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "集团授信风险限额"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
     String sSql = "";//--存放sql语句
	//获得页面参数

	//获得组件参数，客户代码
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = { 
		                    {"CustomerID","客户编号"},
		                    {"CustomerName","客户名称"},
		                    {"CreditAuthSum","授信额度限额"},
		                    {"Currency","币种"}, 
		                    //{"CurrencyName","币种"}, 
		                    {"BeganDate","起始日"},
		                    {"EndDate","到期日"},
		                    {"InputOrgID","登记机构"},
		                    {"InputUserID","登记人"},
		                    {"InputDate","登记日期"},						
		                    {"UpdateDate","更新日期"}
						  };

	 sSql =	" select SERIALNO,OBJECTNO as CustomerID,getCustomerName(OBJECTNO) as CustomerName, " +
	        " COGNSCORE as CreditAuthSum,getItemName('Currency',MODELNO) as Currency,FINISHDATE as BeganDate, " +
	        " FINISHDATE2 as EndDate,ORGID as InputOrgID,USERID as InputUserID,FINISHDATE3 as InputDate, " +
	        " FINISHDATE4 as UpdateDate from EVALUATE_RECORD where OBJECTNO = '"+sCustomerID+"' and OBJECTTYPE = 'GroupCreditRisk' ";
    

	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置修改的表
	doTemp.UpdateTable = "EVALUATE_RECORD";
    //设置主键值
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	//设置不可见
	doTemp.setVisible("CustomerID,RelativeID,RelationShip,SERIALNO",false);
	//设置不可修改列
	doTemp.setUpdateable("UserName,OrgName,RelationName",false);
    //设置列类型
	doTemp.setType("InvestmentProp,OughtSum,InvestmentSum","Number");
	//设置列的宽度,
	doTemp.setHTMLStyle("CurrencyTypeName,InvestDate,InvestmentProp"," style={width:80px} ");
    doTemp.setHTMLStyle("OrgName"," style={width:200px} ");  
    doTemp.setHTMLStyle("CustomerName"," style={width:200px} "); 
    doTemp.setHTMLStyle("UserName"," style={width:100px} "); 
    doTemp.setHTMLStyle("EffStatus"," style={width:30px} "); 
	doTemp.setAlign("RelationShipName,CurrencyTypeName,UserName","2");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	//设置setEvent
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

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
			{"true","","Button","新增","新增资本构成","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看资本构成详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除资本构成","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/GroupCreditRiskInfo.jsp?","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--客户代码
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else 
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{      
	    sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/GroupCreditRiskInfo.jsp?SerialNo="+sSerialNo, "_self","");
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

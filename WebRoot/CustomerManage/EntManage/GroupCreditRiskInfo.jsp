<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hldu
		Tester:
		Describe: 集团授信风险限额; 
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "集团授信风险限额"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
    String sSql = "";
    String sRelativeID = "";
    String sEditRight = "";
	//获得组件参数，客户代码
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	String sCustomerName = Sqlca.getString("select getCustomerName('"+sCustomerID+"') from (values 1) as a");
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = { 
		                     {"OBJECTTYPE","GroupCreditRisk"},
                             {"SERIALNO","流水号"},
	                         {"OBJECTNO","客户编号"},
	                         {"CustomerName","客户名称"},
	                         {"CreditAuthSum","授信额度限额"},
	                         {"Currency","币种"},     
	                         {"BeganDate","起始日"},
	                         {"EndDate","到期日"},
	                         {"InputOrgId","登记机构"},
	                         {"InputOrgID","登记机构"},
	                         {"InputUserId","登记人"},
	                         {"InputUserID","登记人"},
	                         {"InputDate","登记日期"},						
	                         {"UpdateDate","更新日期"}
			              };

	sSql =	" select OBJECTTYPE,SERIALNO,OBJECTNO,getCustomerName(OBJECTNO) as CustomerName, " +
		    " COGNSCORE as CreditAuthSum,MODELNO as Currency,FINISHDATE as BeganDate, " +
		    " FINISHDATE2 as EndDate,ORGID as InputOrgID,USERID as InputUserID,FINISHDATE3 as InputDate, " +
		    " FINISHDATE4 as UpdateDate from EVALUATE_RECORD where OBJECTNO = '"+sCustomerID+"' and OBJECTTYPE = 'GroupCreditRisk' and SERIALNO = '"+sSerialNo+"' ";

	//由sSql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头,更新表名,键值,必输项,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.setDefaultValue("OBJECTTYPE,SERIALNO","GroupCreditRisk");
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setKey("OBJECTNO,SERIALNO,SERIALNO",true);
	doTemp.setVisible("OBJECTTYPE,SERIALNO",false);
	doTemp.setUpdateable("CustomerName",false);
	doTemp.setCheckFormat("BeganDate,EndDate","3");
	//doTemp.setUnit("CreditAuthSum","元");
	doTemp.setType("CreditAuthSum","Number");
	doTemp.setRequired("CreditAuthSum,Currency,BeganDate,EndDate",true);
	doTemp.setHTMLStyle("CustomerName"," style={width:80px} ");
	doTemp.setHTMLStyle("InputUserId,InputUserId","style={width:300px}");
	doTemp.setHTMLStyle("CustomerName,Describe,OrgName"," style={width:200px}");
	doTemp.setHTMLStyle("InputOrgID,InputUserID,UpdateDate,InputDate,"," style={width:100px}");	
	doTemp.setReadOnly("OBJECTNO,CustomerName,InputOrgID,InputUserID,InputDate,UpdateDate",true);
	doTemp.setHTMLStyle("OrgName","style={width:400px}");

	//设置下拉框
	doTemp.setDDDWSql("Currency","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'Currency' ");
	//设置默认值
	
	doTemp.setUnit("Describe"," <input type=button class=inputdate value=.. onclick=parent.selectEntCustomer()><font color=red>(可输可选)</font>");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	//依次为:
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
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
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		//录入数据有效性检查		
		
		
		if(bIsInsert){
			//保存前进行检查,检查通过后继续保存,否则给出提示			
		    // if (!RelativeCheck()) return;
			beforeInsert();
			//特殊增加,如果为新增保存,保存后页面刷新一下,防止主键被修改
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();		
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/GroupCreditRiskList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload()
	{
		sSerialNo = getItemValue(0,getRow(),"SERIALNO");//--重新获得流水号
		OpenPage("/CustomerManage/EntManage/GroupCreditRiskInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
	    initSerialNo() ;    
	}

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"OBJECTNO","<%=sCustomerID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserName%>");
		
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			
		}
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{	
	   return true;	
	}
	
    /*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "EVALUATE_RECORD";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "ER";//前缀
       
		//使用GetSerialNo.jsp来抢占一个流水号
		
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
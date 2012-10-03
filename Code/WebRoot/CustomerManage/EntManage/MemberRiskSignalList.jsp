<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: 关联集团(或联保小组)成员授信额度信息列表;
		Input Param:
			CustomerID：当前客户编号
			NoteType：区分 关联集团：Aggregate
            		       联保小组：AssureGroup
            		       信用共同体:CreditGroup
		Output Param:
          	ObjectType: 对象类型。
        	ObjectNo: 对象编号。
        	BackType: 返回方式类型(Blank)


		HistoryLog:
		增加联保小组
		2004-12-14
		jytian
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联集团成员授信额度信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得页面参数	
	
	//获得组件参数	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//将空值转化为空字符串	
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	
	String sHeaders[][] = { 
		                   {"SerialNo","预警流水号"},	
	                       {"CustomerName","客户名称"},					      
	                       {"SignalType","预警类型"},
		                   {"SignalLevel","预警级别"},			
	                       {"SignalStatus","预警状态"},
	                       {"CustomerOpenBalance","敞口金额"},
	                       {"OperateUserName","登记人"},
	                       {"OperateOrgName","登记机构"}
			      		  };   				   		

	sSql =  "select SerialNo,getCustomerName(ObjectNo) as CustomerName,getItemName('SignalType',SignalType) as SignalType,getItemName('SignalLevel',SignalLevel) as SignalLevel,"+
	        " getItemName('SignalStatus',SignalStatus) as SignalStatus,"+
	        " CustomerOpenBalance,getUserName(InputUserID) as OperateUserName,"+
	        " getOrgName(InputOrgID) as OperateOrgName "+
	        " from RISK_SIGNAL where ObjectNo in (select RelativeID from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and RelationShip like '04%'  and length(RelationShip)>2)";

   	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置不可见项 
	//doTemp.setVisible("SerialNo",false);
	doTemp.setAlign("BusinessTypeName,VouchTypeName,Currency","2");	
	//设置格式
	doTemp.setHTMLStyle("BusinessTypeName,CreditTypeName,VouchTypeName,Currency"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName,OperateOrgName"," style={width:200px} ");		
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
		{"true","","Button","预警详情","预警详情","viewAndEdit()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    	
	/*~[Describe=预警详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//根据新增申请的流水号，打开申请详情界面
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=RiskSignalApply&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		
		reloadSelf();
		//   OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp?ObjectNo="+sSerialNo,"_self","");
	}
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2011/06/10
		Tester:
		Describe: 房屋信息列表
		Input Param:
			ObjectType: 阶段编号
			ObjectNo:
			SerialNo：业务流水号
		Output Param:
			SerialNo：业务流水号
			DeleteRelative
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "房屋信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量:关联表
	String sRelativeTable="CONTRACT_RELATIVE";
	//获得页面参数

	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	if(sObjectType.equals("CreditApply")){ 
		sRelativeTable = "Apply_RELATIVE";
	}else{
		sRelativeTable = "CONTRACT_RELATIVE";
	}
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%


	String sHeaders[][] = {	{"HouseContractNo","购房合同协议编号"},
							{"ItemName","购房项目名称"},
							{"BuildArea","建筑面积"},
							{"HousePrice","房屋售价"},
							{"SelfPrice","自筹资金额"},
							{"EvaluateValue","评估价格"},
							{"BudgetValue","建修房预算价值"},
							{"UserName","登记人"},
	                        {"OrgName","登记机构"}
	                       }; 


	String sSql = " select SerialNo,HouseContractNo,"+
				  " ItemName,BuildArea,HousePrice,SelfPrice,EvaluateValue,BudgetValue,"+
				  " getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName "+
				  " from House_INFO HI "+
				  " where exists (Select AR.ObjectNo from "+sRelativeTable+" AR where "+
				" AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='HouseInfo' "+
				" and AR.ObjectNo = HI.SerialNo) ";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "House_INFO";
	doTemp.setKey("SerialNo",true);	 
	//设置不可见项
	doTemp.setVisible("SerialNo",false);
	//设置不可见项
	doTemp.setVisible("InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);
	//doTemp.setHTMLStyle("InterSerialNo,AboutBankID,UserName"," style={width:80px} ");
	doTemp.setType("HousePrice,SelfPrice,EvaluateValue,BudgetValue","number");
	doTemp.setAlign("HousePrice,SelfPrice,EvaluateValue,BudgetValue","3");

	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//设置setEvent	
	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteRelative("+sObjectNo+",HouseInfo,#SerialNo,APPLY_RELATIVE)");

	
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
		{"false","","Button","新增","新增票据信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看票据详情","viewAndEdit()",sResourcesPath},
		{"false","","Button","删除","删除票据信息","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditApply/HouseInfo.jsp","_self","");
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
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			OpenPage("/CreditManage/CreditApply/HouseInfo.jsp?SerialNo="+sSerialNo, "_self","");	
		}
	}

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);
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

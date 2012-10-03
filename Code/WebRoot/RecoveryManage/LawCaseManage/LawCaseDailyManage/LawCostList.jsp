<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: 法律费用台帐列表
		Input Param:
				SerialNo：案件编号				      
		Output param:
				ObjectNo：对象编号
				ObjectType：对象类型
		History Log: zywei 2005/09/06 重检代码
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "法律费用台帐列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
		
	//获得组件参数（案件流水号）	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"ObjectNo","案件编号"},
							{"SerialNo","台帐流水号"},				
							{"OccurDirectionName","费用发生方向"},
							{"OccurPhaseName","费用发生阶段"},
							{"CostTypeName","费用类型"},
							{"Currency","币种"},
							{"CostSum","金额"},							
							{"OccurDate","费用发生日期"},
							{"UserName","登记人"}, 
							{"OrgName","登记机构"},				
							{"InputDate","登记日期"}
						}; 
	
	sSql = " select ObjectNo,SerialNo,ObjectType,OccurDirection, "+
		   " getItemName('OccurDirection1',OccurDirection) as OccurDirectionName, "+
		   " OccurPhase,getItemName('OccurPhase',OccurPhase) as OccurPhaseName,CostType, "+
		   " getItemName('CostType1',CostType) as CostTypeName,getItemName('Currency',Currency) as Currency,CostSum,OccurDate,InputUserID, "+
		   " getUserName(InputUserID) as UserName,InputOrgID,getOrgName(InputOrgID) as OrgName,InputDate " +
		   " from COST_INFO " +
		   " where ObjectType = 'LawcaseInfo' " +	//对象类型
	       " and ObjectNo = '"+sSerialNo+"' "+ //案件编号
	       " order by InputDate desc" ;
	       
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "COST_INFO";	
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,OccurDirection,OccurPhase,CostType,InputOrgID,InputUserID",false);
	
	doTemp.setCheckFormat("CostSum","2");	
	//设置对齐方式
	doTemp.setAlign("CostSum","3");	
	
	//设置选项双击及行宽
	doTemp.setHTMLStyle("OccurDirectionName"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurPhaseName"," style={width:80px} ");
	doTemp.setHTMLStyle("CostTypeName"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurDate"," style={width:80px} ");
	doTemp.setHTMLStyle("UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style = "1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{			
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCostInfo.jsp?ObjectNo=<%=sSerialNo%>&ObjectType=LawcaseInfo&SerialNo=","right",""); 
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得记录流水号、案件编号或对象编号、对象类型
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCostInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"","right","");
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

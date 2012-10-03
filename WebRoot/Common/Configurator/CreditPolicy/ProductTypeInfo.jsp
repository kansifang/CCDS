<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --产品管理详情
			未用到的属性字段暂时隐藏，如果需要请展示出来。
		Input Param:
        	TypeNo：    --类型编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "产品管理详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//-存放sql语句
	String sSortNo = ""; //--排序编号
	
	//获得组件参数	,产品编号
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	if(sTypeNo == null) sTypeNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String[][] sHeaders = {
							{"TypeNo","产品编号"},
							{"SortNo","排序编号"},
							{"TypeName","产品名称"},
							{"IsInUse","是否有效"},
							{"ApplyDetailNo","申请显示模板"},
							{"ApproveDetailNo","最终审批意见显示模板"},
							{"ContractDetailNo","合同显示模板"},
							{"DisplayTemplet","出帐显示模板"},
							{"SubtypeCode","放款通知单"},
							{"InfoSet","信息设置"},							
							{"TypesortNo","是否联机处理"},
							{"Attribute1","对公/对私"},
							{"Attribute2","主业务品种分类"},
							{"Attribute3","是否分期业务"},
							{"Attribute4","新增业务是否出现"},
							{"Attribute5","补登是否出现"},
							{"Attribute6","非补登是否出现"},
							{"Attribute7","定价参数"},
							{"Attribute8","绩效考核参数"},
							{"Attribute9","审批流程"},
							{"Attribute10","允许的币种"},	
							{"Attribute11","必备文档参数"},
							{"Attribute12","缺省高风险点"},
							{"Attribute13","属性13"},
							{"Attribute14","属性14"},
							{"Attribute15","属性15"},
							{"Attribute16","属性16"},
							{"Attribute17","属性17"},
							{"Attribute18","属性18"},
							{"Attribute19","属性19"},
							{"Attribute20","属性20"},
							{"Attribute21","属性21"},
							{"Attribute22","属性22"},
							{"Attribute23","信贷业务种类"},
							{"Attribute24","贷款业务种类"},
							{"Attribute25Name","贷款种类/融资业务种类"},
							{"Remark","备注"},
							{"InputUserName","登记人"},
							{"InputUser","登记人"},
							{"InputOrgName","登记机构"},
							{"InputOrg","登记机构"},
							{"InputTime","登记时间"},
							{"UpdateUserName","更新人"},
							{"UpdateUser","更新人"},
							{"UpdateTime","更新时间"}
		                 };
	sSql =  " select TypeNo,SortNo,TypeName,IsInUse,ApplyDetailNo,ApproveDetailNo, "+
			" ContractDetailNo,DisplayTemplet,SubtypeCode,Attribute9,TypesortNo,InfoSet, "+
			" Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6, "+
			" Attribute7,Attribute8,Attribute10,Attribute11,Attribute12, "+
			" Attribute13,Attribute14,Attribute15,Attribute16,Attribute17,Attribute18, "+
			" Attribute19,Attribute20,Attribute21,Attribute22,Attribute23,Attribute24, "+
			" Attribute25,getItemName('FinancingType',Attribute25) as Attribute25Name, "+
			" Remark,InputUser,getUserName(InputUser) as InputUserName,InputOrg, "+
			" getOrgName(InputOrg) as InputOrgName,InputTime,UpdateUser, "+
			" getUserName(UpdateUser) as UpdateUserName,UpdateTime "+
		    " from BUSINESS_TYPE "+
		    " where TypeNo = '"+sTypeNo+"'";
		    
    //产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置修改表名
	doTemp.UpdateTable = "BUSINESS_TYPE";
	//设置主键
	doTemp.setKey("TypeNo",true);
    //设置必须项
 	doTemp.setRequired("TypeNo,SortNo,TypeName",true);
 	//如果产品编号不为空，则不允许修改
 	if(!sTypeNo.equals(""))
 		doTemp.setReadOnly("TypeNo",true);
    //设置下拉datawindows
	doTemp.setDDDWCode("IsInUse","IsInUse");	
	doTemp.setDDDWCode("Attribute1","EntInd");
	doTemp.setDDDWCode("SubtypeCode","PutOutNotice");
	doTemp.setDDDWCode("TypesortNo,Attribute3,Attribute4,Attribute5,Attribute6","YesNo");	
    doTemp.setDDDWCode("Attribute23","CreditType");
    doTemp.setDDDWCode("Attribute24","LoanType");
    doTemp.setDDDWCode("Attribute2","GeneralBusinessType");
    doTemp.setDDDWSql("Attribute9","select FlowNo,FlowName from FLOW_CATALOG where aaenabled='1' ");
    
    //设置列的宽度
	doTemp.setEditStyle("Remark","3");
	doTemp.setEditStyle("Attribute9","2");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");		
 	doTemp.setLimit("Remark",120);
 	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	//设置只读列
	doTemp.setReadOnly("InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	//设置不可见列
	doTemp.setVisible("TypesortNo,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8,Attribute11,Attribute12",false);
	doTemp.setVisible("Attribute23,Attribute24,Attribute25Name",false);
	doTemp.setVisible("InfoSet,InputUser,InputOrg,UpdateUser",false);
	doTemp.setVisible("Attribute13,Attribute14,Attribute15,Attribute16,Attribute17,Attribute18,Attribute19",false);
	doTemp.setVisible("Attribute20,Attribute21,Attribute22,Attribute25",false);
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);
	//设置不可修改列    	
	doTemp.setUpdateable("Attribute25Name,InputUserName,InputOrgName,UpdateUserName",false);
	doTemp.setUnit("Attribute25Name"," <input type=button class=inputdate value=.. onclick=parent.selectFinancingType()>");
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTypeNo);
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
			{"true","","Button","保存并返回","保存修改并返回","saveRecordAndBack()",sResourcesPath},
			{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    var sCurTypeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		
	    as_save("myiframe0","doReturn('Y');");
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd()
	{
 		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","newRecord()");      
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"TypeNo");
	    parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

    /*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
	        OpenComp("ProductTypeInfo","/Common/Configurator/CreditPolicy/ProductTypeInfo.jsp","","_self","");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	/*~[Describe=弹出贷款种类/融资业务种类选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectFinancingType()
	{
		sParaString = "CodeNo"+",FinancingType";		
		setObjectValue("SelectCode",sParaString,"@Attribute25@0@Attribute25Name@1",0,0,"");
	}
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

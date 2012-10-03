<%@page import="com.amarsoft.are.sql.ASResultSet"%>
<%@page import="com.amarsoft.are.util.DataConvert"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: 该页面主要处理业务相关的申请列表，如授信额度申请列表，额度项下业务申请列表，
			 单笔授信业务申请列表，最终审批意见登记列表、出帐申请列表
	Input Param:
		ApplyType：申请类型
			—CreditLineApply/授信额度申请
			—DependentApply/额度项下申请	
			—IndependentApply/单笔授信业务申请	
			—ApproveApply/待提交复核最终审批意见
			—PutOutApply/待提交审核出帐
		PhaseType：阶段类型
			—1010/待提交阶段（初始阶段）
	Output param:
	History Log: zywei 2005/07/27 重检页面
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = ""; //存放SQL语句
	ASResultSet rs = null; //存放查询结果集
	String sTempletNo = ""; //显示模版ItemNo
	String sPhaseTypeSet = ""; //存放阶段类型组
	String sButton = ""; 
	String sObjectType = ""; //存放对象类型
	String sViewID = ""; //存放查看方式
	String sWhereClause1 = ""; //存放阶段类型强制where子句1
	String sWhereClause2 = ""; //存放阶段类型强制where子句2
	String sInitFlowNo = ""; 
	String sInitPhaseNo = "";
	String sButtonSet = "";
	
	//获得组件参数:申请类型,阶段类型	
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType")); //????
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType")); //????
	//将空值转化成空字符串
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	//根据组件参数(申请类型)从代码表CODE_LIBRARY中获得ApplyMain的树图以及该申请的阶段,流程对象类型,ApplyList使用哪个ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApplyType' and ItemNo = '"+sApplyType+"' ";
	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sPhaseTypeSet = rs.getString("ItemDescribe");
		sObjectType = rs.getString("ItemAttribute");
		sButtonSet = rs.getString("Attribute5");
		//将空值转化成空字符串
		if(sPhaseTypeSet == null) sPhaseTypeSet = "";
		if(sObjectType == null) sObjectType = "";
		if(sButtonSet == null) sButtonSet = "";
	}else{
		throw new Exception("没有找到相应的申请类型定义（CODE_LIBRARY.ApplyType:"+sApplyType+"）！");
	}
	rs.getStatement().close();
	//根据组件ID和组件参数(阶段类型)从代码表CODE_LIBRARY中查询出显示的按钮,以什么视图查看对象详情,where条件1,where条件2,ApplyList数据对象ID
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute1,Attribute2,Attribute4 "+
			" from CODE_LIBRARY where CodeNo = '"+sPhaseTypeSet+"' and ItemNo = '"+sPhaseType+"' ";

	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sButton = rs.getString("ItemDescribe");
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));
		sTempletNo = rs.getString("Attribute4");
		
		//将空值转化成空字符串
		if(sButton == null) sButton = "";
		if(sViewID == null) sViewID = "";
		if(sWhereClause1 == null) sWhereClause1 = "";
		if(sWhereClause2 == null) sWhereClause2 = "";
		if(sTempletNo == null) sTempletNo = "";
	}else{
		throw new Exception("没有找到相应的申请阶段定义（CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"）！");
	}
	rs.getStatement().close();
	
	if(sTempletNo.equals("")) throw new Exception("没有定义sTempletNo, 检查CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"??");
	if(sViewID.equals("")) throw new Exception("没有定义ViewID 检查CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"??");
	
	//根据组件参数(申请类型)从代码表CODE_LIBRARY中获得默认流程ID
	sSql = " select Attribute2 from CODE_LIBRARY where CodeNo = 'ApplyType' and ItemNo = '"+sApplyType+"' ";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sInitFlowNo = rs.getString("Attribute2");
		
		//将空值转化成空字符串
		if(sInitFlowNo == null) sInitFlowNo = "";
	}
	rs.getStatement().close();
	
	//根据默认流程ID从流程表FLOW_CATALOG中获得初始阶段
	sSql = " select InitPhase from FLOW_CATALOG where FlowNo = '"+sInitFlowNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sInitPhaseNo = rs.getString("InitPhase");
		
		//将空值转化成空字符串
		if(sInitPhaseNo == null) sInitPhaseNo = "";
	}
	rs.getStatement().close();


	//通过显示模版产生ASDataObject对象doTemp
	String sTempletFilter = "1=1";
	//根据显示模版编号和显示模版过滤条件生成DataObject对象
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//设置更新表名和主键
	doTemp.UpdateTable = "FLOW_OBJECT";
	doTemp.setKey("ObjectType,ObjectNo",true);	 //为后面的删除
	//将where条件1和where条件2中的变量用实际的值替换，生成有效的SQL语句
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.UserID);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ApplyType",sApplyType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ObjectType",sObjectType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#PhaseType",sPhaseType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#UserID",CurUser.UserID);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ApplyType",sApplyType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ObjectType",sObjectType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#PhaseType",sPhaseType);
	//增加空格防止sql语句拼接出错
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	//设置ASDataObject中的排序条件
	doTemp.OrderClause = " order by FLOW_OBJECT.ObjectNo desc ";

	//生成查询框
	if(sApplyType.equals("BadBizApply")||sApplyType.equals("DebtDisposeApply")){ //不良业务申请时展示
		doTemp.setFilter(Sqlca,"1","SerialNo","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"3","OccurType","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"4","ApplyDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"5","OperateUserName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"6","OperateOrgName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	}else
	{
		doTemp.setFilter(Sqlca,"1","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	}
	if(!sApplyType.equals("CreditCogApply")&&!sApplyType.equals("BadBizApply")&&
			!sApplyType.equals("DebtDisposeApply")&&!sApplyType.equals("RiskSignalApply")&&
			!sApplyType.equals("RiskSignalFApply")){ //信用等级评估申请时不展示
		if(sApplyType.equals("ContractModApply")||sApplyType.equals("DataModApply")){
			doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' and ItemNo <> '015' and IsInUse='1'");
			doTemp.setFilter(Sqlca,"2","OccurType","Operators=EqualsString;");
		}
		else{
			doTemp.setFilter(Sqlca,"2","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}
	}
	//不良资产显示列表字段控制
	if(sApplyType.equals("BadBizApply")){ 
		if(sPhaseType.equals("1030"))//退回补充资料
		{
			doTemp.setVisible("ReturnDate",true);
			doTemp.setFilter(Sqlca,"7","ReturnDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}else if(sPhaseType.equals("1040"))//批准
		{
			doTemp.setVisible("PassDate",true);
			doTemp.setFilter(Sqlca,"7","PassDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}else if(sPhaseType.equals("1050"))//否决
		{
			doTemp.setVisible("VetoDate",true);
			doTemp.setFilter(Sqlca,"7","VetoDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}else if(sPhaseType.equals("1070"))//无法执行
		{
			doTemp.setVisible("PassDate",true);
			doTemp.setFilter(Sqlca,"7","PassDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}else if(sPhaseType.equals("1060"))//归档
		{
			doTemp.setVisible("PigeonholeDate",true);
			doTemp.setFilter(Sqlca,"7","PigeonholeDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}
	}
	
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(10);
	//删除当前的业务信息
	//if(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract"))
	//	dwTemp.setEvent("AfterDelete","!BusinessManage.AddCLInfoLog(#ObjectType,#ObjectNo,Delete,#UserID,#OrgID)+!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	//else
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'"+sApplyType+"','"+sPhaseType+"','"+CurUser.UserID+"'");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//out.println("-------sql"+doTemp.SourceSql); //常用这句话调试datawindow装载数据的SQL语句
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
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	//用于控制单行按钮显示的最大个数
	String iButtonsLineMax = "9";
	//根据按钮集从代码表CODE_LIBRARY中查询到按钮英文名称，属性1，属性2（Button）、按钮中文名称、按钮功能描述、按钮调用javascript函数名称
	sSql = 	" select ItemNo,Attribute1,Attribute2,ItemName,ItemDescribe,RelativeCode "+
			" from CODE_LIBRARY where CodeNo = '"+sButtonSet+"' and IsInUse = '1' Order by SortNo ";
	//out.println(sSql);
	rs = Sqlca.getASResultSet(sSql); 
	while(rs.next()){
		iCountRecord++;
		sButtons[iCountRecord][0] = (sButton.indexOf(rs.getString("ItemNo"))>=0?"true":"false");
		//sButtons[iCountRecord][0] = "true";
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ApplyType",sApplyType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseType",sPhaseType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		}
		sButtons[iCountRecord][6] = sResourcesPath;
		//对于授信额度申请及额度项下业务申请不显示发送公积金审批按钮
		if("CreditLineApply".equals(sApplyType)||"DependentApply".equals(sApplyType))
		{
			if("doneApproveResult".equals(rs.getString("ItemNo")))
			{
				sButtons[iCountRecord][0]="false";	
			}
		}
		//对于授信业务不显示发送个贷
		if("CreditApply".equals(sObjectType))
		{
			if("send".equals(rs.getString("ItemNo")))
			{
				sButtons[iCountRecord][0]="false";
			}
		}
	}
	rs.getStatement().close();
	
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);

	%> 
<%/*~END~*/%>
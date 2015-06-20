<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量：SQL语句、模版ItemNo、阶段类型组、对象对应阶段、阶段类型强制where子句1、阶段类型强制where子句2
	String sSql = "",sTempletNo = "",sTreeMain = "",sViewID = "",sWhereClause1 = "",sWhereClause2 = ""; 
	//定义变量：按钮集、按钮、申请流程对象
	String sButtonSet = "",sButton = "",sObjectType = "";
	//是否强行生成风险评价报告 added bllou 2012-02-21
	boolean bYNRiskReport = false;
	//定义变量：查询结果集
	ASResultSet rs = null; 
	
	//获得组件参数:流程对象类型、申请类型、流程编号、阶段编号、阶段类型、完成标志
	String sApproveType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType")));
	String sFlowNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"))); 
	String sPhaseNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"))); 
	String sPhaseType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"))); 
	String sFinishFlag = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishFlag"))); 
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	//从代码表CODE_LIBRARY中获得ApproveMain的树图以及该申请的阶段,流程对象类型,TaskList使用哪个ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5"+
			" from CODE_LIBRARY "+
			" where CodeNo = 'ApproveType'"+
			" and ItemNo = '"+sApproveType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sTreeMain = DataConvert.toString(rs.getString("ItemDescribe"));
		sObjectType = DataConvert.toString(rs.getString("ItemAttribute"));
		sButtonSet = DataConvert.toString(rs.getString("Attribute5"));		
	}else{
		throw new Exception("没有找到相应的审批类型定义（CODE_LIBRARY.ApproveType:"+sApproveType+"）！");
	}
	rs.getStatement().close();
	//从代码表CODE_LIBRARY中查询出以什么视图查看对象详情,where条件1,where条件2,ApplyList数据对象ID		
	sSql = 	" select ItemAttribute,Attribute1,Attribute2,Attribute4 "+
			" from CODE_LIBRARY"+
			" where CodeNo = '"+sTreeMain+"'"+
			" and ItemNo = '"+sFinishFlag+"'";//N or Y
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){				
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));
		sTempletNo = rs.getString("Attribute4");
	}else{		
		throw new Exception("没有找到相应的审批阶段定义（CODE_LIBRARY,"+sSql+","+sFinishFlag+"）！");
	}
	rs.getStatement().close();
	if(sTempletNo.equals("")) 
		throw new Exception("没有定义任务列表数据对象（CODE_LIBRARY.ApproveType:"+sApproveType+"）！");
	if(sViewID.equals("")) 
		throw new Exception("没有定义审批阶段视图（CODE_LIBRARY,"+sTreeMain+","+sFinishFlag+"）！");
		
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletFilter = "1=1";
	//根据显示模版编号和显示模版过滤条件生成DataObject对象
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//设置更新表名和主键
	doTemp.UpdateTable = "FLOW_TASK";
	doTemp.setKey("SerialNo",true);	 //为后面的删除
	//将where条件1和where条件2中的变量用实际的值替换，生成有效的SQL语句
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.UserID);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#PhaseNo",sPhaseNo);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#FlowNo",sFlowNo);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ObjectType",sObjectType);
	
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#UserID",CurUser.UserID);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#PhaseNo",sPhaseNo);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#FlowNo",sFlowNo);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ObjectType",sObjectType);
	//增加空格防止sql语句拼接出错
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	//设置ASDataObject中的排序条件
	doTemp.OrderClause = " order by FLOW_TASK.SerialNo desc ";
	//生成查询框
	////信用等级评估审批,诉讼申请审批，抵债资产审批，不良资产审批时不展示
	doTemp.generateFilters(Sqlca);
 	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20);
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'','"+sPhaseType+"','"+CurUser.UserID+"'");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow装载数据的SQL语句
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	//根据完成标志来获取相应流程编号、相应阶段编号应显示的功能按钮,Task阶段在流程中配置按钮
	if(sFinishFlag.equals("N")) //当前工作
		sButton = DataConvert.toString(Sqlca.getString("select Attribute1 from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'"));
	if(sFinishFlag.equals("Y")) //已完成工作
		sButton = DataConvert.toString(Sqlca.getString("select Attribute2 from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'"));
	sSql = " select ItemNo,Attribute1,Attribute2,ItemName,ItemDescribe,RelativeCode"+
		" from CODE_LIBRARY"+
		" where CodeNo = '"+sButtonSet+"'"+
		" and locate(ItemNo,'"+sButton+"')>0"+
		" and IsInUse = '1' Order by SortNo ";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){		
		sButtons[iCountRecord][0] ="true";
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) 
			sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ApplyType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseType",sPhaseType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		} 
		sButtons[iCountRecord][6] = sResourcesPath;
		iCountRecord++;
	}
	rs.getStatement().close();
	%> 
<%
	//add by bllou 标记是否必须生产风险调查报告信息 2012-02-21
	if("CreditApply".equalsIgnoreCase(sObjectType) && sButton.indexOf("genRiskReport") >= 0 && (CurUser.hasRole("009") || CurUser.hasRole("209") || CurUser.hasRole("409") )){
		bYNRiskReport = true;
	}
%>
<%/*~END~*/%>

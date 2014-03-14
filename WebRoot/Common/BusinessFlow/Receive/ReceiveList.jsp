<%@page import="java.util.HashMap"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = ""; //存放SQL语句
	ASResultSet rs = null; //存放查询结果集
	String sTempletNo = ""; //显示模版ItemNo
	String sTreeMain = ""; //存放阶段类型组
	String sButton = ""; 
	String sObjectType = ""; //存放对象类型
	String sViewID = ""; //存放查看方式
	String sWhereClause1 = ""; //存放阶段类型强制where子句1
	String sWhereClause2 = ""; //存放阶段类型强制where子句2
	String sFlowNo = ""; 
	String sButtonSet = "";
	
	//获得组件参数:申请类型,阶段类型	
	String sReceiveType =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReceiveType")));
	String sPhaseNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo")));
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	//1、根据组件参数(申请类型)从代码表CODE_LIBRARY中获得
	//ApplyMain的树图 --ItemDescribe
	//该申请的阶段,
	//流程对象类型---ItemAttribute
	//ApplyList使用哪个流程----Attribute2
	//ApplyList使用哪个ButtonSet----Attribute5
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute2,Attribute5"+
			" from CODE_LIBRARY "+
			" where CodeNo = 'ReceiveType'"+
			" and ItemNo = '"+sReceiveType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sTreeMain = DataConvert.toString(rs.getString("ItemDescribe"));
		sObjectType = DataConvert.toString(rs.getString("ItemAttribute"));
		sFlowNo = DataConvert.toString(rs.getString("Attribute2"));
		sButtonSet = DataConvert.toString(rs.getString("Attribute5"));
	}else{
		throw new Exception("没有找到相应的申请类型定义（CODE_LIBRARY.ReceiveType:"+sReceiveType+"）！");
	}
	rs.getStatement().close();
	//2、根据树图及树图项(阶段类型)从代码表CODE_LIBRARY中查询出
	//显示的按钮 -----ItemDescribe
	//以什么视图查看对象详情--ItemAttribute 000是超级权限视图 001是有条件权限，其他无权限
	//where条件1,where条件2--Attribute1,Attribute2
	//显示模板号dono--Attribute4
	//查询字段--Attribute6
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute1,Attribute2,Attribute4"+
			" from CODE_LIBRARY "+
			" where CodeNo = '"+sTreeMain+"'"+
			" and ItemNo = '"+sPhaseNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sButton = DataConvert.toString(rs.getString("ItemDescribe"));
		sViewID = DataConvert.toString(rs.getString("ItemAttribute"));
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));
		sTempletNo = DataConvert.toString(rs.getString("Attribute4"));
	}else{
		throw new Exception("没有找到相应的申请阶段定义（CODE_LIBRARY,"+sTreeMain+","+sPhaseNo+"）！");
	}
	rs.getStatement().close();
	
	if(sTempletNo.equals("")) 
		throw new Exception("没有定义sTempletNo, 检查CODE_LIBRARY,"+sTreeMain+","+sPhaseNo+"??");
	if(sViewID.equals("")) 
		throw new Exception("没有定义ViewID 检查CODE_LIBRARY,"+sTreeMain+","+sPhaseNo+"??");
	//4、显示模板处理
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletFilter = "1=1";
	//根据显示模版编号和显示模版过滤条件生成DataObject对象
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
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
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20);
	//删除当前的业务信息
	dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'"+sReceiveType+"','"+sPhaseNo+"','"+CurUser.UserID+"'");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println("-------sql"+doTemp.SourceSql); //常用这句话调试datawindow装载数据的SQL语句
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//根据按钮集从代码表CODE_LIBRARY中查询到
	//依次为：
	//0.是否显示
	//1.注册目标组件号(为空则自动取当前组件)--属性1，
	//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)--属性2（Button）
	//3.按钮文字 按钮中文名称--ItemName
	//4.按钮功能描述、说明文字--ItemDescribe
	//5.按钮调用javascript函数名称，事件--RelativeCode
	//6.资源图片路径
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	//用于控制单行按钮显示的最大个数
	String iButtonsLineMax = "8";
	sSql = 	" select ItemNo,Attribute1,Attribute2,ItemName,ItemDescribe,RelativeCode"+
			" from CODE_LIBRARY "+
			" where CodeNo = '"+sButtonSet+"'"+
			" and locate(ItemNo,'"+sButton+"')>0"+
			" and IsInUse = '1'"+
			" Order by SortNo ";
	rs = Sqlca.getASResultSet(sSql); 
	while(rs.next()){
		iCountRecord++;
		//按钮是否显示
		sButtons[iCountRecord][0] = "true";
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) 
			sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		//按钮事件
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ReceiveType",sReceiveType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseNo",sPhaseNo);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		}
		sButtons[iCountRecord][6] = sResourcesPath;
	}
	rs.getStatement().close();
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
	%> 
<%/*~END~*/%>

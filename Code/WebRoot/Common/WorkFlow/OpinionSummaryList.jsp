<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: lpzhang 
		Tester:
		Describe: 统计贷审会决议
		Input Param:
			sFlowNo
			sPhaseNo
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "意见汇总"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
	//在信审会秘书签署意见时增加“意见汇总”按钮，点击后显示本次信审会应到人数、实到人数、同意人数、不同意人数、最后决议。
	String sMemberRole ="",sSuperPhaseNo="",sResult="",sMainOpinion="",sSql0="",sPhaseChoice="";// 信审会成员角色,上阶段号，结果
	int iYDNum=0,iSDNum=0,iOkNum=0,iNoNum=0;
	ASResultSet rs = null;
	if(sFlowNo.equals("EntCreditFlowTJ01"))
	{
		if(sPhaseNo.equals("0050"))
			sMemberRole ="424','224";
		if(sPhaseNo.equals("0170"))
			sMemberRole ="214";
		if(sPhaseNo.equals("0300"))
			sMemberRole ="014";
	}
	if(sFlowNo.equals("IndCreditFlowTJ01"))
	{
		if(sPhaseNo.equals("0050"))
			sMemberRole ="424','224";
		if(sPhaseNo.equals("0170"))
			sMemberRole ="214";
		if(sPhaseNo.equals("0300"))
			sMemberRole ="014";
	}
	//应到人数
	iYDNum = Sqlca.getDouble(" select count(*) from USER_INFO UI,USER_ROLE UR "+
			                 " where UI.UserID = UR.UserID and UI.BelongOrg='"+CurOrg.OrgID+"' and UI.UserID <> '"+CurUser.UserID+"'"+
			                 " and UR.Status = '1' and UI.Status = '1' and UR.RoleID in ('"+sMemberRole+"' )").intValue();
	//实到人数
	sSuperPhaseNo = Sqlca.getString(" select PhaseNo from Flow_Task where PhaseNo < '"+sPhaseNo+"'  and  ObjectNo = '"+sObjectNo+"'and "+
			                        " ObjectType ='CreditApply' group by PhaseNo having count(PhaseNo)>1 order by PhaseNo desc fetch first 1 rows only ");
	 
	iSDNum = Sqlca.getDouble(" Select count(*) from Flow_Task where PhaseNo ='"+sSuperPhaseNo+"' "+
			                 " and ObjectType='CreditApply' and ObjectNo ='"+sObjectNo+"' ").intValue();
	iOkNum = Sqlca.getDouble(" select count(*) from Flow_Opinion where SerialNo in (Select SerialNo from Flow_Task where PhaseNo ='"+sSuperPhaseNo+"' "+
           					 " and ObjectType='CreditApply' and ObjectNo ='"+sObjectNo+"' AND (EndTime<>'' or EndTime is not null) ) and PhaseChoice ='01'").intValue();
	iNoNum = Sqlca.getDouble(" select count(*) from Flow_Opinion where SerialNo in (Select SerialNo from Flow_Task where PhaseNo ='"+sSuperPhaseNo+"' "+
          				     " and ObjectType='CreditApply' and ObjectNo ='"+sObjectNo+"' AND (EndTime<>'' or EndTime is not null) ) and PhaseChoice ='02'").intValue();
	//---------主任委员意见---------------
	sSql0 = " select PhaseChoice from Flow_Opinion FO where SerialNo in (Select SerialNo from Flow_Task where PhaseNo ='"+sSuperPhaseNo+"' "+
			" and ObjectType='CreditApply' and ObjectNo ='"+sObjectNo+"' AND (EndTime<>'' or EndTime is not null) ) "+
			" and  exists (select 'X' from User_Role UR where UR.UserID =  FO.InputUser and UR.RoleID in ('016','218'))";
	rs = Sqlca.getASResultSet(sSql0);
	if(rs.next())
	{ 
		sPhaseChoice = DataConvert.toString(rs.getString("PhaseChoice"));
		if(sPhaseChoice == null) sPhaseChoice = "";
	}
	rs.getStatement().close(); 
	
	
	if(iOkNum+iNoNum<iSDNum){
		sResult = "存在成员未提交业务";
	}else if(Double.parseDouble(String.valueOf(iOkNum))/Double.parseDouble(String.valueOf(iSDNum))<2.0/3.0){
		sResult = "不同意";
	}else{
		sResult = "同意";
	}
		
	if(sPhaseChoice.equals("")){
		sMainOpinion="无主任委员意见";
	}else if(sPhaseChoice.equals("02")){
		sMainOpinion="不同意";
		sResult = "不同意";
	}else if(sPhaseChoice.equals("01")){
		sMainOpinion="同意";
	}
	
	String sHeaders[][] = {
							{"iYDNum","应到人数"},
							{"iSDNum","实到人数"},
							{"iOkNum","同意票数"},
							{"iNoNum","不同意票数"},
							{"sMainOpinion","主任委员意见"},
							{"sResult","审议结果"},
												
						  };

	String sqlStr="";
	if("014,214".indexOf(sMemberRole)>-1)
	{
		sqlStr = "'"+sMainOpinion+"' as sMainOpinion,";
	}
	//取得资金关联方客户名称CustomerID列表
	String sSql =  " select "+iYDNum+" as iYDNum,"+iSDNum+" as iSDNum,"+
				   " "+iOkNum+" as iOkNum,"+iNoNum+" as iNoNum,"+sqlStr+
				   " '"+sResult+ "' as sResult "+
				   " from  (values 1) as a ";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10);
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
			{"true","","Button","确认","确认新增","doReturn()",sResourcesPath},
	
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	function doReturn(){
		sResult = getItemValue(0,0,"sResult");
		top.returnValue = sResult;
		top.close();
	}

	
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  bqliu 2011-5-9
		Tester:
		Content: 审批情况一览
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "审批情况一览表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "";//--题头
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"OrgName","机构名称"},
							{"UserName","岗位"},
							{"PhaseName","最终审批人"},
							{"PassApply","批准总笔数"},
							{"VetoApply","否决总笔数"},	
							{"PassApply1","公司一般(批准)"},
							{"VetoApply1","公司一般(否决)"},									
							{"PassApply2","个人一般(批准)"},
							{"VetoApply2","个人一般(否决)"},
							{"PassApply3","公司低风险(批准)"},
							{"VetoApply3","公司低风险(否决)"},
							{"PassApply4","个人低风险(批准)"},
							{"VetoApply4","个人低风险(否决)"},
							}; 					
	sSql =	"select OrgID,getorgName(OrgID) as OrgName,UserName,PhaseName,"+
			"sum(PassApply) as PassApply,Sum(VetoApply) as VetoApply,"+
			"Sum(PassApply1) as PassApply1,Sum(VetoApply1) as VetoApply1,"+
			"Sum(PassApply2) as PassApply2,Sum(VetoApply2) as VetoApply2,"+
			"Sum(PassApply3) as PassApply3,Sum(VetoApply3) as VetoApply3,"+
			"Sum(PassApply4) as PassApply4,Sum(VetoApply4) as VetoApply4 "+
			"from (select FT1.OrgName,FT1.OrgID,FT1.UserName,FT1.PhaseName,FT1.FlowNo,"+
			"case when FT2.PhaseNo='1000' then 1 else 0 end as PassApply,"+
			"case when FT2.PhaseNo='8000' then 1 else 0 end as VetoApply,"+
			"case when FT2.PhaseNo='1000' and FT1.FlowNo='EntCreditFlowTJ01'  then 1 else 0 end as PassApply1,"+
			"case when FT2.PhaseNo='8000' and FT1.FlowNo='EntCreditFlowTJ01'  then 1 else 0 end as VetoApply1,"+
			"case when FT2.PhaseNo='1000' and FT1.FlowNo='IndCreditFlowTJ01'  then 1 else 0 end as PassApply2,"+
			"case when FT2.PhaseNo='8000' and FT1.FlowNo='IndCreditFlowTJ01'  then 1 else 0 end as VetoApply2,"+
			"case when FT2.PhaseNo='1000' and FT1.FlowNo='EntCreditFlowTJ02'  then 1 else 0 end as PassApply3,"+
			"case when FT2.PhaseNo='8000' and FT1.FlowNo='EntCreditFlowTJ02'  then 1 else 0 end as VetoApply3,"+
			"case when FT2.PhaseNo='1000' and FT1.FlowNo='IndCreditFlowTJ02'  then 1 else 0 end as PassApply4,"+
			"case when FT2.PhaseNo='8000' and FT1.FlowNo='IndCreditFlowTJ02'  then 1 else 0 end as VetoApply4"+
			" from FLOW_TASK FT1,FLOW_TASK FT2"+
			" where FT1.SerialNo=FT2.RelativeSerialno and FT1.ObjectType='CreditApply' "+
			"and FT1.PhaseNo<>'0010'  and  FT2.PhaseNo in('8000','1000') )  as a where "+
			"FlowNo in('EntCreditFlowTJ01','EntCreditFlowTJ02','IndCreditFlowTJ01','IndCreditFlowTJ02') "+
			"group by OrgID,UserName,PhaseName ";
		
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    //doTemp.setKeyFilter("SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	//doTemp.setKey("SerialNo",true);	
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("OrgName,UserName","style={width:250px} ");  
	//设置对齐方式
	doTemp.setAlign("BusinessSum","3");	
	//小数为2，整数为5
	doTemp.setCheckFormat("PassApply,VetoApply,PassApply1,VetoApply1,PassApply2,VetoApply2,PassApply3,VetoApply3,PassApply4,VetoApply4","5");	
	//doTemp.setType("PassApply,VetoApply,PassApply1,VetoApply1,PassApply2,VetoApply2,PassApply3,VetoApply3,PassApply4,VetoApply4","Number");
	doTemp.setVisible("OrgID",false);
	//生成查询框
	/*
	doTemp.setFilter(Sqlca,"1","ObjectNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    */
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
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
		
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

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
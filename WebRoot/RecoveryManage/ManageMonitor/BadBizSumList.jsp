<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin1.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2010-06-01
		Tester:
		Describe: 不良贷款汇总监控列表;
		Input Param:
			AccountType：台帐类型
			SumFlag:汇总标识
		Output Param:
			

		HistoryLog:
			DATE	CHANGER		CONTENT	
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良贷款汇总监控列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sAccountType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AccountType"));
	if(sAccountType == null) sAccountType = "";
	String sSumFlag =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SumFlag"));
	if(sSumFlag == null) sSumFlag = "";
	String sSqlWhereClause = CurComp.compParentComponent.getParameter("SqlWhereClause");
	if(sSqlWhereClause==null) sSqlWhereClause=" where 1=2 ";
	String sSqlWhereClause1 = CurComp.compParentComponent.getParameter("SqlWhereClause1");
	if(sSqlWhereClause1==null) sSqlWhereClause1=" where 1=2 ";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	ASDataObject doTemp = null;
	String sHeaders1[][] = {
							{"RecoverUserName","不良资产管理员"},
							{"iCount","笔数"},
						  };

	String sSql1 =   " select RecoverUserID,getUserName(RecoverUserID) as RecoverUserName,"+
					" count(SerialNo) as iCount "+
					" from BADBIZ_ACCOUNT "+
					sSqlWhereClause1+
					" and (BasicManageDate is null or BasicManageDate='' or days(current date)>90+days(replace(BasicManageDate,'/','-'))) "+					
					" and RecoverUserID != '' and RecoverUserID is not null "+
					" and RecoverOrgID in(select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
					" group by RecoverUserID ";
	
	String sHeaders2[][] = {
							{"RecoverUserName","不良资产管理员"},
							{"iCount","笔数"},
		  };

	String sSql2 =   " select RecoverUserID,getUserName(RecoverUserID) as RecoverUserName,"+
					" count(SerialNo) as iCount "+
					" from BADBIZ_ACCOUNT "+
					sSqlWhereClause1+
					" and (((LastDunDate is null or LastDunDate='') and LastMaturity!='' and days(current date)>90+days(replace(LastMaturity,'/','-'))) "+
					" or (LastDunDate is not null and LastDunDate!='' and days(current date)>90+days(replace(LastDunDate,'/','-'))))"+					
					" and RecoverUserID != '' and RecoverUserID is not null "+
					" and RecoverOrgID in(select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
					" group by RecoverUserID ";
	
	String sHeaders3[][] = {
							{"RecoverUserName","不良资产管理员"},
							{"iCount","笔数"},
	};
	
	String sSql3 =   " select RecoverUserID,getUserName(RecoverUserID) as RecoverUserName,"+
					" count(SerialNo) as iCount "+
					" from BADBIZ_ACCOUNT "+
					sSqlWhereClause1+
					" and (((LastDunDate is null or LastDunDate='') and LastMaturity!='' and days(current date)>600+days(replace(LastMaturity,'/','-'))) "+
					" or (LastDunDate is not null and LastDunDate!='' and days(current date)>600+days(replace(LastDunDate,'/','-'))))"+
					" and RecoverUserID != '' and RecoverUserID is  not null "+
					" and RecoverOrgID in(select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
					" group by RecoverUserID ";
	
	String sHeaders4[][] = {
							{"RecoverUserName","不良资产管理员"},
							{"iCount","笔数"},
	};

	String sSql4 =   " select RecoverUserID,getUserName(RecoverUserID) as RecoverUserName,"+
					" count(SerialNo) as iCount "+
					" from BADBIZ_ACCOUNT "+
					sSqlWhereClause1+
					" and VouchMaturity!='' and days(current date)>600+days(replace(VouchMaturity,'/','-')) "+
					" and RecoverUserID != '' and RecoverUserID is  not null "+
					" and RecoverOrgID in(select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
					" group by RecoverUserID ";
	
	String sHeaders5[][] = {
						{"BelongOrgName","机构"},
						{"iCount","笔数"},
	};

	String sSql5 =   " select getOrgName(BelongOrgID) as BelongOrgName,count(SerialNo) as iCount "+
					" from BADBIZ_ACCOUNT "+
					" where BelongOrgID in(select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')"+
					" and StateFlag='01' "+
					" and AccountType='"+sAccountType+"'"+
					" group by BelongOrgID"
					;
	
	String sHeaders6[][] = {
			{"UserName","审查审批人员"},
			{"iCount","笔数"},
	};

	String sSql6 =   " select FT.UserID,getUserName(FT.UserID) as UserName,"+
					" count(FT.serialno) as iCount "+
					" from BADBIZ_APPLY BA, FLOW_TASK FT "+
					" where BA.SerialNo = FT.ObjectNo "+
					" and FT.ObjectType='BadBizApply' "+
					" and PhaseType='1020'"+
					" and (FT.EndTime is null "+
					" or FT.EndTime = '') "+
					" and (FT.PhaseAction is null "+
					" or FT.PhaseAction = '') "+
					" and FT.OrgID in(select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')"+
					" and PhaseNo in('0270','0260','0255','0170','0160','0155','0135','0130','0090','0040','0030','0025','0022','0020')"+
					" group by FT.UserID";
	
	String sHeaders7[][] = {
			{"iCount","笔数"},
	};
	
	String sSql7 =   " select count(SerialNo) as iCount "+
			" from BADBIZ_ACCOUNT "+
			sSqlWhereClause+
			" and (RecoverOrgID = '' or RecoverOrgID is null) ";
	
	String sHeaders8[][] = {
			{"RecoverOrgName","机构"},
			{"iCount","笔数"},
	};
	
	String sSql8 =   " select getOrgName(RecoverOrgID) as RecoverOrgName,count(SerialNo) as iCount "+
			" from BADBIZ_ACCOUNT "+
			sSqlWhereClause1+
			" and RecoverOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')"+
			" and (RecoverUserID = '' or RecoverUserID is null) "+
			" group by RecoverOrgID";
	
	String sHeaders9[][] = {
			{"BelongOrgName","机构"},
			{"iCount","笔数"},
		  };

	String sSql9 =   " select  getOrgName(BelongOrgID) as BelongOrgName,count(SerialNo) as iCount "+
		" from BADBIZ_ACCOUNT "+
		sSqlWhereClause+
		" and ( AccountManageDate is null or AccountManageDate='' or days(current date)>30+days(replace(AccountManageDate,'/','-')))  "+
		" group by BelongOrgID";

	//由SQL语句生成窗体对象。
	if("1".equals(sSumFlag))
	{
		doTemp = new ASDataObject(sSql1);
		doTemp.setHeader(sHeaders1);
	}else if("2".equals(sSumFlag))
	{
		doTemp = new ASDataObject(sSql2);
		doTemp.setHeader(sHeaders2);
	}else if("3".equals(sSumFlag))
	{
		doTemp = new ASDataObject(sSql3);
		doTemp.setHeader(sHeaders3);
	}else if("4".equals(sSumFlag))
	{
		doTemp = new ASDataObject(sSql4);
		doTemp.setHeader(sHeaders4);
	}else if("5".equals(sSumFlag))
	{
		doTemp = new ASDataObject(sSql5);
		doTemp.setHeader(sHeaders5);
	}else if("6".equals(sSumFlag))
	{
		doTemp = new ASDataObject(sSql6);
		doTemp.setHeader(sHeaders6);
	}else if("7".equals(sSumFlag))
	{
		doTemp = new ASDataObject(sSql7);
		doTemp.setHeader(sHeaders7);
	}else if("8".equals(sSumFlag))
	{
		doTemp = new ASDataObject(sSql8);
		doTemp.setHeader(sHeaders8);
	}else
	{
		doTemp = new ASDataObject(sSql9);
		doTemp.setHeader(sHeaders9);
	}
	//设置不可见项
	doTemp.setVisible("RecoverUserID,UserID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSumSum,iCount,BalanceSum","3");
	//设置html格式
	doTemp.setHTMLStyle("iCount"," style={width:50px} ");
	doTemp.setHTMLStyle("BelongOrgName,RecoverOrgName"," style={width:250px} ");
   //生成过滤器
	doTemp.setColumnAttribute("BusinessTypeName,Currency","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//生成datawindow
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
    };
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

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
	hideFilterArea();//默认关闭查询条件 add by zrli
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>

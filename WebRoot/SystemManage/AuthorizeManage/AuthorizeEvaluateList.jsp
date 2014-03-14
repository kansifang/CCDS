<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: ylwang	2009-02-19
			Tester:
			Describe: 	机构授权维护
			Input Param:
			Output Param:
			HistoryLog: 
				 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "机构授权维护"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";
	String OrgCondition ="";
	String sSortNo = "";
	
	//获得页面参数：担保方式、担保信息编号
	
 	//将空值转化为空字符串
 	
 	//取得查询的统计权限
	//默认为当前机构，根据当前机构判断出该机构的权限
	//选择机构以后，根据选择的机构判断出选择寄过的权限
	if(sSortNo == null || sSortNo.equals(""))
	{
		String sSql1 = "select SortNo from ORG_INFO where OrgID = '"+CurOrg.OrgID+"' ";
		sSortNo = Sqlca.getString(sSql1);
	}
	String sSql2 = "select OrgLevel from ORG_INFO where SortNo = '"+sSortNo+"' ";
	String sOrgLevel = Sqlca.getString(sSql2);
	//out.println("sSortNo="+sSortNo);
	if(sOrgLevel == null) sOrgLevel = "";
	if (sOrgLevel.equals("6")) //支行
	{		
		OrgCondition=" and AO.OrgID = '"+sSortNo+"' ";
	} 
	if (sOrgLevel.equals("3")) //分行
	{
		sSortNo= sSortNo.substring(0,6);
		OrgCondition=" and AO.OrgID like '"+sSortNo+"%' ";
	}
	if (sOrgLevel.equals("0")) //总行
	{
		sSortNo= sSortNo.substring(0,3);
		OrgCondition=" and AO.OrgID like '"+sSortNo+"%' ";
	}
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"SerialNo","授权序列号"},
						{"OrgID","授权机构"},
						{"RoleID","人员角色"},
						{"OrgName","授权机构"},
						{"RoleName","人员角色"},
						{"OperateCode1","信用评级运算符"},
						{"OperateCode1Name","信用评级运算符"},
						{"EvaluateLevel","信用评级等级"},
						{"EvaluateLevelName","信用评级等级"},
						{"IsJudgeCredit","是否判断在途授信额度"},
						{"OperateCode2","授信额度运算符"},
						{"OperateCode2Name","授信额度运算符"},
						{"CreditSum","授信额度"},
						{"InputOrgName","录入机构"},
						{"InputUserName","录入人员"},
						{"InputDate","登记日期"},
						{"Remark","备注"},
		   				};		   		
		
		sSql =  " select SerialNo,OrgID,getOrgName(OrgID) as OrgName, "+
		//" getOrgName(AO.OrgID) as OrgName, "+
		//" (select orgname from org_info where sortno = AO.OrgID) as OrgName, "+
		" RoleID,getRoleName(RoleID) as RoleName, "+
		" OperateCode1,getItemName('OperateCode',OperateCode1) as OperateCode1Name, "+
		" EvaluateLevel,getItemName('CreditLevel',EvaluateLevel) as EvaluateLevelName,"+
		" getItemName('YesNo',IsJudgeCredit) as IsJudgeCredit,"+
		" OperateCode2,getItemName('OperateCode',OperateCode2) as OperateCode2Name, "+
		" CreditSum,Remark, "+
		" InputOrgID,InputUserID,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate  "+
		" from EVALUATE_AUTHORIZE where 1=1"+
		//" and AO.OrgID in (select BelongOrgId from ORG_BELONG where OrgID='"+CurOrg.OrgID+"')"+
		//OrgCondition +
		//" order by OrgID,AuthorizeType,AuthorizeName,AuthorizeOrgLevel ";
		" order by OrgID,RoleID ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "EVALUATE_AUTHORIZE";
		doTemp.setKey("OrgID,RoleID,SerialNo",true);
		doTemp.setUpdateable("OrgName,RoleName,OperateCode1Name,OperateCode2Name,EvaluateLevelName",false);
		doTemp.setUpdateable("EvaluateLevel,OperateCode1,CreditSum,OperateCode2",true);
		doTemp.setVisible("EvaluateLevelName,OrgID,RoleID,UserID,OperateCode1Name,OperateCode2Name,InputOrgID,InputUserID,Remark",false);
		doTemp.setReadOnly("",true);
		doTemp.setReadOnly("EvaluateLevel,OperateCode1,CreditSum,OperateCode2",false);
		doTemp.setHTMLStyle("RoleName"," style={width:200} ");
		doTemp.setDDDWSql("OperateCode1,OperateCode2","select ItemNo,ItemName from code_library where codeno='OperateCode' and ItemNo in ('01','02','03')");
		doTemp.setDDDWSql("EvaluateLevel","select ItemNo,ItemName from code_library where codeno='CreditLevel' and isinuse='1' order by 1");
		//增加过滤器	
		doTemp.setDDDWSql("OrgID","select OrgID,OrgName from org_info where OrgID in(select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') order by sortno");
		doTemp.setDDDWSql("RoleID","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeEvaluateRoleID' and isinuse = '1' order by 1");
		//doTemp.setDDDWCode("AuthorizeOrgLevel","AuthorizeOrgLevel");
		//doTemp.setDDDWSql("ObjectNo","select Serialno,AuthorizeName from AUTHORIZE_ROLE order by 1");
		
		//doTemp.setColumnAttribute("OrgID,RoleID,AuthorizeOrgLevel,ObjectNo,AuthorizeName","IsFilter","1");
		doTemp.setColumnAttribute("OrgID,RoleID,SerialNo","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

		if(!doTemp.haveReceivedFilterCriteria())
		 doTemp.WhereClause+=" and 1=2";
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //设置为Grid风格
		dwTemp.setPageSize(211);  //服务器分页
		//dwTemp.ReadOnly = "1"; //设置为只读
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/
%>
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
			{"true","","Button","新增评级授权","新增评级授权","singletonRecord()",sResourcesPath},
			{"true","","Button","修改/查看评级授权","修改/查看评级授权","editRecord()",sResourcesPath},
			{"true","","Button","删除评级授权","删除评级授权","delRecord()",sResourcesPath},
			{"true","","Button","保存修改","保存修改","saveRecord()",sResourcesPath}
			};
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
	<script language=javascript>
	/*~[Describe=新增评级授权;InputParam=无;OutPutParam=无;]~*/
	function singletonRecord()
	{
		sCompID = "AuthorizeEvaluateInfo";
		sCompURL = "/SystemManage/AuthorizeManage/AuthorizeEvaluateInfo.jsp";
		sParamString = "";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=修改/查看评级授权;InputParam=无;OutPutParam=无;]~*/
	function editRecord()
	{
		var sOrgID = getItemValue(0,getRow(),"OrgID");			//--机构号
		var sRoleID = getItemValue(0,getRow(),"RoleID");		//--角色号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	//--授权方案序列号
		if(typeof(sOrgID)=="undefined" || sOrgID.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		sCompID = "AuthorizeEvaluateInfo";
		sCompURL = "/SystemManage/AuthorizeManage/AuthorizeEvaluateInfo.jsp";
		sParamString = "OrgID="+sOrgID+"&RoleID="+sRoleID+"&SerialNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=删除评级授权;InputParam=无;OutPutParam=无;]~*/
	function delRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		if(confirm("您真的想删除该信息吗？")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=保存修改;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(){
		as_save("myiframe0");
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	hideFilterArea();
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hldu
		Tester:
		Describe: 启用新评分卡模型 
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "启用新评分卡模型"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
    String sSql = "";
    String sIsInuse = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = { 
		                     {"CODENO","UnusedOldEvaluateCard"},
                             {"ITEMNO","UnusedOldEvaluateCard"},
	                         {"IsInuse","是否停用信用等级评估(新模型)"},
	                         {"inputuser","更新人"},
	                         {"inputusername","更新人"},
	                         {"inputorg","更新机构"},
	                         {"inputorgname","更新机构"},
	                         {"InputTime","登记日期"},						
	                         {"UpdateTime","启用时间"}
			              };

	sSql = " select codeno,itemno,IsInuse,inputuser,getUserName(inputuser) as inputusername,inputorg,getOrgName(inputorg) as inputorgname ,InputTime,UpdateTime from code_library  where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' "	;
	
	//由sSql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头,更新表名,键值,必输项,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.setDefaultValue("CODENO,ITEMNO","UnusedOldEvaluateCard");
	doTemp.UpdateTable = "code_library";
	doTemp.setKey("CODENO,ITEMNO",true);
	doTemp.setVisible("CODENO,ITEMNO,inputuser,inputorg",false);
	doTemp.setUpdateable("inputusername,inputorgname",false);  	
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:80px}");
	doTemp.setReadOnly("inputusername,inputorgname,InputTime,UpdateTime",true);
	doTemp.setRequired("IsInuse",true);
	//设置下拉框
	doTemp.setDDDWSql("IsInuse","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'YesNo' ");
    
	//设置默认值
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	sIsInuse = Sqlca.getString(" select IsInuse from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
	if(sIsInuse == null) sIsInuse = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	//依次为:
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			//{(sIsInuse.equals("2")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath}
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath}
		};
	if(!sIsInuse.equals("2"))
	{
		sButtons[0][0] = "false";
	}	

	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		beforeUpdate();		
		as_save("myiframe0",sPostEvents);
		reloadSelf();
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
	    sIsInuse = getItemValue(0,getRow(),"IsInuse");// 放到jsp里
	    if(sIsInuse == "1") //选择“是” 停用原评分卡模型，启用新评分卡模型
	    {
	  		sRetValue = PopPage("/SystemManage/ParameterManage/UnusedOldEvaluateCardAction.jsp?Flag=1","","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(sRetValue=='00'){
				alert("切换成功！");
				reloadSelf();
			}else{
				alert("切换失败！");
			}
	    }
	    //更新时间
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		//更新人
		setItemValue(0,0,"inputuser","<%=CurUser.UserID%>");
		setItemValue(0,0,"inputusername","<%=CurUser.UserName%>");	
		//更新机构
		setItemValue(0,0,"inputorg","<%=CurOrg.OrgID%>");	
		setItemValue(0,0,"inputorgname","<%=CurOrg.OrgName%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{

         if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"inputuser","<%=CurUser.UserID%>");
			setItemValue(0,0,"inputusername","<%=CurUser.UserName%>");	
			setItemValue(0,0,"inputorg","<%=CurOrg.OrgID%>");	
		    setItemValue(0,0,"inputorgname","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		}
		
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
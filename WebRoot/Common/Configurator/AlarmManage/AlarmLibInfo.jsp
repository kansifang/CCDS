<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   zxu 2005-06-06
			Tester:
			Content:    预警条件详情
			Input Param:
	                    ScenarioID：    预警场景编号
	                    AlarmModelNo：  预警模型编号
	 		Output param:
			                
			History Log: 
	            
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "预警条件详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql;
	String sSortNo; //排序编号
	
	//获得组件参数	
	String sScenarioID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ScenarioID"));
	String sAlarmModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AlarmModelNo"));
	if(sScenarioID==null) sScenarioID="";
	if(sAlarmModelNo==null) sAlarmModelNo="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders = {
		{"ScenarioID","场景编号"},
		{"AlarmModelNo","模型编号"},
		{"sortno","排序号"},
		{"DealMethod","处理措施"},
		{"RunCondition","运行条件"},
		{"ShowScript","提示Script"},
		{"EffStatus","有效标志"},
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
	
	sSql =  "select "+
	"ScenarioID,"+
	"AlarmModelNo,"+
	"sortno,"+
	"DealMethod,"+
	"RunCondition,"+
	"ShowScript,"+
	"EffStatus,"+
	"Remark,"+
	"getUserName(InputUser) as InputUserName,"+
	"InputUser,"+
	"getOrgName(InputOrg) as InputOrgName,"+
	"InputOrg,"+
	"InputTime,"+
	"getUserName(UpdateUser) as UpdateUserName,"+
	"UpdateUser,"+
	"UpdateTime "+
		" from ALARM_LIBRARY where ScenarioID = '"+sScenarioID+"' and AlarmModelNo='"+sAlarmModelNo+"' ";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "ALARM_LIBRARY";
	doTemp.setKey("ScenarioID,AlarmModelNo",true);
	doTemp.setHeader(sHeaders);

 	doTemp.setHTMLStyle("RunCondition"," style={width:200px} ");
 	doTemp.setHTMLStyle("ShowScript"," style={width:400px} ");
 	//doTemp.setUnit("RunCondition","(如果为空，则为默认执行；如果填写条件，录入AmarScript逻辑运算表达式，则条件满足才显示；如果使用特殊标签###:引导，则为运行时检查，填写javascript表达式)");

	if( sAlarmModelNo.length() == 0 )
		doTemp.setReadOnly("InputUser,UpdateUser,InputOrg,InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	else
		doTemp.setReadOnly("ScenarioID,AlarmModelNo,InputUser,UpdateUser,InputOrg,InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);

 	doTemp.setRequired("ScenarioID,AlarmModelNo,sortno,DealMethod,EffStatus",true);

	//doTemp.setDDDWSql("DealMethod","select AlmMethodNo,AlmMehtodName from ALARM_METHOD where 1=1 order by AlmMethodNo");
	doTemp.setDDDWCode("DealMethod","LoanMethod");
	doTemp.setDDDWSql("AlarmModelNo","select AlarmModelNo,AlarmModelName from Alarm_MODEL order by AlarmModelNo");

 	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);

	doTemp.setDDDWCode("EffStatus","TrueFalse");

	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Remark",200);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sScenarioID+","+sAlarmModelNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	String sCriteriaAreaHTML = "";
%>

<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
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
			{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()",sResourcesPath},
			{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
			// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回代码列表","doReturn('N')",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndReturn()
	{
  		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
           as_save("myiframe0","doReturn('Y');");
	}
    
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd()
	{
 		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
	        as_save("myiframe0","newRecord()");
	}

    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ScenarioID");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        OpenComp("AlarmLibInfo","/Common/Configurator/AlarmManage/AlarmLibInfo.jsp","ScenarioID="+sScenarioID,"_self","");
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
            	if ("<%=sScenarioID%>" !="") 
            	{
            	    	setItemValue(0,0,"ScenarioID","<%=sScenarioID%>");
            	}
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
			bIsInsert = true;
		}
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

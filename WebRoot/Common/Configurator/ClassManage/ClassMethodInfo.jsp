<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content:    类及方法记录信息详情
			Input Param:
	                    ClassName：    类名称
	                    MethodName：   方法名称
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
		String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sDiaLogTitle;
	
	//获得组件参数	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassName"));
	String sMethodName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("MethodName"));
	String sClassDescribe =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassDescribe"));
	if(sClassName==null) sClassName="";
	if(sClassName==null) sClassName="";
	if(sMethodName==null) sMethodName="";
	if (sClassName.equals(""))
	{
		sDiaLogTitle = "【 新类新方法新增配置 】";	
	}
	else
	{
		if(sMethodName.equals(""))
		{
	sDiaLogTitle = "【类"+sClassDescribe+"－["+ sClassName +"]】方法新增配置";
		}
		else
		{
	sDiaLogTitle = "【类"+sClassDescribe+"－["+ sClassName +"]】的『 "+sMethodName+" 』方法查看修改配置";
		}
	}
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders={
		{"CLASSNAME","类名称"},
		{"METHODNAME","方法名称"},
		{"METHODTYPE","方法类型"},
		{"METHODDESCRIBE","方法描述"},
		{"RETURNTYPE","返回值类型"},
		{"METHODARGS","方法参数"},
		{"METHODCODE","方法实现代码"},
		{"REMARK","备注"},
		{"INPUTUSERNAME","登记人"},
		{"INPUTUSER","登记人"},
		{"INPUTORGNAME","登记机构"},
		{"INPUTORG","登记机构"},
		{"INPUTTIME","登记时间"},
		{"UPDATEUSERNAME","更新人"},
		{"UPDATEUSER","更新人"},
		{"UPDATETIME","更新时间"},
		};

	sSql = "select "+
	"CLASSNAME,"+
	"METHODNAME,"+
	"METHODTYPE,"+
	"METHODDESCRIBE,"+
	"RETURNTYPE,"+
	"METHODARGS,"+
	"METHODCODE,"+
	"REMARK,"+
	"getUserName(INPUTUSER) as INPUTUSERNAME,"+
	"INPUTUSER,"+
	"getOrgName(INPUTORG) as INPUTORGNAME,"+
	"INPUTORG,"+
	"INPUTTIME,"+
	"getUserName(UPDATEUSER) as UPDATEUSERNAME,"+
	"UPDATEUSER,"+
	"UPDATETIME "+
	"from CLASS_METHOD where ClassName='"+sClassName+"' and MethodName='"+sMethodName+"'";

	ASDataObject doTemp = new ASDataObject(sSql);

	doTemp.UpdateTable="CLASS_METHOD";
	doTemp.setKey("CLASSNAME,METHODNAME",true);
	doTemp.setHeader(sHeaders);

 	doTemp.setHTMLStyle("METHODDESCRIBE,METHODARGS"," style={width:300px} ");
 	doTemp.setEditStyle("METHODCODE","3");
 	doTemp.setHTMLStyle("METHODCODE"," style={height:300px;width:400px;} ");

 	doTemp.setHTMLStyle("INPUTORG"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTTIME,UPDATETIME"," style={width:130px} ");
	doTemp.setEditStyle("REMARK","3");
	doTemp.setHTMLStyle("REMARK"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("REMARK",120);
	doTemp.setReadOnly("INPUTUSER,UPDATEUSER,INPUTORG,INPUTUSERNAME,UPDATEUSERNAME,INPUTORGNAME,INPUTTIME,UPDATETIME",true);

	doTemp.setDDDWCodeTable("RETURNTYPE","Number,Number,String,String,Number[],Number[],String[],String[]");
	doTemp.setDDDWCode("METHODTYPE","MethodType");
	doTemp.setRequired("CLASSNAME",true);

	if (!sClassName.equals("")) 
	{
		doTemp.setVisible("CLASSNAME",false);    	
	   	doTemp.setRequired("CLASSNAME",false);
	}
	doTemp.setVisible("INPUTUSER,INPUTORG,UPDATEUSER",false);    	
	doTemp.setUpdateable("INPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);
	//必输项
   	doTemp.setRequired("METHODNAME",true);
   	doTemp.setRequired("METHODDESCRIBE",true);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
    var sCurClassName=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndReturn()
	{
	        setItemValue(0,0,"UPDATEUSER","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","doReturn('Y');");
        
	}
    
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd()
	{
	        setItemValue(0,0,"UPDATEUSER","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","newRecord()");
	}

    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CLASSNAME");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
	        sClassName = getItemValue(0,getRow(),"CLASSNAME");
	        OpenComp("ClassMethodInfo","/Common/Configurator/ClassManage/ClassMethodInfo.jsp","ClassName="+sClassName,"_self","");
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
			if ("<%=sClassName%>" !="") 
			{
				setItemValue(0,0,"CLASSNAME","<%=sClassName%>");
			}
			setItemValue(0,0,"INPUTUSER","<%=CurUser.UserID%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.UserName%>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"INPUTTIME","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.UserID%>");
			setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.UserName%>");
			setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
			
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
 	setDialogTitle("<%=sDiaLogTitle%>");   
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

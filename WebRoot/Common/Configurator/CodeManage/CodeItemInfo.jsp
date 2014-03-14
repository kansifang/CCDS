<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: 代码表信息详情
			Input Param:
	                    CodeNo：    代码表编号
	                    ItemNo：    项目编号（新增是不传入）
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
	String sSql = "";
	String sDiaLogTitle = "";
	String sSortNo = ""; //排序编号
	
	//获得组件参数	
	String sCodeNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo"));
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
	String sCodeName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeName"));
	//将空值转化为空字符串
	if(sCodeNo == null) sCodeNo = "";
	if(sItemNo == null) sItemNo = "";
	if(sCodeName == null) sCodeName = "";
	
	if(sCodeNo.equals("")) 
	{
		sDiaLogTitle = "【 代码库新增配置 】";
	}else
	{
		if(sItemNo==null || sItemNo.equals("")) 
		{
	sItemNo="";
	sDiaLogTitle = "【"+sCodeName+"】代码：『"+sCodeNo+"』新增配置";
		}else
		{
	sDiaLogTitle = "【"+sCodeName+"】代码：『"+sCodeNo+"』查看修改配置";
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
		{"CodeNo","代码号"},
		{"ItemNo","项目号"},
		{"ItemName","项目名称"},
		{"SortNo","排序号"},
		{"IsInUse","有效状态"},
		{"ItemDescribe","项目描述"},
		{"ItemAttribute","项目属性"},
		{"RelativeCode","关联代码"},
		{"Attribute1","属性1"},
		{"Attribute2","属性2"},
		{"Attribute3","属性3"},
		{"Attribute4","属性4"},
		{"Attribute5","属性5"},
		{"Attribute6","属性6"},
		{"Attribute7","属性7"},
		{"Attribute8","属性8"},
		{"Remark","备注"},
		{"HelpText","帮助"},
		{"InputUserName","登记人"},
		{"InputUser","登记人"},
		{"InputOrgName","登记机构"},
		{"InputOrg","登记机构"},
		{"InputTime","登记时间"},
		{"UpdateUserName","更新人"},
		{"UpdateUser","更新人"},
		{"UpdateTime","更新时间"},

		};

	sSql =  "select "+
	"CodeNo,"+
	"ItemNo,"+
	"ItemName,"+
	"SortNo,"+
	"IsInUse,"+
	"ItemDescribe,"+
	"ItemAttribute,"+
	"RelativeCode,"+
	"Attribute1,"+
	"Attribute2,"+
	"Attribute3,"+
	"Attribute4,"+
	"Attribute5,"+
	"Attribute6,"+
	"Attribute7,"+
	"Attribute8,"+
	"Remark,"+
	"HelpText,"+
	"getUserName(InputUser) as InputUserName,"+
	"InputUser,"+
	"getOrgName(InputOrg) as InputOrgName,"+
	"InputOrg,"+
	"InputTime,"+
	"getUserName(UpdateUser) as UpdateUserName,"+
	"UpdateUser,"+
	"UpdateTime "+
	"from CODE_LIBRARY "+
	"Where CodeNo = '" +sCodeNo+"' "+
	"And ItemNo = '"+sItemNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);

	doTemp.UpdateTable="CODE_LIBRARY";
	doTemp.setKey("CodeNo,ItemNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("InputUserName,UpdateUserName,InputOrgName"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:90px} ");
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
	//只读项
	doTemp.setReadOnly("InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);

	doTemp.setDDDWCode("IsInUse","IsInUse");
 
	doTemp.setHTMLStyle("CodeNo"," style={width:200px} ");
	doTemp.setHTMLStyle("ItemName"," style={width:200px} ");
	doTemp.setHTMLStyle("SortNo,ItemNo"," style={width:200px} ");
	//必输项
   	doTemp.setRequired("ItemNo,ItemName",true);
	doTemp.setEditStyle("Remark,HelpText,ItemDescribe,ItemAttribute,RelativeCode,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8","3");
	doTemp.setHTMLStyle("Remark,HelpText,ItemDescribe,ItemAttribute,RelativeCode,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8"," style={width:600px;height:100px;overflow:auto} onDBLClick=\"parent.editObjectValueWithScriptEditorForASScript(this)\"");
	if(!sCodeNo.equals("")) 
	{
		doTemp.setVisible("CodeNo",false); 
	}
	else
	{
		doTemp.setRequired("CodeNo",true);
	} 
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateCodeCatalogUpdateTime("+StringFunction.getTodayNow()+","+CurUser.UserID+","+sCodeNo+")");
	
	
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
			{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
			{"true","","Button","保存并新增","保存后新增","saveAndNew()",sResourcesPath}			
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
	var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=保存并新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function saveAndNew()
	{
		saveRecord("newRecord()");
	}
   
	function newRecord()
	{
        	OpenComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeNo=<%=sCodeNo%>&CodeName=<%=sCodeName%>","_self");
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CodeNo","<%=sCodeNo%>");
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
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

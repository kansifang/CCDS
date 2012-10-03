<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: 页面信息详情
		Input Param:
                    PageID：    组件编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "组件管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sSortNo; //排序编号
	ASResultSet rs=null;
	
	//获得组件参数	
	String sPageID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PageID"));
	String sCompID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CompID",10));
	if(sPageID==null) sPageID="";
	if(sCompID==null) sCompID="";

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	rs = Sqlca.getASResultSet("select Distinct CompID from REG_COMP_Page where PageID='"+sPageID+"' ");
	if(rs.next())
	{
		sCompID = rs.getString(1);
	}
	rs.getStatement().close();

	String[][] sHeaders = {
		{"PageID","页面ID"},
		{"PageName","页面名称"},
		{"CompID","组件ID"},
		{"PageURL","页面URL"},
		{"DONO","DONO"},
		{"JSPMODEL","JSPMODEL"},
		{"Remark","备注"},
		{"InputUserName","输入人"},
		{"InputUser","输入人"},
		{"InputOrgName","输入机构"},
		{"InputOrg","输入机构"},
		{"InputTime","输入时间"},
		{"UpdateUserName","更新人"},
		{"UpdateUser","更新人"},
		{"UpdateTime","更新时间"}
	};
	sSql = "select "+
			"PageID,"+
			"PageName,"+
			"PageURL,"+
			"DoNo,"+
			"JspModel,"+
			"Remark,"+
			"getUserName(InputUser) as InputUserName,"+
			"InputUser,"+
			"getOrgName(InputOrg) as InputOrgName,"+
			"InputOrg,"+
			"InputTime,"+
			"getUserName(UpdateUser) as UpdateUserName,"+
			"UpdateUser,"+
			"UpdateTime "+
			"from REG_PAGE_DEF where PageID='" +sPageID+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "REG_PAGE_DEF";
	doTemp.setKey("PageID",true);
	doTemp.setHeader(sHeaders);
	
	doTemp.setDDDWCode("JSPMODEL","JSPModel");
	doTemp.setRequired("PageName,CompID",true);

	doTemp.setHTMLStyle("PageID,PageURL,PageName,"," style={width:600px} ");

	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:600px;overflow:scroll} ");
 	doTemp.setLimit("Remark",400);
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setReadOnly("InputTime,UpdateTime,InputUserName,InputOrgName,UpdateUserName",true);
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
	doTemp.setVisible("DoNo,JspModel,InputUser,UpdateUser,InputOrg",false);

	if(sCompID!=null) doTemp.setDefaultValue("CompID",sCompID);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	if(sCompID!=null && !sCompID.equals("")) dwTemp.setEvent("AfterInsert","!Configurator.InsertCompPage(#PageID,"+sCompID+")");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPageID);
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
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回代码列表","doReturn('N')",sResourcesPath},
		// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","页面生成","页面生成","generateJspPage()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    var sCurPageID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","doReturn('Y');");        
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"PageID");
        	parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

    function getApp()
    {
        sReturn=popComp("DBConnSelect","/Common/ToolsA/PublicSelect.jsp","TempletNo=SelectDBConn","dialogWidth:320px;dialogHeight:320px;resizable:yes;scrollbars:no");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0 && sReturn!='_NONE_') 
        {
            sReturnValues = sReturn.split("@");
            setItemValue(0,0,"DBConnectionID",sReturnValues[0]);
        
        }
    }
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
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
	setItemValue(0,0,"CompID","<%=sCompID%>");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	function generateJspPage()
	{
		sPageID = getItemValue(0,getRow(),"PageID");
		sCompID = getItemValue(0,getRow(),"CompID");
        	if(typeof(sPageID)=="undefined" || sPageID.length==0 || typeof(sCompID)=="undefined" || sCompID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            		return ;
		}
		sServerRoot = PopPage("/GetServerRootPath.jsp","","");
		sReturn = PopPage("/Common/Configurator/PageManage/GenerateJspPage.jsp?PageID="+sPageID+"&CompID="+sCompID+"&ServerRootPath="+sServerRoot,"","");
		if(sReturn=="succeeded"){
			alert("成功生成页面！");
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

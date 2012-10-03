<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   fhuang 2007-01-04
		Tester:
		Content:    格式化报告参数信息详情
		Input Param:
                    DocID： 格式化调查报告编号
                    OrgID： 使用机构  
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sDocID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocID"));
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sDocID == null) sDocID = "";
	if(sOrgID == null) sOrgID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String[][] sHeaders={
			{"OrgID","机构编号"},
			{"DocID","文档编号"},
			{"DocName","文档名称"},
			{"DefaultValue","缺省节点组合"},			
			{"Attribute1","属性一"},
			{"Attribute2","属性二"},
			{"InputUser","登记人员"},
			{"InputUserName","登记人员"},
			{"InputTime","登记时间"},
			{"UpdateUser","更新人员"},
			{"UpdateUserName","更新人员"},
			{"UpdateDate","更新日期"}
		};

	sSql = "Select "+
			"OrgID,"+
			"DocID,"+
			"DocName,"+
			"DefaultValue,"+
			"Attribute1,"+
			"Attribute2,"+
			"InputUser,"+
			"getUserName(InputUser) as InputUserName,"+
			"InputTime,"+
			"UpdateUser,"+
			"getUserName(UpdateUser) as UpdateUserName,"+
			"UpdateDate "+
			"From FormatDoc_Para "+
			"where DocID='"+sDocID+"' "+
			"and OrgID='"+sOrgID+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.UpdateTable="FormatDoc_Para";
	doTemp.setKey("DocID,OrgID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setDDDWSql("OrgID","select OrgID,OrgName from Org_Info ");
	doTemp.setHTMLStyle("DocID"," style={width:60px} ");
	doTemp.setHTMLStyle("DocName"," style={width:250px} ");
	doTemp.setEditStyle("Attribute1,Attribute2,DefaultValue","3");
	doTemp.setRequired("OrgID,DocID,DocName,DefaultValue",true);   //必输项
	doTemp.setVisible("InputUser,UpdateUser",false);
	doTemp.setUpdateable("InputUserName,UpdateUserName",false);
	doTemp.setReadOnly("DocID,DocName,InputUserName,UpdateUserName,InputTime,UpdateDate",true);
	doTemp.setUnit("DocName"," <input type=button class=inputdate value=.. onclick=parent.getDocName()>");
	//设置共用格式

	//filter过滤条件
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDocID+","+sOrgID);
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
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/

	function saveRecord()
	{
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        as_save("myiframe0","doReturn('Y');");        
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sDocID = getItemValue(0,getRow(),"DocID");
        parent.sObjectInfo = sDocID+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=弹出格式化报告文档名称选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getDocName()
	{		
		sParaString = "";			
		setObjectValue("SelectFormatDoc",sParaString,"@DocID@0@DocName@1",0,0,"");
	}

	function initRow()
	{

		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
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

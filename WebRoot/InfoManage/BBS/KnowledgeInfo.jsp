<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/* 
		Author:   cwliu  2004/12/09
		Tester:
		Content: 营销信息管理
		Input Param:
			                ID:信息编号
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "营销信息信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";
	//获得组件参数
	String sCatalogID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sCatalogID == null) sCatalogID = "";
	//获得页面参数	
	String sID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ID"));
	if(sID == null) sID = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	
	String sHeaders[][] = {     
								{"ID","信息编号"},
	                            {"Title","标题"},
	                            {"Demo","导读"},
				                {"Source","来源"},
								{"CatalogName","主题"},
				                {"Author","发布者"},
				                {"CreateDate","创建日期"},
				                {"ModifiedDate","修改日期"},
				                {"Hits","点击次数"},
				                {"Replies","回复次数"},
				                {"Body","正文"},
				                {"Attribute1","类型"},
				                {"Attribute2","发布范围"}
	                       }; 
	sSql = " select ID,CatalogID,getItemName('CatalogID',CatalogID) as CatalogName,"+
		   " ParentID,RootID,Title,Attribute1,Source,Author,Demo," +
	       " Body,CreateDate,ModifiedDate,Hits,Replies  " +
	       " from KNOWLEDGE_CATALOG " +
	       " where ID='"+sID+"'";
	//通过显示模版产生ASDataObject对象doTemp
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "KNOWLEDGE_CATALOG";
	
    doTemp.setKey("ID",true);       
	doTemp.setRequired("Title,Body",true);

	doTemp.setType("Hits,Replies","Number");
	doTemp.setVisible("CatalogID,CatalogName,ID,ParentID,RootID,Hits,Replies,Author",false);
    doTemp.setReadOnly("CatalogName,CreateDate,ModifiedDate",true);
    doTemp.setUpdateable("CatalogName",false);                             
	//设下拉框	                    
	doTemp.setDDDWCode("Attribute1","KnowledgeType");
	doTemp.setHTMLStyle("Title"," style={width:300px}");
	doTemp.setHTMLStyle("CreateDate,ModifiedDate"," style={color:#848284;width:80px} ");
	doTemp.setLimit("Body",800);
	doTemp.setEditStyle("Body","3");
	doTemp.setHTMLStyle("Body"," style={height:150px;width:400px};overflow:scroll} ");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setEvent("AfterInsert","!InfoManage.InsertKnowledgeObjectInfo(#ID,'"+sCatalogID+"')+!InfoManage.InsertBoard(#ID)");
	dwTemp.setEvent("AfterDelete","!InfoManage.DeleteKnowledgeObjectInfo(#ID,'"+sCatalogID+"')+!InfoManage.DeleteBoard(#ID)");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","上传文件","上传文件","fileadd()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){		
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	function fileadd()
	{
		sID = getItemValue(0,getRow(),"ID");
	    if(typeof(sID)=="undefined" || sID.length==0) {
			alert("先保存信息再上传文件!");
	        return ;
		}
		popComp("FileAdd","/SystemManage/SynthesisManage/FileAdd.jsp","BoardNo="+sID,"dialogWidth=550px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/InfoManage/BBS/KnowledgeList.jsp","_self","");
	}	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,getRow(),"ModifiedDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CatalogID","<%=sCatalogID%>");
			setItemValue(0,getRow(),"CreateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"ModifiedDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"Hits","0");
			setItemValue(0,getRow(),"Replies","0");
			setItemValue(0,0,"Author","<%=CurUser.UserID%>");
			bIsInsert = true;
		}
		
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "KNOWLEDGE_CATALOG";//表名
		var sColumnName = "ID";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
   
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

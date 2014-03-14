<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: ndeng 2005-04-20 
			Tester:
			Describe: 总行通知情况
			Input Param:
		OrgID：
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
		String PG_TITLE = "通知情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>



<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	
	//获得组件参数

	String sBoardNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("BoardNo"));
	if(sBoardNo==null) sBoardNo="";
	
	//获得页面参数
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = { {"BoardNo","公告编号"},
	    	                        {"BoardName","公告名称"},
	    	                        {"BoardTitle","公告标题"},
	    				            {"BoardDesc","公告描述"},
	    				            {"IsPublish","是否发布"},
	    				            {"ShowToOrgs","接受机构"},
	    				            {"IsNew","是否新"},
	                				{"IsEject","是否弹出"},
	                				{"FileName","公告文件名"},
	                				{"ContentType","内容类型"},
	                				{"ContentLength","内容长度"},
	                				{"UploadTime","上传时间"}
			            }; 	 

		String sSql ="select BoardNo,BoardName,BoardTitle,BoardDesc,IsPublish,ShowToOrgs,IsNew,IsEject,FileName,"+
			        "ContentType,ContentLength,UploadTime "+
			        "from BOARD_LIST "+
			        "where BoardNo = '"+sBoardNo+"' ";	
	                	
	    ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "BOARD_LIST"; 

		doTemp.setKey("BoardNo",true);
		doTemp.setVisible("BoardNo",false);
		doTemp.setDDDWCode("IsPublish,IsNew,IsEject","YesNo");
		doTemp.setDefaultValue("IsPublish,IsNew,IsEject","1");
		doTemp.setReadOnly("ShowToOrgs,FileName,ContentType,ContentLength,UploadTime",true);
		doTemp.setHTMLStyle("BoardTitle,FileName,BoardDesc"," style={width:300px}");
		doTemp.setRequired("BoardName,BoardTitle",true);
		doTemp.setUnit("ShowToOrgs"," <input class=\"inputdate\" value=\"...\" type=button value=.. onclick=parent.selectOrgs()>");
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","上传文件","上传文件","fileadd()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
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
		sBoardNo = getItemValue(0,getRow(),"BoardNo");
	    if(typeof(sBoardNo)=="undefined" || sBoardNo.length==0) {
			alert("先保存信息再上传文件!");
	        return ;
		}
		popComp("FileAdd","/SystemManage/SynthesisManage/FileAdd.jsp","BoardNo="+sBoardNo,"dialogWidth=550px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/BoardList.jsp","_self","");
	}

	/*~[Describe=选择机构列表;InputParam=无;OutPutParam=无;]~*/
	function selectOrgs()
	{
		sBoardNo = getItemValue(0,getRow(),"BoardNo");
		var OrgList = PopPage("/SystemManage/SynthesisManage/DefaultOrgSelect.jsp?rand="+randomNumber(),"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
		if (typeof(OrgList)=="undefined" || OrgList=="_none_" || OrgList.length==0)
		return;
		OrgList = OrgList.replace(/,/g,"@");
		alert(OrgList);
		RunMethod("BusinessManage","insertBoardListOrgs",sBoardNo+","+OrgList);
		reloadSelf();
	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

	<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{

	}


	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BOARD_LIST";//表名
		var sColumnName = "BoardNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
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
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

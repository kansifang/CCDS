<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: ymwu　20130505
			Tester:
			Content: 配置影像权限
			Input Param:
			  RCSerialNo
			Output param:
			History Log:
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "INFO页面详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//获得组件参数
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	System.out.println(sObjectNo+"------------------------");
	if(sObjectType==null)  sObjectType="";
	if(sObjectNo==null)  sObjectNo="";
	String sSql = "";
	String sScanAuthority="0",sQueryAuthority="0",sDeleteAuthority="0",sAlterAuthority="0",sPrintAuthority="0",
	       sNoteAuthority="0",sAdminAuthority="0",sDownLoadAuthority="0";
	String sObjectTableName ="",sObjectCol="";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = {
					{"ScanAuthority","扫描权限"},
					{"QueryAuthority","查看权限"},
					{"DeleteAuthority","删除权限"},
					{"AlterAuthority","修改权限"},
					{"PrintAuthority","打印权限"},
					{"NoteAuthority","批注权限"},
					{"AdminAuthority","管理员权限"},
					{"DownLoadAuthority","下载权限"},
					
	           };
	
    if("User".equals(sObjectType)){
    	sObjectTableName="User_Info";
    	sObjectCol ="UserID";
    }else{
    	sObjectTableName="Role_Info";
    	sObjectCol ="RoleID";
    }
    
	sSql = "Select ImageRight from "+sObjectTableName+" where "+sObjectCol+"='"+sObjectNo+"' ";
	String sImageRight = Sqlca.getString(sSql);
	if(sImageRight!= null &&sImageRight.length()>0){
		sScanAuthority     = sImageRight.substring(0,1);
		sQueryAuthority    = sImageRight.substring(1,2);
		sDeleteAuthority   = sImageRight.substring(2,3);
		sAlterAuthority    = sImageRight.substring(3,4);
		sPrintAuthority    = sImageRight.substring(4,5);
		sNoteAuthority     = sImageRight.substring(5,6);
		sAdminAuthority    = sImageRight.substring(6,7);
		sDownLoadAuthority = sImageRight.substring(7,8);
	} 
	
	sSql = " select "+
	" "+sScanAuthority+" as ScanAuthority,"+sQueryAuthority+" as QueryAuthority,"+sDeleteAuthority+" as DeleteAuthority,"+sAlterAuthority+" as AlterAuthority,"+
	       " "+sPrintAuthority+" as PrintAuthority,"+sNoteAuthority+" as NoteAuthority,"+sAdminAuthority+" as AdminAuthority, "+sDownLoadAuthority+" as DownLoadAuthority"+
	       " "+
		   " from sysibm.sysdummy1 ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setRequired("ScanAuthority,QueryAuthority,DeleteAuthority,AlterAuthority,PrintAuthority,NoteAuthority,AdminAuthority,DownLoadAuthority",true);
	doTemp.setUpdateable("ScanAuthority,QueryAuthority,DeleteAuthority,AlterAuthority,PrintAuthority,NoteAuthority,AdminAuthority,DownLoadAuthority",false);
	doTemp.setHRadioCode("ScanAuthority,QueryAuthority,DeleteAuthority,AlterAuthority,PrintAuthority,NoteAuthority,AdminAuthority,DownLoadAuthority","TrueFalse");
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置为Grid风格
	dwTemp.ReadOnly = "0"; //设置为只读

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
		{"User".equals(sObjectType)?"true":"false","","Button","清除影像权限","清除影像权限","clearRight()",sResourcesPath}
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
	function saveRecord()
	{
		sScanAuthority = getItemValue(0,getRow(),"ScanAuthority");
		sQueryAuthority = getItemValue(0,getRow(),"QueryAuthority");
		sDeleteAuthority = getItemValue(0,getRow(),"DeleteAuthority");
		sAlterAuthority = getItemValue(0,getRow(),"AlterAuthority");
		sPrintAuthority = getItemValue(0,getRow(),"PrintAuthority");
		sNoteAuthority = getItemValue(0,getRow(),"NoteAuthority");
		sAdminAuthority = getItemValue(0,getRow(),"AdminAuthority");
		sDownLoadAuthority = getItemValue(0,getRow(),"DownLoadAuthority");
		sImageAuthority = sScanAuthority+sQueryAuthority+sDeleteAuthority+sAlterAuthority+sPrintAuthority+sNoteAuthority+sAdminAuthority+sDownLoadAuthority;
		var sNum = RunMethod("PublicMethod","UpdateColValue","String@ImageRight@"+sImageAuthority+",<%=sObjectTableName%>,String@<%=sObjectCol%>@"+"<%=sObjectNo%>");
		if(sNum){
			self.close();
			}
		
	}

	function clearRight(){
		var sNum = RunMethod("PublicMethod","ExecuteSql","Update User_Info set ImageRight='' where Userid='<%=sObjectNo%>'");
		if(sNum=="1"){
			self.close();
			}
		}

	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

	<script language=javascript>
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
 
 

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{		 
		}
	}
 
 </SCRIPT>
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
	
</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
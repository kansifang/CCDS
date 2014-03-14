<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content: 本行认可评估机构详情页面
			Input Param:
		SerialNo：流水号
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
		String PG_TITLE = "本行认可评估机构管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//获得页面参数	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	
	//定义变量
	String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = {     
						{"attribute1","评估机构编号"},
						{"CustomerName","评估机构名称"},
			                    {"InputOrgName","登记机构"},
			                    {"InputUserName","登记人"},
			                    {"InputDate","登记日期"},
			                    {"UpdateDate","更新日期"},	
			         }; 
		sSql = " select SerialNo,SectionType,attribute1,CustomerName,getOrgName(InputOrgID) as InputOrgName, "+
			   " InputOrgID,getUserName(InputUserID) as InputUserName,InputUserID,InputDate,UpdateDate "+
			   " from CUSTOMER_SPECIAL "+
		       " where SerialNo = '"+sSerialNo+"' "; 
		//通过sql产生数据窗体对象		
		ASDataObject doTemp = new ASDataObject(sSql);
		//设置表头		
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "CUSTOMER_SPECIAL"; 
		//设置关键字		
		doTemp.setKey("SerialNo",true);
		//设置必输属性
		doTemp.setRequired("CustomerName",true);
		//设置是否可见属性
		doTemp.setVisible("SerialNo,SectionType,InputOrgID,InputUserID",false);
		//设置显示的长度
		doTemp.setHTMLStyle("InputDate,UpdateDate"," style={width:80px}");
			
		//设置所属行名称不可更新
		doTemp.setUpdateable("InputOrgName,InputUserName",false);
		//设置所属行名称为只读，从弹出对话框中选择	
		doTemp.setReadOnly("InputOrgName,InputUserName,InputDate,UpdateDate",true);	
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		session.setAttribute(dwTemp.Name,dwTemp);
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
	function saveRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			initSerialNo();//初始化流水号字段		
		setItemValue(0,getRow(),"UpdateDate","<%=StringFunction.getToday()%>");		
		as_save("myiframe0");		
	}
		
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/AuditOrgList.jsp","_self","");
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

	<script language=javascript>
								
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");
			setItemValue(0,getRow(),"SectionType","60");
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");	
			setItemValue(0,getRow(),"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"UpdateDate","<%=StringFunction.getToday()%>");				
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_SPECIAL";//表名
		var sColumnName = "SerialNo";//字段名
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

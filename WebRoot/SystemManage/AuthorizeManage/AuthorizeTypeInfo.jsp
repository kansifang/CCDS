<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: wwhe	2006-09-04
			Tester:
			Describe: 业务品种确定
			Input Param:
					SerialNo	流水号
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
		String PG_TITLE = "业务品种确定"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";
	
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"SerialNo","授权方案编号"},
						{"ObjectType","对象类型"},
						{"ObjectNo","业务品种"}
		   				};		   		
		
		sSql =  " select SerialNo,ObjectType,ObjectNo "+
		" from AUTHORIZE_OBJECT "+
		" where SerialNo = '"+sSerialNo+"' "+
		" and ObjectNo = '"+sObjectNo+"' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		
		doTemp.UpdateTable = "AUTHORIZE_OBJECT";
		doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
		doTemp.setVisible("ObjectType",false);
		doTemp.setReadOnly("SerialNo,ObjectType",true);
		doTemp.setRequired("ObjectNo",true);
		doTemp.setDDDWSql("ObjectNo","select TypeNo,TypeName from BUSINESS_TYPE where not(RTRIM(Attribute14)='' and RTRIM(Attribute14) is NULL) order by 1");
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置为Grid风格
		
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
			{"true","","Button","保存","保存信息","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回","goBack()",sResourcesPath}
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
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{		
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		sReturnValue = RunMethod("授权管理","检查业务品种是否已存在",sSerialNo+","+sObjectNo+","+sObjectType);
		if(sReturnValue>0){
			alert("该业务品种已存在，请重新选择！");
			return false;
		}
		
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/AuthorizeManage/AuthorizeTypeList.jsp?SerialNo=<%=sSerialNo%>","_self","");
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
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");
			setItemValue(0,0,"ObjectType","BusinessType");
			
			bIsInsert = true;
		}
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
	initRow();
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

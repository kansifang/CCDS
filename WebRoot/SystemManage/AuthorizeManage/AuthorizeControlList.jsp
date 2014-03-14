<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: wwhe	2008-04-19
			Tester:
			Describe: 	授权条件定义
			Input Param:
					sSerialNo	授权方案编号
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
		String PG_TITLE = "授权条件定义"; // 浏览器窗口标题 <title> PG_TITLE </title>
		//CurPage.setAttribute("ShowDetailArea","true");
		//CurPage.setAttribute("DetailAreaHeight","60");
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
	
	//获得组件参数：对象编号
	
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
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
						{"ObjectNo","授权方案编号"},
						{"MethodTypeName","控制条件类型"},
						{"MethodDescribe","控制条件说明"},
						{"MethodName","调用类方法方法名"},
						{"MethodStatusName","生效标志"},
						{"InputOrgName","录入机构"},
						{"InputUserName","录入人员"}
		   				};		   		
		
		sSql =  " select SerialNo,ObjectNo,MethodType,getItemName('AuthorizeMethodType',MethodType) as MethodTypeName,MethodDescribe,MethodName,MethodStatus,getItemName('IsInUse',MethodStatus) as MethodStatusName, "+
		" InputOrgID,InputUserID,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName"+
		" from AUTHORIZE_METHOD "+
		" where ObjectNo = '"+sSerialNo+"' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "AUTHORIZE_METHOD";
		doTemp.setKey("SerialNo",true);
		
		doTemp.setVisible("SerialNo,InputOrgID,InputUserID,MethodType,MethodDescribe,MethodStatus,MethodTypeName",false);
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //设置为Grid风格
		dwTemp.ReadOnly = "1"; //设置为只读
		
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
		{"true","","Button","新增控制条件","新增控制条件","newRecord()",sResourcesPath},
		{"true","","Button","修改/查看控制条件","修改/查看控制条件","editRecord()",sResourcesPath},
		{"true","","Button","删除控制条件","删除控制条件","delRecord()",sResourcesPath},
		{"true","","Button","组合授权设置","组合授权设置","setComposeAu()",sResourcesPath}
			};
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
	<script language=javascript>
	/*~[Describe=新增授权方案;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/SystemManage/AuthorizeManage/AuthorizeControlInfo.jsp?ObjectNo=<%=sSerialNo%>","DetailFrame","right");
	}
	
	/*~[Describe=修改授权方案;InputParam=无;OutPutParam=无;]~*/
	function editRecord()
	{
		var sMethodType = getItemValue(0,getRow(),"MethodType");
		var sMethodName = getItemValue(0,getRow(),"MethodName");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		OpenPage("/SystemManage/AuthorizeManage/AuthorizeControlInfo.jsp?MethodName="+sMethodName+"&ObjectNo="+sObjectNo,"DetailFrame","right");
	}
	
	/*~[Describe=删除业务品种;InputParam=无;OutPutParam=无;]~*/
	function delRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		if(confirm("您真的想删除该信息吗？")) 
		{
			var sReturn=RunMethod("PublicMethod","DeleteColValue","Config_Info,String@Attribute1@"+sSerialNo);
			if(sReturn=="TRUE"){
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}
		}
	}
	function setComposeAu()
	{
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");//--授权流水号码
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--授权方法流水号码
		var sMethodName = getItemValue(0,getRow(),"MethodName");//--授权方法流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else if(sMethodName==="组合授权")
		{
			OpenPage("/PublicInfo/ConfigList.jsp?ObjectNo="+sObjectNo+"&AuthorizeMethodSerialNo="+sSerialNo,"DetailFrame",OpenStyle);	
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
	//OpenPage("/Blank.jsp?TextToShow=请先选择相应的授权控制条件!","DetailFrame","");
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: wwhe	2008-04-19
			Tester:
			Describe: 授权方案定义
			Input Param:
				Type:	Precept(授权方案定义)
						Condition(授权条件定义)
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
		String PG_TITLE = "授权方案定义"; // 浏览器窗口标题 <title> PG_TITLE </title>
		CurPage.setAttribute("ShowDetailArea","true");
		CurPage.setAttribute("DetailAreaHeight","125");
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
	
	//获得组件参数
	String sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
	String sType2 = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type2"));
	//获得页面参数
	
 	//将空值转化为空字符串
 	if(sType == null) sType = "";
 	if(sType2 == null) sType2 = "";
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
						{"AuthorizeClass","授权方案优先级"},
						{"AuthorizeName","授权方案名称"},
						{"BeginDate","启用日期"},
						{"EndDate","终结日期"},
						{"InputOrgName","录入机构"},
						{"InputUserName","录入人员"},
						{"AuthorizeStatusName","授权状态"},
						{"AuthorizeTypeName","授权类型"}
		   				};		   		
		
		sSql =  " select SerialNo,AuthorizeClass,AuthorizeName,AuthorizeType,getItemName('AuthorizeType',AuthorizeType) as AuthorizeTypeName, "+
		" BeginDate,EndDate,AuthorizeStatus,getItemName('IsInUse',AuthorizeStatus) as AuthorizeStatusName,InputOrgID,InputUserID, "+
		" getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName "+
		" from AUTHORIZE_ROLE "+
		" where 1=1 "+
		" order by AuthorizeName,AuthorizeClass asc";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "AUTHORIZE_ROLE";
		doTemp.setKey("SerialNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName,AuthorizeStatusName,AuthorizeTypeName",false);
		//doTemp.setDDDWCode("AuthorizeType","AuthorizeType");
		doTemp.setReadOnly("",true);
		doTemp.setReadOnly("AuthorizeType",false);
		
		doTemp.setVisible("InputOrgID,InputUserID,AuthorizeStatus,AuthorizeType,AuthorizeTypeName",false);
		doTemp.setHTMLStyle("AuthorizeName"," style={width:380px} ");
		
		//增加过滤器	
		doTemp.setColumnAttribute("SerialNo,AuthorizeName","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //设置为Grid风格
		//dwTemp.ReadOnly = "1"; //设置为只读
		
		//定义后续事件
		dwTemp.setEvent("BeforeDelete","!授权管理.删除授权方案关联业务品种(#SerialNo)+!授权管理.删除授权方案控制条件(#SerialNo)+!授权管理.删除授权方案机构授权(#SerialNo)");
		
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
			{(sType.equals("Precept")?"true":"false"),"","Button","新增授权方案","新增授权方案","newRecord()",sResourcesPath},
			{(sType.equals("Precept")?"true":"false"),"","Button","修改授权方案","修改授权方案","editRecord()",sResourcesPath},
			{(sType.equals("Precept")?"true":"false"),"","Button","删除授权方案","删除授权方案","delRecord()",sResourcesPath},
			{(sType.equals("Condition")?"true":"false"),"","Button","查看授权方案","查看授权方案","editRecord()",sResourcesPath},
			//{"true","","PlainText","XXX","YYY","",sResourcesPath}
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
		OpenPage("/SystemManage/AuthorizeManage/AuthorizePreceptInfo.jsp","right");
	}
	
	/*~[Describe=修改授权方案;InputParam=无;OutPutParam=无;]~*/
	function editRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		OpenPage("/SystemManage/AuthorizeManage/AuthorizePreceptInfo.jsp?Type=<%=sType%>&SerialNo="+sSerialNo,"right");
	}
	
	/*~[Describe=删除授权方案;InputParam=无;OutPutParam=无;]~*/
	function delRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		if(confirm("您真的想删除该信息吗？")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
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
	/*~[Describe=选中某种授权方案,联动显示与之相关联的业务品种;InputParam=无;OutPutParam=无;]~*/
	function mySelectRow()
	{
		sType = "<%=sType%>";
		sType2 = "<%=sType2%>";

		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else
		{
			if(sType=="Precept")
				OpenPage("/SystemManage/AuthorizeManage/AuthorizeTypeList.jsp?SerialNo="+sSerialNo,"DetailFrame","");
			if(sType=="Condition"){
				if(sType2=="Balance")
					OpenPage("/SystemManage/AuthorizeManage/AuthorizeBalanceList.jsp?SerialNo="+sSerialNo,"DetailFrame","");
				else
					OpenPage("/SystemManage/AuthorizeManage/AuthorizeControlList.jsp?SerialNo="+sSerialNo,"DetailFrame","");	
			}
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
	hideFilterArea();
	OpenPage("/Blank.jsp?TextToShow=请先选择相应的授权方案!","DetailFrame","");
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

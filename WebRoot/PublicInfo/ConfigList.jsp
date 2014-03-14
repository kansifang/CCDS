<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: wwhe	2006-09-04
			Tester:
			Describe: 	机构授权维护
			Input Param:
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
		String PG_TITLE = "机构授权维护"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql="";
	//授权编号
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//控制条件流水号
	String sAuthorizeMethodSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthorizeMethodSerialNo"));
 	//将空值转化为空字符串
 	if(sObjectNo == null) sObjectNo = "";
 	if(sAuthorizeMethodSerialNo == null) sAuthorizeMethodSerialNo = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"Describe1","控制条件描述"},
						{"ItemName1","控制维度1"},
						{"ItemName2","控制维度2"},
						{"ItemName3","控制维度3"},
						{"ItemName4","控制维度4"},
						{"ItemName5","控制维度5"},
						{"ItemName6","控制维度6"},
						{"ItemName7","控制维度7"},
						{"ItemName8","控制维度8"},
						{"ItemName9","控制维度9"},
						{"ItemName10","控制维度10"},
						{"InputDate","控制开始日期"},
						{"UpdateDate","控制截止日期"},
						{"InputOrgName","录入机构"},
						{"InputUserName","录入人员"}
		   				};		   		
		
		sSql =  " select SerialNo,Describe1,"+
		" ItemName1,ItemName2, "+
		" ItemName3,ItemName4, "+
		" ItemName5,ItemName6,"+
		" ItemName7,ItemName8, "+
		" ItemName9,ItemName10, "+
		" IsInUse,InputOrgID,InputUserID,"+
		" getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate"+
		" from Config_Info"+
		" where Attribute1='"+sAuthorizeMethodSerialNo+"'";
			
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "Config_Info";
		doTemp.setKey("SerialNo",true);
		doTemp.setVisible("SerialNo,InputOrgID,InputUserID",false);
		doTemp.setReadOnly("",true);	
		//增加过滤器	
		doTemp.setDDDWCode("IsInUse","YesNo");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //设置为Grid风格
		dwTemp.setPageSize(211);  //服务器分页
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
			//{"true","","Button","新增机构授权(批量)","批量新增机构授权","batchRecord()",sResourcesPath},
			{"true","","Button","新增组合维度","新增组合维度","newRecord()",sResourcesPath},
			{"true","","Button","修改/查看组合维度","修改/查看组合维度","editRecord()",sResourcesPath},
			{"true","","Button","删除组合维度","删除组合维度","delRecord()",sResourcesPath},
			//{"true","","Button","保存金额修改","保存金额修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回","goBack()",sResourcesPath}
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
	/*~[Describe=新增机构授权;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		var sParamString = "Selects=ItemName,ItemNo@Code_Library@CodeNo='AuthorizeControlType' and IsInuse='1'~;";
		var sReturn = PopPage("/PublicInfo/MultiSelectDialogue.jsp?"+sParamString,"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
		if (typeof(sReturn)=="undefined" || sReturn.length==0||sReturn==="_none_"){
			return;
		}
		OpenPage("/PublicInfo/ConfigInfo.jsp?DispayContent="+sReturn+"&AuthorizeMethodSerialNo=<%=sAuthorizeMethodSerialNo%>&ObjectNo=<%=sObjectNo%>","DetailFrame",OpenStyle);
		//var sss=RunMethod("公用方法","DelTable","Config_Info,Describe1 is null or Describe1 =''");
		//reloadSelf();
	}
	
	/*~[Describe=修改/查看机构授权;InputParam=无;OutPutParam=无;]~*/
	function editRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	//--维度序列号
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		OpenPage("/PublicInfo/ConfigInfo.jsp?SerialNo="+sSerialNo+"&AuthorizeMethodSerialNo=<%=sAuthorizeMethodSerialNo%>&ObjectNo=<%=sObjectNo%>","DetailFrame",OpenStyle);
	}
	
	/*~[Describe=删除机构授权;InputParam=无;OutPutParam=无;]~*/
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
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=保存金额修改;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(){
		as_save("myiframe0");
	}
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/AuthorizeManage/AuthorizeControlList.jsp?SerialNo=<%=sObjectNo%>","_self","");
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
	hideFilterArea();
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

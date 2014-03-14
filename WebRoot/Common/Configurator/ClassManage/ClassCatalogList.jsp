<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-28
			Tester:
			Content: 类及方法列表
			Input Param:
	                  
			Output param:
			                
			History Log: 
	            
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql;
	String sSortNo; //排序编号
    	//获得组件参数	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassName"));   //类名
	String sClassDescribe =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassDescribe"));  //类描述
	if (sClassName == null) sClassName = "";
	if (sClassName == null) sClassDescribe = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders={
		{"ClassName","类名称"},
		{"ClassDescribe","类说明"},
		{"ClassType","类型"},
		{"ParentClass","父类名称"},
	};

	sSql = "Select ClassName,ClassDescribe,ClassType,ParentClass from CLASS_CATALOG where 1=1 ";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CLASS_CATALOG";
	doTemp.setKey("ClassName",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("ClassName"," style={width:160px} ");
	doTemp.setHTMLStyle("ClassType"," style={width:100px} ");
	doTemp.setHTMLStyle("ClassDescribe"," style={width:300px} ");
	doTemp.setHTMLStyle("ParentClass"," style={width:160px} ");

	//查询
 	doTemp.setColumnAttribute("ClassName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(sClassName!=null && !sClassName.equals("")) 
	{
		doTemp.WhereClause+=" AND ClassName='"+sClassName+"'";
	}
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" Where 1=2";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelClassMethod(#ClassName)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
%>

<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"false","","Button","保存","保存修改","saveRecord()",sResourcesPath},
			{"true","","Button","方法列表","查看/修改该类对应方法列表","viewAndEdit2()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
	        sReturn=popComp("ClassCatalogInfo","/Common/Configurator/ClassManage/ClassCatalogInfo.jsp","","");
	        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
	        {
			//新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
			{
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
				{
					OpenPage("/Common/Configurator/ClassManage/ClassCatalogList.jsp","_self","");    
		                }
			}
	        }       
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
	        sClassName = getItemValue(0,getRow(),"ClassName");
	        sClassDescribe = getItemValue(0,getRow(),"ClassDescribe");
	        if(typeof(sClassName)=="undefined" || sClassName.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
	        sReturn=popComp("ClassCatalogInfo","/Common/Configurator/ClassManage/ClassCatalogInfo.jsp","ClassName="+sClassName+"&ClassDescribe="+sClassDescribe,"");
	        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
	        {
			//新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
			{
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
				{
					OpenPage("/Common/Configurator/ClassManage/ClassCatalogList.jsp","_self","");    
		                }
			}
	        }       
	}
    
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
	        as_save("myiframe0","");
	}

    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2()
	{
	        sClassName = getItemValue(0,getRow(),"ClassName");
	        sClassDescribe = getItemValue(0,getRow(),"ClassDescribe");
	        if(typeof(sClassName)=="undefined" || sClassName.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
	        popComp("ClassMethodList","/Common/Configurator/ClassManage/ClassMethodList.jsp","ClassName="+sClassName+"&ClassDescribe="+sClassDescribe,"");        
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sClassName = getItemValue(0,getRow(),"ClassName");
	        if(typeof(sClassName)=="undefined" || sClassName.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('54'))) 
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
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
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

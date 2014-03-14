<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-28
			Tester:
			Content: 财务模型列表
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
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders = {
		{"ObjectType","对象类型"},
		{"ObjectName","对象类型名称"},
		{"SortNo","排序号"},
		{"TreeCode","对象树图"},
		{"PagePath","调用页面"},
		{"ObjectAttribute","对象属性"},
		{"ObjectTable","对应数据表"},
		{"KeyCol","关键字段"},
		{"KeyColName","名称字段"},
		{"ViewType","对象视图组"},
		{"DefaultView","默认视图"},
		{"RightType","权限方法"},
		{"Describe","用途说明"}
	};
	sSql = "select "+
		   "ObjectType,"+
		   "ObjectName,"+
		   "SortNo,"+
		   "TreeCode,"+
		   "PagePath,"+
		   "ObjectAttribute,"+
		   "ObjectTable,"+
		   "KeyCol,"+
		   "KeyColName,"+
		   "ViewType,"+
		   "DefaultView,"+
		   "RightType,"+
		   "UsageDescribe "+
		  "from OBJECTTYPE_CATALOG Where 1=1 order by SortNo";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "OBJECTTYPE_CATALOG";
	doTemp.setKey("ObjectType",true);
	doTemp.setHeader(sHeaders);
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	doTemp.setHTMLStyle("PagePath,ObjectAttribute,ObjectTable"," style={width:300px} ");

 	doTemp.setColumnAttribute("ObjectType,ObjectName,PagePath,SortNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","1+!Configurator.DelObjTypeRelative(#ObjectType)");
	
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
			{"false","","Button","保存","查看/修改详情","as_save('myiframe0')",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"false","","Button","对象类型层级列表","查看/修改对象类型层级列表","viewAndEdit2()",sResourcesPath},
			{"false","","Button","对象属性列表","查看/修改对象属性列表","viewAndEdit3()",sResourcesPath},
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
        sReturn=popComp("ObjTypeCatalogInfo","/Common/Configurator/ObjectManage/ObjTypeCatalogInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //新增数据后刷新列表
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/ObjectManage/ObjTypeCatalogList.jsp","_self","");    
                }
            }
        }
        
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        popComp("ObjectTypeView","/Common/Configurator/ObjectManage/ObjTypeCatalogView.jsp","ObjectNo="+sObjectType,"");
        
	}
    
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2()
	{
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        popComp("ObjTypeLevelList","/Common/Configurator/ObjectManage/ObjTypeLevelList.jsp","ObjectType="+sObjectType,"");
        
	}

    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit3()
	{
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        popComp("ObjTypeAttributeList","/Common/Configurator/ObjectManage/ObjTypeAttributeList.jsp","ObjectType="+sObjectType,"");
        
	}
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
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

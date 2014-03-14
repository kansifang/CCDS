<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cyyu 2009-03-23
			Tester:
			Content: 主菜单管理列表
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
	
	//获得组件参数
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = {
			{"CodeNo","代码编号"},
			{"ItemNo","项目编号"},
			{"ItemName","项目名称"},
			{"SortNo","排序号"},
			{"IsInUse","是否可用"},
			{"ItemDescribe","项目描述"},
			{"ItemAttribute","项目属性"},
			{"RelativeCode","关联代码"},
			{"InputUserName","输入人"},
			{"InputUser","输入人"},
			{"InputOrgName","输入机构"},
			{"InputOrg","输入机构"},
			{"InputTime","输入时间"},
			{"UpdateUserName","更新人"},
			{"UpdateUser","更新人"},
			{"UpdateTime","更新时间"}
	       };  

	sSql = 	" select ItemNo,ItemName,SortNo,getItemName('IsInUse',IsInUse) as IsInUse," +
	" ItemDescribe,ItemAttribute,RelativeCode," +
	" getUserName(InputUser) as InputUserName,InputUser," + 
	" getOrgName(InputOrg) as InputOrgName,InputOrg," +
	" getUserName(UpdateUser) as UpdateUserName,UpdateUser," +
	" InputTime,UpdateTime " +
	" from CODE_LIBRARY where CodeNo='MainMenu' order by ItemNo";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CODE_LIBRARY";
	doTemp.setKey("ItemNo",true);
	doTemp.setHeader(sHeaders);
	
	//设置列表显示
	doTemp.setHTMLStyle("ItemNo,SortNo"," style={width:80px} ");
	doTemp.setHTMLStyle("IsInUse"," style={width:60px} ");
	doTemp.setHTMLStyle("ItemDescribe"," style={width:300px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:120px} ");
 	doTemp.setAlign("IsInUse","2");
	doTemp.setVisible("CodeNo,InputUser,InputOrg,UpdateUser,InputUserName,InputOrgName,UpdateUserName",false);    	

	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	//查询
 	doTemp.setFilter(Sqlca,"1","ItemNo","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"2","ItemName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	
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
			{"true","","Button","启用","启用该条记录","stratRecord()",sResourcesPath},
			{"true","","Button","停用","停用该条记录","stopRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
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
    var sCurFunctionID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        OpenPage("/Common/Configurator/MainMenuManage/MainMenuInfo.jsp","_self","");    
        ReloadSelf();
	}
	
	/*~[Describe=启用记录;InputParam=无;OutPutParam=无;]~*/
	function stratRecord()
	{
		sItemNo = getItemValue(0,getRow(),"ItemNo");
		sIsInUse = getItemValue(0,getRow(),"IsInUse");
		if (typeof(sItemNo) == "undefined" || sItemNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm("您确定启用该菜单项吗？"))
		{	
			sFlag = "1";
            sReturn = RunMethod("Configurator","ChangeState",sItemNo+","+sIsInUse+","+sFlag);
			if(sReturn == "false")
			{
				alert("启用该菜单项失败！");
			}
			else if(sReturn == "1")
			{
				alert("该项目已经是启用状态，不需要再启用！");
			}
			else if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
			    alert("该项目已成功启用！");
			    reloadSelf(); 
			}
		}
	}

	/*~[Describe=停用记录;InputParam=无;OutPutParam=无;]~*/
	function stopRecord()
	{
		sItemNo = getItemValue(0,getRow(),"ItemNo");
		sIsInUse = getItemValue(0,getRow(),"IsInUse");
		if (typeof(sItemNo) == "undefined" || sItemNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm("您确定停用该菜单项吗？"))
		{
			sFlag = "2";
            sReturn = RunMethod("Configurator","ChangeState",sItemNo+","+sIsInUse+","+sFlag);
			if(sReturn == "false")
			{
				alert("停用该菜单项失败！");
			}
			else if(sReturn == "2")
			{
				alert("该项目已经是停用状态，不需要再停用！");
			}
			else if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
			    alert("该项目已成功停用！");
			    reloadSelf(); 
			}
		}
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sItemNo = getItemValue(0,getRow(),"ItemNo");
        if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        OpenPage("/Common/Configurator/MainMenuManage/MainMenuInfo.jsp?ItemNo="+sItemNo,"_self",""); 
        //修改数据后刷新列表
    	ReloadSelf();
	}
    
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		 sItemNo = getItemValue(0,getRow(),"ItemNo");
        if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
    
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

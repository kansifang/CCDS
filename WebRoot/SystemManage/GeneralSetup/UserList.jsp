<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-28
			Tester:
			Content: 用户管理列表
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
	
	//获取组件参数
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sOrgID == null) sOrgID = "";
	String sSortNo="";
	sSortNo=Sqlca.getString("select SortNo from Org_Info where OrgID='"+sOrgID+"'");
	if(sSortNo==null)sSortNo="";
	//获取页面参数
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "UserList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    //filter过滤条件
    doTemp.setColumnAttribute("BelongOrgName,UserName,UserID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20);

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql);
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
		String sButtons[][] = 
	        {
	            {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","新增","在当前机构中新增人员","my_add()",sResourcesPath},			
		{"false","","Button","引入","引入人员至当前机构","my_import()",sResourcesPath},
	            {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","停用","从当前机构中删除该人员","my_del()",sResourcesPath}, 
	            {"true","","Button","详情","查看用户详情","viewAndEdit()",sResourcesPath},
	            {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","用户角色","查看并可修改人员角色","viewAndEditRole()",sResourcesPath},
	           // {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","批量更新角色","批量更新角色","my_Addrole()",sResourcesPath},
		//{((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","多用户更新角色","多用户更新角色","MuchAddrole()",sResourcesPath},
	           // {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","用户权限","查看并可修改人员权限","viewAndEditRight()",sResourcesPath},
	           // {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","转移","转移人员至其他机构","UserChange()",sResourcesPath},                       
	            {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","初始密码","初始化该用户密码","ClearPassword()",sResourcesPath}            
	            
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
	
	/*~[Describe=在当前机构中新增人员;InputParam=无;OutPutParam=无;]~*/
	function my_add()
    {   
		OpenPage("/SystemManage/GeneralSetup/UserInfo.jsp","_self","");
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sUserID = getItemValue(0,getRow(),"UserID");
		if (typeof(sUserID)=="undefined" || sUserID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/SystemManage/GeneralSetup/UserInfo.jsp?UserID="+sUserID,"_self","");
		}
	}

	/*~[Describe=查看并可修改人员角色;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditRole()
    {
        sUserID=getItemValue(0,getRow(),"UserID");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0)
        { 
            alert(getHtmlMessage('1'));//请选择一条信息！
        }else
        {
        	sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"非正常用户，无法查看用户角色！");
        	else
            	sReturn=popComp("UserRoleList","/SystemManage/GeneralSetup/UserRoleList.jsp","UserID="+sUserID,"");
        }    
    }
    
    /*~[Describe=批量更新角色;InputParam=无;OutPutParam=无;]~*/    
    function my_Addrole()
	{
	    sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0)
    	{ 
		    alert(getHtmlMessage('1'));//请选择一条信息！
    	}
    	else
    	{
        	sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"非正常用户，无法批量更新角色！");
        	else
        		PopPage("/SystemManage/GeneralSetup/AddUserRole.jsp?UserID="+sUserID,"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
    	}
	}
	
	/*~[Describe=多用户更新角色;InputParam=无;OutPutParam=无;]~*/
	function MuchAddrole()
	{
	    sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0)
    	{ 
		    alert(getHtmlMessage('1'));//请选择一条信息！
    	}
    	else
    	{
    		sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"非正常用户，无法多用户更新角色！");
        	else
        		PopPage("/SystemManage/GeneralSetup/AddMuchUserRole.jsp?UserID="+sUserID,"","dialogWidth=36;dialogHeight=37;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
		}
	}
    
    /*~[Describe=查看并可修改人员权限;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditRight()
    {
        sUserID=getItemValue(0,getRow(),"UserID");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0)
        { 
            alert(getHtmlMessage('1'));//请选择一条信息！
        }else
        {            
            popComp("RightView","/SystemManage/GeneralSetup/RightView.jsp","ObjectNo=USER@"+sUserID,"","");
        }    
    }

	/*~[Describe=转移人员至其他机构;InputParam=无;OutPutParam=无;]~*/
	function UserChange()
	{
        sUserID = getItemValue(0,getRow(),"UserID");
        sFromOrgID = getItemValue(0,getRow(),"BelongOrg");
        sFromOrgName = getItemValue(0,getRow(),"BelongOrgName");
        
        var sReturnValue ="";
        if(typeof(sUserID)=="undefined" ||sUserID.length==0)
        { 
            alert(getHtmlMessage('1'));//请选择一条信息！
        }else
        {	
            //获取当前用户
			sOrgID = "<%=CurOrg.OrgID%>";			
			sParaStr = "OrgID,"+sOrgID;
			sOrgInfo = setObjectValue("SelectBelongOrg",sParaStr,"",0,0);	
		    if(sOrgInfo == "" || sOrgInfo == "_CANCEL_" || sOrgInfo == "_NONE_" || sOrgInfo == "_CLEAR_" || typeof(sOrgInfo) == "undefined") 
		    {
			    if( typeof(sOrgInfo) != "undefined"&&sOrgInfo != "_CLEAR_")alert(getBusinessMessage('953'));//请选择转移后的机构！
			    return;
		    }else
		    {
			    sOrgInfo = sOrgInfo.split('@');
			    sToOrgID = sOrgInfo[0];
			    sToOrgName = sOrgInfo[1];
			    
			    if(sFromOrgID == sToOrgID)	
				{
					alert(getBusinessMessage('954'));//不允许人员转移在同一机构中进行，请重新选择转移后机构！
					return;
				}
				//调用页面更新
				sReturn = PopPage("/SystemManage/SynthesisManage/UserShiftAction.jsp?UserID="+sUserID+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&ToOrgID="+sToOrgID+"&ToOrgName="+sToOrgName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
				if(sReturn == "TRUE")	            
	            {
	                alert(getBusinessMessage("914"));//人员转移成功！
	                reloadSelf();           	
	            }else if(sReturn == "FALSE")
	            {
	                alert(getBusinessMessage("915"));//人员转移失败！
	            }
			}   
		}
	}
	

	/*~[Describe=引入人员至当前机构;InputParam=无;OutPutParam=无;]~*/
	function my_import()
	{       	
       	sParaString = "BelongOrg"+","+"<%=sOrgID%>";		
		sUserInfo = setObjectValue("SelectImportUser",sParaString,"",0,0,"");
		if(typeof(sUserInfo) != "undefined" && sUserInfo != "" && sUserInfo != "_NONE_" 
		&& sUserInfo != "_CANCEL_" && sUserInfo != "_CLEAR_") 
		{
       		sInfo = sUserInfo.split("@");
	        sUserID = sInfo[0];
	        sUserName = sInfo[1];
	        if(typeof(sUserID) != "undefined" && sUserID != "")
	        {
	        	if(confirm(getBusinessMessage("912")))//您确定将所选人员引入到本机构中吗？
	        	{
	        		PopPage("/SystemManage/GeneralSetup/AddUserAction.jsp?UserID="+sUserID+"&OrgID=<%=sOrgID%>","","");
	        		alert(getBusinessMessage("913"));//人员引入成功！
	        		reloadSelf();
	        	}
	        }			
       	}
	}
	

	/*~[Describe=从当前机构中删除该人员;InputParam=无;OutPutParam=无;]~*/
	function my_del()
    {   
		sUserID = getItemValue(0,getRow(),"UserID");
		if (typeof(sUserID) == "undefined" || sUserID.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm("您真的想停用该用户吗？"))//您真的想删除该信息吗？
		{
            sReturn = RunMethod("Configurator","DeleteUser",sUserID);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
			    alert("信息停用成功！");//信息删除成功！
			    reloadSelf(); 
			}
		}
	}
	
	/*~[Describe=初始化用户密码为1;InputParam=无;OutPutParam=无;]~*/
	function ClearPassword()
	{
        sUserID = getItemValue(0,getRow(),"UserID");
        if (typeof(sUserID)=="undefined" || sUserID.length==0)
		{
		    alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getBusinessMessage("916"))) //您确定要初始化该用户的密码吗？
		{
		    PopPage("/SystemManage/GeneralSetup/ClearPasswordAction.jsp?UserID="+sUserID,"","dialogWidth:320px;dialogHeight:270px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
		    alert(getBusinessMessage("917"));//用户密码初始化成功！
		    reloadSelf();
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

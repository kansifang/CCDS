<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: 
			Input Param:
	                    RoleID：    代码表编号
	                    ItemNo：    项目编号（新增是不传入）
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
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	
	//获得页面参数	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String sHeaders[][] = {     
						{"ApplyType","申请类型"},
						{"ObjectType","对象类型"},
	                            {"ObjectNo","业务流水号"},
	                            {"FlowNo","流程号"},
	                            {"FlowName","流程名"}, 
	                            {"PhaseType","阶段类型"},
                                {"PhaseNo","阶段号"},
                                {"PhaseName","阶段名"},
                                {"OrgID","申请机构"},
	                            {"OrgName","申请机构"},
	                            {"UserID","申请人"},
	                            {"UserName","申请人"},
	                            {"InputDate","申请日期"}
					};    	  		   		
	
	
	sSql = " select ApplyType,ObjectType,ObjectNo,FlowNo,FlowName,"+
	  " PhaseType,PhaseNo,PhaseName,"+
              " OrgID,OrgName,UserID,UserName,InputDate"+
              " from Flow_Object " +
              " where ObjectType='"+sObjectType+"'"+
              " and ObjectNo = '"+sObjectNo+"'";
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "Flow_Object";
	doTemp.setKey("ObjectType,ObjectNo",true);	 //为后面的删除

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	String sCriteriaAreaHTML = "";
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
			{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表","doReturn()",sResourcesPath}
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
    var sCurRoleID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
       as_save("myiframe0","");
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(){
		//sObjectNo = getItemValue(0,getRow(),"RoleID");
		//parent 为 OpenCompDialog.jsp 里面有很多方法可用
        //parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.sObjectInfo = "OK";
		parent.closeAndReturn();
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
            setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
            setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
            bIsInsert = true;
		}
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
	initRow();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

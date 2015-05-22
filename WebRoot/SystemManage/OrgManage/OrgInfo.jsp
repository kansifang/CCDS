<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: 代码表信息详情
			Input Param:
	                    OrgID：机构编号
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
	
	//获得页面参数	
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	if(sOrgID == null) sOrgID = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "OrgInfo2";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
    //设置上级机构选择方式
    doTemp.setUnit("RelativeOrgName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getOrgName();\"> ");
	doTemp.setHTMLStyle("RelativeOrgName","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getOrgName()\" ");
	//显示排序号并设置为必输项            add by xlsun  Date in 2013-07-31
	if(CurUser.hasRole("000")){
		doTemp.setVisible("SortNo",true);
		doTemp.setRequired("SortNo",true);
	}
	//filter过滤条件
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//暂时屏蔽，上线以后放开，防止保存对org_belong造成数据丢失
	//if(!sOrgID.equals(""))//--added by wwhe 2006-11-22 for:放开屏蔽
	//	dwTemp.ReadOnly = "1";
		
	
	//定义后续事件
	dwTemp.setEvent("AfterInsert","!SystemManage.AddOrgBelong(#OrgID,#OrgLevel,#SortNo,#RelativeOrgID)");
	dwTemp.setEvent("AfterUpdate","!SystemManage.AddOrgBelong(#OrgID,#OrgLevel,#SortNo,#RelativeOrgID)");
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sOrgID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{"true","","Button","返回","返回到列表界面","doReturn()",sResourcesPath}		
			};
		
		//暂时屏蔽，上线以后放开，防止保存对org_belong造成数据丢失
		
		if(!sOrgID.equals(""))//--added by wwhe 2006-11-22 for:放开屏蔽
		{
			sButtons[0][0]="true";
		}
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
    var sCurOrgID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		var sOrgID = getItemValue(0,getRow(),"OrgID");
		var sReturn1 = RunMethod("SystemManage","CheckOrgID",sOrgID);
		if(sReturn1>0)
		{
			if(confirm("确实要更新机构信息吗？")){
			}else{
				return;
			}
		}
	    setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
        as_save("myiframe0","");
        
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
    	var sObjectNo = getItemValue(0,getRow(),"OrgID");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
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
	
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getOrgName()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
		
		if (typeof(sOrgID) == 'undefined' || sOrgID.length == 0) 
        {
        	alert("请输入机构编号！");
        	return;
        }
		if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0) 
        {
        	alert("请选择级别！");
        	return;
        }
		sParaString = "OrgID"+","+sOrgID+","+"OrgLevel"+","+sOrgLevel;		
		setObjectValue("SelectOrg2",sParaString,"@RelativeOrgID@0@RelativeOrgName@1",0,0,"");
		
	}
	
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getAllOrgName(flag)
	{
		sParaString = "";		
		setObjectValue("SelectAllOrg",sParaString,"@ManageDepartOrgID"+flag+"@0@ManageDepartOrgID"+flag+"Name@1",0,0,"");
	}
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
            setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
            setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
            setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
            //setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
            //setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
            //setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
            //setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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

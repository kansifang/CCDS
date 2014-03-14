<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
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
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
		
	//获得组件参数	
	
	//获得页面参数	
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CurOrgID"));
	if(sOrgID == null) sOrgID = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "OrgInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
    //设置上级机构选择方式
    doTemp.setUnit("RelativeOrgName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getOrgName();\"> ");
	doTemp.setHTMLStyle("RelativeOrgName","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getOrgName()\" ");
	doTemp.appendHTMLStyle("OrgID,SortNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
	//filter过滤条件
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//定义后续事件
	//dwTemp.setEvent("AfterInsert","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//dwTemp.setEvent("AfterUpdate","!SystemManage.AddOrgBelong(#OrgID,#RelativeOrgID)");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sOrgID);
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
			{(CurUser.hasRole("099")?"true":"false"),"","Button","保存","保存修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回到列表界面","doReturn()",sResourcesPath}		
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
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
    var sCurOrgID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		//机构号变更，检测是否有重复机构号
		if(sOrgID!="<%=sOrgID%>"){
			sReturn=RunMethod("PublicMethod","GetColValue","OrgID,ORG_INFO,String@OrgID@"+sOrgID);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert("所输入的机构号已被使用！");
				return;
			}
		}
	    sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
	    if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0) 
        {
        	alert(getBusinessMessage("901"));//请选择级别！
        	return;
        }else
        {
        	if(sOrgLevel != '0')
        	{
        		sRelativeOrgName = getItemValue(0,getRow(),"RelativeOrgName");
			    if (typeof(sRelativeOrgName) == 'undefined' || sRelativeOrgName.length == 0) 
		        {
		        	alert("请选择上级机构！");
		        	return;
		        }
        	}
        }
	    setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
        as_save("myiframe0","");
        
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(){
		OpenPage("/SystemManage/GeneralSetup/OrgList.jsp","_self","");
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getOrgName()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
		
		if (typeof(sOrgID) == 'undefined' || sOrgID.length == 0) 
        {
        	alert(getBusinessMessage("900"));//请输入机构编号！
        	return;
        }
		if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0) 
        {
        	alert(getBusinessMessage("901"));//请选择级别！
        	return;
        }
		sParaString = "OrgID"+","+sOrgID+","+"OrgLevel"+","+sOrgLevel;		
		setObjectValue("SelectOrg",sParaString,"@RelativeOrgID@0@RelativeOrgName@1",0,0,"");
		
	}
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
            setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
            setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
            bIsInsert = true;
		}
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=页面装载时，进行初始化;]~*/
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

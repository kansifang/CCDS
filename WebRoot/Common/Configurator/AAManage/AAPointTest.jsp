<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content: 流程授权测试页面
			Input Param:
			
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
		String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
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

	//获得页面参数	
	String sPolicyID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PolicyID",10));
	String sAuthID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthID",10));
	//将空值转化为空字符串
	if(sPolicyID == null) sPolicyID = "";
	if(sAuthID == null) sAuthID = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders = {														
					{"PolicyName","授权方案"},
					{"FlowName","流程"},
					{"PhaseName","阶段"},							
					{"ObjectType","对象类型"},
					{"ObjectNo","对象编号"},
					{"OrgName","审批机构"},
					{"UserName","审批人员"},
				  };
	//通过显示模版产生ASDataObject对象doTemp
	sSql = 	" select getPolicyName(PolicyID) as PolicyName,FlowNo, "+
	" getFlowName(FlowNo) as FlowName,PhaseNo, "+
	" getPhaseName(FlowNo,PhaseNo) as PhaseName, "+
	" '' as ObjectType,'' as ObjectNo,getOrgName(OrgID) as OrgName, "+
	" OrgID,'' as UserName,'' as UserID "+
	" from AA_AUTHPOINT "+
	" where AuthID='"+sAuthID+"' "+
	" and PolicyID='"+sPolicyID+"' ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "AA_AUTHPOINT";
	doTemp.setKey("AuthID,PolicyID",true);
	doTemp.setHeader(sHeaders);
	//设置不可见	
	doTemp.setVisible("FlowNo,PhaseNo,OrgID,UserID",false);
	doTemp.setUnit("ObjectType","（例如：申请－CreditApply；最终审批意见－ApproveApply；合同－BusinessContract；......）");
	doTemp.setUnit("ObjectNo","（例如：申请流水号；最终审批意见流水号；合同流水号；......）");
	doTemp.setUnit("UserName"," <input type=button value=.. onclick=parent.selectUser()>");
	doTemp.setReadOnly("PolicyName,FlowName,PhaseName,",true);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
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
			{"true","","Button","测试","测试","testAuthPoint()",sResourcesPath},
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
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=测试;InputParam=无;OutPutParam=无;]~*/
    function testAuthPoint()
    {
    	var sObjectType = getItemValue(0,0,"ObjectType");
    	var sObjectNo = getItemValue(0,0,"ObjectNo");
    	var sFlowNo = getItemValue(0,0,"FlowNo");
    	var sPhaseNo = getItemValue(0,0,"PhaseNo");
    	var sOrgID = getItemValue(0,0,"OrgID");
    	var sUserID = getItemValue(0,0,"UserID");
    	if(sObjectType == "" || sObjectNo == ""){
    		alert("请先指定一笔测试业务。");
    		return;
    	}
    	PopPage("/Common/Configurator/AAManage/AAPointTestAction.jsp?AuthID=<%=sAuthID%>&PolicyID=<%=sPolicyID%>&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&OrgID="+sOrgID+"&UserID="+sUserID,"","");
    }
    
    /*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser()
	{
		var sOrgID = getItemValue(0,0,"OrgID");
		//返回客户的相关信息、用户代码、用户名称	
		sParaString = "BelongOrg"+","+sOrgID;
		setObjectValue("SelectUserBelongOrg",sParaString,"@UserID@0@UserName@1",0,0,"");	
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
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

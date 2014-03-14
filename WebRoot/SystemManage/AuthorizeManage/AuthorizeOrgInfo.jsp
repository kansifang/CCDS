<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: wwhe	2006-09-04
			Tester:
			Describe: 机构授权维护
			Input Param:
					OrgID:		机构号
					RoleID:		角色号
					ObjectNo:	授权方案序列号
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
		String PG_TITLE = "业务品种确定"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	
	//获得页面参数
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	String sRoleID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RoleID"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	//将空值转化为空字符串
	if(sOrgID == null) sOrgID = "";
	if(sRoleID == null) sRoleID = "";
	if(sObjectNo == null) sObjectNo = "";
	
	String sAType= DataConvert.toRealString(iPostChange,(String)CurComp.compParentComponent.getParameter("AType"));//added bllou 2011-09-08 增加对客户的特别授权
	if(sAType==null)sAType="NotSpecial";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"OrgID","授权机构"},
						{"RoleID","角色名称"},
						{"ObjectNo","授权名称"},
						{"CustomerName","特别授权客户名称"},
						{"UserID","人员号"},
						{"AuthorizeOrgLevel","人员角色级别"},
						{"FlowNo","流程名称"},
						{"PhaseNo","流程阶段"},
						{"NextPhaseNo","流程下阶段编号"},
						{"OperateCode1","全额单户金额运算符"},
						{"Balance1","全额单户金额"},
						{"OperateCode2","全额单笔金额运算符"},
						{"Balance2","全额单笔金额"},
						{"OperateCode3","敞口单户金额运算符"},
						{"Balance3","敞口单户金额"},
						{"OperateCode4","敞口单笔金额运算符"},
						{"Balance4","敞口单笔金额"},
						{"InputOrgName","录入机构"},
						{"InputUserName","录入人员"},
						{"InputDate","登记日期"},
						{"Remark","备注"},
						{"FinalOrgName","授权机构"}
		   				};		   		
		//added bllou 2011-09-08 增加对客户的特别授权
		if("Special".equals(sAType)){
			sHeaders[2][1]="特别授权客户编号";
		}
		sSql =  " select OrgID,getOrgName(OrgID) as FinalOrgName,RoleID,"+
		("Special".equals(sAType)?" ObjectNo,getCustomerName(ObjectNo) as CustomerName,":"ObjectNo,")+
		" UserID,AuthorizeOrgLevel,FlowNo,PhaseNo,NextPhaseNo,OperateCode1,Balance1, "+
		" OperateCode2,Balance2,OperateCode3,Balance3,OperateCode4,Balance4,InputOrgID, "+
		" InputUserID,InputDate,Remark,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName "+
		" from AUTHORIZE_ORG "+
		" where OrgID = '"+sOrgID+"' "+
		" and RoleID = '"+sRoleID+"' "+
		" and ObjectNo = '"+sObjectNo+"' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		
		doTemp.UpdateTable = "AUTHORIZE_ORG";
		doTemp.setKey("OrgID,RoleID,ObjectNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName,FinalOrgName",false);
		doTemp.setCheckFormat("Balance1,Balance2,Balance3,Balance4","2");
		doTemp.setCheckFormat("InputDate","3");
		doTemp.setType("Balance1,Balance2,Balance3,Balance4","Number");
		doTemp.setRequired("OrgID,RoleID,ObjectNo,OperateCode1,OperateCode2,Balance1,Balance2,FinalOrgName",true);
		doTemp.setReadOnly("InputOrgName,InputUserName,InputDate,FinalOrgName",true);
		doTemp.setVisible("AuthorizeOrgLevel,InputOrgID,InputUserID,UserID,FlowNo,PhaseNo,NextPhaseNo,OperateCode3,Balance3,OperateCode4,Balance4,OrgID",false);
		doTemp.setEditStyle("Remark","3");
		doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px} ");
		doTemp.setDDDWCode("OperateCode1,OperateCode2,OperateCode3,OperateCode4","MathMark");
		doTemp.setDDDWCode("AuthorizeOrgLevel","AuthorizeOrgLevel");
		//doTemp.setDDDWSql("OrgID","select OrgID,OrgName from org_info where OrgID in(select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') order by sortno");
		doTemp.setDDDWSql("RoleID","select RoleID,RoleName from ROLE_INFO where RoleStatus='1' order by RoleID");
		doTemp.setUnit("FinalOrgName"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectFinalOrg()>");
		//added bllou 2011-09-08 增加对客户的特别授权
		if("Special".equals(sAType)){
			doTemp.setRequired("OperateCode1,OperateCode2,Balance1,Balance2",false);
			doTemp.setUnit("CustomerName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectCustomer()>");
			doTemp.setReadOnly("ObjectNo",true);
			doTemp.setUpdateable("CustomerName",false);
		}else{
			doTemp.setDDDWSql("ObjectNo","select SerialNo,AuthorizeName from AUTHORIZE_ROLE order by 2");
		}

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置为Grid风格
		
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
			{"true","","Button","保存","保存信息","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回","goBack()",sResourcesPath}
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
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sRoleID = getItemValue(0,getRow(),"RoleID");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		
		//判断机构和人员角色级别是否一致 added by hysun 2006.10.26
		/*sAuthorizeOrgLevel = getItemValue(0,getRow(),"AuthorizeOrgLevel");
		sOrgIDLevel = RunMethod("授权管理","判断机构和人员角色",sOrgID);//返回机构级别OrgLevel
		
		if(sAuthorizeOrgLevel.substring(0,2)=="00")//支行审批权
		{
			if(sOrgIDLevel=="6")
			{
				if(sRoleID.substring(0,1)=="4")
				{	
				}else
				{alert("请检查机构、角色、级别是否正确！");return;}
			}else
			{alert("请检查机构、角色、级别是否正确！");return;}
		}else if(sAuthorizeOrgLevel.substring(0,2)=="01")//分行审批权
		{
			if(sOrgIDLevel=="3")
			{
				if(sRoleID.substring(0,1)=="2")
				{	
				}else
				{alert("请检查机构、角色、级别是否正确！");return;}
			}else
			{alert("请检查机构、角色、级别是否正确！");return;}
		}else if(sAuthorizeOrgLevel.substring(0,2)=="02")//总行审批权
		{
			if(sOrgIDLevel=="0")
			{
				if(sRoleID.substring(0,1)=="0")
				{	
				}else
				{alert("请检查机构、角色、级别是否正确！");return;}
			}else
			{alert("请检查机构、角色、级别是否正确！");return;}
		}
		*/
		//finished adding by hysun

		sReturnValue = RunMethod("授权管理","判断机构授权是否存在",sOrgID+","+sRoleID+","+sObjectNo);
		if(sReturnValue>0 && bIsInsert==true){
			alert("该机构角色已存在此授权方案，请重新选择机构角色或授权方案！");
			return false;
		}
		as_save("myiframe0",sPostEvents);
	}
	

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
	}
	
	/*~[Describe=选择支行机构;InputParam=无;OutPutParam=无;]~*/
	function selectFinalOrg()
	{
			
		//setObjectValue("SelectSubOrg",sParaString,"@FinalOrg@0@FinalOrgName@1",0,0,"");
		setObjectValue("SelectAllOrg","","@OrgID@0@FinalOrgName@1",0,0,"");
		
	}
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{			
		var sReturn=setObjectValue("SelectAllCustomer","","@ObjectNo@0@CustomerName@1",0,0,"");
		//var aReturn=sReturn.split("@");
		//setItemValue(0,getRow(),"ObjectNo","CID"+aReturn[0]);
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>
	<script language=javascript>	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{	
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			
			bIsInsert = true;
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
	initRow();
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

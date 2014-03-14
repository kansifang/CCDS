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
	String sSql = "";
	
	//获得页面参数：担保方式、担保信息编号
	
 	//将空值转化为空字符串
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"OrgName","授权机构"},
						{"RoleName","人员角色"},
						{"ObjectNo","授权序列号"},
						{"AuthorizeName","授权名称"},
						{"AuthorizeOrgLevel","授权级别"},
						{"AuthorizeOrgLevelName","授权级别"},
						{"UserID","人员号"},
						{"FlowNo","流程名称"},
						{"PhaseNo","流程阶段"},
						{"NextPhaseNo","流程下阶段编号"},
						{"OperateCode1","授权单户金额运算符"},
						{"OperateCode1Name","授权单户金额运算符"},
						{"Balance1","授权单户金额"},
						{"OperateCode2","全额单笔金额运算符"},
						{"OperateCode2Name","全额单笔金额运算符"},
						{"Balance2","单笔金额"},
						{"OperateCode3Name","敞口单户金额运算符"},
						{"Balance3","敞口单户金额"},
						{"OperateCode4Name","敞口单笔金额运算符"},
						{"Balance4","敞口单笔金额"},
						{"InputOrgName","录入机构"},
						{"InputUserName","录入人员"},
						{"InputDate","登记日期"},
						{"Remark","备注"},
						{"OrgID","授权机构"},
						{"RoleID","授权角色"},
						{"AuthorizeTypeName","授权类型"}
		   				};		   		
		
		sSql =  " select AO.OrgID,getOrgName(AO.OrgID) as OrgName,AO.RoleID,getRoleName(AO.RoleID) as RoleName, "+
		" AO.ObjectNo,AR.AuthorizeName,AO.OperateCode1,getItemName('OperateCode',AO.OperateCode1) as OperateCode1Name, "+
		" AO.Balance1,getItemName('OperateCode',AO.OperateCode2) as OperateCode2Name,AO.OperateCode2,AO.Balance2, "+
		" AR.AuthorizeType,getItemName('AuthorizeType',AuthorizeType) as AuthorizeTypeName, "+
		" AO.AuthorizeOrgLevel,getItemName('AuthorizeOrgLevel',AO.AuthorizeOrgLevel) as AuthorizeOrgLevelName, "+
		" AO.UserID,AO.FlowNo,AO.PhaseNo,AO.NextPhaseNo, "+
		" getItemName('OperateCode',AO.OperateCode3) as OperateCode3Name,AO.OperateCode3,AO.Balance3, "+
		" getItemName('OperateCode',AO.OperateCode4) as OperateCode4Name,AO.OperateCode4,AO.Balance4, "+
		" AO.InputOrgID,AO.InputUserID,getOrgName(AO.InputOrgID) as InputOrgName,getUserName(AO.InputUserID) as InputUserName,AO.InputDate,AO.Remark  "+
		" from AUTHORIZE_ORG AO,AUTHORIZE_ROLE AR "+
		" where AO.ObjectNo = AR.SerialNo "+
		" and AO.OrgID in (select BelongOrgId from ORG_BELONG where OrgID='"+CurOrg.OrgID+"')"+
		" order by OrgID,AuthorizeType,AuthorizeName,AuthorizeOrgLevel ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "AUTHORIZE_ORG";
		doTemp.setKey("OrgID,RoleID,ObjectNo",true);
		doTemp.setUpdateable("AuthorizeOrgLevelName,OrgName,RoleName,OperateCode1Name,OperateCode2Name,OperateCode3Name,OperateCode4Name,AuthorizeTypeName",false);
		doTemp.setVisible("OrgID,RoleID,UserID,AuthorizeOrgLevel,FlowNo,PhaseNo,NextPhaseNo,OperateCode3,OperateCode4,Balance3,Balance4,OperateCode3Name,OperateCode4Name,InputOrgID,InputUserID,Remark,AuthorizeType,OperateCode1,OperateCode2",false);
		doTemp.setReadOnly("",true);
		doTemp.setReadOnly("Balance3,Balance4,OperateCode1,OperateCode2",false);
		doTemp.setType("Balance1,Balance2,Balance3,Balance4","Number");
		doTemp.setHTMLStyle("AuthorizeName"," style={width:250px} ");
		doTemp.setHTMLStyle("RoleName"," style={width:200} ");
		//doTemp.setDDDWSql("OperateCode1,OperateCode2","select ItemNo,ItemName from code_library where codeno='OperateCode' and ItemNo in ('01','02','03')");
		
		//增加过滤器	
		doTemp.setDDDWSql("OrgID","select OrgID,OrgName from ORG_INFO where OrgID in (select BelongOrgId from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') and (OrgName like '%审批中心%' or OrgName like '%营业%' or OrgName like '%行长%' or OrgName like '%贷%' or OrgName like '%小企业%' or OrgName like '%支行%') order by SortNo");
		doTemp.setDDDWSql("RoleID","select RoleID,RoleName from ROLE_INFO where (RoleName like '%行领导%' or RoleName like '%审批中心%' or RoleName like '%贷审%' or RoleName like '%小企业部审批员%') and RoleID not in ('260','282','236','235','035','036') order by 1");
		doTemp.setDDDWCode("AuthorizeOrgLevel","AuthorizeOrgLevel");
		//doTemp.setDDDWSql("ObjectNo","select Serialno,AuthorizeName from AUTHORIZE_ROLE order by 1");
		
		doTemp.setColumnAttribute("OrgID,RoleID,AuthorizeOrgLevel,ObjectNo,AuthorizeName","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

		if(!doTemp.haveReceivedFilterCriteria())
		 doTemp.WhereClause+=" and 1=2";
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //设置为Grid风格
		dwTemp.setPageSize(207);  //服务器分页
		//dwTemp.ReadOnly = "1"; //设置为只读
		
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
			{"false","","Button","新增机构授权(批量)","批量新增机构授权","batchRecord()",sResourcesPath},
			{"false","","Button","新增机构授权(单笔)","单笔新增机构授权","singletonRecord()",sResourcesPath},
			{"false","","Button","修改/查看机构授权","修改/查看机构授权","editRecord()",sResourcesPath},
			{"false","","Button","删除机构授权","删除机构授权","delRecord()",sResourcesPath},
			{"false","","Button","保存金额修改","保存金额修改","saveRecord()",sResourcesPath},
			{"true","","Button","导出为Excel","导出为Excel","exportAll()",sResourcesPath}
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
	/*~[Describe=批量新增机构授权;InputParam=无;OutPutParam=无;]~*/
	function batchRecord()
	{
		var sInputOrgID = "<%=CurOrg.OrgID%>";
		var sInputUserID = "<%=CurUser.UserID%>";
		var sReturnValue = PopPage("/SystemManage/AuthorizeManage/AddAuthorizeOrgDialog.jsp","","resizable=yes;dialogWidth=30;dialogHeight=13;center:yes;status:no;statusbar:no");
		
		sReturnValue = sReturnValue.split('@');
		//var sAuthorizeNo = sReturnValue[0];
		var sAuthorizeType = sReturnValue[0];
		var sAuthorizeOrgLevel = sReturnValue[1];
		var sOrgID = sReturnValue[2];
		var sRoleID = sReturnValue[3];
		//sAuthorizeOrgLevel授权级别前两位：00 支行审批权，01 分行审批权，02 总行审批权
		//sRoleID角色第一位:0 总行角色,2 分行角色,4 支行角色
		//sOrgID机构级别：0,3,6
		var sOrgIDLevel = RunMethod("审批流程","取申请机构级别",sOrgID);
		//判断批量增加授权级别、角色、机构是否正确
		
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
		
		//sAuthorizeOrgLevel = sAuthorizeOrgLevel.substr(1,1);

		if(typeof(sOrgID)!="undefined" && sOrgID.length!=0 && sOrgID != "_CANCEL_")
		{
			//sReturnValue = RunMethod("授权管理","批量新增机构授权",sAuthorizeNo+","+sOrgID+","+sAuthorizeOrgLevel+","+sRoleID+","+sInputOrgID+","+sInputUserID);
			sReturnValue = RunMethod("授权管理","批量新增机构授权",sAuthorizeType+","+sOrgID+","+sAuthorizeOrgLevel+","+sRoleID+","+sInputOrgID+","+sInputUserID);
			//if(sReturnValue == "true")
			//{	
				alert("新增机构授权成功！");	
				reloadSelf();
			//}
		}
		else
			alert("新增机构授权没有成功！");	
	}
	
	/*~[Describe=单笔新增机构授权;InputParam=无;OutPutParam=无;]~*/
	function singletonRecord()
	{
		sCompID = "AuthorizeOrgInfo";
		sCompURL = "/SystemManage/AuthorizeManage/AuthorizeOrgInfo.jsp";
		sParamString = "";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
		//OpenPage("/SystemManage/AuthorizeManage/AuthorizeOrgInfo.jsp","right");
	}
	
	/*~[Describe=修改/查看机构授权;InputParam=无;OutPutParam=无;]~*/
	function editRecord()
	{
		var sOrgID = getItemValue(0,getRow(),"OrgID");			//--机构号
		var sRoleID = getItemValue(0,getRow(),"RoleID");		//--角色号
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");	//--授权方案序列号
		if(typeof(sOrgID)=="undefined" || sOrgID.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		sCompID = "AuthorizeOrgInfo";
		sCompURL = "/SystemManage/AuthorizeManage/AuthorizeOrgInfo.jsp";
		sParamString = "OrgID="+sOrgID+"&RoleID="+sRoleID+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
		//OpenComp("/SystemManage/AuthorizeManage/AuthorizeOrgInfo.jsp?OrgID="+sOrgID+"&RoleID="+sRoleID+"&ObjectNo="+sObjectNo,"right");
	}
	
	/*~[Describe=删除机构授权;InputParam=无;OutPutParam=无;]~*/
	function delRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
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
	
	function exportAll(){
		amarExport("myiframe0");
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

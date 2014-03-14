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
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
	//将空值转化为空字符串
	if(sOrgID == null) sOrgID = "";
	if(sRoleID == null) sRoleID = "";
	if(sSerialNo == null) sSerialNo = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"SerialNo","授权序列号"},
						{"OrgID","授权机构"},
						{"RoleID","人员角色"},
						{"OrgName","授权机构"},
						{"RoleName","人员角色"},
						{"OperateCode1","信用评级运算符"},
						{"EvaluateLevel","信用评级等级"},
						{"IsJudgeCredit","是否判断在途授信额度"},
						{"OperateCode2","授信额度运算符"},
						{"CreditSum","授信额度"},
						{"InputOrgName","录入机构"},
						{"InputUserName","录入人员"},
						{"InputDate","登记日期"},
						{"Remark","备注"},
		   				};		   		
		
		sSql =  " select SerialNo,OrgID,RoleID,OperateCode1,EvaluateLevel, "+
		" IsJudgeCredit,OperateCode2,CreditSum,Remark, "+
		" InputUserID,getUserName(InputUserID) as InputUserName,InputOrgID,getOrgName(InputOrgID) as InputOrgName,InputDate "+
		" from EVALUATE_AUTHORIZE "+
		" where OrgID = '"+sOrgID+"' "+
		" and RoleID = '"+sRoleID+"' "+
		" and SerialNo = '"+sSerialNo+"' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		
		doTemp.UpdateTable = "EVALUATE_AUTHORIZE";
		doTemp.setKey("OrgID,RoleID,SerialNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName",false);
		doTemp.setCheckFormat("CreditSum","2");
		doTemp.setCheckFormat("InputDate","3");
		doTemp.setType("CreditSum","Number");
		doTemp.setRequired("OrgID,RoleID,IsJudgeCredit",true);
		doTemp.setReadOnly("SerialNo,InputOrgName,InputUserName,InputDate",true);
		doTemp.setVisible("InputOrgID,InputUserID,UserID",false);
		doTemp.setEditStyle("Remark","3");
		doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px} ");
		doTemp.setDDDWCode("OperateCode1,OperateCode2","OperateCode");
		doTemp.setDDDWSql("IsJudgeCredit","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'YesNo' and isinuse = '1' order by 1 desc");
		doTemp.setDDDWSql("OrgID","select OrgID,OrgName from org_info where OrgID in(select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') order by sortno");
		doTemp.setDDDWSql("RoleID","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeEvaluateRoleID' and isinuse = '1' order by 1 desc");
		doTemp.setDDDWSql("EvaluateLevel","select ItemNo,ItemName from code_library where codeno='CreditLevel' and isinuse='1' order by 1");
		
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
	function saveRecord()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sRoleID = getItemValue(0,getRow(),"RoleID");
		
		sReturnValue = RunMethod("授权管理","判断评级授权是否存在",sOrgID+","+sRoleID);
		if(sReturnValue>0 && bIsInsert==true){
			alert("该机构角色已存在此授权方案，请重新选择机构角色或授权方案！");
			return false;
		}
		
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0");
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>
	<script language=javascript>	
	
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{	
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
    }
    
    function initSerialNo() 
	{
		var sTableName = "EVALUATE_AUTHORIZE";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "EA";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		if(typeof(sSerialNo)!="undefined"||sSerialNo.length!=0)
			setItemValue(0,getRow(),sColumnName,sSerialNo);
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

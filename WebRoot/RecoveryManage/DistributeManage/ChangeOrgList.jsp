<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*	Author: xhyong 2010/05/31
*	Tester:
*	Describe: 不良资产管理机构变更记录管理;
*	Input Param:
*		ObjectNo：台帐流水号
*	Output Param:     
*		SerialNo	:流水号       
*		OldOrgName	:变更前机构 
*		OldUserName	:变更前人员
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产管理机构变更记录管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";

	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectType == null) sObjectType="";
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo="";
	//获得页面参数
	//String sObjectType =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType")); //对象类型
	//String sObjectNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); //取流水号
	//if(sObjectType == null) sObjectType = "";  
	
	//Flag=ShiftType表示查看移交类型变更历史，否则查看管户人变更历史
	String sFlag =  DataConvert.toRealString(iPostChange,(String)request.getParameter("Flag")); 
	if(sFlag==null)	sFlag="";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//管户人历次变更列表表头
	String sHeaders[][] = {	
							{"SerialNo","流水号"},
							{"OldUserName","原管理人"},
							{"OldOrgName","原管理机构"},
							{"NewUserName","现管理人"},
							{"NewOrgName","现管理机构"},
							{"ChangeUserName","变更操作人"},
							{"ChangeOrgName","变更操作机构"},
							{"ChangeTime","变更日期"}
						};
	
	//管户人历次变更列表
	sSql = " Select SerialNo, " +
			" getUserName(OldUserID) as OldUserName, " +
			" getOrgName(OldOrgID) as OldOrgName, " +
			" getUserName(NewUserID) as NewUserName, " +
			" getOrgName(NewOrgID) as NewOrgName, " +
			" getUserName(ChangeUserID) as ChangeUserName, " +
			" getOrgName(ChangeOrgID) as ChangeOrgName, " +
			" ChangeTime " +
			" From MANAGE_CHANGE " +
			" Where ObjectNo = '"+sObjectNo+"' "+
			" and ObjectType = '"+sObjectType+"' order by ChangeTime desc";	  

	
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);

	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "MANAGE_CHANGE";
	//设置不可见性
	doTemp.setVisible("SerialNo,OldUserName,NewUserName,OldShift,NewShift",false);
	//设置选项行宽
	doTemp.setHTMLStyle("OldUserName,NewUserName,ChangeDate,ChangeUserName,ChangeTime"," style={width:80px} ");
	doTemp.setHTMLStyle("OldShiftName,NewShiftName,InputUserName,InputDate"," style={width:80px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);  //服务器分页

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","详情","查看记录详细信息","viewAndEdit()",sResourcesPath},
  		  };
	
	if(sFlag.equals("ShiftType"))
	{
		sButtons[0][0] = "false";
	}
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			sOldOrgName = getItemValue(0,getRow(),"OldOrgName");
			sOldUserName = getItemValue(0,getRow(),"OldUserName");
			sCompID = "ChangeOrgInfo";
			sCompURL = "/RecoveryManage/DistributeManage/ChangeOrgInfo.jsp";
			sParamString = "OldOrgName="+sOldOrgName+"&OldUserName="+sOldUserName+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>

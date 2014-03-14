<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:	ljtao 2008/12/08
			Tester:
			Content: 审批授权信息
			Input Param:
			SerialNo：流水号
			sObjectType:Special/Normal -- 特殊授权/一般授权
			sAuthorType:1/2/3 -- 总行授权/分行授权/支行授权
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
		String PG_TITLE = "审批授权信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//获得页面参数	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sAuthorType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sAuthorType == null) sAuthorType = "";
	//定义变量
	String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = {     
						{"SerialNo","流水号"},
			                    {"FinalOrgName","终审机构"},
			                    {"FinalRole","终审人员"},
			                    {"AcceptBillRight","代签承兑审批权"},//屏蔽 by qli 2008/08/08
			                    {"ImpawnRight","本行全额承兑审批权"},
			                    {"Attribute4","他行全额承兑审批权"},
			                    {"Attribute5","全额保函审批权"},
			                    {"Attribute1","跨区域贷款审批权"},
			                    {"Attribute2","循环贷款审批权"},
			                    {"Attribute3","重大关联交易审批权"},
			                    {"InputOrgName","登记机构"},
			                    {"InputUserName","登记人"},
			                    {"InputDate","登记日期"},	
			                    {"UpdateDate","更新日期"}
			         }; 
		sSql = " select SerialNo,ObjectType,AuthorType, " +
			   " FinalOrg,getOrgName(FinalOrg) as FinalOrgName,FinalRole, " +
			   " ImpawnRight,Attribute4,Attribute5,Attribute1,Attribute2,Attribute3,"+
			   " InputOrgID,getOrgName(InputOrgID) as InputOrgName, "+
			   " InputUserID,getUserName(InputUserID) as InputUserName,InputDate,UpdateDate "+
			   " from USER_AUTHORIZATION "+
		       " where ObjectType= '"+sObjectType+"' and SerialNo = '"+sSerialNo+"' ";

		//通过sql产生数据窗体对象		
		ASDataObject doTemp = new ASDataObject(sSql);
		//设置表头		
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "USER_AUTHORIZATION"; 
		//设置关键字		
		doTemp.setKey("SerialNo",true);
		//设置必输属性
		doTemp.setRequired("FinalRole,ImpawnRight,Attribute4,Attribute5,Attribute1,Attribute2,Attribute3",true);
		//设置是否可见属性
		doTemp.setVisible("SerialNo,ObjectType,AuthorType,InputOrgID,InputUserID,FinalOrg",false);
		if(sAuthorType.equals("1"))
			doTemp.setVisible("FinalOrgName",false);
		else
			doTemp.setRequired("FinalOrgName",true);
		//设置显示的长度
		doTemp.setHTMLStyle("InputDate,UpdateDate"," style={width:80px}");
		//设置所属行名称不可更新
		doTemp.setUpdateable("FinalOrgName,InputOrgName,InputUserName",false);
		//设置所属行名称为只读，从弹出对话框中选择	
		doTemp.setReadOnly("FinalOrgName,InputOrgName,InputUserName,InputDate,UpdateDate",true);
			
		if(sAuthorType.equals("1"))
			doTemp.setDDDWSql("FinalRole","select RoleID,RoleName from ROLE_INFO where RoleAttribute='0' and RoleStatus='1' order by RoleID ");
		else if(sAuthorType.equals("2"))
			doTemp.setDDDWSql("FinalRole","select RoleID,RoleName from ROLE_INFO where RoleAttribute='2' and RoleStatus='1' order by RoleID ");
		else
			doTemp.setDDDWSql("FinalRole","select RoleID,RoleName from ROLE_INFO where RoleAttribute='4' and RoleStatus='1' order by RoleID ");
			
		//doTemp.setDDDWCode("AcceptBillRight","HaveNot");
		doTemp.setDDDWCode("ImpawnRight","HaveNot");
		doTemp.setDDDWCode("Attribute1","HaveNot");
		doTemp.setDDDWCode("Attribute2","HaveNot");
		doTemp.setDDDWCode("Attribute3","HaveNot");
		doTemp.setDDDWCode("Attribute4","HaveNot");
		doTemp.setDDDWCode("Attribute5","HaveNot");
		doTemp.setUnit("FinalOrgName"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectFinalOrg()>");
		
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		session.setAttribute(dwTemp.Name,dwTemp);
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
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

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			initSerialNo();//初始化流水号字段		
		setItemValue(0,getRow(),"UpdateDate","<%=StringFunction.getToday()%>");		
		as_save("myiframe0");		
	}
		
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/Common/Configurator/UserAuthManage/UserSpecialList.jsp?ObjectType=<%=sObjectType%>&Type=<%=sAuthorType%>","_self","");
	}
	
	/*~[Describe=选择分支机构;InputParam=无;OutPutParam=无;]~*/
	function selectFinalOrg()
	{
		/*if("<%=sAuthorType%>" == "2")	//分行
			sParaString = "OrgLevel,3";
		else if("<%=sAuthorType%>" == "3")	//支行
			sParaString = "OrgLevel,6";
			
		setObjectValue("SelectSubOrg",sParaString,"@FinalOrg@0@FinalOrgName@1",0,0,"");*/
		setObjectValue("SelectAllOrg","","@FinalOrg@0@FinalOrgName@1",0,0,"");
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
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");
			setItemValue(0,getRow(),"AuthorType","<%=sAuthorType%>");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ImpawnRight","2");
			setItemValue(0,getRow(),"Attribute1","2");
			setItemValue(0,getRow(),"Attribute2","2");
			setItemValue(0,getRow(),"Attribute3","2");
			setItemValue(0,getRow(),"Attribute4","2");
			setItemValue(0,getRow(),"Attribute5","2");
			if("<%=sAuthorType%>" == "1")
				setItemValue(0,getRow(),"FinalOrg","0100");
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");	
			setItemValue(0,getRow(),"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"UpdateDate","<%=StringFunction.getToday()%>");				
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "USER_AUTHORIZATION";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
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
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

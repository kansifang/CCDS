<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: bliu 2004-12-02
		Tester:
		Describe: 代理机构详细信息
		Input Param:
			CustomerID：当前客户编号
			SerialNo:	流水号
		Output Param:
			CustomerID：当前客户编号

		HistoryLog:slliu 2004.12.17
					ndeng 2004.12.23
					zywei 2005/09/07 重检代码			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "代理机构"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数

	//获得页面参数	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { 							
							{"AgencyName","机构名称"},								
							{"AgencyLicense","营业执照编号"},
							{"BusinessBound","营业范围"},				
							{"Kind","性质"},
							{"LaunchDate","开办时间"},
							{"AgencyTel","联系电话"},
							{"PostNo","邮政编码"},
							{"FaxNo","传真号码"},				
							{"AgencyAdd","地址"},
							{"PrincipalName","负责人姓名"},
							{"PartnerName","合伙人/合作人姓名"},
							{"UserName","登记人"},
							{"OrgName","登记机构"},				
							{"InputDate","登记日期"},
							{"UpdateDate","更新日期"},
							{"Remark","备注"}								
						}; 	
	
	sSql = " select SerialNo,AgencyName,AgencyType,AgencyLicense,BusinessBound,Kind,LaunchDate, "+		   
		   " AgencyTel,PostNo,FaxNo,AgencyAdd,PrincipalName,PartnerName,Remark,InputUserID, "+
		   " getUserName(InputUserID) as UserName,InputOrgID,getOrgName(InputOrgID) as OrgName, "+	   
		   " InputDate,UpdateDate" +
		   " from AGENCY_INFO " +
	       " where SerialNo = '"+sSerialNo+"' ";

	//利用Sql生成窗体对象	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "AGENCY_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("SerialNo,AgencyType,InputUserID,InputOrgID",false);	
		
	//下拉框从代码中取得值
	doTemp.setDDDWCode("Kind","AgencyKind");
	doTemp.setDDDWCode("AgencyType","AgencyType1");	
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);

	//设置长度
	doTemp.setLimit("AgencyName",32);
	doTemp.setLimit("AgencyLicense",20);
	doTemp.setLimit("AgencyTel",32);
	doTemp.setLimit("FaxNo",80);
	doTemp.setLimit("AgencyAdd",80);
	doTemp.setLimit("PrincipalName",32);
	doTemp.setLimit("PartnerName",32);
	doTemp.setLimit("PostNo",6);
	doTemp.setLimit("Remark",100);
	doTemp.setLimit("BusinessBound",100);
	
	//设置编辑形式如大文本框
	doTemp.setEditStyle("BusinessBound","3");
	doTemp.setEditStyle("Remark","3");
	//设置输入框长度
	doTemp.setHTMLStyle("InputDate,UpdateDate,OrgName,UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("AgencyAdd"," style={width:300px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	//设置必输项
	doTemp.setRequired("AgencyName,AgencyType,AgencyLicense,Kind,AgencyTel",true);
	//设置日期检查格式
	doTemp.setCheckFormat("LaunchDate","3");		
	//设置不可更新字段
	doTemp.setUpdateable("OrgName,UserName",false);
	doTemp.appendHTMLStyle("PostNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/Public/AgencyList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"AgencyType","02");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "AGENCY_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
/*
*	Author: SLLIU 2005-01-15
*	Tester:
*	Describe: 资产监管信息;
*	Input Param:
*		ObjectType：对象类型（保全物：GuarantyInfo；查封资产：AssetInfo）											
*		ObjectNo：资产编号
		SerialNo：监管信息流水号
*	Output Param:     
*        	
*	HistoryLog: zywei 2006/01/24 重检代码
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "资产监管信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得组件参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));     
	if(sObjectType == null) sObjectType = "";		
	if(sObjectNo == null) sObjectNo = "";
	//获取页面参数	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); //取流水号
	if(sSerialNo==null) sSerialNo="";	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = {
					{"SerialNo","流水号"},
					{"WardDate","监管时间"},
					{"WardContent","情况描述"},
					{"OperateUserName","监管人"},
					{"OperateOrgName","监管人所属机构"},
					{"Remark","备注"},
					{"InputUserName","登记人"},
					{"InputOrgName","登记机构"},
					{"InputDate","登记日期"},
					{"UpdateDate","更新日期"}
			       };  

	String sSql = 	" select  SerialNo,ObjectNo,ObjectType,"+
					" WardDate,"+
					" WardContent,"+
					" OperateUserID,getUserName(OperateUserID) as OperateUserName," +	
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,Remark," +	
					" InputUserID,getUserName(InputUserID) as InputUserName," +	
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName," +																																																							
					" InputDate,UpdateDate " +	
	       			" from ASSETWARD_INFO " +
	       			" where ObjectType='"+sObjectType+"' "+
	       			" and objectno='"+sObjectNo+"' "+
	       			" and SerialNo = '"+sSerialNo+"' "+
	       			" order by InputDate desc";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSETWARD_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置不可更新
	doTemp.setUpdateable("InputUserName,InputOrgName,OperateUserName,OperateOrgName",false);
	//设置日期
	doTemp.setCheckFormat("WardDate","3");
	//设置共用格式
	doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	doTemp.setVisible("OperateUserID,OperateOrgID,InputUserID,InputOrgID",false);
	//选择现机构及人员
	doTemp.setUnit("OperateUserName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectUser(\""+CurOrg.OrgID+"\",\"OperateUserID\",\"OperateUserName\",\"OperateOrgID\",\"OperateOrgName\")>");
	doTemp.setAlign("WardDate","1");	
	//设置只读
	doTemp.setReadOnly("SerialNo,InputUserName,InputOrgName,OperateUserName,OperateOrgName",true);
	//设置必输项
	doTemp.setRequired("WardDate,WardContent,OperateUserName",true);
	//设置长度
	doTemp.setLimit("Remark",100);	
	//设置选项行宽	
	doTemp.setHTMLStyle("WardDate,OperateUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("WardContent"," style={width:300px} ");	
	doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");	
	//设置编辑形式如大文本框
	doTemp.setEditStyle("Remark","3");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//保存时后续事件

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);	
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
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/AssetWardList.jsp","_self","");
	}
    	
     

</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{		
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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
			
			
			//登记人、登记机构
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
		}		
    }
    
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSETWARD_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);	
	}
	
  	
	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser(sParam,sUserID,sUserName,sOrgID,sOrgName)
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectUserBelongOrg",sParaString,"@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0,"");		
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

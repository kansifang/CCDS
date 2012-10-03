<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: SLLIU 2005-01-15
*	Tester:
*	Describe: 资产监管信息;
*	Input Param:
*		ObjectType：对象类型（保全物：GuarantyInfo；查封资产：AssetInfo）											
*		ObjectNo：资产编号
*	Output Param:     
*        	
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "资产监管信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得组件参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));  
	  
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";		
	

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
   	String sHeaders[][] = {
					{"SerialNo","流水号"},
					{"WardDate","监管时间"},
					{"WardContent","情况描述"},
					{"OperateUserName","监管人"},
					{"OperateOrgName","监管人所属机构"},				
					{"InputUserName","登记人"},
					{"InputOrgName","登记机构"},
					{"InputDate","登记日期"}
			       };  

	String sSql = 	" select  SerialNo,"+
					" WardDate,"+
					" WardContent,"+
					" getUserName(OperateUserID) as OperateUserName," +	
					" getOrgName(OperateOrgID) as OperateOrgName," +	
					" getUserName(InputUserID) as InputUserName," +	
					" getOrgName(InputOrgID) as InputOrgName," +																																																							
					" InputDate " +	
					" from ASSETWARD_INFO " +
					" where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' "+
					" order by InputDate desc";

	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "ASSETWARD_INFO";

	//设置共用格式
	doTemp.setVisible("SerialNo",false);
    
    //设置选项双击及行宽
	doTemp.setHTMLStyle("WardContent"," style={width:200px} ");
	doTemp.setHTMLStyle("OperateUserName,InputUserName,WardDate"," style={width:80px} ");
	doTemp.setHTMLStyle("OperateOrgName,InputOrgName"," style={width:120px} ");
	
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
			{"true","","Button","新增","新增信息","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看详细信息","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除信息","deleteRecord()",sResourcesPath}			
		};		
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>

	//---------------------定义按钮事件------------------------------------		
	function newRecord()
	{
		OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/AssetWardInfo.jsp","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

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
			OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/AssetWardInfo.jsp?SerialNo="+sSerialNo,"_self","");
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

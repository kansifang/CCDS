<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-3
		Tester:
		Content: 抵债资产其他变动信息
		Input Param:
			        ObjectNo：对象编号
			        ObjectType：对象类型						
		Output param:
		
		History Log: zywei 2005/09/06 重检代码
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = " 抵债资产其他变动信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sComponentName == null) sComponentName = "";
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","变动流水号"},
							{"ObjectType","对象类型"},
							{"ObjectNo","资产流水号"},							
							{"AssetName","资产名称"},
							{"ChangeDate","变动日期"},
							{"ChangeType","变动类型"},	
							{"ChangeContent","变动内容"},	
							{"InputUserName","登记人"}, 
							{"InputOrgName","登记机构"}
						}; 
	//从其他变动表中获取变动纪录
	sSql =  " select OI.SerialNo,"+
			" OI.ObjectType,"+
			" OI.ObjectNo,"+			
			" AI.AssetName,"+
			" OI.ChangeDate,"+
			" OI.ChangeType,"+
			" OI.ChangeContent,"+				
			" getOrgName(OI.InputOrgID) as InputOrgName," + 
			" getUserName(OI.InputUserID) as InputUserName" + 
			" from OTHERCHANGE_INFO OI,ASSET_INFO AI" +
			" where  OI.ObjectType = '"+sObjectType+"' "+
			" and OI.ObjectNo = '"+sObjectNo+"' "+
			" and OI.ObjectNo = AI.serialNo "+
			" order by OI.ChangeDate desc";
			//对应于ObjectType的某个资产的变动记录。
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "OTHERCHANGE_INFO";	
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 

	//设置不可见项
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo",false);

	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("ChangeDate,ChangeType","style={width:80px} ");  
	doTemp.setHTMLStyle("SerialNo,ChangeContent,AssetName","style={width:100px} ");  
	doTemp.setHTMLStyle("InputUserName,InputOrgName"," style={width:80px} ");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页
	
	//生成HTMLDataWindow
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
		{"true","","Button","新增","新增变动记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","变动记录详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除变动记录","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAOtherChangeInfo.jsp","right","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;			
		}else
		{
			if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
			{
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");			
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;	
		}else
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAOtherChangeInfo.jsp?SerialNo="+sSerialNo,"right","");
		}
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>	

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

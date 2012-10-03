<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: 庭审记录列表
		Input Param:
				SerialNo:案件编号				      
		Output param:
				ObjectNo:对象编号
				ObjectType:对象类型
		History Log: zywei 2005/09/06 重检代码
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "庭审记录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
		
	//获得组件参数（案件流水号）	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"ObjectNo","案件编号"},
							{"SerialNo","记录流水号"},
							{"CognizanceDate","庭审日期"},				
							{"LawsuitPhaseName","所属诉讼阶段"},
							{"AgentPerson","行内代理人"},
							{"AgentLawyer","我行代理律师"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"},				
							{"InputDate","登记日期"}
						}; 
	
	//从庭审记录表LAWCASE_COGNIZANCE中选出案件的庭审记录信息
	sSql = " select ObjectType,ObjectNo,SerialNo,CognizanceDate,LawsuitPhase,"+
		   " getItemName('LawsuitPhase',LawsuitPhase) as LawsuitPhaseName, "+	
		   " AgentPerson,AgentLawyer,InputUserID,getUserName(InputUserID) as InputUserName, " +
		   " InputOrgID,getOrgName(InputOrgID) as InputOrgName,InputDate "+ 		   
	       " from LAWCASE_COGNIZANCE " +
	       " where ObjectType='LawcaseInfo' " +	//对象类型
	       " and  ObjectNo = '"+sSerialNo+"' "+
	       " order by InputDate desc" ;	//案件编号
	       
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LAWCASE_COGNIZANCE";	
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,LawsuitPhase,InputUserID,InputOrgID",false);	

	//设置选项双击及行宽
	doTemp.setHTMLStyle("CognizanceDate"," style={width:80px} ");
	doTemp.setHTMLStyle("LawsuitPhaseName"," style={width:80px} ");
	doTemp.setHTMLStyle("InputUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");
	doTemp.setHTMLStyle("AgentPerson,AgentLawyer"," style={width:200px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页

	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		
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
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/ImparRecordInfo.jsp?ObjectNo=<%=sSerialNo%>&PersonType=03","right","");    
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得记录流水号、案件编号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/ImparRecordInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&PersonType=03","right","");
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

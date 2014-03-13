<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:	ljtao	2008/12/08
			Tester:
			Content: 审批授权列表
			Input Param:
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
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "审批授权列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sAuthorType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sObjectType == null) sObjectType = "";
	if(sAuthorType == null) sAuthorType = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = {
					{"SerialNo","流水号"},
		                    {"BusinessKindName","业务类型"},
		                    {"BusinessTypeName","业务品种"},
		                    {"VouchType","主要担保方式"},
		                    {"EvaluateRate","信用等级"},
		                    {"MathMark","符号"},
		                    {"DoorSum","单户限额"},
		                    {"FinalOrgName","终审机构"},
		                    {"FinalRoleName","终审人员"},
		                    {"InputOrgName","登记机构"},
		                    {"InputUserName","登记人"},
		                    {"InputDate","登记日期"}
	               };	
	sSql = " select SerialNo,ObjectType,AuthorType,BusinessKind,getItemName('BusinessKind',BusinessKind) as BusinessKindName,getBusinessName(BusinessType) as BusinessTypeName, " +
		   " getItemName('VouchType2',VouchType) as VouchType,EvaluateRate,getItemName('MathMark',MathMark) as MathMark, " +
		   " DoorSum,getOrgName(FinalOrg) as FinalOrgName,getRoleName(FinalRole) as FinalRoleName, " +
		   " getOrgName(InputOrgID) as InputOrgName, "+
		   " getUserName(InputUserID) as InputUserName,InputDate from USER_AUTHORIZATION "+
	       " where ObjectType= '"+sObjectType+"' and AuthorType='"+sAuthorType+"' order by FinalOrg ";
		   
	//设置DataObject				
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置列表标题和更新表名
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "USER_AUTHORIZATION"; 
	
    //设置关键字段	
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,ObjectType,AuthorType,BusinessKind,FinalRole",false);
	doTemp.setVisible("VouchType,EvaluateRate",false);
	
	if(sAuthorType.equals("1"))
		doTemp.setVisible("FinalOrgName",false);
	
	doTemp.setType("DoorSum","Number");
	doTemp.setCheckFormat("DoorSum","2");	
	doTemp.setHTMLStyle("BusinessTypeName","style={width:200px}");
	doTemp.setHTMLStyle("EvaluateRate,MathMark"," style={width:60px}");
    //生成查询条件	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
	
	//生成ASDataWindow对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//设置为Grid风格
	dwTemp.Style="1";
	//设置为只读
	dwTemp.ReadOnly = "1";
	dwTemp.setPageSize(20);
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}		
			};
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/Common/Configurator/UserAuthManage/UserAuthInfo.jsp?ObjectType=<%=sObjectType%>&Type=<%=sAuthorType%>","_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
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
		}
		OpenPage("/Common/Configurator/UserAuthManage/UserAuthInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=<%=sObjectType%>&Type=<%=sAuthorType%>","_self","");
	}		

	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>

	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

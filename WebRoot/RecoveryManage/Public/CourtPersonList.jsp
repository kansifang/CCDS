<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2004-12-24
		Tester:
		Describe: 受理机关人员列表;
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			CustomerID：当前客户编号
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "受理机关人员列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	//获得组件参数
	
	//获得页面参数
	String sBelongNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("BelongNo"));
	//Flag=Y表示从受理机关信息列表进入的
	String sFlag = DataConvert.toRealString(iPostChange,CurPage.getParameter("Flag"));
	//将空值转化为空字符串
	if(sBelongNo == null) sBelongNo = "";
	if(sFlag == null) sFlag = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = { 							
							{"AgentName","受理机关人员名称"},
							{"BelongAgency","所属受理机关名称"},
							{"DepartTypeName","所属受理机关类型"},
							{"Duty","职务"},
							{"RelationTel","联系电话"},
							{"UserName","登记人"},
							{"OrgName","登记机构"},
							{"InputDate","登记日期"}
						}; 

	if(sBelongNo.equals(""))
	{
		sSql = 	" select SerialNo,AgentName,BelongAgency,getItemName('DepartType',DepartType) as DepartTypeName, "+
				" Duty,RelationTel,InputUserID,getUserName(InputUserID) as UserName,InputOrgID, "+
				" getOrgName(InputOrgID) as OrgName,InputDate"+
				" from AGENT_INFO "+
				" where AgentType = '01' "+
				//" and InputOrgID = '"+CurOrg.OrgID+"' "+
				" order by InputDate desc ";
	 }else
	 {		
		 sSql = " select SerialNo,AgentName,BelongAgency,Duty,RelationTel,InputUserID,getUserName(InputUserID) as UserName," +
			   	" InputOrgID,getOrgName(InputOrgID) as OrgName,InputDate"+
		       	" from AGENT_INFO " +
		       	" where BelongNo = '"+sBelongNo+"' "+
		       	//" and InputOrgID='"+CurOrg.OrgID+"' "+
		       	" order by InputDate desc";
	 }      
	
	//用sSql生成数据窗体对象
	//out.println(sSql);
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "AGENT_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("SerialNo,InputUserID,InputOrgID,InputDate",false);	
	
	doTemp.setHTMLStyle("UserName,InputDate"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("AgentName,BelongAgency"," style={width:120px} ");
	doTemp.setHTMLStyle("Duty"," style={width:60px} ");
	doTemp.setHTMLStyle("RelationTel"," style={width:100px} ");

	//生成查询框
	doTemp.setColumnAttribute("AgentName,BelongAgency","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
			{"true","","Button","新增","新增代理人","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看代理人","viewAndEdit()",sResourcesPath},
			{"true","","Button","已受理案件","查看已受理案件","my_lawcase()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
			{"true","","Button","删除","删除代理人","deleteRecord()",sResourcesPath}
		};
		
	if(sFlag.equals("Y")) //从机构信息列表进入
	{
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[4][0]="false";
		
	}else
	{
		sButtons[3][0]="false";
	}
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/Public/CourtPersonInfo.jsp","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/Public/CourtPersonInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}
	
	/*~[Describe=返回列表;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{     	
		OpenPage("/RecoveryManage/Public/CourtList.jsp?rand="+randomNumber(),"_self","");
	}
	
	/*~[Describe=已代理案件信息;InputParam=无;OutPutParam=无;]~*/
	function my_lawcase()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/Public/SupplyLawCase.jsp?QuaryName=PersonNo&QuaryValue="+sSerialNo+"&Back=4&rand="+randomNumber(),"_self","");           	
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

<%@	include file="/IncludeEnd.jsp"%>

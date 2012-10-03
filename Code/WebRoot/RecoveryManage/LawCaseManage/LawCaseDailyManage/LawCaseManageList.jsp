<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:    hxli 2005-8-3
		Tester:
		Content: 诉讼案件列表
		Input Param:
			   CasePhase：案件状态     
		Output param:
				 
		History Log: zywei 2005/09/06 重检代码
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "诉讼案件列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";		
	String sWhereClause = ""; //Where条件
	
	//获得组件参数	：案件状态	
	String sCasePhase =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID"));
	if(sCasePhase == null) sCasePhase = "";	
			
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
				{"SerialNo","内部案号"},
				{"CasePhase","案件阶段"},
				{"CasePhaseName","案件阶段"},
				{"LawCaseName","案件名称"},
				{"LawCaseTypeName","案件类型"},				
				{"Counter","关联合同数"},				
				{"LawsuitStatusName","我行的诉讼地位"},
				{"CaseBriefName","案由"},
				{"CaseStatusName","案件当前进程"},
				{"CourtStatus","当前受理法院"},
				{"CognizanceResultName","受理结果"},
				{"CurrencyName","标的币种"},
				{"AimSum","诉讼总标的"},				
				{"ManageUserName","案件管理人"},
				{"ManageOrgName","案件管理机构"},
				{"InputDate","登记日期"}
				
			}; 

	
	//除终结案件之外的所有所有案件列表，如果包括终结，那么在列表中无法显示终结标志会引起误会，
	//因为是通过其终结日期来判断是否终结的，其案件阶段依然是终结前的阶段。案件阶段中并没有终结阶段的说！
	if(sCasePhase.equals("000"))	
		sWhereClause=" and (( LI.PigeonholeDate='' or LI.PigeonholeDate is null)) ";
	if(sCasePhase.equals("010"))	//诉前案件列表
		sWhereClause=" and ( LI.CasePhase = '010' and ( LI.PigeonholeDate='' or  LI.PigeonholeDate is null)) ";
	if(sCasePhase.equals("020"))	//诉讼中案件列表
		sWhereClause=" and ( LI.CasePhase = '020' and ( LI.PigeonholeDate='' or  LI.PigeonholeDate is null))  ";
	if(sCasePhase.equals("025"))	//待执行案件列表
		sWhereClause=" and ( LI.CasePhase = '025' and ( LI.PigeonholeDate='' or  LI.PigeonholeDate is null))  ";
	if(sCasePhase.equals("030"))	//执行中案件列表
		sWhereClause=" and ( LI.CasePhase = '030' and ( LI.PigeonholeDate='' or  LI.PigeonholeDate is null))   ";
	if(sCasePhase.equals("040"))	//终结归档案件列表
	{
		String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
		if (sDBName.startsWith("INFORMIX"))
			sWhereClause = " and ( LI.PigeonholeDate<>'' or  LI.PigeonholeDate is not null)   ";
		else if (sDBName.startsWith("ORACLE"))
			sWhereClause = " and ( LI.PigeonholeDate<>' ' or  LI.PigeonholeDate is not null)   ";
		else if (sDBName.startsWith("DB2"))
			sWhereClause = " and ( LI.PigeonholeDate<>' ' or  LI.PigeonholeDate is not null)   ";
	}			
	sSql = 	" select  LI.SerialNo as SerialNo,"+
			" LI.CasePhase,getItemName('CasePhase',LI.CasePhase) as CasePhaseName,"+
			" LI.LawCaseName as LawCaseName,"+
			" LI.LawCaseType as LawCaseType,getItemName('LawCaseType',LI.LawCaseType) as LawCaseTypeName, "+		
			" LI.LawsuitStatus as LawsuitStatus ,getItemName('LawsuitStatus',LI.LawsuitStatus) as LawsuitStatusName, "+
			" LI.CaseBrief as CaseBrief, getItemName('CaseBrief',LI.CaseBrief) as CaseBriefName,LI.CourtStatus as CourtStatus," +
			" LI.CaseStatus as CaseStatus ,getItemName('CaseStatus',LI.CaseStatus) as CaseStatusName," +
			" LI.CognizanceResult as CognizanceResult,getItemName('CognizanceResult',LI.CognizanceResult) as CognizanceResultName," +
			" LI.Currency as Currency,getItemName('Currency',LI.Currency) as CurrencyName," +
			" LI.AimSum as AimSum,"+
			" LI.ManageUserID as ManageUserID,getUserName(LI.ManageUserID) as ManageUserName, " +
			" LI.ManageOrgID as ManageOrgID,getOrgName(LI.ManageOrgID) as ManageOrgName," +
			" LI.InputDate as InputDate "+
			" from LAWCASE_INFO LI"+		
			" where   LI.ManageOrgID = '"+CurOrg.OrgID+"' "+	//当前机构
			" and  LI.ManageUserID = '"+CurUser.UserID+"'"+	//当前用户		
			sWhereClause +
			" Group by LI.SerialNo,LI.CasePhase,LI.LawCaseName,LI.LawCaseType, LI.LawsuitStatus,LI.CaseBrief ,LI.CourtStatus, "+
			" LI.CaseStatus,LI.CognizanceResult,LI.Currency,LI.AimSum,LI.ManageUserID, LI.ManageOrgID, LI.InputDate  "+
			" order by LI.InputDate desc, LI.LawCaseName ";
		
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LAWCASE_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("LawsuitStatus,LawCaseType,CaseBrief,Currency,ManageUserID,ManageOrgID,PigeonholeDate,LawCaseTypeNo",false);	
	doTemp.setVisible("SerialNo,CaseStatus,CognizanceResult,CasePhase",false);	
	//设置金额格式
	doTemp.setCheckFormat("AimSum","2");	
	//设置对齐方式	
	doTemp.setAlign("AimSum","3");	
	
	//设置选项行宽
	doTemp.setHTMLStyle("LawCaseName"," style={width:300px} ");
	doTemp.setHTMLStyle("LawCaseTypeName"," style={width:100px} ");	
	doTemp.setHTMLStyle("LawsuitStatusName"," style={width:100px} ");
	doTemp.setHTMLStyle("CaseBriefName"," style={width:80px} ");
	doTemp.setHTMLStyle("CaseStatusName,CasePhaseName"," style={width:80px} ");
	doTemp.setHTMLStyle("CognizanceResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CurrencyName"," style={width:80px} ");
	doTemp.setHTMLStyle("AimSum"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");
	doTemp.setHTMLStyle("Counter"," style={width:60px} ");
	
	//生成查询框
	doTemp.setColumnAttribute("LawCaseName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页
    
    //删除案件后删除关联信息
    dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(LawcaseInfo,#SerialNo,DeleteBusiness)");
	
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
	
		//如果为诉前案件，则列表显示如下按钮
		String sButtons[][] = {
					{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
					{"true","","Button","案件详情","查看/修改案件详情","viewAndEdit()",sResourcesPath},
					{"true","","Button","转入下阶段","转入下阶段","my_NextPhase()",sResourcesPath},
					{"true","","Button","归档","转入诉讼终结案件","my_Pigeonhole()",sResourcesPath},
					{"true","","Button","取消归档","取消转入诉讼终结案件","my_CancelPigeonhole()",sResourcesPath},
					{"true","","Button","取消","删除所选中的记录","deleteRecord()",sResourcesPath},
				};
				
		//如果为不良日常转入，那么：
		if(sCasePhase.equals("000"))			
		{
			sButtons[4][0]="false";			
		}

		//如果为诉前案件，则对应列表不显示取消归档等按钮
		if(sCasePhase.equals("010"))			
		{
			sButtons[4][0]="false";			
		}
		
		//如果为诉讼中案件，则对应列表不显示新增、删除等按钮
		if(sCasePhase.equals("020"))			
		{
			sButtons[0][0]="false";
			sButtons[4][0]="false";
			sButtons[5][0]="false";			
		}
		
		//如果为待执行案件、执行中案件，则对应列表不显示新增、删除等按钮
		if(sCasePhase.equals("025"))			
		{
			sButtons[0][0]="false";
			sButtons[4][0]="false";
			sButtons[5][0]="false";			
		}
		
		//如果为执行中案件，则对应列表不显示新增、删除等按钮
		if(sCasePhase.equals("030") )			
		{
			sButtons[0][0]="false";
			sButtons[4][0]="false";
			sButtons[5][0]="false";			
		}
		
		//如果为已终结案件，则对应列表不显示新增、删除、归档等按钮
		if(sCasePhase.equals("040"))			
		{
			sButtons[0][0]="false";
			sButtons[2][0]="false";
			sButtons[3][0]="false";			
			sButtons[5][0]="false";
		}
	
	
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
		//获得选择的案件类型
		var sLawCaseType = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseTypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sLawCaseType) != "undefined" && sLawCaseType.length != 0 && sLawCaseType != '')
		{	
			//使用GetSerialNo.jsp来抢占一个流水号
			var sTableName = "LAWCASE_INFO";//表名
			var sColumnName = "SerialNo";//字段名
			var sPrefix = "";//前缀
			var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");		
			PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/AddLawCaseAction.jsp?SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;
			sViewID = "001";
			openObject(sObjectType,sObjectNo,sViewID);			
			reloadSelf();
		} 		
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
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
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sCasePhase = "<%=sCasePhase%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;			
			if(sCasePhase=="040")
				sViewID = "002"
			else
				sViewID = "001"
			
			openObject(sObjectType,sObjectNo,sViewID);	
			reloadSelf();		
		}
	}
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	/*~[Describe=转入下阶段;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_NextPhase()
	{		
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			//获得选择阶段
			var sLawCasePhase = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCasePhaseDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sLawCasePhase) != "undefined" && sLawCasePhase.length != 0 && sLawCasePhase != '')
			{			
				if(sLawCasePhase == '<%=sCasePhase%>')
				{
					alert(getBusinessMessage("779"));  //转入阶段与当前阶段相同！
					return;
				}else if(confirm(getBusinessMessage("777"))) //您真的想将该案件转到下阶段吗？
				{
					sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@CasePhase@"+sLawCasePhase+",LAWCASE_INFO,String@SerialNo@"+sSerialNo);
					if(sReturnValue == "TRUE")
					{
						alert(getBusinessMessage("772"));//转入下阶段成功！
						reloadSelf();
					}else
					{
						alert(getBusinessMessage("773")); //转入下阶段失败！
						return;
					}						
				}
			}
        }    
	}
			
	/*~[Describe=归档;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_Pigeonhole()
	{		
		//获得案件流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			if(confirm(getHtmlMessage('56'))) //您真的想将该信息归档吗？
			{				
				sPigeonholeDate = "<%=StringFunction.getToday()%>";
				sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@PigeonholeDate@"+sPigeonholeDate+",LAWCASE_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
					alert(getHtmlMessage('57'));//归档成功！
					reloadSelf();
				}else
				{
					alert(getHtmlMessage('60'));//归档失败！
					return;
				}
			}
        }    
	}
	
	/*~[Describe=取消归档;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_CancelPigeonhole()
	{		
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			if(confirm(getHtmlMessage('58'))) //您真的想将该信息归档取消吗？
			{
				sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@PigeonholeDate@None,LAWCASE_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
					alert(getHtmlMessage('59'));//取消归档成功！
					reloadSelf();
				}else
				{
					alert(getHtmlMessage('61'));//取消归档失败！
					return;
				}				
        	}
        }    
	}
		
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

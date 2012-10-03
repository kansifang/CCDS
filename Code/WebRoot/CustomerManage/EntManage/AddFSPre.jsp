<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jbye 2004-12-16 20:40
		Tester:
		Describe: 新增财务报表准备信息 本页面仅仅用于报表信息的新增操作
		Input Param:
			--CustomerID：当前客户编号
			--ModelClass: 模式类型
		Output Param:
			--CustomerID：当前客户编号
		HistoryLog:		
			DATE	CHANGER		CONTENT
			2005-8-10	fbkang	页面调整	
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "报表说明"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
    String sCustomerID="";//--客户代码
    String sModelClass = "";//--模式类型
    String sSql = "";//--存放sql语句
    String sPassRight = "true";//--布尔型变量
	//获得组件参数，客户代码、模式类型
	sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID")); 
	sModelClass = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelClass")); 
	//获得页面参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sHeaders[][] = {
							{"CustomerID","客户号"},
							{"RecordNo","记录号"},
							{"ReportDate","报表截至日期"},
							{"ReportScope","报表口径"},
							{"ReportPeriod","报表周期"},
							{"ReportCurrency","报表币种"},
							{"ReportUnit","报表单位"},
							{"ReportStatus","报表状态"},
							{"ReportFlag","报表检查标志"},
							{"ReportOpinion","报表注释"},
							{"AuditFlag","审计情况"},
							{"AuditOffice","审计单位"},
							{"AuditDate","审计时间"},
							{"AuditOpinion","审计意见"},
							{"InputDate","登记日期"},
							{"OrgName","登记机构"},
							{"UserName","登记人"},
							{"UpdateDate","修改日期"},
							{"Remark","备注"}
						  };
	
	sSql = 	" select CustomerID,RecordNo,ReportDate,ReportScope,ReportPeriod,ReportCurrency,"+
			" ReportUnit,ReportStatus,ReportFlag,ReportOpinion,AuditFlag,AuditOffice,AuditDate,AuditOpinion,"+
			" getUserName(UserID) as UserName,"+
			" getOrgName(OrgID) as OrgName,"+
			" InputDate,OrgID,UserID,UpdateDate,Remark "+
			" from CUSTOMER_FSRECORD "+
			" where 1=2 ";
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_FSRECORD";
	doTemp.setKey("RecordNo",true);	
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setVisible("ReportFlag,CustomerID,RecordNo,OrgID,UserID,Remark,ReportStatus",false);
	
	//币种默认为人民币，单位默认为元。modi by xuzhang 2005-1-20
	doTemp.setDefaultValue("ReportCurrency","01");
	doTemp.setDefaultValue("ReportUnit","01");
    //下拉数据列表框
	doTemp.setDDDWCode("ReportPeriod","ReportPeriod");
	doTemp.setDDDWCode("ReportCurrency","Currency");
	doTemp.setDDDWCode("ReportStatus","ReportStatus");
	doTemp.setDDDWCode("ReportScope","ReportScope");
	doTemp.setDDDWCode("ReportUnit","ReportUnit");
	doTemp.setDDDWCode("AuditFlag","AuditInstance");
	doTemp.setDDDWCode("AuditOpinion","AuditOpinion");
	//选择日期
	doTemp.setUnit("ReportDate","<input class=\"InputDate\" value=\"...\" type=button onClick=parent.getMonth(\"ReportDate\")>");
	doTemp.setUnit("AuditOffice","<input type=button value=.. onclick=parent.selectEvalOrgName()>");
	//datawindow格式类型定义
	//doTemp.setEditStyle("AuditOpinion","3");
	doTemp.appendHTMLStyle("ReportDate"," style={width=55px} ");
	doTemp.appendHTMLStyle("AuditOffice"," style={width=300px} ");	 
	//doTemp.appendHTMLStyle("AuditOpinion","  style={height:100px;width:400px;overflow:scroll} ");
    doTemp.setLimit("ReportOpinion,AuditOpinion",200);
	//可修改字段
	doTemp.setRequired("AuditFlag,ReportDate,ReportScope,ReportPeriod,ReportUnit,ReportCurrency",true);
	//字段只读
	doTemp.setHTMLStyle("OrgName","style={width:250px}");  
	doTemp.setReadOnly("ReportDate,UserName,OrgName,InputDate,UpdateDate,ReportUnit,ReportCurrency",true);
	//设置日期的格式
	doTemp.setCheckFormat("AuditDate","3");
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//保存后进行财务报表的初始化操作
	dwTemp.setEvent("AfterInsert","!BusinessManage.InitFinanceReport(CustomerFS,#CustomerID,#ReportDate,#ReportScope,ModelClass^'"+sModelClass+"',,AddNew,"+CurOrg.OrgID+","+CurUser.UserID+")");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义按钮;]~*/%>
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
		       {"true","","Button","确定","确定","doCreation()",sResourcesPath}
		      };
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------//
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		sReportDate = getItemValue(0,0,"ReportDate");
		sReportScope = getItemValue(0,0,"ReportScope");
		//如果需要可以进行保存前的权限判断
		sPassRight = PopPage("/CustomerManage/EntManage/FinanceCanPass.jsp?ReportDate="+sReportDate+"&ReportScope="+sReportScope,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		if(sPassRight=="pass")
		{
			//使用GetSerialNo.jsp来抢占一个流水号
			var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=CUSTOMER_FSRECORD&ColumnName=RecordNo&Prefix=CFS","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			//将流水号置入对应字段
			setItemValue(0,0,"RecordNo",sSerialNo);
			as_save("myiframe0",sPostEvents);
		}else
		{
			alert(sReportDate +" 已存在相同报表口径的财务报表，请重新选择报表口径！");
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info05;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		saveRecord("goBack()");
	}
	
	function goBack()
	{
		sRecordNo = getItemValue(0,0,"RecordNo");//流水号
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//客户编号
		sReportDate = getItemValue(0,getRow(),"ReportDate");//报表日期
		sReportScope = getItemValue(0,getRow(),"ReportScope");//报表口径
		sUserID = getItemValue(0,getRow(),"UserID");
		self.returnValue= sRecordNo+"@"+sCustomerID+"@"+sReportDate+"@"+sReportScope+"@"+sUserID;
		self.close();
	}
	
	/*~[Describe=日期选择;InputParam=无;OutPutParam=无;]~*/
	function getMonth(sObject)
	{
		sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
		if(typeof(sReturnMonth) != "undefined")
		{
			setItemValue(0,0,sObject,sReturnMonth);
		}
	}
	
	/*~[Describe=选择审计单位;InputParam=无;OutPutParam=无;]~*/
	function selectEvalOrgName()
	{
		//房屋只能由房地产评估机构评估，其他由资产评估公司
		var AuditOrgType = "010";
		sParaString = "AuditOrgType"+","+AuditOrgType;
		setObjectValue("selectNewEvalOrgName",sParaString,"@AuditOffice@0",0,0,"");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{			
		//校验报表截止日期是否大于当前日期
		sReportDate = getItemValue(0,0,"ReportDate");//报表截止日期
		sToday = "<%=StringFunction.getToday()%>";//当前日期
		sToday = sToday.substring(0,7);//当前日期的年月			
		if(typeof(sReportDate) != "undefined" && sReportDate != "" )
		{
			if(sReportDate >= sToday)
			{		    
				alert(getBusinessMessage('163'));//报表截止日期必须早于当前日期！
				return false;		    
			}
		}
		//当审计情况为已审计时,审计单位,审计日期和审计意见必须填写
		sAuditFlag = getItemValue(0,0,"AuditFlag");//审计情况
		sAuditOffice = getItemValue(0,0,"AuditOffice");//审计单位
		sAuditOpinion = getItemValue(0,0,"AuditOpinion");//审计意见
		sAuditDate = getItemValue(0,0,"AuditDate");//审计日期	
		if(typeof(sAuditFlag) != "undefined" && sAuditFlag != "")
		{
			if(sAuditFlag == '2' && (typeof(sAuditOffice) == "undefined" || sAuditOffice == "" ||sAuditDate=="" || typeof(sAuditDate) == "undefined" ||typeof(sAuditOpinion) == "undefined" || sAuditOpinion == ""))
			{
				alert("当审计情况为已审计时,审计单位,审计日期和审计意见必须填写!");
				return false;
			}
			if(sAuditFlag == '2'&& typeof(sAuditDate) != "undefined" && sAuditDate != "")
			{
				//审计机构有效性检查
				sCustomerName = getItemValue(0,getRow(),"AuditOffice");
				sAuditDate = getItemValue(0,getRow(),"AuditDate");
				sReturn=RunMethod("CustomerManage","selectNewEvalOrgDate",sCustomerName);
				sReturn1=sReturn.split("@");
     			sEffectStartDate=sReturn1[0];
     			sEffectFinishDate=sReturn1[1];
				if(sAuditDate<sEffectStartDate || sAuditDate>sEffectFinishDate)
				{
					alert("审计日期不在评估机构有效期内!");
					return true;
				}		
				return true;
			}
		}
		return true;
	}
	

	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"ReportStatus","01");
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

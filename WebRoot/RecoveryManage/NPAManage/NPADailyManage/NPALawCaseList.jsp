<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   XWu 2004.12.12
		Tester:
		Content: 合同涉诉案件信息列表
		Input Param:
			   ObjectNo：合同编号 不良资产调用    
			   ObjectType：对象类型     
			   CustomerID：客户ID 信贷客户信息调用    
		Output param:
				 
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同涉诉案件信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sWhereCondition = "";
	String sInCondition = "";	
	String sSql = "";
	ASResultSet rs = null;
	//获得组件参数	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID")); //对象类型
	if(sCustomerID == null) sCustomerID = "";

	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); //对象类型
	if(sObjectType == null) sObjectType = "BusinessContract";
	
	if(sCustomerID.equals(""))
	{
		String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		sWhereCondition	= " SerialNo in (Select SerialNo From LAWCASE_RELATIVE Where ObjectNo = '"+sObjectNo+"' And ObjectType = 'BusinessContract') order by InputDate desc ";
	}else
	{
		sSql = "select SerialNo from BUSINESS_CONTRACT where CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getResultSet(sSql);
		while(rs.next()){
			if(sInCondition != null && !sInCondition.equals(""))
				sInCondition = sInCondition+",";
			sInCondition = sInCondition+ "'"+rs.getString(1)+"'";
		}
		rs.getStatement().close();

		if(sInCondition == null) sInCondition = "";
		if(sInCondition.indexOf("'")<0) sInCondition = "'"+sInCondition+"'";

		sWhereCondition	= 	" SerialNo in (Select Distinct SerialNo From LAWCASE_RELATIVE Where ObjectNo in ("+sInCondition+")" + 
							" And ObjectType = 'BusinessContract') order by InputDate desc ";  	
	}

	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","内部案号"},
							{"LawCaseName","案件名称"},
							{"LawCaseTypeName","案件类型"},
							{"LawsuitStatusName","我行的诉讼地位"},
							{"CaseBriefName","案由"},
							{"CaseStatusName","当前诉讼进程"},
							{"CourtStatus","当前受理法院"},
							{"CognizanceResultName","受理结果"},
							{"CurrencyName","诉讼币种"},
							{"AimSum","诉讼总标的"},				
							{"ManageUserName","案件管理人"},
							{"ManageOrgName","案件管理机构"},
							{"InputDate","登记日期"}				
						}; 

	 sSql = " select  SerialNo,LawCaseName,"+
			" LawCaseType,getItemName('LawCaseType',LawCaseType) as LawCaseTypeName, "+		  
			" LawsuitStatus,getItemName('LawsuitStatus',LawsuitStatus) as LawsuitStatusName, "+
			" CaseBrief,getItemName('CaseBrief',CaseBrief) as CaseBriefName,CourtStatus," +
			" CaseStatus,getItemName('CaseStatus',CaseStatus) as CaseStatusName," +
			" CognizanceResult,getItemName('CognizanceResult',CognizanceResult) as CognizanceResultName," +
			" Currency,getItemName('Currency',Currency) as CurrencyName," +
			" AimSum,"+
			" ManageUserID,getUserName(ManageUserID) as ManageUserName, " +
			" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName," +
			" InputDate"+
			" From LAWCASE_INFO " +
			" Where ((PigeonholeDate='') or (PigeonholeDate is null) ) and " + sWhereCondition ;
			//上述条件排斥了归档的案件。   added by FSGong 2005-03-18
	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("SerialNo,LawsuitStatus,LawCaseType,CaseBrief,Currency,LawCaseOrg,ManageUserID,ManageOrgID,PigeonholeDate,LawCaseTypeNo",false);	
	doTemp.setVisible("CaseStatus,CognizanceResult",false);	

	doTemp.setCheckFormat("AimSum","2");	
	//设置对齐方式	
	doTemp.setAlign("AimSum","3");	
	doTemp.setAlign("LawCaseTypeName,LawsuitStatusName,CaseBriefName,CurrencyName","2");
	doTemp.setCheckFormat("InputDate","3");
    doTemp.setHTMLStyle("ManageOrgName","style={width:200px}");		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页

	//生成HTMLDataWindow
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
	
		//如果为诉前案件，则列表显示如下按钮
		String sButtons[][] = {
					{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
				};	
%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得案件流水号、案件类型
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
		}
		else
		{		
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;
			sViewID = "002";
			openObject(sObjectType,sObjectNo,sViewID);		}
		
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

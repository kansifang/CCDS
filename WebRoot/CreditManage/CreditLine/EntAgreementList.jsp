<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:lpzhang 2009-8-5
		Tester:
		Content: 工程机械按揭额度
		Input Param:
			
		Output param:
		History Log: 
			 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "工程机械按揭额度"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	String sWhere = "";
	
	//获得组件参数	
	
	//获得页面参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		
	//显示标题				
	String[][] sHeaders = {		
							{"SerialNo","主协议流水号"},              	
							{"CustomerName","制造商名称"},              
							{"LoanTypeName","工程机械类型"},            
							{"Currency","币种"},                    
							{"BailRatio","最低缴存保证金比例(%)"}, 
							{"CompanyBailRatio","其中制造商比例(%)"},    	
							{"DealerBailRatio","其中经销商比例(%)"},   	
							{"BailAccount","保证金账号"},            	
							{"OperateOrgID","主办行"},                 	
							{"AGREEMENTScale","申请协议规模"},           	
							{"TermMonth","期限(月)"},            	
							{"LoanSum","最高贷款金额"},           	
							{"LoanTerm","最高贷款期限(月)"},    	
							{"LoanRatio","最高贷款比例(%)"}, 
							{"FreezeFlag","额度状态"},
							{"InputUserName","登记人"},                  
							{"InputOrgName","登记机构"},                
							{"InputDate","登记日期"},                
							{"UpdateDate","更新日期"},    
						 };
	

	sSql =  " select SerialNo,CustomerName,LoanType,getItemName('AgreementLoanType',LoanType) as LoanTypeName,AGREEMENTScale,"+
			" getItemName('Currency',Currency) as Currency,LoanSum,BailRatio,LoanTerm,LoanRatio,getItemName('FreezeFlag',FreezeFlag) as FreezeFlag, "+
			" getUserName(InputUserID) as InputUserName,UpdateDate "+
			" from ENT_AGREEMENT where AgreementType = 'ProjectAgreement' and FreezeFlag <> '' and FreezeFlag is not null  ";
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//添加机构项下
	sWhere += OrgCondition.getOrgCondition("InputOrgID",CurOrg.OrgID,Sqlca); 
	doTemp.WhereClause+=sWhere;
	
	doTemp.UpdateTable="ENT_AGREEMENT";
	doTemp.setKey("SerialNo",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("Currency","2");
	doTemp.setVisible("LoanType",false);
	
	doTemp.setType("LoanSum,BailRatio,LoanTerm,LoanRatio,AGREEMENTScale","Number");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency"," style={width:80px} ");
	
	//设置Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1=1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		
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
		{"true","","Button","冻结","冻结此协议","FreezeAgreement()",sResourcesPath},
		{"true","","Button","解冻","解冻此协议","CancelFreeze()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		//{"true","","Button","查询","查询","payBackCheck()",sResourcesPath},
		};
		
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
		OpenComp("EntAgreementInfo","/CreditManage/CreditLine/EntAgreementInfo.jsp","","_blank",OpenStyle)
		reloadSelf();
	}
	
	/*~[Describe=冻结协议;InputParam=无;OutPutParam=无;]~*/
	function FreezeAgreement()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sReturn = RunMethod("CreditLine","CheckFreeze",sSerialNo);
		if(sReturn == "2")
		{
			alert("该额度已经被冻结，不能进行此操作！");
			return;
		}
		
		if(confirm("您确定要冻结此额度吗？"))
		{
	        RunMethod("CreditLine","FreezeAgreement",sSerialNo);
	        reloadSelf();
		}
	}
	
	
	/*~[Describe=解冻协议;InputParam=无;OutPutParam=无;]~*/
	function CancelFreeze()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sReturn = RunMethod("CreditLine","CheckFreeze",sSerialNo);
		if(sReturn != "2")
		{
			alert("该额度未被冻结，不能进行此操作！");
			return;
		}
		
		if(confirm("您确定要解除此额度冻结吗？"))
		{
	        RunMethod("CreditLine","CancelFreeze",sSerialNo);
	        reloadSelf();
		}
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
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
	        RunMethod("CreditLine","DeleteAgreementRelative",sSerialNo);
	        as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
	        reloadSelf();
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
			OpenComp("EntAgreementInfo","/CreditManage/CreditLine/EntAgreementInfo.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
			reloadSelf();
		}
	}
	
	/*~[Describe=余额查询;InputParam=无;OutPutParam=无;]~*/
	function payBackCheck()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = sSerialNo;
		sObjectType = "EntAgreement";
		sTradeType = "6003";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else{
			alert("发送个贷系统成功！日间还款总额为["+parseFloat(sReturn[1])+"]");
			//reloadSelf();
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
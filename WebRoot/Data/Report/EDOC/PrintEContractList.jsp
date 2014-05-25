<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: lfang 2008.04.21 电子合同打印列表
		Tester:
		Describe:
		Input Param:
			ObjectType
			ObjectNo
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "电子合同打印列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "",sSql1="",sPhaseType="";

	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sFlag == null) sFlag = "";

	String sECOrgID = "";
	sECOrgID = Sqlca.getString(" select VitualID from ORG_INFO where OrgID = '"+CurOrg.OrgID+"' ");
	if(sECOrgID == null) sECOrgID = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"EDocNo","电子合同编号"},
							{"EDocNoName","电子合同名称"},
							};

	sSql =  //业务主合同
			" select ObjectNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" ObjectType as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" union "+
			//甲方贷款本金分期还款表（借款合同附件）
			" select ObjectNo,'A101' as EDocNo,getItemName('ElectronicContractType','A101') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType in ('A001','A050') "+
			" union "+
			//贴现汇票清单（汇票贴现合同）
			" select ObjectNo,'A102' as EDocNo,getItemName('ElectronicContractType','A102') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'A002' "+
			" union "+
			//银行承兑汇票清单（汇票承兑合同附件）
			" select ObjectNo,'A103' as EDocNo,getItemName('ElectronicContractType','A103') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'A004' "+
			" union "+
			//甲方展期借款本金分期还款表（借款展期合同附件）
			" select ObjectNo,'A104' as EDocNo,getItemName('ElectronicContractType','A104') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'A012' "+
			" union "+
			//抵押房地产详情（楼宇按揭抵押借款合同附件）
			" select ObjectNo,'C101' as EDocNo,getItemName('ElectronicContractType','C101') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType in ('C002','C051') "+
			" union "+
			//甲方贷款本金分期还款表（委托贷款合同附件）
			" select ObjectNo,'F025' as EDocNo,getItemName('ElectronicContractType','F025') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'F006' "+
			" union "+
			//委托贷款协议（与委托贷款合同一并展示）
			" select ObjectNo,'F007' as EDocNo,getItemName('ElectronicContractType','F007') as EDocNoName, "+
			" ObjectType as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'F006' "+
			" union "+
			//仓单质押监管协议
			" select SerialNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" 'ECIndependent1' as ObjectType,SerialNo as ObjectNo "+
			" from ECONTRACT_INDEPENDENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'A014' "+
			" union "+
			//工贸银三方协议
			" select SerialNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" 'ECIndependent2' as ObjectType,SerialNo as ObjectNo "+
			" from ECONTRACT_INDEPENDENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'A015' "+
			" union "+
			//担保合同
			" select SerialNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" 'GuarantyContract' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType in ('E001','E002','E003','E004','E005','E006','E007','E008') "+
			" and ECTempSaveFlag = '2' "+
			" union "+
/*
			//抵押物价值确认书
			" select SerialNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" 'ECGuaranty' as ObjectType,SerialNo as ObjectNo "+
			" from ECONTRACT_GUARANTY "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" union "+
*/
			//抵押物价值确认书（标准版楼宇按揭抵押借款合同附件）
			" select ObjectNo,'C102' as EDocNo,getItemName('ElectronicContractType','C102') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType in ('C002','C051') "+
			" and IsItem14 = '10' "+
			" union "+
			//抵押物价值确认书（深圳宝安版楼宇按揭抵押借款合同附件）
			" select ObjectNo,'C103' as EDocNo,getItemName('ElectronicContractType','C103') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType in ('C002','C051') "+
			" and IsItem14 = '20' "+
			" union "+
			//抵押物价值确认书（标准版抵押合同附件）
			" select SerialNo,'E010' as EDocNo,getItemName('ElectronicContractType','E010') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E005' "+
			" and ECTempSaveFlag = '2' "+
			" and FinanceItem7 = '10' "+
			" union "+
			//抵押物价值确认书（深圳宝安版抵押合同附件）
			" select SerialNo,'E011' as EDocNo,getItemName('ElectronicContractType','E011') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E005' "+
			" and ECTempSaveFlag = '2' "+
			" and FinanceItem7 = '20' "+
			" union "+
			//抵押物清单（抵押合同附件）
			" select SerialNo,'E012' as EDocNo,getItemName('ElectronicContractType','E012') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E005' "+
			" and ECTempSaveFlag = '2' "+
			" and (FinanceItem6 = '2' or FinanceItem6 is null) "+
			" union "+
			//抵押物清单（抵押合同上海版附件）
			" select SerialNo,'E016' as EDocNo,getItemName('ElectronicContractType','E016') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E005' "+
			" and ECTempSaveFlag = '2' "+
			" and FinanceItem6 = '1' "+
			" union "+
			//现有抵押财产清单（浮动抵押合同附件）
			" select SerialNo,'E013' as EDocNo,getItemName('ElectronicContractType','E013') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E006' "+
			" and ECTempSaveFlag = '2' "+
			" union "+
			//质物清单（质押合同附件）
			" select SerialNo,'E014' as EDocNo,getItemName('ElectronicContractType','E014') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E007' "+
			" and ECTempSaveFlag = '2' "+
			" union "+
			//质押应收账款清单（应收账款质押合同）
			" select SerialNo,'E015' as EDocNo,getItemName('ElectronicContractType','E015') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E008' "+
			" and ECTempSaveFlag = '2' "+
			" union "+
			//保函正本合同
			" select SerialNo,LGType as EDocNo,getItemName('ElectronicContractType',LGType) as EDocNoName, "+
			" 'ECLG1' as ObjectType,SerialNo as ObjectNo "+
			" from ECONTRACT_LG1 "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" union "+
			//独立合同
			" select SerialNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" 'ElectronicContract' as ObjectType,SerialNo as ObjectNo "+
			" from ECONTRACT_INDEPENDENT "+
			" where SerialNo = '"+sObjectNo+"' "+
			" order by EDocNo ";
			;

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable="BUSINESS_CONTRACT";

	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	//设置html格式
	doTemp.setHTMLStyle("EDocNoName"," style={width:300px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页

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
		{"true","","Button","打印电子合同","打印电子合同","printContract()",sResourcesPath},
		{"true","","Button","重新生成合同","电子合同重新生成","genContract()",sResourcesPath},
		{(sFlag.equals("")&&sECOrgID.equals("")?"true":"false"),"","Button","打印电子签章","打印电子签章","printStamper1()",sResourcesPath},
		{(sFlag.equals("")&&sECOrgID.equals("1")?"true":"false"),"","Button","发送电子签章","发送电子签章","printStamper()",sResourcesPath},
	};

	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=打印电子合同;InputParam=无;OutPutParam=无;]~*/
	function printContract()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sEDocNo = getItemValue(0,getRow(),"EDocNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		sReturn = PopPage("/Common/EDOC/EDocCreateCheckAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
		if (typeof(sReturn)=="undefined") {
	        alert("打印电子合同失败！！");
		    return;
		}
		else if (sReturn=="nodef") {
			alert("对应的产品未定义电子合同模版,不能生成电子合同！");
			return;
		}
		else if (sReturn=="nodoc") {
			if(confirm("电子合同未生成！确定要生成电子打印合同吗？"))
			{
				sReturn = PopPage("/Common/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
			    if (typeof(sReturn)=="undefined") {
			        alert("生成电子合同失败！");
				    return;
				}
			}
			else
			    return;
		}
		popComp("EDocView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn);
	}

	/*~[Describe=电子合同重新生成;InputParam=无;OutPutParam=无;]~*/
	function genContract()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sEDocNo = getItemValue(0,getRow(),"EDocNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		sReturn = PopPage("/Common/EDOC/EDocCreateCheckAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
	    if (typeof(sReturn)=="undefined") {
	        alert("打印电子合同失败！！");
		    return;
		}
		else if (sReturn=="nodef") {
			alert("对应的产品未定义电子合同模版,不能生成电子合同！");
			return;
		}
		else if (sReturn=="nodoc") {
			if(confirm("电子合同未生成！确定要生成电子打印合同吗？"))
			{
				sReturn = PopPage("/Common/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
			    if (typeof(sReturn)=="undefined") {
			        alert("生成电子合同失败！");
				    return;
				}
			}
			else
			    return;
		}
		else if (sReturn != "nodoc") {
			if(confirm("电子合同已经存在！确定要重新生成电子打印合同吗？"))
			{
				sReturn = PopPage("/Common/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
			    if (typeof(sReturn)=="undefined") {
			        alert("生成电子合同失败！");
				    return;
				}
			}
			else
			    return;
		}
		popComp("EDocView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn);
	}

	/*~[Describe=发送电子签章;InputParam=无;OutPutParam=无;]~*/
	function printStamper()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sEDocNo = getItemValue(0,getRow(),"EDocNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sReturn = PopPage("/Common/EDOC/Stamper/StamperCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
	    if (typeof(sReturn)=="undefined") {
	        alert("生成电子签章页失败！");
		    return;
		}
		else if (sReturn=="nodef") {
			alert("对应的产品未定义电子签章页模版,不能生成电子签章页！");
			return;
		}
		else if (sReturn=="nodoc") {
			alert("电子合同未生成且电子签章页为合同本身！请先生成电子合同！");
			return;
		}
		popComp("StatmperInfo","/Common/EDOC/Stamper/StamperInfo.jsp","SerialNo="+sReturn);
	}

	/*~[Describe=打印电子签章;InputParam=无;OutPutParam=无;]~*/
	function printStamper1()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sEDocNo = getItemValue(0,getRow(),"EDocNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		sReturn = PopPage("/Common/EDOC/Stamper/StamperCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
	    alert(sReturn);
		if (typeof(sReturn)=="undefined") {
	        alert("生成电子签章页失败！");
		    return;
		}
		else if (sReturn=="nodef") {
			alert("对应的产品未定义电子签章页模版,不能生成电子签章页！");
			return;
		}
		else if (sReturn=="nodoc") {
			alert("电子合同未生成且电子签章页为合同本身！请先生成电子合同！");
			return;
		}
		popComp("StamperView","/Common/EDOC/Stamper/StamperView.jsp","SerialNo="+sReturn);
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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/09/08
		Tester:
		Describe: 关联不良贷款信息列表
		Input Param:
			ObjectType: 对象类型
			ObjectNo：对象编号
		Output Param:
			SerialNo：业务流水号
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联不良贷款信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";
	String sSql1 = "select ApplyType ,ContractSerialNo from BADBIZ_APPLY where serialno='"+sObjectNo+"' " ;
	ASResultSet rs2 = Sqlca.getASResultSet(sSql1);
	String sApplyType = "";
	String sContractSerialNo = "";
	if(rs2.next()){
		sApplyType = rs2.getString(1);
		sContractSerialNo = rs2.getString(2);
	}
	rs2.getStatement().close();
	if(sApplyType == null) sApplyType = "";
%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	String sHeaders[][] = 	{
				{"SerialNo","流水号"},	
				{"ObjectNo","以资抵债申请编号"},
				{"ContractSerialNo","合同号流水号"},	
				{"ContractSerialNo1","抵债贷款合同流水号"},
				{"CustomerName","客户名称"},
				{"BusinessType","业务品种"},
				{"OccurType","发生类型"},
				{"BusinessCurrency","币种"},
				{"VouchType","担保方式"},
				{"BusinessSum","合同金额"},
				{"Balance","当前余额"},
				{"ClassifyResult","风险分类"},
				{"InterestBalance1","表内欠息"},
				{"InterestBalance2","表外欠息"},
				{"OriginalPutOutDate","首次发放日"},
				{"Maturity","最后到期日"},
				{"FinishDate","合同终结日期"},
//				{"Balance","结欠贷款本金(元)"},
//				{"Interest","结欠贷款利息(元)"},
				{"OrgName","登记机构"},
				{"UserName","登记人"},
				{"BadBizProjectFlagName","项目类型"},
				{"RecoveryOrgName","管理机构"},
				{"RecoveryUserName","管理责任人"},
				{"AssetSum","拟抵偿贷款本金"},
				{"AssetInterestBalance1","拟抵偿表内欠息"},
				{"AssetInterestBalance2","拟抵偿表外欠息"},
			      	};
	String sSql = "";
	if("030".equals(sApplyType)){
		 sSql =	" select SerialNo as ContractSerialNo,CustomerID,getCustomerName(CustomerID) as CustomerName,"+
						" getBusinessName(BusinessType) as BusinessType , getItemName('OccurType',OccurType) as OccurType,"+
						" getItemName('Currency',BusinessCurrency) as BusinessCurrency ,getItemName('VouchType',VouchType) as VouchType," +
						" BusinessSum,Balance,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult ,InterestBalance1,"+
						" InterestBalance2,OriginalPutOutDate,Maturity,FinishDate "+
						" from BUSINESS_CONTRACT " +
						" where SerialNo = '"+sContractSerialNo+"'";
	}else{
		 sSql =	" select AB.SerialNo,AB.ObjectNo as ObjectNo,AB.ContractSerialNo as ContractSerialNo1,AB.CustomerID,"+
						" getBusinessName(BC.BusinessType) as BusinessType , getItemName('OccurType',BC.OccurType) as OccurType,"+
						" getCustomerName(AB.CustomerID) as CustomerName,"+
						" getItemName('Currency',BC.BusinessCurrency) as BusinessCurrency ,getItemName('VouchType',BC.VouchType) as VouchType," +
						" BC.BusinessSum,AB.Balance,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResult ,BC.InterestBalance1,"+
						" BC.InterestBalance2,BC.OriginalPutOutDate,BC.Maturity,BC.FinishDate ,"+
						" AB.InputOrgID,getOrgName(AB.InputOrgID) as OrgName,AB.InputUserID,getUserName(AB.InputUserID) as UserName, " +
						" getItemName('BadBizProjectFlag',BC.BadBizProjectFlag) as BadBizProjectFlagName,"+
						" getOrgName(BC.RecoveryOrgID) as RecoveryOrgName,"+
						" getUserName(BC.RecoveryUserID) as RecoveryUserName,"+
						" AB.AssetSum,AB.InterestBalance1 as AssetInterestBalance1,AB.InterestBalance2 as AssetInterestBalance2 "+
						" from ASSET_BIZ AB,BUSINESS_CONTRACT BC " +
						" where AB.ContractSerialNo = BC.SerialNo and "+
						" AB.ObjectNo='"+sObjectNo+"' and AB.ObjectType='"+sObjectType+"' " ;

	}
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_BIZ";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	doTemp.setVisible("ObjectType,CustomerID,InputOrgID,InputUserID,SerialNo",false);
	if("030".equals(sApplyType))
	{
		doTemp.setVisible("BusinessCurrency,VouchType,OriginalPutOutDate,Maturity,FinishDate,OrgName,UserName",false);
	}else{
		doTemp.setVisible("BadBizProjectFlagName,RecoveryOrgName,RecoveryUserName,AssetSum,AssetInterestBalance1,AssetInterestBalance2",false);
	}
	doTemp.setUpdateable("UserName,OrgName",false);

	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	
	//设置小数显示状态,
	doTemp.setAlign("BusinessSum,Balance,InterestBalance1,InterestBalance2,AssetSum,AssetInterestBalance1,AssetInterestBalance2","3");
	doTemp.setType("BusinessSum,Balance,InterestBalance1,InterestBalance2,AssetSum,AssetInterestBalance1,AssetInterestBalance2","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum,Balance,InterestBalance1,InterestBalance2,AssetSum,AssetInterestBalance1,AssetInterestBalance2","2");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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

	String sButtons[][] = 
		{
		{"true","","Button","新增","新增关联不良贷款信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看关联不良贷款信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除关联不良贷款信息","deleteRecord()",sResourcesPath},
		};
		
	if("030".equals(sApplyType)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
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
		OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/AssetBizInfo.jsp","_self","");
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
		if("<%=sApplyType%>" == "030"){		
			sObjectType = "BusinessContract";
			sObjectNo = getItemValue(0,getRow(),"ContractSerialNo");
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
			{
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}
		else{
			sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			{
				alert(getHtmlMessage('1'));//请选择一条信息！
			}else
			{
				OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/AssetBizInfo.jsp?SerialNo="+sSerialNo, "_self","");
			}
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

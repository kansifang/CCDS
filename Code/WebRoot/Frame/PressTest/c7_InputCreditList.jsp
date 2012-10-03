<%@	page contentType="text/html; charset=GBK"%>
<%@	include file="IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: 信贷数据补登列表;
		Input Param:
					DataInputType：010需补登信贷业务
									020补登完成信贷业务
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信贷数据补登列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";
	
	String sClauseWhere="";
	//获得页面参数
	
	//获得组件参数
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));

	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	if(sFlag==null) sFlag="";
	sReinforceFlag="010";
	
	String sHeaders[][] = {
					{"SerialNo","合同流水号"},
					{"CustomerName","客户名称"},
					{"CustomerTypeName","客户类型"},
					{"CustomerID","客户编号"},
					{"BusinessTypeName","业务品种"},
					{"ArtificialNo","合同编号"},
					{"OccurTypeName","发生类型"},
					{"Currency","币种"},
					{"BusinessSum","合同金额(元)"},
					{"Balance","余额(元)"},
					{"VouchTypeName","主要担保方式"},
					{"PutOutDate","起始日期"},
					{"Maturity","到期日期"},
					{"OperateOrgName","经办机构"},
				  };

	if(sReinforceFlag.equals("010"))  //待补登的业务
	{
	
		if(sFlag.equals("Y"))  //不良资产补登
		{
			sClauseWhere = " and ManageOrgID ='"+CurOrg.OrgID+"' and (RecoveryOrgID='' or RecoveryOrgID is null)";
		}
		else	//信贷信息补登
		{
			sClauseWhere = " and ManageOrgID ='"+CurOrg.OrgID+"' and (RecoveryOrgID='' or RecoveryOrgID is null)";
		}
	}
	if(sReinforceFlag.equals("020"))  //补登完成的业务
	{
	
		if(sFlag.equals("Y"))  //不良资产补登
		{
			sClauseWhere = " and ManageOrgID ='"+CurOrg.OrgID+"' and (RecoveryOrgID<>'' or RecoveryOrgID is not null)";
		}
		else	//信贷信息补登
		{
			sClauseWhere = " and ManageOrgID ='"+CurOrg.OrgID+"' and (RecoveryOrgID='' or RecoveryOrgID is null)";
		}
	}
	
	 sSql = " select SerialNo,CustomerName,"+
			" CustomerID,getCustomerType(CustomerID) as CustomerType,"+
			" getItemName('CustomerType',getCustomerType(CustomerID)) as CustomerTypeName,"+
			" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
			" ArtificialNo,"+
			" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
			" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
			" BusinessSum,Balance,"+
			" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
			" PutOutDate,Maturity,"+
			" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
			" from BUSINESS_CONTRACT"+
			" where (BusinessType like '[1,2,5]%' or BusinessType is null)"+
			" and ReinforceFlag = '"+sReinforceFlag+"' "
			+sClauseWhere ;
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
		
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setKeyFilter("SerialNo"); //add by hxd in 2005/02/21
	
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("SerialNo,BusinessType,CustomerType,OccurType,BusinessCurrency,VouchType,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:180px} ");
	
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,ArtificialNo","IsFilter","1");
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
	};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=客户详情;InputParam=无;OutPutParam=无;]~*/
	function CustomerInfo()
	{
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			var sReturn = PopPage("/InfoManage/DataInput/CustomerQueryAction.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("要查询的客户信息不存在！");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("要查询的客户类型为空，请选择客户类型！");
			}
			openObject("Customer",sCustomerID,"001");
		}
	}

	/*~[Describe=合同详情;InputParam=无;OutPutParam=无;]~*/
	function BusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			openObject("AfterLoan",sSerialNo,"002");
		}
	}

	/*~[Describe=补登客户信息;InputParam=无;OutPutParam=无;]~*/
	function InputCustomerInfo()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			var sReturn = PopPage("/InfoManage/DataInput/CustomerQueryAction.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("要补登的客户信息不存在！");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("要补登的客户类型为空，请选择客户类型！");
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
				if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
				sCustomerType = sReturn;
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			}
			openObject("Customer",sCustomerID,"000");
		}
	}

	/*~[Describe=补登业务信息;InputParam=无;OutPutParam=无;]~*/
	function InputBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				sCustomerType   = getItemValue(0,getRow(),"CustomerType");
				sCustomerType = sCustomerType.substr(0,3);
				sReturn=selectObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=N");
				if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
				sss1 = sReturn.split("@");
				sBusinessType=sss1[0];
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
			}
			openObject("ReinforceContract",sSerialNo,"000");
			reloadSelf();
		}
	}

	/*~[Describe=改变客户类型;InputParam=无;OutPutParam=无;]~*/
	function changeCustomerType()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			sReturn=PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
			if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
			sCustomerType = sReturn;
			sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			reloadSelf();
		}
	}

	/*~[Describe=改变业务品种;InputParam=无;OutPutParam=无;]~*/
	function changeBusinessType()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			sCustomerType   = getItemValue(0,getRow(),"CustomerType");
			sCustomerType = sCustomerType.substr(0,3);
			sReturn=selectObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=N");
			if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
			sss1 = sReturn.split("@");
			sBusinessType=sss1[0];
			sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
			reloadSelf();
		}
	}

	/*~[Describe=新增合同;InputParam=无;OutPutParam=无;]~*/
	function NewContract()
	{
		var sFlag="<%=sFlag%>";
		
		if(sFlag=="Y")
		{
			var sReturn = createObject("NPAReinforceContract","");
		}
		else
		{
			var sReturn = createObject("ReinforceContract","");
		}
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		reloadSelf();
	}

	/*~[Describe=置完成补登标志;InputParam=无;OutPutParam=无;]~*/
	function Finished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm("真的要补登完成吗？")) 
			{
				var sFlag="<%=sFlag%>";
			
				if(sFlag=="Y")   //不良资产补登完成
				{
					sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag,"","");
				}
				else
				{
					sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo,"","");
				}
				if(sReturn == "succeed")
				{
					alert(getBusinessMessage('186'));
				}
				//reloadSelf();
				OpenComp("DataInputMain","/InfoManage/DataInput/DataInputMain.jsp","ComponentName=信息补充登记&Component=N&ComponentType=MainWindow","_top","")
			}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=再次补登;InputParam=无;OutPutParam=无;]~*/
	function secondFinished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm("真的要再次补登吗？")) 
		{
			
			var sFlag="<%=sFlag%>";
			var sFlag1 = "SecondFlag";
			
			if(sFlag=="Y")   //不良资产补登完成
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag+"&Flag1="+sFlag1,"","");
			}
			else
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag1=SecondFlag","","");
			}
			
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			
			if(sReturn == "true")
			{
				alert("再次补登，所选数据将回到需补登业务列表!");
			}
			
			if(sReturn == "false")
			{
				alert("所选资产已经分发,不能再次补登!");
			}
			reloadSelf();
		}
	}


	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="IncludeEnd.jsp"%>

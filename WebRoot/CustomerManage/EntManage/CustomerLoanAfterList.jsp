<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: 未结清授信业务列表;
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			ObjectType: 对象类型。
			ObjectNo: 对象编号。
			BackType: 返回方式类型(Blank)

		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	增加过滤器		
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未结清授信业务列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	String sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"BusinessTypeName","业务品种"},
							{"SerialNo","合同流水号"},
							{"OccurTypeName","发生类型"},
							{"Currency","币种"},
							{"BusinessSum","合同金额"},
							{"Balance","余额"},
							{"ClassifyResultName","风险分类"},
							{"VouchTypeName","主要担保方式"},
							{"PutOutDate","起始日期"},
							{"Maturity","到期日期"},
							{"ManageOrgName","管户机构"}, 
							{"OperateOrgName","经办机构"},
						  };	

	String sSql =   " select SerialNo,"+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,Balance,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" PutOutDate,Maturity,"+
					" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where CustomerID='"+sCustomerID+"' "+					
					" and (FinishDate = '' or FinishDate is null) "+
					" and (BusinessType like '1%' "+
					" or BusinessType like '2%' ) ";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("OperateOrgName,BusinessType,OccurType,BusinessCurrency,VouchType,ManageOrgID,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setAlign("OccurTypeName,Currency,VouchTypeName,BusinessTypeName,Maturity,PutOutDate","2");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName,OccurTypeName"," style={width:80px} ");
	doTemp.setHTMLStyle("OperateOrgName,ManageOrgName" ,"style={width:200px} ");	
   //生成过滤器
	doTemp.setColumnAttribute("SerialNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
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
		{"true","","Button","详情","查看未结清授信业务详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","信息汇总","信息汇总","infoGather()",sResourcesPath},
		{"true","","Button","检查实时余额","检查实时余额","checkBalance()",sResourcesPath},
		{sCustomerType.startsWith("03")?"true":"false","","Button","保易贷理赔扣款申请","保易贷理赔扣款申请","deductApply()",sResourcesPath},
		{sCustomerType.startsWith("03")?"true":"false","","Button","保易贷理赔扣款取消","保易贷理赔扣款取消","deductCancel()",sResourcesPath},
		{sCustomerType.startsWith("03")?"true":"false","","Button","担保代偿查询","担保代偿查询","assurePay()",sResourcesPath},
    };
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=AfterLoan&ObjectNo="+sSerialNo+"&ViewID=002";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
   
   	/*~[Describe=汇总详情;InputParam=无;OutPutParam=无;]~*/
	function infoGather()
	{
		popComp("CustomerLoanAfterGather","/CustomerManage/EntManage/CustomerLoanAfterGather.jsp","CustomerID=<%=sCustomerID%>","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=检查实时余额;InputParam=无;OutPutParam=无;]~*/
	function checkBalance()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			sBusinessType = getItemValue(0,getRow(),"BusinessType");
			if(sBusinessType=='1110010' || sBusinessType=='1110020' || sBusinessType=='1140060'
			 || sBusinessType=='1140010' || sBusinessType=='1140020' || sBusinessType=='1140110' 
			 || sBusinessType=='2110010'|| sBusinessType=='1140025' || sBusinessType == '1110025')
			{
				//alert("个贷系统尚未上线，不能查询！");
				sObjectNo=sSerialNo;
				sObjectType="CheckBalance";
				sTradeType = "6002";
				sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
					return;
				}else{
					alert("发送个贷成功!"+sReturn[1]);
					reloadSelf();
				}
			}else
			{
				sObjectNo=sSerialNo;
				sObjectType="CheckBalance";
				sTradeType="798004";
				sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
					return;
				}else{
					alert("发送核心成功!"+sReturn[1]);
					reloadSelf();
				}
			}
		}
	}
	
	/*~[Describe=保易贷理赔扣款申请;InputParam=无;OutPutParam=无;]~*/
	function deductApply()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		//sSerialNo="9031001000900916";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			///alert("个贷系统尚未上线，不能做保易贷理赔扣款申请！");
			sBusinessType = getItemValue(0,getRow(),"BusinessType");
			if(sBusinessType=='1140110')
			{
				sObjectNo=sSerialNo;
				sObjectType="deductApply";
				sTradeType = "6010";
				sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
					return;
				}else{
					alert("发送个贷成功!"+sReturn[1]);
					reloadSelf();
				}
			}
		}
	}
	
	/*~[Describe=保易贷理赔扣款取消;InputParam=无;OutPutParam=无;]~*/
	function deductCancel()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		//sSerialNo="9031001000900916";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			//alert("个贷系统尚未上线，不能做保易贷理赔扣款申请！");
			sBusinessType = getItemValue(0,getRow(),"BusinessType");
			if(sBusinessType=='1140110')
			{
				sObjectNo=sSerialNo;
				sObjectType="deductCancel";
				sTradeType = "6011";
				sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
					return;
				}else{
					alert("发送个贷成功!"+sReturn[1]);
					reloadSelf();
				}
			}
		}
	}
	
	//----------------公积金担保代偿----------------
	function assurePay()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sObjectType = getItemValue(0,getRow(),"BusinessType");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sTradeType = "6024";
		//var sReturn = RunMethod("WorkFlowEngine","GetAfaloanFlag3",sSerialNo);
		if(sBusinessType == '2110020' || sBusinessType == '1110027')
		{
			sReturn = RunMethod("BusinessManage","SendGD",sSerialNo+","+sObjectType+","+sTradeType);
			sReturn=sReturn.split("@");
			if(sReturn[0] != "0000000"){
				alert("公积金系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
				return;
			}else{
				alert("发送公积金系统成功！"+sReturn[1]);
			}
		}else
		{
			alert("该笔贷款不是公积金贷款！");
			return;
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

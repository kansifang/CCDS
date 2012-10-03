<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: bma 2008-09-17
		Tester:
		Describe: 补登列表;
		Input Param:
		DataInputType：020010未结清垫款
					   020020已结清垫款
					   030010已结清国际业务
					   030020已结清国际业务
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "补登列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";
	
	//获得组件参数
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag1"));
	if(sReinforceFlag==null) sReinforceFlag="";
	if(sFlag==null) sFlag="";
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
					{"SerialNo","借据号"},
					{"RelativeSerialNo1","原业务编号"},
					{"CustomerID","客户编号"},
					{"CustomerName","客户名称"},
					{"BusinessStatus","垫款状态"},
					{"BusinessCurrency","币种"},					
					{"BusinessType","垫款种类"},
					{"ReturnType","还款方式"},
					{"ClassifyResult","五级分类状态"},									
					{"PutoutDate","垫款发生日期"},
					{"Balance","垫款余额(元)"},
					{"NormalBalance","正常余额(元)"},
					{"OverdueBalance","逾期余额(元)"},
					{"DullBalance","呆滞余额(元)"},
					{"BadBalance","呆帐余额(元)"},
					{"InputOrgName","登记机构"},
					{"InputUserName","登记人"},
					{"InputDate","登记日期"}					
				  };
	String sHeaders1[][] = {
					{"SerialNo","借据号"},
					{"Describe2","业务编号"},
					{"RelativeSerialNo2","合同编号"},
					{"CustomerID","客户编号"},
					{"CustomerName","客户名称"},
					{"BusinessType","业务品种"},
					{"SubjectNo","会计科目"},
					{"BusinessCurrency","币种"},					
					{"Balance","余额(元)"},
					{"NormalBalance","正常余额(元)"},
					{"OverdueBalance","逾期余额(元)"},
					{"DullBalance","呆滞余额(元)"},
					{"BadBalance","呆帐余额(元)"},
					{"BusinessStatus","业务状态"},
					{"PutoutDate","注销日期"},
					{"ClassifyResult","五级分类状态"},	
					{"ReturnType","还款方式"},
					{"InputOrgName","登记机构"},
					{"InputUserName","登记人"},
					{"InputDate","登记日期"}	
				};
	
	if(sReinforceFlag.equals("020010"))  //未结清垫款
	{
		 sSql = " select SerialNo,RelativeSerialNo1,CustomerID,getCustomerName(CustomerID) as CustomerName,"+
		 		" getItemName('BusinessStatusType',BusinessStatus) as BusinessStatus,"+
		 		" getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
		 		" getBusinessName(BusinessType) as BusinessType,"+
		 		" getItemName('ReturnType',ReturnType) as ReturnType,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
		 		" PutoutDate,Balance,NormalBalance,OverdueBalance,DullBalance,"+
		 		" BadBalance,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate "+
		 		" from BUSINESS_DUEBILL where BusinessType like '1130%' and "+
		 		" (BusinessStatus = '01' or BusinessStatus = '' or BusinessStatus is null) "+
		 		" order by SerialNo desc";
	}else if(sReinforceFlag.equals("020020"))//已结清垫款
	{
		sSql = " select SerialNo,RelativeSerialNo1,CustomerID,getCustomerName(CustomerID) as CustomerName,"+
	 		" getItemName('BusinessStatusType',BusinessStatus) as BusinessStatus,"+
	 		" getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
	 		" getBusinessName(BusinessType) as BusinessType,"+
	 		" getItemName('ReturnType',ReturnType) as ReturnType,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
	 		" PutoutDate,Balance,NormalBalance,OverdueBalance,DullBalance,"+
	 		" BadBalance,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate "+
	 		" from BUSINESS_DUEBILL where BusinessType like '1130%' and BusinessStatus = '82'"+
	 		" order by SerialNo desc";
	}else if(sReinforceFlag.equals("030010"))  //未结清国际业务
	{
		 sSql = " select SerialNo,Describe2,RelativeSerialNo2,CustomerID,getCustomerName(CustomerID) as CustomerName,"+
		 		" getItemName('BusinessStatusType1',BusinessStatus) as BusinessStatus,"+
		 		" getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
		 		" getBusinessName(BusinessType) as BusinessType,"+
		 		" SI.subjectno||subjectname as subjectno,"+
		 		" getItemName('ReturnType',ReturnType) as ReturnType,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
		 		" Balance,NormalBalance,OverdueBalance,DullBalance,"+
		 		" BadBalance,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate "+
		 		" from BUSINESS_DUEBILL BD,SUBJECT_INFO SI where BD.SubjectNo = SI.SubjectNo and (BusinessType like '1080%' or BusinessType like '2060%' or BusinessType like '2050%') and"+
		 		" (BusinessStatus = '10' or BusinessStatus = '' or BusinessStatus is null)"+
		 		" order by Describe2 desc";
	}else if(sReinforceFlag.equals("030020"))//已结清国际业务
	{
		sSql = " select SerialNo,Describe2,RelativeSerialNo2,CustomerID,getCustomerName(CustomerID) as CustomerName,"+
	 		" getItemName('BusinessStatusType1',BusinessStatus) as BusinessStatus,"+
	 		" getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
	 		" getBusinessName(BusinessType) as BusinessType,"+
	 		" SI.subjectno||subjectname as subjectno,"+
	 		" getItemName('ReturnType',ReturnType) as ReturnType,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
	 		" PutoutDate,Balance,NormalBalance,OverdueBalance,DullBalance,"+
	 		" BadBalance,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate "+
	 		" from BUSINESS_DUEBILL BD,SUBJECT_INFO SI where BD.SubjectNo = SI.SubjectNo and (BusinessType like '1080%' or BusinessType like '2060%' or BusinessType like '2050%') and BusinessStatus = '20'"+
	 		" order by Describe2 desc";
	}
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//由SQL语句生成窗体对象
	if(sReinforceFlag.equals("020010")||sReinforceFlag.equals("020020"))  //垫款
	{
		doTemp.setHeader(sHeaders);
	}else	//国际业务
	{
		doTemp.setHeader(sHeaders1);
	}
	doTemp.UpdateTable = "BUSINESS_DUEBILL";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置不可见项
	//doTemp.setVisible("CustomerID,CustomerType,OccurType,BusinessCurrency,VouchType",false);
	//doTemp.setVisible("BusinessType,FinishType",false);
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance","3");
	doTemp.setCheckFormat("BusinessSum,Balance,Interestbalance1,Interestbalance2","2");
	
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,InputDate"," style={width:80px} ");
	//doTemp.setHTMLStyle("CustomerTypeName,CertID,ManageUserIDName"," style={width:80px} ");
	//doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	//doTemp.setHTMLStyle("VouchTypeName"," style={width:170px} ");
	//doTemp.setHTMLStyle("BusinessTypeName"," style={width:100px} ");
		
	//生成查询框
	if(sReinforceFlag.equals("020010") ||sReinforceFlag.equals("020020"))
	{
		doTemp.setColumnAttribute("CustomerName,SerialNo,BusinessType","IsFilter","1");
	}else
	{
		doTemp.setColumnAttribute("CustomerName,SerialNo,BusinessType,Describe2,RelativeSerialNo2","IsFilter","1");
	}
		
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10); //服务器分页

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
				{"true","","Button","新增","新增","NewContract()",sResourcesPath},
				{"true","","Button","详情","详情","CreditBusinessInfo()",sResourcesPath},
				{"true","","Button","删除","删除","my_del()",sResourcesPath}
			};
	
	//已结清垫款
	if(sReinforceFlag.equals("020020") ||sReinforceFlag.equals("030020")) 
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function NewContract()
	{
		//将jsp中的变量值转化成js中的变量值
		sReinforceFlag = "<%=sReinforceFlag%>";
		sSerialNo = "";
		
		if(sReinforceFlag == "020010")	//未结清垫款补登
		{
			//弹出新增页面
			sCompID = "NewContract";
			sCompURL = "/InfoManage/DataInput/NewContract.jsp";
			sReturn = popComp(sCompID,sCompURL,"SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
			sReturn = sReturn.split("@");
			sSerialNo=sReturn[0];
			
	        //根据新生成的流水号，打开申请详情界面
			sCompID = "NewInputInfo";
			sCompURL = "/InfoManage/DataInput/NewInputInfo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}else	//未结清国际业务
		{
			//弹出新增页面
			sCompID = "NewNational";
			sCompURL = "/InfoManage/DataInput/NewNational.jsp";
			sReturn = popComp(sCompID,sCompURL,"SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
			sReturn = sReturn.split("@");
			sSerialNo=sReturn[0];
			
	        //根据新生成的流水号，打开申请详情界面
			sCompID = "NewNationalInfo";
			sCompURL = "/InfoManage/DataInput/NewNationalInfo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}		
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=详情;InputParam=无;OutPutParam=无;]~*/
	function CreditBusinessInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(sReinforceFlag == "030010" ||sReinforceFlag == "030020" ) //国际业务
		{
			 //根据新生成的流水号，打开申请详情界面
			sCompID = "NewNationalInfo";
			sCompURL = "/InfoManage/DataInput/NewNationalInfo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}else	//垫款补登
		{
			 //根据新生成的流水号，打开申请详情界面
			sCompID = "NewInputInfo";
			sCompURL = "/InfoManage/DataInput/NewInputInfo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		reloadSelf();
	}
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function my_del()
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

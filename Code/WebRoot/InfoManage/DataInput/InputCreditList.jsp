<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

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
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag1"));
	if(sReinforceFlag==null) sReinforceFlag="";
	if(sFlag==null) sFlag="";
	
	String sHeaders[][] = {
					{"SerialNo","合同流水号"},
					{"CustomerName","客户名称"},
					{"CustomerID","客户编号"},
					{"MFCustomerID","核心客户号"},
					{"CertTypeName","证件类型"},
					{"CertID","证件号码"},
					{"LoanCardNo","贷款卡号"},
					{"CreditLevelName","客户评级结果"},
					{"BusinessTypeName","业务品种"},					
					{"OccurTypeName","发生类型"},
					{"BDSerialNo","贷款账号"},
					{"ClassifyResultName","当前风险分类结果"},
					{"LowRiskName","是否低风险业务"},
					{"FinishType","终结方式"},
					{"FinishTypeName","终结方式"},									
					{"Currency","币种"},
					{"BusinessSum","合同金额(元)"},
					{"Balance","余额(元)"},
					{"NormalBalance","正常余额(元)"},
					{"OverdueBalance","逾期余额(元)"},
					{"DullBalance","呆滞余额(元)"},
					{"BadBalance","呆帐余额(元)"},
					{"Interestbalance1","表内欠息(元)"},
					{"Interestbalance2","表外欠息(元)"},
					{"VouchTypeName","主要担保方式"},
					{"PutOutDate","起始日期"},
					{"Maturity","到期日期"},
					{"ManageOrgIDName","管户机构"},
					{"ManageUserIDName","管户人"}					
				  };

	if(sReinforceFlag.equals("010") || sReinforceFlag.equals("110"))  //待补登或新增的业务
	{	
		sClauseWhere = "  and BC.Balance>0 and BC.ManageOrgID in (select BelongOrgID from Org_Belong where OrgID = '"+CurOrg.OrgID+"') and (BC.DeleteFlag =''  or  BC.DeleteFlag is null) and (BC.FinishDate is null or BC.FinishDate ='')  order by BC.CustomerID,BC.PutOutDate ";
	}
	
	if(sReinforceFlag.equals("020") || sReinforceFlag.equals("120"))  //补登或新增完成的业务
	{
		sClauseWhere = "  and BC.ManageOrgID in (select BelongOrgID from Org_Belong where OrgID = '"+CurOrg.OrgID+"') and (BC.DeleteFlag =''  or  BC.DeleteFlag is null) order by BC.CustomerID,BC.PutOutDate ";

	}
	
	 sSql = " select CI.CustomerType,BC.SerialNo,BC.SerialNo as BDSerialNo,CI.MFCustomerID as MFCustomerID,"+
	 		" BC.CustomerName as CustomerName,"+
			" BC.CustomerID as CustomerID,"+
			" getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID as CertID,"+
			" CI.LoanCardNo as LoanCardNo,"+
			" getItemName('CreditLevel',getCreditLevel(BC.CustomerID)) as CreditLevelName,"+
			" BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
			" BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			" BC.FinishType,getItemName('FinishType',BC.FinishType) as FinishTypeName,"+
			" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as Currency,"+
			" BC.BusinessSum,BC.Balance,"+
			" BC.NormalBalance,BC.OverdueBalance,BC.DullBalance,BC.BadBalance,"+
			" BC.Interestbalance1,BC.Interestbalance2,"+
			" BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
			" BC.PutOutDate,BC.Maturity,"+
			" getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
			" getItemName('YesNo',LowRisk) as LowRiskName,"+
			" getUserName(BC.ManageUserID) as ManageUserIDName,"+
			" getOrgName(BC.ManageOrgID) as ManageOrgIDName "+
			" from BUSINESS_CONTRACT BC left join CUSTOMER_INFO CI ON CI.CUSTOMERID=BC.CUSTOMERID "+
			" where  "+
			" (BC.BusinessType like '1%' "+
			" or BC.BusinessType like '2%' "+
			" or BC.BusinessType like '5%' "+
			" or BC.BusinessType is null "+
			" or BC.BusinessType ='')"+
			" and BC.ReinforceFlag= '"+sReinforceFlag+"' "+
			" and (BC.FinishType not like '060%' "+
			" or BC.FinishType is null)"
			+sClauseWhere 
			+" with ur ";
	
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//out.println("<font color='red' size = 2>"+
	//			"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√如果额度项下业务先[额度补登管理]，否则先[补登业务]再[补登完成]，如果提示客户有问题并且信贷系统中确认此客户已[保存]成功，那么请在核心系统先做客户合并处理！√如果贷款所对应额度已经过期，那么贷款就可以按照“单笔授信业务”进行补登，并无需再补录其额度信息。"+
	//			"</font>");
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("BC.SerialNo");		//add by hxd in 2005/02/20 for 加快速度
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置不可见项
	doTemp.setVisible("CustomerType,OccurType,BusinessCurrency,VouchType",false);
	doTemp.setVisible("BusinessType,FinishType,FinishTypeName,Currency",false);
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("NormalBalance,OverdueBalance,DullBalance,BadBalance,BusinessSum,Balance,Interestbalance1,Interestbalance2","3");
	doTemp.setCheckFormat("NormalBalance,OverdueBalance,DullBalance,BadBalance,BusinessSum,Balance,Interestbalance1,Interestbalance2","2");
	
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerTypeName,CertID,ManageUserIDName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("SerialNo,CustomerID"," style={width:160px} ");
	doTemp.setHTMLStyle("VouchTypeName"," style={width:170px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:100px} ");
		
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,SerialNo,ManageOrgIDName","IsFilter","1");
		
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10); 	//服务器分页

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
				{"true","","Button","额度补登管理","额度补登管理","NewContract()",sResourcesPath},
				{"true","","Button","指定客户","补登客户信息","InputCustomerInfo()",sResourcesPath},	
				{"true","","Button","补登业务","补登业务信息","InputBusinessInfo()",sResourcesPath},
				{"false","","Button","额度详情","额度详情","CreditBusinessInfo()",sResourcesPath},
				{"false","","Button","删除额度","删除额度","DeleteContract()",sResourcesPath},
				{"true","","Button","补登客户信息","补登客户信息","InputCustomerInfo()",sResourcesPath},		
				{"true","","Button","补登完成","补登完成","Finished()",sResourcesPath},
				{"true","","Button","客户详情","客户详情","CustomerInfo()",sResourcesPath},
				{"true","","Button","业务详情","业务详情","BusinessInfo()",sResourcesPath},
				{"true","","Button","再次补登","再次补登","secondFinished()",sResourcesPath},
				{"true","","Button","改变业务品种","改变业务品种","changeBusinessType()",sResourcesPath},
				{"false","","Button","改变客户类型","改变客户类型","changeCustomerType()",sResourcesPath},
				{"true","","Button","合同合并","合同合并","UniteContract()",sResourcesPath},
				{"true","","Button","其他信贷资产业务补登","其他信贷资产业务补登","NewCreditContract()",sResourcesPath},
				{"false","","Button","删除合同","删除合同","DeleteContract()",sResourcesPath},
				{"true","","Button","分次放款业务合同补登","分次放款业务合同补登","dispartMendContract()",sResourcesPath}
			};
	String sButtons2[][] = {
				{"true","","Button","垫款关联原表外业务","垫款关联原表外业务","RelativeBusiness()",sResourcesPath},
				{"true","","Button","终结信息登记","终结信息登记","Account()",sResourcesPath},
				{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath}
			};
	
	//需补登信贷业务
	if(sReinforceFlag.equals("010")) 
	{
		//sButtons[2][0] = "false";
		//sButtons[3][0] = "false";
		//sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		//sButtons[7][0] = "false";
		sButtons[8][0] = "false";
		sButtons[9][0] = "false";
		sButtons[12][0] = "false";
	}
	
	//补登完成信贷业务
	if(sReinforceFlag.equals("020")) 
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[6][0] = "false";		
		sButtons[10][0] = "false";
		sButtons[11][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons2[0][0] = "false";
		sButtons[15][0] = "false";
		
	}
	
	//新增额度
	if(sReinforceFlag.equals("110")) 
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";		
		sButtons[7][0] = "false";
		sButtons[8][0] = "false";
		sButtons[9][0] = "false";
		sButtons[10][0] = "false";
		sButtons[11][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons2[0][0] = "false";
		
	}
	
	//补登完成额度
	if(sReinforceFlag.equals("120")) 
	{		
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[6][0] = "false";		
		sButtons[10][0] = "false";
		sButtons[11][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons2[0][0] = "false";
	}
	CurPage.setAttribute("Buttons2",sButtons2);
	
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
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function DeleteContract()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		
		var sFlag="<%=sFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{			
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句			
		}
	}
	
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
			
			////openObject("ReinforceCustomer",sCustomerID,"002");
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
			if(sReinforceFlag=="110") 
			{
				openObject("AfterLoan",sSerialNo,"000");
			}
			else
			{
				openObject("AfterLoan",sSerialNo,"002");
			}
		}
	}

	/*~[Describe=额度合同详情;InputParam=无;OutPutParam=无;]~*/
	function CreditBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			if(sReinforceFlag=="110") 
			{
				openObject("ReinforceContract",sSerialNo,"000");
			}else
			{
				openObject("ReinforceContract",sSerialNo,"002");
			}
		}
	}

	/*~[Describe=补登客户信息;InputParam=无;OutPutParam=无;]~*/
	function InputCustomerInfo()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sCustomerName   = getItemValue(0,getRow(),"CustomerName");
		sBusinessSum   = getItemValue(0,getRow(),"BusinessSum");
		sPutOutDate   = getItemValue(0,getRow(),"PutOutDate");
		sMaturity   = getItemValue(0,getRow(),"Maturity");
		sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
	    {
			var sParaString = "UserID"+","+"<%=CurUser.UserID%>"+",CustomerType,0,OrgID,<%=CurUser.OrgID%>";
			//alert(sParaString);
			var sObjectNoString = selectObjectValue("SelectReinforceCustomer",sParaString,"dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no");
			//alert(sObjectNoString);
			if(sObjectNoString=="_CLEAR_" ||sObjectNoString=="" || sObjectNoString=="_CANCEL_" || sObjectNoString=="_NONE_" || typeof(sObjectNoString)=="undefined") return;
			sReturn=sObjectNoString.split("@");
			var sCustomerID=sReturn[0];
			var sNewCustomerName=sReturn[1];
			if(confirm("你确认要把借据号为["+sSerialNo+"],客户名为["+sCustomerName+"],合同金额为["+sBusinessSum+"],到期日 期为["+sMaturity+"]的合同指定客户为["+sNewCustomerName+"]的业务吗？"))
			{
				if(sReturn == "EMPTY")
				{
					alert("要补登的客户类型为空，请选择客户类型！");
					sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
					if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
					sCustomerType = sReturn;
					sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
				}
				//alert(sCustomerID);
				//alert(sSerialNo);
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerIDAction.jsp?CustomerID="+sCustomerID+"&SerialNo="+sSerialNo,"","");
				if(sReturn=="succeed")
					alert("指定客户成功！");
				else 
					alert("指定客户失败！");
				//openObject("ReinforceCustomer",sCustomerID,"000");
				reloadSelf();
			}
		}
	}

	/*~[Describe=补登业务信息;InputParam=无;OutPutParam=无;]~*/
	function InputBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sCustomerType   = getItemValue(0,getRow(),"CustomerType");
		var sDependType = "";
		var sCreditAggreement = "";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{	
			if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0 || sCustomerID.length>16){
				alert("请先指定客户！");
				return;
			}
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{				
				sParaString = "CodeNo"+",DependType";		
				sReturn=setObjectValue("SelectCode",sParaString,"",0,0,"");
				if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
				{
					sss1 = sReturn.split("@");
					sDependType=sss1[0];		
					if(sDependType=="DependentApply"){
						sCLType =PopPage("/InfoManage/DataInput/AddCreditLineDialog.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
						if (!(sCLType=='_CANCEL_' || typeof(sCLType)=="undefined" || sCLType.length==0 || sCLType=='_CLEAR_' || sCLType=='_NONE_'))
						{
							sParaString = "BusinessType"+","+sCLType+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
							sCLSerialNo = setObjectValue("SelectCL",sParaString,"",0,0,"");
							sCLSerialNo = sCLSerialNo.split("@");
							sCreditAggreement=sCLSerialNo[0];
						}else{
							return;
						}
					}
					
					if (sCustomerType.substring(0,2) == "03")
					{
					   sReturn=setObjectValue("SelectIndBusinessType","","",0,0,"");	
					}else if(sCustomerType.substring(0,2)=="01")
					{
					   sReturn=setObjectValue("SelectEntBusinessType","","",0,0,"");	
					}else
					{
					   sReturn=setObjectValue("SelectAllBusinessType","","",0,0,"");	
					}			
					if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
					{
						sss1 = sReturn.split("@");
						sBusinessType=sss1[0];		
						if((sSerialNo.substring(0,4)=='0871'||sSerialNo.substring(0,2)=='BC')&&sBusinessType=='2010'){
							alert("此业务不能认定为承兑汇票！");
							return								
						}							
						sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction1.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType+"&ApplyType="+sDependType+"&CreditAggreement="+sCreditAggreement,"","");
					}else{
						return;
					}
				}else{
					return;
				}
			}
			openObject("ReinforceContract",sSerialNo,"001");
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
		}else 
		{
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
		var sCustomerType   = getItemValue(0,getRow(),"CustomerType");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sCreditAggreement = "";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{	
			if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0 || sCustomerID.length>16){
				alert("请先指定客户！");
				return;
			}		
			sParaString = "CodeNo"+",DependType";		
			sReturn=setObjectValue("SelectCode",sParaString,"",0,0,"");
			if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
			{
				sss1 = sReturn.split("@");
				sDependType=sss1[0];	
				if(sDependType=="DependentApply"){
					sCLType =PopPage("/InfoManage/DataInput/AddCreditLineDialog.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
					if (!(sCLType=='_CANCEL_' || typeof(sCLType)=="undefined" || sCLType.length==0 || sCLType=='_CLEAR_' || sCLType=='_NONE_'))
					{
						sParaString = "BusinessType"+","+sCLType+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
						sCLSerialNo = setObjectValue("SelectCL",sParaString,"",0,0,"");
						sCLSerialNo = sCLSerialNo.split("@");
						sCreditAggreement=sCLSerialNo[0];
					}else{
						return;
					}
					
				}
				if (sCustomerType.substring(0,2) == "03")
				{
					   sReturn=setObjectValue("SelectIndBusinessType","","",0,0,"");	
				}else if(sCustomerType.substring(0,2) == "01")
				{
					   sReturn=setObjectValue("SelectEntBusinessType","","",0,0,"");	
				}else
				{
				       sReturn=setObjectValue("SelectAllBusinessType","","",0,0,"");	
				}			
				if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
				{
					sss1 = sReturn.split("@");
					sBusinessType=sss1[0];	
					if((sSerialNo.substring(0,4)=='0871'||sSerialNo.substring(0,2)=='BC')&&sBusinessType=='2010'){
						alert("此业务不能认定为承兑汇票！");
						return								
					}
					sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction1.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType+"&ApplyType="+sDependType+"&CreditAggreement="+sCreditAggreement,"","");
				}else{
					return;
				}
			}else{
				return;
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=新增银承等表外合同;InputParam=无;OutPutParam=无;]~*/
	function NewCreditContract()
	{
		var sFlag="<%=sFlag%>";
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if(sReinforceFlag=="010")
		{  
			//新增合同进入
			//var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag+"~ReinforceFlag=G");
			//sNewBusinessType =PopPage("/InfoManage/DataInput/AddCreditDialog.jsp","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
			//if(typeof(sNewBusinessType)!="undefined" && sNewBusinessType.length!=0 && sNewBusinessType != '_none_')
			//{
				OpenComp("CreditList","/InfoManage/DataInput/CreditList.jsp","ComponentName=&OpenerFunctionName=&DealType=010&ReinforceFlag=01","_blank");
			//}
		}

		reloadSelf();		
	}
	
	
	/*~[Describe=分次放款;InputParam=无;OutPutParam=无;]~*/
	function dispartMendContract()
	{
		var sFlag="<%=sFlag%>";
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if(sReinforceFlag=="010")
		{  
			OpenComp("DispartCreditList","/InfoManage/DataInput/DispartCreditList.jsp","ComponentName=&OpenerFunctionName=&DealType=010&ReinforceFlag=01","_blank");
		}

		reloadSelf();		
	}
	

	/*~[Describe=新增合同;InputParam=无;OutPutParam=无;]~*/
	function NewContract()
	{
		var sFlag="<%=sFlag%>";
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if(sFlag=="Y")  //不良资产补登进入
		{
			var sReturn = createObject("NPAReinforceContract","");
		}
		else		//信贷补登进入
		{
			if(sReinforceFlag=="010")
			{  
				//新增合同进入
				//var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag+"~ReinforceFlag=G");
				sNewBusinessType =PopPage("/InfoManage/DataInput/AddCreditLineDialog.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
				if(typeof(sNewBusinessType)!="undefined" && sNewBusinessType.length!=0 && sNewBusinessType != '_none_')
				{
					//OpenPage("/CreditManage/CreditPutOut/AssureInfo.jsp?GuarantyType1="+sGuarantyType,"right");
					OpenComp("CreditLineList","/InfoManage/DataInput/CreditLineList.jsp","ComponentName=&OpenerFunctionName=&DealType=010&ReinforceFlag=01&BusinessType="+sNewBusinessType,"_blank");
				}
			}else
			{
				//新增额度进入
				var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag);
			}
		}
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		sss = sReturn.split("@");
		sSerialNo=sss[0];

		if(sFlag=="Y")
		{
			openObject("NPAReinforceContract",sSerialNo,"000");
		}else
		{
			openObject("ReinforceContract",sSerialNo,"000");
		}
		
		reloadSelf();		
	}

	/*~[Describe=置完成补登标志;InputParam=无;OutPutParam=无;]~*/
	function Finished()
	{
		//合同流水号、客户编号、业务品种
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		//表示补登进入列表
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm("真的要补登完成吗？")) 
		{
			var sFlag="<%=sFlag%>";
			
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				alert("业务品种为空，请先补登业务品种！");
				return;
			}else
			{	
				var sExistFlag = PopPage("/InfoManage/DataInput/ReinforceCheckAction.jsp?ContractNo="+sSerialNo,"","");
				
				if(sExistFlag!="true")
				{
					alert(sExistFlag);
					return;
				}else
				{					
					if(sFlag=="Y")   //不良资产补登完成
					{
						sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag+"&Flag="+sFlag,"","");
					}else
					{
						sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag,"","");
					}
					if(sReturn == "succeed")
					{
						if(sReinforceFlag == "010")
						{
							alert("补登完成，该业务已转到补登完成信贷业务列表!");
						}else
						{
							alert("补登完成，该业务已转到补登完成额度列表!");
						}
						
					}
					reloadSelf();	
				}
			}
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
		var sReinforceFlag = "<%=sReinforceFlag%>";
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
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag+"&Flag="+sFlag+"&Flag1="+sFlag1,"","");
			}else
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag+"&Flag1=SecondFlag","","");
			}
			
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			
			if(sReturn == "true")
			{
				if(sReinforceFlag == "020")
				{
					alert("再次补登，所选数据将回到需补登业务列表!");
				}else
				{
					alert("再次补登，所选数据将回到新增额度列表!");
				}
			}
			
			if(sReturn == "false")
			{
				alert("所选资产已经分发,不能再次补登!");
			}
			
			if(sFlag=="Y")
			{
				OpenComp("DataInputMain","/InfoManage/DataInput/DataInputMain.jsp","ComponentName=信息补充登记&Component=Y&ReinforceFlag=<%=sReinforceFlag%>&ComponentType=MainWindow","_top","")
			}else
			{
				OpenComp("DataInputMain","/InfoManage/DataInput/DataInputMain.jsp","ComponentName=信息补充登记&Component=N&ReinforceFlag=<%=sReinforceFlag%>&ComponentType=MainWindow","_top","")
			}
		}
	}


	/*~[Describe=合并合同;InputParam=无;OutPutParam=无;]~*/
	function UniteContract()
	{
		//合同流水号、客户编号、合同编号
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sArtificialNo   = getItemValue(0,getRow(),"ArtificialNo");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{	
			 var sReturn = popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&ArtificialNo="+sArtificialNo+"&CustomerID="+sCustomerID,"dialogWidth=50;dialogHeight=40;","resizable=yes;scrollbars=yes;status:no;maximize:yes;help:no;");
			 if(sReturn=="true")
			 {
				reloadSelf();
			 }
		}
	}

	/*~[Describe=已合并合同查询;InputParam=无;OutPutParam=无;]~*/
	function QueryContract()
	{
		//合同流水号、客户编号、合同编号
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{			
			 popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&CustomerID="+sCustomerID+"&Flag=QueryContract","_self","dialogWidth=100;dialogHeight=20;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
		}
	}

	function RelativeBusiness()
	{
		//合同流水号、客户编号、合同编号
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			if (sBusinessType == '1100050' )
			{
				sParaString = "CustomerID"+","+sCustomerID;
				sRelativeContractNo=setObjectValue("SelectOutContract","","",0,0,"");
				if(typeof(sRelativeContractNo)=="undefined" || sRelativeContractNo.length==0 || sRelativeContractNo == "_CANCEL_" || sRelativeContractNo == "_CLEAR_")
				{
				    return;
				}
				sRelativeContractNo = sRelativeContractNo.split("@");
				sRelativeContractNo=sRelativeContractNo[0];

				sReturn = PopPage("/CreditManage/CreditCheck/RelativeBusinessAction.jsp?SerialNo="+sSerialNo+"&RelativeContractNo="+sRelativeContractNo,"","");
				if(sReturn == "succeed")
				{
					alert("关联成功");
				}else if(sReturn == "fail")
				{
				    alert("该合同已被关联");
				}
			}else
			{
				alert("当前业务不是垫款业务，请选择一笔垫款业务开展。");
			}
		}
	}

	/*~[Describe=台帐管理;InputParam=无;OutPutParam=无;]~*/
	function Account()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBalance   = getItemValue(0,getRow(),"Balance");
		sInterestbalance1   = getItemValue(0,getRow(),"Interestbalance1");
		sInterestbalance2   = getItemValue(0,getRow(),"Interestbalance2");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			if((sBalance=="0" || sBalance=="") && (sInterestbalance1=="0" || sInterestbalance1=="") && (sInterestbalance2=="0" || sInterestbalance2==""))
			{
			    OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","cando=Y&ComponentName=终结信息&ObjectNo="+sSerialNo,"_blank",OpenStyle);
			}
			else
			{
			    OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","ComponentName=终结信息&ObjectNo="+sSerialNo,"_blank",OpenStyle);
			}
		}
	}
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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

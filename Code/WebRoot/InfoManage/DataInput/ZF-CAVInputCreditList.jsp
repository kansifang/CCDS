<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: slliu 2005-03-25
		Tester:
		Describe: 核销资产补登列表;
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
	String PG_TITLE = "核销资产补登列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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

	String sHeaders[][] = {
					{"SerialNo","合同流水号"},
					{"CustomerName","客户名称"},
					{"CustomerTypeName","客户类型"},
					{"CustomerID","客户编号"},
					{"CertID","组织机构代码"},
					{"BusinessTypeName","业务品种"},
					{"OccurTypeName","发生类型"},
					{"FinishType","终结方式"},
					{"FinishTypeName","终结方式"},
					{"ShiftType","移交方式"},
					{"ShiftTypeName","移交方式"},									
					{"Currency","币种"},
					{"BusinessSum","合同金额(元)"},
					{"Balance","余额(元)"},
					{"VouchTypeName","主要担保方式"},
					{"PutOutDate","起始日期"},
					{"Maturity","到期日期"},
					{"ManageOrgIDName","管户机构"},
					{"ManageUserIDName","管户人"}
					
				  };

	if(sReinforceFlag.equals("010"))  //待补登核销资产
	{
	
		sClauseWhere = 	" and BC.ManageOrgID in (select BelongOrgId from ORG_BELONG where OrgId='"+CurOrg.OrgID+"') "+
						" and (BC.DeleteFlag =''  or  BC.DeleteFlag is null) order by BC.CustomerID ";		
	}
	if(sReinforceFlag.equals("020"))  //补登完成核销资产
	{		
		sClauseWhere = 	" and BC.ManageOrgID in (select BelongOrgId from ORG_BELONG where OrgId='"+CurOrg.OrgID+"') "+
						" and (BC.DeleteFlag =''  or  BC.DeleteFlag is null) order by BC.CustomerID ";		
	}
	
	 sSql = " select BC.SerialNo,CI.CustomerName as CustomerName,"+
			" BC.CustomerID as CustomerID,CI.CertID as CertID,getCustomerType(CI.CustomerID) as CustomerType,"+
			" getItemName('CustomerType',CI.CustomerType) as CustomerTypeName,"+
			" BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			" BC.OccurType,BC.FinishType,getItemName('FinishType',BC.FinishType) as FinishTypeName,"+
			" BC.ShiftType,getItemName('ShiftType',BC.ShiftType) as ShiftTypeName,"+
			" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as Currency,"+
			" BC.BusinessSum,BC.Balance,"+
			" BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
			" BC.PutOutDate,BC.Maturity,"+
			" getUserName(BC.ManageUserID) as ManageUserIDName,"+
			" getOrgName(BC.ManageOrgID) as ManageOrgIDName "+			
			" from BUSINESS_CONTRACT BC,CUSTOMER_INFO CI"+
			" where BC.CustomerID=CI.CustomerID and (BC.BusinessType like '[1,2,5]%' or BC.BusinessType is null or BC.BusinessType ='')"+
			" and BC.ReinforceFlag= '"+sReinforceFlag+"' "+
			" and (BC.FinishType like '060%' ) "
			+sClauseWhere ;
	
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
		
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	//out.println(sSql);
	doTemp.setKeyFilter("BC.SerialNo||CI.CustomerID");		//add by hxd in 2005/02/20 for 加快速度
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置不可见项
	doTemp.setVisible("CustomerID,CustomerType,OccurType,BusinessCurrency,VouchType",false);
	doTemp.setVisible("BusinessType,FinishType,ShiftType",false);

	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerTypeName,CertID,ManageUserIDName"," style={width:80px} ");	
	doTemp.setHTMLStyle("CustomerTypeName,FinishTypeName,ShiftTypeName,Currency"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:170px} ");
	doTemp.setHTMLStyle("VouchTypeName,ManageOrgIDName,ManageUserIDName"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserIDName"," style={width:60px} ");
	doTemp.setHTMLStyle("BusinessTypeName,BusinessSum,Balance"," style={width:100px} ");
		
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,SerialNo","IsFilter","1");
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
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
		
				{"true","","Button","补登客户","补登客户信息","InputCustomerInfo()",sResourcesPath},
				{"true","","Button","补登业务","补登业务信息","InputBusinessInfo()",sResourcesPath},
				{"true","","Button","新增额度","新增额度","NewContract()",sResourcesPath},
				{"true","","Button","额度详情","额度详情","BusinessInfo()",sResourcesPath},
				{"true","","Button","删除额度","删除额度","DeleteContract()",sResourcesPath},
				{"true","","Button","补登客户信息","补登客户信息","InputCustomerInfo()",sResourcesPath},		
				{"true","","Button","补登完成","补登完成","Finished()",sResourcesPath},
				{"true","","Button","客户详情","客户详情","CustomerInfo()",sResourcesPath},
				{"true","","Button","业务详情","业务详情","BusinessInfo()",sResourcesPath},
				{"true","","Button","再次补登","再次补登","secondFinished()",sResourcesPath},
				{"true","","Button","改变业务品种","改变业务品种","changeBusinessType()",sResourcesPath},
				{"true","","Button","改变客户类型","改变客户类型","changeCustomerType()",sResourcesPath},
				{"true","","Button","合同合并","合同合并","UniteContract()",sResourcesPath},
				{"true","","Button","移交保全","将不良资产移交保全部管理","ShiftRMDepart()",sResourcesPath},
				//Add by wuxiong 20050709 去除删除及新增,change by ndeng 20050720 不用去除
				{"true","","Button","新增合同","新增合同","NewContract()",sResourcesPath},
				//Add by wuxiong 20050709 去除删除及新增,change by ndeng 20050720 不用去除
				{"true","","Button","删除合同","删除合同","DeleteContract()",sResourcesPath},
			
			};
	//需补登信贷业务
	if(sReinforceFlag.equals("010")) 
	{
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[7][0] = "false";
		sButtons[8][0] = "false";
		sButtons[9][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
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
		sButtons[14][0] = "false";
		sButtons[15][0] = "false";		
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
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function DeleteContract()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");		
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{				
			if(sBusinessType.substring(0,4)=="1020" || sBusinessType=="5010" || sBusinessType=="5020")	
			{
				//如果为票据贴现，可以删除
				if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
				{
					as_del("myiframe0");
					as_save("myiframe0");  //如果单个删除，则要调用此语句
					
					
				}
			}else	//如果不为票据贴现，不可以删除
			{
				alert("从628系统导入的数据不能删除！");
				return;
			}			
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
			
			openObject("ReinforceCustomer",sCustomerID,"002");
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
			}else
			{
				openObject("AfterLoan",sSerialNo,"002");
			}
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
			openObject("ReinforceCustomer",sCustomerID,"000");
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
				
				if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
				{
					sss1 = sReturn.split("@");
					sBusinessType=sss1[0];
					sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
				
				}
				else if (sReturn=='_CLEAR_')
				{
					return;
				}
				else 
				{
					return;
				}
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
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			sCustomerType   = getItemValue(0,getRow(),"CustomerType");
			sCustomerType = sCustomerType.substr(0,3);
			if(sReinforceFlag=="010") //需补登信贷业务进入
			{
				sReturn=selectObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=N");
			}else		//新增信贷业务进入
			{
				sReturn=selectObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=Y");

			}
			
			if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
			{
				sss1 = sReturn.split("@");
				sBusinessType=sss1[0];
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
				reloadSelf();
				
			}else if (sReturn=='_CLEAR_')
			{
				return;
			}
			else 
			{
				return;
			}
		
		}
	}

	/*~[Describe=新增合同;InputParam=无;OutPutParam=无;]~*/
	function NewContract()
	{
		
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		//新增合同进入
		var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag+"~ReinforceFlag=G~ListFlag=CAVInputCreditList");
		
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		sss = sReturn.split("@");
		sSerialNo=sss[0];

		
		openObject("ReinforceContract",sSerialNo,"000");
		
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
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				alert("业务品种为空，请先补登业务品种！");
				return;
			}else
			{	
				var sExistFlag = PopPage("/InfoManage/DataInput/ReinforceCheckAction.jsp?ContractNo="+sSerialNo+"&CustomerID="+sCustomerID,"","");
				
				if(sExistFlag!="true")
				{
					alert(sExistFlag);
					return;
				}else
				{												
					sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag,"","");
					
					if(sReturn == "succeed")
					{
						if(sReinforceFlag == "010")
						{
							alert("补登完成，该业务已转到补登完成的核销资产列表!");
						}
						
					}					
					OpenComp("CAVDataInputMain","/InfoManage/DataInput/CAVDataInputMain.jsp","ComponentName=核销资产补充登记&ReinforceFlag=<%=sReinforceFlag%>&ComponentType=MainWindow","_top","");
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
			
			var sFlag1 = "SecondFlag";
			
			sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag+"&Flag1=SecondFlag","","");
			
			
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			
			if(sReturn == "true")
			{
				if(sReinforceFlag == "020")
				{
					alert("再次补登，所选数据将回到需补登核销资产列表!");
				}				
			}			
			OpenComp("CAVDataInputMain","/InfoManage/DataInput/CAVDataInputMain.jsp","ComponentName=核销资产补充登记&ReinforceFlag=<%=sReinforceFlag%>&ComponentType=MainWindow","_top","");
		}
	}

    /*~[Describe=移交保全部门;InputParam=无;OutPutParam=无;]~*/
	function ShiftRMDepart()
	{
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{       
		
			var sTrace= PopPage("/RecoveryManage/Public/NPAShiftDialog.jsp","","dialogWidth=25;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		
			if(typeof(sTrace)!="undefined" && sTrace.length!=0)
			{				
				var sTrace=sTrace.split("@");
				
				//获得移交类型、保全机构
				var sShiftType = sTrace[0];
				var sTraceOrgID = sTrace[1];
				var sTraceOrgName = sTrace[2];
				
				if(typeof(sTraceOrgID)!="undefined" && sTraceOrgID.length!=0)
				{
					var sReturn = PopPage("/RecoveryManage/Public/CAVShiftAction.jsp?SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"&TraceOrgID="+sTraceOrgID+"","","");
					if(sReturn == "true") //刷新页面
					{
						alert("该不良资产成功移交到『"+sTraceOrgName+"』"); 
						reloadSelf();
					}else
					{
						alert("该不良资产已经移交，不能再次移交！"); 
						reloadSelf();
					}
				}
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
		var sArtificialNo   = getItemValue(0,getRow(),"ArtificialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			
			 popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&ArtificialNo="+sArtificialNo+"&CustomerID="+sCustomerID+"&Flag=QueryContract","_self","dialogWidth=100;dialogHeight=20;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
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
				sRelativeContractNo = selectObjectInfo("BusinessContract","BusinessType= like '2%'~CustomerID="+sCustomerID+"");
				alert(sRelativeContractNo);
				sRelativeContractNo = sRelativeContractNo.split("@");
				sRelativeContractNo=sRelativeContractNo[0];
				alert(sRelativeContractNo);
				sReturn = PopPage("/CreditManage/CreditCheck/RelativeBusinessAction.jsp?SerialNo="+sSerialNo+"&RelativeContractNo="+sRelativeContractNo,"","");
				if(sReturn == "succeed")
				{
					alert("关联成功");
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
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","ComponentName=终结信息&ObjectNo="+sSerialNo,"_blank",OpenStyle);
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

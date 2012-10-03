<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zrli 2007-12-14
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
					{"CustomerName","客户名称"},					
					{"CustomerID","客户编号"},
					{"CertType","证件类型"},
					{"CertTypeName","证件类型"},					
					{"CertID","证件编号"},							
					{"CertTypeName","客户类型"},
					{"CustomerTypeName","客户类型"},											
					{"InputUserID","登记人"},					
					{"InputUserName","登记人"},	
					{"InputOrgID","登记机构"},
					{"InputOrgName","登记机构"},
				  };

	if(sReinforceFlag.equals("010"))  //待补登公司业务
	{	
		
		sClauseWhere = " from CUSTOMER_INFO CI,ENT_INFO EI where CI.CustomerID=EI.CustomerID and (EI.TempSaveFlag<>'2' or EI.TempSaveFlag='' or EI.TempSaveFlag is null) and CI.InputOrgID='"+CurOrg.OrgID+"' ";
		
	}else if(sReinforceFlag.equals("020"))  //补登完成公司的业务
	{
		sClauseWhere = " from CUSTOMER_INFO CI,ENT_INFO EI where CI.CustomerID=EI.CustomerID and EI.TempSaveFlag='2' and CI.InputOrgID='"+CurOrg.OrgID+"' ";
		
	}else if(sReinforceFlag.equals("030"))  //补登完成个人客户信息
	{
		sClauseWhere = " from CUSTOMER_INFO CI,IND_INFO II where CI.CustomerID=II.CustomerID and (II.TempSaveFlag<>'2' or II.TempSaveFlag='' or II.TempSaveFlag is null) and CI.InputOrgID='"+CurOrg.OrgID+"' ";	
		
	}else if(sReinforceFlag.equals("040"))  //补登完成个人客户信息
	{
		sClauseWhere = " from CUSTOMER_INFO CI,IND_INFO II where CI.CustomerID=II.CustomerID and II.TempSaveFlag='2' and CI.InputOrgID='"+CurOrg.OrgID+"' ";	
		
	}
	
	 sSql = "select CI.CustomerName,CI.CustomerID,CI.CertType,"
			+" getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID,"
			+" CI.CustomerType,getItemName('CustomerType',CI.CustomerType) as CustomerTypeName,"
			+" CI.InputUserID,getUserName(CI.InputUserID) as InputUserName,CI.InputOrgID,getOrgName(CI.InputOrgID) as InputOrgName"
			+sClauseWhere ;

	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("CI.CustomerID");	
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSOTMER_INFO";	
	doTemp.setKey("CustomerID",true);	 //设置关键字
	
	//设置不可见项
	doTemp.setVisible("CertType,CustomerType",false);
	
	doTemp.setUpdateable("",false);
	//doTemp.setAlign("BusinessSum,Balance,Interestbalance1,Interestbalance2","3");
	//doTemp.setCheckFormat("BusinessSum,Balance,Interestbalance1,Interestbalance2","2");
	
	//设置html格式

	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");

		
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,CustomerID,CertID,ManageOrgIDName","IsFilter","1");
		
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10); 	//服务器分页

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //调试datawindow的Sql常用方法

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
				{"true","","Button","补登客户信息","补登客户信息","InputCustomerInfo()",sResourcesPath},		
				{"true","","Button","补登完成","补登完成","Finished()",sResourcesPath},
				{"true","","Button","再次补登","再次补登","secondFinished()",sResourcesPath},
				{"true","","Button","客户详情","客户详情","CustomerInfo()",sResourcesPath},
				{"true","","Button","改变客户类型","改变客户类型","changeCustomerType()",sResourcesPath},
			};
	
	//需补登信贷业务
	if(sReinforceFlag.equals("010")||sReinforceFlag.equals("030")) 
	{
		
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
	}
	
	//补登完成信贷业务
	if(sReinforceFlag.equals("020")||sReinforceFlag.equals("040")) 
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[5][0] = "false";		
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
			//openObject("ReinforceCustomer",sCustomerID,"000");
			openObject("ReinforceCustomer",sCustomerID,"000");
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
				var sExistFlag = PopPage("/InfoManage/DataInput/ReinforceCheckAction.jsp?ContractNo="+sSerialNo+"&CustomerID="+sCustomerID,"","");
				
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

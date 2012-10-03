<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2011/0614
		Tester:
		Describe1: 合同选择;
		Input Param:
		Output Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同选择"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";
	String sWhereClause ="";
	String sTempletNo ="";
	
	//获得组件参数	
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
		
	if(sContractNo==null) sContractNo="";
	if(sCustomerID==null) sCustomerID="";
	if(sFlag==null) sFlag="";
	//定义表头文件
	String sHeaders[][] = { 		
	    					{"SerialNo","合同流水号"},     					
	    					{"CustomerName","客户名称"},
	    					{"RelativeSerialNo","目标合同号"},
							{"BusinessTypeName","业务品种"},
							{"BusinessCurrencyName","币种"},
							{"BusinessSum","金额(元)"},
							{"BlanceSum","余额(元)"},
							{"PutoutDate","起始日"},
							{"Maturity","到期日"},
							{"ManageUserName","管户人"},
							{"ManageOrgName","管户机构"}
						}; 
	
	
	if(sFlag.equals("DeleteContract"))	//根据查询条件查询已被合并的合同
	{
		sSql = 	" select BC.SerialNo as SerialNo ,BC.CustomerID as CustomerID,BC.CustomerName as CustomerName, "+
			   	" BC.RelativeSerialNo as RelativeSerialNo,BC.BusinessType as BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
	           	" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName, "+
			   	" BC.BusinessSum as BusinessSum,BC.Balance as BlanceSum, "+
			   	" BC.ManageOrgID,getUserName(BC.ManageUserID) as ManageUserName, "+
			   	" GetOrgName(BC.ManageOrgID) as ManageOrgName ,BC.ManageUserID "+
		 		" from BUSINESS_CONTRACT BC,CUSTOMER_INFO CI "+
				" where BC.CustomerID=CI.CustomerID "+
			 	" and BC.ManageOrgID in (select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') "+
			 	" and BC.CustomerID = '"+sCustomerID+"' "+
				" and BC.DeleteFlag = '01' "+         //01表示已被合并
				" and exists(select 1 from BUSINESS_DUEBILL where serialno=BC.serialno and RelativeSerialNo2='"+sContractNo+"')"+
				" order by BC.PutOutDate ";
	
	}else	//未被合并的合同列表
	{
		sSql = 	" select BC.SerialNo as SerialNo ,BC.CustomerID as CustomerID,BC.CustomerName as CustomerName, "+
			   	" BC.BusinessType as BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
	           	" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName, "+
			   	" BC.BusinessSum as BusinessSum,BC.Balance as BlanceSum,PutoutDate, Maturity,  "+
			   	" BC.ManageOrgID, "+
			   	" getUserName(BC.ManageUserID) as ManageUserName, "+
			   	" GetOrgName(BC.ManageOrgID) as ManageOrgName ,BC.ManageUserID "+
			 	" from BUSINESS_CONTRACT BC,CUSTOMER_INFO CI "+
			 	" where BC.SerialNo <> '"+sContractNo+"' "+				
			 	" and (DeleteFlag =''  or  DeleteFlag is null) "+
			 	" and CI.CustomerID = BC.CustomerID "+
			 	" and BC.ManageOrgID in (select BelongOrgId from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') "+
			 	" and BC.CustomerID = '"+sCustomerID+"' "+
			 	" and BC.CustomerID<>'' "+
			 	" and substr(BC.SerialNo,1,4)<>'0871' and substr(BC.SerialNo,1,2)<>'BC' "+
			 	" and substr(BC.SerialNo,1,2)<>'FC' "+
			 	" and BC.ReinforceFlag in('010','020') "+
			 	" and exists(select 1 from business_duebill where relativeserialno2=BC.serialno) "+
				" and BC.CustomerID is not null order by BC.PutOutDate ";
	}	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	//利用Sql生成窗体对象
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("BusinessType,CustomerType,CustomerID,BusinessType,BusinessCurrency,ManageOrgID,ManageUserID",false);	
	doTemp.setVisible("RelativeSerialNo",false);	
	
	//设置金额为数字形式
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("BusinessSum","2");
	
	doTemp.setType("BlanceSum","Number");
	doTemp.setCheckFormat("BlanceSum","2");
	
	//设置金额对齐方式
	doTemp.setAlign("BusinessSum,BlanceSum","3");
	doTemp.setColumnAttribute("SerialNo,BusinessTypeName,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//多选
	doTemp.multiSelectionEnabled = true;
	
	//设置html格式
	doTemp.setHTMLStyle("RelativeSerialNo"," style={width:160px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName,RecoveryUserName"," style={width:100px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {
				{"true","","Button","合并","合并所选合同","addSubmit()",sResourcesPath},
				{"true","","Button","删除合并","删除合并合同","deleteSubmit()",sResourcesPath},
				{"false","","Button","客户详情","客户详情","CustomerInfo()",sResourcesPath},
				{"false","","Button","业务详情","业务详情","BusinessInfo()",sResourcesPath}
			};
			
	if(sFlag.equals("AddContract"))
	{
		sButtons[1][0]="false";
	}else if(sFlag.equals("DeleteContract"))
	{
		sButtons[0][0]="false";
	}
	
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script>
	
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
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{			
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				sReturn=setObjectValue("SelectBusinessType","","",0,0,"");
				if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
				{
					sss1 = sReturn.split("@");
					sBusinessType=sss1[0];
					sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
				}else if (sReturn=='_CLEAR_')
				{
					return;
				}else 
				{
					return;
				}				
			}
			openObject("AfterLoan",sSerialNo,"002");			
		}
	}

	
	/*~[Describe=合并合同提交;InputParam=无;OutPutParam=无;]~*/
	function addSubmit()
	{
		//获得合同流水号
		sObjectNoArray = getItemValueArray(0,"SerialNo");
		
		if (sObjectNoArray.length==0){
			alert("你没有选择信息，请在需要选择的信息前打√！ ");
			return;
		}		

		var iCount = 0;
		var sMessage1 = "";
		
		sMessage = "你已经选择了下列需要被合并的合同:\n\r\n\r";
		//找到第一笔选中的任务，并生成提示信息
		for(var iMSR = 0; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a == "√")
			{
				if (iCount == 0) 
				{
					sSerialNo = getItemValue(0,iMSR,"SerialNo");
					
				}
				
				iCount = iCount + 1;
				
				sMessage = sMessage+getItemValue(0,iMSR,"SerialNo")+"-";
				sMessage = sMessage+getItemValue(0,iMSR,"CustomerName")+"-";
				sMessage = sMessage+"\n\r";
				if(sMessage1=="")
				{
					sMessage1 = getItemValue(0,iMSR,"SerialNo");
				}else
				{
					sMessage1 = sMessage1+","+getItemValue(0,iMSR,"SerialNo");
				}
			}
		}

		sMessage = sMessage+"\n\r"+"确认要将所选合同与目标合同『<%=sContractNo%>』合并吗？";
		
		if (confirm(sMessage)==false){
			return;
		}		
				
		var sReturn = PopPage("/InfoManage/DataInput/UniteContractAction1.jsp?ContractNo=<%=sContractNo%>&Flag=<%=sFlag%>&ObjectNoArray="+sObjectNoArray,"","");
		
		if(sReturn=="true")
		{
			alert("被选合同『"+sMessage1+"』已经成功合并到目标合同『<%=sContractNo%>』!");
			self.returnValue =sReturn;
			self.close();
		}else
		{
			self.returnValue =sReturn;
			self.close();
		}
		
	}
	
	
	/*~[Describe=删除合同合并提交;InputParam=无;OutPutParam=无;]~*/
	function deleteSubmit()
	{
		//获得合同流水号
		sObjectNoArray = getItemValueArray(0,"SerialNo");
		
		if (sObjectNoArray.length==0){
			alert("你没有选择信息，请在需要选择的信息前打√！ ");
			return;
		}		

		var iCount = 0;
		var sMessage1 = "";
		
		sMessage = "你已经选择了下列需要被解除合并的合同:\n\r\n\r";
		//找到第一笔选中的任务，并生成提示信息
		for(var iMSR = 0; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a == "√")
			{
				if (iCount == 0) 
				{
					sSerialNo = getItemValue(0,iMSR,"SerialNo");
					
				}
				
				iCount = iCount + 1;
				
				sMessage = sMessage+getItemValue(0,iMSR,"SerialNo")+"-";
				sMessage = sMessage+getItemValue(0,iMSR,"CustomerName")+"-";
				sMessage = sMessage+"\n\r";
				if(sMessage1=="")
				{
					sMessage1 = getItemValue(0,iMSR,"SerialNo");
				}else
				{
					sMessage1 = sMessage1+","+getItemValue(0,iMSR,"SerialNo");
				}
			}
		}

		sMessage = sMessage+"\n\r"+"确认要将所选合同与目标合同『<%=sContractNo%>』解除合并吗？";
		
		if (confirm(sMessage)==false){
			return;
		}		
				
		var sReturn = PopPage("/InfoManage/DataInput/UniteContractAction1.jsp?ContractNo=<%=sContractNo%>&Flag=<%=sFlag%>&ObjectNoArray="+sObjectNoArray,"","");
		
		if(sReturn=="true")
		{
			alert("被选合同『"+sMessage1+"』已经成功从目标合同『<%=sContractNo%>』解除合并!");
			self.returnValue =sReturn;
			self.close();
		}else
		{
			self.returnValue =sReturn;
			self.close();
		}
		
	}
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
<%@	page contentType="text/html; charset=GBK"%>
<%@	include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2011/06/14
		Tester:
		Describe: 分次放款合同补登
		Input Param:
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "分次放款合同补登"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	
	//定义变量
	String sSql1="";
	String sCondition ="";

	//获得页面参数
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if (sReinforceFlag==null) sReinforceFlag="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","合同流水号"},
							{"CustomerName","客户名称"},							
							{"BusinessTypeName","业务品种"},
							{"CreditAggreement","额度协议编号"},						
							{"OccurTypeName","发生类型"},													
							{"Currency","币种"},
							{"BusinessSum","合同金额"},
							{"Balance","余额"},
							{"NormalBalance","正常余额"},
							{"OverdueBalance","逾期余额"},
							{"DullBalance","呆滞余额"},
							{"BadBalance","呆帐余额"},						
							{"BusinessRate","利率(‰)"},
							{"InterestBalance1","表内欠息余额"},
							{"InterestBalance2","表外欠息余额"},
							{"PutOutDate","起始日期"},
							{"Maturity","到期日期"},
							{"VouchTypeName","担保方式"},							
							{"ClassifyResult","风险分类"},
							{"UserName","客户经理"},
							{"OperateOrgName","经办机构"},
							{"VouchType","主要担保方式"}
						  };
   
 		String sSql = " select SerialNo,CustomerID,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,"+
					" nvl(InterestBalance1,0) as InterestBalance1,nvl(InterestBalance2,0) as InterestBalance2,"+
					" BusinessRate,PutOutDate,Maturity,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
					" getOrgName(ManageOrgID) as OrgName,"+
					" getUserName(ManageUserID) as UserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where SerialNo like 'FC%' and ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
					" and (FinishDate = '' or FinishDate is null)";

	//具有支行客户经理、分行客户经理、总行客户经理的用户只能查看自己管户的合同
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
	{
	    sSql += " and ManageUserID = '"+CurUser.UserID+"'";
	}
	sSql += " order by CustomerName";
	//out.println(sSql);
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);

	doTemp.setVisible("OverdueBalance,CustomerID,OccurTypeName,BusinessRate",false);	
	
	//设置不可见项
	doTemp.setVisible("BusinessType,OccurType,BusinessCurrency,VouchType,OperateOrgID,OrgName",false);	
	
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setAlign("BadBalance,DullBalance,NormalBalance,BusinessSum,Balance,OverdueBalance,BusinessRate","3");
	doTemp.setType("BadBalance,DullBalance,NormalBalance,InterestBalance1,InterestBalance2,BusinessSum,Balance,OverdueBalance,BusinessRate","Number");
	doTemp.setCheckFormat("BadBalance,DullBalance,NormalBalance,BusinessSum,Balance,OverdueBalance","2");
	doTemp.setCheckFormat("BusinessRate","16");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from code_library where codeno = 'VouchType' and ItemNo in ('005','010','020','040')");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency","2");
	//doTemp.setColumnAttribute("CustomerName,BusinessTypeName,SerialNo,Maturity,VouchType","IsFilter","1");
	
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","BusinessTypeName","");	
	doTemp.setFilter(Sqlca,"3","SerialNo","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","Maturity","");
	doTemp.setFilter(Sqlca,"6","VouchType","Operators=BeginsWith");	
	doTemp.parseFilterData(request,iPostChange);
	
	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
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
		{"true","","Button","新增合同","新增合同","NewContract()",sResourcesPath},	
		{"true","","Button","查看合同详情","查看合同详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除合同","删除合同","Delete()",sResourcesPath},
		{"true","","Button","合同项下借据关联","合同项下借据关联","addRelativeBD()",sResourcesPath},
		{"true","","Button","删除合同项下借据","删除合同项下借据","deleteRelativeBD()",sResourcesPath},
	};

	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=合同详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		openObject("ReinforceContract",sObjectNo,"001");
		reloadSelf();	
	}
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增合同;InputParam=无;OutPutParam=无;]~*/
	function NewContract()
	{
		sCompID	 = "ReinforceCreation2";
		sCompURL = "/InfoManage/DataInput/ReinforceCreationInfo2.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(!(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") )
		{
			sReturn = sReturn.split("@");
			var sObjectNo = sReturn[0];
			openObject("ReinforceContract",sObjectNo,"002");					
		}
		else
		{
			return;
		}
		reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function Delete()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}   
		//是否存在借据
	    var sColName = "count(serialno)";
		var sTableName = "Business_Duebill";
		var sWhereClause = "String@RelativeSerialNo2@"+sSerialNo;
			
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturnValue = sReturn.split('@');
			if(sReturnValue[1]>0) 
			{
				alert("该笔合同存在借据信息，不能删除！");
				return;
				
			}else
			{
				if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
				{
					as_del('myiframe0');
		            as_save('myiframe0');  //如果单个删除，则要调用此语句
					//reloadSelf();
				}
			}
		}
	}
	
	
	/*~[Describe=增加关联合同(借据);InputParam=无;OutPutParam=无;]~*/
	function addRelativeBD()
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
			 var sReturn = popComp("UniteContractSelectList1","/InfoManage/DataInput/UniteContractSelectList1.jsp","ContractNo="+sSerialNo+"&CustomerID="+sCustomerID+"&Flag=AddContract","dialogWidth=50;dialogHeight=40;","resizable=yes;scrollbars=yes;status:no;maximize:yes;help:no;");
			 if(sReturn=="true")
			 {
				reloadSelf();
			 }
		}
	}
	
	/*~[Describe=删除关联合同(借据);InputParam=无;OutPutParam=无;]~*/
	function deleteRelativeBD()
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
			 var sReturn = popComp("UniteContractSelectList1","/InfoManage/DataInput/UniteContractSelectList1.jsp","ContractNo="+sSerialNo+"&CustomerID="+sCustomerID+"&Flag=DeleteContract","dialogWidth=50;dialogHeight=40;","resizable=yes;scrollbars=yes;status:no;maximize:yes;help:no;");
			 if(sReturn=="true")
			 {
				reloadSelf();
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

<%@	include file="/IncludeEnd.jsp"%>

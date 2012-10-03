<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: 客户在其他金融机构业务活动;
		Input Param:
				DealType：
				    03待完成放贷的合同
					04已完成放贷的合同
		Output Param:
			
		HistoryLog:
			zywei 2007/10/10 修改取消合同的提示语
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql1="";
	
	//获得组件参数
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"BusinessTypeName","业务品种"},
							{"CustomerName","客户名称"},
							{"SerialNo","合同流水号"},
							{"OccurTypeName","发生类型"},
							{"Currency","币种"},
							{"BusinessSum","合同金额"},
							{"RelativeSum","已出账金额"},
							{"Balance","余额"},
							{"VouchTypeName","主要担保方式"},
							{"PutOutDate","起始日期"},
							{"Maturity","到期日期"},
							{"ManageOrgName","经办机构"},
						  };
	String 	sSql = "";
    String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sDBName.startsWith("INFORMIX"))
	{
		sSql =   " select SerialNo,CustomerID,CustomerName,"+
						" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
						" ArtificialNo,"+
						" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
						" BusinessSum,"+
						" Balance,"+
						" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
						" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
						" PutOutDate,Maturity,"+
						" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,FinishDate "+
						" from BUSINESS_CONTRACT "+
						" where ManageUserID = '"+CurUser.UserID+"' "+
						" and BusinessType not like '30%'"+
			 			" and (DeleteFlag = ''  or  DeleteFlag is null) ";
	}
	else if(sDBName.startsWith("ORACLE"))
	{		 					 			
		sSql =   " select SerialNo,CustomerID,CustomerName,"+
						" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
						" ArtificialNo,"+
						" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
						" BusinessSum,"+
						" Balance,"+
						" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
						" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
						" PutOutDate,Maturity,"+
						" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,FinishDate "+
						" from BUSINESS_CONTRACT "+
						" where ManageUserID = '"+CurUser.UserID+"' "+
						" and BusinessType not like '30%'"+
			 			" and (DeleteFlag = ''  or  DeleteFlag is null) ";	 			
	}else if(sDBName.startsWith("DB2"))
	{
		sSql =   " select SerialNo,CustomerID,CustomerName,"+
						" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
						" ArtificialNo,"+
						" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
						" BusinessSum,"+
						" Balance,"+
						" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
						" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
						" PutOutDate,Maturity,"+
						" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,FinishDate "+
						" from BUSINESS_CONTRACT "+
						" where ManageUserID = '"+CurUser.UserID+"' "+
						" and BusinessType not like '30%'"+
			 			" and (DeleteFlag = ''  or  DeleteFlag is null) ";
	}
	if(sDealType.equals("03100"))
	{
		if(sDBName.startsWith("INFORMIX"))
		{
		    sSql1 =" and (PigeonholeDate ='' or PigeonholeDate is null) ";
		}
		else if(sDBName.startsWith("ORACLE")) 
		{
			sSql1 =" and (PigeonholeDate =' ' or PigeonholeDate is null) ";
		}else if(sDBName.startsWith("DB2"))
		{
		    sSql1 =" and (PigeonholeDate ='' or PigeonholeDate is null) ";
		}
	}
	else if(sDealType.equals("03200"))
	{
		
		if(sDBName.startsWith("INFORMIX"))
		{
		    sSql1 =" and (PigeonholeDate !='' and PigeonholeDate is not null) ";
		}
		else if(sDBName.startsWith("ORACLE")) 
		{
			sSql1 =" and (PigeonholeDate !=' ' and PigeonholeDate is not null) ";
		}else if(sDBName.startsWith("DB2"))
		{
		    sSql1 =" and (PigeonholeDate !='' and PigeonholeDate is not null) ";
		}
	}
	sSql = sSql + sSql1 + " order by SerialNo desc ";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable="BUSINESS_CONTRACT";
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("ArtificialNo,CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,ManageOrgID,FinishDate",false);
	if (sDealType.equals("030")) {
		doTemp.setVisible("RelativeSum",false);
	}

	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,RelativeSum,Balance","3");
	doTemp.setAlign("Currency,OccurTypeName","2");
	doTemp.setType("BusinessSum,RelativeSum,Balance","Number");
	
	doTemp.setCheckFormat("BusinessSum,RelativeSum,Balance","2");
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:120px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
    
    doTemp.setFilter(Sqlca,"1","SerialNo","");
    doTemp.setFilter(Sqlca,"2","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"3","BusinessSum","");
	doTemp.setFilter(Sqlca,"4","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
    
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10); 	//服务器分页

	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteBusiness(BusinessContract,#SerialNo,DeleteBusiness)"); 
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//组织进行合计用参数 add by zrli 
	String[][] sListSumHeaders = {	{"BusinessCurrency","币种"},
									{"BusinessSum","合同金额"},
									{"Balance","余额"},
								 };
	String sListSumSql = "Select BusinessCurrency,Sum(BusinessSum) as BusinessSum,Sum(Balance) as Balance "
						+ " From BUSINESS_CONTRACT "
						+ doTemp.WhereClause
						+ " Group By BusinessCurrency";
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);
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
		{"true","","Button","新增合同","新增合同","newRecord()",sResourcesPath},
		{"true","","Button","合同详情","合同详情","viewTab()",sResourcesPath},
		{"true","","Button","取消合同","取消合同","cancelContract()",sResourcesPath},
		{"true","","Button","合同归档","合同归档","archive()",sResourcesPath},
		{"true","","Button","加入重点连接","加入重点合同连接","addUserDefine()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
		{"true","","Button","汇总","金额汇总","listSum()",sResourcesPath},
		{"false","","Button","新增纯公积金贷款","新增纯公积金贷款","newAFRecord()",sResourcesPath}
	};

	if(sDealType.equals("04")||sDealType.equals("03200"))
	{
		sButtons[0][0] ="false";
		sButtons[2][0] ="false";
		sButtons[3][0] ="false";
	}
	
	if(sDealType.equals("03100"))
	{
		sButtons[7][0] ="true";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
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

	/*~[Describe=加入重点合同连接;InputParam=无;OutPutParam=无;]~*/
	function addUserDefine()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getBusinessMessage('420'))) //要把这个合同信息加入重点合同链接中吗？
		{
			PopPage("/Common/ToolsB/AddUserDefineAction.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
		}
	}

	/*~[Describe=完成放贷;InputParam=无;OutPutParam=无;]~*/
	function archive(){
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sBalance = getItemValue(0,getRow(),"Balance");
		sFinishDate = getItemValue(0,getRow(),"FinishDate");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(!(sBalance>0 || (sFinishDate.length>0 && typeof(sObjectNo)!="undefined"))){
			alert("此条记录不能归档");
			return;
		}
		if(confirm("归档后的合同将不能再放贷，您确定要将此合同归档吗？")) //您真的想将该笔合同置为完成放贷吗？
		{
			sReturn = PopPage("/Common/WorkFlow/AddPigeonholeAction.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"","");
			if(typeof(sReturn)!="undefined" && sReturn!="failed")
				reloadSelf();
			alert(getBusinessMessage('422'));//该笔合同已经置为完成放贷！
		}
	}

	/*~[Describe=取消合同;InputParam=无;OutPutParam=无;]~*/
	function cancelContract()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('70')))//您真的想取消该信息吗？
		{
		    sReturn = PopPage("/CreditManage/CreditPutOut/CheckContractDelAction.jsp?ObjectNo="+sObjectNo,"","");
	        if (typeof(sReturn)=="undefined" || sReturn.length==0)
	       	{
	       		if(sBusinessType="2110020")
	       		{
	       			sReturn = RunMethod("BusinessManage","DeleteBusiness",sObjectNo+",CreditApply,DeleteTask");
	       		}
	            as_del('myiframe0');
	            as_save('myiframe0');  //如果单个删除，则要调用此语句
	        }else if(sReturn == 'Reinforce')
	        {
	            alert(getBusinessMessage('425'));//该合同为补登合同，不能删除！
	            return;
	        }else if(sReturn == 'Finish')
	        {
	            alert(getBusinessMessage('426'));//该合同已经被终结了，不能删除！
	            return;
	        }else if(sReturn == 'Pigeonhole')
	        {
	            alert(getBusinessMessage('427'));//该合同已经完成放贷了，不能删除！
	            return;
	        }else if(sReturn == 'PutOut')
	        {
	            alert(getBusinessMessage('428'));//该合同已经出帐了，不能删除！
	            return;
	        }else if(sReturn == 'Other')
	        {
	            alert(getBusinessMessage('429'));//该合同管户人为其它人员，不能删除！
	            return;
	        }else if(sReturn == 'Use')
	        {
	            alert(getBusinessMessage('430'));//该授信额度已被占用，不能删除！
	            return;
	        }
		}
	}
	
	/*~[Describe=新增合同;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		sParaString = "ObjectType"+","+"CreditApply"+","+"UserID"+","+"<%=CurUser.UserID%>";
		sReturn = setObjectValue("SelectApplyForContract",sParaString,"",0,0,"");		
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;

		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		sReturn=RunMethod("BusinessManage","InitializeContract","CreditApply,"+sObjectNo+","+"<%=CurUser.UserID%>"+","+"<%=CurOrg.OrgID%>");
	    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
		alert("根据已批准的申请生成合同成功，合同流水号["+sReturn+"]！\n\r请继续填写合同起止时间等要素信息！");
		sObjectType = "BusinessContract";
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	 /*~[Describe=金额汇总;InputParam=无;OutPutParam=无;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
	} 
	
	
	/*~[Describe=新增纯公积金贷款;InputParam=无;OutPutParam=无;]~*/
	function newAFRecord()
	{
		//生成申请信息
		sCompID = "AssembleCreationInfo";
		sCompURL = "/CreditManage/CreditPutOut/AssembleCreationInfo.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=35;dialogHeight=15;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sObjectNo=sReturn[0];////申请流水号
		sAccumulationNo = sReturn[1]; //委贷贷款号
		//取该笔申请对应的流程阶段号
		sTradeType = "6020";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+"CreditApply"+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000")
		{
			alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			sReturn = RunMethod("BusinessManage","DeleteBusiness",sObjectNo+",CreditApply,DeleteTask");
			return;
		}else{
			alert("发送个贷成功！"+sReturn[1]);
			sReturn = RunMethod("BusinessManage","UpdateTrade6020",sObjectNo+", ,"+sAccumulationNo);
			if(typeof(sReturn)!="undefined" && sReturn.length!=0)
			{
				alert(sReturn);
			}
			reloadSelf();
		}
		//生成合同信息
		sReturn=RunMethod("BusinessManage","InitializeContract","CreditApply,"+sObjectNo+","+"<%=CurUser.UserID%>"+","+"<%=CurOrg.OrgID%>");
	    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
		sObjectType = "BusinessContract";
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
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
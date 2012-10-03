<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: lpzhang 2009-9-9
		Tester:
		Describe: 
		Input Param:
				DealType：
				    05未生效的额度
					06已生效的额度
					07已终结的额度
		Output Param:
			
		HistoryLog:
			
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
							{"VouchTypeName","主要担保方式"},
							{"PutOutDate","起始日期"},
							{"Maturity","到期日期"},
							{"ManageOrgName","经办机构"},
						  };
	String 	sSql = "";
	sSql =  " select SerialNo,CustomerID,CustomerName,"+
			" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
			" ArtificialNo,"+
			" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
			" BusinessSum,TempSaveFlag,"+
			" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
			" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
			" PutOutDate,Maturity,"+
			" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName"+
			" from BUSINESS_CONTRACT "+
			" where ManageUserID = '"+CurUser.UserID+"' "+ 
			" and BusinessType like '30%'"+
 			" and (DeleteFlag = ''  or  DeleteFlag is null) ";
	
	if(sDealType.equals("05100"))//未生效
	{
	    sSql1 =" and (InUseFlag ='' or InUseFlag is null) and (FinishDate='' or FinishDate is null  )";
	}
	else if(sDealType.equals("05110"))//已生效
	{
		sSql1 =" and InUseFlag='01' and (FinishDate='' or FinishDate is null)";
	}
	else if(sDealType.equals("05120"))//已终结
	{
		sSql1 =" and (FreezeFlag = '4'  or  FinishDate is not null) ";
	}
	sSql = sSql + sSql1 + " order by SerialNo desc ";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable="BUSINESS_CONTRACT";
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("ArtificialNo,CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,ManageOrgID,TempSaveFlag",false);
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
								 };
	String sListSumSql = "Select BusinessCurrency,Sum(BusinessSum) as BusinessSum "
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
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
		{"false","","Button","新增合同","新增合同","newRecord()",sResourcesPath},
		{"true","","Button","合同详情","合同详情","viewTab()",sResourcesPath},
		{"false","","Button","取消合同","取消合同","cancelContract()",sResourcesPath},
		{"false","","Button","额度生效","额度生效","AgreementInUse()",sResourcesPath},
		{"true","","Button","加入重点连接","加入重点合同连接","addUserDefine()",sResourcesPath},
		{"true","","Button","汇总","金额汇总","listSum()",sResourcesPath},
		{"false","","Button","额度失效","额度失效","cancelAgreement()",sResourcesPath}
	};
	if(sDealType.equals("05100"))
	{	
		sButtons[0][0] ="true";
		sButtons[2][0] ="true";
		sButtons[3][0] ="true";
	}else if(sDealType.equals("05110"))
	{
		sButtons[6][0] ="true";
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
		reloadSelf();
	}
	
	/*~[Describe=额度生效;InputParam=无;OutPutParam=无;]~*/
	function AgreementInUse()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sOccurType = getItemValue(0,getRow(),"OccurType");
		sTempSaveFlag = getItemValue(0,getRow(),"TempSaveFlag");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(sTempSaveFlag == '1')
		{
			alert("合同信息未保存，不能生效！");
			retrun;
		}
		//检查担保合同有没有登记完整
		sReturn=RunMethod("CreditLine","CheckGuarantyContract",sSerialNo);
		if(sReturn>0){
			alert("担保合同信息未保存，不能生效！");
			return;
		}
		if(sOccurType == "100")
		{
			//检查该用户额度项下是否有没有登记合同的申请
			sReturn=RunMethod("CreditLine","CheckCustomerApply",sSerialNo);
			if(parseFloat(sReturn)>0)
			{
				alert("存在未登记合同的额度项下业务！");
				retrun;
			}
			if(confirm("该额度立即生效，原综合授信额度将被终结 \r\n您确定吗？")) 
			{
				sReturn=RunMethod("CreditLine","ChangeAgreementInuse",sSerialNo+","+sCustomerID+","+sBusinessType+","+sOccurType); 
				if(typeof(sReturn)=="undefined" || sReturn.length==0) 
				{
					alert("操作失败!");
				}else{
					alert("操作成功!");
				}
				reloadSelf();
			}
		}else
		{
			sReturn=RunMethod("CreditLine","ChangeAgreementInuse",sSerialNo+","+sCustomerID+","+sBusinessType+","+sOccurType); 
			if(sReturn != "1") 
			{
				alert("操作失败!");
			}else{
				alert("操作成功!");
			}
			reloadSelf();
		}
	}

	/*~[Describe=完成放贷;InputParam=无;OutPutParam=无;]~*/
	function archive(){
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getBusinessMessage('421'))) //您真的想将该笔合同置为完成放贷吗？
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
		sReturn = setObjectValue("SelectApplyForContract1",sParaString,"",0,0,"");		
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;

		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		sReturn=RunMethod("BusinessManage","InitializeContract","CreditApply,"+sObjectNo+","+"<%=CurUser.UserID%>"+","+"<%=CurOrg.OrgID%>");
	    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
		alert("根据已批准的申请生成合同成功，合同流水号["+sReturn+"]！\n\r请继续填写合同要素并“保存”或稍后在“待完成放贷的合同”列表中选择该合同并填写合同要素！");
		sObjectType = "BusinessContract";
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	 /*~[Describe=金额汇总;InputParam=无;OutPutParam=无;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
	}
	   
	//取消额度
	function cancelAgreement()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sReturn = RunMethod("CreditLine","SelectAgreement",sSerialNo);
		if(sReturn == "0")
		{
			var sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@InUseFlag@None,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{
				alert("额度已失效");
			}else
			{
				alert("操作失败");
			}
			reloadSelf();
		}else
		{
			alert("额度项下还有业务，不能失效");
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
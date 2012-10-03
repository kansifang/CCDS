<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/09/10
		Tester:
		Describe: 关联终结贷款合同
		Input Param:
			ObjectType: 对象类型
			ObjectNo：对象编号
		Output Param:
			SerialNo：业务流水号
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联终结贷款合同"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String 	sSql = "";
	//获得页面参数
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";

%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	String sHeaders[][] = {
			{"BusinessTypeName","业务品种"},
			{"CustomerID","客户编号"},
			{"CustomerName","客户名称"},
			{"ObjectNo","合同流水号"},
			{"OccurTypeName","发生类型"},
			{"BusinessCurrency","币种"},
			{"VouchType","担保方式"},	
			{"Currency","币种"},
			{"BusinessSum","合同金额"},
			{"Balance","当前余额"},
			{"VouchTypeName","主要担保方式"},
			{"ClassifyResult","风险分类"},
			{"InterestBalance1","表内欠利"},
			{"InterestBalance2","表外欠息"},			
			{"OriginalPutOutDate","首次发放日"},
			{"Maturity","到期日期"},	
		  };
		  
	sSql =   " select BR.SerialNo as SerialNo,BR.ObjectType as ObjectType,BR.ObjectNo as ObjectNo,BC.CustomerID,BC.CustomerName as CustomerName,"+
		" getBusinessName(BC.BusinessType) as BusinessTypeName,"+
		" getItemName('Currency',BC.BusinessCurrency) as Currency,"+
		" BC.BusinessSum as BusinessSum,"+
		" BC.Balance as Balance,"+
		" getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
		" getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
		" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,InterestBalance1,InterestBalance2,"+
		" BC.OriginalPutOutDate as OriginalPutOutDate,BC.Maturity as Maturity"+
		" from BUSINESS_CONTRACT BC,BADBIZ_RELATIVE BR "+
		" where BR.ObjectNo=BC.SerialNo and BR.ObjectType='FinishContract' "+
		" and BR.SerialNo='"+sObjectNo+"'";

	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BADBIZ_RELATIVE";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	
	//设置小数显示状态,
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setType("BusinessSum,Balance","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	//设置不可见项
	doTemp.setVisible("SerialNo,ObjectType,CustomerID",false);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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

	String sButtons[][] = 
		{
			{"true","","Button","引入关联合同","引入贷款终结合同信息","importRecord()",sResourcesPath},
			{"true","","Button","合同详情","合同详情","viewTab()",sResourcesPath},
			{"true","","Button","删除关联合同","删除关联合同信息","deleteRecord()",sResourcesPath},
			{"true","","Button","客户详情","客户详情","viewCustomer()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function importRecord()
	{
		sParaString = "RecoveryOrgID,"+"<%=CurOrg.OrgID%>"+",RecoveryUserID,"+"<%=CurUser.UserID%>";
		//跟新关联合同
		sReturnValue=setObjectValue("SelectFinishContract",sParaString,"",0,0,"");
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
		{
			sReturnValue = sReturnValue.split("@");
			sContractSerialNO=sReturnValue[0];
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sObjectNo%>"+",FinishContract,"+sContractSerialNO+",BADBIZ_RELATIVE");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				alert(getBusinessMessage("754"));//引入关联合同成功！
			}else
			{
				alert(getBusinessMessage("755"));//引入关联合同失败，请重新操作！
				return;
			}
		}
		reloadSelf();	
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
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

	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
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
	/*~[Describe=使用OpenComp打开客户详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomer()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
    	openObject("Customer",sCustomerID,"001");
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

<%@include file="/IncludeEnd.jsp"%>

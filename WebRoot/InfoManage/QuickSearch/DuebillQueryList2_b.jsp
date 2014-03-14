<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   wwhe 2010-01-18
			Tester:
			Content: 个人客户借据信息快速查询
			Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：合同信息快速查询
		          
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "个人客户借据信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "";
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//定义表头文件
	String sHeaders[][] = { 
		
					{"SerialNo","借据流水号"},
					{"CustomerID","客户编号"},
					{"CustomerName","客户名称"},
					{"PayType","支付方式"},
					{"BusinessTypeName","业务品种"},										
					{"VouchType","主要担保方式"},										
					{"BusinessSum","金额"},
					{"Balance","余额"},										
					{"Currency","币种"},
					{"ActualBusinessRate","执行利率(%)"},
					{"PutOutDate","借据起始日"},
					{"Maturity","借据到期日"},
					{"MFOrgName","入账机构"},
					{"Direction","行业投向"},
					{"DirectionName1","行业投向(大类)"},
					{"DirectionName","行业投向(子类)"},
					{"RateFloatType","利率浮动方式"},
					{"RateFloat","利率浮动值"},
					{"ICType","还款方式"},
					{"ICTypeName","还款方式"},
					{"OverdueDays","逾期天数"},
					{"TermMonth","贷款期限"},
					{"Purpose","贷款用途"},
					{"PurposeName","贷款用途"},
					{"Flag2","是否并行贷款"},
					{"Flag2Name","是否并行贷款"},
					{"FixCYC","结息日"}, 
					{"CMIntSum","当月利息收入"},
					{"AMIntSum","总利息收入"},
					{"Sex","性别"},
					{"WorkBeginDate","本单位工作起始日"},
					{"WorkCorp","单位名称"},
					{"WorkAdd","单位地址"},
					{"FamilyStatus","借款人居住状况"},
					{"Marriage","婚姻状况"},
					{"NativePlace","户籍地址"},
					{"CreditFarmer","客户子类型1"},
					{"CreditFarmerName","客户子类型1"},
					{"FarmerSort","客户子类型2"},
					{"FarmerSortName","客户子类型2"},
					{"ManageOrgName","管户机构"},
					{"ManageUserName","管户人"},
					{"ClassifyResult","五级分类"},
					{"ClassifyResultName","五级分类"},
					{"OverdueBalance","逾期余额"},
					{"InterestBalance1","表内欠息余额(元)"},
					{"InterestBalance2","表外欠息余额(元)"}
					}; 
	
	sSql =	" select BD.SerialNo,BD.CustomerID,BD.CustomerName,getItemName('pay_type',BC.paytype) as PayType,"+
	" getBusinessName(BD.BusinessType) as BusinessTypeName,getItemName('VouchType',getVouchTypeByDueBillNo(BD.SerialNo)) as VouchType,"+
	" BD.ClassifyResult,getItemName('ClassifyResult',BD.ClassifyResult) as ClassifyResultName,"+
	" BP.ICType,getItemName('BackLoanType',BP.ICType) as ICTypeName,BD.LCATimes as OverdueDays,BC.TermMonth,BP.Purpose,getItemName('LoanPurpose',BP.Purpose) as PurposeName ,BC.Flag2,getItemName('YesNo',BC.Flag2) as Flag2Name,BP.FixCYC,"+
	" II.CreditFarmer,getItemName('CustomerType',II.CreditFarmer) as CreditFarmerName,II.FarmerSort,getItemName('CustomerType3',II.FarmerSort) as FarmerSortName,"+
	" BC.Direction,getItemName('IndustryType',substr(BC.Direction,1,1)) as DirectionName1,getItemName('IndustryType',BC.Direction) as DirectionName,getItemName('RateFloatType',BC.RateFloatType) as RateFloatType,BC.RateFloat,"+
	" getItemName('Currency',BD.BusinessCurrency) as Currency,BD.BusinessSum,BD.Balance,BD.OverdueBalance,BD.InterestBalance1,"+
	" BD.InterestBalance2,BD.ActualBusinessRate,BD.PutOutDate,BD.Maturity,"+
	" t.CMIntSum,t.AMIntSum,"+//added by bllou 计算当月利息收入和累计利息收入 20120327		
	" getItemName('Sex',II.Sex) as Sex,II.WorkBeginDate,II.WorkCorp,II.WorkAdd,getItemName('FamilyStatus',II.FamilyStatus) as FamilyStatus,getItemName('Marriage',II.Marriage) as Marriage,II.NativePlace,"+
	" getOrgName(getHeaderOrgID(GetOrgIDByCoreOrgID(nvl(BD.MFOrgID,''))))||'-'||getOrgName(GetOrgIDByCoreOrgID(nvl(BD.MFOrgID,''))) as MFOrgName,"+
	" getOrgName(BD.OperateOrgID) as ManageOrgName,getUserName(BD.OperateUserID) as ManageUserName " +
	       	" from Business_Duebill BD"+
	       	" left join Business_PutOut BP on BD.RelativeSerialNo1 = BP.SerialNo"+
	       	" inner join Business_Contract BC on BD.RelativeSerialNo2 = BC.SerialNo"+
	       	" inner join Ind_Info II on BD.CustomerID = II.CustomerID "+
	       	" left join"+
	       		" (select RelativeSerialNo,"+
	       			"nvl(sum(ActualDebitSum),0) as AMIntSum,"+//总利息收入
	       			"nvl(sum(case when OccurDate like '"+StringFunction.getToday().substring(0,7)+"%' then ActualDebitSum end),0) as CMIntSum"+//当月利息收入
	       		" from Business_WasteBook"+
	       		" where OccurSubject='2' group by RelativeSerialNo)t"+
	       	" on BD.SerialNo = t.RelativeSerialNo"+
	" where BD.OperateOrgID in (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') ";
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("BD.SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	doTemp.setKey("CustomerID",true);	
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("BusinessRate","style={width:60px} "); 		
	//设置对齐方式
	doTemp.setAlign("BusinessSum,BusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2","3");	
	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setType("BusinessSum,ActualBusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2,TermMonth","Number");
	doTemp.setCheckFormat("ActualBusinessRate","16");
	//设置下拉列表
	doTemp.setDDDWCode("ClassifyResult","ClassifyResult");
	doTemp.setDDDWCode("ICType","BackLoanType");
	doTemp.setDDDWCode("Direction","IndustryType");
	doTemp.setDDDWCode("Flag2","YesNo"); 
	doTemp.setDDDWCode("Purpose","LoanPurpose"); 
	doTemp.setDDDWSql("CreditFarmer","Select ItemNo,ItemName from code_library where codeno='CustomerType' and itemno like '030%' and itemno<>'0301' order by itemno");
	doTemp.setDDDWCode("FarmerSort","CustomerType3");
	//设置可见
	doTemp.setVisible("ClassifyResult,Direction,ICType,Purpose,Flag2,CreditFarmer,FarmerSort",false);
	
	//生成查询框
	doTemp.setColumnAttribute("SerialNo,CustomerName,BusinessTypeName,Direction,ClassifyResult,BusinessSum,Balance,Flag2,OverdueBalance,ManageOrgName,PutOutDate,Maturity,OverdueBalance,ICType,Purpose,CreditFarmer,FarmerSort","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) 
		doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页
	//dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#CMIntSum","(select nvl(sum(BW.ActualDebitSum),0) from Business_WasteBook BW where BW.RelativeSerialNo=BD.SerialNo and BW.OccurSubject='2' and BW.OccurDate like '"+StringFunction.getToday().substring(0,7)+"%')");//added by bllou 20120316 获取当月利息收入
	//dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#AMIntSum","(select nvl(sum(BW.ActualDebitSum),0) from Business_WasteBook BW where BW.RelativeSerialNo=BD.SerialNo and BW.OccurSubject='2')");//added by bllou 20120316 获取总利息收入
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
%>
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
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
			{"true","","Button","五级分类认定","五级分类认定","ClassifyEdit()",sResourcesPath}
		};
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		//BusinessDueBill
	    sObjectType = "BusinessDueBill";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}	
	
	function ClassifyEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sParaString = "CodeNo"+","+"ClassifyResult2";
		sReturnValue = setObjectValue("SelectCode",sParaString,"",0,0,"");
		if (typeof(sReturnValue)!="undefined" && sReturnValue.length!=0){
			sReturnValue = sReturnValue.split("@");
			sClassifyResult = sReturnValue[0];
			
			RunMethod("BusinessManage","UpdateClassifyResult",sSerialNo+","+sClassifyResult);
			alert("补登成功！");
			reloadSelf();
		}
	}

	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

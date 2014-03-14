<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   wwhe 2009-10-13
			Tester:
			Content: 借据信息快速查询
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
		String PG_TITLE = "借据信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
					{"CorpID","证件号码"},	
					{"RegionCode","国家地区"},	
					{"PayType","支付方式"},
					{"isJGT","是否晋钢通业务"},	
					{"BusinessTypeName","业务品种"},										
					{"BusinessSum","金额(元)"},
					{"Balance","余额(元)"},										
					{"Currency","币种"},
					{"ActualBusinessRate","执行年利率(%)"},
					{"TermMonth","期限月"},
					{"TermDay","期限日"},
					{"PutOutDate","借据起始日"},
					{"ActualMaturity","借据到期日"},
					{"MFOrgName","入账机构"},
					{"ManageOrgName","管户机构"},
					{"ManageUserName","管户人"},
					{"ClassifyResult","五级分类"},
					{"ClassifyResultName","五级分类"},
					{"OverdueBalance","逾期余额(元)"},
					{"IndustryTypeBigName","国标行业分类大类"},
					{"IndustryTypeName","国标行业分类"},
					{"OldScopeName","企业规模(老标准)"},
					{"ScopeName","企业规模"},
					{"InterestBalance1","表内欠息余额(元)"},
					{"InterestBalance2","表外欠息余额(元)"},
					{"VouchTypeName","主要担保方式"},
					{"OrgTypeName","企业类型"},
					{"LoanCardNo","贷款卡号"},
					{"TotalAssets","资产总额(元)"},
					{"SellSum","年销售额(元)"},
					{"EmployeeNumber","职工人数"},
					{"OrgNatureName","客户类型"},
					{"OrgNature","客户类型"},
					{"Month","期限类型"},
					{"Man","法定代表人"},
					{"StockHolder","股东名称"},
					{"Voucher","担保人名称"},
					{"StockHolder2","担保人股东名称"},
					{"Man2","担保人法定代表人"},
					{"Flag3Name","行内客户类型"},
					{"InputDate","查询日期"},
					{"BailRatio","保证金比例(%)"},
					{"OrgName","直属行名称"},
					{"OldDirectionName","行业投向(老国标)"},
					{"DirectionName","行业投向"},
					{"RateFloatTypeName","利率浮动方式"},
					{"RateFloat","利率浮动值"},
					{"CK","风险敞口"},
					{"RealtyFlag","重点客户链接类型"},
					{"IndustryType1","特殊客户类型"},
					{"EconomyTypeName","经营类型"}
					}; 
	if(CurUser.hasRole("098")){
		sSql =	" select BD.SerialNo,BD.RelativeSerialNo1,BD.RelativeSerialNo2,getOrgName(getHeaderOrgID(BD.OperateOrgID)) as OrgName, "+
	" getOrgName(BD.OperateOrgID) as ManageOrgName,getItemName('CustomerType2',EI.Flag3) as Flag3Name, "+
	" getItemName('RealtyFlag',RealtyFlag) as RealtyFlag,getItemName('IndustryType1',IndustryType1) as IndustryType1, "+
	" getItemName('EconomyType',EconomyType) as EconomyTypeName, "+
	" BC.CustomerID,BD.CustomerName,EI.CorpID,getItemName('AreaCode',EI.RegionCode) as RegionCode,getItemName('pay_type',BC.paytype) as PayType, getItemName('YesNo',isJGTByContractNo(BC.Serialno)) as isJGT,"+
	
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,1))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,3))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,4))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,5)) as OldDirectionName, "+
	//" getItemName('IndustryType',BC.Direction) as DirectionName, "+
	" getItemName('IndustryType',substr(BC.Direction,1,1))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,3))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,4))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,5)) as DirectionName, "+
	
	" getItemName('Currency',BD.BusinessCurrency) as Currency, "+
	" BD.BusinessSum,BD.Balance,BD.OverdueBalance,BD.InterestBalance1,BD.InterestBalance2, "+
	" getItemName('RateFloatType',BC.RateFloatType) as RateFloatTypeName,BC.RateFloat,BD.ActualBusinessRate, "+
	" BD.BailRatio,(BD.BusinessSum-(BD.BusinessSum*nvl(BD.BailRatio,0))/100) as CK, "+
	" BC.TermMonth,BC.TermDay,"+
	/*
	" case when BD.BusinessType = '2010' "+
	" then BD.BusinessSum-(BD.BusinessSum*nvl(BD.BailRatio,0)/100) "+
	" else 0.00 end as CK2, "+
	*/
	" case when days(date(replace(BD.ActualMaturity,'/','-')))-days(date(replace(BD.PutOutDate,'/','-')))>367 "+
	" then '中长期' "+
	" else '短期' end as Month, "+
	//" days(date(replace(BD.ActualMaturity,'/','-')))-days(date(replace(BD.PutOutDate,'/','-'))) as Month, "+
	" BD.PutOutDate,BD.ActualMaturity,"+
	" getOrgName(getHeaderOrgID(GetOrgIDByCoreOrgID(BD.MFOrgID)))||'-'||getOrgName(GetOrgIDByCoreOrgID(BD.MFOrgID)) as MFOrgName,"+
	" getBusinessName(BD.BusinessType) as BusinessTypeName,"+
	" BD.ClassifyResult,getItemName('ClassifyResult',BD.ClassifyResult) as ClassifyResultName, "+
	" getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
	//--担保人名称
	" getVoucher(BD.RelativeSerialNo2) as Voucher, "+
	//--担保人法定代表人名称
	" 	case when getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)) is not null and getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)) <> '' "+
	"	then "+
	"	substr(getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)),1,Locate('@',getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)))-1) "+
	"	else ''  "+
	"	end as Man2, "+
	//--担保人最大的股东名称
	" getStockHolder(getVoucherID(BD.RelativeSerialNo2)) as StockHolder2, "+
	
	" EI.OrgNature,getItemName('CustomerType',EI.OrgNature) as OrgNatureName, "+
	//--获取法定代表人名称
	" 	case when getFictitiousPerson(EI.CustomerID) is not null and getFictitiousPerson(EI.CustomerID) <> '' "+
	"	then "+
	"	substr(getFictitiousPerson(EI.CustomerID),1,Locate('@',getFictitiousPerson(EI.CustomerID))-1) "+
	"	else ''  "+
	"	end as Man, "+
	//--出资最大的股东名称
	" getStockHolder(EI.CustomerID) as StockHolder, "+
	
	
	" EI.LoanCardNo,getItemName('IndustryType',substr(EI.IndustryType,1,1)) as IndustryTypeBigName, "+
	" getItemName('IndustryType',EI.IndustryType) as IndustryTypeName,getItemName('OrgType',EI.OrgType) as OrgTypeName, "+
	" getItemName('Scope',AUS.OldEntScope) as OldScopeName,"+
	" getItemName('Scope',EI.Scope) as ScopeName,"+
	" EI.TotalAssets,EI.SellSum,EI.EmployeeNumber, "+
	" getUserName(BD.OperateUserID) as ManageUserName " +
	       	" from BUSINESS_DUEBILL BD,ENT_INFO EI,Als_UpdateEntScope AUS,BUSINESS_CONTRACT BC left join ALS_UPDATEBUSIINDUSTRY AU on BC.SerialNo=AU.ApplyNo "+
	" where BC.BusinessType not like '1%' "+
	" and BC.CustomerID = EI.CustomerID "+
	" and EI.CustomerID = AUS.CustomerID "+
	" and BD.RelativeSerialNo2 = BC.SerialNo "+
	//" and BD.SerialNo = BH.SerialNo "+
	" and BD.OperateOrgID in (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') ";
	}else{
		sSql =	" select BD.RelativeSerialNo1,BD.RelativeSerialNo2,getOrgName(substr(BD.OperateOrgID,1,2)) as OrgName, "+
	" getOrgName(BD.OperateOrgID) as ManageOrgName,getItemName('CustomerType2',EI.Flag3) as Flag3Name, "+
	//" getItemName('IndustryType1',IndustryType1) as IndustryType1Name, "+
	" BD.SerialNo,BC.CustomerID,BD.CustomerName,EI.CorpID,getItemName('AreaCode',EI.RegionCode) as RegionCode, "+
	
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,1))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,3))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,4))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,5)) as OldDirectionName, "+
	//" getItemName('IndustryType',BC.Direction) as DirectionName, "+
	" getItemName('IndustryType',substr(BC.Direction,1,1))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,3))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,4))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,5)) as DirectionName, "+
	
	" getItemName('Currency',BD.BusinessCurrency) as Currency, "+
	" BD.BusinessSum,BD.Balance,BD.OverdueBalance,BD.InterestBalance1,BD.InterestBalance2, "+
	" getItemName('RateFloatType',BC.RateFloatType) as RateFloatTypeName,BC.RateFloat,BD.ActualBusinessRate, "+
	" BD.BailRatio,(BD.BusinessSum-(BD.BusinessSum*nvl(BD.BailRatio,0))/100) as CK, "+
	" BC.TermMonth,BC.TermDay,"+
	/*
	" case when BD.BusinessType = '2010' "+
	" then BD.BusinessSum-(BD.BusinessSum*nvl(BD.BailRatio,0)/100) "+
	" else 0.00 end as CK2, "+
	*/
	" case when days(date(replace(BD.ActualMaturity,'/','-')))-days(date(replace(BD.PutOutDate,'/','-')))>367 "+
	" then '中长期' "+
	" else '短期' end as Month, "+
	//" days(date(replace(BD.ActualMaturity,'/','-')))-days(date(replace(BD.PutOutDate,'/','-'))) as Month, "+
	" BD.PutOutDate,BD.ActualMaturity, "+
	" getOrgName(getHeaderOrgID(GetOrgIDByCoreOrgID(BD.MFOrgID)))||'-'||getOrgName(GetOrgIDByCoreOrgID(BD.MFOrgID)) as MFOrgName,"+
	" getBusinessName(BD.BusinessType) as BusinessTypeName,"+
	" BD.ClassifyResult,getItemName('ClassifyResult',BD.ClassifyResult) as ClassifyResultName, "+
	" getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
	//--担保人名称
	" getVoucher(BD.RelativeSerialNo2) as Voucher, "+
	//--担保人法定代表人名称
	" 	case when getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)) is not null and getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)) <> '' "+
	"	then "+
	"	substr(getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)),1,Locate('@',getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)))-1) "+
	"	else ''  "+
	"	end as Man2, "+
	//--担保人最大的股东名称
	" getStockHolder(getVoucherID(BD.RelativeSerialNo2)) as StockHolder2, "+
	
	" EI.OrgNature,getItemName('CustomerType',EI.OrgNature) as OrgNatureName, "+
	//--获取法定代表人名称
	" 	case when getFictitiousPerson(EI.CustomerID) is not null and getFictitiousPerson(EI.CustomerID) <> '' "+
	"	then "+
	"	substr(getFictitiousPerson(EI.CustomerID),1,Locate('@',getFictitiousPerson(EI.CustomerID))-1) "+
	"	else ''  "+
	"	end as Man, "+
	//--出资最大的股东名称
	" getStockHolder(EI.CustomerID) as StockHolder, "+
	
	
	" EI.LoanCardNo,getItemName('IndustryType',substr(EI.IndustryType,1,1)) as IndustryTypeBigName, "+
	" getItemName('IndustryType',EI.IndustryType) as IndustryTypeName,getItemName('OrgType',EI.OrgType) as OrgTypeName, "+
	" getItemName('Scope',AUS.OldEntScope) as OldScopeName,"+
	" getItemName('Scope',EI.Scope) as ScopeName,"+
	" EI.TotalAssets,EI.SellSum,EI.EmployeeNumber, "+
	" getUserName(BD.OperateUserID) as ManageUserName " +
	       	" from BUSINESS_DUEBILL BD,ENT_INFO EI,Als_UpdateEntScope AUS,BUSINESS_CONTRACT BC left join ALS_UPDATEBUSIINDUSTRY AU on BC.SerialNo=AU.ApplyNo "+
	" where BC.BusinessType not like '1%' "+
	" and BC.CustomerID = EI.CustomerID "+
	" and EI.CustomerID = AUS.CustomerID "+
	" and BD.RelativeSerialNo2 = BC.SerialNo "+
	//" and BD.SerialNo = BH.SerialNo "+
	" and BD.OperateOrgID in (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') ";
	}

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
	doTemp.setHTMLStyle("DirectionName","style={width:350px} "); 	
		
	//设置对齐方式
	doTemp.setAlign("CK,BailRatio,BusinessSum,BusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2,TotalAssets,SellSum,EmployeeNumber,TermMonth,TermDay","3");	
	//小数为2，整数为5
	doTemp.setCheckFormat("BailRatio,BusinessSum,CK","2");	
	doTemp.setCheckFormat("PutOutDate,ActualMaturity","3");
	doTemp.setType("BailRatio,BusinessSum,ActualBusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2,TotalAssets,SellSum,EmployeeNumber,RateFloat","Number");
	doTemp.setCheckFormat("ActualBusinessRate","16");
	doTemp.setCheckFormat("InputDate","3");
	//设置下拉列表
	doTemp.setDDDWCode("ClassifyResult","ClassifyResult");
	//doTemp.setDDDWCode("OrgNature","CustomerType");
	//设置可见
	doTemp.setVisible("RelativeSerialNo1,RelativeSerialNo2,ClassifyResult,OrgNature",false);
	
	//生成查询框
	if(CurUser.hasRole("098")){
		doTemp.setColumnAttribute("InputDate,Month,SerialNo,CustomerName,BusinessTypeName,ClassifyResult,BusinessSum,Balance, "+
		"OverdueBalance,ManageOrgName,PutOutDate,ActualMaturity,OverdueBalance,Flag3Name,RealtyFlag,EconomyTypeName","IsFilter","1");
	}else{
		doTemp.setColumnAttribute("InputDate,Month,SerialNo,CustomerName,BusinessTypeName,ClassifyResult,BusinessSum,Balance, "+
		"OverdueBalance,ManageOrgName,PutOutDate,ActualMaturity,OverdueBalance,Flag3Name","IsFilter","1");
	}
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

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
			{"true","","Button","五级分类认定","五级分类认定","ClassifyEdit()",sResourcesPath},
			{CurUser.hasRole("000")?"true":"false","","Button","变更合同归属","变更合同归属","TransferToContract()",sResourcesPath}
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
	//added by bllou 把当前借据归属到另一个合同下 2012-07-19
	function TransferToContract()
	{
		var sDuebillSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sPutOutSerialNo = getItemValue(0,getRow(),"RelativeSerialNo1");
		var sContractSerialNo = getItemValue(0,getRow(),"RelativeSerialNo2");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sDuebillSerialNo)=="undefined" || sDuebillSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sParaString = "SerialNo,"+sContractSerialNo+",CustomerID,"+sCustomerID;
		var sReturnValue = setObjectValue("SelectChangeContract",sParaString,"",0,0,"");
		if (typeof(sReturnValue)!="undefined" && sReturnValue.length!=0){
			sReturnValue = sReturnValue.split("@");
			var sToContractSerialNo = sReturnValue[0];
			sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@RelativeSerialNo2@"+sToContractSerialNo+",Business_Duebill,String@SerialNo@"+sDuebillSerialNo);
			sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@ContractSerialNo@"+sToContractSerialNo+",Business_PutOut,String@SerialNo@"+sPutOutSerialNo);
			if(sReturnValue!=='TRUE'){
				alert("更新借据和出账的合同号由"+sContractSerialNo+"为"+sToContractSerialNo+"失败！");
				return false;
			}
			alert("变更合同归属成功！");
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

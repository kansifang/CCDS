<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin1.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2010/05/25
*	Tester:
*	Describe: 抵债资产台账
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产台账"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>

<%
	//定义变量	    
	String sSql = "";
	//定义变量：SQL语句,查询结果集,机构直属、区县标志
	//获得组件参数:树图节点,不良资产台账状态
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sOrgID == null) sOrgID="";
	//获得页面参数
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义标题
	String sHeaders[][] = {
						{"SerialNo","流水号"},
						{"BelongOrgID","抵债资产所属机构"},
						{"BelongOrgName","抵债资产所属机构"},
						{"AssetName","抵债资产名称"},
						{"GainDate","取得时间"},
						{"GainType","取得方式"},
						{"SitAddress","坐落（保管）地点"},
						{"AssetStatus","报告日抵债资产现状"},
						{"FormerManageName","原管理责任人"},
						{"AssetAna","土地性质"},
						{"AssetArea","土地面积(亩)"},
						{"PropertyFlag","是否有土地证"},
						{"GroundTransferFlag","土地是否过户"},
						{"ConstructionType","房产主体建筑结构"},
						{"HousePurpose","房产用途"},
						{"ConstructionArea","房产面积(平方米)"},
						{"PropertyFlag1","是否有房产证"},
						{"HouseTransferFlag","房产是否过户"},
						{"AssetType","抵债动产类别"},
						{"EffectsName","抵债动产名称、品牌"},
						{"AssetAmount","抵债动产实存数量"},
						{"ExistOrNewFLag","(存量/新增)初始类别"},
						{"InitializeBalance","抵债资产账面初始金额"},
						{"DisposeTotalSum","报告期抵债资产处置合计"},
						{"SaleSum","报告期抵债资产出售"},
						{"HireSum","报告期抵债资产出租"},
						{"OtherDisposeSum","报告期抵债资产其他方式处置"},
						{"LostSum","报告期抵债资产处置损失"},
						{"ReceiveSum","报告期抵债资产处置收现"},
						{"FinalAccountBalance","期末结存抵债资产账面余额"},
						{"FactValue","抵债资产估算实际价值"},
						{"CustomerName","抵债人名称"},
						{"CertType","抵债人证件类型"},
						{"CertTypeName","抵债人证件类型"},
						{"CertID","抵债人证件号码"},
						{"AccountManageDate","账务信息最后维护日期"},
						{"BasicManageDate","基本信息最后维护日期"},
						{"BadBizFinishDate","处置终结日期"},
						{"RecoverOrgID","现抵债资产管理机构"},
						{"RecoverOrgName","现抵债资产管理机构"},
						{"RecoverUserID","现抵债资产管理员"},
						{"RecoverUserName","现抵债资产管理员"},
						{"AccountNeedManage","账务信息是否待维护"},
						{"AccountNeedManageName","账务信息是否待维护"},
						{"BasicNeedManage","基本信息是否待维护"},
						{"BasicNeedManageName","基本信息是否待维护"},
						{"IsFinish","是否处置终结"},
						{"IsFinishName","是否处置终结"},
					}; 

	sSql = " select SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,"+
			" AssetName,GainDate,getItemName('PDAGainType',GainType) as GainType,SitAddress,"+
			" getItemName('AssetActualStatus',AssetStatus) as AssetStatus,"+
			" FormerManageName,"+
			" getItemName('SoilProperty',AssetAna) as AssetAna,AssetArea,"+
			" getItemName('YesNo',PropertyFlag) as PropertyFlag,"+
			" getItemName('YesNo',GroundTransferFlag) as GroundTransferFlag,"+
			" getItemName('AssetAna',ConstructionType) as ConstructionType,"+
			" getItemName('HousePurpose',HousePurpose) as HousePurpose,ConstructionArea,"+
			" getItemName('YesNo',PropertyFlag1) as PropertyFlag1,"+
			" getItemName('YesNo',HouseTransferFlag) as HouseTransferFlag,"+
			" getItemName('PDAAssetType2',AssetType) as AssetType,EffectsName,AssetAmount,"+
			" getItemName('ExistNewType',ExistOrNewFLag) as ExistOrNewFLag,"+
			" InitializeBalance,DisposeTotalSum,"+
			" SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,"+
			" CustomerName,CertType,getItemName('CertType',CertType) as CertTypeName,CertID,"+
			" AccountManageDate,BasicManageDate,"+
			" BadBizFinishDate,RecoverOrgID,getOrgName(RecoverOrgID) as RecoverOrgName,"+
			" RecoverUserID,getUserName(RecoverUserID) as RecoverUserName,"+
			" CompareDate(AccountManageDate,30,'1','2') as AccountNeedManage,CompareDate(AccountManageDate,30,'是','否') as AccountNeedManageName,"+
			" CompareDate(BasicManageDate,90,'1','2') as BasicNeedManage,CompareDate(BasicManageDate,90,'是','否') as BasicNeedManageName,"+
			" IsFinish,getItemName('YesNo',IsFinish) as IsFinishName "+
		    " from BADBIZ_ACCOUNT "+
		    " where AccountType='050' and StateFlag='10'  "+
		    " and BelongOrgID in(Select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
		   
	//根据树图取不同结果集	 
	/*
		StateFlag 台账阶段:
					01:未登记
					10:已登记
					03:已取消
					80:已终结		
	*/
	
	sSql+= "order by SerialNo";
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("BelongOrgID,RelativeContractNo,LoanType,CertType,RecoverOrgID,RecoverUserID,IsFinish,AccountNeedManage,BasicNeedManage",false);
	doTemp.UpdateTable="BADBIZ_ACCOUNT";
	doTemp.setKey("SerialNo",true);	
    
	//设置行宽
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");

	//设置金额为三位一逗数字
	doTemp.setType("ConstructionArea,AssetArea,AssetArea,ConstructionArea,SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("ConstructionArea,AssetArea,AssetArea,ConstructionArea,SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","2");
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("ConstructionArea,AssetArea,AssetArea,ConstructionArea,SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","3");
	
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWCode("IsFinish","YesNo");
	doTemp.setDDDWCode("AccountNeedManage","YesNo");
	doTemp.setDDDWCode("BasicNeedManage","YesNo");
	//doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
	//生成查询框
		doTemp.setColumnAttribute("SerialNo,ClassifyResult,BadLoanType,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,AccountNeedManage,BasicNeedManage,IsFinish,RecoverOrgID,RecoverUserID","IsFilter","1");
	
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
		{"true","","Button","确定","确定","doReturn()",sResourcesPath},
		};
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script language=javascript>
function doReturn(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			self.returnValue=sSerialNo;//返回参数
			self.close();
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

<%@include file="/IncludeEnd.jsp"%>
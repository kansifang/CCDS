<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  wangdw 2012/06/13
		Tester:
		Content: 融资平台借据台账
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：
					Flag:
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "融资平台借据台账"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql
	String sComponentName = "";//--组件名称
	String sFlag = "";//标识
	String PG_CONTENT_TITLE = "";//--题头
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数
	sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));	//获得页面参数
	if(sFlag==null) sFlag = "";
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 
							{"SERIALNO","借据流水号"},
							{"CUSTOMERNAME","客户名称"},
							{"BusinessTypeName","业务品种"},
							{"BUSINESSSUM","借据金额"},
							{"BALANCE","借据余额"},
							{"BusinessCurrency","币种"},
							{"ACTUALBUSINESSRATE","执行月利率"},
							{"RateFloat","利率浮动值"},
							{"PutOutDate","借据起始日"},
							{"Maturity","借据到期日"},
							{"VouchType","主要担保方式"},
							{"NormalBalance","正常余额"},
							{"OverdueBalance","逾期金额"},
							{"DullBalance","呆滞余额"},
							{"BadBalance","呆帐金额"},
							{"PlatformLevel_name","平台级别"},
							{"PlatformLevel","平台级别"},
							{"DealClassify_name","处置分类"},
							{"DealClassify","处置分类"},
							{"LegalPersonNature_name","法人类型"},
							{"LegalPersonNature","法人类型"},
							{"PlatformType_name","平台类型"},
							{"PlatformType","平台类型"},
							{"CashCoverDegree_name","现金流覆盖程度"},
							{"CashCoverDegree","现金流覆盖程度"},
							{"FinanceCreditType_name","信贷分类"},
							{"FinanceCreditType","信贷分类"}
							}; 					
	sSql =	"select BD.SERIALNO,BD.RelativeSerialNo2,BD.CUSTOMERNAME,getBusinessName(BD.BusinessType) as BusinessTypeName,BD.BUSINESSSUM,BD.BALANCE,"
		    +"getItemName('Currency',BD.BusinessCurrency) as BusinessCurrency,BD.ACTUALBUSINESSRATE,BC.RateFloat,"
		    +"BD.PutOutDate,BD.Maturity,getItemName('VouchType',BC.VouchType) as VouchType,BD.NormalBalance,BD.OverdueBalance,BD.DullBalance,BD.BadBalance,"
			+"getItemName('PlatformLevel',CF.PlatformLevel) as PlatformLevel_name,"
		    +"CF.PlatformLevel,"
		    +"getItemName('DealClassify',CF.DealClassify) as DealClassify_name,"
		    +"CF.DealClassify,"
		    +" getItemName('LegalPersonNature',CF.LegalPersonNature) as LegalPersonNature_name,"
		    +"CF.LegalPersonNature,"
		    +" getItemName('FinancePlatformType',CF.PlatformType) as PlatformType_name,"
		    +"CF.PlatformType,"
		    +" getItemName('CashCoverDegree',CF.CashCoverDegree) as CashCoverDegree_name,"
		    +"CF.CashCoverDegree,"
		    +" getItemName('FinanceCreditType',CF.FinanceCreditType) as FinanceCreditType_name,"
		    +"CF.FinanceCreditType"
		    +" from BUSINESS_DUEBILL as BD,BUSINESS_CONTRACT as BC,CUSTOMER_FINANCEPLATFORM as CF "
		    +"where BD.CUSTOMERID=CF.CUSTOMERID and BD.RelativeSerialNo2 = BC.SerialNo";
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    //doTemp.setKeyFilter("EI.CustomerID");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	//doTemp.setKey("SerialNo",true);	
	//设置显示文本框的长度及事件属性
	//doTemp.setHTMLStyle("PlatformLevel,DealClassify,LegalPersonNature,PlatformType,FinanceCreditType,CashCoverDegree","style={width:250px} ");  
	//设置对齐方式
	//doTemp.setAlign("OverDueDays,BusinessRate,RateFloat,BCBusinessSum,BusinessSum,Balance,Interestbalance1,Interestbalance2","3");
	doTemp.setVisible("PlatformLevel,DealClassify,LegalPersonNature,PlatformType,CashCoverDegree,FinanceCreditType,RelativeSerialNo2",false);
	//小数为2，整数为5
	doTemp.setCheckFormat("BUSINESSSUM,BALANCE,ACTUALBUSINESSRATE,RateFloat,NormalBalance,OverdueBalance,DullBalance,BadBalance","2");
	doTemp.setDDDWSql("PlatformLevel","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'PlatformLevel'");
	doTemp.setDDDWSql("DealClassify","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'DealClassify'");
	doTemp.setDDDWSql("LegalPersonNature","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'LegalPersonNature'");
	doTemp.setDDDWSql("PlatformType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'FinancePlatformType'");
	doTemp.setDDDWSql("CashCoverDegree","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CashCoverDegree'");
	doTemp.setDDDWSql("FinanceCreditType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'FinanceCreditType'");
	
	//生成查询框
	doTemp.setFilter(Sqlca,"1","PlatformLevel","");
	doTemp.setFilter(Sqlca,"2","DealClassify","");
	doTemp.setFilter(Sqlca,"3","LegalPersonNature","");
	doTemp.setFilter(Sqlca,"4","PlatformType","");
	doTemp.setFilter(Sqlca,"5","CashCoverDegree","");
	doTemp.setFilter(Sqlca,"6","FinanceCreditType","");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
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
			{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
			{"true","","Button","合同详情","合同详情","viewTab()",sResourcesPath},
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
 	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"RelativeSerialNo2");	
		
	    sObjectType = "AfterLoan";
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
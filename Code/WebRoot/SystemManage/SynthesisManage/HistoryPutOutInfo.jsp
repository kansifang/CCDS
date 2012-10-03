<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hlzhang 2012.08.09
		Tester:
		Content: 出帐修改详情
		Input Param:
		Output param:
		History Log:  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "出账修改详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	
	//获得组件参数：对象类型和对象编号
	String sBPBSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BPBSerialNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//定义变量：SQL语句、出帐业务品种、出帐显示模版、对象主表、暂存标志
	String sSql = "",sBusinessType = "",sDisplayTemplet = "",sMainTable = "";
	//定义变量：发生类型
	String sBCOccurType = "";
	//定义变量：查询结果集
	ASResultSet rs = null;
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	//根据对象类型从对象类型定义表中查询到相应对象的主表名
	sSql = 	" select ObjectTable from OBJECTTYPE_CATALOG "+
			" where ObjectType = '"+sObjectType+"' ";
	sMainTable = Sqlca.getString(sSql);	
	
	//获取出帐业务品种
	sSql = 	" select BusinessType from "+sMainTable+" "+
			" where SerialNo ='"+sObjectNo+"' ";
	sBusinessType = Sqlca.getString(sSql);	
	//如果业务品种为空,则显示短期流动资金贷款
	if (sBusinessType.equals(""	)) sBusinessType = "1010010";
	
	//获取该出帐信息的发生类型
	sSql = 	" select BC.OccurType,BC.PutOutDate,BC.Maturity,BC.BusinessType,BC.BusinessSum,BC.AdjustRateType "+
			" from BUSINESS_CONTRACT BC "+
			" where exists (select BP.ContractSerialNo from BUSINESS_PUTOUT BP "+
			" where BP.SerialNo = '"+sObjectNo+"' "+
			" and BP.ContractSerialNo = BC.SerialNo) ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sBCOccurType = rs.getString("OccurType");
		//将空值转化为空字符串
		if(sBCOccurType == null) sBCOccurType = "";
	}
	rs.getStatement().close();
	
	if(sBCOccurType.equals("015")) //展期
		sDisplayTemplet = "PutOutInfo0";
	else
	{
		//根据产品类型从产品信息表BUSINESS_TYPE中获得显示模版名称
		sSql = " select DisplayTemplet from BUSINESS_TYPE where TypeNo = '"+sBusinessType+"' ";
		sDisplayTemplet = Sqlca.getString(sSql);
		if(sDisplayTemplet==null)sDisplayTemplet="";
	}
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,Sqlca);
	
	//设置更新表名和主键
	doTemp.UpdateTable = "BUSINESS_PUTOUT_BAK";
	doTemp.setKey("BPBSerialNo",true);
	doTemp.FromClause = " from BUSINESS_PUTOUT_BAK BUSINESS_PUTOUT";
	doTemp.WhereClause = " where BPBSerialNo = '"+sBPBSerialNo+"' ";
		
	//当业务品种为表外业务时，不显示支付方式 add by bqliu 2011-05-19
	if(sBusinessType.startsWith("2"))
	{
		doTemp.setRequired("SelfPayMethod",false);
		doTemp.setVisible("SelfPayMethod",false);
	}
	
	//设置格式,后面小数点4位
	doTemp.setCheckFormat("RateFloat,BackRate,RiskRate","14");
	//设置利率格式,后面小数点6位
	doTemp.setCheckFormat("BaseRate,BusinessRate,OverdueRate,TARate","16");
	
	//设置固定周期输入范围
	if(sDisplayTemplet.equals("PutOutInfo1") || sDisplayTemplet.equals("PutOutInfo2") || sDisplayTemplet.equals("PutOutInfo3") || sDisplayTemplet.equals("PutOutInfo8")){
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=2 && parseFloat(myobj.value,10)<=12 \" mymsg=\"固定周期输入范围为[2,12]\" ");
	}
	if(sDisplayTemplet.equals("PutOutInfo9")){
		doTemp.appendHTMLStyle("CDate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=31 \" mymsg=\"扣款日输入范围为[0,31]\" ");
	}
	if(sDisplayTemplet.equals("PutOutInfo11")||sDisplayTemplet.equals("PutOutInfo12"))
	{
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率必须大于等于0,小于等于1000！\" ");
	}
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例必须大于等于0,小于等于100！\" ");
	
	if("2050010".equals(sBusinessType) || "2050020".equals(sBusinessType) || "2050030".equals(sBusinessType) || "2050040".equals(sBusinessType)){
		doTemp.setRequired("BusinessRate,ICCyc,CorpusPayMethod",false);
		doTemp.setVisible("BusinessRate,ICCyc,CorpusPayMethod",false);
	}
	
	doTemp.setReadOnly("",false);
	doTemp.setReadOnly("SerialNo,CustomerID,CustomerName,BusinessTypeName,OccurDate,CertID,CertType,ContractSerialNo",true);
	doTemp.setRequired("",false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);

	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
 
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------

	//---------------------定义按钮事件------------------------------------	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/HistoryPutOutList.jsp","_self","");
	}
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=获取保证金;InputParam=无;OutPutParam=无;]~*/
	function getBailSum(){
		//手工录入
	}
	
	/*~[Describe=弹出损益入帐机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getPutOutOrg()
	{		
		sParaString = "OrgID"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectBelongOrg",sParaString,"@AboutBankID3@0@AboutBankID3Name@1",0,0,"");		
	}
	
	/*~[Describe=弹出记账机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectPutOutOrg()
	{		
		sParaString = "SortNo"+","+"<%=CurOrg.SortNo%>";
		setObjectValue("SelectBelongOrgCode",sParaString,"@PutOutOrgID@0@PutOutOrgIDName@1",0,0,"");		
	}
	/*~[Describe=根据基准利率、利率浮动方式、利率浮动值计算执行年(月)利率;InputParam=无;OutPutParam=无;]~*/
	function getBusinessRate(sFlag)
	{
		//手工录入
	}
	
	//取得基准年利率
	function selectBaseRateType(){
		sCurDate = "<%=StringFunction.getToday()%>"
		sParaString = "CurDate"+","+sCurDate;
	    sReturn = setObjectValue("selectBaseRateType",sParaString,"@BaseRateType@0@BaseRate@1",0,0,"");
		getBusinessRate("M");
	}
	//自动获取利率类型 2009-12-24 
	function getBaseRateType(){
		 //手工录入
	}
	
	/*~[Describe=挤占/挪用利率InputParam=无;OutPutParam=无;]~*/
	function getTARate()
	{
		//手工录入
	}
	/*~[Describe=计算逾期利率;InputParam=无;OutPutParam=无;]~*/
	function getOverdueRate()
	{
		//手工录入
	}
	
	//出账阶段，重新获取基准利率 
	function getNewBaseRate(){
		//手工录入
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_PUTOUT_BAK";//表名
		var sColumnName = "BPBSerialNo";//字段名
		var sPrefix = "BPB";//前缀
       
		//使用GetSerialNo.jsp来抢占一个流水号
		var sBPBSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		//将流水号返回
		return sBPBSerialNo;
	}
	</SCRIPT>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
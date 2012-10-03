<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/10/20
*	Tester:
*	Describe: 不良资产合同提示列表
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产合同提示列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%
	//定义变量	    
	String sSql = "";
	//定义变量：
	//获得组件参数
	String sAlarmType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AlarmType"));
	if(sAlarmType == null) sAlarmType="";
	//获得页面参数
			
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义标题
	String sHeaders[][] = {
							{"CustomerName","客户名称"},
							{"SerialNo","合同编号"},				
							{"BusinessTypeName","业务品种"},
							{"OccurTypeName","发生类型"},
							{"VouchTypeName","主要担保方式"},
							{"BusinessCurrencyName","币种"},
							{"BusinessSum","金额"},
							{"Balance","余额"},
							{"PutOutDate","起始日"},
							{"Maturity","到期日"}
						}; 
 	sSql = " select CustomerID,CustomerName,SerialNo," + 	
		   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
		   " getItemName('OccurType',OccurType) as OccurTypeName," + 
		   " getItemName('VouchType',VouchType) as VouchTypeName," + 
		   " getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
		   " BusinessSum,Balance,PutOutDate,Maturity "+
		   " from BUSINESS_CONTRACT "+
		   " where substr(ClassifyResult,1,2)>'02'"+
		   " and RecoveryUserID='"+CurUser.UserID+"'"+
		   " and RecoveryOrgID='"+CurOrg.OrgID+"'";
		   
	//根据树图取不同结果集	 
	/*
		BadLoanCaliber 不良贷款口径标识:
					010:账面不良贷款
					020:票据置换不良贷款
					030:股金置换不良贷款
					040:已核销不良贷款
		BadBizProjectFlag 不良贷款项目标识:
					010:一般项目
					020:重点项目
		EMonitorDate 最近一次重点项目监控时间
		CMonitorDate 最近一次一般项目监控时间
						
	*/
	if(sAlarmType.equals("010050"))//30天不良到期提示
	{
		sSql+=" and days(replace(Maturity,'/','-'))<30+days(current date) and days(replace(Maturity,'/','-'))>days(current date)";
	}else if(sAlarmType.equals("010090"))//60天账面不良贷款监控到期提示
	{
		sSql+=" and (FinishDate is  null or FinishDate ='')  and BadLoanCaliber='010' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<days(current date)-60)";
	}else if(sAlarmType.equals("010100"))//60天股金置换不良贷款监控到期提示
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<days(current date)-60)";
	}else if(sAlarmType.equals("010110"))//150天票据置换不良贷款监控到期提示
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<days(current date)-150)";
	}else if(sAlarmType.equals("010120"))//已核销不良贷款监控到期提示
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-180 )";
	}else if(sAlarmType.equals("010060"))//90天诉讼时效即将到期提示
	{
		sSql+=" and (FinishDate is  null or FinishDate ='')  "+
				" and LawEffectDate is not null and LawEffectDate!='' "+
				" and days(replace(LawEffectDate,'/','-'))<days(current date)+90"+
				" and days(replace(LawEffectDate,'/','-'))>days(current date)";
	}else if(sAlarmType.equals("010070"))//90天担保时效即将到期提示
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') "+
		" and VouchEffectDate is not null and VouchEffectDate!='' "+
		" and days(replace(VouchEffectDate,'/','-'))<days(current date)+90"+
		" and days(replace(VouchEffectDate,'/','-'))>days(current date)";
	}else
	{
		sSql+=" and 1=2";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("RecoveryUserID,RecoveryOrgID,CustomerID,BusinessType,ClassifyResult,ShiftType,ShiftTypeName",false);
	doTemp.setKeyFilter("SerialNo");		
    
	//设置行宽
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("PutOutDate,Maturity"," style={width:65px} ");

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,Balance","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,BusinessCurrencyName","2");
	
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(20); 	//服务器分页
	
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

	String sButtons[][] = {
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		};
	//根据不同树图显示按钮
	
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	
	
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
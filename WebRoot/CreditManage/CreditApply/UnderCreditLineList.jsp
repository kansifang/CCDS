<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%> 
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: 额度项下业务
		Input Param:
			ObjectType: 阶段编号
			ObjectNo：业务流水号
		Output Param:

		HistoryLog: 
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "额度项下业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "", sSql1 = "";
	ASResultSet rs=null;

	//获得页面参数

	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sBusinessType1 = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
	String sHeaders[][] = 	{
				{"SerialNo","合同流水号"},
				{"CustomerName","客户名称"},
				{"BusinessTypeName","业务品种"},
				{"OccurTypeName","发生类型"},
				{"ObjectNo","合同编号"},
				{"Currency","币种"},
				{"BusinessSum","金额(元)"},
				{"OccurDate","申请日期"},
				{"VouchTypeName","担保方式"},
				{"FinishDate","终结日期"},
				{"OperateOrgName","经办机构"},
			      	};


	sSql =   " select"+	"  B.SerialNo as SerialNo,"+
					
					" B.CustomerID,getCustomerName(B.CustomerID) as CustomerName,"+
					" B.BusinessType,getBusinessName(B.BusinessType) as BusinessTypeName,"+
					" B.OccurType,getItemName('OccurType',B.OccurType) as OccurTypeName,"+
					" B.BusinessCurrency,getItemName('Currency',B.BusinessCurrency) as Currency,"+
					" B.BusinessSum, "+
					" B.VouchType,getItemName('VouchType',B.VouchType) as VouchTypeName,"+
					" B.FinishDate, "+
					" B.OperateOrgID,getOrgName(B.OperateOrgID) as OperateOrgName"+
					" from  Business_Contract B "+
					" where B.BusinessType not like '30%' and (B.FinishDate = '' or B.FinishDate is null) ";

	
	if(sBusinessType1.equals("3010") || sBusinessType1.equals("3040"))
	{
		sSql1 = " and B.CreditAggreement = '"+sObjectNo+"' ";
	}else if(sBusinessType1.equals("3050"))
	{
		sSql1 = " and B.AssureAgreement = '"+sObjectNo+"' ";
	}else if(sBusinessType1.equals("3060"))
	{
		sSql1 = " and B.CommunityAgreement = '"+sObjectNo+"' ";
	}
	sSql = sSql + sSql1;
	
	//out.println(sSql);

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,OperateOrgID",false);
	//设置数据表名和主键
   	doTemp.UpdateTable ="BUSINESS_CONTRACT";                               
    doTemp.setKey("SerialNo",true);
    		  
	doTemp.setAlign("BusinessSum","3");
	doTemp.setCheckFormat("BusinessSum","2");

	//生成datawindow
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

	String sButtons[][] = {
		{"true","","Button","详情","查看额度项下业务详情","viewAndEdit()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	function viewAndEdit()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else 
		{
			openObject("BusinessContract",sObjectNo,"001");
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

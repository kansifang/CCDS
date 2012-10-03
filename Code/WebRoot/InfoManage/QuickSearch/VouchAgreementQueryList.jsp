<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:xhyong 2012-08-01
		Tester:
		Content:  担保机构担保协议查询
		Input Param:
			
		Output param:
		History Log: 
			 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "担保机构担保协议查询列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	String sWhere = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		
	//显示标题				
	String[][] sHeaders = {		
							{"SerialNo","担保协议流水号"},              	
							{"CustomerName","担保机构名称"},             
							{"VouchTotalSum","担保总额度"},           	
							{"VouchAgreementNo","担保协议号"}, 
							{"PutOutDate","担保起始日"},            	
							{"Maturity","担保到期日"},
							{"VouchOrgType","担保机构类型"},
							{"VouchOrgTypeName","担保机构类型"},
							{"ManageCustomerOrgName","管户机构"},
							{"TermMonth","担保期限（月）"},
							{"FreezeFlag","额度状态"},  
						 };
	

	sSql =  " select SerialNo,CustomerName,VouchTotalSum,VouchAgreementNo,"+
			" PutOutDate,Maturity,VouchOrgType,"+
			" getItemName('VouchOrgType',VouchOrgType) as VouchOrgTypeName ,"+
			" (select getOrgName(OrgID) as ManageCustomerOrgName"+
			" from CUSTOMER_BELONG   "+
			" where CustomerID=EA.CustomerID "+
			" and  BelongAttribute1='1' fetch first 1 rows only),"+
			"TermMonth,getItemName('FreezeFlag',FreezeFlag) as FreezeFlag "+
			" from Ent_Agreement EA "+
			" where AgreementType = 'VouchAgreement' "+
			" and FreezeFlag <> '' and FreezeFlag is not null  ";
			
	ASDataObject doTemp = new ASDataObject(sSql);
	//添加机构项下
	sWhere += OrgCondition.getOrgCondition("InputOrgID",CurOrg.OrgID,Sqlca); 
	doTemp.WhereClause+=sWhere;
	
	doTemp.UpdateTable="Ent_Agreement";
	doTemp.setKey("SerialNo",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("Currency","2");
	   
	doTemp.setType("VouchTotalSum","Number");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency"," style={width:80px} ");
	doTemp.setVisible("VouchOrgType",false);
	doTemp.setDDDWCode("VouchOrgType","VouchOrgType");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	//设置Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.setColumnAttribute("VouchTotalSum","IsFilter","1");
	doTemp.setColumnAttribute("PutOutDate","IsFilter","1");
	doTemp.setColumnAttribute("Maturity","IsFilter","1");
	doTemp.setColumnAttribute("VouchOrgType","IsFilter","1");
	doTemp.setColumnAttribute("ManageCustomerOrgName","IsFilter","1");	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","协议项下业务","协议项下业务","AgreementBusiness()",sResourcesPath},
		};
		
	%> 
	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=协议项下业务;InputParam=无;OutPutParam=无;]~*/
	function AgreementBusiness()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sAgreementType   = "VouchAggreement";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("AgreementBusiness","/CreditManage/CreditLine/AgreementBusiness.jsp","SerialNo="+sSerialNo+"&AgreementType="+sAgreementType,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("VouchAgreementInfo","/CreditManage/CreditLine/VouchAgreementInfo.jsp","SerialNo="+sSerialNo+"&ReadOnly=true","_blank",OpenStyle);
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
		
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
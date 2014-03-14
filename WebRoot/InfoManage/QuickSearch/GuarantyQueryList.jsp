<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   CYHui 2005-1-25
			Tester:
			Content: 担保合同快速查询
			Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：担保合同快速查询
		          
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
		String PG_TITLE = "担保合同快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";//--存放sql
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
					{"CustomerID","接受客户编号"},
					{"CustomerName","接受担保客户名称"},
					{"ContractType","担保类型"},
					{"ContractTypeName","担保类型"},
					{"GuarantyType","担保方式"},
					{"GuarantyTypeName","担保方式"},
					{"GuarantorName","提供担保人名称"},
					{"GuarantyCurrencyName","担保币种"},
					{"GuarantyValue","担保总金额"},
					{"SerialNo","担保合同流水号"},
					{"InputOrgID","登记机构"},
					{"InputOrgIDName","登记机构"}
					}; 
	
	sSql =	" select InputOrgID,getOrgName(InputOrgID) as InputOrgIDName, "+
	" SerialNo,ContractNo,CustomerID,getCustomerName(CustomerID) as CustomerName, " +
	" ContractType,getItemName('ContractType',ContractType) as ContractTypeName, "+
	" GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName, "+
	" getCustomerName(GuarantorID) as GuarantorName,"+
	" getItemName('Currency',GuarantyCurrency) as GuarantyCurrencyName,GuarantyValue " +
	       	" from GUARANTY_CONTRACT " +
	" where ContractStatus ='020' "+
	" and InputOrgID in  (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') ";
		
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";	
	//设置关键字
	doTemp.setKey("SerialNo",true);
	//设置不可见项
	doTemp.setVisible("ContractNo,BusinessType,ContractType,GuarantyType,InputOrgID",false);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName,GuarantorName","style={width:250px} ");  		
	//设置对齐方式
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setType("GuarantyValue","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("GuarantyValue","2");	
	//生成下拉框
	doTemp.setDDDWCode("ContractType","ContractType");
	doTemp.setDDDWCode("GuarantyType","GuarantyType");
	
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","ContractType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"7","GuarantyType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"3","GuarantorName","");
	doTemp.setFilter(Sqlca,"4","GuarantyValue","");
	doTemp.setFilter(Sqlca,"5","SerialNo","");
	doTemp.setFilter(Sqlca,"6","InputOrgIDName","");
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
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath}
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
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			openObject("GuarantyContract",sSerialNo,"002");
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

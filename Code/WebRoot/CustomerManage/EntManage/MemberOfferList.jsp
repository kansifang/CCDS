<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: 关联集团(联保小组)成员为本行客户提供担保情况列表;
		Input Param:
			CustomerID：当前客户编号
			NoteType：区分  关联集团：Aggregate
            		        联保小组：AssureGroup
            		        信用共同体: CreditGroup
		Output Param:
			ObjectType: 对象类型。
			ObjectNo: 对象编号。
			BackType: 返回方式类型(Blank)

		HistoryLog:
		增加联保小组
		2004-12-14
		jytian
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联集团成员为本行客户提供担保情况列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sCon = "";
	//获得页面参数
	//获得组件参数
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sNoteType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("NoteType"));
	if(sCustomerID == null) sCustomerID = "";
	if(sNoteType == null) sNoteType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	if (sNoteType.equals("Aggregate"))
	{
		sCon=" (select RELATIVEID from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and RelationShip like '04%' )";
	}
	else if (sNoteType.equals("AssureGroup"))
	{
		sCon=" (select CustomerID from CUSTOMER_RELATIVE where RelativeID='"+sCustomerID+"' and RelationShip='5501' ) ";
	}
	else if (sNoteType.equals("CreditGroup"))
	{
		sCon=" (select CustomerID from CUSTOMER_RELATIVE where RelativeID='"+sCustomerID+"' and RelationShip='0701' ) ";
	}
	
	String sHeaders[][] = {
							{"SerialNo","担保合同流水号"},
							{"CustomerName","成员客户名称"},
							{"GuarantorName","被担保人名称"},							
							{"GuarantyTypeName","担保类型"},
							{"Currency","币种"},
							{"GuarantyValue","担保总金额"},
							{"BeginDate","起始日期"},
							{"EndDate","到期日期"},
							{"InputOrgName","经办机构"},
						  };
	String sSql =   " select SerialNo,"+
					" GuarantorName as CustomerName,"+
					" CustomerID,getCustomerName(CustomerID) as GuarantorName,"+
					" ContractNo,"+
					" GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName,"+
					" GuarantyCurrency,getItemName('Currency',GuarantyCurrency) as Currency,"+
					" GuarantyValue,"+
					" BeginDate,EndDate,"+
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName"+
					" from GUARANTY_CONTRACT"+
					" where GuarantorID in "
					+ sCon +
					" and ContractStatus = '020'";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("CustomerID,ContractNo,GuarantyType,GuarantyCurrency,InputOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setAlign("GuarantyTypeName,Currency","2");
	doTemp.setCheckFormat("GuarantyValue","2");
	//设置html格式
	doTemp.setHTMLStyle("SerialNo","style={width=140px}");
	doTemp.setHTMLStyle("CustomerName,GuarantorName"," style={width:180px} ");
	doTemp.setCheckFormat("BeginDate,EndDate","3");
	doTemp.appendHTMLStyle("GuarantyTypeName,Currency"," style={width:50px} ");
	doTemp.appendHTMLStyle("InputOrgName"," style={width:200px} ");	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
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
		{"true","","Button","详情","查看为本行客户提供担保情况详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","信息汇总","信息汇总","infoGather()",sResourcesPath},
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
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			openObject("GuarantyContract",sSerialNo,"002");
		}
	}
	
	/*~[Describe=汇总详情;InputParam=无;OutPutParam=无;]~*/
	function infoGather()
	{
		OpenPage("/CustomerManage/EntManage/MemberOfferGather.jsp?CustomerID=<%=sCustomerID%>&NoteType=<%=sNoteType%>","","");	
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-12-6
		Tester:
		Describe: 抵质押物担保的担保合同列表;
		Input Param:
				
		Output Param:
				
		HistoryLog:
										
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "担保合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	
	//获得组件参数：抵质押物编号
	String sGuarantyID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyID"));
	
	//获得页面参数

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","担保合同编号"},
							{"GuarantyTypeName","担保方式"},
							{"GuarantyStatusName","担保状态"},				           
							{"GuarantorName","担保人名称"},
							{"GuarantyValue","担保金额"},				            
							{"GuarantyCurrency","币种"},
							{"ContractStatusName","合同状态"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"}
						  };

	sSql =  " select distinct GC.SerialNo,GC.CustomerID,GC.GuarantyType,GC.ContractStatus, "+	
			" getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName, "+	
			" getItemName('ContractStatus',GC.ContractStatus) as GuarantyStatusName, "+	
			" GC.GuarantorID,GC.GuarantorName,GC.GuarantyValue, "+
			" getItemName('Currency',GC.GuarantyCurrency) as GuarantyCurrency, "+			
			" GC.InputUserID,getUserName(GC.InputUserID) as InputUserName, "+
			" GC.InputOrgID,getOrgName(GC.InputOrgID) as InputOrgName "+
			" from GUARANTY_RELATIVE GR,GUARANTY_CONTRACT GC "+
			" where GR.ObjectType = 'BusinessContract' "+
			" and GR.ContractNo = GC.SerialNo "+
			" and GR.GuarantyID = '"+sGuarantyID+"' "+			
			" and GC.InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("CustomerID,GuarantorID,GuarantyType,ContractStatus,InputUserID,InputOrgID",false);
	
	//设置格式
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setCheckFormat("GuarantyValue","2");
	doTemp.setHTMLStyle("GuarantyTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:180px} ");
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
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
		{"true","","Button","详情","查看担保合同信息详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","担保客户详情","查看担保合同相关的担保客户详情","viewCustomerInfo()",sResourcesPath},
		{"true","","Button","相关业务详情","查看担保合同相关的业务合同信息列表","viewBusinessInfo()",sResourcesPath}
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//担保类型
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//担保合同编号
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			OpenPage("/CreditManage/GuarantyManage/GuarantyContractInfo.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"_self");
		}
	}
	
	/*~[Describe=查看担保客户详情详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (sCustomerID.length == 0)
				alert("担保客户无详细信息！");
			else
				openObject("Customer",sCustomerID,"002");
		}
	}

	/*~[Describe=查看担保合同关联业务详情;InputParam=无;OutPutParam=无;]~*/
	function viewBusinessInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			OpenComp("AssureBusinessList","/CreditManage/CreditAssure/AssureBusinessList.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
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
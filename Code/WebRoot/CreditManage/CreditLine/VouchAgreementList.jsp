<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:lpzhang 2009-8-9
		Tester:
		Content:  担保机构担保协议
		Input Param:
			
		Output param:
		History Log: 
			 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "担保机构担保协议列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
							{"SerialNo","协议流水号"},              	
							{"CustomerName","担保公司名称"},              
							{"VouchOrgTypeName","担保机构类型"},            
							{"VouchTotalSum","担保总额度"},           	
							{"VouchAgreementNo","担保协议号"}, 
							{"PutOutDate","担保协议起始日"},            	
							{"Maturity","担保协议到期日"},
							{"FreezeFlag","额度状态"},
							{"InputUserName","登记人"},                  
							{"InputOrgName","登记机构"},                
							{"InputDate","登记日期"},                
							{"UpdateDate","更新日期"},    
						 };
	

	sSql =  " select SerialNo,CustomerName,VouchOrgType,getItemName('VouchOrgType',VouchOrgType) as VouchOrgTypeName ,VouchTotalSum,"+
			" VouchAgreementNo,PutOutDate,Maturity,getItemName('FreezeFlag',FreezeFlag) as FreezeFlag,"+
			" getUserName(InputUserID) as InputUserName,UpdateDate "+
			" from Ent_Agreement where AgreementType = 'VouchAgreement' and FreezeFlag <> '' and FreezeFlag is not null  ";
			
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
	
	//设置Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","冻结","冻结此协议","FreezeAgreement()",sResourcesPath},
		{"true","","Button","解冻","解冻此协议","CancelFreeze()",sResourcesPath},
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
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenComp("VouchAgreementInfo","/CreditManage/CreditLine/VouchAgreementInfo.jsp","","_blank",OpenStyle)
		reloadSelf();
	}
	
	/*~[Describe=冻结协议;InputParam=无;OutPutParam=无;]~*/
	function FreezeAgreement()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sReturn = RunMethod("CreditLine","CheckFreeze",sSerialNo);
		if(sReturn == "2")
		{
			alert("该额度已经被冻结，不能进行此操作！");
			return;
		}
		
		if(confirm("您确定要冻结此额度吗？"))
		{
	        RunMethod("CreditLine","FreezeAgreement",sSerialNo);
	        reloadSelf();
		}
	}
	
	
	/*~[Describe=解冻协议;InputParam=无;OutPutParam=无;]~*/
	function CancelFreeze()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sReturn = RunMethod("CreditLine","CheckFreeze",sSerialNo);
		if(sReturn != "2")
		{
			alert("该额度未被冻结，不能进行此操作！");
			return;
		}
		
		if(confirm("您确定要解除此额度冻结吗？"))
		{
	        RunMethod("CreditLine","CancelFreeze",sSerialNo);
	        reloadSelf();
		}
	}
	
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
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
       		as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
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
			OpenComp("VouchAgreementInfo","/CreditManage/CreditLine/VouchAgreementInfo.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
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
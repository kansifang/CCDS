<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-3
		Tester:
		Content: 待处置资产的相关联合同列表RelativeContractList.jsp
		Input Param:				
			    SerialNo：抵债资产编号
		Output param:
		History Log: 		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "待处置的资产关联合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
		
	//获得组件参数		
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));	//资产流水号
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 									
							{"AssetName","资产名称"},
							{"ContractSerialNo","合同流水号"},						
							{"CustomerName","客户名称"},
							{"BusinessCurrencyname","合同币种"},
							{"BusinessSum","合同金额"},
							{"Balance","合同余额"},
							{"IndebtSum","抵债金额(元)"},	
							{"Principal","抵入本金(元)"},	
							{"IndebtInterest","表内息(元)"},	
							{"OutdebtInterest","表外息(元)"}, 
							{"OtherInterest","其他(元)"}
						}; 
						
	//从抵债资产关联信息表ASSET_CONTRACT中选出相关联的合同及其相关信息
	sSql =  " select AI.SerialNo as SerialNo,"+		
			" AI.AssetName as AssetName,"+
			" AC.ContractSerialNo as ContractSerialNo,"+			
			" BC.CustomerName as CustomerName,"+
			" getItemName('Currency', BC.BusinessCurrency)  as  BusinessCurrencyname,"+
			" BC.BusinessSum as BusinessSum,"+
			" BC.Balance as Balance,"+
			" AC.IndebtSum as IndebtSum,"+
			" AC.Principal as Principal,"+
			" AC.IndebtInterest as IndebtInterest,"+
			" AC.OutdebtInterest as OutdebtInterest,"+
			" AC.OtherInterest  as OtherInterest"+
			" from ASSET_CONTRACT AC,BUSINESS_CONTRACT BC,ASSET_INFO AI" +
			" where AC.SerialNo = AI.SerialNo "+
			" and BC.SerialNo = AC.ContractSerialNo  "+
			" and AI.SerialNo = '"+sSerialNo+"' "+
			" order by AC.ContractSerialNo desc";

	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_CONTRACT";
	
	//设置关键字
	doTemp.setKey("SerialNo,ContractSerialNo",true);	 

	//设置不可见项
	doTemp.setVisible("SerialNo",false);

	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("SerialNo,ContractSerialNo,AssetName","style={width:100px} ");  
	doTemp.setHTMLStyle("IndebtSum,Principal,IndebtInterest,IndebtInterest,OutdebtInterest,OtherInterest,BusinessCurrencyname,AssetNo","style={width:80px} ");  
	
	//设置对齐方式
	doTemp.setAlign("IndebtSum,Principal,IndebtInterest,OutdebtInterest,,BusinessSum,Balance,OtherInterest","3");
	doTemp.setType("IndebtSum,Principal,IndebtInterest,OutdebtInterest,,BusinessSum,Balance,OtherInterest","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("IndebtSum,Principal,IndebtInterest,OutdebtInterest,,BusinessSum,Balance,OtherInterest","2");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页

	//定义后续事件
	
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
		{"true","","Button","引入","引入一条合同信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","合同详情","察看合同详情","my_Contract()",sResourcesPath}	,
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		var sRelativeContractNo = "";	
		//获取抵债资产关联的合同流水号	
		var sContractInfo = setObjectValue("SelectRelativeContract","","@RelativeContract@0",0,0,"");
		if(typeof(sContractInfo) != "undefined" && sContractInfo != "" && sContractInfo != "_NONE_" 
		&& sContractInfo != "_CLEAR_" && sContractInfo != "_CANCEL_")  
		{
			sContractInfo = sContractInfo.split('@');
			sRelativeContractNo = sContractInfo[0];
		}		
		if(sRelativeContractNo == "" || typeof(sRelativeContractNo) == "undefined") return;
		{	
			sSerialNo = "<%=sSerialNo%>";			
			popComp("PDARelativeContractInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeContractInfo.jsp","ContractSerialNo="+sRelativeContractNo+"~SerialNo="+sSerialNo);
			reloadSelf();
		}
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		if (typeof(sContractSerialNo) == "undefined" || sContractSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{				
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");  
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sContractSerialNo) == "undefined" || sContractSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！	
			return;		
		}
		
		popComp("PDARelativeContractInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeContractInfo.jsp","ContractSerialNo="+sContractSerialNo+"~SerialNo="+sSerialNo);
	}	
	
	/*~[Describe=查看合同详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_Contract()
	{  
		//获得合同流水号
		var sContractNo = getItemValue(0,getRow(),"ContractSerialNo");  //合同流水号或对象编号
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		sObjectType = "AfterLoan";
		sObjectNo = sContractNo;				
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
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

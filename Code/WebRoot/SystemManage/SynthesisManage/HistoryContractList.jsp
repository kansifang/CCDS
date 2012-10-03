<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hlzhang 2011/10/28
		Tester:
		Describe: 合同历史记录
		Input Param:
				ObjectType：对象类型（BusinessContract）
				ObjectNo: 合同流水号
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "历史合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	//获得组件参数：对象类型、对象编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"BCSerialNo","修改流水号"},
							{"SerialNo","合同流水号"},
							{"CustomerID","客户编号"},
							{"CustomerName","客户名称"},
							{"BusinessType","业务品种"},
							{"BusinessTypeName","业务品种"},
							{"ArtificialNo","文本合同编号"},
							{"CustomerName","客户名称"},
							{"SerialNo","合同流水号"},
							{"OccurTypeName","发生类型"},
							{"Currency","币种"},
							{"BusinessSum","合同金额(元)"},
							{"RelativeSum","已出账金额(元)"},
							{"Balance","余额(元)"},
							{"VouchTypeName","主要担保方式"},
							{"PutOutDate","起始日期"},
							{"Maturity","到期日期"},
							{"ManageOrgName","经办机构"},
							{"UpdateOrgName","更新机构"},
							{"UpdateUserName","更新人员"},
						  };

	sSql =	" select BCSerialNo,SerialNo,CustomerID,CustomerName,InterestBalance1,InterestBalance2,"+
			" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
			" ArtificialNo,BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
			" BusinessSum,Balance,OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
			" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,PutOutDate, "+
			" Maturity,ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,getOrgName(UpdateOrgID) as UpdateOrgName,getUserName(UpdateUserID) as UpdateUserName "+
			" from BUSINESS_CONTRACT_BAK "+
			//" where ManageUserID = '"+CurUser.UserID+"' and SerialNo = '"+sObjectNo+"' "+
			" where SerialNo = '"+sObjectNo+"' "+
			" Order by BCSerialNo Desc ";
	
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头,更新表名,键值,
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT_BAK";
    //设置关键字
	doTemp.setKey("BCSerialNo",true);
	//设置不可见项
    doTemp.setVisible("InterestBalance1,InterestBalance2,BusinessType,ArtificialNo,BusinessCurrency",false);
    doTemp.setVisible("OccurType,VouchType,ManageOrgID",false);
   	//设置对齐方式
    //doTemp.setAlign("BusinessSum,Balance","3");
    //设置字段类型
    //doTemp.setCheckFormat("BusinessSum,Balance","2");	
	//设置字段类型以上两句等于这一句
	doTemp.setType("BusinessSum,Balance","Number");

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	//设置setEvent
	//dwTemp.setEvent("AfterDelete","!DocumentManage.DelDocRelative(#DocNo)");

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
			{"true","","Button","详情","查看担保信息详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","返回","返回列表信息","closeSelf()",sResourcesPath} 
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=按钮函数;]~*/%>
	<script language=javascript>
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sBCSerialNo   = getItemValue(0,getRow(),"BCSerialNo");
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBCBusinessType = getItemValue(0,getRow(),"BusinessType");
		
		if(typeof(sBCBusinessType) == "undefined" || sBCBusinessType.length == 0 || sBCBusinessType == "" )
		{
			sBCBusinessType = "1010010";
		}
		
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/SystemManage/SynthesisManage/HistoryContractInfo.jsp?BCSerialNo="+sBCSerialNo+"&ObjectType=BusinessContract&ObjectNo="+sSerialNo, "_self","");
		}
	}
	
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=关闭;InputParam=无;OutPutParam=无;]~*/
	function closeSelf()
	{
		self.close();  //关闭当前页面

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
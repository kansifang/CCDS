<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: wangdw 2012-08-01
		Tester:
		Describe: 根据出账流水号查询该笔业务下所有抵质押物;
		Input Param:
			CustomerID：当前出账流水号
		Output Param:
			ObjectType: 对象类型。
			ObjectNo: 对象编号。
			BackType: 返回方式类型(Blank)

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "该笔业务下抵质押物列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"GUARANTYID","抵质押物编号"},
							{"GUARANTYSTATUS","抵质押物状态"},
							{"SENDFLAG","发送标志"},
							{"GuarantyType","抵质押物类型"},
						  };

	//取得资金关联方客户名称CustomerID列表
	//select RelativeID from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and (RelationShip like '52%' or RelationShip like '02%')
	String sSql =  " select GUARANTYID,GuarantyType,GUARANTYSTATUS,SENDFLAG from GUARANTY_INFO where GUARANTYID in (select GUARANTYID "+
			"from GUARANTY_RELATIVE where objectno=(select CONTRACTSERIALNO  from BUSINESS_PUTOUT where serialno='"+sObjectNo+"') )";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("GUARANTYSTATUS","GuarantyStatus");
	doTemp.setDDDWCode("GuarantyType","GuarantyList");
	doTemp.setDDDWCode("SENDFLAG","GISendFlag");
	//设置不可见项
	//doTemp.setVisible("CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,OperateOrgID",false);
	//doTemp.setUpdateable("",false);
	//doTemp.setAlign("BusinessSum,Balance","3");
	//doTemp.setCheckFormat("BusinessSum,Balance","2");
	//doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency,VouchTypeName","2");
	//设置html格式
	//doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	//doTemp.setHTMLStyle("ArtificialNo"," style={width:180px} ");
	//doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10);
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
		{"true","","Button","详情","查看未结清授信业务详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","获取抵质押物状态","获取抵质押物状态","getGuarantyState()",sResourcesPath},
		{"true","","Button","打印出入库凭证","打印抵质押物出入库凭证","printLoadGuaranty()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
//从核心获取抵质押物状态
	function getGuarantyState()
	{
		sGuarantyID = getItemValue(0,getRow(),"GUARANTYID");
		sTradeType = "777120";	
        sObjectNo = sGuarantyID;
        sObjectType = "GuarantyInfoQuery";
        sGuarantyStatus = "";
		if (typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else{
				alert("查询成功["+sReturn[1]+"]");
				//sReturn[1]：1 在库，2 出库
				if(sReturn[1]=="1")
				{
					sGuarantyStatus = "02";//入库
				}else if(sReturn[1]=="2"){
					sGuarantyStatus = "04";//出库
				}
				RunMethod("PublicMethod","UpdateColValue","String@GuarantyStatus@sGuarantyStatus,GUARANTY_INFO,String@GUARANTYID@"+sGuarantyID);
		}
		reloadSelf();
	}	
//抵质押物详情
	function viewAndEdit()
	{
		sGuarantyID = getItemValue(0,getRow(),"GUARANTYID");
		sPawnType = getItemValue(0,getRow(),"GuarantyType");
		sGuarantyStatus = getItemValue(0,getRow(),"GUARANTYSTATUS");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			OpenPage("/CreditManage/GuarantyManage/PawnInfo.jsp?GuarantyStatus="+sGuarantyStatus+"&GuarantyID="+sGuarantyID+"&PawnType="+sPawnType,"_self");
		}
	}
	
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	/*~[Describe=金额汇总;InputParam=无;OutPutParam=无;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
	}	
	/*~[Describe=打印抵质押物出入库凭证;InputParam=无;OutPutParam=无;]~*/
	function printLoadGuaranty()
	{
		sGuarantyID = getItemValue(0,getRow(),"GUARANTYID");
		sGUARANTYSTATUS = getItemValue(0,getRow(),"GUARANTYSTATUS");
		sSENDFLAG = getItemValue(0,getRow(),"SENDFLAG");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			//如果抵质押物状态为"入库"且发送标志位"入库发送"
			if(sGUARANTYSTATUS == "02" && sSENDFLAG == "01")
				{
					PopComp("LoadPawnSheet","/CreditManage/GuarantyManage/LoadPawnSheet1.jsp","GuarantyID="+sGuarantyID+"&Churuku=入库","dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no");
				}
			else
				{
					alert("抵质押物未入库，不能打印凭证");					
				}
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

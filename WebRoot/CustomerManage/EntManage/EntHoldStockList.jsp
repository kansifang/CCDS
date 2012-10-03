<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: XWu 2004-11-29
*	Tester:
*	Describe: 客户持有股票信息列表;
*	Input Param:
*		CustomerID：客户编号
*	Output Param:     
*        CustomerID：--当前客户编号
*		 SerialNo:	--具体信息流水号
*		 EditRight:--权限代码（01：查看权；02：维护权）
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "持有股票信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sEditRight;

	//获得页面参数

	//获得组件参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {	
							{"SerialNo","信息流水号"},				
							{"CertificateType","股东代码证类型"},
							{"UpToDate","账务截至日期"},  
							{"CertificateNo","股票代码"},
							{"StockName","股票名称"},
							{"StockType","股票类型"},
							{"StockAmount","股票数量"},
							{"StockCurrency","股票币种"},
							{"MarketValue","股票市值"},
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记日期"},
							{"UpdateDate","更新日期"},
							{"Remark","备注"}
						};

	String sSql = " Select SerialNo, " +
				" CertificateType, " +
				" UpToDate, " +
				" CertificateNo, " +
				" StockName, " +
				" getItemName('StockType',StockType) as StockType, " +
				" StockAmount, " +
				" getItemName('Currency',StockCurrency) as StockCurrency, " +
				" MarketValue, " +				
				" InputOrgID,getOrgName(InputOrgID) as InputOrgName, " +
				" InputUserID,getUserName(InputUserID) as InputUserName, " +
				" InputDate, " +
				" UpdateDate, " +
				" Remark " +
				" from CUSTOMER_STOCK " +
				" Where CustomerID = '"+sCustomerID+"'";	  

	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,CertificateType,InputUserID,InputOrgID,Remark,UpdateDate",false);
	doTemp.UpdateTable = "CUSTOMER_STOCK";

	doTemp.setType("MarketValue,StockAmount","Number");
	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("MarketValue","2");
	doTemp.setCheckFormat("StockAmount","5");
	
	doTemp.setAlign("CertificateType,CertificateNo,StockName,StockType,UpToDate,InputDate,UpdateDate,StockType,StockCurrency","2");
	doTemp.setHTMLStyle("CertificateNo,CertificateType,StockCurrency,StockType,StockName"," style={width:80px} ");
	doTemp.setHTMLStyle("StockName"," style={width:300px} ");
	doTemp.setHTMLStyle("UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate"," style={width:80px} ");
	doTemp.setCheckFormat("UpdateDate,InputDate","3");
    doTemp.setHTMLStyle("InputOrgName","style={width:200px}"); 	
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
		{"true","","Button","新增","新增客户持有股票信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看客户持有股票详细信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除客户持有股票信息","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntHoldStockInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserID");  
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{	
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}
		}else alert(getHtmlMessage('3'));
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
	 	sUserID=getItemValue(0,getRow(),"InputUserID");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/CustomerManage/EntManage/EntHoldStockInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight,"_self","");
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

<%@include file="/IncludeEnd.jsp"%>

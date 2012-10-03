<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zrli
		Tester:
		Describe: 提示贷后检查列表
		Input Param:
			InspectType：  报告类型 
				010     贷款用途检查报告
	            010010  未完成
	            010020  已完成
	            020     贷后检查报告
	            020010  未完成
	            020020  已完成
		Output Param:
			SerialNo:流水号
			ObjectType:对象类型
			ObjectNo：对象编号
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷后检查列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得组件参数
	String sInspectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InspectType"));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	ASDataObject doTemp = null;
  	//首次检查报告列表
  	if(sInspectType.equals("010010"))
  	{
	  	String sHeaders1[][] = {
								{"SerialNo","合同流水号"},
								{"CustomerName","客户名称"},
								{"BusinessTypeName","业务品种"},								
								{"Currency","币种"},
								{"BusinessSum","合同金额"},
								{"Balance","合同余额"},
								};

	  	String sSql1 =  " select SerialNo,getBusinessName(BusinessType) as BusinessTypeName,CustomerID,"+
					  	"CustomerName,nvl(BusinessSum,0) as BusinessSum,nvl(Balance,0) as Balance,BusinessType  "+
					  	"from BUSINESS_CONTRACT  "+
					  	"where not exists (select ObjectNo from Inspect_Info Where ObjectType='BusinessContract'  "+
					  	"and InspectType like '010%' and ObjectNo=BUSINESS_CONTRACT.SerialNo) "+
					  	"and (OccurType != '020' or OccurType is null) "+
					  	"and ActualPutOutSum > 0 and ManageUserID = '"+CurUser.UserID+"' and (FinishDate is null or FinishDate = '')  ";
		//由SQL语句生成窗体对象。
		doTemp = new ASDataObject(sSql1);
		//设置可更新的表
		doTemp.UpdateTable = "BUSINESS_CONTRACT";
		//设置关键字
		doTemp.setKey("SerialNo",true);
		doTemp.setHeader(sHeaders1);
		//设置不可见项
		doTemp.setVisible("BusinessType,CustomerID",false);
		doTemp.setAlign("BusinessSum,Balance","3");
		doTemp.setType("BusinessSum,Balance","Number");
		doTemp.setCheckFormat("BusinessSum,Balance","2");
		
		doTemp.setColumnAttribute("SerialNo,CustomerName,BusinessSum","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	  	//设置html格式
	  	doTemp.setHTMLStyle("SerialNo,CustomerName,BusinessTypeName"," style={width:120px} ");
 	}
  	//贷后检查报告列表
  	else if(sInspectType.equals("020010") || sInspectType.equals("020020"))
  	{
    	String sHeaders2[][] = {
								{"CustomerName","客户名称"},
								{"CertTypeName","证件类型"},
								{"CertID","证件编号"},
								{"LoanCardNo","贷款卡号"}
							  };

	  	String sSql2 =  " select CustomerID,CustomerName,CertID,getItemName('CertType',CertType) as CertTypeName,LoanCardNo "+
					  	" from CUSTOMER_INFO CI   where CustomerID in (select customerID from CHECK_Frequency where "+
					  	"(FinishFrequencyDate is not null and FinishFrequencyDate<>'') and ((CheckTime is null or CheckTime ='') "+
					  	"or( NextCheckTime is not null and NextCheckTime <>'' and  NextCheckTime<='"+StringFunction.getToday()+"'  ))"+
					  	" and CheckFrequency <>'0' ) and (CustomerType like '01%' or CustomerType like '03%') "+
					  	" and CustomerID in(Select CustomerID from Customer_Belong where BelongAttribute='1' and UserID='"+CurUser.UserID+"')";

		//由SQL语句生成窗体对象。
		doTemp = new ASDataObject(sSql2);
		//设置可更新的表
		doTemp.UpdateTable = "CUSTOMER_INFO";
		//设置关键字
		doTemp.setKey("CustomerID",true);
		doTemp.setHeader(sHeaders2);
		//设置不可见项
		doTemp.setVisible("CustomerID",false);
		
		//设置html格式
		doTemp.setHTMLStyle("CustomerName"," style={width:250px} ");
		
		doTemp.setColumnAttribute("CustomerName,CertID","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

  	}
  	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
  	dwTemp.Style="1";      //设置为Grid风格
  	dwTemp.ReadOnly = "1"; //设置为只读
  
  
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
		{"true","","Button","客户基本信息","查看客户基本信息","viewCustomer()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
 
    /*~[Describe=查看客户详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomer()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			openObject("Customer",sCustomerID,"001");
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
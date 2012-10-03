<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-12-9
		Tester:
		Describe: 被此担保合同担保的业务合同列表;
		Input Param:
			SerialNo: 担保合同编号
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "业务合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	//获得页面参数

	//获得组件参数：担保合同编号
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","合同编号"},
							{"CustomerName","客户名称"},							
							{"BusinessTypeName","业务品种"},
							{"Currency","币种"},
							{"BusinessSum","合同金额"},
							{"Balance","合同余额"},
							{"OverdueBalance","逾期/垫款金额"},
							{"FineBalance1","本金罚息"},
							{"FineBalance2","利息罚息"},
							{"BusinessRate","利率(‰)"},
							{"PdgRatio","费率(‰)"},
							{"PutOutDate","起始日期"},
							{"Maturity","到期日期"},
							{"VouchTypeName","担保方式"},	
							{"ManageUserName","管户客户经理"},
							{"ManageOrgName","管户机构"}
						  };

	
	sSql =  " select BC.SerialNo,BC.CustomerName, "+
			" getBusinessName(BC.BusinessType) as BusinessTypeName, "+
			" getItemName('Currency',BC.BusinessCurrency) as Currency, "+
			" BC.BusinessSum,BC.Balance,BC.OverdueBalance,BC.FineBalance1, "+
			" BC.FineBalance2,BC.BusinessRate,BC.PdgRatio,BC.PutOutDate,BC.Maturity, "+
			" getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
			" getOrgName(BC.ManageOrgID) as ManageOrgName,"+
			" getUserName(BC.ManageUserID) as ManageUserName "+			
			" from CONTRACT_RELATIVE CR, BUSINESS_CONTRACT BC "+
			" where CR.SerialNo = BC.SerialNo "+
			" and CR.ObjectNo='"+sSerialNo+"' "+
			" and CR.ObjectType='GuarantyContract' ";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("SerialNo",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance,OverdueBalance,FineBalance1,FineBalance2","3");
	doTemp.setCheckFormat("BusinessSum,Balance,OverdueBalance,FineBalance1,FineBalance2","2");
	doTemp.setHTMLStyle("CustomerName,VouchTypeName"," style={width:200px} ");

	//生成datawindow
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
		{"true","","Button","详情","查看合同详情","viewAndEdit()",sResourcesPath},
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
			OpenComp("CreditTab","/CreditManage/CreditApply/ObjectTab.jsp","ObjectType=AfterLoan&ObjectNo="+sSerialNo+"&ViewID=002","_blank",OpenStyle);
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zwhu 2009-08-30
		Tester:
		Describe: 流水台帐列表;
		Input Param:

		Output Param:
			
		HistoryLog:

	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "流水台帐列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";

	//获得页面参数
	
	//获得组件参数
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sLineID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("LineID"));
	
	if(sObjectNo == null) sObjectNo = "";
	if(sLineID == null) sLineID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义表头文件
	String sHeaders[][] = { 
							{"LineID","额度编号"},
							{"ClTypeName","额度类型名称"},		
							{"ApplySerialNo","授信申请流水号"},					
							{"ApproveSerialNo","额度批复号"},
							{"BCSerialNo","授信合同号"},
							{"CustomerName","客户名称"},
							{"BusinessType","业务品种"},
							{"BusinessTypeName","业务品种"},
							{"CurrencyName","币种"},
							{"LineSum1","金额"},
							{"FreezeFlag","状态"},										
							{"FreezeFlagName","状态"},										
							{"LineEffDate","使用日期"},
							{"PutOutDeadLine","截止日期"},										
							{"InputUser","经办人"},
							{"InputOrg","经办机构"}
							}; 
	sSql =	" select LineID,ClTypeName,ApplySerialNo,ApproveSerialNo,BusinessType,getBusinessName(BusinessType) as BusinessTypeName , "+ 
			" BCSerialNo,CustomerName,getItemName('Currency',Currency) as CurrencyName,LineSum1,"+
			" FreezeFlag,getItemName('FreezeFlag',FreezeFlag) as FreezeFlagName, LineEffDate,PutOutDeadLine, "+
			" getUserName(InputUser) as InputUser ,getOrgName(InputOrg) as InputOrg "+
			" from CL_INFO where LineID = '"+sLineID+"'";
	//out.println(sSql);

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID",true);
	doTemp.setVisible("BusinessType,FreezeFlag",false);

    //设置金额为数字形式
    doTemp.setType("LineSum1","Number");
    doTemp.setCheckFormat("LineSum1","2");
	doTemp.setAlign("LineSum1","3");


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置为Grid风格
	dwTemp.Height=100;
	dwTemp.Width=100;
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
//		{"true","","Button","查看详情","查看详情","viewAndEdit()",sResourcesPath},
		};

	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

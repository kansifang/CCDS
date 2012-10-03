<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zwhu 2009/08/31
		Tester:
		Describe: 	合同变更基本信息
		Input Param:
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同变更基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo = "ContractModifyInfo";
	//获得组件参数，客户代码
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo="";
	String sAfaloanFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AfaloanFlag"));
	if(sAfaloanFlag == null) sAfaloanFlag="";
	String sPaycyc2 = " ";
	String sPaycyc1 = "",sBankAccount1 = "";
	String sPaycyc1Name = "";
	String sMaturity1 ="";
	String sRateFloat1 = "";
	String sFineRate1 = "";
	String sWarrantor1 = "";
	String sDisCountInfo1 = "";
	String sPurpose1 = "";
	String sBusinessType = "";
	double dBalance1 = 0.00;
	String sSql= " select Paycyc2 from CONTRACT_MODIFY where SerialNo = '"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sPaycyc2 = rs.getString(1);
		if(sPaycyc2 == null) sPaycyc2 = "";
	}
	rs.getStatement().close();
	if("".equals(sPaycyc2)){
		sSql = " select BC.CorPusPayMethod,getItemName('CorpusPayMethod2',BC.CorPusPayMethod) as PaycycName,BC.Maturity,BC.RateFloat,BC.FineRate,"+
					  " BC.Warrantor ,BC.DisCountinterest,BC.Purpose,nvl(BC.Balance,0),BC.AccountNo,BC.BusinessType "+
		              " from CONTRACT_MODIFY CM,BUSINESS_CONTRACT BC "+
		              " where CM.SerialNo = '"+sSerialNo+ "' and BC.SerialNo = CM.RelativeNo";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sPaycyc1 = rs.getString(1);
			if(sPaycyc1 == null) sPaycyc1 = "";
			sPaycyc1Name = rs.getString(2);
			if(sPaycyc1Name == null) sPaycyc1Name = "";	
			sMaturity1 = rs.getString(3);
			if(sMaturity1 == null) sMaturity1 = "";
			sRateFloat1 = rs.getString(4);
			if(sRateFloat1 == null) sRateFloat1 = "0";
			sFineRate1 = rs.getString(5);
			if(sFineRate1 == null) sFineRate1 = "";
			sWarrantor1 = rs.getString(6);
			if(sWarrantor1 == null) sWarrantor1 = "";
			sDisCountInfo1 = rs.getString(7);
			if(sDisCountInfo1 == null) sDisCountInfo1 = "0";
			sPurpose1 = rs.getString(8);
			if(sPurpose1 == null) sPurpose1 = "";
			dBalance1 = rs.getDouble(9);
			sBankAccount1 = rs.getString(10);
			if(sBankAccount1 == null) sBankAccount1 = "";
			sBusinessType = rs.getString(11);
			if(sBusinessType == null) sBusinessType = "";
		}        
		rs.getStatement().close();
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if("1110027".equals(sBusinessType)||"2110020".equals(sBusinessType))
	{
		doTemp.setReadOnly("ReduceTermMonth,ReturnBalance,RateOfPay",true);
		doTemp.setVisible("ReduceTermFlag,Paycyc3,RateOfPay",true);
		
	}
	if("1110027".equals(sBusinessType))
	{
		doTemp.setReadOnly("ReturnBalance1,RateOfPay1",true);
		doTemp.setVisible("ReturnBalance1,RateOfPay1",true);
	}
	//设置月收入(元)范围
	//doTemp.appendHTMLStyle("MONTHLYWAGES"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"月收入(元)必须大于等于0！\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //--设置DW风格 1:Grid 2:Freeform
	
	if("1110010,1110020,1140060,1140010,1140020,1140110,1110027,1140025,1110025".indexOf(sBusinessType) > -1){
		doTemp.setDDDWSql("Paycyc2","select ItemNo,ItemName from code_library where CodeNo = 'CorpusPayMethod2' and ItemNo in('030','040') order by sortno");
	}
	else{
		doTemp.setDDDWSql("Paycyc2","select ItemNo,ItemName from code_library where CodeNo = 'CorpusPayMethod2' and ItemNo in('010','020','070') order by sortno");
	}
	if("1110027".equals(sBusinessType)||"2110020".equals(sBusinessType))
	{
		String sHTMLTemplate = "<font color=\"#FF0000\">注:该笔贷款为公积金贷款，请点击【获取公积金系统提前还款信息】按钮获取信息!</font><hr color=\"#FFFFFF\" size=\"1\" />";
		sHTMLTemplate += "<tr><td> ${DOCK:PART1} </td></tr>";
		dwTemp.setHarborTemplate(sHTMLTemplate);
		doTemp.setColumnAttribute("","DockOptions","DockID=PART1");
		doTemp.setDDDWSql("ReduceTermFlag","select ItemNo,ItemName from code_library where CodeNo = 'ReduceTermFlag' and IsInuse = '1'");
		doTemp.setDDDWSql("Paycyc3","select ItemNo,ItemName from code_library where CodeNo = 'Paycyc3' and IsInuse = '1'");
	}
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","提前还款试算","提前还款试算","prepayment()",sResourcesPath},
		{"true","","Button","获取公积金系统提前还款信息","获取公积金系统提前还款信息","send()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{	
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=提前还款试算;InputParam=提前还款试算;OutPutParam=无;]~*/
	function prepayment(sPostEvents)
	{	
		
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//流水号
		sObjectNo = sSerialNo;
		sObjectType = "BusinessContract";
		sTradeType = "6004";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else{
			alert("发送个贷成功！"+sReturn[1]);
			//print();
			//reloadSelf();
		}
		return;
	
	}
	
	/*~[Describe=发送个贷;InputParam=发送个贷;OutPutParam=无;]~*/
	function send()
	{
		sSerialNo = getItemValue(0,getRow(),"RelativeNo");//流水号
		sObjectNo = sSerialNo;
		sObjectType = "BusinessContract";
		sTradeType = "6025";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
		sReturnValue=sReturn.split("@");
		if(sReturnValue[0] != "0000000"){
			alert("个贷系统提示："+sReturnValue[1]+",错误编号["+sReturnValue[0]+"]");//如果失败抛错出来错
			return;
		}else{
			if(sReturnValue[4] == "0")
			{
				setItemValue(0,getRow(),"ReduceTermMonth","0");
			}else if(sReturnValue[4] == "1")
			{
				setItemValue(0,getRow(),"ReduceTermMonth",sReturnValue[5]);//缩减期次
			}
			//alert(sReturnValue[1]+"@"+sReturnValue[2]+"@"+sReturnValue[3]+"@"+sReturnValue[4]+"@"+sReturnValue[5]+"@"+sReturnValue[6]+"@"+sReturnValue[7]+"@"+sReturnValue[8]);
			if("<%=sBusinessType%>"=="1110027")
			{
				setItemValue(0,getRow(),"ReturnBalance",sReturnValue[3]);//提前还款金额
				setItemValue(0,getRow(),"RateOfPay",sReturnValue[6]);//应还利息
				setItemValue(0,getRow(),"ReduceTermFlag",sReturnValue[4]);//是否缩期
				setItemValue(0,0,"Paycyc3",sReturnValue[2]);//提前还款方式
				setItemValue(0,getRow(),"ReturnBalance1",sReturnValue[7]);//公积金提前还款金额
				setItemValue(0,getRow(),"RateOfPay1",sReturnValue[8]);//委托应还利息
			}else{
				setItemValue(0,getRow(),"ReturnBalance",sReturnValue[7]);//提前还款金额
				setItemValue(0,getRow(),"RateOfPay",sReturnValue[8]);//应还利息
				setItemValue(0,getRow(),"ReduceTermFlag",sReturnValue[4]);//是否缩期
				setItemValue(0,0,"Paycyc3",sReturnValue[2]);//提前还款方式
			}
		}
	}
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
	
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
		if("<%=sPaycyc2%>"==""){
			setItemValue(0,0,"Paycyc1","<%=sPaycyc1%>");
			setItemValue(0,0,"Paycyc1Name","<%=sPaycyc1Name%>");	
			setItemValue(0,0,"Maturity1","<%=sMaturity1%>");
			setItemValue(0,0,"RateFloat1","<%=DataConvert.toDouble(sRateFloat1)%>");
			setItemValue(0,0,"FineRate1","<%=sFineRate1%>");			
			setItemValue(0,0,"DisCountInfo1","<%=DataConvert.toDouble(sDisCountInfo1)%>");	
			setItemValue(0,0,"Warrantor1","<%=sWarrantor1%>");
			setItemValue(0,0,"Purpose1","<%=sPurpose1%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Balance1","<%=DataConvert.toMoney(dBalance1)%>");
			setItemValue(0,0,"BankAccount1","<%=sBankAccount1%>");						
		}    
    }
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

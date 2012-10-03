<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2006/03/31
		Tester:
		Content: 额度分配基本信息页面
		Input Param:
			ParentLineID：额度编号
			LineID：额度分配编号
		Output param:
		History Log: lpzhang 2009-8-26 重检页面

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "额度分配基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数

	//获得页面参数	
	String sParentLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentLineID"));
	String sSubLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubLineID"));
	String sBusinessType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessType"));
	String sCLBusinessType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CLBusinessType"));//额度分配业务品种
	if(sParentLineID == null) sParentLineID = "";
	if(sSubLineID == null) sSubLineID = "";
	if(sBusinessType == null) sBusinessType = "";
	if(sCLBusinessType == null) sCLBusinessType = "";
	ASResultSet rs= null;
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%		
	String sSql="";
	//根据额度编号获取客户编号和客户名称,申请流水号、最终审批意见流水号、合同流水号、额度类型和额度名称
	String sCustomerID = "",sCustomerName = "";
	String sApplySerialNo = "",sApproveSerialNo = "",sContractSerialNo = "",sCLTypeID = "",sCLTypeName = "";
	
	sSql = 	" select CustomerID,CustomerName,ApplySerialNo,ApproveSerialNo,BCSerialNo,CLTypeID,CLTypeName "+
			" from CL_INFO where "+
			" LineID = '"+sParentLineID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sApplySerialNo = rs.getString("ApplySerialNo");
		sApproveSerialNo = rs.getString("ApproveSerialNo");
		sContractSerialNo = rs.getString("BCSerialNo");
		sCLTypeID = rs.getString("CLTypeID");
		sCLTypeName = rs.getString("CLTypeName");
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
		//将空值转化为空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sApplySerialNo == null) sApplySerialNo = "";
		if(sApproveSerialNo == null) sApproveSerialNo = "";
		if(sContractSerialNo == null) sContractSerialNo = "";
		if(sCLTypeID == null) sCLTypeID = "";
		if(sCLTypeName == null) sCLTypeName = "";
	}
	rs.getStatement().close();
	
	String sSmallEntFlag = Sqlca.getString("Select SmallEntFlag from ENT_INFO where CustomerID = '"+sCustomerID+"'");
	if(sSmallEntFlag == null) sSmallEntFlag = "";
	//设置显示标题				
	String[][] sHeaders = {					
					{"CustomerID","客户编号"},
					{"CustomerName","客户名称"},
					{"BusinessTypeName","业务品种"},
					{"Rotative","是否循环"},
					{"TermMonth","期限(月)"},
					{"Currency","币种"},
					{"BailRatio","保证金比例"},		
					{"LineSum1","最高额度金额"},
					{"LineSum2","敞口限额"},
					{"InputOrgName","登记机构"},
					{"InputUserName","登记人"},
					{"InputTime","登记日期"},
					{"UpdateTime","更新日期"}	,	
					{"RateFloatCondition","利率浮动说明"},	
					{"PdgRatioCondition","费率要求"},	
					{"Purpose","用途"},	
					{"DirectionName","行业投向"},	
					{"GetSource","提款方式及说明"},	
					{"PaySource","还款方式及说明"},
					{"BaseRateType","基准利率类型"},
					{"BaseRate","基准年利率(%)"},
					{"RateFloatType","浮动类型"},
					{"RateFloat","利率浮动值"},
					{"BusinessRate","执行月利率(‰)"},
					{"PdgRatio","手续费率‰"},
					{"PdgPayMethod","手续费支付方式"},
					{"PdgSum","手续费金额"},
					};
	
	 sSql = 	" select ParentLineID,LineID,CustomerID,CustomerName,BusinessType, "+
				" getBusinessName(BusinessType) as BusinessTypeName,Currency,"+
				" LineSum1,LineSum2,TermMonth,"+
				" BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate,BailRatio,Rotative, "+
				" PdgRatio,PdgPayMethod,PdgSum,"+
				" RateFloatCondition,PdgRatioCondition,Purpose,Direction,getItemName('IndustryType',Direction) as DirectionName,"+
				" GetSource,PaySource,"+
				" GetOrgName(InputOrg) as InputOrgName,InputOrg,InputUser,GetUserName(InputUser) as InputUserName,InputTime, "+
				" UpdateTime,CLTypeID,CLTypeName,ApplySerialNo,ApproveSerialNo,BCSerialNo "+
				" from CL_INFO "+
				" Where LineID = '"+sSubLineID+"' "+
				" and ParentLineID = '"+sParentLineID+"' ";	
	 
	if(sBusinessType.equals("3015"))//同业
	 {
		sSql = 	" select ParentLineID,LineID,CustomerID,CustomerName,BusinessType, "+
				" getBusinessName(BusinessType) as BusinessTypeName,Currency,"+
				" InputOrg,InputUser,GetUserName(InputUser) as InputUserName,InputTime, "+
				" UpdateTime,CLTypeID,CLTypeName,ApplySerialNo,ApproveSerialNo,BCSerialNo "+
				" from CL_INFO "+
				" Where LineID = '"+sSubLineID+"' "+
				" and ParentLineID = '"+sParentLineID+"' ";	
	 }else if(sBusinessType.equals("3050") || sBusinessType.equals("3060")) //联保小组，信用共同体
	 {
		 sSql = " select ParentLineID,LineID,CustomerID,CustomerName,MemberID, "+
				" MemberName,Currency,"+
				" LineSum1,LineSum2,TermMonth,Rotative,GetOrgName(InputOrg) as InputOrgName, "+
				" InputOrg,InputUser,GetUserName(InputUser) as InputUserName,InputTime, "+
				" UpdateTime,CLTypeID,CLTypeName,ApplySerialNo,ApproveSerialNo,BCSerialNo "+
				" from CL_INFO "+
				" Where LineID = '"+sSubLineID+"' "+
				" and ParentLineID = '"+sParentLineID+"' ";	
	 }
					
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("Rotative","YesNo");
	
	//设置不可见属性
	doTemp.setVisible("Direction,RateFloatCondition,PdgRatioCondition,ParentLineID,MemberID,LineID,BusinessType,InputUser,LineSum2,InputOrg,CLTypeID,CLTypeName,ApplySerialNo,ApproveSerialNo,BCSerialNo",false);
	//设置只读属性
	doTemp.setReadOnly("BaseRateType,BaseRate,BusinessRate,DirectionName,CustomerID,CustomerName,MemberName,InputUserName,InputOrgName,InputTime,UpdateTime,BusinessTypeName",true);
	//设置必输项
	doTemp.setRequired("PaySource,GetSource,DirectionName,Purpose,BusinessTypeName,Currency,Rotative,LineSum1,TermMonth",true);
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setDDDWCode("BaseRateType","BaseRateType");
	doTemp.setDDDWCode("RateFloatType","RateFloatType");
	doTemp.setDDDWCode("PdgPayMethod","ChargeType");
	if(sBusinessType.equals("3050"))
	{
		doTemp.setHeader("CustomerName","联保小组名称");
		doTemp.setHeader("MemberName","成员名称");
		doTemp.setRequired("MemberName",true);
		doTemp.setRequired("BusinessTypeName",false);
	}
	if(sBusinessType.equals("3060"))
	{
		doTemp.setHeader("CustomerName","信用共同体名称");
		doTemp.setHeader("MemberName","成员名称");
		doTemp.setRequired("MemberName",true);
		doTemp.setRequired("BusinessTypeName",false);
	}
	
	//设置不可更新属性
	doTemp.setUpdateable("InputUserName,InputOrgName,BusinessTypeName,DirectionName",false);
	doTemp.setHTMLStyle("CustomerName"," style={width:200px;} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");
	doTemp.setHTMLStyle("RateFloatCondition"," style={height:100px;width:400px} ");
	doTemp.setHTMLStyle("PdgRatioCondition","style={height:100px;width:400px}");
	doTemp.setHTMLStyle("Purpose","style={height:100px;width:400px}");
	doTemp.setHTMLStyle("GetSource","style={height:100px;width:400px}");
	doTemp.setHTMLStyle("PaySource","style={height:100px;width:400px}");
	//设置格式
	doTemp.setType("PdgSum,PdgRatio,RateFloat,BaseRate,BusinessRate,LineSum1,LineSum2,BailRatio,TermMonth","Number");
	doTemp.setCheckFormat("TermMonth","5");
	doTemp.setCheckFormat("BusinessRate,BaseRate","16");
	doTemp.setUnit("BailRatio","%");	
	doTemp.setHTMLStyle("InputUserName,InputTime,UpdateTime"," style={width:80px;} ");
	 if(sBusinessType.equals("3015"))//同业
		doTemp.setUnit("BusinessTypeName","<input type=button value=\"...\" onClick=parent.SelectCode()>");
	else if(sBusinessType.equals("3010")){//公司
		if("1".equals(sSmallEntFlag)){
			doTemp.setUnit("BusinessTypeName","<input type=button value=\"...\" onClick=parent.SelectSMEBusinessType()>");
		}
		else{
			doTemp.setUnit("BusinessTypeName","<input type=button value=\"...\" onClick=parent.SelectEntBusinessType()>");
	 	}
	 	doTemp.setUnit("DirectionName","<input type=button value=\"...\" onClick=parent.getIndustryType()>");
	}else if(sBusinessType.equals("3040"))//个人
	{
		doTemp.setUnit("BusinessTypeName","<input type=button value=\"...\" onClick=parent.SelectIndBusinessType()>");
		doTemp.setUnit("DirectionName","<input type=button value=\"...\" onClick=parent.getIndustryType()>");
	}
	 if(sBusinessType.equals("3050"))//联保
	{
		 doTemp.setUnit("MemberName","<input type=button value=\"...\" onClick=parent.SelectLBMember()>");
	}
	if(sBusinessType.equals("3060"))//信用共同体
	{
		doTemp.setUnit("MemberName","<input type=button value=\"...\" onClick=parent.SelectXYMember()>");
	}
	//针对保函业务手续费金额为可修改
	if(sCLBusinessType.startsWith("2030")||sCLBusinessType.startsWith("2040"))
	{
		doTemp.setReadOnly("PdgSum",false);
	}else{
		doTemp.setReadOnly("PdgSum",true);
	}
	//非表外业务设置保证金比例只读
	if(sCLBusinessType.startsWith("2") ){
		doTemp.setReadOnly("BailRatio",false);
	}else{
		doTemp.setReadOnly("BailRatio",true);
	}
	//根据业务品种设置是否必输项
	if(sCLBusinessType.startsWith("1") || sCLBusinessType.equals("2070") || sCLBusinessType.equals("2110040"))
	{
		doTemp.setRequired("BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate",true);
	}else if(!sCLBusinessType.equals("")){
		doTemp.setRequired("PdgRatio,PdgPayMethod,PdgSum",true);
	}	
	//获取费率
	doTemp.setUnit("PdgSum","<input class=\"inputdate\" value=\"获取值\" type=button onClick=parent.getpdgsum1()>");
	//设置自动获取基准利率
	doTemp.appendHTMLStyle("TermMonth","onBlur=\"javascript:parent.getBaseRateType()\" ");
	//设置获取执行利率
	doTemp.appendHTMLStyle("RateFloatType,RateFloat","onBlur=\"javascript:parent.getBusinessRateInfo()\" ");
	//设置授信限额范围
	doTemp.appendHTMLStyle("LineSum1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"授信限额必须大于等于0！\" ");
	//设置敞口限额范围
	doTemp.appendHTMLStyle("LineSum2"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"敞口限额必须大于等于0！\" ");
	//设置最低保证金比率(%)范围
    doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"最低保证金比率(%)的范围为[0,100]\" ");
    doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
    doTemp.appendHTMLStyle("PdgRatio"," onChange=\"javascript:parent.getpdgsum1()\" ");
    
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置setEvent
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","返回","返回到额度分配列表","goBack()",sResourcesPath}
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
		if(vI_all("myiframe0"))
		{	
			//录入数据有效性检查
			if (!ValidityCheck()) return;
			getBaseRateType();
			if(bIsInsert){
				beforeInsert();
			}
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
			
		}
		
	}
	
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditLine/SubCreditLineList.jsp?ParentLineID=<%=sParentLineID%>","_self","");
	}	
		
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sCurDate = PopPage("/Common/ToolsB/GetDay.jsp","","");		
		setItemValue(0,0,"UpdateTime",sCurDate);
		if("<%=sBusinessType%>"=="3010"||"<%=sBusinessType%>"=="3040")
		{
			sCLBusinessType =  getItemValue(0,0,"BusinessType");
			if(sCLBusinessType.substring(0,4) != "2030" && sCLBusinessType.substring(0,4) != "2040" )//保函
			{
				getpdgsum1();
			}
		}
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{	
		if(CheckSubCreditLine()) return true;
		else return false;
	}
	/*~[Describe=选择行业投向（国标行业类型）;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"Direction");
		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"Direction","");
			setItemValue(0,getRow(),"DirectionName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
			sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
			setItemValue(0,getRow(),"Direction",sIndustryTypeValue);
			setItemValue(0,getRow(),"DirectionName",sIndustryTypeName);				
		}
	}
	
	/*~[Describe=授信限额和敞口限额检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function CheckSubCreditLine()
	{
		sParentLineID = "<%=sParentLineID%>";
		sSubLineID = getItemValue(0,getRow(),"LineID");//表示取当前页面的LineID作为参数传递，不能只取固定值，要去变化的值
		sLineSum1 = getItemValue(0,0,"LineSum1");//取当前值
		sLineSum2 = getItemValue(0,0,"LineSum2");//取当前值
		sBailRatio = getItemValue(0,0,"BailRatio");//取当前值
		sTermMonth = getItemValue(0,0,"TermMonth");//取当前值
		sCurrency = getItemValue(0,0,"Currency");//取当币种
		sBusinessType = getItemValue(0,0,"BusinessType");//取当业务品种
		sMemberID = getItemValue(0,0,"MemberID");//成员ID
		//如果取到授信限额为空时，则自动置位成0.00
		if (typeof(sLineSum1)=="undefined" || sLineSum1.length==0)
		{
			sLineSum1 = 0.00;
			setItemValue(0,0,"LineSum1","0.00");
		}
		//如果取到授信限额为空时，则自动置位成0.00
		if (typeof(sLineSum2)=="undefined" || sLineSum2.length==0)
		{
			sLineSum2 = 0.00;
			setItemValue(0,0,"LineSum2","0.00");	
		}
		//该产品是否已经设置
		iCount = 0;
		sBusinessType1 = "<%=sBusinessType%>";
		if(sBusinessType1=="3050" || sBusinessType1=="3060"){
			iCount = RunMethod("CreditLine","getLineTypeCount1",sMemberID+","+sParentLineID+","+sSubLineID);
			if(iCount>0)
			{
				alert("该客户已经分配额度，不能再进行分配！");
				return false;
			}
		}
		else{
			iCount = RunMethod("CreditLine","getLineTypeCount",sBusinessType+","+sParentLineID+","+sSubLineID);
			if(iCount>0)
			{
				alert("该业务品种已经分配额度，不能再进行分配！");
				return false;
			}
		}	
		sReturn = RunMethod("CreditLine","CheckCreditLine",sParentLineID+","+sSubLineID+","+sLineSum1+","+sLineSum2+","+sTermMonth+","+sCurrency);
		if(sReturn == "10")	
		{
			alert("敞口限额不能大于授信限额，请更正！");
			return false;					
		}
		if(sReturn == "01")	
		{
			alert("授信限额不能超过授信额度总额，请更正！");
			return false;					
		}
		if(sReturn == "11")	
		{
			alert("敞口限额不能大于授信限额，授信限额也不能超过授信额度总额，请更正!");
			return false;					
		}
		if(sReturn == "00")	
		{
			return true;					
		}
		if(sReturn == "12")	
		{
			alert("额度分配期限不能大于总额度期限，请更正!");
			return false;					
		}
		return false;
	}

	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function SelectEntBusinessType(){
		setObjectValue("SelectEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
		CheckSubCL();
	}
	
	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function SelectSMEBusinessType(){
		setObjectValue("SelectSMEBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
		CheckSubCL();
	}	
	
	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function SelectIndBusinessType(){
		setObjectValue("SelectCLIndBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
		CheckSubCL();		
	}
	/*~[Describe=验证额度分配不能重复业务品种分配;InputParam=无;OutPutParam=无;]~*/
	function CheckSubCL(){
		sBusinessType = getItemValue(0,0,"BusinessType");//取当业务品种
		sParentLineID = getItemValue(0,0,"ParentLineID");
		sLineID = getItemValue(0,0,"LineID");
		dReturn = RunMethod("CreditLine","CheckSubCL",sParentLineID+","+sBusinessType+","+sLineID);
		if(dReturn>0){
			alert("该业务品种已经分配额度，请重新选择业务品种！");
			setItemValue(0,0,"BusinessType","");
			setItemValue(0,0,"BusinessTypeName","");
		}
		if("<%=sBusinessType%>" == "3040"){
			dReturn = RunMethod("CreditLine","CheckSubCL1",sParentLineID+","+sBusinessType+","+sLineID);
			if(dReturn>0){
				sBusinessTypeName = getItemValue(0,0,"BusinessTypeName");//取当业务品种
				alert("该个人综授已分配了"+sBusinessTypeName+"不能分配给其他业务品种！");
				setItemValue(0,0,"BusinessType","");
				setItemValue(0,0,"BusinessTypeName","");
			}
		}
		if("<%=sBusinessType%>" == "3010"){
			dReturn = RunMethod("CreditLine","CheckSubCL",sParentLineID+","+sBusinessType+","+sLineID);
			sBusinessType = getItemValue(0,0,"BusinessType");
			//if("2010" == sBusinessType ||"2050030" == sBusinessType ){
			if(sBusinessType.substring(0,1)=="2" ){
				setItemRequired(0,0,"BailRatio",true);
	    	    getASObject(0,0,"BailRatio").style.background ="#ffffff";	
	    	    getASObject(0,0,"BailRatio").removeAttribute("readOnly");
			}else{
				setItemRequired(0,0,"BailRatio",false);
				getASObject(0,0,"BailRatio").style.background ="#efefef";
				getASObject(0,0,"BailRatio").setAttribute("readOnly","true");
				setItemValue(0,0,"BailRatio","");
			}
			if(sBusinessType.substring(0,4)=="2030" || sBusinessType.substring(0,4)=="2040"){
	    	    getASObject(0,0,"PdgSum").style.background ="#ffffff";
	    	    getASObject(0,0,"PdgSum").removeAttribute("readOnly");
			}else{
				getASObject(0,0,"PdgSum").style.background ="#efefef";
				getASObject(0,0,"PdgSum").setAttribute("readOnly","true");
				setItemValue(0,0,"PdgSum","");
			}
			//表内要求输入和委托贷款要求输入利率相关信息,表外要求输入费率手续费信息
			if(sBusinessType.substring(0,1)=="1" || "2070" == sBusinessType || "2110040" == sBusinessType)
			{
				setItemRequired(0,0,"BaseRateType",true);
				setItemRequired(0,0,"BaseRate",true);
				setItemRequired(0,0,"RateFloatType",true);
				setItemRequired(0,0,"RateFloat",true);
				setItemRequired(0,0,"BusinessRate",true);
	    	    setItemRequired(0,0,"PdgRatio",false);
	    	    setItemRequired(0,0,"PdgPayMethod",false);
	    	    setItemRequired(0,0,"PdgSum",false);
				setItemValue(0,0,"PdgRatio","");
				setItemValue(0,0,"PdgPayMethod","");
				setItemValue(0,0,"PdgSum","");
			}else{
			 	setItemRequired(0,0,"PdgRatio",true);
	    	    setItemRequired(0,0,"PdgPayMethod",true);
	    	    setItemRequired(0,0,"PdgSum",true);
				setItemRequired(0,0,"BaseRateType",false);
				setItemRequired(0,0,"BaseRate",false);
				setItemRequired(0,0,"RateFloatType",false);
				setItemRequired(0,0,"RateFloat",false);
				setItemRequired(0,0,"BusinessRate",false);
				setItemValue(0,0,"BaseRateType","");
				setItemValue(0,0,"BaseRate","");
				setItemValue(0,0,"RateFloatType","");
				setItemValue(0,0,"RateFloat","");
				setItemValue(0,0,"BusinessRate","");
			}
		}
	}	
	/*~[Describe=弹出联保成员选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function SelectLBMember(){
		sCustomerID = getItemValue(0,0,"CustomerID");
		sParaString = "CustomerID"+","+sCustomerID;
		setObjectValue("SelectLBMember",sParaString,"@MemberID@0@MemberName@1",0,0,"");
		
	}
	/*~[Describe=弹出信用共同体选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function SelectXYMember(){
		sCustomerID = getItemValue(0,0,"CustomerID");
		sParaString = "CustomerID"+","+sCustomerID;
		setObjectValue("SelectXYMember",sParaString,"@MemberID@0@MemberName@1",0,0,"");
		
	}
	/*~[Describe=弹出同业客户业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function SelectCode(){
		setObjectValue("SelectCode","CodeNo,BusinessTypeTY","@BusinessType@0@BusinessTypeName@1",0,0,"");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ParentLineID","<%=sParentLineID%>");	
			setItemValue(0,0,"ApplySerialNo","<%=sApplySerialNo%>");
			setItemValue(0,0,"ApproveSerialNo","<%=sApproveSerialNo%>");
			setItemValue(0,0,"BCSerialNo","<%=sContractSerialNo%>");			
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");	
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"CLTypeID","<%=sCLTypeID%>");	
			setItemValue(0,0,"CLTypeName","<%=sCLTypeName%>");									
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Rotative","2");
			setItemValue(0,0,"Currency","01");
			bIsInsert = true;	
			if("<%=sBusinessType%>" == "3040"){
				setItemValue(0,0,"Rotative","1");
			}		
		}	
		
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CL_INFO";//表名
		var sColumnName = "LineID";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	//取得基准年利率
	function selectBaseRateType(){
		sCurDate = "<%=StringFunction.getToday()%>"
		sParaString = "CurDate"+","+sCurDate;
	    sReturn = setObjectValue("selectBaseRateType",sParaString,"@BaseRateType@0@BaseRate@1",0,0,"");
		getBusinessRate("M");
	}
	//自动获取利率类型 2009-12-24 
	function getBaseRateType(){
		 var sBusinessType = <%=sBusinessType%>
		 dTermDay = getItemValue(0,getRow(),"TermDay");
		 dTermMonth = getItemValue(0,getRow(),"TermMonth");
		 sBusinessCurrency = getItemValue(0,getRow(),"Currency");//币种
		 sBaseRateID = "";
		 if(sBusinessCurrency=="01"){//人民币
			 if(dTermMonth <= 6){
			 	sBaseRateID = "10010";
			 }else if(dTermMonth > 6 && dTermMonth <= 12){
			 	sBaseRateID = "10020";
			 }else if(dTermMonth > 12 && dTermMonth <= 36){
			 	sBaseRateID = "10040";
			 }else if(dTermMonth > 36 && dTermMonth <= 60){
			 	sBaseRateID = "10050";
			 }else{
			 	sBaseRateID = "10030";
			 }
		 }else{//外币
			 if(dTermDay < 7 && dTermMonth==0){
			 	sBaseRateID = "20010";//隔夜
			 }else if(dTermDay < 14 && dTermMonth==0){
			 	sBaseRateID = "20020";//一周
			 }else if(dTermMonth==0 ){
			 	sBaseRateID = "20030";//二周
			 }else if(dTermMonth <3){
			 	sBaseRateID = "20040";//一个月
			 }else if(dTermMonth <6){
			 	sBaseRateID = "20050";//三个月
			 }else if(dTermMonth <12){
			 	sBaseRateID = "20060";//六个月
			 }else{
			 	sBaseRateID = "20070";//十二个月
			 }
		}
		 setItemValue(0,0,"BaseRateType",sBaseRateID);
		 
		 //sReturn = RunMethod("BusinessManage","getBaseRate",sBaseRateID);
		 sReturn = RunMethod("BusinessManage","getCurrencyBaseRate",sBaseRateID+","+sBusinessCurrency);
		    if(typeof(sReturn) != "undefined" && sReturn != ""){
		    	setItemValue(0,0,"BaseRate",sReturn);
		    }  
		getBusinessRate("M");
	}
	
	
	function getBusinessRateInfo()
	{
		getBusinessRate("M")
	}
	
	/*~[Describe=根据基准利率、利率浮动方式、利率浮动值计算执行年(月)利率;InputParam=无;OutPutParam=无;]~*/
	function getBusinessRate(sFlag)
	{
		//业务类型
		sBusinessType = "<%=sBusinessType%>";
		//基准利率
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//利率浮动方式
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//利率浮动值
		dRateFloat = getItemValue(0,getRow(),"RateFloat");
		var dBusinessRate = "";
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 )
		{			
			if(sRateFloatType=="0")	//浮动百分比
			{
				if(sFlag == 'Y') //执行年利率
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 );
				if(sFlag == 'M') //执行月利率
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 ) / 1.2;
			}else	//1:浮动点数
			{
				if(sFlag == 'Y') //执行年利率
					dBusinessRate = parseFloat(dBaseRate) + parseFloat(dRateFloat);
				if(sFlag == 'M') //执行月利率
					dBusinessRate = (parseFloat(dBaseRate) + parseFloat(dRateFloat)) / 1.2;
			}
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,0,"BusinessRate",dBusinessRate);
		}else
		{
			setItemValue(0,0,"BusinessRate","");
		}
		if(sBusinessType == "1020010" || sBusinessType == "1020020")
		{
			dBusinessRate = parseFloat(dBaseRate)/1.2;
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,0,"BusinessRate",dBusinessRate);
		}
	}
	
	
	/*~[Describe=根据手续费率计算手续费;InputParam=无;OutPutParam=无;]~*/
	function getpdgsum1()
	{
	    dBusinessSum = getItemValue(0,getRow(),"LineSum1"); //获取申请金额
	    if(parseFloat(dBusinessSum) >= 0)
	    {
			dPdgRatio = getItemValue(0,getRow(),"PdgRatio");//获取手续费比例
	    	if(parseFloat(dPdgRatio) >= 0)
	    	{
	    		sBusinessCurrency = getItemValue(0,getRow(),"Currency");		
	    		sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
	    		if(typeof(sFeeCurrency) == "undefined" || sFeeCurrency == "" ){
		        	sFeeCurrency = "01";
		        }
	        	dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
		    	dPdgRatio = roundOff(dPdgRatio,2);
			    dPdgSum = (parseFloat(dBusinessSum)*dErateRatio)*parseFloat(dPdgRatio)/1000;
			    dPdgSum = roundOff(dPdgSum,2);
			    if(dPdgSum<300 && ("<%=sBusinessType%>" == "2050030" || "<%=sBusinessType%>" == "2050010"))
					dPdgSum = 300.00;	
			    setItemValue(0,getRow(),"PdgSum",dPdgSum);
			}
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
	initRow();	
			
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

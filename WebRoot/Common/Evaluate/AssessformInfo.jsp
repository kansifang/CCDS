<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2010/02/01
		Tester:
		Content: 信用评定表详情
		Input Param:
                CustomerID：客户编号
                SerialNo：信息流水号
                EditRight：权限代码（01：查看权；02：维护权）
                ReportDate:报表月份
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信用评定表详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
    String sSql = "";//--存放sql语句
	ASResultSet rs = null;//-- 存放结果集
	String sCustomerName = "",sSex = "",sCertID = "";
	String sBirthday = "",sFamilyAdd = "",sMobileTelephone = "";
	String sWorkCorp = "",sManageAdd = "",sRelaCustomerName = "";
	String sRelativeID = "",sManageArea = "",sRelaCustomerID = "";
	String sPermitID = "";
	//获得组件参数：
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";
	//获得页面参数：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sEditRight = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sEditRight == null) sEditRight = "";
	String sAssessFormType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssessFormType"));
	if(sAssessFormType == null) sAssessFormType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//获取客户相关信息
	if("03".equals(sCustomerType))//个人客户
	{
		sSql = "select FullName,Sex,CertID,Birthday,FamilyAdd,MobileTelephone,WorkCorp "+
			" from IND_INFO "+
			" where CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			 sCustomerName = rs.getString("FullName");
			 sSex = rs.getString("Sex");
			 sCertID = rs.getString("CertID");
			 sBirthday = rs.getString("Birthday");
			 sFamilyAdd = rs.getString("FamilyAdd");
			 sMobileTelephone = rs.getString("MobileTelephone");
			 sWorkCorp = rs.getString("WorkCorp");
		}
		rs.getStatement().close();
	}else if("0501".equals(sCustomerType))//信用共同体
	{
		sSql = "select CustomerName "+
			" from CUSTOMER_INFO "+
			" where CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			 sCustomerName = rs.getString("CustomerName");
		}
		rs.getStatement().close();
	}else{
		sRelaCustomerID = sCustomerID;
		//取公司客户信息
		sSql = "select EnterpriseName,OfficeAdd,MostBusiness,LicenseNo "+
			" from ENT_INFO "+
			" where CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sRelaCustomerName = rs.getString("EnterpriseName");
			 sManageAdd = rs.getString("OfficeAdd");
			 sManageArea = rs.getString("MostBusiness");
			 sPermitID = rs.getString("LicenseNo");
		}
		rs.getStatement().close();
		//取法定代表人信息
		sSql = "select RelativeID,CustomerName,CertID,Sex,Birthday,FamilyAdd,Telephone "+
		" from CUSTOMER_RELATIVE "+
		" where RelationShip='0100' and CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			 sCustomerName = rs.getString("CustomerName");
			 sRelativeID = rs.getString("RelativeID");
			 sCertID = rs.getString("CertID");
			 sSex = rs.getString("Sex");
			 sBirthday = rs.getString("Birthday");
			 sFamilyAdd = rs.getString("FamilyAdd");
			 sMobileTelephone = rs.getString("Telephone");
			 if(sMobileTelephone == null) sMobileTelephone = "";
			 if(sFamilyAdd == null) sFamilyAdd = "";
		}
		rs.getStatement().close();
	}
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "AssessFormInfo1";
	if("".equals(sAssessFormType))
	{
		if("0501".equals(sCustomerType))//信用共同体
		{
			sAssessFormType = "030";
		}else//公司客户
		{
			sAssessFormType = "010";
		}
	}
	//根据信用等级评估模板确定模板条件
	if(sAssessFormType.equals("010"))
	{
		sTempletNo = "AssessFormInfo1";
	}else if(sAssessFormType.equals("020")){
		sTempletNo = "AssessFormInfo2";
	}else if(sAssessFormType.equals("030")){
		sTempletNo = "AssessFormInfo3";
	}
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//设置可修改
	if("03".equals(sCustomerType) && "010".equals(sAssessFormType))
	{
		doTemp.setReadOnly("RelaCustomerName,ManageAdd",false);
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform	
	if(sEditRight.equals("02"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
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
		{"false","","Button","测算","测算","getAssessScore()",sResourcesPath},
		{(sEditRight.equals("01")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
		if("010".equals(sAssessFormType) && sEditRight.equals("01")){
			sButtons[0][0] = "true";
		}
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
		//录入数据有效性检查
		if (!ValidityCheck()) return;	
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		
		sAssessFormType  = "<%=sAssessFormType%>";
		sCustomerType = "<%=sCustomerType%>"
		if(sAssessFormType != "030"){
			sAssessLevel = getItemValue(0,getRow(),"AssessLevel");
			sCustomerID = "<%=sCustomerID%>";
			if(sCustomerType.substring(0,2) == "03"){
				sReturn = RunMethod("CustomerManage","UpdateAssessLevel",sAssessLevel+","+sCustomerID);
				if(sReturn != 1.0)
					return;
			}	
		}
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/Common/Evaluate/AssessformList.jsp","_self","");
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script language=javascript>
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{		
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{	
		if("<%=sAssessFormType%>" == "010")
		getAssessScore();
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{		
		return true;
	}
	
	/*~[Describe=获得比例;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function getAssessRate(pItemNum1,pItemNum2,pRate)
	{		
		sItemNum1=getItemValue(0,getRow(),pItemNum1);
		sItemNum2=getItemValue(0,getRow(),pItemNum2);
		if(typeof(sItemNum1)!="undefined" && sItemNum1.length!=0 && typeof(sItemNum2)!="undefined" && sItemNum2.length!=0 && sItemNum1!=0)
		{
			setItemValue(0,0,pRate,roundOff(sItemNum2*100/sItemNum1,2));
		}
	}
	
	function getAssessRate2(){
		sItemNum1=getItemValue(0,getRow(),"AssessNum7");
		sItemNum2=getItemValue(0,getRow(),"AssessNum8");
		sItemNum3=getItemValue(0,getRow(),"AssessNum1");
		sItemTotalNum = 0;
		if(typeof(sItemNum1)!="undefined" && typeof(sItemNum2)!="undefined" && typeof(sItemNum3)!="undefined" )
		{
			sItemTotalNum = parseInt(sItemNum1)+parseInt(sItemNum2)+parseInt(sItemNum3);
		}		
		sItemNum4=getItemValue(0,getRow(),"AssessNum9");//信用户数
		sItemNum5=getItemValue(0,getRow(),"AssessNum2");//信用商户数
		if(sItemTotalNum != 0 && typeof(sItemNum4)!="undefined" ){
			setItemValue(0,0,"AssessRate4",roundOff(sItemNum4*100/sItemTotalNum,2));
		}
		if(sItemTotalNum != 0 && typeof(sItemNum5)!="undefined" ){
			setItemValue(0,0,"AssessRate1",roundOff(sItemNum5*100/sItemTotalNum,2));
		}
	}

	/*~[Describe=获得比例;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function getAssessRate1(pItemNum1,pItemNum2,pItemNum3,pRate)
	{		
		sItemNum1=getItemValue(0,getRow(),pItemNum1);
		sItemNum2=getItemValue(0,getRow(),pItemNum2);
		sItemNum3=getItemValue(0,getRow(),pItemNum3);		
		if(typeof(sItemNum1)!="undefined" && sItemNum1.length!=0 && typeof(sItemNum2)!="undefined" && sItemNum2.length!=0 && sItemNum1!=0&& typeof(sItemNum3)!="undefined" && sItemNum3.length!=0 && sItemNum3!=0)
		{
			setItemValue(0,0,pRate,roundOff(sItemNum3*100/(parseInt(sItemNum1)+parseInt(sItemNum2)+parseInt(sItemNum3)),2));
		}
	}
	
	/*~[Describe=计算信用评定得分;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function getAssessScore()
	{		
		sAssessItem1 = parseInt(getItemValue(0,getRow(),"AssessItem1"));
		sAssessItem2 = parseInt(getItemValue(0,getRow(),"AssessItem2"));
		sAssessItem3 = parseInt(getItemValue(0,getRow(),"AssessItem3"));
		sAssessItem4 = parseInt(getItemValue(0,getRow(),"AssessItem4"));
		sAssessItem5 = parseInt(getItemValue(0,getRow(),"AssessItem5"));
		sAssessItem6 = parseInt(getItemValue(0,getRow(),"AssessItem6"));
		sAssessItem7 = parseInt(getItemValue(0,getRow(),"AssessItem7"));
		sAssessItem8 = parseInt(getItemValue(0,getRow(),"AssessItem8"));
		sAssessItem9 = parseInt(getItemValue(0,getRow(),"AssessItem9"));
		sAssessScore=sAssessItem1+sAssessItem2+sAssessItem3+sAssessItem4+sAssessItem5+sAssessItem6+sAssessItem7+sAssessItem8+sAssessItem9
		if(sAssessScore>=85)
		{
			setItemValue(0,0,"AssessLevel","030");
		}else if(sAssessScore>=70)
		{
			setItemValue(0,0,"AssessLevel","020");
		}else 
		{
			setItemValue(0,0,"AssessLevel","010")
		}
		setItemValue(0,0,"AssessScore",sAssessScore);
	}
	
	function getAssessLevel(){
		sAssessItem = getItemValue(0,getRow(),"PerFamilySum");
		if(sAssessItem>"8000")
			setItemValue(0,0,"AssessLevel","030");
		else if(sAssessItem>"5000")	
			setItemValue(0,0,"AssessLevel","020");
		else if(sAssessItem>"2000")	
			setItemValue(0,0,"AssessLevel","010");		
		else{ 	
			alert("家庭人均纯收入不得小于2000元！");
			setItemValue(0,0,"AssessLevel","");
		}		
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		var sAge="";
		sToday = "<%=StringFunction.getToday()%>";
		sBirthday = "<%=sBirthday%>";
		if(typeof(sBirthday)!="undefined" && sBirthday.length!=0)
		{
			sToday=sToday.split("/");
			sBirthday=sBirthday.split("/");
			sAge=sToday[0]-sBirthday[0]
		}
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"ObjectNo","<%=sCustomerID%>");
			setItemValue(0,0,"ObjectType","Customer");
			setItemValue(0,0,"AssessFormType","<%=sAssessFormType%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Sex","<%=sSex%>");
			setItemValue(0,0,"CertID","<%=sCertID%>");
			setItemValue(0,0,"FamilyAdd","<%=sFamilyAdd%>");
			setItemValue(0,0,"MobileTelephone","<%=sMobileTelephone%>");
			setItemValue(0,0,"WorkCorp","<%=sWorkCorp%>");
			setItemValue(0,0,"ManageAdd","<%=sManageAdd%>");
			setItemValue(0,0,"ManageArea","<%=sManageArea%>");
			setItemValue(0,0,"PermitID","<%=sPermitID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			if("<%=sCustomerType%>"!='03'&&"<%=sCustomerType%>"!='0501')
			{
				setItemValue(0,0,"CustomerID","<%=sRelativeID%>");
			}else
			{
				setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			}
			setItemValue(0,0,"RelaCustomerName","<%=sRelaCustomerName%>");
			setItemValue(0,0,"RelaCustomerID","<%=sRelaCustomerID%>");
			setItemValue(0,0,"Age",sAge);
		}
    }
    
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSESSFORM_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:lpzhang 2009-8-12 
		Tester:
		Content:风险度测算
		Input Param:
			ObjectNo： 对象编号
			ObjectType:对象类型
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "风险度测算"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";//sql语句
	ASResultSet rs = null;
	//客户编号，担保方式
	String sCustomerID = "",sVouchResult = "",sEvaluateResult = "",sVouchResultName="",sTableName="",sVouchModulus ="";
	String sCustomerType = "";
	//担保系数数
	double  dTermModulus = 0.0 ,dEvaluateModulus = 0.0,dTermMonth=0.0;
	String[] VouchModulus = new String[2];
	
	//获得组件参数
	//获得页面参数	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(sObjectType==null) sObjectType="";
%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%

	
	//取得申请各项值
	sSql = " select BA.CustomerID,BA.VouchType,getItemName('VouchType',VouchType) as VouchResultName,"+
		   " TermMonth,getTermModulus(TermMonth) as TermModulus, CL.Attribute3 "+
		   " from Business_Apply BA ,Code_library CL where BA.VouchType =CL.ItemNo and CL.CodeNo='VouchType' and BA.SerialNo = '"+sObjectNo+"'" ;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID"); //客户编号
		sVouchResult = rs.getString("VouchType");//担保方式
		sVouchResultName = rs.getString("VouchResultName");//担保方式
		dTermMonth = rs.getDouble("TermMonth");//贷款期限
		sVouchModulus = rs.getString("Attribute3");//担保系数
		dTermModulus = rs.getDouble("TermModulus");//期限系数
		if(sCustomerID == null) sCustomerID = "";
		if(sVouchResult == null) sVouchResult = ""; 
		if(sVouchResultName == null) sVouchResultName = ""; 
		if(sVouchModulus == null) sVouchModulus = ""; 
	}else
	{
		out.println("<font color=red>请先填写完成申请基本信息！</font>");
		return;
	}
	rs.getStatement().close();
	//取客户信息
	sSql = "select CustomerType from Customer_Info where CustomerID = '"+sCustomerID+"'"; 
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
		if(sCustomerType == null) sCustomerType = "";
	}
	rs.getStatement().close();	
	
	//取得客户信用等级值,如果客户类型03开头则为个人客户
	sTableName = Sqlca.getString("select (case when locate('03',CustomerType) = 1 then 'IND_INFO' else 'ENT_INFO' end) as TableName from Customer_Info where CustomerID ='"+sCustomerID+"'");
	if(sTableName==null) sTableName="";
	//本行即期评级 
	sSql = "select CreditLevel,getEvaluateModulus(CreditLevel) as EvaluateModulus from "+sTableName+" where CustomerID ='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sEvaluateResult = rs.getString("CreditLevel"); //评级结果
		dEvaluateModulus = rs.getDouble("EvaluateModulus");//评级系数
		if(sEvaluateResult == null) sEvaluateResult = ""; 	
	}
	rs.getStatement().close();
	
	//如果即期评级为空取当前系统最近一年末(对公)或者最近一期(个人)的评估结果
	if("".equals(sEvaluateResult))
	{
		if(sCustomerType.startsWith("03"))//个人
		{
			sSql = "select EvaluateResult,getEvaluateModulus(EvaluateResult) as EvaluateModulus "+
				" from EVALUATE_RECORD R "+
				" where ObjectType = 'Customer' "+
				" and ObjectNo = '"+sCustomerID+"'  order by AccountMonth desc fetch first 1 rows only";
		}else//对公
		{
			sSql = "select EvaluateResult,getEvaluateModulus(EvaluateResult) as EvaluateModulus "+
				" from EVALUATE_RECORD R "+
				" where ObjectType = 'Customer' "+
				" and AccountMonth like '%/12' "+
				" and ObjectNo = '"+sCustomerID+"'  order by AccountMonth desc fetch first 1 rows only";
			
		}
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sEvaluateResult = rs.getString("EvaluateResult"); //评级结果
			dEvaluateModulus = rs.getDouble("EvaluateModulus");//评级系数
			if(sEvaluateResult == null) sEvaluateResult = ""; 	
		}
		rs.getStatement().close();
	}
	
	String sBizHouseFlag = "";
	sSql = "select CustomerType,GETBIZHOUSEFLAG(CustomerID) as BizHouseFlag from Customer_Info where CustomerID = '"+sCustomerID+"'"; 
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
		sBizHouseFlag = rs.getString("BizHouseFlag");//是否商户
		if(sCustomerType == null) sCustomerType = "";
		if(sBizHouseFlag == null) sBizHouseFlag = "";
		if((!sCustomerType.startsWith("03") && sBizHouseFlag.equals("1")) && sVouchResult.equals("005")){
			dEvaluateModulus = 1.00;
			sEvaluateResult = "";
			dTermModulus = 1.00;
		}
	}
	rs.getStatement().close();
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "RiskEvaluate";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//如果担保系数在区间，则将VouchModulus设置为只读
	if(sVouchModulus.length()<1){
		out.println("<font color=red>无担保方式["+sVouchResultName+"]对应系数，请联系系统管理员进行维护！</font>");
		return;
	}else{
		if(sVouchModulus.indexOf(",")>-1)
		{
			VouchModulus = sVouchModulus.split(",");
			doTemp.setReadOnly("VouchModulus",false);
			doTemp.setRequired("VouchModulus",true);
			doTemp.setUnit("VouchModulus","<font color=red>该区域录入数据值在（"+VouchModulus[0]+"~"+VouchModulus[1]+"）之间</font>");
		}
	}
	if((!sCustomerType.startsWith("03") && sBizHouseFlag.equals("1")) && sVouchResult.equals("005")){
		doTemp.setUnit("EvaluateResult","<font color=red>个人客户或商户，主要担保方式为信用时，信用贷款的信用等级为空！</font>");
	}
	else if("".equals(sEvaluateResult)){
		doTemp.setUnit("EvaluateResult","<font color=red>该客户还没有可用的信用评级！</font>");
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//构建一个HTML模版
	String sHTMLTemplate = "<table align='center' width='100%' border='0' Backgroundcolor='#red' cellpadding='1' cellspacing='2' bodercolor='#red' bordercolorlight='#FFFFFF'   bordercolordark='#FFFFFF'>";
	sHTMLTemplate += "<tr><td><fieldset><legend><font color='blue'>测算要素</font></legend>${DOCK:PART1}</fieldset></td></tr>";			   
	sHTMLTemplate += "<tr><td><fieldset><legend><font color='blue'>测算结果</font></legend>${DOCK:PART2}</fieldset></td></tr>";
	sHTMLTemplate += "<tr><td><fieldset><legend><font color='blue'>登记信息</font></legend>${DOCK:PART3}</fieldset></td></tr>";			   
	sHTMLTemplate += "</table>";
	//将模版应用于Datawindow
	dwTemp.setHarborTemplate(sHTMLTemplate);
	//设置setEvent	
	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateLowRisk("+sObjectNo+",#RiskEvaluate)");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateLowRisk("+sObjectNo+",#RiskEvaluate)");
	
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//System.out.println("doTemp.SourceSql:"+doTemp.SourceSql);
	
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
							{"true","","Button","测算并保存","测算并保存","saveRecord()",sResourcesPath}
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
		if (!ValidityCheck()) return;
		if(vI_all("myiframe0"))
		{
			if(bIsInsert){		
				beforeInsert();
			}
			dVouchModulus = getItemValue(0,getRow(),"VouchModulus");
			if("<%=sCustomerType%>" == "03")
			{
				dRiskEvaluate =  parseFloat("<%=dEvaluateModulus%>")*parseFloat(dVouchModulus); //授信风险度=信用等级换算系数x担保方式换算系数
			}else{
				dRiskEvaluate =  parseFloat("<%=dEvaluateModulus%>")*parseFloat(dVouchModulus)*parseFloat("<%=dTermModulus%>");//授信风险度=信用等级换算系数x担保方式换算系数x授信期限调节系数
			}
			setItemValue(0,0,"RiskEvaluate",dRiskEvaluate);
			
			as_save("myiframe0",sPostEvents);
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		sVouchResult = getItemValue(0,getRow(),"VouchResult");
		dTermNum = getItemValue(0,getRow(),"TermNum");
		dVouchModulus = getItemValue(0,getRow(),"VouchModulus");
		if(typeof(sVouchResult) == "undefined" || sVouchResult == "" || typeof(<%=dTermMonth%>) == "undefined" || "<%=dTermMonth%>" == "")
		{	
			alert("请先保存授信申请基本信息项！");
			return false;
		}
		if("<%=sVouchModulus%>".indexOf(",")>-1)//担保系数是区间，则需要判断输入的数据是否在区间内
		{
			if(parseFloat(dVouchModulus) < parseFloat("<%=VouchModulus[0]%>") || parseFloat(dVouchModulus) > parseFloat("<%=VouchModulus[1]%>"))
			{
				alert("担保方式换算系数录入数据请在区间之内！");
				return false;
			}
		}
		
		return true;
	}
	
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
		setItemValue(0,0,"EvaluateResult","<%=sEvaluateResult%>");
		setItemValue(0,0,"VouchResult","<%=sVouchResult%>");
		setItemValue(0,0,"VouchResultName","<%=sVouchResultName%>");
		if("<%=sCustomerType%>" == "03")
		{
			setItemValue(0,0,"TermNum","");
			setItemValue(0,0,"TermModulus","");
			 
		}else
		{
			setItemValue(0,0,"TermNum","<%=dTermMonth%>");
			setItemValue(0,0,"TermModulus","<%=dTermModulus%>");
		}
		if("<%=sVouchModulus%>".indexOf(",")<0)
		{
			setItemValue(0,0,"VouchModulus","<%=sVouchModulus%>");
		}
		
		setItemValue(0,0,"EvaluateModulus","<%=dEvaluateModulus%>");
	}
	
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "RISK_EVALUATE";//表名 
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
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

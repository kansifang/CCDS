<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   bma 2008-09-19
		Tester:
		Content: 国际业务补登详情页面
		Input Param:
			SerialNo：借据号
			ReinforceFlag：标志位
				020010未结清垫款
			   	020020已结清垫款
			   	030010已结清国际业务
			   	030020已结清国际业务
		Output param:
		History Log: 	
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "国际业务补登详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReinforceFlag"));
	String sMFOrgID = "";
	
	//将空值转化成空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sReinforceFlag == null) sReinforceFlag = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "NewNationalInfo";
	String sSql = " select MainFrameExgID from ORG_INFO where OrgID ='"+CurOrg.OrgID+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sMFOrgID = rs.getString("MainFrameExgID");
		if(sMFOrgID==null) sMFOrgID = "";
	}
	rs.getStatement().close();
	//根据模板编号设置数据对象	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
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
			  {"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
			  };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{	
		sBusinessStatus = getItemValue(0,getRow(),"BusinessStatus");
		sFinishDate = getItemValue(0,getRow(),"FinishDate");
		sReturnType = getItemValue(0,getRow(),"ReturnType");
		sActualMaturity = getItemValue(0,getRow(),"Maturity");//实际到期日
		if(sBusinessStatus == "20" && (sReturnType == null || sReturnType == "" ))
		{
			alert("业务状态为注销时，还款方式不能为空");
			return;
		}else if(sBusinessStatus == "20" && (sFinishDate == null || sFinishDate == "" ))
		{
			alert("业务状态为注销时，注销日期不能为空");
			return;
		}
		judgeBalance();
		setItemValue(0,getRow(),"ActualMaturity",sActualMaturity);
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=判断余额;InputParam=无;OutPutParam=取消标志;]~*/
	function judgeBalance()
	{		
		sBalance = getItemValue(0,getRow(),"Balance");	//余额
		sNormalBalance = getItemValue(0,getRow(),"NormalBalance"); //正常余额
		sOverdueBalance = getItemValue(0,getRow(),"OverdueBalance");//逾期余额
		sDullBalance = getItemValue(0,getRow(),"DullBalance");	//呆滞余额
		sBadBalance = getItemValue(0,getRow(),"BadBalance");	//呆账余额
		if(sBalance == null ||sBalance == "" || sBalance == " ") sBalance = 0.0;
		if(sNormalBalance == null || sNormalBalance == "" || sNormalBalance == " ") sNormalBalance = 0.0;
		if(sOverdueBalance == null || sOverdueBalance == "" || sOverdueBalance == " ") sOverdueBalance = 0.0;
		if(sDullBalance == null || sDullBalance == " ") sDullBalance = 0.0;
		if(sBadBalance == null || sBadBalance == "" || sBadBalance == " ") sBadBalance = 0.0;
		sSum = sNormalBalance+sOverdueBalance+sDullBalance+sBadBalance;
		if(sBalance != sSum)
		{
			alert("认定余额之和不等于预期余额");
			return;
		}	
	}
	
	/*~[Describe=初始化认定余额;InputParam=无;OutPutParam=取消标志;]~*/
	function getBalance()
	{		
		sBalance = getItemValue(0,getRow(),"Balance");	//余额
		if(sBalance == null ||sBalance == "" || sBalance == " ") sBalance = 0.0;
		sNormalBalance = sBalance; //正常余额
		sOverdueBalance = 0.0;//逾期余额
		sDullBalance = 0.0;	//呆滞余额
		sBadBalance = 0.0;	//呆账余额
		setItemValue(0,getRow(),"NormalBalance",sNormalBalance);
		setItemValue(0,getRow(),"OverdueBalance",sOverdueBalance);
		setItemValue(0,getRow(),"DullBalance",sDullBalance);
		setItemValue(0,getRow(),"BadBalance",sBadBalance);
	}
		   
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
	function goBack()
	{		
		self.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	function selectDueBill()
	{  
		setObjectValue("SelectDueBill","","@RelativeSerialNo1@0",0,0,"");
	}
	
							
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		var sInputOrgID = getItemValue(0,getRow(),"InputOrgID");
		if( sInputOrgID == "" || sInputOrgID == " " || sInputOrgID == null)
		{
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"MFOrgID","<%=sMFOrgID%>");
		}
    }
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
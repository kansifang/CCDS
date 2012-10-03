<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   bqliu 2011-06-13
		Tester:
		Content: 预警信息_Info
		Input Param:	
			SignalType：预警类型（01：发起；02：解除）		
			SignalStatus：预警状态（10：待处理；15：待分发；20：审批中；30：批准；40：否决） 
			SerialNo：预警流水号    
		Output param:
		                
		History Log: pliu 2011-08-19
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警发起"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "",sCustomerType="";
		
	//获得组件参数		
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalStatus"));
	String sSignalType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalType"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sSignalStatus == null) sSignalStatus = "";
	if(sSignalType == null) sSignalType = "";
	//定义变量：查询结果集
	ASResultSet rs = null;
%>
<%/*~END~*/%>

<%	
	//获取客户类型
	sSql = " select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerType = DataConvert.toString(rs.getString("CustomerType"));
		if(sCustomerType == null) sCustomerType = "";		
	}
	rs.getStatement().close();
	
	
	String[][] sHeaders = {							
							{"SignalName","预警信号"},
							{"SignalType","预警类型"},
							{"SignalStatus","预警状态"},													
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记时间"}
						};
		
	sSql =  " select CR.SerialNo,CR.SignalNo as SignalNo,CR.CustomerID as CustomerID,CR.SignalName as SignalName,"+
	        " getItemName('SignalType',RS.SignalType) as SignalType,"+
			" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus, "+
			" GetOrgName(CR.InputOrgID) as InputOrgName, "+
			" GetUserName(CR.InputUserID) as InputUserName,CR.InputDate "+
			" from Customer_RiskSignal CR,Risk_Signal RS,RISKSIGNAL_RELATIVE RR"+
			" where RR.ObjectNo = CR.SerialNo "+
			" and RS.SerialNo=RR.SerialNo and RR.ObjectType='RiskSignal' "+
			" and RS.SerialNo = '"+sObjectNo+"'";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="Customer_RiskSignal";
	doTemp.setHTMLStyle("SignalName","style={width=200px}");
	//设置字段位置
	doTemp.setAlign("SignalType,SignalStatus","2");
	//设置关键字
	doTemp.setKey("SignalNo,CustomerID",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("SignalNo,CustomerID,SerialNo",false);
	
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
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
			{"02".equals(sSignalType)?"false":"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"02".equals(sSignalType)?"false":"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
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
		//OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp","_self","");
		var sParaString = "CodeNo"+","+"AlertSignal2";
		if("<%=sCustomerType%>".substring(0,2)=="01")
		{
			sParaString=sParaString+",SortID,EndAL";
		}else if("<%=sCustomerType%>".substring(0,2)=="03")
		{
			sParaString=sParaString+",SortID,IndAL";
		}
		
		var sReturn = setObjectValue("SelectAlarmCode",sParaString,"@SignalNo@0@SignalName@1",0,0,"");
		if (typeof(sReturn) != "undefined" && sReturn != "" )
		{
			sSignalNo = sReturn.split("@")[0];	
			sSignalName = sReturn.split("@")[1];
			sMessage=RunMethod("BusinessManage","AddRiskSignal","<%=sObjectNo%>,RiskSignal,<%=sCustomerID%>,"+sSignalNo+","+sSignalName+",<%=CurUser.UserID%>,<%=CurUser.OrgID%>");
			if(typeof(sMessage)!="undefined"&&sMessage!=""&& sMessage.length>0 ) 
			{
				alert(sMessage);
				return;
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			sReturn=RunMethod("BusinessManage","DeleteRiskSignal","RiskSignal,"+sSerialNo+",<%=sObjectNo%>");
			if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED") 
			{
				alert(getHtmlMessage('7'));//信息删除成功！
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('8'));//对不起，删除信息失败！
				return;
			}
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	function initRow()
	{
		setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
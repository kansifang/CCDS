<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   lpzhang 2009-8-5
		       
		Tester:	
		Content:工程机械按揭额度详情
		Input Param:
			
			
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "工程机械按揭额度从协议详情"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));//申请编号
	String ESerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ESerialNo"));//主协议
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(ESerialNo == null) ESerialNo = "";
    out.print("<fieldset ><font color='red'><b>请注意：此区域输入工程机械按揭额度从协议</b></font></fieldset>");
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	ASResultSet rs = null;
	//主协议工程机械类型  
	String sParentLoanType = "" ,sParentCurrency = "";
	//主协议期限 ,贷款规模，最高贷款金额，最高比例
	double dParentTermMonth = 0.0 ,dParentAgreementScale = 0.0,dParentLoanSum = 0.0,dParentLoanRatio = 0.0;

	String sSql = "select LoanType,Currency,TermMonth,AgreementScale,LoanSum,LoanRatio from ENT_Agreement where SerialNo ='"+ESerialNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sParentLoanType = rs.getString("LoanType");   
		sParentCurrency = rs.getString("Currency"); 
		dParentTermMonth = rs.getDouble("TermMonth");   
		dParentAgreementScale = rs.getDouble("AgreementScale");  
		dParentLoanSum = rs.getDouble("LoanSum");    
		dParentLoanRatio = rs.getDouble("LoanRatio");   
		if(sParentLoanType == null) sParentLoanType = "";
		if(sParentCurrency == null) sParentCurrency = "";
	}
	rs.getStatement().close();
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "DealerAgreement";
	String sTempletFilter = "1=1";
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//设置最高贷款金额
	doTemp.appendHTMLStyle("LimitSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"最高贷款金额(元)必须大于等于0！\" ");
	//设置最高贷款期限(月)范围
	doTemp.appendHTMLStyle("LimitLoanTerm"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"最高贷款期限(月)必须大于等于0！\" ");
	//设置期限)范围
	doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限必须大于等于0！\" ");
	//设置最低缴存保证金比例(%)范围
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"缴存保证金比例(‰)的范围为[0,100]\" ");
	//设置其中制造商比例(%)范围
	doTemp.appendHTMLStyle("CompanyBailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"其中制造商比例(‰)的范围为[0,100]\" ");
	//设置其中经销商比例(%)范围
	doTemp.appendHTMLStyle("DealerBailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"其中经销商比例(‰)的范围为[0,100]\" ");
	//设置最高贷款比例(%)范围
	doTemp.appendHTMLStyle("LimitLoanRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"最高贷款比例(‰)的范围为[0,100]\" ");
	//设置从协议额度金额范围
	doTemp.appendHTMLStyle("CreditSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"从协议额度金额必须大于等于0！\" ");

	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "0"; 
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+ESerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //调试datawindow的Sql常用方法

	
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{	
	
		if(vI_all("myiframe0"))
		{
			if(!ValidityCheck()) return;
			if(bIsInsert){		
				beforeInsert();
			}	
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
		}	
		//parent.reloadSelf();
	}	

	</script>
	
	

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getCompanyName()
	{
		setObjectValue("getCompanyName","","@DealerID@0@DealerName@1",0,0,"");		
		//传入当前的条件即可
		/*
	    sParaString = "ObjectType"+",BuildAgreement";
		sReturn = selectObjectValue("SelectEntAgreement",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || sReturn=="_CLEAR_" || typeof(sReturn)=="undefined") return;
		sReturn= sReturn.split('@');
		sSerialNo = sReturn[0];
		*/
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		//期限判断
		var dParentTermMonth = "<%=dParentTermMonth%>";
		var dTermMonth = getItemValue(0,getRow(),"LimitLoanTerm");
		if(parseFloat(dTermMonth) > parseFloat(dParentTermMonth))
		{
			alert("对不起，从协议最高贷款期限不能高于主协议的最高贷款期限！");
			return false;
		}
		//最高贷款金额判断
		var dParentLoanSum = "<%=dParentLoanSum%>";
		var sParentCurrency = "<%=sParentCurrency%>";
		var dLimitSum = getItemValue(0,getRow(),"LimitSum");
		var sCurrency = getItemValue(0,getRow(),"Currency");
		var dErateRatio =  RunMethod("BusinessManage","getErateRatio",sCurrency+","+sParentCurrency+",''");
		if(parseFloat(dLimitSum)*dErateRatio > parseFloat(dParentLoanSum))
		{
			alert("对不起，最高贷款金额不能高于主协议最高贷款金额！");
			return false;
		}
		//贷款比例判断
		var dParentLoanRatio = "<%=dParentLoanRatio%>";
		var dLimitLoanRatio = getItemValue(0,getRow(),"LimitLoanRatio");
		if(parseFloat(dLimitLoanRatio) > parseFloat(dParentLoanRatio))
		{
			alert("对不起，最高贷款比例不能高于主协议最高贷款比例！");
			return false;
		}
		//贷款规模判断
		var dParentAgreementScale = "<%=dParentAgreementScale%>"; 
		var dCreditSum = getItemValue(0,getRow(),"CreditSum");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var dTotalCreditSum =  RunMethod("CreditLine","getTotalCreditSum","<%=ESerialNo%>,"+sSerialNo+","+dCreditSum+","+sCurrency+","+sParentCurrency);
		if(parseFloat(dTotalCreditSum) > parseFloat(dParentAgreementScale))
		{
			alert("对不起，从协议额度金额不能高于主协议规模！");
			return false;
		}
		
		return true;
	}
	
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{

		if(getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ObjectNo","<%=ESerialNo%>");
			setItemValue(0,0,"LoanType","<%=sParentLoanType%>");
		}
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");

	}
	
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "DEALER_AGREEMENT";//表名
		var sColumnName = "SerialNo";//字段名
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");//对象名称

		//使用GetSerialNo.jsp来抢占一个流水号GetChildSerialNo
		var sSerialNo = PopPage("/Common/ToolsB/GetChildSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&ObjectNo="+sObjectNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
	
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
	
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
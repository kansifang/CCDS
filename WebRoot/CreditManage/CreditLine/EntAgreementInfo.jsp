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
	String PG_TITLE = "工程机械按揭额度详情"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";

	out.print("<fieldset ><font color='red'><b>请注意：此区域输入工程机械按揭额度主协议</b></font></fieldset>");
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ProjectAgreement";
	String sTempletFilter = "1=1";
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//设置最高贷款金额
	doTemp.appendHTMLStyle("LoanSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"最高贷款金额(元)必须大于等于0！\" ");
	//设置最高贷款期限(月)范围
	doTemp.appendHTMLStyle("LoanTerm"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"最高贷款期限(月)必须大于等于0！\" ");
	//设置期限)范围
	doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限必须大于等于0！\" ");
	//设置最低缴存保证金比例(%)范围
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"最低缴存保证金比例(‰)的范围为[0,100]\" ");
	//设置其中制造商比例(%)范围
	doTemp.appendHTMLStyle("CompanyBailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"其中制造商比例(‰)的范围为[0,100]\" ");
	//设置其中经销商比例(%)范围
	doTemp.appendHTMLStyle("DealerBailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"其中经销商比例(‰)的范围为[0,100]\" ");
	//设置最高贷款比例(%)范围
	doTemp.appendHTMLStyle("LoanRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"最高贷款比例(‰)的范围为[0,100]\" ");
	//设置申请协议规模)范围
	doTemp.appendHTMLStyle("AgreementScale"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请协议规模必须大于等于0！\" ");
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "0"; 
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+",ProjectAgreement");
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
		{"true","","Button","从协议信息","编辑/查看从协议信息","viewDealerAgreement()",sResourcesPath},
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
			sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
			sMaturity = getItemValue(0,getRow(),"Maturity");
			if(sPutOutDate > sMaturity)
			{
				alert("协议签署日期不能大于协议到期日！");
				return;
			}
			if(bIsInsert){		
				beforeInsert();
			}	
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
			
		}		
	}	


	/*~[Describe=,查看主协议下面的的子协议;InputParam=无;OutPutParam=无;]~*/
	function viewDealerAgreement()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码RAGREEMENT
		OpenComp("DealerAgreementList","/CreditManage/CreditLine/DealerAgreementList.jsp","ESerialNo="+sSerialNo,"_blank",OpenStyle);
	}
    
	</script>
	
	

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		//更新从协议工程机械类型
		sLoanType = getItemValue(0,getRow(),"LoanType");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		RunMethod("CreditLine","UpdateLoanType",sLoanType+","+sSerialNo);
	}
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getCompanyName()
	{
		setObjectValue("getCompanyName","","@CustomerID@0@CustomerName@1",0,0,"");		
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{

		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
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
			setItemValue(0,0,"AgreementType","ProjectAgreement");
			setItemValue(0,0,"FreezeFlag","1");
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
		var sTableName = "ENT_AGREEMENT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
	
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	/*
	if(getRowCount(0)== 0) 
	{
		OpenPage("/Blank.jsp?TextToShow=请录入工程机械按揭额度主协议!","DetailFrame","");
	}else
	{
		mySelectRow();	
	}*/
	initRow(); //页面装载时，对DW当前记录进行初始化
	
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
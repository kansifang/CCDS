<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: bliu 2004-12-22
		Tester:
		Describe: 投资－企业债权投资
		Input Param:
			CustomerID：当前客户编号
			SerialNo:	流水号
		Output Param:
			CustomerID：当前客户编号

		HistoryLog:slliua 2005-1-6
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "投资－企业债权投资"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数

	
	//获得页面参数	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
	
	//获得组件参数
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	if(sFlag==null) sFlag="";
	
	//获得组件参数(8010企业投资、8020股权投资、8030拆借)
	String sCurItemDescribe3 = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurItemDescribe3"));
	if(sCurItemDescribe3==null) sCurItemDescribe3="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo="";
	
	//企业债权投资
	if(sCurItemDescribe3.equals("8010"))
	{
		sTempletNo = "InputInvestBondInfo";
	}
	
	//股权投资
	if(sCurItemDescribe3.equals("8020"))
	{
		sTempletNo = "InputInvestStockInfo";
	}
	
	//拆借
	if(sCurItemDescribe3.equals("8030"))
	{
		sTempletNo = "InputLendInfo";
	}
	
	
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//设置比率范围
	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"债券利率的范围为[0,100]\" ");
	
	if(sFlag.equals("Y"))
	{
		doTemp.setUpdateable("ManageOrgID",false);
	}else
	{
		doTemp.setUpdateable("RecoveryOrgID",false);
	}
	
	//设置只读
	doTemp.setReadOnly("SerialNo,CustomerID,BusinessSubType,BeginDate,EndDate,BusinessCurrency,FirstDrawingDate",true);
	
	
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
	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		setObjectInfo("ImportCustomer","0@CustomerID@3@CustomerName@1",0,0);
	}
	
	/*~[Describe=选择保全管理机构;InputParam=无;OutPutParam=无;]~*/
	function getRecoveryOrgID()
	{
		var sReturn= selectObjectInfo("Org","OrgID=<%=CurOrg.OrgID%>");
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'))
		{
			sReturn=sReturn.split("@");
			sRecoveryOrgID=sReturn[0];
			sRecoveryOrgName=sReturn[1];
	
			setItemValue(0,0,"RecoveryOrgID",sReturn[0]);	
			setItemValue(0,0,"RecoveryOrgName",sReturn[1]);
		}else if (sReturn=='_CLEAR_')
		{
			setItemValue(0,0,"RecoveryOrgID","");
			setItemValue(0,0,"RecoveryOrgName","");
		}else 
		{
			return;
		}
	}
	
	/*~[Describe=选择经办人和经办机构;InputParam=无;OutPutParam=无;]~*/
	function getOperateUserID()
	{
		var sReturn= selectObjectInfo("User","OrgID=<%=CurOrg.OrgID%>");
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'))
		{
			sReturn=sReturn.split("@");
			sOperateUserID=sReturn[0];
			sOperateUserName=sReturn[1];
			sOperateOrgID=sReturn[2];
			sOperateOrgName=sReturn[3];
	
			setItemValue(0,0,"OperateUserID",sReturn[0]);
			setItemValue(0,0,"OperateUserName",sReturn[1]);
			setItemValue(0,0,"OperateOrgID",sReturn[2]);	
			setItemValue(0,0,"OperateOrgName",sReturn[3]);
		}else if (sReturn=='_CLEAR_')
		{
			setItemValue(0,0,"OperateUserID","");
			setItemValue(0,0,"OperateUserName","");
			setItemValue(0,0,"OperateOrgID","");	
			setItemValue(0,0,"OperateOrgName","");
		}else 
		{
			return;
		}
	}	

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}


	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			
			var sCurItemDescribe3 = "<%=sCurItemDescribe3%>";
			
			//企业债权投资
			if(sCurItemDescribe3=="8010")
			{
				setItemValue(0,0,"BusinessType","8010");
			}
			
			//股权投资
			if(sCurItemDescribe3=="8020")
			{
				setItemValue(0,0,"BusinessType","8020");
			}
			
			//拆借
			if(sCurItemDescribe3=="8030")
			{
				setItemValue(0,0,"BusinessType","88010");
			}
			
			
			var sFlag = "<%=sFlag%>";
			if(sFlag=="Y")
			{
				setItemValue(0,0,"ShiftType","020");
			}
			
			setItemValue(0,0,"RecoveryOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"RecoveryOrgName","<%=CurOrg.OrgName%>");
			
			setItemValue(0,0,"ManageOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"ManageOrgName","<%=CurOrg.OrgName%>");
			
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT";//表名
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
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   王业罡 2005-08-18
		Tester:
		Content: 催收函详细信息_List
		Input Param:
				SerialNo	催收函流水号
				下列参数作为组件参数传入
				ComponentName	组件名称：催收函管理/催收函列表
				ComponentType	组件类型：MainWindo/ListWindow	
				ObjectType	对象类型：BUSINESS_CONTRACT
				ObjectNo	对象编号：合同编号
						上述两个参数的目的是保持扩展性,将来可能不仅仅用户不良资产的催收函管理.
						
		Output param:
		
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "催收详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(sObjectType==null) sObjectType="";
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sObjectNo==null) sObjectNo="";
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));			
	if(sSerialNo==null) sSerialNo="";
	String sSql = "select CustomerID,CustomerName from BADBIZ_ACCOUNT where serialno = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	String sCustomerID = "";
	String sCustomerName = "";
	if(rs.next()){
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
	}
	rs.getStatement().close();
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	ASDataObject doTemp = new ASDataObject("DunManageInfo",Sqlca);

	//定义自动累计字段
	doTemp.appendHTMLStyle("Corpus,InterestInSheet,InterestOutSheet,ElseFee"," onChange=\"javascript:parent.getDunSum()\" ");

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
		{"true","","Button","返回","返回","goBack()",sResourcesPath},
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
	    fCorpus = getItemValue(0,getRow(),"Corpus");
		fInterestInSheet = getItemValue(0,getRow(),"InterestInSheet");
		fInterestOutSheet = getItemValue(0,getRow(),"InterestOutSheet");
		fElseFee = getItemValue(0,getRow(),"ElseFee");
		fFeedbackContent = getItemValue(0,getRow(),"FeedbackContent");
		
     	if(fCorpus<0 || fInterestInSheet < 0 ||fInterestOutSheet <0 || fElseFee <0 ) 
     	{
     		alert("本金或利息应大于零！请重新输入！"); 	
     		return;
     	}
     	if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
     	//催收金额由四项合计获得
	function getDunSum()
	{
		fCorpus = getItemValue(0,getRow(),"Corpus");
		fInterestInSheet = getItemValue(0,getRow(),"InterestInSheet");
		fInterestOutSheet = getItemValue(0,getRow(),"InterestOutSheet");
		fElseFee = getItemValue(0,getRow(),"ElseFee");
     		
		if(typeof(fCorpus)=="undefined" || fCorpus.length==0) fCorpus=0; 
		if(typeof(fInterestInSheet)=="undefined" || fInterestInSheet.length==0) fInterestInSheet=0; 
		if(typeof(fInterestOutSheet)=="undefined" || fInterestOutSheet.length==0) fInterestOutSheet=0; 
		if(typeof(fElseFee)=="undefined" || fElseFee.length==0) fElseFee=0; 
     		
		fDunSum = fCorpus+fInterestInSheet+fInterestOutSheet+fElseFee;
		setItemValue(0,getRow(),"DunSum",fDunSum);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
				
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		sDunDate =  getItemValue(0,getRow(),"DunDate");
		if("<%=sObjectType%>"=="BadBizAccount"&& typeof(sDunDate)!="undefined" && sDunDate.length!=0)
		{
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@LastDunDate@"+sDunDate+",BADBIZ_ACCOUNT,String@SerialNo@<%=sObjectNo%>");
		}
	}
	
	function goBack()
	{
		OpenPage("/RecoveryManage/DunManage/DunList.jsp","_self","");
	}

	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser()
	{
		setObjectInfo("User","OrgID=<%=CurOrg.OrgID%>@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0);
		/*
		* setObjectInfo()函数说明：---------------------------
		* 功能： 弹出指定对象对应的查询选择对话框，并将返回的对象设置到指定DW的域
		* 返回值： 形如“ObjectID@ObjectName”的返回串，可能有多段，例如“UserID@UserName@OrgID@OrgName”
		* sObjectType： 对象类型
		* sValueString格式： 传入参数 @ ID列名 @ ID在返回串中的位置 @ Name列名 @ Name在返回串中的位置
		* iArgDW:  第几个DW，默认为0
		* iArgRow:  第几行，默认为0
		* 详情请参阅 common.js -----------------------------
		*/
	}


	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			
			setItemValue(0,0,"DunDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");

			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");			
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");			

			setItemValue(0,0,"Corpus","0.00");
			setItemValue(0,0,"InterestInSheet","0.00");
			setItemValue(0,0,"InterestOutSheet","0.00");
			setItemValue(0,0,"ElseFee","0.00");

			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");	
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");	
			setItemValue(0,0,"DunObjectType","01");
			setItemValue(0,0,"DunObjectName","<%=sCustomerName%>");
			
			
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "Dun_Info";//表名
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
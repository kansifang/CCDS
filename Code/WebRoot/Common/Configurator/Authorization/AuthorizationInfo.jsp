<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: wlu 2009-2-13 
		Tester:
		Describe: 用户权限信息
		Input Param:
			UserID:	   用户编号
		Output Param:
			

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数	
	String sSql;
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));	
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%       
    String[][] sHeaders = {
							{"SerialNo","编号"},
							{"AuthorizationType","授权类型"},
							{"UserName","用户名"},
							{"BusinessTypeName","业务品种<br>(若选择单笔授权必须选择业务品种)"},
							{"BusinessSumCurrency","授权币种"},
							{"BusinessSum","授权金额"},
							{"BusinessExposureCurrency","授权敞口币种"},
							{"BusinessExposure","授权敞口金额"},
							{"Remark","备注"},
							{"InputUserName","登记人"},							
							{"InputOrgName","登记机构"},
							{"InputDate","登记日期"},
							{"UpdateDate","更新日期"}							
		                 };
	sSql =  " select SerialNo,AuthorizationType,UserID,getUserName(UserID) as UserName, "+
			" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,BusinessSumCurrency, "+
			" BusinessSum,BusinessExposureCurrency,BusinessExposure,Remark, "+			
			" InputUserID,getUserName(InputUserID) as InputUserName,InputOrgID, "+
			" getOrgName(InputOrgID) as InputOrgName,InputDate,UpdateDate "+
		    " from USER_AUTHORIZATION "+
		    " where SerialNo = '"+sSerialNo+"'";
		    
    //产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置修改表名
	doTemp.UpdateTable = "USER_AUTHORIZATION";
	//设置主键
	doTemp.setKey("SerialNo",true);
    //设置必须项
 	doTemp.setRequired("UserName,AuthorizationType,BusinessSumCurrency,BusinessSum,BusinessExposureCurrency,BusinessExposure",true);
 	//如果产品编号不为空，则不允许修改
 	if(!sSerialNo.equals(""))
 		doTemp.setReadOnly("AuthorizationType,UserName,BusinessTypeName",true);
 	//设置下拉datawindows
	doTemp.setDDDWCode("BusinessSumCurrency,BusinessExposureCurrency","Currency");	    
	doTemp.setDDDWCode("AuthorizationType","AuthorizationType");
	//设置默认值
	doTemp.setDefaultValue("BusinessSumCurrency","01");
	doTemp.setDefaultValue("BusinessExposureCurrency","01");
	//设置列的宽度
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Remark",200);
 	doTemp.setHTMLStyle("InputOrgID"," style={width:160px} ");
 	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");
 	//三位一逗显示 	
 	doTemp.setType("BusinessSum,BusinessExposure","number");
	doTemp.setAlign("BusinessSum,BusinessExposure","3");
	//设置只读列
	doTemp.setReadOnly("UserName,BusinessTypeName,InputUserName,InputUserID,InputOrgName,InputOrgID,UpdateDate,InputDate,SerialNo",true);
	//设置不可见列
	doTemp.setVisible("UserID,InputUserID,InputOrgID,BusinessType",false);	
	//设置不可修改列    	
	doTemp.setUpdateable("BusinessTypeName,UserName,InputUserName,InputOrgName",false);	
	if(sSerialNo == "")
	{
		doTemp.setUnit("BusinessTypeName"," <input type=button class=inputdate value=.. onclick=parent.selectBusinessType(\"ALL\")>");
		doTemp.setUnit("UserName"," <input type=button class=inputdate value=.. onclick=parent.selectUser(\"ALL\")>");
	}		
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
	String sButtons[][] = 
		{
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
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
		//录入数据有效性检查
		if (!ValidityCheck()) return;			
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{	
		//OpenPage("/Common/Configurator/Authorization/AuthorizationList.jsp?SerialNo="+<%=sSerialNo%>,"_self","");
		top.returnValue = "_CANCEL_";
		top.close();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>	
	var bIsInsert = false; //标记DW是否处于“新增状态”
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段	
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");	
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");		
		setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");		
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
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{			
			as_add("myiframe0"); //新增记录						
			bIsInsert = true;
		}		
    }
    
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "USER_AUTHORIZATION";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectBusinessType(sType)
	{		
		if(sType == "ALL")
		{			
			setObjectValue("SelectAllBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
		}	
	}	
	
	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser(sType)
	{		
		if(sType == "ALL")
		{			
			setObjectValue("SelectAllUser","","@UserID@0@UserName@1",0,0,"");			
		}	
	}	
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{		
		//检查录入的授权类型、用户和业务品种是否存在
		sSerialNoOld=getItemValue(0,0,"SerialNo");//流水号
		sUserID = getItemValue(0,0,"UserID");	//用户编号
		sBusinessType = getItemValue(0,0,"BusinessType");//--业务品种
		sAuthorizationType = getItemValue(0,0,"AuthorizationType");//--授权类型
		//单笔授权下业务品种一定要存在
		if(sAuthorizationType=='01'){
			if(typeof(sBusinessType) == "undefined" || sBusinessType == ""){
				alert("单笔授权下，业务品种不能为空！");
				return false;
			}
		}
		
		if(typeof(sUserID) != "undefined" && sUserID != "" && typeof(sAuthorizationType) != "undefined" && sAuthorizationType != "")
		{
	        //获得流程编号
	        var sColName = "SerialNo";
			var sTableName = "USER_AUTHORIZATION";
			//如果授权类型为单户授权，则要检查是否已存在要录入的用户；如果授权类型为单笔授权，则要检查用户和业务品种是否存在
			if(sAuthorizationType == "01")
			{
				var sWhereClause = "String@UserID@"+sUserID+"@String@BusinessType@"+sBusinessType+"@String@AuthorizationType@"+sAuthorizationType;
			}else
			{
				var sWhereClause = "String@UserID@"+sUserID+"@String@AuthorizationType@"+sAuthorizationType;
			}
			//执行类方法取SerialNo判断有效性
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++)
				{
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++)
					{
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++)
					{									
						//查询流水号
						if(my_array2[n] == "serialno")
							sSerialNo = sReturnInfo[n+1];					
					}
				}
				//通过拆分出的流水号判断检查结果
				if(typeof(sSerialNo)!="undefined" && sSerialNo != "")
				{
					isExist=true;
					if(typeof(sSerialNoOld)!="undefined" && sSerialNoOld != ""&&sSerialNo==sSerialNoOld)
						isExist=false;
					if(isExist)
					{
						if(sAuthorizationType == "01")
							alert("对不起，已存在该授权类型下该用户对该业务品种的授权！");
						else
							alert("对不起，已存在该授权类型下对该用户的授权！");
						return false;
					}
				}
			}			
		}
		return true;
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

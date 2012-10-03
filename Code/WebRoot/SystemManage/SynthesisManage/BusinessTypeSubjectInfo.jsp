<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --wangdw 2012-05-23
		Tester:
		Describe: --业务品种与科目号维护信息;
		Input Param:
			EditRight:权限代码（01：查看权；02：维护权）
		Output Param:
			
		HistoryLog:
           DATE	     CHANGER		CONTENT
           2005.7.25 fbkang         新版本的改写		
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "业务品种与科目号维护信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
    String sTempletNo = "BusinessTypeSubjectInfo";//模板号

	//获得组件参数，客户代码、关联客户代码、关联关系、编辑权限
	//String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//if(sCustomerID == null) sCustomerID = "";
	
	//获得页面参数
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerScale",2));
	String sSERIALNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//将空值转化为空字符串
	if(sEditRight == null) sEditRight = "";
	if(sCustomerScale == null) sCustomerScale = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setUnit("BusinessTypeName"," <input class=\"inputdate\" type=button value=\"...\" onclick=parent.selectBusiness_type()><font color=red>(可输可选)</font>");
	doTemp.setUnit("IsFarmer"," <font color=red>当业务品种选择“好易贷”、“直易贷”时候需要录入此字段</font>");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	//设置插入和更新事件，反方向插入和更新客户信息表
//	dwTemp.setEvent("BeforeUpdate","!CustomerManage.InsertHistoryInfoLog(#SerialNo,"+CurUser.UserID+",ChangeFinancePlatFormList)");
//	dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#CustomerName,#CertType,#CertID,,#InputUserId)+!CustomerManage.UpdateCustomerFinancePlatformInfo(#CustomerID,#FinancePlatformFlag,#PlatformType,#DealClassify)");
//	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateCustomerFinancePlatformInfo(#CustomerID,#FinancePlatformFlag,#PlatformType,#DealClassify)");
	Vector vTemp = dwTemp.genHTMLDataWindow(""+","+sSERIALNO);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	//依次为:
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
		{"true","","Button","新增","新增","newRecord()",sResourcesPath},
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
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/SystemManage/SynthesisManage/BusinessTypeSubjectInfo.jsp?EditRight=02","_self","");
	}	

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{	
		//录入数据有效性检查
		if (!ValidityCheck()) return;	
		if(bIsInsert)
		{
			beforeInsert();
			//特殊增加,如果为新增保存,保存后页面刷新一下,防止主键被修改
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/BusinessTypeSubjectList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
		/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
	   sCertType = "Ent01";
       sCertId = getItemValue(0,0,"CertID");//--组织机构代码证	//初始化流水号字段
       initSerialNo();
       //判断该组织机构代码是否在系统中存在，如果存在则使用原客户号，如果不存在则使用新生成的客户号
       sReturn = RunMethod("CustomerManage","GetCustomerIdByCardId",sCertType+","+sCertId);
       if(sReturn != "Null" && typeof(sReturn) != "undefined")
       {
       		setItemValue(0,getRow(),"CustomerID",sReturn);
       }else{
       	var sTableName = "CUSTOMER_INFO";//表名
		var sColumnName = "CustomerID";//字段名
		var sPrefix = "";//前缀
       	var sCustomerID = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			setItemValue(0,getRow(),"CustomerID",sCustomerID);
		}
	}
	
	function pageReload()
	{
		//OpenPage("/SystemManage/SynthesisManage/BusinessTypeSubjectInfo.jsp?EditRight=<%=sEditRight%>", "_self","");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--重新获得流水号
		OpenPage("/SystemManage/SynthesisManage/BusinessTypeSubjectInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
		
	}
	
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectBusiness_type()
	{
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码
		var sReturn = "";
		var sBusinessType = "";
		var sBusinessTypeName = "";
		var sReturn = setObjectValue("selectBusiness_type","","",0,0,"");
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined")
		{
			return;
		}else{
		sReturn= sReturn.split('@');
		sBusinessType = sReturn[0];
		sBusinessTypeName = sReturn[1];
		setItemValue(0,0,"BusinessType",sBusinessType);
		setItemValue(0,0,"BusinessTypeName",sBusinessTypeName);
		}
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");//--获得当前日期
		setItemValue(0,0,"UpdateDate",sDay);
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
	
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
			setItemValue(0,0,"InputUserId","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
		}
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_FINANCEPLATFORM";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
       
		//使用GetSerialNo.jsp来抢占一个流水号
		
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{	
	   //根据业务品种、期限类型、担保方式检查是否重复	
	   sBusinessType = getItemValue(0,0,"BusinessType");		//业务品种	
	   sTimeLimitType = getItemValue(0,0,"TimeLimitType");		//期限类型
	   sVouchType = getItemValue(0,0,"VouchType");		 		//担保方式
	   sIsFarmer =  getItemValue(0,0,"IsFarmer");		 		//是否涉农
	   if(sIsFarmer=="")
	   {
	   		sIsFarmer = "123"; //标识是否涉农为空
	   }
	   if(bIsInsert == true)
	   {
	   	   var sColName = "SerialNo";
		   var sTableName = "BUSINESSTYPE_SUBJECT";
		   var sWhereClause = "String@BusinessType@"+sBusinessType+"@String@TimeLimitType@"+sTimeLimitType+"@String@VouchType@"+sVouchType+"@String@IsFarmer@"+sIsFarmer;
		   sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		   if(sReturn != "" && typeof(sReturn) != "undefined" && sReturn != "Null" )
		   {
		   		alert("业务品种、期限、担保方式、是否涉农 组合键重复！");
		   		return false;
		   }
		   //判断只有“好易贷、直易贷” 可以录入“是否涉农””
		   if(sBusinessType !="1140090" && sBusinessType !="1140100" && sIsFarmer !="123")
		   {
		   		alert("只有“好易贷、直易贷” 可以录入“是否涉农””");
		   		return false;
		   }
	   }
	    return true;
	}
	
	/*~[Describe=根据证件类型和证件编号获得客户编号和客户名称;InputParam=无;OutPutParam=无;]~*/
	function getCustomerName()
	{
		var sCertType = getItemValue(0,getRow(),"CertType");//--证件类型
		var sCertID = getItemValue(0,getRow(),"CertID");//--证件号码
        if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
	        //获得客户名称
	        var sColName = "CustomerID@CustomerName";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
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
						//设置客户编号
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"CustomerID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
					}
				}			
			}
		}     
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
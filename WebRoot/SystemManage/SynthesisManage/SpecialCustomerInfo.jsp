<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 特殊客户管理
		Input Param:
		       --SerialNO:流水号
		Output param:
		History Log: 
		-- fbkang 重新整改页面

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "特殊客户管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSerialNo = "";//--流水号码
	String sSql = "";//--存放sql语句
	
	//获得页面参数	：黑名单流水号
    sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = {               
			                    {"CertID","证件号"},
			                    {"CertType","证件类型"},
			                    {"CustomerName","客户名称"},
						        {"BeginDate","开始日期"},
						        {"EndDate","结束日期"},
						        {"InListStatus","是否有效"},
						        {"Remark","备注"},
						        {"OrgName","登记机构"},
						        {"UserName","登记人"},
						        {"InputDate","登记日期"},
						        {"UpdateDate","更新日期"}
						   };   	
	 sSql = " select SerialNo,SectionType,CertType,CertID,CustomerID,CustomerName,BeginDate,EndDate,InListStatus, "+
		    " Remark,InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName,"+
		    " InputDate,UpdateDate from CUSTOMER_SPECIAL where SerialNo = '"+sSerialNo+"' ";
     //sql产生datawindows
	ASDataObject doTemp = new ASDataObject(sSql);
	//头名称
	doTemp.setHeader(sHeaders);
	//修改表
	doTemp.UpdateTable = "CUSTOMER_SPECIAL";
    //设置主键
	doTemp.setKey("SerialNo",true);
	//设置不可修改的列
	doTemp.setUpdateable("UserName,OrgName,Resouce",false);
    //设置不可见列
	doTemp.setVisible("SerialNo,SectionType,InputOrgID,InputUserID,CustomerID",false);
	//设置必输项
	doTemp.setRequired("InListStatus,Attribute1,InListReason,BeginDate,EndDate,CustomerName",true);
	//设置只读列
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate,CertID,CertType",true); 
	//设置日期的格式
	doTemp.setCheckFormat("BeginDate,InputDate,UpdateDate,EndDate","3");
	//设置宽度
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	//下拉窗口
    doTemp.setDDDWCode("InListStatus","YesNo");
    //证件类型
    doTemp.setDDDWCode("CertType","CertType");
    //缺省值为有效标志
    doTemp.setDefaultValue("Inliststatus","02");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setEvent("BeforeUpdate","!CustomerManage.InsertHistoryInfoLog(#SerialNo,"+CurUser.UserID+",ChangeSpecialCustList)");
	doTemp.setUnit("CustomerName"," <input type=button value=.. onclick=parent.selectCustomer()>");
	doTemp.setHTMLStyle("CertID"," onchange=parent.getCustomerName() ");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		OpenPage("/SystemManage/SynthesisManage/SpecialCustomerList.jsp","_self","");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--重新获得流水号
		OpenPage("/SystemManage/SynthesisManage/SpecialCustomerInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
	}
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		//校验开始是否大于结束日期
		sBeginDate = getItemValue(0,0,"BeginDate");//开始日期
		sEndDate = getItemValue(0,0,"EndDate");//结束日期		
		if(typeof(sBeginDate) != "undefined" && sBeginDate != "" && typeof(sEndDate) != "undefined" && sEndDate != "")
		{
			if(sBeginDate >= sEndDate)
			{		    
				alert("开始日期必须早于结束日期,请更正！");
				return false;		    
			}
		}
			return true;
	}
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
       initSerialNo();//初始化流水号字段
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");//--获得当前日期
		setItemValue(0,0,"UpdateDate",sDay);
	}
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{   
		//返回、客户代码、客户名称、证件类型、证件号码
		setObjectValue("SelectOwner","","@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0);
	}
	
	/*~[Describe=得到客户名字;InputParam=无;OutPutParam=无;]~*/
	function getCustomerName()
	{
		var sCertType   = getItemValue(0,getRow(),"CertType");//--证件类型
		var sCertID   = getItemValue(0,getRow(),"CertID");//--证件号码
        //获得客户名称
        var sColName = "CustomerID@CustomerName";
		var sTableName = "CUSTOMER_INFO";
		var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
		if(typeof(sCertType) != "undefined" && sCertType != ""&&typeof(sCertID) != "undefined" && sCertID != "")
		{
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		}else return;
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
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;

			sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
			setItemValue(0,0,"SectionType","70");//--特殊客户列表
		}
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_SPECIAL";//表名
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

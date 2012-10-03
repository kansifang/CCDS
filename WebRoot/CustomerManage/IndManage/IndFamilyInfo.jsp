<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 配偶及家庭主要成员;
		Input Param:
			--CustomerID: 当前客户编号
			--RelativeID: 关联客户编号
			--Relationship: 关联关系
			--EditRight:权限代码（01：查看权；02：维护权）
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "配偶及家庭主要成员"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得组件参数，客户代码
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//获得页面参数，关联客户编号、关联关系
	String sRelativeID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = {
							{"CertType","证件类型"},
							{"CertID","证件号码"},
							{"CustomerName","姓名"},							
							{"RelationShip","与该客户关系"},
							{"Telephone","联系电话"},	
							{"Describe","工作单位"},
							{"WorkAdd","单位地址"},
							{"WorkZip","单位邮编"},
							{"WorkTel","单位电话"},
							{"Occupation","成员职业"},
							{"HealthStatus","健康状况"},
							{"Birthday","出生日期"},
							{"EffStatus","是否有效"},						
							{"Remark","备注"},
							{"OrgName","登记机构"},
							{"UserName","登记人"},
							{"InputDate","输入日期"},
							{"UpdateDate","更新日期"}
						 };
	String sSql =   " select CustomerID,RelativeID,CertType,CertID,"+
					" CustomerName,RelationShip,Telephone,Describe,"+
					" WorkAdd,WorkZip,WorkTel,"+
					" Occupation,HealthStatus,Birthday,EffStatus," +
					" Remark,InputUserId,getUserName(InputUserId) as UserName," +
					" InputOrgId,getOrgName(InputOrgId) as OrgName," +
					" InputDate,UpdateDate " +
					" from CUSTOMER_RELATIVE" +
					" where CustomerID='"+sCustomerID+"'" +
					" and RelativeID='"+sRelativeID+"' " +
					" and RelationShip='"+sRelationShip+"' " ;

	//由sSql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头,更新表名,键值,必输项,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	doTemp.setRequired("RelationShip,CustomerName,CertType,CertID,Occupation,HealthStatus,Birthday,EffStatus",true);
	doTemp.setVisible("CustomerID,RelativeID,InputUserId,InputOrgId",false);
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setLimit("Remark",200);
	//设置字段格式
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("Describe"," style={width:250px}; ");
	doTemp.setHTMLStyle("CustomerName"," style={width:80px} ");
	doTemp.setHTMLStyle("WorkAdd"," style={width:400px} ");
	//注意,先设HTMLStyle，再设ReadOnly，否则ReadOnly不会变灰
	doTemp.setHTMLStyle("CustomerName,OrgName,UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);

	//设置下拉框
	doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'RelationShip' and ItemNo like '03%' and length(ItemNo)>2 and IsInUse = '1' ");
	doTemp.setDDDWSql("CertType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and ItemNo like 'Ind%' and IsInUse = '1' ");
	doTemp.setDDDWCode("EffStatus","EffStatus");
	doTemp.setDDDWCode("Occupation","Occupation");
	doTemp.setDDDWCode("HealthStatus","HealthStatus");

	//日期为3
	doTemp.setCheckFormat("Birthday","3");
	//设置默认值

	//若关联客户编号为空，则出现选择客户提示框
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input type=button value=.. onclick=parent.selectCustomer()>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}
	//doTemp.setHTMLStyle("CertID"," onchange=parent.getBirthday() ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	
	//设置插入和更新事件，反方向插入和更新
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.AddCustomerInfo(#RelativeID,#CustomerName,#CertType,#CertID,,#InputUserId)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateRelation(#CustomerID,#RelativeID,#RelationShip)");

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{(sEditRight.equals("02")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
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
			//保存前进行检查,检查通过后继续保存,否则给出提示
		    if (!RelativeCheck()) return;
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
		OpenPage("/CustomerManage/IndManage/IndFamilyList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");
		var sRelationShip = getItemValue(0,getRow(),"RelationShip");
		OpenPage("/CustomerManage/IndManage/IndFamilyInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight=<%=sEditRight%>", "_self","");
	}
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getBirthday()
	{
		var sCertID = getItemValue(0,getRow(),"CertID");//--证件号码
		var sCertType = getItemValue(0,getRow(),"CertType");//--证件类型
		if(sCertType=="Ind01")
		{
			//将身份证中的日期自动赋给出生日期
			if(sCertID.length == 15)
			{
				sSex = sCertID.substring(14);
				sSex = parseInt(sSex);
				sCertID = sCertID.substring(6,12);
				sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
				setItemValue(0,getRow(),"Birthday",sCertID);
			}
			if(sCertID.length == 18)
			{
				sSex = sCertID.substring(16,17);
				sSex = parseInt(sSex);
				sCertID = sCertID.substring(6,14);
				sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
				setItemValue(0,getRow(),"Birthday",sCertID);	
			}
		}
	}
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		sParaStr = "OrgID"+","+"<%=CurOrg.OrgID%>";		
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码		
		//setObjectValue("SelectManager",sParaStr,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
		//modify by xhyong 2009/08/03
		setObjectValue("SelectFamily",sParaStr,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4@Occupation@5@HealthStatus@6@Birthday@7@Telephone@8@Describe@9",0,0,"");
		var sCertID = getItemValue(0,getRow(),"CertID");//--证件号码
		//将身份证中的日期自动赋给出生日期
		if(sCertID.length == 15)
		{
			sSex = sCertID.substring(14);
			sSex = parseInt(sSex);
			sCertID = sCertID.substring(6,12);
			sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
			setItemValue(0,getRow(),"Birthday",sCertID);
		}
		if(sCertID.length == 18)
		{
			sSex = sCertID.substring(16,17);
			sSex = parseInt(sSex);
			sCertID = sCertID.substring(6,14);
			sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
			setItemValue(0,getRow(),"Birthday",sCertID);	
		}
	}

	//modify by xhyong 2009/08/03
/**	
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
							setItemValue(0,getRow(),"RelativeID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"RelativeID","");
				setItemValue(0,getRow(),"CustomerName","");								
			} 
		}				     
	}
**/
	/*~[Describe=根据证件类型和证件编号获得客户编号和客户名称;InputParam=无;OutPutParam=无;]~*/
	function getCustomerName()
	{
		var sCertType = getItemValue(0,getRow(),"CertType");//--证件类型
		var sCertID = getItemValue(0,getRow(),"CertID");//--证件号码
        if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
		    //获得客户名称
		    var sColName = "CustomerID@FullName@Occupation@HealthStatus@Birthday";
			var sTableName = "IND_INFO";
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
							setItemValue(0,getRow(),"RelativeID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "fullname")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
						//设置成员职业
						if(my_array2[n] == "occupation")
							setItemValue(0,getRow(),"Occupation",sReturnInfo[n+1]);
						//设置健康状况
						if(my_array2[n] == "healthstatus")
							setItemValue(0,getRow(),"HealthStatus",sReturnInfo[n+1]);
						//设置出生日期
						if(my_array2[n] == "birthday")
							setItemValue(0,getRow(),"Birthday",sReturnInfo[n+1]);
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"RelativeID","");
				setItemValue(0,getRow(),"CustomerName","");
				setItemValue(0,getRow(),"Occupation","");
				setItemValue(0,getRow(),"HealthStatus","");	
				setItemValue(0,getRow(),"Birthday","");									
			} 
			getBirthday();
		}				     
	}
	//add end
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		//对已经存在配偶关系进行提示
		var sCertType = getItemValue(0,getRow(),"CertType");//--证件类型
		var sCertID = getItemValue(0,getRow(),"CertID");//--证件号码
		var sRelationShip = getItemValue(0,getRow(),"RelationShip");//与客户的关系
		sReturnValue=RunMethod("CustomerManage","AlertCustomerRelationShip","0301,"+sCertType+","+sCertID);
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "" )
		{
			alert(sReturnValue);
		}
		bIsInsert = false;
	}

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		getBirthday();
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		//检查组织机构代码和身份证号码是否符合编码规则
		sCertType = getItemValue(0,0,"CertType");//证件类型		
		sCertID = getItemValue(0,0,"CertID");//证件编号	
				
		//判断身份证合法性,个人身份证号码应该是15或18位！
		if(typeof(sCertType) != "undefined" && sCertType != "" )
		{
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if (!CheckLisince(sCertID))
					{
						alert(getBusinessMessage('156'));//身份证号码有误！				
						return false;
					}
				}
			}
		}
		
		//检查录入的客户是否为其本身
		sCustomerID   = getItemValue(0,0,"CustomerID");	//客户编号
		sRelativeID   = getItemValue(0,0,"RelativeID");//--关联客户代码
		if (typeof(sRelativeID) != "undefined" && sRelativeID != '')
		{
			if(sCustomerID == sRelativeID)	
			{
				alert(getBusinessMessage('141'));//录入的客户不能为其本身！
				return false;
			}
		}
		
		//校验联系电话
		sTelephone = getItemValue(0,getRow(),"Telephone");//联系电话	
		if(typeof(sTelephone) != "undefined" && sTelephone != "" )
		{
			if(!CheckPhoneCode(sTelephone))
			{
				alert(getBusinessMessage('121'));//联系电话有误！
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
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	/*~[Describe=关联关系插入前检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function RelativeCheck()
	{
		sCustomerID   = getItemValue(0,0,"CustomerID");	//客户编号			
		sCertType = getItemValue(0,0,"CertType");//证件类型	
		sCertID = getItemValue(0,0,"CertID");//证件编号	
		sRelationShip = getItemValue(0,0,"RelationShip");//关联关系
		if (typeof(sRelationShip) != "undefined" && sRelationShip != "")
		{
			var sMessage = PopPage("/CustomerManage/EntManage/RelativeCheckAction.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sMessage)=="undefined" || sMessage.length==0) {
				return false;
			}
			setItemValue(0,0,"RelativeID",sMessage);
		}
		return true;
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
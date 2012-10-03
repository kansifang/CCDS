<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --FMWu 2004-11-29
		Tester:
		Describe: --关键人信息;
		Input Param:
			CustomerID: --当前客户编号
			RelativeID: --关联客户编号
			Relationship: --关联关系
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
	String PG_TITLE = "关键人信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
    String sTempletNo = "EntKeymanInfo";//模板号

	//获得组件参数，客户代码、关联客户代码、关联关系、编辑权限
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//获得页面参数
	String sRelativeID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerScale",2));
	//将空值转化为空字符串
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";
	if(sCustomerScale == null) sCustomerScale = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//若关联客户编号为空，则出现选择客户提示框
	if(!(sRelativeID == null || sRelativeID.equals("")))
	{
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}

	//设置下拉框
	doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'RelationShip' and ItemNo like '01%' and length(ItemNo)>2 order by SortNo ");
	doTemp.setDDDWSql("CertType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and ItemNo not like 'Ent%' order by SortNo ");
    	
	//若关联客户编号为空，则出现选择客户提示框
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input class=\"inputdate\" type=button value=\"...\" onclick=parent.selectCustomer()><font color=red>(可输可选)</font>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}
	
	//设置相关行业从业年限范围
	doTemp.appendHTMLStyle("EngageTerm"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"相关行业从业年限必须大于等于0！\" ");
		
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
  	
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sRelativeID+","+sRelationShip);
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
		{"true","","Button","新增","新增高管信息","newRecord()",sResourcesPath},
		{(sEditRight.equals("02")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","高管信息详情","查看高管信息详情","viewKeymanInfo()",sResourcesPath},
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
	//add by wlu 2009-02-19
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntKeymanInfo.jsp?EditRight=02","_self","");
	}	

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{	
		//录入数据有效性检查
		if (!ValidityCheck()) return;	
		if(bIsInsert)
		{
			//保存前进行关联关系检查
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

	/*~[Describe=返回高管信息详情页面;InputParam=无;OutPutParam=无;]~*/
	//add by wlu 2009-02-19
	function viewKeymanInfo()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		if(typeof(sRelativeID) == "undefined" || sRelativeID == "")
		{
			alert("对不起，请选择一位高管！");
			return;
		}
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sRelativeID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }

        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];
        sReturnValue2 = sReturnValue[1];
        sReturnValue3 = sReturnValue[2];
                        
        if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2")
        {    		
    		openObject("Customer",sRelativeID+"&<%=sCustomerScale%>","001");
    		//reloadSelf();
		}else
		{
		    alert("对不起，你没有查看该客户的权限或不存在高管信息详情！");//对不起，你没有查看该客户的权限！
		}
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntKeymanList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload()
	{
		sRelativeID   = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		sRelationShip   = getItemValue(0,getRow(),"RelationShip");//--关联关系
		OpenPage("/CustomerManage/EntManage/EntKeymanInfo.jsp?RelationShip="+sRelationShip+"&RelativeID="+sRelativeID+"&EditRight=<%=sEditRight%>", "_self","");
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
			
			//将身份证的出生日期自动赋给出生日期字段
			if (!GetBirthday()) return;  
		}     
	}
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码
		sParaString = "OrgID"+","+"<%=CurUser.OrgID%>";		
		sReturn = setObjectValue("SelectManager",sParaString,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
		//将身份证的出生日期自动赋给出生日期字段,xing
		if (!GetBirthday()) return;
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			setFieldDisabled("CustomerName");
			setFieldDisabled("CertType");
			setFieldDisabled("CertID");
		}
	}
	
	//设置域不可用
	function setFieldDisabled(sField)
	{
	  setItemDisabled(0,0,sField,true);
      //getASObject(0,0,sField).style.background ="#efefef";
      //setItemValue(0,0,sField,"");
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
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
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
		}
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{		
		//检查证件编号是否符合编码规则
		sCertType = getItemValue(0,0,"CertType");//--证件类型	
		sCertID = getItemValue(0,0,"CertID");//--证件号码
				
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
								
					//将身份证中的日期自动赋给出生日期,把性别置上(add by fhuang 06.11.28)
					if(sCertID.length == 15)
					{
						sSex = sCertID.substring(14);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,12);
						sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
						setItemValue(0,getRow(),"Birthday",sCertID);
						if(sSex%2==0)//奇男偶女
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sCertID.length == 18)
					{
						sSex = sCertID.substring(16,17);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,14);
						sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
						setItemValue(0,getRow(),"Birthday",sCertID);
						if(sSex%2==0)//奇男偶女
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
				}
			}
			//验证客户只有一个法人代表
			var sCustomerID = "<%=sCustomerID%>";
			var sRelationShip = getItemValue(0,getRow(),"RelationShip");
			var sRelativeID = getItemValue(0,getRow(),"RelativeID");
			if(sRelationShip == "0100"){
				sCustomerName = RunMethod("BusinessManage","getFictitiousPerson",sCustomerID+","+sRelativeID);
				if(sCustomerName !="Null" && sCustomerName !="NULL" && typeof(sCustomerName) != "undefined" && sCustomerName.length!=0 )
				{
					alert("该客户已经录入法人代表信息！！！");
					return false;
				}	
			}	
		}
		
		sBirthday = getItemValue(0,getRow(),"Birthday");//出生日期			
		sHoldDate = getItemValue(0,getRow(),"HoldDate");//担任该职务时间
		//校验出生日期、担任该职务时间是否大于当前日期
		sToday = "<%=StringFunction.getToday()%>";
		if(typeof(sBirthday) != "undefined" && sBirthday != "" )
		{
			if(sBirthday >= sToday)
			{		    
				alert(getBusinessMessage('134'));//出生日期必须早于当前日期！
				return false;		    
			}
		}
		if(typeof(sHoldDate) != "undefined" && sHoldDate != "" )
		{
			if(sHoldDate >= sToday)
			{		    
				alert(getBusinessMessage('135'));//担任该职务时间必须早于当前日期！
				return false;		    
			}
		}		
		//校验出生日期是否大于担任该职务时间
		if(typeof(sBirthday) != "undefined" && sBirthday != "" && 
		typeof(sHoldDate) != "undefined" && sHoldDate != "")
		{		
			if(sHoldDate <= sBirthday)
			{		    
				alert(getBusinessMessage('136'));//担任该职务时间必须晚于出生日期！
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
				
		return true;
	}

	/*~[Describe=关联关系插入前检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function RelativeCheck()
	{
		/*~
		sCustomerID   = getItemValue(0,0,"CustomerID");//--客户代码		
		sCertType = getItemValue(0,0,"CertType");//--证件类型	
		sCertID = getItemValue(0,0,"CertID");//--证件号码			
		sRelationship = getItemValue(0,0,"RelationShip");//--关联关系
		if (typeof(sRelationship) != "undefined" && sRelationship != "")
		{
			var sMessage = PopPage("/CustomerManage/EntManage/RelativeCheckAction.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationship+"&CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sMessage)=="undefined" || sMessage.length==0) 
			{
				return false;
			}
			setItemValue(0,getRow(),"RelativeID",sMessage);
		}
		~*/
		//检查是否录入重复录入信息
		sCustomerID   = getItemValue(0,0,"CustomerID");//--客户代码
		sRelationShip   = getItemValue(0,0,"RelationShip");//--关联关系
		sRelativeID   = getItemValue(0,0,"RelativeID");//--关联客户代码
		sCertType  = getItemValue(0,0,"CertType");//--证件类型
		sCertID  = getItemValue(0,0,"CertID");//--证件号码
		if(typeof(sRelativeID) == "undefined" || sRelativeID.length == "")
		{
			var sRelativeID = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=CUSTOMER_INFO&ColumnName=CustomerID","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			setItemValue(0,getRow(),"RelativeID",sRelativeID);
		}
		sPara = "1,Customer_Relative,String@CustomerID@"+sCustomerID+
					"@String@CertType@"+sCertType+"@String@CertID@"+sCertID+"@String@RelationShip@"+sRelationShip;
		sReturn=RunMethod("PublicMethod","GetColValue",sPara);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			alert("该高管已经录入,请选择其他高管!");//该高管已经录入,请选择其他高管!				
			return false;
		}
		return true;
	}
	
	/*~[Describe=根据身份证号获取出生日期;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function GetBirthday()
	{		
		sCertType = getItemValue(0,0,"CertType");//--证件类型	
		sCertID = getItemValue(0,0,"CertID");//--证件号码
	
			
		//判断身份证合法性,个人身份证号码应该是15或18位！
		if(sCertType =='Ind01' || sCertType =='Ind08')
		{
			if (!CheckLisince(sCertID))
			{
				alert(getBusinessMessage('156'));//个人身份证号码有误！				
				return false;
			}
			
			//将身份证中的日期自动赋给出生日期,把性别置上(add by fhuang 06.11.28)
			if(sCertID.length == 15)
			{
				sSex = sCertID.substring(14);
				sSex = parseInt(sSex);
				sCertID = sCertID.substring(6,12);
				sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
				setItemValue(0,getRow(),"Birthday",sCertID);
				if(sSex%2==0)//奇男偶女
					setItemValue(0,getRow(),"Sex","2");
				else
					setItemValue(0,getRow(),"Sex","1");
			}
			if(sCertID.length == 18)
			{
				sSex = sCertID.substring(16,17);
				sSex = parseInt(sSex);
				sCertID = sCertID.substring(6,14);
				sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
				setItemValue(0,getRow(),"Birthday",sCertID);
				if(sSex%2==0)//奇男偶女
					setItemValue(0,getRow(),"Sex","2");
				else
					setItemValue(0,getRow(),"Sex","1");
			}
		}	
		return true;			
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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --FMWu 2004-11-29
		Tester:
		Describe: --股东情况;
		Input Param:
			CustomerID：--当前客户编号
			RelativeID：--关联客户组织机构代码
			Relationship：--关联关系	
			EditRight:--权限代码（01：查看权；02：维护权）		
		Output Param:

		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	参数、格式			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "资本构成情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
    String sSql = "";
	ASResultSet rs = null;
	double dPaiclUpCapital = 0.00;//实收资本
	
	//获得组件参数,客户代码
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	//获得页面参数，关联客户代码、关联关系、编辑权限
	String sRelativeID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerScale",2));
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";
	if(sCustomerScale == null) sCustomerScale = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	sSql = "select PaiclUpCapital from ENT_INFO where CustomerID='"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		dPaiclUpCapital = rs.getDouble("PaiclUpCapital");
	}
	rs.getStatement().close();
	
	String sHeaders[][] = {		
								{"CustomerName","股东名称"},
								{"CertType","客户证件类型"},
								{"CertID","证件号码"},
								{"FictitiousPerson","法人代表名称"},
								{"LoanCardNo","股东贷款卡编号"},
								{"RelationShip","出资方式"},
								{"CurrencyType","出资币种"},
								{"OughtSum","应出资金额"},
								{"InvestmentSum","实际投资金额"},
								{"InvestmentProp","出资比例"},
								{"InvestmentStatus","出资地位"},
								{"InvestDate","投资日期"},
								{"EffStatus","是否有效"},
								{"Remark","备注"},
								{"OrgName","登记机构"},
								{"UserName","登记人"},
								{"InputDate","登记日期"},
								{"UpdateDate","更新日期"}
						  };

	      sSql =	" select CustomerID,RelativeID,CertType,CertID,CustomerName, "+
					" LoanCardNo,FictitiousPerson,RelationShip,CurrencyType,OughtSum, "+
					" InvestmentSum,InvestmentProp,InvestmentStatus,InvestDate,EffStatus,Remark, "+
					" InputUserId,getUserName(InputUserId) as UserName,InputOrgId, "+
					" getOrgName(InputOrgId) as OrgName,InputDate,UpdateDate "+
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"' " +
					" and RelativeID='"+sRelativeID+"' " +
					" and RelationShip='"+sRelationShip+"' " ;

	//由sSql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头,更新表名,键值,必输项,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	//设置修改的表
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	//设置主键
	doTemp.setKey("CustomerID,RelativeID,CustomerName,RelationShip",true);
    //设置修改的列
	doTemp.setRequired("CustomerName,RelationShip,CertType,CertID,CurrencyType,OughtSum,InvestmentSum,EffStatus",true);   //应补登需要修改
	//设置列不可见
	doTemp.setVisible("CustomerID,RelativeID,InputUserId,InputOrgId",false);
	//设置不可修改的列
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setUnit("InvestYield","元");
	doTemp.setUnit("OughtSum,InvestmentSum","万元");
	doTemp.setUnit("InvestmentProp","%");
	doTemp.setLimit("Remark",200);
	//设置字段格式
	doTemp.setType("OughtSum,InvestmentSum,InvestmentProp","Number");
	doTemp.setCheckFormat("InvestmentProp","2");
	doTemp.setAlign("OughtSum,InvestmentSum，InvestmentProp","3");
	doTemp.setCheckFormat("InvestDate","3");
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	//注意,先设HTMLStyle，再设ReadOnly，否则ReadOnly不会变灰
	doTemp.setHTMLStyle("UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	doTemp.setReadOnly("OrgName,InvestmentProp,UserName,InputDate,UpdateDate",true);
	
	//设置下拉框来源
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'RelationShip' and ItemNo like '52%' and length(ItemNo)>2 ");
	doTemp.setDDDWCode("CurrencyType","Currency");
	doTemp.setDDDWCode("EffStatus","EffStatus");
	doTemp.setDDDWCode("InvestmentStatus","InvestmentStatus");
	
	//设置默认值
	doTemp.setDefaultValue("CurrencyType","01");

	//若关联客户编号为空，则出现选择客户提示框
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input type=button class=inputdate value=.. onclick=parent.selectCustomer()><font color=red>(可输可选)</font>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}
	
	//设置应出资金额(元)范围
	doTemp.appendHTMLStyle("OughtSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"应出资金额必须大于等于0！\" ");
	//设置实际投资金额(元)范围
	doTemp.appendHTMLStyle("InvestmentSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"实际投资金额必须大于等于0！\" ");
	doTemp.appendHTMLStyle("InvestmentSum"," onChange=\"javascript:parent.getInvestmentProp()\" mymsg=\"实际投资金额必须大于等于0！\" ");
	//设置出资比例(%)范围
   // doTemp.appendHTMLStyle("InvestmentProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"出资比例的范围为[0,100]\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	//设置插入和更新事件，反方向插入和更新
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.AddCustomerInfo(#RelativeID,#CustomerName,#CertType,#CertID,#LoanCardNo,#InputUserId)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateRelation(#CustomerID,#RelativeID,#RelationShip)");
  
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
			{"true","","Button","新增","新增资本构成","newRecord()",sResourcesPath},
			{(sEditRight.equals("02")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","股东信息详情","查看股东信息详情","viewOwnerInfo()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?EditRight=02","_self","");
	}	

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
	
	/*~[Describe=返回股东信息详情页面;InputParam=无;OutPutParam=无;]~*/
	//add by wlu 2009-02-19
	function viewOwnerInfo()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		if(typeof(sRelativeID) == "undefined" || sRelativeID == "")
		{
			alert("对不起，请选择一位股东！");
			return;
		}		
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
		    alert("对不起，你没有查看该客户的权限，或者此客户非系统内客户！");//对不起，你没有查看该客户的权限！
		}
	}
		
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntOwnerList.jsp?","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		var sRelationShip   = getItemValue(0,getRow(),"RelationShip");//--关联关系
		OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight=<%=sEditRight%>", "_self","");
	}

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
	    //返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号			
		setObjectValue("SelectOwner","","@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");	    
	}
	
	/*~[Describe=自动获得出资比例;InputParam=无;OutPutParam=无;]~*/
	function getInvestmentProp()
	{
		dInvestmentSum = getItemValue(0,getRow(),"InvestmentSum");//实际出资金额
		dPaiclUpCapital =  "<%=dPaiclUpCapital%>";//实收资本
		if(dPaiclUpCapital!=0.0)
		{
			dInvestmentProp=(dInvestmentSum/dPaiclUpCapital)*100;
			setItemValue(0,getRow(),"InvestmentProp",roundOff(dInvestmentProp,2));
		}
	}
	
	/*~[Describe=根据证件类型和证件编号获得客户编号和客户名称;InputParam=无;OutPutParam=无;]~*/
	function getCustomerName()
	{
		var sCertType   = getItemValue(0,getRow(),"CertType");//--证件类型
		var sCertID   = getItemValue(0,getRow(),"CertID");//--证件号码
        
        if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
	        //获得客户名称
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
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
						//设置贷款卡编号
						if(my_array2[n] == "loancardno") 
						{
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"LoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"LoanCardNo","");
						}
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"RelativeID","");
				setItemValue(0,getRow(),"CustomerName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			}  
		}
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");//--当前日期
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
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
			setItemValue(0,0,"CurrencyType","01");
		}
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{		
		//检查证件编号是否符合编码规则
		sCertType = getItemValue(0,0,"CertType");//--证件类型		
		sCertID = getItemValue(0,0,"CertID");//证件代码
		
		if(typeof(sCertType) != "undefined" && sCertType != "" )
		{
			//判断组织机构代码合法性
			if(sCertType =='Ent01')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if(!CheckORG(sCertID))
					{
						alert(getBusinessMessage('102'));//组织机构代码有误！						
						return false;
					}
				}
			}
				
			//判断身份证合法性,个人身份证号码应该是15或18位！
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
		
		//校验股东贷款卡编号
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//股东贷款卡编号	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
		{
			if(!CheckLoanCardID(sLoanCardNo))
			{
				alert(getBusinessMessage('230'));//股东贷款卡编号有误！							
				return false;
			}
			
			//检验股东贷款卡编号唯一性
			sCustomerName = getItemValue(0,getRow(),"CustomerName");//客户名称	
			sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sCustomerName+","+sLoanCardNo);
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
			{
				alert(getBusinessMessage('231'));//该股东贷款卡编号已被其他客户占用！							
				return false;
			}						
		}
		
		//校验投资日期是否大于当前日期
		sInvestDate = getItemValue(0,0,"InvestDate");//投资日期
		sToday = "<%=StringFunction.getToday()%>";//当前日期		
		if(typeof(sInvestDate) != "undefined" && sInvestDate != "" )
		{
			if(sInvestDate >= sToday)
			{		    
				alert(getBusinessMessage('137'));//投资日期必须早于当前日期！
				return false;		    
			}
		}
		
		//校验股东的出资比例(%)之和是否超过100%
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--主体客户代码
		sInvestmentSum = getItemValue(0,getRow(),"InvestmentSum");//--出资比例(%)
		if(typeof(sInvestmentSum) != "undefined" && sInvestmentSum != "" )
		{
			sStockSum = RunMethod("CustomerManage","CalculateStock",sCustomerID+","+sRelativeID);
			if(typeof(sStockSum) == "undefined" && sStockSum == "") sStockSum = 0;
			sTotalStockSum = parseFloat(sStockSum) + parseFloat(sInvestmentSum);
			if(sTotalStockSum > "<%=dPaiclUpCapital%>")
			{
				alert("所有股东的出资金额之和不能超过实收资本");//所有股东的出资比例(%)之和不能超过100%！
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
		sCustomerID   = getItemValue(0,0,"CustomerID");//--客户代码
		sRelationShip   = getItemValue(0,0,"RelationShip");//--关联关系
		sRelativeID   = getItemValue(0,0,"RelativeID");//--关联客户代码
		sCertType  = getItemValue(0,0,"CertType");//--证件类型
		sCertID  = getItemValue(0,0,"CertID");//--证件号码
		//查询系统中是否存在该证件类型证件号码对应的客户有则返回CustomerID无则新增CustomerID
		if (typeof(sRelationShip) != "undefined" && sRelationShip != '')
		{			
			var sMessage = PopPage("/CustomerManage/EntManage/RelativeCheckAction.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sMessage)!="undefined" && sMessage.length!=0) {
				sRelativeID=sMessage;
			}	
		}
		//检查是否录入重复录入信息
		if(typeof(sRelativeID) != "undefined" && sRelativeID.length!=0)
		{
			setItemValue(0,getRow(),"RelativeID",sRelativeID);
		}
		sPara = "1,Customer_Relative,String@CustomerID@"+sCustomerID+
					"@String@CertType@"+sCertType+"@String@CertID@"+sCertID+"@String@RelationShip@"+sRelationShip;
		sReturn=RunMethod("PublicMethod","GetColValue",sPara);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			alert("该股东已经录入,请选择其它股东!");//该股东已经录入,请选择其它股东!				
			return false;
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

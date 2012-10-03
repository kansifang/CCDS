<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: 业务合同所对应的抵押物基本信息详情;
		Input Param:
			ObjectType：对象类型
			ObjectNo: 对象编号
			ContractNo: 担保信息编号
			GuarantyID：质物编号
			PawnType：抵押物类型
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵押物基本信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sGuarantyStatus = "";//抵押物状态
	String sTempletNo = "";//--模板号码
	String sTempletFilter = "";//模板过滤变量
	String sSql = "";//Sql语句
	ASResultSet rs = null;//结果集
	String sPawnTypeName = "";//抵押物类型名称
	String sBCMaturity = "";//合同到期日
	String sBusinessType = "";//业务品种
	double dBusinessSum = 0;//合同金额
	
	//获得组件参数:
	String sOldObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sOldObjectType==null)sOldObjectType="";

	//获得页面参数：对象类型、对象编号、担保信息编号、抵押物编号、质物类型
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractNo"));
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyID"));
	String sPawnType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PawnType"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sContractNo == null) sContractNo = "";
	if(sGuarantyID == null) sGuarantyID = "";
	if(sPawnType == null) sPawnType = "";
	if(sObjectType.equals("ReinforceContract")) sObjectType="BusinessContract";	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%		        	
	//根据抵押物编号获取抵押物状态（01－未入库；02－入库；03－临时出库；04－出库）
	sGuarantyStatus = Sqlca.getString("select GuarantyStatus from GUARANTY_INFO where GuarantyID = '"+sGuarantyID+"'");
	if(sGuarantyStatus == null) sGuarantyStatus = "01";
	
	sSql = " select Maturity,BusinessType,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum "+
				  " from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sBCMaturity = rs.getString("Maturity");
		if(sBCMaturity == null) sBCMaturity = "";
		sBusinessType = rs.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = "";
		dBusinessSum = rs.getDouble("BusinessSum");
	}
	rs.getStatement().close();
	//根据抵押物类型取得显示模版号
	sSql = "select ItemName,ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo='"+sPawnType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sTempletNo = rs.getString("ItemDescribe");
		sPawnTypeName = rs.getString("ItemName");
	}
	rs.getStatement().close();
	
	//将空值转化为空字符串
	if(sTempletNo == null) sTempletNo = "";
	if(sPawnTypeName == null) sPawnTypeName = "";

	//设置过滤条件	
	sTempletFilter = " (ColAttribute like '%BusinessContract%' ) and (attribute1 is null or attribute1 = ' ' or attribute1 like '%"+sBusinessType+"%') ";

	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	//设置权利人选择框
	if("1030040".equals(sBusinessType)) 
		doTemp.setReadOnly("InsuranceType",true);
	doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()>");
	doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	doTemp.setUnit("EvalOrgName"," <input type=button value=.. onclick=parent.selectEvalOrgName()>");
	doTemp.setHTMLStyle("OwnerName"," style={width:400px} ");	
	if(sPawnType.equals("010020")){
		doTemp.appendHTMLStyle("OwnerTime"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	if(sGuarantyStatus.equals("01")||"ReinforceContract".equals(sOldObjectType)) 
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	else
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//设置setEvent
	dwTemp.setEvent("AfterInsert","!BusinessManage.InsertGuarantyRelative("+sObjectType+","+sObjectNo+","+sContractNo+",#GuarantyID,New,Add)+!CustomerManage.AddCustomerInfo(#OwnerID,#OwnerName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.InsertGuarantyRelative("+sObjectType+","+sObjectNo+","+sContractNo+",#GuarantyID,New,Add)+!CustomerManage.AddCustomerInfo(#OwnerID,#OwnerName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGuarantyID);
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
		{((sGuarantyStatus.equals("01")||"ReinforceContract".equals(sOldObjectType))?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
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
		if(vI_all("myiframe0"))
		{
		//录入数据有效性检查
			if (!ValidityCheck()) return;
			if(bIsInsert){		
				beforeInsert();
			}
	
			beforeUpdate();
			as_save("myiframe0",sPostEvents);	
		}		
	}
	function selectEvalOrgName()
	{
		//房屋只能由房地产评估机构评估，其他由资产评估公司
		var AuditOrgType = "";
		if("<%=sPawnType%>" == "010010"){
			AuditOrgType = "020";
		}else{
			AuditOrgType = "030";
		}
		sParaString = "AuditOrgType"+","+AuditOrgType;
		if("<%=sPawnType%>" == "010020"||"<%=sPawnType%>" == "010025")//土地||在建工程
		{
			setObjectValue("selectNewEvalOrgName2",sParaString,"@EvalOrgName@0",0,0,"");
		}else{
			setObjectValue("selectNewEvalOrgName",sParaString,"@EvalOrgName@0",0,0,"");
		}
	}
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/GuarantyManage/ContractPawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo=<%=sContractNo%>","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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
		
		//校验权利人贷款卡编号
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//权利人贷款卡编号	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
		{
			if(!CheckLoanCardID(sLoanCardNo))
			{
				alert(getBusinessMessage('235'));//权利人贷款卡编号有误！							
				return false;
			}
			
			//检验权利人贷款卡编号唯一性
			sOwnerName = getItemValue(0,getRow(),"OwnerName");//权利人名称	
			sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sOwnerName+","+sLoanCardNo);
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
			{
				alert(getBusinessMessage('236'));//该权利人贷款卡编号已被其他客户占用！							
				return false;
			}						
		}
		
		//检查输入的权利人是否建立信贷关系，如果未建立，需要新获取权利人的客户编号
		if(typeof(sCertType) != "undefined" && sCertType != "" 
		&& typeof(sCertID) != "undefined" && sCertID != "")
		{
			var sOwnerID = PopPage("/PublicInfo/CheckCustomerAction.jsp?CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sOwnerID)=="undefined" || sOwnerID.length==0) {
				return false;
			}
			setItemValue(0,0,"OwnerID",sOwnerID);
		}			
/*	
		if("<%=sOldObjectType%>" != "ReinforceContract"){
			//针对于所有品种，投保金额应不低于贷款本金
			sInsuranceSum = getItemValue(0,0,"InsuranceSum");//--保险金额
			if("<%=dBusinessSum%>" > sInsuranceSum && (typeof(sInsuranceSum) != "undefined" && sInsuranceSum != "")){
				alert("保险金额应不低于贷款本金!");
				return false
			}	

			//保险到期日需长于合同到期日；其中，房地产开发贷款对于保险的特殊要求：保险的有效期应至少长于合同到期日后的92天。
			sInsuranceEndDate = getItemValue(0,0,"InsuranceEndDate");//--保险到期日
			if(typeof(sInsuranceEndDate) != "undefined" && sInsuranceEndDate != ""){
				sBCMaturity = "<%=sBCMaturity%>";
				if(sBCMaturity == "" ){
					alert("请先填写合同信息！");
					return false;
				}else{
					//dReturn = RunMethod("BusinessManage","getDays",sInsuranceEndDate+","+sBCMaturity);
					var sCheckTermMonth = "2";
					var iCheckTermDay1 = "-1";
					sReturn = RunMethod("WorkFlowEngine","DateExcute",sBCMaturity+","+sCheckTermMonth+","+iCheckTermDay1);
					if("<%=sBusinessType%>" == "1050010" && sReturn >= sInsuranceEndDate){
						alert("房地产开发贷款的保险期限需长于合同期限3月减1天!");
						return false;
					}
					else if(dReturn < 0){
						alert("保险到期日需长于合同到期日!");
						return false;
					}
					
				}	
			}	
			
		}
*/		
		//评估机构有效性检测(提示不控制)
		sEvalOrgName = getItemValue(0,getRow(),"EvalOrgName");
		sEvalDate = getItemValue(0,getRow(),"EvalDate");
		if(typeof(sEvalOrgName) != "undefined" && sEvalOrgName != "" )
		{
			sReturn=RunMethod("CustomerManage","selectNewEvalOrgDate",sEvalOrgName);
			sReturn1=sReturn.split("@");
	     	sEffectStartDate=sReturn1[0];
	     	sEffectFinishDate=sReturn1[1];
			if(sEvalDate<sEffectStartDate || sEvalDate>sEffectFinishDate)
			{
				alert("审计日期不在评估机构有效期内!");
				return true;
			}
		}
		
		return true;
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"GuarantyType","<%=sPawnType%>");			
			setItemValue(0,0,"GuarantyStatus","01");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"GuarantyTypeName","<%=sPawnTypeName%>");
			if("<%=sBusinessType%>" == "1030040") 
				setItemValue(0,0,"InsuranceType","综合财产险");
			bIsInsert = true;			
		}
		if("<%=sOldObjectType%>" == "ReinforceContract"){
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");		
		}
		
    }

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号		
		setObjectValue("SelectOwner","","@OwnerID@0@OwnerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");		
	}
	
	/*~[Describe=根据证件类型和证件编号获得客户编号、客户名称和贷款卡编号;InputParam=无;OutPutParam=无;]~*/
	function getCustomerName()
	{
		var sCertType   = getItemValue(0,getRow(),"CertType");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		
		if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
			//获得客户编号、客户名称和贷款卡编号
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
						//设置客户ID
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"OwnerID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"OwnerName",sReturnInfo[n+1]);
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
				setItemValue(0,getRow(),"OwnerID","");
				setItemValue(0,getRow(),"OwnerName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			} 
		}		
	}
        
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "GUARANTY_INFO";//表名
		var sColumnName = "GuarantyID";//字段名
		var sPrefix = "GI";//前缀

		//使用GetGuarantyID.jsp来抢占一个流水号
		var sGuarantyID = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","");
		//将流水号置入对应字段
		setItemValue(0,getRow(),"GuarantyID",sGuarantyID);				
	}
	
	/* 设置抵押率2009-12-26 lpzhang*/
	function setGuarantyRate()
	{
		dConfirmValue = getItemValue(0,getRow(),"ConfirmValue");
		dAboutSum2 = getItemValue(0,getRow(),"AboutSum2");
		if(dConfirmValue<0 || dAboutSum2<0){
			alert("数值不得小于零！");
			return;
		}
		dGuarantyRate = (dAboutSum2/dConfirmValue)*100;
		dGuarantyRate = roundOff(dGuarantyRate,2);
		setItemValue(0,0,"GuarantyRate",dGuarantyRate);
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化

</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

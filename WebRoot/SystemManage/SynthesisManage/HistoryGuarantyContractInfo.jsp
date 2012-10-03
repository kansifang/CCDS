<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hlzhang 2012-07-17
		Tester:
		Describe: 修改担保合同详情
		Input Param:
			ObjectNo：对象编号（合同流水号）
			SerialNo：担保合同编号			
			GuarantyType：担保方式
		Output Param:

		HistoryLog:pliu 2011-11-07
			 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "修改担保合同详情信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	
	//获得页面参数：担保方式、担保合同编号
    String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//将空值转化为空字符串
	if(sGuarantyType == null) sGuarantyType = "";
	if(sSerialNo == null) sSerialNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
    //根据担保类型取得显示模版号
	String sSql = " select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo='"+sGuarantyType+"'";
	String sTempletNo = Sqlca.getString(sSql);
	//设置过滤条件
	String sTempletFilter = " (ColAttribute like '%BC%' ) ";
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
    //设置更新表名和主键
	doTemp.UpdateTable = "GUARANTY_CONTRACT_BAK";
	doTemp.setKey("GCBSerialNo",true);
	doTemp.FromClause = " from GUARANTY_CONTRACT_BAK ";
	doTemp.WhereClause = " where GCBSerialNo = '"+sSerialNo+"' ";
	//设置权利人选择框
	doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()>");
	doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:400px} ");
	if(sGuarantyType.equals("010040")){
		doTemp.appendHTMLStyle("GuarantyInfo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例的范围为[0,100]\" ");
	}
	//如果不是新增设置为只读
	if(!"".equals(sSerialNo))
	{
		doTemp.setReadOnly("CertType,CertID,GuarantorName",true);
	}else{
		if("050".equals(sGuarantyType)||"060".equals(sGuarantyType))
		{
			doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()><font color=red>(可输可选)</font>");
		}else{
			doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()>");
		}
	}
	
	doTemp.setRequired("",false);
    //	将历史修改记录中的合同要素调为只读项
	doTemp.setReadOnly("",true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置setEvent	
	dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#GuarantorID,#GuarantorName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	
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
			{"true","","Button","关闭","关闭详情页面","closeSelf()",sResourcesPath}
	  };
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=关闭;InputParam=无;OutPutParam=无;]~*/
	function closeSelf()
	{
		self.close();  //关闭当前页面
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		//不做操作
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{		
		//不做操作
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		//不做操作
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "GUARANTY_CONTRACT_BAK";//表名
		var sColumnName = "GCSerialNo";//字段名
		var sPrefix = "GCB";//前缀
       
		//使用GetSerialNo.jsp来抢占一个流水号
		var sBCBSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		//将流水号返回
		return sBCBSerialNo;
	}
	
	/*~[Describe=弹出保函类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectAssureType()
	{
		sParaString = "CodeNo"+",AssureType";		
		setObjectValue("SelectCode",sParaString,"@CheckGuarantyMan2@0@CheckGuarantyMan2Name@1",0,0,"");
	}

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号
		sGuarantyType = getItemValue(0,0,"GuarantyType");//--担保类型
		var sReturn = "";
		if(sGuarantyType == '010020' || sGuarantyType == '010030')
		{
			setObjectValue("SelectInvest","","@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");		
		}else
		{
		    if(sGuarantyType == '010010' || sGuarantyType == '010040')
		    {
			sReturn=setObjectValue("SelectOwner3","","@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
			}else 
			{
			sReturn=setObjectValue("SelectOwner","","@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
			}
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				setFieldDisabled("GuarantorName");
				setFieldDisabled("CertType");
				setFieldDisabled("CertID");
			}			
		}
	}
	
	
	//设置域不可用
	function setFieldDisabled(sField)
	{
	  setItemDisabled(0,0,sField,true);
	}
	
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{			
		sGuarantyType = getItemValue(0,0,"GuarantyType");//--担保类型		
		//如果担保类型为抵押、质押、保证、履约保险保证、保函保证、保证金时，需对录入的证件编号合法性进行验证
		if(sGuarantyType == '050' || sGuarantyType == '060' || sGuarantyType.substring(0,3) == '010')
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
			
			//校验担保人贷款卡编号
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//担保人贷款卡编号	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
			{
				if(!CheckLoanCardID(sLoanCardNo))
				{
					alert(getBusinessMessage('414'));//担保人的贷款卡编号有误！							
					return false;
				}
				
				//检验担保人贷款卡编号唯一性
				sGuarantorName = getItemValue(0,getRow(),"GuarantorName");//客户名称	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sGuarantorName+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					alert(getBusinessMessage('419'));//该担保人的贷款卡编号已被其他客户占用！							
					return false;
				}						
			}
			
			//检查输入的担保人是否建立信贷关系，如果未建立，需要新获取担保人的客户编号
			if(typeof(sCertType) != "undefined" && sCertType != "" 
			&& typeof(sCertID) != "undefined" && sCertID != "")
			{
				var sGuarantorID = PopPage("/PublicInfo/CheckCustomerAction.jsp?CertType="+sCertType+"&CertID="+sCertID,"","");
				if (typeof(sGuarantorID)=="undefined" || sGuarantorID.length==0) {
					return false;
				}
				setItemValue(0,0,"GuarantorID",sGuarantorID);
			}			
		}
		
		return true;
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
							setItemValue(0,getRow(),"GuarantorID",sReturnInfo[n+1]);
						//设置客户名称
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"GuarantorName",sReturnInfo[n+1]);
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
				setItemValue(0,getRow(),"GuarantorID","");
				setItemValue(0,getRow(),"GuarantorName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			} 
		}		
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: 业务合同拟引入的担保合同详情（一个保证合同对应一个保证人）;
		Input Param:
			ObjectType：对象类型（BusinessContract）
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
	String PG_TITLE = "担保合同详情信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";	
	int iCount = 0;
	ASResultSet rs = null;
	
	//获得组件参数：对象类型、对象编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
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
	//检查该最高额担保合同是否已被引入过
	sSql = 	" select count(SerialNo) from CONTRACT_RELATIVE "+
			" where SerialNo <> '"+sObjectNo+"' "+
			" and ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sSerialNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
		iCount = rs.getInt(1);
	rs.getStatement().close();
	
	//新增的最高额担保合同还需检查该业务合同是否已经出帐或完成放贷
	if(iCount <= 0)
	{
		String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
		if(sDBName.startsWith("INFORMIX"))
    	{
			sSql = 	" select count(SerialNo) from BUSINESS_CONTRACT "+
					" where SerialNo = '"+sObjectNo+"' "+
					" and ((SerialNo in (select ContractSerialNo "+
					" from BUSINESS_PUTOUT "+
					" where ContractSerialNo = '"+sObjectNo+"')) "+
					" or (PigeonholeDate is not null "+
					" and PigeonholeDate <> '')) ";
		}else if(sDBName.startsWith("ORACLE"))
		{
			sSql = 	" select count(SerialNo) from BUSINESS_CONTRACT "+
					" where SerialNo = '"+sObjectNo+"' "+
					" and ((SerialNo in (select ContractSerialNo "+
					" from BUSINESS_PUTOUT "+
					" where ContractSerialNo = '"+sObjectNo+"')) "+
					" or (PigeonholeDate is not null "+
					" and PigeonholeDate <> ' ')) ";
		}else if(sDBName.startsWith("DB2"))
    	{
			sSql = 	" select count(SerialNo) from BUSINESS_CONTRACT "+
					" where SerialNo = '"+sObjectNo+"' "+
					" and ((SerialNo in (select ContractSerialNo "+
					" from BUSINESS_PUTOUT "+
					" where ContractSerialNo = '"+sObjectNo+"')) "+
					" or (PigeonholeDate is not null "+
					" and PigeonholeDate <> '')) ";
		}
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
	}
	
    //根据担保类型取得显示模版号
	sSql = " select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo='"+sGuarantyType+"'";
	String sTempletNo = Sqlca.getString(sSql);
	//设置过滤条件
	String sTempletFilter = " (ColAttribute like '%BC%' ) ";
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//设置权利人选择框
	doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()>");
	doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:400px} ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	if(iCount <= 0||"ReinforceContract".equals(sObjectType)) dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	else dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		
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
		{(iCount <= 0||"ReinforceContract".equals(sObjectType)?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}	
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>		
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		//录入数据有效性检查
		if (!ValidityCheck()) return;		
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditAssure/ContractAssureList2.jsp","_self","");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{		
		setItemValue(0,0,"ContractStatus","020");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{			
		return true;
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
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

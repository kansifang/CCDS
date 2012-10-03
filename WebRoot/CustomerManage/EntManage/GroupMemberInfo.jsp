<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-11-29
		Tester:
		Describe: 关联集团成员信息;
		Input Param:
			CustomerID：当前客户编号
			RelativeID：关联客户组织机构代码
			Relationship：关联关系
		Output Param:
			CustomerID：当前客户编号

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联集团成员信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得组件参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	//获得页面参数
	String sRelativeID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = {
							{"CustomerName","关联集团成员名称"},
							{"CertType","关联集团成员证件类型"},
							{"CertID","关联集团成员证件号码"},
							{"RelationShip","成员类型"},
							//{"Whethen1","是否可共享额度"},
							//{"Whethen1","是否有该情况"},
							//{"Whethen2","是否有该情况"},
							//{"Whethen3","是否有该情况"},
							//{"Whethen4","是否有该情况"},
							{"Whethen5","是否有该情况"},
							{"Whethen6","是否有该情况"},
							{"Whethen7","是否有该情况"},
							{"Whethen8","是否有该情况"},
							{"Whethen9","是否有该情况"},
							{"Whethen10","是否有该情况"},
							{"Remark","备注"},
							{"OrgName","登记机构"},
							{"UserName","登记人"},
							{"InputDate","登记日期"},
							{"UpdateDate","更新日期"}
						   };

	String sSql =	" select CustomerName,CustomerID,RelativeID,LoanCardNo, " +
					" CertType,CertID,RelationShip," +
					" Whethen5,Whethen6,Whethen7,Whethen8,Whethen9,Whethen10,Remark," +
					" InputOrgId,getOrgName(InputOrgId) as OrgName,"+
					" InputUserId,getUserName(InputUserId) as UserName,InputDate,UpdateDate "+
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"' " +
					" and RelativeID='"+sRelativeID+"' " +
					" and RelationShip ='"+sRelationShip+"'" ;

	//由sSql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头,更新表名,键值,必输项,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	doTemp.setRequired("RelationShip,CustomerName,CertType,CertID",true);
	doTemp.setVisible("CustomerID,RelativeID,LoanCardNo,InputUserId,InputOrgId,Whethen1",false);
	doTemp.setUpdateable("UserName,OrgName",false);

	//设置字段格式
	doTemp.setEditStyle("Remark","3");
	doTemp.setLimit("Remark",200);
	doTemp.setHTMLStyle("Remark","style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");	
	//注意,先设HTMLStyle，再设ReadOnly，否则ReadOnly不会变灰
	doTemp.setHTMLStyle("UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setReadOnly("CustomerName,CertType,CertID,OrgName,UserName,InputDate,UpdateDate",true);
	//doTemp.setUnit("Whethen2","股权上或者经营决策上直接或间接控制其他企事业法人或被其他企事业法人控制的 ");
	//doTemp.setUnit("Whethen3","共同被第三方企事业法人所控制的 ");
	//doTemp.setUnit("Whethen4","主要投资者个人、关键管理人员或与其关系密切的家庭成员共同直接控制或间接控制的 ");
	doTemp.setUnit("Whethen5","存在其他关联关系，可能不按公允价格原则转移资产和利润，商业银行认为应视同企业客户进行授信管理的 ");
	doTemp.setUnit("Whethen6","通过与其他投资者之间的协议，拥有另一方50%以上的表决权 ");
	doTemp.setUnit("Whethen7","根据公司章程或协议，有权决定另一方财务和经营政策 ");
	doTemp.setUnit("Whethen8","有权任免另一方董事会或类似权利机构的多数成员 ");
	doTemp.setUnit("Whethen9","在另一方董事会或类似机构占50%以上表决权 ");
	doTemp.setUnit("Whethen10","集团客户合并报表 ");
	//设置下拉框
	doTemp.setDDDWSql("CertType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='CertType' and ItemNo like 'Ent%'");
	doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='RelationShip' and ItemNo like '04%' and length(ItemNo)>2 ");
	doTemp.setDDDWCode("Whethen5","YesNo");
	doTemp.setDDDWCode("Whethen6","YesNo");
	doTemp.setDDDWCode("Whethen7","YesNo");
	doTemp.setDDDWCode("Whethen8","YesNo");
	doTemp.setDDDWCode("Whethen9","YesNo");
	doTemp.setDDDWCode("Whethen10","YesNo");

	//若关联客户编号为空，则出现选择客户提示框
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input class=\"inputdate\" type=button value=... onclick=parent.selectCustomer()>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID",true);
	}

	//生成数据窗体
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform格式

	//设置插入和更新事件，反方向插入和更新
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.AddCustomerInfo(#RelativeID,#CustomerName,#CertType,#CertID,#LoanCardNo,#InputUserId)+!CustomerManage.AddGroupInfo(#CustomerID,#RelativeID,#InputUserId)");
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
		if(bIsInsert){
			//保存前进行检查,检查通过后继续保存,否则给出提示
		    if (!ValidityCheck()) return;
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
		OpenPage("/CustomerManage/EntManage/GroupMemberList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");
		var sRelationShip   = getItemValue(0,getRow(),"RelationShip");
		OpenPage("/CustomerManage/EntManage/GroupMemberInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip, "_self","");
	}

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		sCustomerID = "<%=sCustomerID%>";
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号		
		setObjectValue("SelectDisRelativeMember","CustomerID,"+sCustomerID,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
	}

	
	/*~[Describe=得到客户名字;InputParam=无;OutPutParam=无;]~*/
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
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
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
		}
	}

	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		//检查证件编号是否符合编码规则
		sCertType = getItemValue(0,0,"CertType");//--证件类型		
		sCertID = getItemValue(0,0,"CertID");//--证件代码
		
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
		
		//检查录入的客户是否为其本身
		sCustomerID   = getItemValue(0,0,"CustomerID");	//客户编号
		sRelationShip   = getItemValue(0,0,"RelationShip");//--关联客户代码		
		var sMessage = PopPage("/CustomerManage/EntManage/RelativeCheckAction.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
		if (typeof(sMessage)=="undefined" || sMessage.length==0) {
			return false;
		}		
		setItemValue(0,0,"RelativeID",sMessage);
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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: 业务合同所对应的新增的担保合同列表（一个保证合同对应一个保证人）;
		Input Param:
				ObjectType：对象类型（BusinessContract）
				ObjectNo: 对象编号（合同流水号）
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "担保合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%
	//定义变量
	String sSql = "";
	//获得组件参数：对象类型、对象编号
	String sObjectType = "BusinessContract";
	
	//将空值转化为空字符串
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","担保合同编号"},
							{"GuarantyTypeName","担保方式"},
							{"ContractTypeName","担保合同种类"},
							{"GuarantorName","担保人名称"},
							{"GuarantyValue","担保金额"},				            
							{"GuarantyCurrency","币种"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"}
						  };

	sSql =  " select GC.SerialNo,GC.CustomerID,GC.ContractType,GC.GuarantyType, "+
			" getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName, "+
			" getItemName('ContractType',GC.ContractType) as ContractTypeName,"+
			" GC.GuarantorID,GC.GuarantorName,GC.GuarantyValue, "+
			" getItemName('Currency',GC.GuarantyCurrency) as GuarantyCurrency, "+
			" GC.InputUserID,getUserName(GC.InputUserID) as InputUserName, "+
			" GC.InputOrgID,getOrgName(GC.InputOrgID) as InputOrgName "+
			" from GUARANTY_CONTRACT GC "+
			" where GC.SerialNo like 'ZJGC%' "+
			" and ContractStatus = '020' "+
			" and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	//客户经理只能查看自己的业务
	if(CurUser.hasRole("2D3")||CurUser.hasRole("480")||CurUser.hasRole("0E8")||CurUser.hasRole("080")||CurUser.hasRole("2A5")||CurUser.hasRole("280")||CurUser.hasRole("2J4"))
	{
		sSql += " and InputUserID='"+CurUser.UserID+"'";
	}
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("CustomerID,GuarantorID,GuarantyType,ContractType,InputUserID,InputOrgID,Channel",false);
	//设置格式
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setCheckFormat("GuarantyValue","2");
	doTemp.setHTMLStyle("GuarantyTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:180px} ");
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
		{"false","","Button","新增","新增担保信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看担保信息详情","viewAndEdit()",sResourcesPath},
		{"false","","Button","删除","删除担保信息","deleteRecord()",sResourcesPath},
		{"true","","Button","担保客户详情","查看担保相关的担保客户详情","viewCustomerInfo()",sResourcesPath},
		{"true","","Button","相关业务详情","查看相关业务合同信息","viewBusinessInfo()",sResourcesPath},
		{"false","","Button","关联业务合同","关联业务合同信息","my_relativecontract()",sResourcesPath},
		{"false","","Button","担保生效","将担保合同由失效变为生效","statusChange()",sResourcesPath},
		};
	//客户经理进行追加
	if(CurUser.hasRole("2D3")||CurUser.hasRole("480")||CurUser.hasRole("0E8")||CurUser.hasRole("080")||CurUser.hasRole("2A5")||CurUser.hasRole("280")||CurUser.hasRole("2J4"))
	{
		sButtons[getBtnIdxByName(sButtons,"新增")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"删除")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"关联业务合同")][0]="true";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		//选择所需的合同信息
		sParaString = "ManageUserID"+","+"<%=CurUser.UserID%>";
		sReturn = setObjectValue("SelectContractOfGuaranty",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
		//合同流水号
		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		
		sGuarantyType=PopPage("/CreditManage/CreditAssure/AddAssureDialog1.jsp","","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(sGuarantyType) != "undefined" && sGuarantyType.length != 0 && sGuarantyType != '_none_')
		{
			OpenPage("/CreditManage/CreditAssure/AddAssureInfo1.jsp?GuarantyType="+sGuarantyType+"&ObjectNo="+sObjectNo,"right");
		}
	}


	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--担保信息编号
		sContractType = getItemValue(0,getRow(),"ContractType");//--担保合同类型
		var sReturnValue = "";
		var sObjectNo = "";
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			if(sContractType=="010")//一般担保合同
			{
				sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,Contract_relative,String@ObjectNo@"+sSerialNo+"@String@ObjectType@GuarantyContract");
				sReturnValue=sReturn.split("@")
				if(sReturnValue[1] != ""  || sReturnValue[1] != "null" || sReturnValue[1] != 0) 
				{
					sObjectNo=sReturnValue[1];
				} 
			}else{//最高额担保合同
				sParaString="UserID,<%=CurUser.UserID%>"+",ObjectNo,"+sSerialNo;
				sReturn = setObjectValue("SelectGuarantyBContract",sParaString,"",0,0,"");
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn != "_NONE_" && sReturn != "_CLEAR_" && sReturn != "_CANCEL_")
				{
					//合同流水号
					sReturnValue = sReturn.split("@");
					sObjectNo = sReturnValue[0];
				}
				
			}
			if(typeof(sObjectNo)!="undefined" && sObjectNo.length!=0&&confirm(getHtmlMessage('2')))//您真的想删除该信息吗？)
			{
				sReturn=RunMethod("BusinessManage","DeleteAddGuarantyContract","BusinessContract,"+sObjectNo+","+sSerialNo);
				if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED")
				{
					alert(getHtmlMessage('7'));//信息删除成功！
					reloadSelf();
				}else
				{
					alert(getHtmlMessage('8'));//对不起，删除信息失败！
					return;
				}
			}
		}
	}


	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--担保信息编号
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//--担保方式
			OpenPage("/CreditManage/CreditAssure/AddAssureInfo1.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"right");
		}
	}

	/*~[Describe=查看担保客户详情详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0)
				alert(getBusinessMessage('413'));//系统中不存在担保人的客户基本信息，不能查看！
			else
				openObject("Customer",sCustomerID,"002");
		}
	}


	/*~[Describe=选中某笔担保合同,联动显示担保项下的抵质押物;InputParam=无;OutPutParam=无;]~*/
	function mySelectRow()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		var sObjectNo="";
		sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,Contract_relative,String@ObjectNo@"+sSerialNo+"@String@ObjectType@GuarantyContract");
		sReturnValue=sReturn.split("@");
		if(sReturnValue[1] != ""  || sReturnValue[1] != "null" || sReturnValue[1] != 0) 
		{
			sObjectNo=sReturnValue[1];
		} 
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else
		{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");			
			if (sGuarantyType.substring(0,3) == "010") {
				OpenPage("/Blank.jsp?TextToShow=保证担保下无详细信息!","DetailFrame","");
			}else 
			{
				if (sGuarantyType.substring(0,3) == "050") //抵押
					OpenPage("/CreditManage/GuarantyManage/AddAssurePawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&ContractNo="+sSerialNo,"DetailFrame","");
				else //质押
					OpenPage("/CreditManage/GuarantyManage/AddAssureImpawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&ContractNo="+sSerialNo,"DetailFrame","");
			}
		}
	}
	

	/*~[Describe=查看担保合同关联业务详情;InputParam=无;OutPutParam=无;]~*/
	function viewBusinessInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--担保合同流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("AssureBusinessList","/CreditManage/CreditAssure/AssureBusinessList.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=操作最高额担保合同关联业务;InputParam=无;OutPutParam=无;]~*/
	function my_relativecontract()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--担保合同流水号码
		sContractType = getItemValue(0,getRow(),"ContractType");//--担保合同类型
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(sContractType=='010')//如果为一般担保合同
		{
			alert("此为一般担保合同，不能进行关联业务操作");
			return ;
		}
		//选择所需的合同信息
		sParaString = "ManageUserID"+","+"<%=CurUser.UserID%>";
		sReturn = setObjectValue("SelectContractOfGuaranty",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
		//合同流水号
		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		//alert(sObjectNo);
		sReturn = RunMethod("PublicMethod","GetColValue","SerialNo,CONTRACT_RELATIVE,String@ObjectNo@"+sSerialNo+"@String@ObjectType@GuarantyContract@String@SerialNo@"+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array[i] = sReturn[i];
			}
				
			for(j = 0;j < my_array.length;j++)
			{
				sReturnInfo = my_array[j].split('@');				
				if(typeof(sReturnInfo) != "undefined" && sReturnInfo != "")
				{		
					if(sReturnInfo[0] == "serialno")
					{ 
						if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" )
						{
							alert("所选合同已被该担保合同引入,不能再次引入！");//所选合同已被该担保合同引入,不能再次引入！
					        return;
					    }
					}				
				}
			}			
		}
		//新增该担保合同与所选合同的关联关系
		sReturn=RunMethod("BusinessManage","ImportGauarantyContract","BusinessContract,"+sObjectNo+","+sSerialNo);
		if(sReturn == "EXIST") alert(getBusinessMessage('415'));//该业务合同已经关联上！
		if(sReturn == "SUCCEEDED")
		{
			alert(getBusinessMessage('416'));//关联业务合同成功！
			reloadSelf();
		}
		
	}
	
	
	/*~[Describe=追加担保合同;InputParam=无;OutPutParam=无;]~*/
	function statusChange()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getBusinessMessage('418'))) //您真的想将担保合同由失效变为生效吗？
		{
			RunMethod("BusinessManage","UpdateGuarantyContractStatus",sSerialNo+",020");
			alert("已成功将该担保生效");
			reloadSelf();
			OpenPage("/Blank.jsp?TextToShow=请先选择相应的担保信息!","DetailFrame","");
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	OpenPage("/Blank.jsp?TextToShow=请先选择相应的担保信息!","DetailFrame","");
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
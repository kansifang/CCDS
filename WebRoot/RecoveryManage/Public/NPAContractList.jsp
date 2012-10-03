<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  hxli 2005.8.11
		Tester:
		Content: 重组方案关联合同列表
		Input Param:
				SerialNo:申请编号				  
		Output param:
				
		History Log: zywei 2005/09/03 重检代码
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "申请相关合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	String sCustomerID = "";
	ASResultSet rs1=null;
	//获得组件参数：申请流水号		
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//将空值转化成空字符串	
	if(sSerialNo == null) sSerialNo = "";
	//获得页面参数
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	sSql = "select CustomerID from BUSINESS_APPLY "+
	" where SerialNo in(select SerialNo from APPLY_RELATIVE "+
			" where ObjectType='CapitalReform' and ObjectNo='"+sSerialNo+"')";
	rs1 = Sqlca.getResultSet(sSql);
	if(rs1.next()) 
	{
		sCustomerID = rs1.getString("CustomerID");
	}
	rs1.getStatement().close();
	//定义表头文件
	String sHeaders[][] = { 		
    					{"SerialNo","合同流水号"},  
    					{"CustomerName","客户名称"},
						{"BusinessTypeName","业务品种"},
						{"BusinessCurrencyName","币种"},
						{"BusinessSum","金额"},
						{"Balance","余额"},
						{"RecoveryUserName","不良资产管理人"},
						{"RecoveryOrgName","不良资产管理机构"}
						}; 
	
	//从申请关联表LAWCASE_RELATIVE中获得对应合同号的相关信息
	sSql = 	" select BC.SerialNo,BC.CustomerName,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
			" getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName,BC.BusinessSum,BC.Balance, "+
			" AR.ObjectNo,AR.ObjectType as ObjectType,getUserName(BC.RecoveryUserID) as RecoveryUserName, "+
			" GetOrgName(BC.RecoveryOrgID) as RecoveryOrgName,BC.BusinessType "+
			" from BUSINESS_CONTRACT BC,REFORM_RELATIVE AR "+
			" where BC.SerialNo = AR.ObjectNo "+		
			" and AR.SerialNo = '"+sSerialNo+"' "+		
			" and AR.ObjectType= 'BusinessContract' "+
			" order by SerialNo desc ";	
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("ObjectType,ObjectNo,BusinessType",false);	

	//设置金额为数字形式
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("BusinessSum","2");
	
	doTemp.setType("Balance","Number");
	doTemp.setCheckFormat("Balance","2");
	
	//设置金额对齐方式
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setAlign("BusinessTypeName,BusinessCurrencyName","2");
	
	//设置行宽	
	doTemp.setHTMLStyle("CustomerName,BusinessTypeName,RecoveryOrgName"," style={width:150px} ");		
	doTemp.setHTMLStyle("BusinessCurrencyName,BusinessSum,Balance,RecoveryUserName"," style={width:100px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
				{"true","","Button","引入关联合同","引入重组方案的关联合同信息","my_relativecontract()",sResourcesPath},
				{"true","","Button","合同详情","查看合同详情","viewAndEdit()",sResourcesPath},
				{"true","","Button","删除","解除重组方案与合同的关联关系","deleteRecord()",sResourcesPath},
				{"true","","Button","关联其他贷款","关联非借款主体贷款","other_relativecontract()",sResourcesPath}
			};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ContractInfo;Describe=查看合同详情;]~*/%>
	<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=关联重组方案的合同信息;InputParam=无;OutPutParam=无;]~*/
	function my_relativecontract()
	{ 				
		var sRelativeContractNo = "";	
		/*//获取重组方案关联的合同流水号	
		var sContractInfo = setObjectValue("SelectRelativeContract","","@RelativeContract@0",0,0,"");
		if(typeof(sContractInfo) != "undefined" && sContractInfo != "" && sContractInfo != "_NONE_" 
		&& sContractInfo != "_CLEAR_" && sContractInfo != "_CANCEL_") 
		{
			sContractInfo = sContractInfo.split('@');
			sRelativeContractNo = sContractInfo[0];
		}
		*/
		var sContractInfo = PopComp("SelectRelativeContract","/RecoveryManage/Public/SelectRelativeContract.jsp","CustomerID=<%=sCustomerID%>","dialogWidth=55;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sContractInfo != "" && sContractInfo != "_CANCEL_" &&  sContractInfo != "_NONE_" && sContractInfo != "_CLEAR_" &&  typeof(sContractInfo) != "undefined")
		{
			sContractInfo = sContractInfo.split("@");
			sRelativeContractNo = sContractInfo[0];
		}
		//如果选择了合同信息，则判断该合同是否已和当前的重组方案建立了关联，否则建立关联关系。
		if(typeof(sRelativeContractNo) != "undefined" && sRelativeContractNo != "") 
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,REFORM_RELATIVE,String@SerialNo@"+"<%=sSerialNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sContractInfo);
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
						if(sReturnInfo[0] == "objectno")
						{
							if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sRelativeContractNo)
							{
								alert(getBusinessMessage("756"));//所选合同已被该重组方案引入,不能再次引入！
								return;
							}
						}				
					}
				}			
			}
			//新增重组方案与所选合同的关联关系
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sSerialNo%>"+",BusinessContract,"+sRelativeContractNo+",REFORM_RELATIVE");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				alert(getBusinessMessage("754"));//引入关联合同成功！
				OpenPage("/RecoveryManage/Public/NPAContractList.jsp","right","");	
			}else
			{
				alert(getBusinessMessage("755"));//引入关联合同失败，请重新操作！
				return;
			}
		}	
	}
		
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{		
		//获取合同流水号
		sContractNo = getItemValue(0,getRow(),"SerialNo");  
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,APPLY_RELATIVE,String@ObjectType@NPARefromApply@String@ObjectNo@"+"<%=sSerialNo%>");
			if (typeof(sReturn) != "undefined" && sReturn.length != 0)
			{
				alert(getBusinessMessage("757"));  //由于该重组方案已经与申请业务建立了关联关系，故它的关联合同信息不能删除！
				return;
			}else
			{
				//删除重组方案与所选合同的关联关系
				sReturn = RunMethod("BusinessManage","DeleteRelative","<%=sSerialNo%>"+",BusinessContract,"+sContractNo+",REFORM_RELATIVE");
				if(typeof(sReturn) != "undefined" && sReturn != "")
				{
					alert(getBusinessMessage("758"));//该重组方案的关联合同删除成功！
					OpenPage("/RecoveryManage/Public/NPAContractList.jsp","right","");	
				}else
				{
					alert(getBusinessMessage("759"));//该重组方案的关联合同删除失败，请重新操作！
					return;
				}
			}
		}
	}
	
	/*~[Describe=增加其他贷款;InputParam=无;OutPutParam=无;]~*/
	function other_relativecontract()
	{		
		var sRelativeSerialNo = "";	
		//按照合同关联	
		sRelativeContractNo = PopPage("/RecoveryManage/Public/AddOtherContract.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");

		dReturn = RunMethod("BusinessManage","QueryBusinessContract",sRelativeContractNo);				
		if(dReturn < 1){
			alert("合同号不正确！请从新输入！");
			return;
		}
			//如果选择了合同信息，则判断该合同是否已和当前的重组方案建立了关联，否则建立关联关系。
		if(typeof(sRelativeContractNo) != "undefined" && sRelativeContractNo != "") 
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,REFORM_RELATIVE,String@SerialNo@"+"<%=sSerialNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sRelativeContractNo);
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
						if(sReturnInfo[0] == "objectno")
						{
							if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sRelativeContractNo)
							{
								alert(getBusinessMessage("756"));//所选合同已被该重组方案引入,不能再次引入！
								return;
							}
						}				
					}
				}			
			}
			//新增重组方案与所选合同的关联关系
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sSerialNo%>"+",BusinessContract,"+sRelativeContractNo+",REFORM_RELATIVE");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				alert(getBusinessMessage("754"));//引入关联合同成功！
				OpenPage("/RecoveryManage/Public/NPAContractList.jsp","right","");	
			}else
			{
				alert(getBusinessMessage("755"));//引入关联合同失败，请重新操作！
				return;
			}
			reloadSelf();
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

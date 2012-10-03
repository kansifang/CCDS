<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: 案件相关合同列表
		Input Param:
				SerialNo:案件编号				  
		Output param:
				
		History Log: zywei 2005/09/06 重检代码
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "案件相关合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";	
	
	//获得组件参数（案件流水号）		
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 		
	    					{"SerialNo1","案件编号"}, 
	    					{"SerialNo","合同流水号"},  	    					
	    					{"CustomerName","客户名称"},
							{"BusinessTypeName","业务品种"},
							{"BusinessCurrencyName","币种"},
							{"BusinessSum","金额"},
							{"BlanceSum","余额"},
							{"RecoveryUserName","不良资产管理人"},
							{"RecoveryOrgName","不良资产管理机构"}
						}; 
	
	//从案件关联表LAWCASE_RELATIVE中获得对应合同号的相关信息
	sSql = " select LR.SerialNo as SerialNo1,BC.SerialNo as SerialNo,BC.CustomerName as CustomerName, "+
		   " BC.BusinessType as BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
           " BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName, "+
		   " BC.BusinessSum as BusinessSum,BC.Balance as BlanceSum, "+
		   " LR.ObjectNo,LR.ObjectType as ObjectType,BC.RecoveryOrgID, "+
		   " getUserName(BC.RecoveryUserID) as RecoveryUserName, "+
		   " GetOrgName(BC.RecoveryOrgID) as RecoveryOrgName ,BC.RecoveryUserID "+
		   " from BUSINESS_CONTRACT BC,LAWCASE_RELATIVE LR "+
		   " where BC.SerialNo = LR.ObjectNo "+		
		   " and LR.SerialNo = '"+sSerialNo+"' "+
		   " and LR.ObjectType= 'BusinessContract' "+
		   " order by LR.SerialNo desc ";	//对象类型
	
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);	
	//设置共用格式
	doTemp.setVisible("ObjectType,ObjectNo,BusinessType,SerialNo1,SerialNo,BusinessType,BusinessCurrency,RecoveryOrgID,RecoveryUserID",false);	

	//设置金额为数字形式
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("BusinessSum","2");	
	doTemp.setType("BlanceSum","Number");
	doTemp.setCheckFormat("BlanceSum","2");	
	//设置金额对齐方式
	doTemp.setAlign("BusinessSum,BlanceSum","3");
	doTemp.setAlign("BusinessTypeName,BusinessCurrencyName","2");
	
	//设置html格式
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName,RecoveryUserName"," style={width:80px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页

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
			{"true","","Button","引入关联合同","引入关联合同信息","my_relativecontract()",sResourcesPath},
			{"true","","Button","合同详情","查看合同详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","取消关联合同","解除案件与合同的关联关系","deleteRecord()",sResourcesPath}
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
		
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sContractNo = getItemValue(0,getRow(),"SerialNo");  //合同流水号或对象编号
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			//删除案件与所选合同的关联关系
			sReturn = RunMethod("BusinessManage","DeleteRelative","<%=sSerialNo%>"+",BusinessContract,"+sContractNo+",LAWCASE_RELATIVE");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				alert(getBusinessMessage("751"));//该案件的关联合同删除成功！
				OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/RelativeContractList.jsp","right","");	
			}else
			{
				alert(getBusinessMessage("752"));//该案件的关联合同删除失败，请重新操作！
				return;
			}			
		}
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	function my_relativecontract()
	{ 
		var sRelativeContractNo = "";	
		//获取案件关联的合同流水号	
		var sContractInfo = setObjectValue("SelectRelativeContract","","@RelativeContract@0",0,0,"");
		if(typeof(sContractInfo) != "undefined" && sContractInfo != "" && sContractInfo != "_NONE_" 
		&& sContractInfo != "_CLEAR_" && sContractInfo != "_CANCEL_") 
		{
			sContractInfo = sContractInfo.split('@');
			sRelativeContractNo = sContractInfo[0];
		}
		//如果选择了合同信息，则判断该合同是否已和当前的案件建立了关联，否则建立关联关系。
		if(typeof(sRelativeContractNo) != "undefined" && sRelativeContractNo != "") 
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,LAWCASE_RELATIVE,String@SerialNo@"+"<%=sSerialNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sContractInfo);
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
								alert(getBusinessMessage("753"));//所选合同已被该案件引入,不能再次引入！
								return;
							}
						}				
					}
				}			
			}
			//新增案件与所选合同的关联关系
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sSerialNo%>"+",BusinessContract,"+sRelativeContractNo+",LAWCASE_RELATIVE");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				alert(getBusinessMessage("754"));//引入关联合同成功！
				OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/RelativeContractList.jsp","right","");	
			}else
			{
				alert(getBusinessMessage("755"));//引入关联合同失败，请重新操作！
				return;
			}
		}	
	}
		
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

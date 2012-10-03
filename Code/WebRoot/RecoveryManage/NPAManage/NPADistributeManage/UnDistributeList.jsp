<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: XWu 2004-12-04
*	Tester:
*	Describe: 未分发不良资产信息列表
*	Input Param:
*	Output Param:  
*		RecoveryUserID  :保全部管理员ID
*   	SerialNo	:合同流水号
*		sShiftType	:移交类型
*	
	HistoryLog:slliu 2004.12.17
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未分发不良资产信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量	    
	String sSql = "";
	
	//获得组件参数
	
	//获得页面参数
			
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义标题
	String sHeaders[][] = {
							{"SerialNo","合同流水号"},				
							{"BusinessTypeName","业务品种"},
							{"OccurTypeName","发生类型"},
							{"CustomerName","客户名称"},
							{"BusinessCurrencyName","币种"},
							{"BusinessSum","金额"},
							{"ShiftBalance","移交余额"},
							{"Balance","当前余额"},
							{"CAVSum","核销金额"},
							{"Maturity","到期日期"},							
							{"ClassifyResultName","五级分类"},							
							{"ShiftTypeName","移交类型"},
							{"ManageUserName","原管户人"},
							{"ManageOrgName","原管户机构"}
						}; 

 	sSql = " select SerialNo," + 	
		   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
		   " getItemName('OccurType',OccurType) as OccurTypeName," + 
		   " CustomerName,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
		   " BusinessSum,ShiftBalance,Balance, Cancelsum+CancelInterest as CAVSum,Maturity,"+
		   " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName," + 
		   " ShiftType,getItemName('ShiftType',ShiftType) as ShiftTypeName," + 
		   " getUserName(ManageUserID) as ManageUserName," + 
		   " getOrgName(ManageOrgID) as ManageOrgName" + 
		   " from BUSINESS_CONTRACT" ;
	//取消了对机构的限制，列表中可以看到所有的不良资产，项目组可根据实际情况增加机构限制
	//	   " Where  RecoveryOrgID = '"+CurOrg.OrgID+"'" +
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
 	if(sDBName.startsWith("INFORMIX"))
 	{
		   sSql+=" Where  RecoveryOrgID <> ''" +
		   " and (RecoveryUserID is null or RecoveryUserID ='') ";
 	}
 	else if(sDBName.startsWith("ORACLE"))
 	{
		   sSql+=" Where  RecoveryOrgID <> ' '" +
		   " and (RecoveryUserID is null or RecoveryUserID =' ') ";
	}
 	else if(sDBName.startsWith("DB2"))
 	{
		   sSql+=" Where  RecoveryOrgID <> ''" +
		   " and (RecoveryUserID is null or RecoveryUserID ='') ";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("ShiftType,BusinessType,FinishType,FinishDate,ClassifyResult,ShiftType,ShiftTypeName",false);
	doTemp.setKeyFilter("SerialNo");		//add by hxd in 2005/02/20 for 加快速度
    
	//设置行宽
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName,Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum,CAVSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,CAVSum,Balance,ActualPutOutSum","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,BusinessCurrencyName","2");
	
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(20); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		{"true","","Button","指定管理人","指定合同管户人或者跟踪人，转为已分发","my_Distribute()",sResourcesPath},
		{"true","","Button","逆移交","将合同退回给原管户人","my_ReverseHandover()",sResourcesPath}
		};

/*added by FSGong 2005-03-30
	根据高科长要求，增加指定跟踪人功能
	原指定管理人不变：如果是客户移交，则指定管户人，同时移交；如果是审批移交，则指定跟踪人，同时移交。
	新增指定跟踪人：	  如果是客户移交，则指定跟踪人，不移交；如果是审批移交，则指定跟踪人，同时移交。
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=指定保全部管理人;InputParam=无;OutPutParam=无;]~*/   
	function my_Distribute()
	{
		//获得合同流水号、移交类型
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sShiftType = getItemValue(0,getRow(),"ShiftType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else
		{
			//弹出对话选择框
			var sRecovery = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
			{
				sRecovery = sRecovery.split("@");
				var sRecoveryUserID = sRecovery[0];
				var sRecoveryUserName = sRecovery[1];
				var sRecoveryOrgID = sRecovery[2];
				
				var sReturn = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserAction.jsp?"+
					 "RecoveryUserID="+sRecoveryUserID+"&RecoveryOrgID="+sRecoveryOrgID+"&SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"","","");
				if(sReturn == "true") //刷新页面
				{
					if(sShiftType=="02")
					{
						alert("该不良资产成功分发给『"+sRecoveryUserName+"』管户！");
						self.location.reload();
					}
					else
					{
						alert("该不良资产成功分发给『"+sRecoveryUserName+"』跟踪！");
						self.location.reload();
					}
				}
			}
		}
	}
		
	/*~[Describe=逆向移交记录;InputParam=无;OutPutParam=无;]~*/	
	function my_ReverseHandover()
	{ 
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else
		{	
			if(confirm(getBusinessMessage('785')))//您真的想将此不良资产退回给原管户人吗？
    		{	
				var sReturn = PopPage("/RecoveryManage/Public/NPAShiftAction.jsp?SerialNo="+sSerialNo+"&Type=2","","");
				if(sReturn == "true") //刷新页面
				{
					alert(getBusinessMessage('784')); //该不良资产已成功退回给原管户人！
					self.location.reload();
				}
			}
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
<%
	/*
		Author: FSGong  2005-01-26
	
		Tester:
		Describe: 管户的不良资产快速查询
		Input Param:
		Output Param:     
		HistoryLog:
*/
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "管户的不良资产快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	/*~END~*/
%>         
       
                      
<%
                                      	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
                                      %>
<%
	String sHeaders[][] = {
					{"SerialNo","合同流水号"},										
					{"BusinessType","业务品种"},
					{"BusinessTypeName","业务品种"},
					{"OccurType","发生类型"},
					{"OccurTypeName","发生类型"},
					{"CustomerName","客户名称"},
					{"BusinessCurrencyName","币种"},
					{"BusinessSum","金额"},
					{"ActualPutOutSum","已实际出账金额"},
					{"Balance","当前余额"},
					{"ShiftBalance","移交余额"},
					{"FinishType","终结类型"},
					{"FinishTypeName","终结类型"},
					{"FinishDate","终结日期"},							
					{"ClassifyResult","五级分类"},
					{"ClassifyResultName","五级分类"},
					{"Maturity","到期日期"},
					{"ManageUserName","原管户人"},
					{"ManageOrgName","原管户机构"},
					{"RecoveryUserName","保全管户人"}
				}; 

 	String sSql = "select SerialNo," + 							 	
		 " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
		 " OccurType,getItemName('OccurType',OccurType) as OccurTypeName," + 
		 " CustomerName," + 
		 " BusinessCurrency,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
		 " BusinessSum," + 
		 " ActualPutOutSum," + 
		 " ShiftBalance,Balance," + 
		 " FinishType,getItemName('FinishType',FinishType) as FinishTypeName," + 
		 " FinishDate," + 				
		 " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName," + 
		 " Maturity," +  
		 " getUserName(ManageUserID) as ManageUserName," + 
		 " getOrgName(ManageOrgID) as ManageOrgName," + 
		 " getUserName(RecoveryUserID) as RecoveryUserName" + 
		 " from BUSINESS_CONTRACT" +
		 " Where RecoveryUserID  is not null And ShiftType ='02' " ;     //移交类型为02-客户移交

	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setKeyFilter("SerialNo");
	doTemp.setHeader(sHeaders);	

	//设置选项双击及行宽	
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName"," style={width:65px} ");
	doTemp.setHTMLStyle("OccurTypeName,Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:80px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("Balance,ShiftBalance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	doTemp.setVisible("BusinessType,OccurType,FinishType,ClassifyResult,BusinessCurrency",false);	

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,Balance,ShiftBalance,ActualPutOutSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,Balance,ShiftBalance,ActualPutOutSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,Balance,ShiftBalance,ActualPutOutSum,OperateUserName,OperateOrgName","3");
	
	//生成查询框
	doTemp.setDDDWCode("OccurType","OccurType");
	doTemp.setDDDWCode("FinishType","FinishType");
	doTemp.setDDDWCode("ClassifyResult","ClassifyResult");	
	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","BusinessTypeName","");
	doTemp.setFilter(Sqlca,"4","OccurType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","FinishType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"6","ClassifyResult","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"7","RecoveryUserName","");
	doTemp.setFilter(Sqlca,"8","ManageOrgName","");
	doTemp.setFilter(Sqlca,"9","ManageUserName","");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(16); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
%>
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
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath}
		};
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	//查看合同详情
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得合同流水号
		var sContractNo=getItemValue(0,getRow(),"SerialNo");  
		
		//获得业务品种
		var sBusinessType=getItemValue(0,getRow(),"BusinessType"); 
		if (typeof(sContractNo)=="undefined" || sContractNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		else
		{
			
			if(sBusinessType=="8010" || sBusinessType=="8020" || sBusinessType=="8030")
			{
				OpenComp("DataInputDetailInfo","/InfoManage/DataInput/DataInputDetailInfo.jsp","ComponentName=列表?&ComponentType=MainWindow&SerialNo="+sContractNo+"&Flag=Y&CurItemDescribe3="+sBusinessType+"","_blank",OpenStyle);
			}
			else
			{
			  	sObjectType = "AfterLoan";
				sObjectNo = sContractNo;
				sViewID = "001";
				
				openObject(sObjectType,sObjectNo,sViewID);
			}
		}
	}
</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>


<%@include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   slliu 2004.11.22
			Change by FSGong  2005.01.25
			Tester:
			Content: 跟踪的不良资产快速查询
			Input Param:
		       
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "跟踪的不良资产快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义表头
	String sHeaders[][] = {
								{"SerialNo","合同流水号"},
								{"ArtificialNo","合同编号"},
								{"BusinessType","业务品种"},
								{"BusinessTypeName","业务品种"},
								{"OccurType","发生类型"},
								{"OccurTypeName","发生类型"},
								{"CustomerName","客户名称"},
								{"BusinessCurrencyName","币种"},
								{"BusinessSum","金额(元)"},
								{"ShiftBalance","移交余额(元)"},
								{"Balance","当前余额(元)"},
								{"Maturity","到期日期"},
								{"Flag5","是否老不良"},
								{"Flag5Name","是否老不良"},
								{"ClassifyResult","五级分类"},
								{"ClassifyResultName","五级分类"},
								{"ShiftType","移交类型"},				
								{"ShiftTypeName","移交类型"},				
								{"RecoveryUserID","不良管户人"},
								{"RecoveryUserName","不良管户人"},
								{"RecoveryOrgID","不良管户机构"},
								{"RecoveryOrgName","不良管户机构"},
								{"ManageUserName","原管户人"},
								{"ManageOrgName","原管户机构"}
							}; 
	

 	//从合同表中选出不良资产管户机构为登录用户所在机构的不良资产
 	String sSql = "select BC.SerialNo as SerialNo, BC.ArtificialNo as ArtificialNo," + 	
				 " BC.BusinessType as BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName," + 
				 " BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
				 " BC.CustomerName as CustomerName," + 
				 " getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
				 " BC.BusinessSum as BusinessSum,BC.ShiftBalance as ShiftBalance,BC.Balance as Balance,"+
				 " BC.Maturity as Maturity,BC.Flag5, getItemName('Flag5',BC.Flag5) as Flag5Name," + 
				 " BC.ClassifyResult as ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName," +  
				 " BC.ShiftType as ShiftType,getItemName('ShiftType',BC.ShiftType) as ShiftTypeName," + 
				 
				 " BC.RecoveryUserID as RecoveryUserID," + 
				 " BC.RecoveryOrgID as RecoveryOrgID," + 
				 " getUserName(BC.RecoveryUserID) as RecoveryUserName," + 
				 " getOrgName(BC.RecoveryOrgID) as RecoveryOrgName," + 
				 
				 " getUserName(BC.ManageUserID) as ManageUserName," + 
				 " getOrgName(BC.ManageOrgID) as ManageOrgName" + 
				 " from BUSINESS_CONTRACT BC,TRACE_INFO TI" +
				 " Where BC.SerialNo = TI.ContractNo "+
				 " and TI.TraceUserid is not null"+	//跟踪人不为空
				 " and (TI.CancelFlag='' or TI.CancelFlag is null) ";
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("BC.SerialNo");	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("SerialNo,ShiftType,BusinessType,ShiftType,FinishType,FinishDate,ClassifyResult,RecoveryOrgID,RecoveryUserID,OccurType,Flag5,ClassifyResult",false);
    
	
	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,Balance,ActualPutOutSum","3");
	
	//设置选项双击及行宽
	doTemp.setHTMLStyle("ArtificialNo"," style={width:100px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName"," style={width:65px} ");
	doTemp.setHTMLStyle("OccurTypeName,Flag5Name"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName,RecoveryOrgName"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:80px} ");
	
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,OccurType,Flag5,ShiftType,ClassifyResult,RecoveryOrgName,RecoveryUserName","IsFilter","1");
	doTemp.setDDDWCode("OccurType","OccurType");
	doTemp.setDDDWCode("Flag5","Flag5");
	doTemp.setDDDWCode("ClassifyResult","ClassifyResult");
	doTemp.setDDDWCode("ShiftType","ShiftType");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
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
		{"true","","Button","合同详情","查看不良资产详情","viewAndEdit()",sResourcesPath}		
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
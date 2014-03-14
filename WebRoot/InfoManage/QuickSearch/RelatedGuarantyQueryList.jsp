<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   wwhe 2009-10-13
			Tester:
			Content: 借据信息快速查询
			Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：合同信息快速查询
		          
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
		String PG_TITLE = "关联担保合同快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "";
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//定义表头文件
	String sHeaders[][] = { 							
					{"SerialNo","合同流水号"},
					{"BusinessTypeName","业务品种"},
					{"CustomerID","借款人客户编号"},
					{"CustomerName","借款人名称"},	
					{"GuarantorName","提供担保人名称"},
					{"RelationShip","与借款人关联关系"},
					{"Pertain","是否属于同一集团"},
					{"VouchTypeName","担保方式"},
					{"BusinessSum","合同金额"},	
					{"Balance","合同余额"},										
					{"PutOutDate","合同起始日"},
					{"Maturity","合同到期日"},										
					{"ManageOrgName","管户机构"},
					{"HeaderOrgName","直属行"},
					{"ManageUserName","管户人"}
					}; 

	String sTab1 =  " (select BC.SerialNo,getBusinessName(BC.BusinessType) as BusinessTypeName,BC.CustomerID,BC.CustomerName, "+
	" BC.BusinessSum,BC.Balance,BC.PutOutDate,BC.Maturity,getOrgName(BC.OperateOrgID) as ManageOrgName, "+
	" getOrgName(getHeaderOrgID(BC.OperateOrgID)) as HeaderOrgName,getUserName(BC.OperateUserID) as ManageUserName "+
	" from Business_Contract BC where 1=1) Tab1 ";
	
	String sTab2 = " (select CR.SerialNo as CRSer,GC.CustomerID, "+
		 			" GC.GuarantorID,GC.GuarantorName,getItemName('GuarantyType',GC.GuarantyType) as VouchTypeName from GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR "+
		 			" where GC.serialno= CR.ObjectNo   and CR.ObjectType='GuarantyContract' "+
		    		" and CR.ObjectNo = GC.SerialNo	and GC.ContractType='010' "+
		 			" and (GC.ContractStatus = '010' or GC.ContractStatus = '020') and GC.ContractType='010' and GC.certtype like 'Ent%' "+
                    " and GC.GuarantorID in ( select customerid from business_duebill) "+
                    " and GC.Customerid in ( select customerid from business_duebill) order by GC.GuarantyValue desc) Tab2 ";
	
	String sTab3 = "(select Tab2.*,getItemName('RelationShip',CR.RelationShip) as RelationShip "+
			" from"+sTab2+" left outer join Customer_Relative CR on CR.Relativeid=Tab2.GuarantorID and CR.customerid=Tab2.CustomerID) Tab3 ";
	
	sSql = " select Tab1.SerialNo,Tab1.BusinessTypeName,Tab1.CustomerID,Tab1.CustomerName,Tab3.GuarantorName,Tab3.VouchTypeName, Tab3.RelationShip,Tab3.GuarantorID, "+
	" (case when Tab3.RelationShip is null or Tab3.RelationShip = '' then '否' else '是' end) as Pertain, "+
	" Tab1.BusinessSum,Tab1.Balance,Tab1.PutOutDate,Tab1.Maturity,Tab1.ManageOrgName,Tab1.HeaderOrgName,Tab1.ManageUserName from "+
	sTab1+','+sTab3+" where Tab1.SerialNo = Tab3.CRSer and Tab1.CustomerID <> Tab3.GuarantorID and Tab1.CustomerID in (select customerid from ent_info) order by Tab1.serialno ";
	
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    //doTemp.setKeyFilter("BC.SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	//doTemp.setKey("CustomerID",true);	
	//设置显示文本框的长度及事件属性
	//doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	//doTemp.setHTMLStyle("BusinessRate","style={width:60px} "); 	
	doTemp.setHTMLStyle("CustomerName,GuarantorName","style={width:350px} "); 
	//doTemp.setHTMLStyle("DirectionName","style={width:350px} "); 	
		
	//设置对齐方式
	//doTemp.setAlign("CK,BailRatio,BusinessSum,BusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2,TotalAssets,SellSum,EmployeeNumber,TermMonth,TermDay","3");	
	//小数为2，整数为5
	//doTemp.setCheckFormat("BailRatio,BusinessSum,CK","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	//doTemp.setType("BailRatio,BusinessSum,ActualBusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2,TotalAssets,SellSum,EmployeeNumber,RateFloat","Number");
	//doTemp.setCheckFormat("ActualBusinessRate","16");
	//doTemp.setCheckFormat("InputDate","3");
	//设置下拉列表
	//doTemp.setDDDWCode("ClassifyResult","ClassifyResult");
	//doTemp.setDDDWCode("OrgNature","CustomerType");
	//设置可见
	doTemp.setVisible("GuarantorID",false);
	
	//生成查询框
	//if(CurUser.hasRole("098")){
		//doTemp.setColumnAttribute("VouchTypeName","IsFilter","1");
	//}else{
	//	doTemp.setColumnAttribute("InputDate,Month,SerialNo,CustomerName,BusinessTypeName,ClassifyResult,BusinessSum,Balance, "+
	//	"OverdueBalance,ManageOrgName,PutOutDate,ActualMaturity,OverdueBalance,Flag3Name","IsFilter","1");
	//}
		doTemp.generateFilters(Sqlca);
		doTemp.setFilter(Sqlca,"1","SerialNo","");
		doTemp.setFilter(Sqlca,"2","CustomerID","");
		doTemp.setFilter(Sqlca,"3","CustomerName","");
		doTemp.setFilter(Sqlca,"4","BusinessTypeName","");
		doTemp.setFilter(Sqlca,"5","GuarantorName","");
		doTemp.setFilter(Sqlca,"6","RelationShip","");
		doTemp.setFilter(Sqlca,"7","PutOutDate","");
		doTemp.setFilter(Sqlca,"8","Maturity","");
		doTemp.setFilter(Sqlca,"9","ManageOrgName","");
		doTemp.setFilter(Sqlca,"10","HeaderOrgName","");
		doTemp.setFilter(Sqlca,"11","ManageUserName","");
		doTemp.parseFilterData(request,iPostChange);
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页
	//dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#CMIntSum","(select nvl(sum(BW.ActualDebitSum),0) from Business_WasteBook BW where BW.RelativeSerialNo=BD.SerialNo and BW.OccurSubject='2' and BW.OccurDate like '"+StringFunction.getToday().substring(0,7)+"%')");//added by bllou 20120316 获取当月利息收入
	//dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#AMIntSum","(select nvl(sum(BW.ActualDebitSum),0) from Business_WasteBook BW where BW.RelativeSerialNo=BD.SerialNo and BW.OccurSubject='2')");//added by bllou 20120316 获取总利息收入

	//生成HTMLDataWindow
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
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
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
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		//BusinessDueBill
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}	
	

	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

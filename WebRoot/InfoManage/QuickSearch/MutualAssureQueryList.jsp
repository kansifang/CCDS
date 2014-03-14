<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   CYHui 2005-1-26
			Tester:
			Content: 担保物信息快速查询
			Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：担保物信息快速查询
		          
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
		String PG_TITLE = "互保信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sComponentName = "";//--存放组件名称
	String PG_CONTENT_TITLE = "";
	String sTab1 = "";
	String sTab2 = "";
	String sTab3 = "";
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
	String sHeaders[][] =	{ 			
						{"SerialNo","合同编号"},
						{"CustomerID","借款人编号"},
						{"CustomerName","借款人名称"},
						{"BusinessType","业务品种"},
						{"BusinessSum","合同金额"},
						{"Balance","合同余额"},
						{"GuarantorName","提供担保客户名称"},
						//{"GuarantorName","提供担保客户在我行授信余额"},
						{"PutOutDate","合同起始日"},
						{"Maturity","合同到期日"},
						{"ManageOrgID","管护机构"},
						{"OrgName","直属行"},
						{"InputUserName","客户经理"}
					}; 
	
	sTab1 =	"(select BC.SerialNo,BC.customerid,BC.customername,getBusinessName(BusinessType) as BusinessType,BC.BusinessSum,BC.Balance,GC.guarantorid,GC.guarantorname, "+
	" BC.PutOutDate,BC.Maturity,getOrgName(BC.ManageOrgID) as ManageOrgID,getOrgName(getHeaderOrgID(BC.InputOrgID)) as OrgName,getUserName(BC.InputUserID) as InputUserName "+
	" from guaranty_contract GC,contract_relative CR,business_contract BC "+
	" where GC.serialno=CR.objectno and CR.serialno=BC.serialno and BC.customerid<>GC.guarantorid ) as Tab1";
	
	sTab2 = " (select BC.serialno,BC.customerid,BC.customername,GC.guarantorid,GC.guarantorname "+
	" from guaranty_contract GC,contract_relative CR,business_contract BC "+
	" where GC.serialno=CR.objectno and CR.serialno=BC.serialno and BC.customerid<>GC.guarantorid ) as Tab2";
	
	sTab3 = "(select distinct Tab1.SerialNo,Tab1.customerid as CustomerID,Tab1.customername as CustomerName,Tab1.BusinessType as BusinessType,Tab1.BusinessSum as BusinessSum, "+
	" Tab1.Balance as Balance,Tab1.guarantorname as GuarantorName,Tab1.PutOutDate as PutOutDate,Tab1.Maturity as Maturity,Tab1.ManageOrgID as ManageOrgID,Tab1.OrgName as OrgName,Tab1.InputUserName as InputUserName from"+
	sTab1+","+sTab2+" where Tab1.customerid=Tab2.guarantorid and Tab1.guarantorid = Tab2.customerid ) as Tab3 ";
	
	sSql = " select Tab3.SerialNo,Tab3.CustomerID,Tab3.CustomerName,Tab3.BusinessType,Tab3.BusinessSum,Tab3.Balance,Tab3.GuarantorName, "+
	" Tab3.PutOutDate,Tab3.Maturity,Tab3.ManageOrgID,Tab3.OrgName,Tab3.InputUserName from "+sTab3 +"where 1=1 ";

	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    //doTemp.setKeyFilter("CustomerID");
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置关键字
	//doTemp.setKey("GuarantyID",true);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName,GuarantorName","style={width:250px} ");  
	//设置不可见项
	//doTemp.setVisible("GuarantyType,InputOrgID",false);		
	//设置对齐方式
	//doTemp.setAlign("EvalNetValue,ConfirmValue","3");
	//doTemp.setType("EvalNetValue,ConfirmValue","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("PutOutDate,Maturity","3");	
	//设置下拉框
	//doTemp.setDDDWSql("BusinessType","select SortNo,TypeName from Business_Type where length(SortNo) > 4");

	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerID","");
	doTemp.setFilter(Sqlca,"3","CustomerName","");
	doTemp.setFilter(Sqlca,"4","BusinessType","");
	doTemp.setFilter(Sqlca,"5","CustomerName","");
	doTemp.setFilter(Sqlca,"6","GuarantorName","");
	doTemp.setFilter(Sqlca,"7","PutOutDate","");
	doTemp.setFilter(Sqlca,"8","Maturity","");
	doTemp.setFilter(Sqlca,"9","ManageOrgID","");
	doTemp.setFilter(Sqlca,"10","OrgName","");
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

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
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath}
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
		
	    sObjectType = "AfterLoan";
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

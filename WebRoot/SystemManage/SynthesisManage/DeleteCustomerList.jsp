<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Describe: 删除无效客户
			Input Param:
			Output Param:
			HistoryLog: fbkang on 2005/08/14 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "变更客户信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量：sql语句
	String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = {
						{"CustomerID","客户代码"},
						{"CustomerName","客户名称"},
						{"CustomerTypeName","客户类型"},
						{"CertTypeName","证件类型"},
						{"CertID","证件号码"}				
		      		};

	sSql = 	" select distinct CI.CustomerID,CI.CustomerName,getItemName('CustomerType',CI.CustomerType) as CustomerTypeName, "+
	" CI.CustomerType,getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID " +
	" from CUSTOMER_BELONG CB,CUSTOMER_INFO CI " +
	" where CB.CustomerID = CI.CustomerID "+			
	" and CB.OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	              
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "CUSTOMER_BELONG";
	//设置主键
	doTemp.setKey("CustomerID,OrgID,UserID",true);	
	
	//设置不可见性
	doTemp.setVisible("CustomerType",false);
	//置字段是否可更新，主要是外部函数产生的，类似UserName\OrgName	    
	doTemp.setUpdateable("CertTypeName,CustomerTypeName,UserName",false);
	//设置html格式
	doTemp.setHTMLStyle("CustomerID,UserName,CustomerTypeName,CertTypeName"," style={width:100px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
		
	//增加过滤器
	doTemp.setColumnAttribute("CustomerName,CertID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
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
			   {"true","","Button","清理","清理无效客户信息","clearCustomer()",sResourcesPath}
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
	/*~[Describe=清理无效客户;InputParam=无;OutPutParam=无;]~*/
	function clearCustomer()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sCustomerType = getItemValue(0,getRow(),"CustomerType"); 		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{			
			sReturn = PopPage("/SystemManage/SynthesisManage/DeleteCustomerAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType, "_self","");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
				return;  
			}else
			{
				alert(getBusinessMessage('947'));//无效客户被成功清理！
				reloadSelf();
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
	<script language=javascript>

	
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

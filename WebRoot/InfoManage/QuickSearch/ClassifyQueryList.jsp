<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   CYHui 2005-1-25
			Tester:
			Content: 风险分类信息快速查询
			Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：风险分类信息快速查询
		          
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
		String PG_TITLE = "风险分类信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	/*
	//定义表头文件（合同）
	String sHeaders[][] = {
							{"CustomerID","客户编号"},
							{"CustomerName","客户名称"},
							{"ObjectNo","合同流水号"},
							{"BusinessTypeName","业务品种"},
							{"BusinessType","业务类型"},
							{"BusinessSum","金额"},
							{"PutOutDate","合同起始日"},
							{"Maturity","合同到期日"},
							{"Currency","币种"},
							{"FinallyResult","认定结果"},
							{"FinallyResultName","认定结果"},
							{"balance","余额"},
							{"ClassifyDate","分类日期"},
					}; 
					
	sSql =		" select CR.ObjectType,Cr.ObjectNo,CR.SerialNo,BC.CustomerID,BC.CustomerName, " +
		" BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, " +
		" getItemName('Currency',BusinessCurrency) as Currency,BC.BusinessSum,BC.balance, " +
		" BC.PutOutDate,BC.Maturity,CR.FinallyResult,CR.ClassifyDate,getItemName('ClassifyResult',CR.FinallyResult) as FinallyResultName " +
	       		" from CLASSIFY_RECORD CR,BUSINESS_CONTRACT BC " +
		" where CR.ObjectNo = BC.SerialNo "+
		" and CR.ObjectType = 'BusinessContract' "+
		" and ManageOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	*/
	//定义表头文件（借据）
	String sHeaders[][] = {
							{"CustomerID","客户编号"},
							{"CustomerName","客户名称"},
							{"ObjectNo","借据流水号"},
							{"BusinessTypeName","业务品种"},
							{"BusinessType","业务类型"},
							{"BusinessSum","金额"},
							{"PutOutDate","起息日"},
							{"Maturity","到期日"},
							{"Currency","币种"},
							{"FinallyResult","认定结果"},
							{"FinallyResultName","认定结果"},
							{"balance","余额"},
							{"ClassifyDate","分类日期"},
					}; 
					
	sSql =		" select CR.ObjectType,Cr.ObjectNo,CR.SerialNo,BD.CustomerID,BD.CustomerName, " +
		" BD.BusinessType,getBusinessName(BD.BusinessType) as BusinessTypeName, " +
		" getItemName('Currency',BD.BusinessCurrency) as Currency,BD.BusinessSum,BD.balance, " +
		" BD.PutOutDate,BD.Maturity,CR.FinallyResult,CR.ClassifyDate,getItemName('ClassifyResult',CR.FinallyResult) as FinallyResultName " +
	       		" from CLASSIFY_RECORD CR,BUSINESS_DUEBIll BD " +
		" where CR.ObjectNo = BD.SerialNo "+
		" and CR.ObjectType in ('BusinessDueBill','ClassifyApply') "+
		" and BD.OperateOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("CR.SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CLASSIFY_RECORD";
	
	//设置关键字
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);

	//设置不可见项
	doTemp.setVisible("ObjectType,SerialNo,CustomerID,BusinessType,FinallyResult",false);

	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("Currency","style={width:60px} ");  
		
	//设置对齐方式
	doTemp.setAlign("BusinessSum,balance","3");
	doTemp.setType("BusinessSum,balance","Number");

	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum,balance","2");
	doTemp.setDDDWCode("FinallyResult","ClassifyResult");	
	
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","BusinessTypeName","");
	doTemp.setFilter(Sqlca,"3","ObjectNo","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","balance","");
	doTemp.setFilter(Sqlca,"6","FinallyResult","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"7","ClassifyDate","");
	
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
		sObjectNo =getItemValue(0,getRow(),"ObjectNo");
		sObjectType =getItemValue(0,getRow(),"ObjectType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			OpenComp("ClassifyQueryInfo","/InfoManage/QuickSearch/ClassifyQueryInfo.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo, "_bank",OpenStyle);
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

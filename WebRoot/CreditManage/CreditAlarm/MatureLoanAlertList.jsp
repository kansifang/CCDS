<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: 显示即将到期业务_List
		Input Param:			
			Days：天数（7天；15天；30天）			   
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "即将到期业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	int iDays = 0;
	String sBeginDate = "",sEndDate="";
	String sSql = "";
		
	//获得组件参数		
	String sDays = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Days"));	
	//将空值转化为空字符串	
	if(sDays == null) sDays = "";	
	//获得页面参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
 	//将字符串的天数转化为整型
 	if(!sDays.equals("")) iDays = Integer.parseInt(sDays);
	sBeginDate=StringFunction.getToday();
	sEndDate = StringFunction.getRelativeDate(StringFunction.getToday(),iDays);
	
	//列表表头
	String sHeaders[][] = {
							{"RelativeSerialNo2","合同流水号"},
							{"SerialNo","借据流水号"},
							{"CustomerName","客户名称"},													
							{"BusinessType","业务品种"},
							{"BusinessSum","发放金额"},
							{"Balance","余额"},
							{"Maturity","到期日"},
							{"InterestBalance1","表内欠息金额"},
							{"InterestBalance2","表外欠息金额"},
							{"FineBalance1","本金罚息"},
							{"FineBalance2","利息罚息"},												
							{"PutoutDate","发放日"}
							
						};
			              
	
	sSql = 	" select RelativeSerialNo2,SerialNo,CustomerName, "+
			" getBusinessName(BusinessType) as BusinessType, "+
			" BusinessSum,nvl(Balance,0) as Balance, Maturity,"+
			" InterestBalance1,InterestBalance2,FineBalance1, "+
			" FineBalance2,PutoutDate "+
			" from BUSINESS_DUEBILL BD " + 
			" where Maturity >= '"+sBeginDate+"' and Maturity<='"+sEndDate+"' "+			
			//" and OperateOrgID = '"+CurOrg.OrgID+"' "+
			//" and OperateUserID = '"+CurUser.UserID+"' "+
			" and exists(select 1 from Business_contract "+
			" where serialno=BD.RelativeSerialNo2  "+
			" and ManageOrgID='"+CurOrg.OrgID+"' and ManageUserID='"+CurUser.UserID+"') "+
			" and (FinishDate is null or FinishDate = '' or FinishDate=' ') ";
        				
	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_DUEBILL";
	doTemp.setKey("SerialNo",true);
	//定义列表表头
	doTemp.setHeader(sHeaders);
	
	//设置格式
	doTemp.setHTMLStyle("CustomerName","style={width:200px}");
	doTemp.setCheckFormat("BusinessSum,Balance,InterestBalance","2");
	doTemp.setAlign("BusinessType","2");
	//设置过滤器
	doTemp.setColumnAttribute("RelativeSerialNo2,Customername","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","借据详情","查看借据详情","viewDueBill()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------	
	/*~[Describe=借据详情;InputParam=无;OutPutParam=无;]~*/
	function viewDueBill()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sObjectType = "BusinessDueBill";
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
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

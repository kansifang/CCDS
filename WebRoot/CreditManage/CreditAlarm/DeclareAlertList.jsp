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
							{"SerialNo","案件编号"},
							{"LawCaseName","案件名称"},				
							{"LawCaseTypeName","案件类型"},
							{"LawsuitStatusName","我行诉讼地位"},
							{"LawCaseOrg","破产人名称"},
							{"ApplyDate","宣告破产日"}, 
							{"DeclareDate","债权申报日期"},
						}; 
			              
	
	sSql = 	" select SerialNo,LawCaseName,getItemName('LawCaseType',LawCaseType) as LawCaseTypeName, "+
			" getItemName('LawsuitStatus',LawsuitStatus) as LawsuitStatusName, LawCaseOrg,DeclareDate,PigeonholeDate "+
			" from LAWCASE_INFO "+
			" where DeclareDate >= '"+sBeginDate+"' and DeclareDate <='"+sEndDate+"'";
        				
	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "LAWCASE_INFO";
	doTemp.setKey("SerialNo",true);
	//定义列表表头
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("SerialNo,PigeonholeDate",false);

	//设置过滤器
	doTemp.setColumnAttribute("SerialNo,LawCaseName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.setPageSize(10);
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
			{"true","","Button","案件详情","查看案件详情","viewCaseDetail()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------	
	
	/*~[Describe=案件详情;InputParam=无;OutPutParam=无;]~*/
	function viewCaseDetail()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sPigeonholeDate = getItemValue(0,getRow(),"PigeonholeDate");
		
		if(typeof(sObjectNo)=="undefined" || sObjectNo=="")
		{
			alert(getHtmlMessage('1'));
			return;
		}	
		sObjectType = "LawCase";
		sViewID = "";		
		if(typeof(sPigeonholeDate)=="undefined" || sPigeonholeDate=="")
		{
			sViewID = "001";
		}	
		else
			sViewID = "002";					
		openObject(sObjectType,sObjectNo,sViewID);	
		reloadSelf();	
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

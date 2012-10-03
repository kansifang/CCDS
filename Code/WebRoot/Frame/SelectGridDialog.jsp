<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 20050826
		Tester:
		Content: 选择对话框页面
		Input Param:
		Output param:
		History Log: 
			zywei 2007/10/11 解决大数据量查询引起的响应延迟
			xhgao 2009/04/09 增加KeyFilter加快查询速度；增加双击确认
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "选择信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//获取参数：查询名称和参数
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	
	//将空值转化为空字符串
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
		
	//定义变量：查询结果集
	ASResultSet rs = null;
	//定义变量：SQL语句
	String sSql = "";
	//定义变量：查询类型、展现方式、参数、隐藏域
	String sSelType = "",sSelBrowseMode = "",sSelArgs = "",sSelHideField = "";
	//定义变量：代码、字段显示中文名称、表名、主键
	String sSelCode = "",sSelFieldName = "",sSelTableName = "",sSelPrimaryKey = "";
	//定义变量：字段显示风格、返回值、过滤字段、选择方式
	String sSelFieldDisp = "",sSelReturnValue = "",sSelFilterField = "",sMutilOrSingle = "";
	//定义变量：显示字段对齐方式、显示字段类型、显示字段检查模式、是否根据检索条件查询、属性5
	String sAttribute1 = "",sAttribute2 = "",sAttribute3 = "",sAttribute4 = "",sAttribute5 = "";
	//定义变量：数组长度
	int l = 0;
	//定义变量：返回字段的个数
	int iReturnFiledNum = 0;
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	sSql =  " select SelType,SelTableName,SelPrimaryKey,SelBrowseMode,SelArgs,SelHideField,SelCode, "+
			" SelFieldName,SelFieldDisp,SelReturnValue,SelFilterField,MutilOrSingle,Attribute1, "+
			" Attribute2,Attribute3,Attribute4,Attribute5 "+
			" from SELECT_CATALOG "+
			" where SelName = '"+sSelName+"' "+
			" and IsInUse = '1' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sSelType = rs.getString("SelType");
		sSelTableName = rs.getString("SelTableName");
		sSelPrimaryKey = rs.getString("SelPrimaryKey");
		sSelBrowseMode = rs.getString("SelBrowseMode");
		sSelArgs = rs.getString("SelArgs");
		sSelHideField = rs.getString("SelHideField");
		sSelCode = rs.getString("SelCode");
		sSelFieldName = rs.getString("SelFieldName");
		sSelFieldDisp = rs.getString("SelFieldDisp");
		sSelReturnValue = rs.getString("SelReturnValue");
		sSelFilterField = rs.getString("SelFilterField");
		sMutilOrSingle = rs.getString("MutilOrSingle");
		sAttribute1 = rs.getString("Attribute1");
		sAttribute2 = rs.getString("Attribute2");
		sAttribute3 = rs.getString("Attribute3");
		sAttribute4 = rs.getString("Attribute4");
		sAttribute5 = rs.getString("Attribute5");
	}
	rs.getStatement().close();

	//将空值转化为空字符串
	if(sSelType == null) sSelType = "";
	if(sSelTableName == null) sSelTableName = "";
	if(sSelPrimaryKey == null) sSelPrimaryKey = "";
	if(sSelBrowseMode == null) sSelBrowseMode = "";
	if(sSelArgs == null) sSelArgs = "";
	else sSelArgs = sSelArgs.trim();
	if(sSelHideField == null) sSelHideField = "";
	else sSelHideField = sSelHideField.trim();
	if(sSelCode == null) sSelCode = "";
	else sSelCode = sSelCode.trim();	
	if(sSelFieldName == null) sSelFieldName = "";
	else sSelFieldName = sSelFieldName.trim();
	if(sSelFieldDisp == null) sSelFieldDisp = "";
	else sSelFieldDisp = sSelFieldDisp.trim();
	if(sSelReturnValue == null) sSelReturnValue = "";
	else sSelReturnValue = sSelReturnValue.trim();
	if(sSelFilterField == null) sSelFilterField = "";
	else sSelFilterField = sSelFilterField.trim();
	if(sMutilOrSingle == null) sMutilOrSingle = "";
	if(sAttribute1 == null) sAttribute1 = "";
	if(sAttribute2 == null) sAttribute2 = "";
	if(sAttribute3 == null) sAttribute3 = "";
	if(sAttribute4 == null) sAttribute4 = "";
	if(sAttribute5 == null) sAttribute5 = "";
	
	//获取返回值
	StringTokenizer st = new StringTokenizer(sSelReturnValue,"@");
	String [] sReturnValue = new String[st.countTokens()];  
	while (st.hasMoreTokens()) 
	{
		sReturnValue[l] = st.nextToken();                
		l ++;
	}
	iReturnFiledNum = sReturnValue.length;
	//设置显示标题
	String sHeaders = sSelFieldName;
	
	//将Sql中的变量用相对应的值替换	
	StringTokenizer stArgs = new StringTokenizer(sParaString,",");
	while (stArgs.hasMoreTokens()) 
	{
		try{
			String sArgName  = stArgs.nextToken().trim();
			String sArgValue  = stArgs.nextToken().trim();		
			sSelCode = StringFunction.replace(sSelCode,"#"+sArgName,sArgValue );		
		}catch(NoSuchElementException ex){
			throw new Exception("输入参数格式错误！");
		}
	}	
	
	//实例化DataObject	
	ASDataObject doTemp = new ASDataObject(sSelCode);
	doTemp.UpdateTable = sSelTableName;
	doTemp.setKey(sSelPrimaryKey,true);
	doTemp.setHeader(sHeaders);	
	
	//设置隐藏字段	
	if(!sSelHideField.equals("")) doTemp.setVisible(sSelHideField,false);	
	
	//设置对齐格式
	StringTokenizer stAlign = new StringTokenizer(sAttribute1,"@");
	while (stAlign.hasMoreTokens()) 
	{
		String sAlignName  = stAlign.nextToken().trim();
		String sAlignValue  = stAlign.nextToken().trim();		
		doTemp.setAlign(sAlignName,sAlignValue);  	
	}
	
	//设置类型
	StringTokenizer stType = new StringTokenizer(sAttribute2,"@");
	while (stType.hasMoreTokens()) 
	{
		String sTypeName  = stType.nextToken().trim();
		String sTypeValue  = stType.nextToken().trim();		
		doTemp.setType(sTypeName,sTypeValue);  	
	}
	
	//设置检查模式
	StringTokenizer stCheck = new StringTokenizer(sAttribute3,"@");
	while (stCheck.hasMoreTokens()) 
	{
		String sCheckName  = stCheck.nextToken().trim();
		String sCheckValue  = stCheck.nextToken().trim();		
		doTemp.setCheckFormat(sCheckName,sCheckValue);  	
	}	
	
	//KeyFilter加快查询速度
	StringTokenizer stFilter = new StringTokenizer(sAttribute4,"@");
	String sFilter="";
	while (stFilter.hasMoreTokens()) 
	{
		String sFilterValue  = stFilter.nextToken().trim();	
		sFilter=sFilter+"||"+sFilterValue;
	}
	if(sFilter.length()>2)
	{
		doTemp.setKeyFilter(sFilter.substring(2,sFilter.length()));
	}
	
	//设置显示格式
	StringTokenizer stDisp = new StringTokenizer(sSelFieldDisp,"@");
	while (stDisp.hasMoreTokens()) 
	{
		String sDispName  = stDisp.nextToken().trim();
		String sDispValue  = stDisp.nextToken().trim();		
		doTemp.setHTMLStyle(sDispName,sDispValue);  
	}		
	
	//设置检索区
	if(!sSelFilterField.equals(""))
	{		
		doTemp.setColumnAttribute(sSelFilterField,"IsFilter","1");		
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	}
	
	doTemp.appendHTMLStyle(""," style=\"cursor:hand\" ondblclick=javascript:parent.parent.returnSelection() ");

	//如果需要根据检索条件查询结果，则默认查询为空
	if(sAttribute4.equals("1") && !doTemp.haveReceivedFilterCriteria())
		doTemp.WhereClause += " and 1=2 ";
	
	if(!sMutilOrSingle.equals("Single"))
		doTemp.multiSelectionEnabled=true;			
	//实例化DataWindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
%>

<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/	
	function doSearch()
	{
		document.forms("form1").submit();
	}
	
	/*~[Describe=将选择行的信息拼成字符串并返回;InputParam=无;OutPutParam=无;]~*/	
	function mySelectRow()
	{   
		if (getRow()<0) return;
		
		var sReturnValue = "";
		try{
			<%
			for(int j = 0 ; j < sReturnValue.length ; j ++)
			{			
			%>		
			sReturnValue += getItemValue(0,getRow(),"<%=sReturnValue[j]%>") + "@";
			<%					
			}
			%>
		}catch(e){
			return;
		}
		parent.sObjectInfo = sReturnValue; 
	}
	
	/*~[Describe=将选择行的信息拼成字符串并返回;InputParam=无;OutPutParam=无;]~*/	
	function returnValue()
	{   
		var sReturnValue = "";
		var sMutilOrSingle = "<%=sMutilOrSingle%>";		
		if(sMutilOrSingle == "Multi")		//多选
			sReturnValue = myMultiSelectRow();
		else
			sReturnValue = mySingleSelectRow();
		
		sReturnSplit = sReturnValue.split("@");//by jgao，因为在返回时，只要判断第一个是undefined，就可以说明它没有选择到任何数据
		if(sReturnSplit[0]=="undefined")       //其他项不会有undefied的。
		{
			parent.sObjectInfo="";
		}else{
			parent.sObjectInfo = sReturnValue;
		}		
	}
	
	/*~[Describe=将选择行的信息拼成字符串并返回;InputParam=无;OutPutParam=无;]~*/	
	function mySingleSelectRow()
	{   
		try{			
			var sReturnValue = "";			
			<%
			for(int j = 0 ; j < iReturnFiledNum ; j ++)
			{			
			%>				
				sReturnValue += getItemValue(0,getRow(),"<%=sReturnValue[j]%>") + "@";
			<%					
			}
			%>				
		}catch(e){
			return;
		}				
		return (sReturnValue); 
	}
	
	/*~[Describe=将选择行的信息拼成字符串并返回;InputParam=无;OutPutParam=无;]~*/	
	function myMultiSelectRow()
	{   
		try{
			var b = getRowCount(0);
			var sReturnValue = "";				
			for(var iMSR = 0 ; iMSR < b ; iMSR++)
			{
				var a = getItemValue(0,iMSR,"MultiSelectionFlag");				
				if(a == "√")
				{			
					<%
					for(int j = 0 ; j < iReturnFiledNum ; j ++)
					{		
					%>			
						sReturnValue += getItemValue(0,getRow(),"<%=sReturnValue[j]%>") + "@";
					<%
					}
					%>
				}				
			}
		}catch(e){
			return;
		}				
		return (sReturnValue); 
	}
			
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');		
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
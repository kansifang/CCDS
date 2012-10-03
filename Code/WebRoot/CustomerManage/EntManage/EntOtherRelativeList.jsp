<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --FMWu 2004-11-29
		Tester:
		Describe: --其他关联方信息列表;
		Input Param:
			CustomerID： --当前客户编号
		Output Param:
			CustomerID：  --当前客户编号
			RelativeID：  --关联客户组织机构代码
			Relationship：--关联关系  
			EditRight:--权限代码（01：查看权；02：维护权）          
		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	参数、格式				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "其他关联方信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
    String sSql ="";//--存放sql语句
	//获得页面参数	
	
	//获得组件参数	，客户代码
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = {
				            {"CertID","上下游企业证件号码"},
				            {"CustomerName","上下游企业名称"},
				            {"RelationName","上下游关系"},			
						    {"OrgName","登记机构"},
						    {"UserName","登记人"}
						  };   		   		
	

 	      sSql =	" select CustomerID,RelativeID,CertID,CustomerName,RelationShip,getItemName('RelationShip',RelationShip) as RelationName, " +
					" InputOrgId,getOrgName(InputOrgId) as OrgName,InputUserId,getUserName(InputUserId) as UserName " +
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"' "+
					" and RelationShip like '99%' "+
					" and length(RelationShip)>2";	

   //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置表修改
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
    //设置主键
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);	 //为后面的删除
	//设置不可见项
	doTemp.setVisible("CustomerID,RelativeID,RelationShip,InputUserId,InputOrgId",false);	    
	//通常用于外部存储函数得到的字段
	doTemp.setUpdateable("UserName,RelationName,OrgName",false);  
    doTemp.setHTMLStyle("OrgName,CustomerName"," style={width:200px} "); 
    doTemp.setHTMLStyle("UserName,RelationName"," style={width:80px} ");           
    		 
	doTemp.setAlign("RelationName,UserName","2");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	//设置setEvent
	//调用事件，现在事件的处理是在后台的类中处理
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
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
		{"true","","Button","新增","新增其他关联方信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看其他关联方信息详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除其他关联方信息","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntOtherRelativeInfo.jsp?EditRight=02","_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserId");//--用户代码
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--客户代码		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}	
		}	
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{    			
		sUserID=getItemValue(0,getRow(),"InputUserId");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01'; 
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");//--客户代码
		sRelationShip = getItemValue(0,getRow(),"RelationShip");//--关联关系
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--关联客户代码
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)		
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{       
			OpenPage("/CustomerManage/EntManage/EntOtherRelativeInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight="+sEditRight, "_self","");
		}
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

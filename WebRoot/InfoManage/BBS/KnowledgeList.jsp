<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cwliu 2004-12-09
		Tester:
		Describe: 营销信息管理
		Input Param:
		
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "营销信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数
	
	//获得组件参数
	String sCatalogID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//非管理人员无权限 add by zrli 
	if(!(CurUser.hasRole("086")||CurUser.hasRole("286")||CurUser.hasRole("486"))){
		CurComp.setAttribute("RightType","ReadOnly");
	}
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	String sHeaders[][] = {     {"ID","信息编号"},
	                            {"Title","标题"},
	                            {"Demo","导读"},
				                {"Source","来源"},
				                {"Author","发布者"},
				                {"CreateDate","创建日期"},
				                {"ModifiedDate","修改日期"},
				                {"Hits","点击次数"},
				                {"Replies","回复次数"},
				                {"KnowledgeType","类型"}
	                      };
			      		
	String  sSql =  " select KO.ID,CatalogID,Attribute1,"+
					" getItemName('KnowledgeType',Attribute1) as KnowledgeType," +
					" Title,Demo,Source,Author,CreateDate,ModifiedDate,Hits,Replies " +
					" from KNOWLEDGE_CATALOG KC,KNOWLEDGE_OBJECT KO" +
					" where KC.ID=KO.ID and KO.ObjectID='"+sCatalogID+"'  ";


	//用sSql生成数据窗体对象

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="KNOWLEDGE_CATALOG";
	
	doTemp.setKey("ID",true);
	doTemp.setVisible("ID,CatalogID,Attribute1,Attribute2,Replies,Hits",false);
	
	doTemp.setType("Hits,Replies","Number");
	doTemp.setCheckFormat("Hits,Replies","5");	
	doTemp.setHTMLStyle("CreateDate,ModifiedDate"," style={width:80px} ");
	doTemp.setHTMLStyle("Hits,Replies,KnowledgeType"," style={width:50px} ");
	doTemp.setAlign("KnowledgeType","2");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	//删除关联信息
	//dwTemp.setEvent("AfterDelete","!CustomerManage.删除乡村镇关联(#SerialNo)");


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{((CurUser.hasRole("099")||CurUser.hasRole("098")||CurUser.hasRole("097"))?"false":"true"),"","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{((CurUser.hasRole("099")||CurUser.hasRole("098")||CurUser.hasRole("097"))?"false":"true"),"","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{((CurUser.hasRole("099")||CurUser.hasRole("098")||CurUser.hasRole("097"))?"false":"true"),"","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{((CurUser.hasRole("099")||CurUser.hasRole("098")||CurUser.hasRole("097"))?"false":"true"),"","Button","查看附件内容","查看附件内容","viewFile()",sResourcesPath},	
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
		OpenPage("/InfoManage/BBS/KnowledgeInfo.jsp","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sID=getItemValue(0,getRow(),"ID");
		if (typeof(sID)=="undefined" || sID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sID=getItemValue(0,getRow(),"ID");
		if (typeof(sID)=="undefined" || sID.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		OpenPage("/InfoManage/BBS/KnowledgeInfo.jsp?ID="+sID,"_self","");
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
    function viewFile(sBoardNo)
    {
   		sID = getItemValue(0,getRow(),"ID");
    	if (typeof(sID)=="undefined" || sID.length==0)
    	{        
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;         
    	}
    	else{
        	popComp("BoardView","/SystemManage/SynthesisManage/BoardView.jsp","BoardNo="+sID,"","");
        	reloadSelf();
        }	
    }
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: 信用评级快速查询
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：信用评级信息快速查询
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信用评级信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "";
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"ObjectNo","客户编号"},
							{"CustomerName","客户名称"},
							{"EvaluateDate","评估日期"},
							{"EvaluateScore","评估分值"},
							{"EvaluateResult","评估结果"},
							{"CognDate","认定日期"},
							{"CognScore","认定分值"},
							{"CognResult","认定结果"},
						}; 	

	sSql =	" select SerialNo,ObjectType,ObjectNo,getCustomerName(ObjectNo) as CustomerName, " +
			" EvaluateDate,EvaluateScore,EvaluateResult,CognDate,CognScore,CognResult,UserID,OrgID " +
	       	" from EVALUATE_RECORD" +
			" where ObjectType = 'Customer' "+
			" and OrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo||ObjectType||ObjectNo");
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "EVALUATE_RECORD";
	
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	doTemp.setVisible("UserID,OrgID",false);

	//设置不可见项
	doTemp.setVisible("SerialNo,ObjectType",false);

	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("EvaluateDate,CognDate,EvaluateResult,CognResult","style={width:70px} ");  
		
	//设置对齐方式
	doTemp.setAlign("EvaluateDate,CognDate,EvaluateResult,CognResult","2");
	doTemp.setAlign("EvaluateScore,CognScore","3");
	doTemp.setType("EvaluateScore,CognScore","Number");

	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum","2");
	doTemp.setCheckFormat("TermMonth","5");
	
	//指定双击事件

	//生成查询框
	doTemp.setColumnAttribute("CustomerName,ObjectNo,EvaluateResult,CognResult","IsFilter","1");

	doTemp.generateFilters(Sqlca);
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
		{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/

	function viewAndEdit()
	{
		
		var sSerialNo	  = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo	  = getItemValue(0,getRow(),"ObjectNo");
		var sUserID       = getItemValue(0,getRow(),"UserID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择一次评估记录！");
		}else
		{
			var sEditable="true";
			if(sUserID!="<%=CurUser.UserID%>")
				sEditable="false";
			OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&ObjectType=Customer&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo+"&Editable="+sEditable,"_blank",OpenStyle);
		}

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

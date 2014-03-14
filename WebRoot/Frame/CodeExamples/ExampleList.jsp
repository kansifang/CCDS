<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content: 示例列表页面
			Input Param:
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
		String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql;
	String sInputUser; //排序编号
	
	//获得组件参数	
	sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	if(sInputUser==null) sInputUser="";
	//获得页面参数	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ExampleList"; //模版编号
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混淆
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	//doTemp.setColumnAttribute("ExampleName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	doTemp.UpdateTable="EXAMPLE_INFO";
	doTemp.setKey("ExampleID",true);
	//doTemp.multiSelectionEnabled=true;
//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	if(!sInputUser.equals("")) doTemp.WhereClause += " and InputUser = '"+sInputUser+"'";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"true","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
			{"true","","Button","详情111","查看/修改详情","viewAndEdit()",sResourcesPath},
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
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/Frame/CodeExamples/ExampleInfo.jsp","_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sExampleID = getItemValue(0,getRow(),"ExampleID");
		
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sExampleID=getItemValue(0,getRow(),"ExampleID");
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		OpenPage("/Frame/CodeExamples/ExampleInfo.jsp?ExampleID="+sExampleID,"_self","");
	}
	
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function openWithObjectViewer()
	{
		sExampleID=getItemValue(0,getRow(),"ExampleID");
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		
		openObject("Example",sExampleID,"001");//使用ObjectViewer以视图001打开Example，
		/*
		 * [参考]
		 * 等同于这一句：
		 * OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ComponentName=对象查看器&ObjectType=Example&ObjectNo="+sExampleID+"&ViewID=001","_blank",OpenStyle);
		 */
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

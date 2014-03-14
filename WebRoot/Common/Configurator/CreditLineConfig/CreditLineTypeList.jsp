<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:       cjiang   2005-8-1 23:55
			Tester:
			Content:      授信额度类型列表
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
		String PG_TITLE = "授信额度类型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>

<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][]={ {"CLTypeID","额度类型编号"},
			      {"CLTypeName","额度类型名称"},
			      {"CLKeeperClass","额度管理器类名"},
			      {"Line1BalExpr","额度余额计算表达式"},
			      {"Line2BalExpr","敞口余额计算表达式"},
			      {"Line3BalExpr","担保余额计算表达式"},					    
			      {"CheckExpr","额度判断script"},
			      {"EffStatus","生效标志"},
			      {"Circulatable","循环_不可循环"},
			      {"BeneficialType","自用_他用"},
			      {"CreationWizard","创建Wizard"},
			      {"DONo","额度主DataObject"},
			      {"OverviewComp","额度信息一览组件"},
			      {"CurrencyMode","汇率计算模式"},
			      {"ApprovalPolicy","审批流程简化程度"},
			      {"ContractFlag","是否需要签署协议"},
			      {"SubContractFlag","项下业务是否需要签署合同"},
			      {"DefaultLimitation","默认的限制类型"}
			  };
	String sSql = " select CLTypeID,CLTypeName,CLKeeperClass, "+
	              " getItemName('EffStatus',EffStatus) as EffStatus, " +
	              " getItemName('YesNo',Circulatable) as Circulatable, "+
	              " getItemName('BeneficialType',BeneficialType) as BeneficialType, " +
	              " Line1BalExpr,Line2BalExpr,Line3BalExpr,CheckExpr, "+
	              " CreationWizard , DONo , OverviewComp , " +
	              " CurrencyMode , ApprovalPolicy , getItemName('YesNo',ContractFlag) as ContractFlag ," +
	              " getItemName('YesNo',SubContractFlag) as  SubContractFlag , DefaultLimitation " +
	              " from CL_TYPE where 1=1" ;
	
	//通过显示模版产生ASDataObject对象doTemp
	//String sTempletNo = "ExampleInfo1"; //模版编号
	//String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混淆
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="CL_TYPE";
	doTemp.setKey("CLTypeID",true);
	
	doTemp.setAlign("EffStatus,Circulatable,BeneficialType,ContractFlag,SubContractFlag","2");
	doTemp.setHTMLStyle("Line1BalExpr,Line2BalExpr,Line3BalExpr,CheckExpr","style={width:200px}");
	doTemp.setHTMLStyle("EffStatus,BeneficialType","style={width:60px}");
	doTemp.setHTMLStyle("Circulatable","style={width:80px}");
	
	doTemp.setColumnAttribute("CLTypeID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"false","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath}
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
		OpenPage("/Common/Configurator/CreditLineConfig/CreditLineTypeInfo.jsp","_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCLTypeID = getItemValue(0,getRow(),"CLTypeID");
		
		if (typeof(sCLTypeID)=="undefined" || sCLTypeID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sCLTypeID=getItemValue(0,getRow(),"CLTypeID");
		if (typeof(sCLTypeID)=="undefined" || sCLTypeID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		OpenPage("/Common/Configurator/CreditLineConfig/CreditLineTypeInfo.jsp?CLTypeID="+sCLTypeID,"_self","");
	}
	
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function openWithObjectViewer()
	{
		sCLTypeID=getItemValue(0,getRow(),"CLTypeID");
		if (typeof(sCLTypeID)=="undefined" || sCLTypeID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		
		openObject("CLTypeID",sCLTypeID,"001");//使用ObjectViewer以视图001打开Example，
		
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

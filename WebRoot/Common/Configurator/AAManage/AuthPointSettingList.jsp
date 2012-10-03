
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2005/08/28
		Tester:
		Content: 授权点列表页面
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权点列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//CurPage.setAttribute("ShowDetailArea","true");
	//CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	
	//获得页面参数	
	String sPolicyID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PolicyID"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	//将空值转化为空字符串
	if(sPolicyID == null) sPolicyID = "";
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {														
							{"PolicyName","授权方案"},
							{"FlowName","流程"},
							{"PhaseName","阶段"},							
							{"OrgName","机构"},
							{"ProductName","产品"},
							{"GuarantyTypeName","担保方式"},							
							{"CustBalanceCeiling","终批单户金额授权上限（元）"},
							{"CustExposureCeilin","终批单户敞口授权上限（元）"},
							{"BizBalanceCeiling","终批单笔金额上限（元）"},
							{"BizExposureCeiling","终批单笔敞口授权上限（元）"},
							{"InterestRateFloor","终批利率下限（％）"},
							{"EffDate","启用日期"},
							{"EffStatus","生效状态"}
						  };
						  
	sSql =  " select AuthID,PolicyID,SortNo,getPolicyName(PolicyID) as PolicyName, "+
			" getFlowName(FlowNo) as FlowName,getPhaseName(FlowNo,PhaseNo) as PhaseName, "+
			" GetOrgName(OrgID) as OrgName,getBusinessName(ProductID) as ProductName, "+
			" getItemName('VouchType',GuarantyType) as GuarantyTypeName,CustBalanceCeiling, "+
			" CustExposureCeilin,BizBalanceCeiling,BizExposureCeiling,InterestRateFloor, "+
			" EffDate,getItemName('YesNo',EffStatus) as EffStatus "+
			" from AA_AUTHPOINT "+
			" Where PolicyID = '"+sPolicyID+"' "+
			" and FlowNo='"+sFlowNo+"' "+
			" and PhaseNo='"+sPhaseNo+"' "+
			" order by SortNo";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "AA_AUTHPOINT";
	doTemp.setKey("AuthID,PolicyID",true);
	doTemp.setHeader(sHeaders);
	//设置不可见	
	doTemp.setVisible("AuthID,PolicyID,SortNo",false);
	//设置数据输入项格式
	doTemp.setAlign("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin,InterestRateFloor","3");
	doTemp.setType("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin,InterestRateFloor","Number");
	doTemp.setCheckFormat("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin","2");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
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
		PopComp("NewAuthPoint","/Common/Configurator/AAManage/AuthPointSettingInfo.jsp","PolicyID=<%=sPolicyID%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>","","");	
		reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		//授权点ID   
	    sAuthID = getItemValue(0,getRow(),"AuthID");			
		if (typeof(sAuthID) == "undefined" || sAuthID.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			sReturn=RunMethod("PublicMethod","GetColValue","ExceptionID,AA_EXCEPTION,String@AuthID@"+sAuthID);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert("所选授权点已被某些例外条件引用，不能删除！");
				return;
			}else
			{
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		//授权点ID  
		sAuthID = getItemValue(0,getRow(),"AuthID");
		if (typeof(sAuthID) == "undefined" || sAuthID.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		PopComp("AuthPointEdit","/Common/Configurator/AAManage/AuthPointSettingInfo.jsp","PolicyID=<%=sPolicyID%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>&AuthID="+sAuthID,"","");
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
	hideFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

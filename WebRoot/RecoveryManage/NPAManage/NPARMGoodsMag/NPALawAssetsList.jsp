<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-2
		Tester:
		Content: 查封资产列表
		Input Param:
				ObjectType：对象类型
				ObjectNo：对象编号
				CurItemID：项目编号
		Output param:
				
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "查封资产列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	String sItemID = "";  
	String sWhereCondition = "";
	
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	String sCurItemID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurItemID")); 
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sCurItemID == null) sCurItemID = "";
	
	if(sCurItemID.equals("075010")) //未退出查封的资产
		sItemID="020";
	else if(sCurItemID.equals("075020")) //已退出查封的资产
		sItemID="030";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"LawCaseName","案件名称"},
							{"SerialNo","查封资产编号"},				
							{"AssetName","查封资产名称"},
							{"AssetTypeName","查封资产类别"},
							{"LandownerNo","查封资产数量"},
							{"AssetSum","查封资产总额(元)"},
							{"PropertyOrg","查封资产所有人"},
							{"BeginDate","查封日期"}, 
							{"EndDate","查封到期日"}, 
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"},
							{"InputDate","登记日期"}
						}; 
	
	if(sItemID.equals("020"))
	{
		sWhereCondition = " and AI.AssetStatus = '01' order by InputDate desc ";  //未退出查封的资产
	}
	
	if(sItemID.equals("030"))
	{
		sWhereCondition = " and AI.AssetStatus = '02' order by InputDate desc ";  //已退出查封的资产
	}
	
	//从资产信息表中查出当前用户管户的查封资产信息		
	sSql =  " select LI.LawCaseName,AI.SerialNo,AI.ObjectType, "+
			" AI.AssetName,AI.AssetType,getItemName('LawsuitAssetsType',AI.AssetType) as AssetTypeName,"+
			" AI.LandownerNo,AI.AssetSum,AI.PropertyOrg,AI.BeginDate,AI.EndDate, "+
			" AI.InputUserID,getUserName(AI.InputUserID) as InputUserName,AI.InputOrgID,"+
			" getOrgName(AI.InputOrgID) as InputOrgName,AI.InputDate " +
			" from LAWCASE_RELATIVE LR,ASSET_INFO AI,LAWCASE_INFO LI " +
			" where LR.ObjectType = '"+sObjectType+"' "+
			" and LR.ObjectNo = '"+sObjectNo+"' "+
			" and AI.AssetAttribute = '02' "+		//资产属性为查封资产
			" and AI.ObjectNo = LR.SerialNo "+	//对象编号
			" and LI.SerialNo = AI.ObjectNo "+
			" and AI.ObjectType ='LawcaseInfo' " + sWhereCondition;
			
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字

	//设置共用格式
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,AssetAttribute,AssetType,InputUserID,InputOrgID",false);
	//设置金额为三位一逗数字
	doTemp.setType("AssetSum","Number");
	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("AssetSum","2");	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("AssetSum","3");
		
	//设置选项双击及行宽
	doTemp.setHTMLStyle("AssetName"," style={width:120px} ");
	doTemp.setHTMLStyle("AssetTypeName,BeginDate,EndDate,InputUserName,InputDate"," style={width:80px} ");
	
	//生成查询框
	doTemp.setColumnAttribute("AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页

	
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
			{"true","","Button","详情","查看详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","退出查封","退出查封资产信息","quitRecord()",sResourcesPath}
			};
			
		if(sItemID.equals("030"))
		{
			sButtons[1][0] = "false";
		}
	
		
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
		//获得记录流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sItemID = "<%=sItemID%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(sItemID=="030")
		{
			popComp("NPALawAssetsView","/RecoveryManage/NPAManage/NPARMGoodsMag/NPALawAssetsView.jsp","ObjectNo="+sSerialNo,"");
		}
		else
		{
			popComp("NPALawAssetsView","/RecoveryManage/NPAManage/NPARMGoodsMag/NPALawAssetsView.jsp","ObjectNo="+sSerialNo,"");
		}
	
	}
	
	/*~[Describe=退出查封;InputParam=无;OutPutParam=SerialNo;]~*/
	function quitRecord()
	{
		//获得记录流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getBusinessMessage("774"))) //该查封资产真的要退出查封吗？
		{
			var sReturn = RunMethod("PublicMethod","UpdateColValue","String@AssetStatus@02,ASSET_INFO,String@SerialNo@"+sSerialNo);
			if(sReturn == "TRUE") //刷新页面
			{
				alert(getBusinessMessage("775"));//该查封资产已成功退出查封！
				reloadSelf();
			}else
			{
				alert(getBusinessMessage("776")); //该查封资产退出查封失败！
				return;
			}
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: 查封资产列表
		Input Param:
				SerialNo:案件编号
				BookType：台帐类型				      
		Output param:
				SerialNo：查封资产编号
				AssetType：查封资产类型
				ObjectNo:对象编号或案件编号
				ObjectType:对象类型
		History Log: zywei 2005/09/06 重检代码
		                  
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
		
	//获得组件参数（案件流水号、台帐类型）	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sBookType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BookType"));
	//将空值转化为空字符串
	if(sBookType == null) sBookType = "";
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"ObjectNo","案件编号"},
							{"LawCaseName","案件名称"},
							{"SerialNo","查封资产编号"},				
							{"AssetName","查封资产名称"},
							{"AssetTypeName","查封资产类别"},
							{"LandownerNo","查封资产数量"},
							{"Currency","查封资产币种"},
							{"AssetSum","查封资产总额"},
							{"PropertyOrg","查封资产所有人"},
							{"BeginDate","查封日期"}, 
							{"EndDate","查封到期日"},
							{"AssetOrgName","查封机构"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"},				
							{"InputDate","登记日期"}
						}; 
	
	//从资产信息表中查出案件对应的查封资产信息
	sSql = " select AI.ObjectNo,LI.LawCaseName,AI.SerialNo,AI.ObjectType,AI.AssetName, "+
		   " AI.AssetType,getItemName('LawsuitAssetsType',AI.AssetType) as AssetTypeName,"+
		   " AI.LandownerNo,getItemName('Currency',AI.Currency) as Currency,AI.AssetSum,AI.PropertyOrg,AI.BeginDate,AI.EndDate, "+
		   " AI.AssetOrgID,getOrgName(AI.AssetOrgID) as AssetOrgName,"+
		   " AI.InputUserID,getUserName(AI.InputUserID) as InputUserName,AI.InputOrgID, "+
		   " getOrgName(AI.InputOrgID) as InputOrgName,AI.InputDate " +
		   " from ASSET_INFO AI,LAWCASE_INFO LI " +
		   " where AI.ObjectNo='"+sSerialNo+"' "+	//案件编号或对象编号
		   " and AI.AssetAttribute='02' "+		//资产属性为查封资产
		   " and LI.SerialNo = AI.ObjectNo "+
		   " and AI.ObjectType='LawcaseInfo' "+
		   " order by InputDate desc";	//对象类型
	
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";	
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);	 //设置关键字

	//设置共用格式
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,AssetAttribute,AssetType,InputUserID,InputOrgID,AssetOrgID",false);
	//设置金额为三位一逗数字
	doTemp.setType("AssetSum","Number");
	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("AssetSum","2");
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("AssetSum","3");
		
	//设置选项双击及行宽
	doTemp.setHTMLStyle("AssetName"," style={width:120px} ");
	doTemp.setHTMLStyle("AssetTypeName"," style={width:80px} ");	
	doTemp.setHTMLStyle("BeginDate,EndDate"," style={width:80px} ");	
	doTemp.setHTMLStyle("InputUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{			
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawsuitAssetsInfo.jsp?BookType=<%=sBookType%>&ObjectNo=<%=sSerialNo%>&ObjectType=LawcaseInfo&SerialNo=","right","");  
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得记录流水号、案件编号或对象编号、对象类型、查封资产类型
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		var sLawsuitAssetsType=getItemValue(0,getRow(),"AssetType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawsuitAssetsInfo.jsp?PageSerialNo="+sSerialNo+"&BookType=<%=sBookType%>&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"","right","");

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

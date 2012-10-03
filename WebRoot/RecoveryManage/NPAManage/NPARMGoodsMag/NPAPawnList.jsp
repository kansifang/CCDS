<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei 2006-1-24
		Tester:
		Content: 不良资产的抵押物信息列表
		Input Param:
			ObjectType：对象类型
			ObjectNo：对象编号	
		Output param:
				
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵押物信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql="";
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";	
	//获取页面参数
			
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 	
				{"GuarantyID","抵押物编号"},
				{"GuarantyName","抵押物名称"},
				{"GuarantyType","抵押物类型"},
				{"GuarantyTypeName","抵押物类型"},							
				{"OwnerID","权属人编号"}, 
				{"OwnerName","权利人名称"}, 
				{"OwnerTypeName","权属人类型"}, 
				{"GuarantyRightID","权证号"},				
				{"InputUserName","登记人"},
				{"InputOrgName","登记机构"},
				{"InputDate","登记日期"}
			}; 
			
	//从担保物信息表中查出当前用户管户的不良资产对应的抵押物信息
	sSql = 	" select GI.GuarantyID,GI.GuarantyType,GI.GuarantyName,getItemName('GuarantyList',GI.GuarantyType) as GuarantyTypeName, "+
			" GI.OwnerID,GI.OwnerName,GI.OwnerType,getItemName('CustomerType',GI.OwnerType) as OwnerTypeName,GI.GuarantyRightID,"+
			" GI.InputUserID,getUserName(GI.InputUserID) as InputUserName,GI.InputOrgID,getOrgName(GI.InputOrgID) as InputOrgName,GI.InputDate " +
			" from GUARANTY_INFO GI,BUSINESS_CONTRACT BC,GUARANTY_RELATIVE GR  "+ 
			" where GR.ObjectNo = BC.SerialNo "+
			" and GR.ObjectType = '"+sObjectType+"' "+		
			" and GR.ObjectNo = '"+sObjectNo+"' "+						
			" and GI.GuarantyID =  GR.GuarantyID "+			
			" and GI.GuarantyType like '010%' " ;
	//利用Sql生成窗体对象	
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置抵押物信息表头
	doTemp.setHeader(sHeaders);	
	doTemp.UpdateTable = "GUARANTY_INFO";	
	doTemp.setKey("GuarantyID",true);	 //设置关键字

	//设置共用格式
	doTemp.setVisible("GuarantyName,OwnerID,GuarantyID,OwnerType,GuarantyType,InputUserID,InputOrgID",false);
	doTemp.setCheckFormat("CostSum","2");	
	//设置对齐方式
	doTemp.setAlign("CostSum","3");		
	//设置显示文本框的长度
	doTemp.setHTMLStyle("OwnerName"," style={width:200px} ");
	
	//生成查询框
	doTemp.setColumnAttribute("GuarantyID,OwnerName","IsFilter","1");
	
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
					{"true","","Button","详情","查看抵质押物信息详情","viewAndEdit()",sResourcesPath},
					{"true","","Button","价值变更","抵质押物价值变更","valueChange()",sResourcesPath},
					{"true","","Button","其他信息变更","抵质押物其他信息变更","otherChange()",sResourcesPath},
					{"true","","Button","资产监管信息","资产监管信息","assetWard()",sResourcesPath}
				};
			
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=资产监管信息;InputParam=无;OutPutParam=无;]~*/
	function assetWard()
	{
		//担保物编号
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sObjectType = "GuarantyInfo";
		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else 
		{
			OpenComp("AssetWardList","/RecoveryManage/NPAManage/NPARMGoodsMag/AssetWardList.jsp","ObjectNo="+sGuarantyID+"&ObjectType="+sObjectType,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		//担保物编号、担保合同号
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{		
			OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/NPAPawnInfo.jsp?GuarantyID="+sGuarantyID+"&PawnType="+sGuarantyType,"_self");
		}
	}

	

	/*~[Describe=抵质押物价值变更;InputParam=无;OutPutParam=无;]~*/
	function valueChange()
	{
		//担保物编号、担保合同号
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			OpenComp("NPAValueChangeList","/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeList.jsp","ChangeType=010&GuarantyID="+sGuarantyID,"_blank",OpenStyle);
			reloadSelf();
		}
																
															
	}

	/*~[Describe=抵质押物其他信息变更;InputParam=无;OutPutParam=无;]~*/
	function otherChange()
	{
		//担保物编号、担保合同号
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			OpenComp("NPAValueChangeList","/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeList.jsp","ChangeType=020&GuarantyID="+sGuarantyID,"_blank",OpenStyle);
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
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   FSGong  2005.01.26
		Tester:
		Content: 不良资产重组方案快速查询
		Input Param:
			   ItemID：重组状态     
		Output param:				 
		History Log: 		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产重组方案快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql="";	

	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义显示标题
	String sHeaders[][] = { 							
								{"SerialNo","重组方案流水号"},
								{"Type1","重组贷款类型"},
								{"ApplyType","重组方案类型"},
								{"ApplyTypeName","重组方案类型"},
								{"ReformTypeName","重组形式"},
								{"FirstReformFlag","是否首次重组"},
								{"DRTimes","累计重组次数"},
								{"FirstBusinessSum","首次重组贷款金额"},
								{"des1","有无借款人担保人恶意赖账"},
								{"des2","有无逃废悬空债权"},
								{"des3","是否进入撤销、关闭、破产或进入清算程序"},
								{"des4","是否应起诉或采取法律措施"},
								{"des5","有无法律法规禁止发放贷款情况"},
								{"ChangeFlag1","借款主体是否变更"},
								{"ChangeFlag2","担保方式是否调整"},
								{"ChangeFlag3","利率是否变更"},
								{"ChangeFlag4","期限是否调整"},
								{"ChangeFlag5","是否需提供新增授信"},
								{"NewBusinessSum","新增授信金额"},
								{"ChangeFlag6","抵质押物是否足值"},
								{"OperateUserName","经办人"},
								{"OperateOrgName","经办机构"}
							}; 
							
	//从申请信息表BUSINESS_APPLY中选出重组方案列表(经办机构为当前用户所辖机构、业务品种为6010)
	sSql =  " select SerialNo,'' as type1,ApplyType,"+
			" getItemName('ReformType',ApplyType) as ApplyTypeName," +	
			" getItemName('ReformType1',ReformType) as ReformTypeName,"+
			" getItemName('YesNo',FirstReformFlag) as FirstReformFlag,"+
			" DRTimes,'' as FirstBusinessSum, " +	
			" '' as des1,'' as des2,'' as des3,'' as des4,'' as des5,"+
			" getItemName('YesNo',ChangeFlag1) as ChangeFlag1,"+
			" getItemName('YesNo',ChangeFlag1) as ChangeFlag2,"+
			" getItemName('YesNo',ChangeFlag1) as ChangeFlag3,"+
			" getItemName('YesNo',ChangeFlag1) as ChangeFlag4,"+
			" getItemName('YesNo',ChangeFlag1) as ChangeFlag5,"+
			" NewBusinessSum,getItemName('YesNo',ChangeFlag1) as ChangeFlag6,"+
			" getUserName(OperateUserID) as OperateUserName,getOrgName(OperateOrgID) as OperateOrgName " +	
			" from REFORM_INFO  " +
			" where  OperateOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
			
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "REFORM_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("ApplyType,SerialNo",false);	

	doTemp.setCheckFormat("FirstBusinessSum,NewBusinessSum","2");
	
	//设置对齐方式	
	doTemp.setAlign("FirstBusinessSum,NewBusinessSum","3");
	
	//设置字段显示宽度
	doTemp.setHTMLStyle("ApplyTypeName,ProjectName,BusinessSum,PaymentDate"," style={width:100px} ");
	doTemp.setHTMLStyle("OperateTypeName,"," style={width:180px} ");
	doTemp.setUpdateable("ApplyTypeName",false); 
	doTemp.setType("TotalSum","number");
	
	//生成查询框
	doTemp.setDDDWCode("ApplyType","ReformType");
	//doTemp.setDDDWCode("OperateType","ReformShape");
	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","OperateUserName","");
	doTemp.setFilter(Sqlca,"2","OperateOrgName","");
	doTemp.setFilter(Sqlca,"3","ApplyType","Operators=EqualsString;");
	//doTemp.setFilter(Sqlca,"4","OperateType","Operators=EqualsString;");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
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
	
		//如果为拟重组不良资产，则列表显示如下按钮
		
		String sButtons[][] = {
					{"true","","Button","拟重组原贷款","查看拟重组不良资产","viewAndEdit()",sResourcesPath},
					{"true","","Button","重组方案详情","查看重组方案详情","viewReform()",sResourcesPath},
					{"true","","Button","重组后新贷款","查看重组贷款信息","ReformCredit()",sResourcesPath},
					{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath}						
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
		//申请流水号		
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");  
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		OpenComp("NPAReformContractList","/RecoveryManage/NPAManage/NPAReform/NPAReformContractList.jsp","ComponentName=拟重组不良资产详情列表&ComponentType=MainWindow&SerialNo="+sSerialNo+"&ItemID=060&QueryFlag=Query","_blank",OpenStyle);

	}
	
	//重组方案申请信息
	function viewReform()
	{
		//获得申请流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //请选择一条信息！
		}
		else
		{
			sObjectType = "NPAReformApply";
			sObjectNo = sSerialNo;
			sViewID = "002";
			
			openObject(sObjectType,sObjectNo,sViewID);
			
		}
		
		
	}
	
	//重组贷款信息
	function ReformCredit()
	{
		//获得重组方案流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo"); 
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
			
		OpenComp("NPAReformContractList","/RecoveryManage/NPAManage/NPAReform/NPAReformContractList.jsp","ComponentName=资产详情列表?&ComponentType=MainWindow&SerialNo="+sSerialNo+"&Flag=ReformCredit&ItemID=060&QueryFlag=Query","_blank",OpenStyle);

	}
	
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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

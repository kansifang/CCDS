<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/10/09
		Tester:
		Describe: 台帐维护处置登记列表;
			
		Input Param:
			ObjectNo：抵债资产流水号
			DealType:树图节点号
		Output Param:
			SerialNo: 自身流水号类型。
			DealType:树图节点号
		HistoryLog:
				
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "台帐维护处置登记列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%

	//定义变量 

	//获得页面参数:

	//获得组件参数
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	String sEditRight = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EditRight"));
	//将空值转化为字符串
	if(sObjectNo == null) sObjectNo="";
	if(sDealType == null) sDealType="";
	if(sEditRight == null) sEditRight="";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
								
	String sHeaders[][] = {
							{"ObjectNo","资产编号"},
							{"AssetName","资产名称"},
							{"DisposeDate","处置日期"},
							{"SaleSum","出售金额"},
							{"LeaseSum","出租金额"},
							{"OtherTypeSum","其他方式金额"},
							{"DisposeLossSum","处置损失金额"},
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记日期"},
						  };

	String sSql =   " select SerialNo,ObjectNo,AssetName,"+
					" DisposeDate,SaleSum,LeaseSum,OtherTypeSum,DisposeLossSum,"+
					" InputUserID,getUserName(InputUserID) as InputUserName,"+
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName, "+
					" InputDate "+
					" from ASSET_DISPOSE "+
					" where ObjectNo='"+sObjectNo+"'";
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置主键,可更新表
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "ASSET_DISPOSE";
	
	//设置不可见项
	doTemp.setVisible("SerialNo,InputUserID,InputOrgID",false);
	//设置金额为三位一逗数字
	doTemp.setType("SaleSum,LeaseSum,OtherTypeSum,DisposeLossSum","Number");
	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("SaleSum,LeaseSum,OtherTypeSum,DisposeLossSum","2");
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("SaleSum,LeaseSum,OtherTypeSum,DisposeLossSum","3");
   //生成过滤器
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
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
		{sEditRight.equals("02")?"false":"true","","Button","新增","新增","newRecord()",sResourcesPath},
		{"true","","Button","详情","详情","viewAndEdit()",sResourcesPath},
		{sEditRight.equals("02")?"false":"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
		{"true","","Button","返回","返回","go_Back()",sResourcesPath}
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
		OpenPage("/RecoveryManage/AccountManage/DisposeRegisterInfo.jsp","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{	
		
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/AccountManage/DisposeRegisterInfo.jsp?SerialNo="+sSerialNo,"_self","");
		}
	}
	
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function go_Back()
	{
		self.close();
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


<%@	include file="/IncludeEnd.jsp"%>

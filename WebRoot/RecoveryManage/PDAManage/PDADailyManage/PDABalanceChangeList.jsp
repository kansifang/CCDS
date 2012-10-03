<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   FSGong  2004.12.16
		Tester:
		Content: 抵债资产余额变动台帐
		余额变动类型：出租和出售，BalanceChangeType
		资产表中资产余额y=资产表中抵入金额a-变动表中变动金额b.
		当资金流入b>0;otherwise b<0.
		Input Param:
			        ObjectNo：对象编号（抵债资产流水号）
			        ObjectType：对象类型（ASSET_INFO）						
		Output param:
		
		History Log: zywei 2005/09/07 重检代码
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = " 抵债资产余额变动台帐"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";

	//获得组件参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";	
	
	//获取页面参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","变动流水号"},
							{"ObjectType","对象类型"},
							{"ObjectNo","资产流水号"},							
							{"AssetName","资产名称"},
							{"ChangeDate","变动日期"},
							{"ChangeType","变动方向"},	
							{"ChangeTypeName","变动方向"},	
							{"ChangeStyle","变动类型"},	
							{"ChangeStyleName","变动类型"},	
							{"ChangeSum","变动金额(元)"},	
							{"InputUserName","登记人"}, 
							{"InputOrgName","登记机构"},
							{"InputDate","登记日期"}
						}; 
	//从变动表中获取变动纪录
	sSql = 	" select ASSET_BALANCE.SerialNo,"+
			" ASSET_BALANCE.ObjectType,"+
			" ASSET_BALANCE.ObjectNo,"+			
			" ASSET_INFO.AssetName,"+
			" ASSET_BALANCE.ChangeDate,"+
			" ASSET_BALANCE.ChangeType,"+
			" getItemName('BalanceChangeType',trim(ASSET_BALANCE.ChangeType)) as ChangeTypeName,"+
			" ASSET_BALANCE.ChangeStyle,"+
			" getItemName('BalanceChangeStyle',trim(ASSET_BALANCE.ChangeStyle)) as ChangeStyleName,"+
			" ASSET_BALANCE.ChangeSum,"+
			" getUserName(ASSET_BALANCE.InputUserID) as InputUserName," + 
			" getOrgName(ASSET_BALANCE.InputOrgID) as InputOrgName," + 
			" ASSET_BALANCE.InputDate"+				
			" from ASSET_BALANCE,ASSET_INFO " +
			" where ASSET_BALANCE.ObjectNo = '"+sObjectNo+"' "+
			" and ASSET_BALANCE.ObjectType = '"+sObjectType+"' "+
			" and ASSET_INFO.SerialNo = ASSET_BALANCE.ObjectNo "+
			" order by ASSET_BALANCE.InputDate desc ";
			//对应于ObjectType的某个资产的余额变动记录。
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_BALANCE";	
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 
	//设置不可见项
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,ChangeType,ChangeStyle",false);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("ChangeDate,InputDate","style={width:70px} ");  
	doTemp.setHTMLStyle("ChangeTypeName,ChangeStyleName","style={width:60px} ");  
	doTemp.setHTMLStyle("ChangeSum,InputUserName","style={width:80px} ");  
	doTemp.setHTMLStyle("InputOrgName","style={width:120px} ");  
	doTemp.setHTMLStyle("AssetName","style={width:100px} ");  
	doTemp.setHTMLStyle("InputUserName"," style={width:80px} ");
		
	doTemp.setCheckFormat("ChangeSum","2");		
	//设置对齐方式
	doTemp.setAlign("ChangeSum","3");
	doTemp.setType("ChangeSum","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("ChangeSum","2");

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //设置DW风格 1:Grid 2:Freeform
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
			{"true","","Button","新增","新增变动记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","变动记录详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除变动记录","deleteRecord()",sResourcesPath}
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
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeInfo.jsp","right","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;			
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			// 必须同时修改抵债资产表的余额。
			var NewValue = "0"; //得到修改之后的值.	删除相当于变动金额由原金额改为0
			var OldValue = getItemValue(0,getRow(),"ChangeSum");  //得到原来的值	
			if (OldValue == "") OldValue = "0";

			var TempValue = parseFloat(NewValue)-parseFloat(OldValue);//计算需要变动的值.
			var sChangeType = getItemValue(0,getRow(),"ChangeType");  //得到变动方向	

			//修改抵债资产表的抵债余额.
			var sObjectNo = "<%=sObjectNo%>";//抵债资产编号
			var sReturn = PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeAction.jsp?SerialNo="+sObjectNo+"&Interval_Value="+TempValue+"&ChangeType="+sChangeType,"","");

			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		sChangeType = getItemValue(0,getRow(),"ChangeType");  //得到变动方向	
		sSerialNo = getItemValue(0,getRow(),"SerialNo");			
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeInfo.jsp?SerialNo="+sSerialNo+"&ChangeType="+sChangeType,"right","");
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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   FSGong 2004.12.12
		Tester:
		Content: 抵债资产处置台帐AppDisposingList.jsp
		Input Param:								
				ObjectType：对象类型（ASSET_INFO）
				ObjectNo：对象编号（资产流水号）        
		Output param:

		History Log: zywei 2005/09/07 重检代码		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产处置台帐列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
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
							{"ObjectType","对象类型"},
							{"ObjectNo","资产编号"},							
							{"AssetName","资产名称"},
							{"SerialNo","处置流水号"},
							{"AgreementNo","处置协议号"},
							{"BargainDate","处置日期"},
							{"DispositionType","处置方式"},
							{"DispositionTypeName","处置方式"},
							{"DispositionSum","处置收入(元)"},
							{"DispositionCharge","处置费用(元)"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"},
							{"InputDate","登记日期"}
						};
						
	//从抵债资产处置信息表ASSET_DISPOSITON中选出处置信息记录
	sSql =  " select ASSET_DISPOSITION.ObjectType as ObjectType,"+
			" ASSET_DISPOSITION.ObjectNo as ObjectNo,"+
			" ASSET_DISPOSITION.SerialNo as SerialNo,"+			
			" ASSET_INFO.AssetName as AssetName,"+
			" ASSET_DISPOSITION.BargainDate as BargainDate,"+
			" ASSET_DISPOSITION.AgreementNo as AgreementNo,"+
			" ASSET_DISPOSITION.DispositionType as DispositionType,"+
			" getItemName('DispositionType',trim(ASSET_DISPOSITION.DispositionType)) as DispositionTypeName,"+
			" ASSET_DISPOSITION.DispositionSum as DispositionSum,"+
			" ASSET_DISPOSITION.DispositionCharge as DispositionCharge,"+
			" getUserName(ASSET_DISPOSITION.InputUserID) as InputUserName, " +	
			" getOrgName(ASSET_DISPOSITION.InputOrgID) as InputOrgName ,"+			
			" ASSET_DISPOSITION.InputDate as InputDate"+
			" from ASSET_DISPOSITION,ASSET_INFO" +
			" where ASSET_DISPOSITION.ObjectType = '"+sObjectType+"' "+
			" and ASSET_INFO.SerialNo = '"+sObjectNo+"' "+
			" and ASSET_DISPOSITION.ObjectNo = '"+sObjectNo+"' "+
			" and (ASSET_DISPOSITION.DispositionType <> '01')  "+
			" order by ASSET_DISPOSITION.InputDate desc ";  //出租单独考虑.
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_DISPOSITION";	
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	
	//设置不可见项
	doTemp.setVisible("ObjectType,ObjectNo,DispositionType,SerialNo,AgreementNo",false);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("DispositionSum,DispositionCharge,InputDate,InputUserName,BargainDate,DispositionTypeName","style={width:80px} ");  
	doTemp.setHTMLStyle("AgreementNo,AssetName"," style={width:100px} ");
	doTemp.setUpdateable("DispositionTypeName",false); 
	//设置对齐方式
	doTemp.setAlign("DispositionSum,DispositionCharge","3");
	doTemp.setType("DispositionSum,DispositionCharge","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("DispositionSum,DispositionCharge","2");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //设置DW风格 1:Grid 2:Freeform
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
			{"true","","Button","新增","新增","newRecord()",sResourcesPath},
			{"true","","Button","详情","详细信息","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
			{"true","","Button","处置情况汇总","处置情况汇总","my_Statistics()",sResourcesPath}	
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
		var sDispositionInfo =PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalTypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(sDispositionInfo) != "undefined" && sDispositionInfo.length != 0)
		{			
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookInfo.jsp?DispositionType="+sDispositionInfo+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
		} 		
	}

	/*~[Describe=抵债资产处置终结汇总;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_Statistics()
	{
		var sObjectNo="<%=sObjectNo%>";//资产序列号
		//type=1 意味着从AppDisposingList中执行处置终结并且汇总。
		//type=2 意味着从PDADisposalEndList中察看汇总。
		//type=3 意味着从PDADisposalBookList中察看汇总。
        sReturn=popComp("PDADisposalEndInfo","/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndInfo.jsp","SerialNo="+sObjectNo+"~Type=3","dialogWidth:720px;dialogheight:580px","");
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
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得资产处置流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sDispositionType = getItemValue(0,getRow(),"DispositionType");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookInfo.jsp?SerialNo="+sSerialNo+"&DispositionType="+sDispositionType+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
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
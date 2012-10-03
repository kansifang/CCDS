<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.07
		Tester:
		Content: 数据采集  非信贷数据维护
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "非信贷数据维护"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量

	//获得组件参数

	//获得页面参数
	String sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sAssetNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssetNo"));
	if(sAssetNo==null) sAssetNo="";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ReserveDataInfo";
	//Reserve_Total.AccountMonth='#AccountMonth' and Reserve_Total.DuebillNo='#DuebillNo'
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "Reserve_Nocredit";
	doTemp.setKey("AssetNo",true);
	doTemp.setUnit("AccountMonth","<input type=\"button\" class=\"inputDate\" value=\"...\" onclick=\"parent.selectAccountMonth()\">");
	doTemp.setUnit("OrgName","<input type=\"button\" class=\"inputDate\" value=\"...\" onclick=\"parent.selectOrg()\">");
	doTemp.setHTMLStyle("Orgid","style={width:50px;}");
	doTemp.appendHTMLStyle("Balance"," onBlur=\"javascript:parent.setRMBBalance()\" ");
	doTemp.appendHTMLStyle("ExchangeRate"," onBlur=\"javascript:parent.setRMBBalance()\" ");
	doTemp.setHTMLStyle("AssetStatusDescribe,AssetChangeDescribe,AssetorBaseDescribe,Remark,AssetManageDescribe","style={width:260;height:150}overflow:scroll");
	doTemp.setHTMLStyle("AccountMonth,InputUserName,InputDate","style={width:100}");
	doTemp.setHTMLStyle("NoAssetAddress,AssetSaveAddress","style={width:200}");
	//doTemp.appendHTMLStyle("SubjectNo","onChange=\"javascript:parent.setSubjectNo()\" ");	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+sAssetNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//session.setAttribute(dwTemp.Name,dwTemp);
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},		
		{"true","","Button","录入/修改减值准备信息","录入或查看减值准备信息","editReserve()",sResourcesPath},
		{"true","","Button","上传附件","上传附件","upload()",sResourcesPath},
		{"true","","Button","返回","返回","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	function selectAccountMonth()
	{
		
		var sAccountMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=21;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sAccountMonth)!="undefined" && sAccountMonth!="")
		{	
			setItemValue(0,0,"AccountMonth",sAccountMonth);
		}
		else
			setItemValue(0,0,"AccountMonth","");
	}
	
	function selectVouchType() 
	{
    	sParaString = "CodeNo" + "," + "VouchType";
    	setObjectValue("SelectCode", sParaString, "@VouchType@0@VouchTypeName@1", 0, 0, "");
	}
	
	function setRMBBalance()
	{
		if(getActureVale()==false)
		{
			return;
		}
		else
		{
			var dBalance=getItemValue(0,getRow(),"Balance");
			var dExchangeRate=getItemValue(0,getRow(),"ExchangeRate");
			setItemValue(0,0,"RMBBalance",dBalance*dExchangeRate);
		}
	}
	function getActureVale()
	{
		var sBalance=getItemValue(0,getRow(),"Balance");
		if(typeof(sBalance)=="undefined" || sBalance.length==0)
		{
			return false;
		}
		var sExchangeRate=getItemValue(0,getRow(),"ExchangeRate");
		if(typeof(sExchangeRate)=="undefined" || sExchangeRate.length==0)
		{
			return false;
		}
		return true;
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}
		else{
			beforeUpdate();
		}
		sAssetNo = getItemValue(0,getRow(),"AssetNo");
		as_save("myiframe0",sPostEvents);
	}
	
	function goBack()
	{
		self.close();
	}
	function editReserve()
	{
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sAssetNo = getItemValue(0,getRow(),"AssetNo");
		if(typeof(sAssetNo) == "undefined" || sAssetNo.length == 0)
		{
			alert("请先保存客户基本信息,再进行减值准备信息录入!");
			return;
		}
		var sReturn = PopComp("ReserveNullDataInfo","/BusinessManage/ReserveDataPrepare/ReserveNullDataInfo.jsp","AccountMonth="+sAccountMonth+"&AssetNo="+sAssetNo,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
	}
	function upload(){
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sAssetNo = getItemValue(0,getRow(),"AssetNo");
		if(typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert("没有录入会计月份,请先录入会计月份并保存!");
			return;
		}
		if(typeof(sAssetNo) == "undefined" || sAssetNo.length == 0)
		{
			alert("请先保存基本信息,再上传附件!");
			return;
		} 
		PopComp("AddDocumentPreMessage","/BusinessManage/ReserveManage/AddDocumentPreMessage.jsp","ObjectType=ReserveImport&ObjectNo= " + sAssetNo + "&rand="+randomNumber(),"_blank","width=500,height=150,top=200,left=170;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 	
	}
	
	function selectOrg()
	{
		var sReturn= selectObjectValue("SelectAllOrg","",0,0,"");		
		
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'))
		{
			sReturn=sReturn.split("@");
			sTraceOrgID=sReturn[0];
			sTraceOrgName=sReturn[1];
			//alert(sTraceOrgID+"~~~"+sTraceOrgName);
			setItemValue(0,0,"Orgid",sTraceOrgID);
			setItemValue(0,0,"OrgName",sTraceOrgName);
		}
		else if (sReturn=='_CLEAR_')
		{
			sTraceOrgID="";
		}
		else 
		{
			return;
		}
		
	}	   
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
		initSerialNo();
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
			
	}
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			//setItemValue(0,0,"AccountMonth","<%=StringFunction.getToday().substring(0,7)%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
    }
    function initSerialNo() 
	{
		var sTableName = "Reserve_Nocredit";//表名
		var sColumnName = "AssetNo";//字段名
		var sPrefix = "fxd";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		if(typeof(sSerialNo)=="undefined" || sSerialNo=="undefined" || sSerialNo.lenth==0 || sSerialNo==" " || sSerialNo=="")
		{
			alert("保存失败，请重新保存！");
			return;
		}
		
		//将流水号置入对应字段
		setItemValue(0,0,sColumnName,sSerialNo);
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.07
		Tester:
		Content: 数据采集  对个人据维护
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "对个数据维护"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量

	//获得组件参数

	//获得页面参数
	String sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "DataBaseIndInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "Reserve_IndPara";
	doTemp.setDDDWCode("LossScope","LossScope");
	doTemp.setUnit("AccountMonth"," <input type=button class=inputDate value=... onclick=parent.selectAccountMonth() > ");
	doTemp.setHTMLStyle("AccountMonth,LastAccountMonth","style={width:80}");
   	//doTemp.setDDDWCode("LossRateCalType","LossScope");
   	doTemp.setUnit("LastAccountMonth"," <input type=button class=inputDate value=... onclick=parent.selectLastAccountMonth() > ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth);
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
		{"false","","Button","自动计算","自动计算","my_cal()",sResourcesPath},
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","上传附件","上传附件","Upload()",sResourcesPath},
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
	function selectLastAccountMonth()
	{
		var sLastAccountMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=21;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sLastAccountMonth)!="undefined" && sLastAccountMonth!="")
		{	
			setItemValue(0,0,"LastAccountMonth",sLastAccountMonth);
		}
		else
			setItemValue(0,0,"LastAccountMonth","");
	}
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			sAccountmonth = getItemValue(0,0,"AccountMonth");
			sReturnValue = RunMethod("新会计准则","DataBaseIndInfo",sAccountmonth);
			if(sReturnValue==1)
			{
				alert("该月份的基础参数已经存在，请重新录入会计月份！");
				return;
			}
			var sLastAccountMonth = PopPage("/BusinessManage/ReserveDataPrepare/GetLastAccountMonth.jsp?AccountMonth="+sAccountmonth,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			if(sLastAccountMonth != ""){
				setItemValue(0,getRow(),"LastAccountMonth",sLastAccountMonth);
			}
			beforeInsert();
		}
		else{
			beforeUpdate();
		}
		
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=自动计算;InputParam=无;OutPutParam=无;]~*/
	function my_cal(){
		sLossScope  = getItemValue(0,getRow(),"LossScope");
		if(typeof(sLossScope)== "undefined" || sLossScope == "" || sLossScope == "M"){
		    alert("当前损失率计算类型，不能进行自动计算");
		    return;
		}
		sAccountMonth  = getItemValue(0,getRow(),"AccountMonth");
	    if(sLossScope != "M")	{//取算数平均值
	    	sReturn = self.showModalDialog("CalLossRateAction.jsp?LossScope="+sLossScope+"&AccountMonth="+sAccountMonth+"&rand="+randomNumber()," ","dialogWidth=20;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;close:no");
	        ss = sReturn.split('@');
	        setItemValue(0,0,"ALossRate1",ss[0]);
	        setItemValue(0,0,"ALossRate2",ss[1]);
	    }
	}
	
	function goBack()
	{
		//var sReturn = PopComp("RelatingCustomerView","/RelatingExchange/RelatingCustomerView.jsp","CustomerID="+sCustomerID,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		self.close();
	}
	/*~[Describe=保存并新增一条记录;InputParam=无;OutPutParam=无;]~*/
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo() ;
		bIsInsert = false;
		
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
		}
		
    }
	function initSerialNo() 
	{
		var sTableName = "Reserve_IndPara";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "GR";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		//防止流水号取空----------added by yjfang on 20060601
		if(typeof(sSerialNo)=="undefined" || sSerialNo=="undefined" || sSerialNo.lenth==0 || sSerialNo==" " || sSerialNo=="")
		{
			alert("保存失败，请重新保存！");
			return;
		}
		
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
   	function Upload(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo"); 
		if(typeof(sSerialNo)=="undefined" || sSerialNo=="undefined" || sSerialNo.lenth==0 || sSerialNo==" " || sSerialNo=="")
		{
			alert("请先保存记录后再上传附件！");
			return;
		}
		PopComp("AddDocumentPreMessage","/BusinessManage/ReserveManage/AddDocumentPreMessage.jsp","ObjectType=CS&ObjectNo= " +sSerialNo+ "&rand="+randomNumber(),"_blank","width=500,height=150,top=200,left=170;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 	
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

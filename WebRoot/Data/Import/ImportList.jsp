<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: xxx 2005-08-17
			Tester:
			Describe:文档信息列表
			Input Param:
	       		    ObjectNo: 对象编号
	       		    ObjectType: 对象类型           		
	        Output Param:

			HistoryLog:xxxx 2005/09/03 重检代码
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "文档信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量                     
	String sObjectNo = "";//--对象编号
	//获得页面参数
	
	//获得组件参数
	String sReportDate = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)request.getParameter("DOFILTER_1_1_VALUE")));//setFilter 
	String sConfigNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)request.getParameter("DOFILTER_DF1_1_VALUE")));//doTemp.setColumnAttribute("报表类型","IsFilter","1");
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][]	={};
	String sS=",";
	if("".equalsIgnoreCase(sConfigNo)){
		sS="";
	}else{
		sHeaders=Sqlca.getStringMatrix("select ItemDescribe,Attribute1 from Code_Library where CodeNo='"+sConfigNo+"' and IsInUse='1' order by SortNo asc");
		for(int i=0;i<sHeaders.length;i++){
	  		sS+=sHeaders[i][0]+",";
	  	}
	  	if(sS.length()>0){
	  		sS=sS.substring(0,sS.length()-1);
	  	}
	}
    	//定义SQL语句
    String sSql = " SELECT  ConfigNo as 报表类型,OneKey as 报表日期,ImportIndex as 序号"+
    				sS+
    				",ImportNo as 导入号,ImportTime as 导入时间,UserID as 导入人"+
    	 			" FROM Batch_Import_Interim " +
		  			" WHERE 1=1 order by ImportNo asc";
	//产生ASDataObject对象doTemp
    ASDataObject doTemp = new ASDataObject(sSql);
    //设置表头
    doTemp.setHeader(sHeaders);
    //可更新的表
    doTemp.UpdateTable = "Batch_Import_Interim";
    //设置关键字
	doTemp.setKey("ImportNo,ImportIndex",true);
	//设置不可见项
    doTemp.setVisible("报表类型,ImportFlag",false);
    //设置风格
    //doTemp.setAlign("AttachmentCount","3");
    if(!"".equalsIgnoreCase(sConfigNo)){
    	doTemp.setHTMLStyle(2,"style={width:300px}");//项目加宽
    	doTemp.setHTMLStyle(4,"style={width:300px}");//项目加宽
	}
    doTemp.setHTMLStyle("ImportNo"," style={width:180px}");
    doTemp.setHTMLStyle("报表日期"," style={width:50px}");
    //生成查询框
    doTemp.setFilter(Sqlca, "1", "报表日期", "HtmlTemplate=PopSelect;");//这个可以独立使用---不知道为什么下面的用法 能显示出弹出按钮，但下面的filterAction函数无法调用
    //doTemp.setColumnAttribute("报表日期","IsFilter","1");
	//doTemp.setColumnAttribute("报表日期", "FilterOptions", "HtmlTemplate=PopSelect;");
	doTemp.setColumnAttribute("报表类型","IsFilter","1");
	doTemp.setColumnAttribute("报表类型", "FilterOptions", "Operators=EqualsString;");
    if(sHeaders.length!=0){
    	//doTemp.setHTMLStyle(DataConvert.toString(StringFunction.getAttribute(sHeaders,"合同流水号",1,0))," style={width:95px}");
        String CustomerName=DataConvert.toString(StringFunction.getAttribute(sHeaders,"客户名称",1,0));
        if(!"".equals(CustomerName)){
        	doTemp.setHTMLStyle(CustomerName," style={width:250px}");
        	//生成查询框
            doTemp.setColumnAttribute(CustomerName,"IsFilter","1");
        }
        String ItemName=DataConvert.toString(StringFunction.getAttribute(sHeaders,"项目",1,0));
        if(!"".equals(ItemName)){
        	doTemp.setHTMLStyle(ItemName," style={width:260px}");
        	//生成查询框
            doTemp.setColumnAttribute(ItemName,"IsFilter","1");
        }
        String IName=DataConvert.toString(StringFunction.getAttribute(sHeaders,"项目Item",1,0));
        if(!"".equals(IName)){
        	doTemp.setHTMLStyle(IName," style={width:260px}");
        	//生成查询框
            doTemp.setColumnAttribute(IName,"IsFilter","1");
        }
       	//doTemp.setHTMLStyle(DataConvert.toString(StringFunction.getAttribute(sHeaders,"币种",1,0))," style={width:20px}");
    }
    doTemp.setHTMLStyle("序号"," style={width:25px}");
    doTemp.setDDDWSql("报表类型", "select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%' order by InputTime asc");
   // doTemp.setCheckFormat("报表日期", "3");
	doTemp.generateFilters(Sqlca);//和这个doTemp.setColumnAttribute("报表类型","IsFilter","1")配合生产查询框 filterID 以DF为前缀 即 DF1 DF2...
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) {
		 doTemp.WhereClause+=" and 1=2";
	}
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.iPageSize=20;
	//设置setEvent
	dwTemp.setEvent("AfterDelete","!PublicMethod.DeleteColValue(Batch_Case,String@BatchNo@#BatchNo)");

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	CurPage.setAttribute("ShowDetailArea","false");
	CurPage.setAttribute("DetailAreaHeight","150");
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
%>
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
				{"false","","Button","删除","删除文档信息","deleteRecord()",sResourcesPath},
				{"true","","Button","查看附件","查看附件详情","viewDoc()",sResourcesPath},
				{"false","","Button","上传附件","查看附件详情","uploadDoc()",sResourcesPath},
				{"false","","Button","更新批次","查看附件详情","ImportBatch('02')",sResourcesPath},
				{"false","","Button","区间汇总","查看附件详情","summation()",sResourcesPath},
				{"true","","Button","导入数据","查看附件详情","ImportBatch('01')",sResourcesPath}
			};
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"UserID");//取文档录入人	
		sBatchNo = getItemValue(0,getRow(),"ImportNo");
		if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{ 
			if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
			{
				as_del('myiframe0');
				as_save('myiframe0'); //如果单个删除，则要调用此语句   
				mySelectRow();
				reloadSelf(); 
			} 
		}else{
			alert(getHtmlMessage('3'));
			return;
		}
	}
	/*~[Describe=上传附件;InputParam=1导入2更新;OutPutParam=无;]~*/
	function uploadDoc(){
		var sBatchNo="<%=sConfigNo+sReportDate%>";
		var sDocTitle="S63";
    	if(typeof(sBatchNo)=="undefined" || sBatchNo.length==0){
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;
    	}
   		var sDocNo=RunMethod("PublicMethod","GetColValue","Doc_Library.DocNo,Doc_Relative@Doc_Library,None@Doc_Relative.DocNo@Doc_Library.DocNo@String@ObjectType@Batch@String@ObjectNo@"+sBatchNo+"@String@DocAttribute@01");
   		if(sDocNo.length==0){
   			sDocNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=Doc_Library&ColumnName=DocNo&Prefix=","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
   			RunMethod("PublicMethod","InsertColValue","String@DocNo@"+sDocNo+"@String@ObjectType@Batch@String@ObjectNo@"+sBatchNo+",Doc_Relative");
   			RunMethod("PublicMethod","InsertColValue","String@DocNo@"+sDocNo+"@String@DocTitle@"+sDocTitle+"_默认文件夹_<%=StringFunction.getNow()%>@String@DocAttribute@01@String@OrgID@<%=CurUser.OrgID%>@String@UserID@<%=CurUser.UserID%>@String@InputOrg@<%=CurUser.OrgID%>@String@InputUser@<%=CurUser.UserID%>@String@InputTime@<%=StringFunction.getToday()%>,Doc_Library");
   		}else{
   			sDocNo=sDocNo.split("@")[1];
   		}
   		popComp("FileChooseDialog","/Document/FileChooseDialog.jsp","BatchNo="+sBatchNo+"&DocModelNo=&DocNo="+sDocNo+"&Handler=&Message=上传成功&Type=","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
   		reloadSelf(); 
	}
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewDoc()
	{
		var sBatchNo=getItemValue(0,getRow(),"报表类型");
		var sUserID=getItemValue(0,getRow(),"UserID");
    	if (typeof(sUserID)=="undefined" || sUserID.length==0)
    	{
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;
    	}else{
    		sReturn=popComp("DocumentList","/Document/DocumentList.jsp","ObjectType=Batch&ObjectNo="+sBatchNo,"");
            reloadSelf(); 
        }
	}
	/*~[Describe=导入批量;InputParam=1导入2更新;OutPutParam=无;]~*/
	function ImportBatch(sType)
	{
		//Doc_Relative ObjectType=Batch ObjectNo=ConfigNo 
		var sReturn=popComp("FileChooseDialog","/Document/FileChooseDialog.jsp","","dialogWidth=900px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") 
   			return;
   		sReturn = sReturn.split("@");
		var sConfigNo=sReturn[0];
		var sUploadMethod=sReturn[1];
		var sReportDates=sReturn[2];
		var sFiles=sReturn[3];
   		//2、上传文件后 解析存入数据库并作初步加工处理
   		ShowMessage("正在进行文档上传后的后续操作,请耐心等待.......",true,false);
   		sReturn=PopPage("/Data/Import/Handler.jsp?HandleType=AfterImport&ConfigNo="+sConfigNo+"&OneKeys="+sReportDates+"&UploadMethod="+sUploadMethod+"&Files="+encodeURIComponent(encodeURIComponent(sFiles,'UTF-8')),"","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
   		if(sReturn=="true"){
   			alert("处理成功！");
   		}else{
   			alert("处理失败！");
   		}
   		try{hideMessage();}catch(e) {};
   		reloadSelf(); 
	}
	function summation()
	{
		var sCompID = "CreationInfo";
		var sCompURL = "/Data/Import/CreationInfo.jsp";
		var sReturn = popComp(sCompID,sCompURL,"","dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var configNo=sReturn[0];
		var oneKey=sReturn[1];
		PopPage("/Data/Process/S63Handler.jsp?Type=02&ConfigNo="+configNo+"&OneKey="+oneKey,"","dialogWidth=0;dialogHeight=0;minimize:yes");
   		alert("汇总成功");
		reloadSelf(); 
	}
	/*~[Describe=完成导入批量;InputParam=无;OutPutParam=无;]~*/
	function FinishBatch()
	{
		var sBatchNo=getItemValue(0,getRow(),"BatchNo");
    	if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;
    	}
		if(confirm("确认完成导入？"))
		{
			RunMethod("PublicMethod","UpdateColValue","String@Status@020,Batch_Info,String@BatchNo@"+sBatchNo);
			//RunMethod("PublicMethod","UpdateColValue","String@Status@030,Batch_Case,String@BatchNo@"+sBatchNo);
	   		var sArg="ApplyCaseDistOT,SerialNo@Batch_Case@BatchNo@"+sBatchNo+",ApplyCaseDist,ApplyCaseDistFlow,0010,<%=CurUser.UserID%>,<%=CurUser.OrgID%>";
	   		RunMethod("WorkFlowEngine","AutoBatchInitializeFlow",sArg);
			reloadSelf(); 
		}
	}
	/*~[Describe=取消导入批量;InputParam=无;OutPutParam=无;]~*/
	function unFinishBatch()
	{
		var sBatchNo=getItemValue(0,getRow(),"BatchNo");
		var sFlag=getItemValue(0,getRow(),"\"040CaseCount\"");
    	if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0)
    	{
        	alert(getHtmlMessage(1));//请选择一条记录！
			return;
    	}
    	if(sFlag!=="0"){
    		alert("当前批次下已有案件分配，不能取消！");//请选择一条记录！
			return;
    	}
    	if(confirm("确认取消完成导入？")){
    		RunMethod("PublicMethod","UpdateColValue","String@Status@010,Batch_Info,String@BatchNo@"+sBatchNo);
    		RunMethod("PublicMethod","DeleteColValue","Flow_Object,String@ObjectType@ApplyCaseDistOT@Exists@None@select 1 from Batch_Case where Batch_Case.SerialNo=Flow_Object.ObjectNo and BatchNo='"+sBatchNo+"'");
    		RunMethod("PublicMethod","DeleteColValue","Flow_Task,String@ObjectType@ApplyCaseDistOT@Exists@None@select 1 from Batch_Case where Batch_Case.SerialNo=Flow_Task.ObjectNo and BatchNo='"+sBatchNo+"'");
    		reloadSelf(); 
		}
	}
	/*~[Describe=查询条件;InputParam=;OutPutParam=SerialNo;]~*/
	function filterAction(sInputValue,sFilterID,sInputDisplay)
	{
		var oMyObj = document.all(sInputValue);
		var oMyObj2 = document.all(sInputDisplay);
		if(sFilterID=="1"){
			getIndustryType(oMyObj,oMyObj2);
		}
	}
	/*~[Describe=弹出国标行业类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType(id,name){
		//由于行业分类代码有几百项，分两步显示行业代码
		var sIndustryTypeInfo = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(typeof(sIndustryTypeInfo)=="undefined" || sIndustryTypeInfo.length==0){
			return;
		}else{
			id.value=sIndustryTypeInfo;
			name.value=sIndustryTypeInfo;
		}
	}
	document.all("DOFILTER_1_1_DISPLAY").value="<%=sReportDate%>";
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
		function mySelectRow()
		{
			//var sBatchNo = getItemValue(0,getRow(),"BatchNo");
			//document.getElementById("ListHorizontalBar").parentNode.style.display="";
			//document.getElementById("ListDetailAreaTD").parentNode.style.display="";
			//OpenComp("CaseList","/BusinessManage/CaseList.jsp","BatchNo="+sBatchNo,"DetailFrame","");
	
		}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	mySelectRow();
	hideFilterArea();
</script>
<%
	/*~END~*/
%>


<%@	include file="/IncludeEnd.jsp"%>
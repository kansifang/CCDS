<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: 王业罡 2005-08-17
			Tester:
			Describe:文档信息列表
			Input Param:
	       		    ObjectNo: 对象编号
	       		    ObjectType: 对象类型           		
	        Output Param:

			HistoryLog:zywei 2005/09/03 重检代码
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
	String sStatus = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Status")));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = 	{           
								{"BatchNo","批次号"},
                            	{"DocTitle","批次名称"},
                            	{"DocType","批次使用模板"},
                            	{"DocDate","批次建立日期"},
                            	{"TotalCaseCount","变更总数量"}, 
                            	{"TotalCaseSum","变更总委额"},
                            	{"\"040CaseCount\"","已分配变更数量"}, 
                            	{"\"040CaseSum\"","已分配变更委额"},
                            	{"ImportFlagN","批次是否已导入"},
                            	{"UserName","登记人"},
                            	{"OrgName","登记机构"},
                            	{"InputTime","登记日期"},
                            	{"UpdateTime","更新日期"}
                           	};                           
    	//定义SQL语句
    String sSql = " SELECT BatchNo,DocTitle,DocType,DocDate," + 
		  " getCaseSum(BatchNo,1,'all') as TotalCaseCount,"+
		  " getCaseSum(BatchNo,2,'all') as TotalCaseSum,"+
		  " getCaseSum(BatchNo,1,'040') as \"040CaseCount\","+//以数字开头的别名必须这样写
		  " getCaseSum(BatchNo,2,'040') as \"040CaseSum\","+
    	  " ImportFlag,getItemName('YesNo',ImportFlag) as ImportFlagN,OrgName,UserID,UserName,InputTime,UpdateTime " +
		  " FROM Batch_Info" +
		  " WHERE Status='"+sStatus+"'";
	//产生ASDataObject对象doTemp
    ASDataObject doTemp = new ASDataObject(sSql);
    //设置表头
    doTemp.setHeader(sHeaders);
    //可更新的表
    doTemp.UpdateTable = "Batch_Info";
    //设置关键字
	doTemp.setKey("BatchNo",true);
	//设置不可见项
    doTemp.setVisible("UserID,ObjectNo,ObjectType,ImportFlag",false);
    //设置风格
    doTemp.setAlign("AttachmentCount","3");
    doTemp.setHTMLStyle("AttachmentCount","style={width:80px}");
    doTemp.setHTMLStyle("DocTitle"," style={width:140px}");
    doTemp.setHTMLStyle("UserName,OrgName,AttachmentCount,InputTime,UpdateTime"," style={width:80px} ");
    doTemp.setDDDWSql("DocType", "select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%'");
    doTemp.setHTMLStyle("BatchNo,DocTitle,DocType"," style={width:200px;height:20px;cursor:hand} onDBLClick=\"parent.viewConfigList()\"");
    //生成查询框
	doTemp.setColumnAttribute("DocTypeName,DocTitle","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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
			{"010".equals(sStatus)?"true":"false","","Button","新增","新增文档信息","newRecord()",sResourcesPath},
			{"true","","Button","批次详情","查看文档详情","viewAndEdit()",sResourcesPath},
			{"010".equals(sStatus)?"true":"false","","Button","删除","删除文档信息","deleteRecord()",sResourcesPath},
			{"true","","Button","查看附件","查看附件详情","viewDoc()",sResourcesPath},
			{"true","","Button","上传附件","查看附件详情","uploadDoc()",sResourcesPath},
			{"010".equals(sStatus)?"true":"false","","Button","导入批次","查看附件详情","ImportBatch(1)",sResourcesPath},
			{"010".equals(sStatus)?"false":"false","","Button","完成导入","查看附件详情","FinishBatch()",sResourcesPath},
			{"020".equals(sStatus)?"false":"false","","Button","更新批次","查看附件详情","ImportBatch(2)",sResourcesPath},
			{"020".equals(sStatus)?"false":"false","","Button","取消完成导入","查看附件详情","unFinishBatch()",sResourcesPath},
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
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		sReturn=popComp("BatchInfo","/BusinessManage/BatchInfo.jsp","","dialogWidth=50;dialogHeight=60;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
        reloadSelf();  
	}
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"UserID");//取文档录入人	
		sBatchNo = getItemValue(0,getRow(),"BatchNo");
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
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sBatchNo=getItemValue(0,getRow(),"BatchNo");
    	if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0){
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;
    	}else{
    		sReturn=popComp("BatchInfo","/BusinessManage/BatchInfo.jsp","BatchNo="+sBatchNo,"");
            reloadSelf(); 
        }
	}
	/*~[Describe=上传附件;InputParam=1导入2更新;OutPutParam=无;]~*/
	function uploadDoc(){
		var sBatchNo=getItemValue(0,getRow(),"BatchNo");
		var sDocTitle=getItemValue(0,getRow(),"DocTitle");
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
   		popComp("FileChooseDialog","/Common/Document/FileChooseDialog.jsp","BatchNo="+sBatchNo+"&DocModelNo=&DocNo="+sDocNo+"&Handler=&Message=上传成功&Type=","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
   		reloadSelf(); 
	}
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewDoc()
	{
		sBatchNo=getItemValue(0,getRow(),"BatchNo");
		sUserID=getItemValue(0,getRow(),"UserID");//取文档录入人		     	
    	if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;
    	}
    	else
    	{
    		sReturn=popComp("DocumentList","/Document/DocumentList.jsp","ObjectType=Batch&ObjectNo="+sBatchNo,"");
            reloadSelf(); 
        }
	}
	/*~[Describe=导入批量;InputParam=1导入2更新;OutPutParam=无;]~*/
	function ImportBatch(sType)
	{
		var sBatchNo=getItemValue(0,getRow(),"BatchNo");
		var sConfigNo=getItemValue(0,getRow(),"DocType");
		var sDocTitle=getItemValue(0,getRow(),"DocTitle");
		var sImportFlag=getItemValue(0,getRow(),"ImportFlag");
    	if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;
    	}
    	if (sType=="1" &&sImportFlag=="1")
    	{
        	alert("该批次已导入，不能重复导入，请废掉当前批次，重新建批次再导入！");  //请选择一条记录！
			return;
    	}
   		var sReturn=popComp("FileChooseDialog","/Document/FileChooseDialog.jsp","PCNo="+sBatchNo+"&ConfigNo="+sConfigNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
   		if(typeof(sReturn)!=="undefined" && sReturn.length!==0){
   			//alert(sReturn);进来后 是Return为true
   			//RunMethod("PublicMethod","UpdateColValue","String@Status@020,Batch_Info,String@BatchNo@"+sBatchNo);
   	   		reloadSelf(); 
   		}
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
			var sBatchNo = getItemValue(0,getRow(),"BatchNo");
			document.getElementById("ListHorizontalBar").parentNode.style.display="";
			document.getElementById("ListDetailAreaTD").parentNode.style.display="";
			OpenComp("CaseList","/BusinessManage/CaseList.jsp","BatchNo="+sBatchNo,"DetailFrame","");
	
		}
		function viewConfigList(){
			var sBatchNo = getItemValue(0,getRow(),"BatchNo");
			if(sBatchNo.length>0){
				popComp("CaseList","/BusinessManage/CaseList.jsp","BatchNo="+sBatchNo,"","");
			}
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

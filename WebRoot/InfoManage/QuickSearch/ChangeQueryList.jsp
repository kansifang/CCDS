<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: jytian 2004-12-21
			Tester:
			Describe:文档附件列表
			Input Param:
	       		文档编号:BatchNo
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
		String PG_TITLE = "文档附件列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量                     
    String sSql = "";   	
	//获得页面参数
	
	//获得组件参数
	String sBatchNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BatchNo"))); 
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
	                           	{"SerialNo","流水号"},
	                        	{"FatherCNo","父变更"},
	                        	{"ChildCNo","子变更"},
	                           	{"ChangeNo","变更号"},
	                           	{"SystemName","系统名称"},
	                           	{"Status","变更状态"},
	                           	{"Summary","摘要"},
	                           	{"CreateDate","创建时间"},
	                           	{"ChangeType","变更类型"},
	                           	{"ChangeUser","变更申请人"},
	                           	{"BusinessPriority","业务优先级"},
	                           	{"FactoryPriority","厂商优先级"},
	                           	{"FinallyTerm","最终实现期次"},
	                           	{"ChangeConfirmDate","需求分析完成时间"},
	                           	{"UATDate","厂商提交版本时间"},
	                           	{"RelativeSystem","涉及相关系统"},
	                           	{"ChangeConfirmPerson","厂商需求分析人员"},
	                           	{"ChangeWorker","开发人员"},
	                           	{"Problem","存在问题"},
	                           	{"MeetingContent","讨论过程"},
	                           	{"Remark","备注"},
	                           	{"BranchSpecial","分行特色"},
	                           	{"ChangeCondition","开发状态"},
	                           	{"OutFactoryDate","上线版本"},
	                           	{"BusinessWriteCondition","业需编写情况"},
	                           	{"SoftWriteCondition","软需编写情况"},
	                           	{"SoftWriteDir","软需目录"},
	                           	{"BusinessReviewResult","业务评审结果"},
	                           	{"ProjectManagerReviewResult","项目负责人评审结果"},
	                           	{"ChangeManagerReviewResult","需求组评审结果"},
	                           	{"UpdateUserName","维护人"},
						       	{"UpdateTime","维护时间"}
	     					};    		                     
    	//定义SQL语句
	sSql = 	" SELECT BatchNo,SerialNo,"+
    		" ChangeNo,"+
			" SystemName,Status,Summary,CreateDate,"+
			" ChangeType,ChangeUser,BusinessPriority,FactoryPriority,"+
			" FinallyTerm,ChangeConfirmDate,UATDate,RelativeSystem,"+
			" ChangeConfirmPerson,ChangeWorker,Problem,"+
			" MeetingContent,Remark,BranchSpecial,"+
			" ChangeCondition,OutFactoryDate,BusinessWriteCondition,"+
			" SoftWriteCondition,SoftWriteDir,BusinessReviewResult,ProjectManagerReviewResult,"+
			" ChangeManagerReviewResult,"+
			" FatherCNo||'：'||(Select SystemName from Batch_Case BC1 where BC1.ChangeNo=BC.FatherCNo) as FatherCNo,"+
    		" getRowsToRow(ChangeNo) as ChildCNo,"+
			" getUserName(UpdateUserID) as UpdateUserName,UpdateTime"+
			//" getItemName('Status',Status) as Status"+
		    " FROM Batch_Case BC"+
			" WHERE 1=1 "+
           	("".equals(sBatchNo)?"":" and BatchNo='"+sBatchNo+"'");
	ASDataObject doTemp = new ASDataObject(sSql);
	//定义列表表头
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable = "Batch_Case";
	doTemp.setKey("ChangeNo",true);	
	
    doTemp.setVisible("BatchNo,SerialNo",false);
	doTemp.setHTMLStyle("ChangeNo,SystemName,Status","ondblclick=\"javascript:parent.viewAndEdit()\"");
    doTemp.setHTMLStyle("Summary"," style={width:300px;cursor:hand} onDBLClick=\"javascript:parent.viewAndEdit()\"");
    doTemp.setHTMLStyle("ChildCNo"," style={width:400px;cursor:hand} onDBLClick=\"javascript:parent.viewAndEdit()\"");
    //doTemp.setDDDWCode("SystemName", "SystemType");
    //生成查询框
  	doTemp.setColumnAttribute("Status,ChangeNo,SystemName,Summary,ChangeUser,FinallyTerm,OutFactoryDate","IsFilter","1");
  	doTemp.generateFilters(Sqlca);
  	doTemp.parseFilterData(request,iPostChange);
  	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
			{"false","","Button","新增","新增一个相关附件信息","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看明细信息","viewAndEdit()",sResourcesPath},
			{CurUser.hasRole("482")?"true":"false","","Button","删除","删除文档信息","deleteRecord()",sResourcesPath},
			{"false","","Button","上传/查看文档","查看附件详情","viewDoc()",sResourcesPath}
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
		popComp("CaseInfo","/BusinessManage/CaseInfo.jsp","BatchNo=<%=sBatchNo%>","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=查看详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sChangeNo = getItemValue(0,getRow(),"ChangeNo");
		var sSystemName = getItemValue(0,getRow(),"SystemName");
		if (typeof(sChangeNo)=="undefined" || sChangeNo.length==0){
        	alert("请选择一条记录！");
			return;
    	}
   		popComp("CaseInfo","/BusinessManage/CaseInfo.jsp","BatchNo=<%=sBatchNo%>&ChangeNo="+sChangeNo+"&SystemName="+sSystemName,"");
   		reloadSelf();
	}
	/*~[Describe=上传附件;InputParam=无;OutPutParam=无;]~*/	
	function uploadFile()
	{
		var sBatchNo= getItemValue(0,getRow(),"BatchNo");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		popComp("AttachmentChooseDialog","/Common/Document/AttachmentChooseDialog.jsp","BatchNo="+sBatchNo+"&SerialNo="+sSerialNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewFile()
	{
		var sDocNo= getItemValue(0,getRow(),"DocNo");
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		else
		{
			popComp("AttachmentView","/Common/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
			reloadSelf();
		}
	}
	/*~[Describe=导出附件;InputParam=无;OutPutParam=无;]~*/
	function exportFile()
	{
		//导出附件信息       
    	OpenPage("/BusinessManage/Document/ExportFile.jsp","_self","");
	}
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sChangeNo = getItemValue(0,getRow(),"ChangeNo");
		if (typeof(sChangeNo)=="undefined" || sChangeNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
			{
        		as_del('myiframe0');
        		as_save('myiframe0'); 
    		}
		}
		
	}	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewDoc()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sUserID=getItemValue(0,getRow(),"UserID");//取文档录入人		     	
    	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;
    	}
    	else
    	{
    		sReturn=popComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType=Case&ObjectNo="+sSerialNo,"");
            reloadSelf(); 
        }
	}
	</script>
<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	hideFilterArea();
	my_load(2,0,'myiframe0');
</script>
<%@	include file="/IncludeEnd.jsp"%>
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
                            	{"SerialNo","案子号"},
                            	{"DueNo","借据号"},
                            	{"LCustomerID","委托方"},
                            	{"LCustomerName","委托方"},
                            	{"LDate","委托日期"},
                            	{"LSum","委托金额"},
                            	{"DCustomerID","姓名"},
                            	{"DCustomerName","姓名"},
                            	{"ID","身份证号"},
                            	{"CardNo","卡号"},
                            	{"PayBackSum","应还款金额"},
                            	{"PayBackDate","应还日期"},
                            	{"ActualPayBackSum","实际还款金额"},
                            	{"ActualPayBackDate","实际还日期"},
                            	{"Balance","余额"},
                            	{"Remark","评语"},
                            	{"BeginTime","发送开始时间"},
                            	{"EndTime","发送结束时间"},
                            	{"BeginTime","发送开始时间"},
                            	{"EndTime","发送结束时间"}
	     			};    		                     
	
	    
    	//定义SQL语句
    	
	sSql = 	" SELECT BatchNo,SerialNo,DueNo,"+
	" LCustomerID,LCustomerName,"+
	" LDate,LSum,"+
	" DCustomerID,DCustomerName,"+
	" ID,CardNo,"+
	" PayBackSum,PayBackDate,"+
	" ActualPayBackSum,ActualPayBackDate,"+
	" Balance,Remark,"+
	" BeginTime,EndTime,"+
	" getItemName('Status',Status) as Status"+
           	" FROM Batch_Case"+
	" WHERE 1=1 "+
           	("".equals(sBatchNo)?"":" and BatchNo='"+sBatchNo+"'")+
           	("".equals(sStatus)?"":" and Status='"+sStatus+"'");
	ASDataObject doTemp = new ASDataObject(sSql);
	//定义列表表头
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable = "Batch_Case";
	doTemp.setKey("SerialNo",true);	
	
    doTemp.setVisible("BatchNo,LCustomerID,DCustomerID",false);
	doTemp.setHTMLStyle("BeginTime,EndTime,ContentType"," ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setHTMLStyle("ContentLength"," style={width:50px} ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setHTMLStyle("FileName"," style={width:150px} ondblclick=\"javascript:parent.viewFile()\" ");
    doTemp.setAlign("ContentLength","3");
    //生成查询框
  	doTemp.setColumnAttribute("LCustomerName,DCustomerName","IsFilter","1");
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
			{"false","","Button","删除","删除文档信息","deleteRecord()",sResourcesPath},
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
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    	{
        	alert("请选择一条记录！");
			return;
    	}
    	else
    	{
    		popComp("CaseInfo","/BusinessManage/CaseInfo.jsp","BatchNo=<%=sBatchNo%>&SerialNo="+sSerialNo,"");
    		reloadSelf();
		}
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
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
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
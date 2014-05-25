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
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectType.equals("Customer"))
	 	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	else							
		sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sTempletNo = "QDocument";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//设置不可见项
    doTemp.setVisible("UserID,DocType,ObjectNo,ObjectType",false);
    //设置风格
   	doTemp.setEditStyle("DocKeyWord,DocAbstract,Remark", "1");
	doTemp.setHTMLStyle("DocKeyWord,DocAbstract,Remark", "");
    //生成查询框
	doTemp.setColumnAttribute("DocTypeName,DocTitle","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	//设置setEvent
	Vector vTemp = dwTemp.genHTMLDataWindow("QDT,All");
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
			{"true","","Button","新增","新增文档信息","newRecord()",sResourcesPath},
			{"true","","Button","批量详情","查看批量详情","viewAndEdit_doc()",sResourcesPath},
			{"true","","Button","内容详情","查看批量详情","viewAndEdit_attachment()",sResourcesPath},
			{"true","","Button","删除","删除文档信息","deleteRecord()",sResourcesPath},
			{"false","","Button","导出附件","导出附件文档信息","exportFile()",sResourcesPath},
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
		OpenPage("/Data/Define/QDocumentInfo.jsp","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"UserID");//取文档录入人	
		sDocNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{ 
			if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
			{
				as_del('myiframe0');
				as_save('myiframe0') //如果单个删除，则要调用此语句             
			} 
		}else 
		{
			alert(getHtmlMessage('3'));
			return;
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit_doc()
	{
		sDocNo=getItemValue(0,getRow(),"DocNo");
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;
    	}
    	else
    	{
    		OpenPage("/Data/Define/QDocumentInfo.jsp?DocNo="+sDocNo,"_self","");
        }
	}
	
	/*~[Describe=查看及修改附件详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit_attachment()
	{    
    	sDocNo=getItemValue(0,getRow(),"DocNo");
    	sUserID=getItemValue(0,getRow(),"UserID");//取文档录入人	     
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{        
        	alert(getHtmlMessage(1));  //请选择一条记录！
			return;         
    	}
    	else
    	{
    		popComp("QDefinitionList","/Data/Define/QDefinitionList.jsp","docNo="+sDocNo);
      		reloadSelf();
      	}
	}
	function mySelectRow()
	{
		//hideFilterArea();
		var sCodeNo = getItemValue(0,getRow(),"DocNo");
		var sType = getItemValue(0,getRow(),"CodeAttribute");
		if(sCodeNo.length>0){
			document.getElementById("ListHorizontalBar").parentNode.style.display="";
			document.getElementById("ListDetailAreaTD").parentNode.style.display="";
			OpenComp("QTabConfigList","/Data/Define/QTabConfigList.jsp","CodeNo="+sCodeNo+"&type="+sType,"DetailFrame","");
		}
	}
	/*~[Describe=导出附件;InputParam=无;OutPutParam=无;]~*/
	function exportFile()
	{
		//导出附件信息       
    	OpenPage("/Common/Document/ExportFile.jsp","_self","");
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
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
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>


<%@	include file="/IncludeEnd.jsp"%>

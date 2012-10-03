<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: 评估模型列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "评估模型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sSortNo; //排序编号
	
    //获得页面参数	
    //获得组件参数	
    String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if (sModelNo == null) sModelNo = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
   	String sHeaders[][] = {
							{"ModelNo","评估表编号"},
							{"ItemNo","项目编号"},
							{"DisplayNo","显示序号"},
							{"ItemName","项目名称"},
							{"ItemAttribute","项目属性"},
							{"ValueMethod","取值方法"},
							{"ValueCode","取值代码"},
							{"ValueType","值类型"},
							{"EvaluateMethod","评估方法"},
							{"Coefficient","权重"},
							{"Remark","备注"}
					       };  

	sSql = " Select ModelNo,"+
				"ItemNo,DisplayNo,"+
				"ItemName,ItemAttribute,"+
				"ValueMethod,ValueCode,"+
				"ValueType,EvaluateMethod,"+
				"Coefficient,Remark "+ 
				" From EVALUATE_MODEL"+
				" Where ModelNo='"+sModelNo+"'"+
				" order by DisplayNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="EVALUATE_MODEL";
	doTemp.setKey("ModelNo,ItemNo",true);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("ModelNo,ItemNo,ItemAttribute,Remark",false);
	
	//设置小数显示状态,
	doTemp.setAlign("Coefficient","3");
	doTemp.setType("Coefficient","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("Coefficient","2");
	
	doTemp.setFilter(Sqlca,"1","ItemNo","");
	doTemp.setFilter(Sqlca,"2","ItemName","");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(30);
    
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","250");
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回","doReturn('N')",sResourcesPath}
		};
    %> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    var sCurModelNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn=popComp("EvaluateModelInfo","/Common/Configurator/EvaluateManage/EvaluateModelInfo.jsp","ModelNo=<%=sModelNo%>","");
        //修改数据后刷新列表
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/EvaluateManage/EvaluateModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        sItemNo = getItemValue(0,getRow(),"ItemNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        sReturn=popComp("EvaluateModelInfo","/Common/Configurator/EvaluateManage/EvaluateModelInfo.jsp","ModelNo="+sModelNo+"~ItemNo="+sItemNo,"");
        //修改数据后刷新列表
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/EvaluateManage/EvaluateModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sItemNo = getItemValue(0,getRow(),"ItemNo");
        if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
	</script>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//added by bllou 2012-09-20 新评级模板显示细项
		function mySelectRow()
		{
			var sModelNo = getItemValue(0,getRow(),"ModelNo");
			var sItemNo = getItemValue(0,getRow(),"ItemNo");
			var sValueCode = getItemValue(0,getRow(),"ValueCode");
			var sValueMethod = getItemValue(0,getRow(),"ValueMethod").length>0?"true":"false";
			var sValueType = getItemValue(0,getRow(),"ValueType");
			if("<%=Sqlca.getString("select RelativeCode from Code_Library where CodeNo='OperateModelNos' and ItemNo='010' and IsInUse='1'")%>".indexOf(sModelNo)>0&&sValueType.length>0){
				document.getElementById("ListHorizontalBar").parentNode.style.display="";
				document.getElementById("ListDetailAreaTD").parentNode.style.display="";
			  	//OpenPage("/ImpawnManage/ShowInfoManage/ImpawnRightDocList.jsp?IMASerialno="+sIMASerialno+"&ImpawnID="+sImpawnID,"DetailFrame","");
			  	OpenComp("EvaluateScoreConfigList","/Common/Configurator/EvaluateManage/EvaluateScoreConfigList.jsp","ModelNo="+sModelNo+"&ItemNo="+sItemNo+"&ValueCode="+sValueCode+"&ValueMethod="+sValueMethod+"&CodeNo=ScoreToItemValue","DetailFrame","");

			}else{
				document.getElementById("ListHorizontalBar").parentNode.style.display="none";
				document.getElementById("ListDetailAreaTD").parentNode.style.display="none";
			}
		}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	mySelectRow();
	hideFilterArea();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: 评估模型目录列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "评估模型目录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sSortNo; //排序编号

	//获得组件参数	
	String sType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
	if(sType == null) sType = "";
	//获得页面参数	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
   	String sHeaders[][] = {
					{"ModelNo","评估表编号"},
					{"ModelName","评估表名称"},
					{"ModelType","评估表类别"},
					{"ModelDescribe","评估表描述"},
					{"TransformMethod","转换方法"},
					{"Remark","备注"},
			       };  

	sSql = 	" Select ModelNo,ModelName,getItemName('EvaluateModelType',ModelType) as ModelType,"+
			" TransformMethod,ModelDescribe,Remark "+ 
			" From EVALUATE_CATALOG ";
	//模型类型参见代码EvaluateModelType
	if(sType.equals("Classify")) //资产风险分类
		//sSql += " Where ModelNo = 'Classify1' ";
		sSql += " Where ModelType = '020' ";
	if(sType.equals("Risk")) //风险度评估
		//sSql += " Where ModelNo = 'RiskEvaluate' ";	
		sSql += " Where ModelType = '030' ";	
	if(sType.equals("CreditLine")) //最高综合授信额度参考
		//sSql += " Where ModelNo = 'CreditLine' ";
		sSql += " Where ModelType = '080' ";
	if(sType.equals("CreditLevel")) //信用等级评估	(公司客户和个人)
		//sSql += " Where (ModelNo like '0%' or ModelNo like '5%') ";	
		sSql += " Where (ModelType ='010' or ModelType = '015' or ModelType = '017') ";//added by bllou 加一个同业	
	sSql += " order by ModelType,ModelNo ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="EVALUATE_CATALOG";
	doTemp.setKey("ModelNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("ModelNo"," style={width:120px} ");
	doTemp.setHTMLStyle("ModelName"," style={width:200px} ");
	doTemp.setHTMLStyle("TransformMethod,"," style={width:600px} ");
	doTemp.setHTMLStyle("ModelDescribe,Remark"," style={width:200px} ");
	doTemp.setVisible("ModelDescribe,Remark",false);
	
	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	//查询
 	doTemp.setColumnAttribute("ModelNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	
	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelEvaluateModel(#ModelNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//added by bllou 2012-09-20 新评级模板显示细项
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","150");
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
		{"false","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","模型列表","查看/修改模型列表","viewAndEdit2()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn=popComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //新增数据后刷新列表
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/EvaluateManage/EvaluateCatalogList.jsp","_self","");    
                }
            }
        }
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        //openObject("EvaluateCatalogView",sModelNo,"001");
        popComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","ModelNo="+sModelNo);
        
	}
    
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2()
	{
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        popComp("EvaluateModelList","/Common/Configurator/EvaluateManage/EvaluateModelList.jsp","ModelNo="+sModelNo,"");
        
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sModelNo = getItemValue(0,getRow(),"ModelNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('50'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
		function mySelectRow()
		{
			var sModelNo = getItemValue(0,getRow(),"ModelNo");
			if("<%=Sqlca.getString("select RelativeCode from Code_Library where CodeNo='OperateModelNos' and ItemNo='010' and IsInUse='1'")%>".indexOf(sModelNo)>0){
				document.getElementById("ListHorizontalBar").parentNode.style.display="";
				document.getElementById("ListDetailAreaTD").parentNode.style.display="";
				OpenComp("EvaluateScoreConfigList","/Common/Configurator/EvaluateManage/EvaluateScoreConfigList.jsp","ModelNo="+sModelNo+"&CodeNo=CreditLevelToTotalScore","DetailFrame","");
			}else{
				document.getElementById("ListHorizontalBar").parentNode.style.display="none";
				document.getElementById("ListDetailAreaTD").parentNode.style.display="none";
			}
		  	//OpenPage("/ImpawnManage/ShowInfoManage/ImpawnRightDocList.jsp?IMASerialno="+sIMASerialno+"&ImpawnID="+sImpawnID,"DetailFrame","");
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

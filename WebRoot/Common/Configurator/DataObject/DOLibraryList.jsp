<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   --cwzhan 2004-12-15
			Tester:
			Content: 代码表列表
			Input Param:
	                    DoNo：    --显示模板编号
	                    sEditRight:--编辑权限
			Output param:
			                
			History Log: 
	            
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
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

	//获得页面参数	：代码表编号、编辑权限
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DoNo"));
	String sEditRight =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	//获得组件参数
    if(sDoNo == null) sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
    if (sDoNo == null) sDoNo = "";
    if (sEditRight == null) sEditRight = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders={
	{"DoNo","DO编号"},
	{"ColIndex","列号"},
	{"ColHeader","中文名称"},			
	{"ColType","值类型"},			
	{"ColAttribute","属性"},
	{"ColTableName","数据表名"},
	{"ColActualName","数据库源名"},
	{"ColName","使用名"},	
	{"ColDefaultValue","缺省值"},			
	{"ColUnit","显示后缀"},
	{"ColColumnType","是否Sum"},
	{"ColCheckFormat","检查格式"},
	{"ColAlign","对齐"},
	{"ColEditStyle","编辑形式"},
	{"ColEditSourceType","下拉框来源"},
	{"ColEditSource","来源描述"},
	{"ColHtmlStyle","HTML格式"},
	{"ColLimit","长度"},
	{"ColKey","关键字"},
	{"ColUpdateable","可更新"},
	{"ColVisible","可见"},
	{"ColReadOnly","只读"},
	{"ColRequired","必须"},
	{"ColSortable","排序"},
	{"ColCheckItem","检查"},
	{"ColTransferBack","回传"},
	{"IsForeignKey","是否外键"},
	{"SortNo","字段序"},
	{"IsInUse","是否有效"},
	{"DataPrecision","有效位"},
	{"DataScale","小数位"},
	{"Attribute1","过滤器1"},
	{"Attribute2","过滤器2"},
	{"Attribute3","过滤器3"},
		};

	sSql =  " select DoNo,ColIndex,ColHeader,getItemName('DataType',ColType) as ColType,ColAttribute, "+
	" ColTableName,ColActualName,ColName,ColDefaultValue,ColUnit,ColColumnType, "+
	" ColCheckFormat,ColAlign,ColEditStyle,ColEditSourceType,ColEditSource,ColHtmlStyle, "+
	" ColLimit,ColKey,ColUpdateable,ColVisible,ColReadOnly,ColRequired,ColSortable, "+
	" ColCheckItem,ColTransferBack,IsForeignKey,SortNo,getItemName('IsInUse',IsInUse) as IsInUse, "+
	" DataPrecision,DataScale,Attribute1,Attribute2,Attribute3 "+
	" from DATAOBJECT_LIBRARY ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "DATAOBJECT_LIBRARY";
	doTemp.setKey("DoNo,ColIndex",true);
	doTemp.setHeader(sHeaders);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.setAlign("ColType,IsInUse","2");
	//设置不可见性
	doTemp.setVisible("ColColumnType,ColCheckFormat,ColAlign,ColEditStyle,ColEditSourceType,ColLimit,ColKey,ColUpdateable,ColVisible,ColReadOnly,ColRequired,ColSortable,ColCheckItem,ColTransferBack,IsForeignKey,SortNo,Attribute1,Attribute2,Attribute3",false);    	
   	//查询
 	doTemp.setColumnAttribute("DoNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!sDoNo.equals("")) 
	{
		doTemp.WhereClause += " where DoNo = '"+sDoNo+"' ";
	}
	
	//设置列宽度
	doTemp.setHTMLStyle("ColIndex"," style={width:60px} ");
	doTemp.setHTMLStyle("ColAttribute"," style={width:400px} ");
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(22);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDoNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
			};
	   //add by fbkang 2005.7.28
	   //产品管理联接过来的就屏蔽这些功能
	   if (sEditRight.equals("01"))
	    {
	      sButtons[0][0]="False";
	      sButtons[1][0]="false";
	      sButtons[2][0]="false";
	    }
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
        sReturn=popComp("DOLibraryInfo","/Common/Configurator/DataObject/DOLibraryInfo.jsp","DoNo=<%=sDoNo%>","");
        reloadSelf();
        //新增数据后刷新列表
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
         {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/DataObject/DOLibraryList.jsp?DoNo="+sReturnValues[0],"_self","");    
            }
         }
        
	}
	
     /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sDoNo = getItemValue(0,getRow(),"DoNo");
        sColIndex = getItemValue(0,getRow(),"ColIndex");
        if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        
        sReturn=popComp("DOLibraryInfo","/Common/Configurator/DataObject/DOLibraryInfo.jsp","DoNo="+sDoNo+"~ColIndex="+sColIndex,"");
        reloadSelf();
        //修改数据后刷新列表
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/DataObject/DOLibraryList.jsp?DoNo="+sReturnValues[0],"_self","");    
            }
        }
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sDoNo = getItemValue(0,getRow(),"DoNo");
        if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
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

	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

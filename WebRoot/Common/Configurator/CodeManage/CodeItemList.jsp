<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: 代码表列表
			Input Param:
	                    CodeNo：    代码表编号
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
	String sDiaLogTitle = "";
	String sCodeNo = ""; //代码表编号
	String sCodeName = ""; //代码表名称
	
	//获得组件参数	
	sCodeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));   
	if(sCodeNo==null) sCodeNo="";
	sCodeName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeName"));   
	if(sCodeName==null) sCodeName="";
	sDiaLogTitle = "【"+sCodeName+"】代码：『"+sCodeNo+"』配置";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders={
		{"CodeNo","代码号"},
		{"ItemNo","项目号"},
		{"ItemName","项目名称"},
		{"SortNo","排序号"},
		{"IsInUse","有效状态"},
		{"ItemDescribe","项目描述"},
		{"ItemAttribute","项目属性"},
		{"RelativeCode","关联代码"},
		{"Attribute1","属性1"},
		{"Attribute2","属性2"},
		{"Attribute3","属性3"},
		{"Attribute4","属性4"},
		{"Attribute5","属性5"},
		{"Attribute6","属性6"},
		{"Attribute7","属性7"},
		{"Attribute8","属性8"},
		{"Remark","备注"},
		{"HelpText","帮助"},
		{"InputUserName","登记人"},
		{"InputUser","登记人"},
		{"InputOrgName","登记机构"},
		{"InputOrg","登记机构"},
		{"InputTime","登记时间"},
		{"UpdateUserName","更新人"},
		{"UpdateUser","更新人"},
		{"UpdateTime","更新时间"},
		};

	sSql = "select "+
	"CodeNo,"+
	"ItemNo,"+
	"ItemName,"+
	"SortNo,"+
	"getItemName('IsInUse',IsInUse) as IsInUse,"+
	"ItemDescribe,"+
	"ItemAttribute,"+
	"RelativeCode,"+
	"Attribute1,"+
	"Attribute2,"+
	"Attribute3,"+
	"Attribute4,"+
	"Attribute5,"+
	"Attribute6,"+
	"Attribute7,"+
	"Attribute8,"+
	"Remark,"+
	"HelpText,"+
	"getUserName(InputUser) as InputUserName,"+
	"InputUser,"+
	"getOrgName(InputOrg) as InputOrgName,"+
	"InputOrg,"+
	"InputTime,"+
	"getUserName(UpdateUser) as UpdateUserName,"+
	"UpdateUser,"+
	"UpdateTime "+
	"from CODE_LIBRARY Where 1 = 1 ";

	ASDataObject doTemp = new ASDataObject(sSql);

	doTemp.UpdateTable="CODE_LIBRARY";
	doTemp.setKey("CodeNo,ItemNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("ItemNo"," style={width:100px} ");
	doTemp.setHTMLStyle("SortNo"," style={width:56px} ");
	doTemp.setHTMLStyle("IsInUse"," style={width:56px} ");
	
	//查询
	doTemp.setColumnAttribute("CodeNo,ItemName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(sCodeNo!=null && !sCodeNo.equals("")) 
	{
		doTemp.WhereClause+=" And CodeNo='"+sCodeNo+"'";
	}
	/*
	else
	{
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause  += " And 1=2";
	}
	*/
	//by zhou 2005-08-31
	doTemp.OrderClause += " Order by  CodeNo,SortNo ";
	
	doTemp.setHTMLStyle("InputUserName,UpdateUserName,InputOrgName"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:90px} ");
	//所有都为不显示
	doTemp.setVisible("Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8,InputUserName,InputOrgName,UpdateUserName,InputUser,InputOrg,UpdateUser,InputTime,UpdateTime",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
	//只读项
	doTemp.setReadOnly("CodeNo,InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	
	doTemp.setEditStyle("Remark,HelpText,ItemDescribe,ItemAttribute,RelativeCode,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8","3");
	doTemp.setHTMLStyle("Remark,HelpText,ItemDescribe,ItemAttribute,RelativeCode,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8"," style={width:200px;height:22px;overflow:auto} onDBLClick=\"parent.editObjectValueWithScriptEditorForASScript(this)\"");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateCodeCatalogUpdateTime("+StringFunction.getTodayNow()+","+CurUser.UserID+",#CodeNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql);
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
	        sReturn=popComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeNo=<%=sCodeNo%>&CodeName=<%=sCodeName%>","");
	        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
	        {
	            //新增数据后刷新列表
	            sReturnValues = sReturn.split("@");
	            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
	            {
	                reloadSelf();
	            }
	        }
	        
	}
	
     /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
	        sCodeNo = getItemValue(0,getRow(),"CodeNo");
	        sItemNo = getItemValue(0,getRow(),"ItemNo");
	        if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
			}
        
        sReturn=popComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeName=<%=sCodeName%>&CodeNo="+sCodeNo+"&ItemNo="+sItemNo+"&rand="+amarRand(),"");
		reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCodeNo = getItemValue(0,getRow(),"CodeNo");
        if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) {
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
	ssCodeNo = "<%=sCodeNo%>"
        if(typeof(ssCodeNo)=="undefined" || ssCodeNo.length==0)	
        {
        //因sCodeNo 空时，页面未调用模态窗口 Remark by wuxiong 2005-02-23
        }
        else
        {
         	setDialogTitle("<%=sDiaLogTitle%>");
        }
//add by byhu 默认显示filter区，查询后不显示
<%if(!doTemp.haveReceivedFilterCriteria()) {%>
	showFilterArea();
<%}%>
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

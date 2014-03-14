<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-28
			Tester:
			Content: 财务模型列表
			Input Param:
	                  
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
	String sSql;
	String sSortNo; //排序编号
	//获得页面参数
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders = {
		{"TypeNo","类型编号（永久）"},
		{"SortNo","排序编号"},
		{"TypeName","类型名称"},
		{"IsInUse","是否有效"},
		{"TypesortNo","类型序号"},
		{"SubtypeCode","分类编号"},
		{"InfoSet","信息设置"},
		{"DisplayTemplet","对应的显示模板"},
		{"Attribute1","属性1"},
		{"Attribute2","属性2"},
		{"Attribute3","属性3"},
		{"Attribute4","属性4"},
		{"Attribute5","属性5"},
		{"Attribute6","属性6"},
		{"Attribute7","属性7"},
		{"Attribute8","属性8"},
		{"Attribute9","属性9"},
		{"Attribute10","属性10"},
		{"Remark","备注"},
		{"ApplyDetailNo","应用明显号"},
		{"ApproveDetailNo","审批明显号"},
		{"ContractDetailNo","合同明显号"},
		{"InputUserName","登记人"},
		{"InputUser","登记人"},
		{"InputORGName","登记机构"},
		{"InputORG","登记机构"},
		{"InputTime","登记时间"},
		{"UpdateUserName","更新人"},
		{"UpdateUser","更新人"},
		{"UpdateTime","更新时间"},
		};
	sSql = "select "+
	"TypeNo,"+
	"SortNo,"+
	"TypeName,"+
	"getItemName('IsInUse',IsInUse) as IsInUse,"+
	"TypesortNo,"+
	"SubtypeCode,"+
	"InfoSet,"+
	"DisplayTemplet,"+
	"Attribute1,"+
	"Attribute2,"+
	"Attribute3,"+
	"Attribute4,"+
	"Attribute5,"+
	"Attribute6,"+
	"Attribute7,"+
	"Attribute8,"+
	"Attribute9,"+
	"Attribute10,"+
	"Remark,"+
	"ApplyDetailNo,"+
	"ApproveDetailNo,"+
	"ContractDetailNo,"+
	"getUserName(InputUser) as InputUserName,"+
	"InputUser,"+
	"getOrgName(InputORG) as InputORGName,"+
	"InputORG,"+
	"InputTime,"+
	"getUserName(UpdateUser) as UpdateUserName,"+
	"UpdateUser,"+
	"UpdateTime "+
	"from BUSINESS_TYPE where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_TYPE";
	doTemp.setKey("TypeNo",true);
	doTemp.setHeader(sHeaders);
	//查询
 	doTemp.setColumnAttribute("TypeNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
 
 	doTemp.setHTMLStyle("InputORG"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setReadOnly("InputUser,UpdateUser,InputORG,InputUserName,UpdateUserName,InputORGName,InputTime,UpdateTime",true);
	doTemp.setVisible("InputUser,InputORG,UpdateUser",false);    	

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
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
    var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn=popComp("BizTypeInfo","/Common/Configurator/BizTypeManage/BizTypeInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //新增数据后刷新列表
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/BizTypeManage/BizTypeList.jsp","_self","");    
                }
            }
        }
        
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sTypeNo = getItemValue(0,getRow(),"TypeNo");
        if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        sReturn=popComp("BizTypeInfo","/Common/Configurator/BizTypeManage/BizTypeInfo.jsp","TypeNo="+sTypeNo,"");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //新增数据后刷新列表
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/BizTypeManage/BizTypeList.jsp","_self","");    
                }
            }
        }
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");
        if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
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
	
	function mySelectRow()
	{
        
	}
	
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

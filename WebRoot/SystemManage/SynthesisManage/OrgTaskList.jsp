<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Describe: 机构任务设置
			Input Param:
			Output Param:
			HistoryLog: zywei on 2005/08/14 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "机构任务设置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量：sql语句
	String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//设置列表显示标题			
	String sHeaders[][] = {	
					{"SerialNo","流水号"},	
					{"Year","年度"},
					{"OrgID","机构编号"},								
					{"OrgName","机构名称"},
					{"TaskIndex","任务指标"},
					{"Inputuserid","登记人"},
					{"Inputorgid","登记机构"}								
		          };
   
   sSql = " select SerialNo,Year,OrgID,OrgName,TaskIndex,Inputuserid,Inputorgid "+
   		  " from Org_Task_Info "+
          "  where 1=1 ";
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "Org_Task_Info";
	doTemp.setKey("SerialNo",true);
	//设置字段是否可见
	doTemp.setVisible("SerialNo",false);
		
	//生成查询条件
	doTemp.setColumnAttribute("OrgID,OrgName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
		{"true","","Button","新增","新增","newRecord()",sResourcesPath},
		{"true","","Button","详情","详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除","deleteRecord()",sResourcesPath}		
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
<script language="javascript">
		
	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		sReturn=popComp("AddOrgTaskInfo","/SystemManage/SynthesisManage/OrgTaskInfo.jsp","","");        
        reloadSelf();
	}
	
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sReturn=popComp("AddOrgTaskInfo","/SystemManage/SynthesisManage/OrgTaskInfo.jsp","SerialNo="+sSerialNo,"");
    	reloadSelf();
	}
	
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
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

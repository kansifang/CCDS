<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29
		Tester:
		Describe: 项目进展情况
		Input Param:
			ProjectNo：当前项目编号
		Output Param:
			ProjectNo：当前项目编号
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "项目进展情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得页面参数	 
	
	//获得组件参数	
	String sProjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = { {"ProjectNo","项目编号"},
							{"UpToDate","调查日期"},
							{"ProjectStatus","项目进展情况"},
							{"InvestedSum","已投资金额(元)"},
							{"OrgName","登记机构"},
						    {"UserName","登记人"}
						};   		   		
	
	String sSql =	"  select ProjectNo,SerialNo,UpToDate,ProjectStatus,InvestedSum, " +
					"  InputOrgId,getOrgName(InputOrgId) as OrgName ,"+
					"  InputUserId,getUserName(InputUserId) as UserName" +
					"  from PROJECT_PROGRESS "+
					"  where ProjectNo='"+sProjectNo+"'";
					
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "PROJECT_PROGRESS";
	doTemp.setKey("CustomerID,SerialNo",true);	 //为后面的删除
	//设置不可见项
	doTemp.setVisible("ProjectNo,SerialNo,InputOrgId,InputUserId,ProjectStatus",false);	    
	//通常用于外部存储函数得到的字段
	doTemp.setUpdateable("UserName,OrgName,",false);   
	doTemp.setHTMLStyle("UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:200px} ");	
	doTemp.setCheckFormat("UpToDate","3");
	//靠右对齐
	doTemp.setAlign("InvestedSum","3");
	//如果设置数字（小数）型
	doTemp.setType("InvestedSum","Number");//设置数字型，对应设置模版“值类型”
	doTemp.setCheckFormat("InvestedSum","2");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","新增","新增项目进展情况信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看项目进展情况信息详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除项目进展情况信息","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/ProjectProgressInfo.jsp","_self","");
	}
	

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sProjectNo = getItemValue(0,getRow(),"ProjectNo");		
		if (typeof(sProjectNo)=="undefined" || sProjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}		
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{

		sProjectNo   = getItemValue(0,getRow(),"ProjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)		
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{       
			OpenPage("/CustomerManage/EntManage/ProjectProgressInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

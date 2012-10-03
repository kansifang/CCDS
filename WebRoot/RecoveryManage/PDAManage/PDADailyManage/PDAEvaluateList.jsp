<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-3
		Tester:
		Content: 抵债资产价值评估记录
		Input Param:
			        ObjectNo：对象编号
			        ObjectType：对象类型						
		Output param:
		
		History Log: zywei 2005/09/06 重检代码
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = " 抵债资产价值评估记录"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sComponentName == null) sComponentName = "";
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
		
	//定义表头文件
	String sHeaders[][] = { 							
										{"SerialNo","评估记录流水号"},
										{"ObjectType","对象类型"},
										{"ObjectNo","资产流水号"},										
										{"AssetName","资产名称"},
										{"EvaluateReportNo","评估报告编号"},	
										{"EvaluateDate","评估日期"},	
										{"EvaluateSum","评估市场价格(元)"},	
										{"EvaluateOrgID","评估机构"}, 
										{"EvaluateMethod","评估方法"},
										{"EvaluateMethodName","评估方法"}
									}; 
	//从抵债资产价值评估表EVALUATE_INFO中选出该资产的价值评估记录
	sSql =  " select EI.SerialNo,"+
			" EI.ObjectType,"+
			" EI.ObjectNo,"+			
			" AI.AssetName, "+
			" EI.EvaluateReportNo,"+
			" EI.EvaluateDate,"+				
			" EI.EvaluateSum,"+
			" EI.EvaluateOrgID," +	
			" EI.EvaluateMethod," +	
			" getItemName('EvaluateMethod',EI.EvaluateMethod) as EvaluateMethodName"+
			" from EVALUATE_INFO EI, ASSET_INFO AI" +
			" where EI.ObjectType='"+sObjectType+"' "+
			" and EI.ObjectNo='"+sObjectNo+"' "+
			" and EI.ObjectNo=AI.SerialNo "+
			" order by EI.EvaluateDate desc";
			//对应于ObjectType的某个资产的价值评估记录。
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "EVALUATE_INFO";	
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 

	//设置不可见项
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,EvaluateMethod",false);

	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("SerialNo,ObjectNo,EvaluateDate","style={width:80px} ");  
	doTemp.setHTMLStyle("AssetName,EvaluateReportNo,EvaluateSum","style={width:100px} ");  
	doTemp.setHTMLStyle("EvaluateOrgID,EvaluateMethod"," style={width:80px} ");
	doTemp.setCheckFormat("EvaluateSum","2");	
	
	//设置对齐方式
	doTemp.setAlign("EvaluateSum","3");
	doTemp.setType("EvaluateSum","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("EvaluateSum","2");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
		{"true","","Button","新增","新增价值评估记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","价值评估记录详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除评估记录","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAEvaluateInfo.jsp","right","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{		
			if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
			{
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");			
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAEvaluateInfo.jsp?SerialNo="+sSerialNo,"right","");
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

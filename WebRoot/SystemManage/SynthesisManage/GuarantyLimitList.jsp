<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Describe: 资本净额管理
			Input Param:
			Output Param:
			
			HistoryLog:
			--msHuang on 2008/04/08 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "本行资本净额管理列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql="";//--存放sql语句
	String sComponentName;//--组件名称
	String PG_CONTENT_TITLE;
	//获得页面参数	
	
	//获得组件参数	
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = { 
		 						{"SerialNo","流水号"},
	                    {"CustomerID","担保客户号"},	
	                    {"CustomerName","担保客户名称"},					      
				        {"SumLimit","总担保限额"},
				        {"InLimit","表内担保限额"},
				        {"OutLimit","表外担保限额"},
				        {"UpdateDate","更新日期"},
						{"Maturity","有限日期"}
	               };   				   		
		   		

	sSql = " select SerialNo,CustomerID,CustomerName,"+
		   " SumLimit,InLimit,OutLimit,Maturity,UpdateDate"+
		   " from Guaranty_Limit "+	            
		   " where 1=1 order by SerialNo ";
	              
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "Guaranty_Limit";
	//设置主键
	doTemp.setKey("SerialNo",true);
	//设置字段的不可见
	//doTemp.setVisible("SerialNo",false);
	//设置number列
	doTemp.setCheckFormat("SumLimit,InLimit,OutLimit","2");

	//置字段是否可更新，主要是外部函数产生的，类似UserName\OrgName	    
	//doTemp.setUpdateable("UserName,OrgName",false);
	//设置html格式
	
	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerID","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			   {"true","","Button","新增","新增","my_add()",sResourcesPath},
			   {"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
			   {"true","","Button","详情","详情","viewAndEdit()",sResourcesPath}
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
	function my_add()
	{ 	 
	    OpenPage("/SystemManage/SynthesisManage/GuarantyLimitInfo.jsp","_self","");
	}	                                                                                                                                                                                                                                                                                                                                                 

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
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
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/SystemManage/SynthesisManage/GuarantyLimitInfo.jsp?SerialNo="+sSerialNo, "_self","");
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

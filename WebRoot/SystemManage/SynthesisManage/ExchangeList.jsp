<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Describe: 汇率管理
			Input Param:
		              --sComponentName:组件名称
			Output Param:
			
		

			HistoryLog:
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "汇率管理信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = { 
		                        {"Currency","币种"},
		                        {"CurrencyName","币种"},
			            {"EfficientDate","生效日期"},  
			            {"EfficientTime","生效时间"},  
			            {"Price","中间价"},
			            {"Unit","单位"}					        
				  };   		   		
	
	sSql = " select Currency,getItemName('Currency',Currency) as CurrencyName,"+
           " Unit,Price,EfficientDate,EfficientTime"+
           " from ERATE_INFO "+
           " where 1=1 "+
           " Order by EfficientDate desc";
             
  	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "ERATE_INFO";
	doTemp.setKey("Currency",true);		
	//设置币种下拉框内容
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setVisible("Currency",false);
	//生成查询框
	doTemp.setCheckFormat("EfficientDate","3");
	//增加过滤器
	doTemp.setColumnAttribute("Currency,EfficientDate","IsFilter","1");
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
			{"true","","Button","新增","新增汇率信息","newRecord()",sResourcesPath},
			{"true","","Button","详情","汇率查看详情","editRecord()",sResourcesPath}
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
	/*~[Describe=新增;InputParam=后续事件;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/SystemManage/SynthesisManage/ExchangeInfo.jsp","_self","");
	}
	
	/*~[Describe=详情;InputParam=后续事件;OutPutParam=无;]~*/
	function editRecord()
	{
		var sCurrency = getItemValue(0,getRow(),"Currency");
		var sEfficientDate = getItemValue(0,getRow(),"EfficientDate");
		var sEfficientTime = getItemValue(0,getRow(),"EfficientTime");
		OpenPage("/SystemManage/SynthesisManage/ExchangeInfo.jsp?Currency="+sCurrency+"&EfficientDate="+sEfficientDate+"&EfficientTime="+sEfficientTime,"_self","");
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

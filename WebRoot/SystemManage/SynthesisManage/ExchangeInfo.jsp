<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: wwhe 2008-11-28
			Tester:
			Describe: 汇率管理
			Input Param:
			Output Param:
			HistoryLog:
		 */
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "汇率管理信息明细"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量

	//获得组件参数

	//获得页面参数
	String sCurrency = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Currency"));
	String sEfficientDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EfficientDate"));
	String sEfficientTime = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EfficientTime"));
	
	if(sCurrency == null) sCurrency = "";
	if(sEfficientDate == null || "".equals(sEfficientDate)) sEfficientDate = "XX";
	if(sEfficientTime == null || "".equals(sEfficientTime)) sEfficientTime = "XX";
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
			            {"EfficientDate","生效日期"},  
			            {"Price","中间价"},
			            {"Unit","单位"},					        
			            {"Remark","备注"}					        
				  };   		   		
	
	String sSql =  " select ExchangeValue,Currency,"+
		           " Unit,Price,EfficientDate,EfficientTime,Remark"+
		           " from ERATE_INFO "+
		           " where Currency = '"+sCurrency+"' "+
		           " and nvl(EfficientDate,'XX') = '"+sEfficientDate+"'"+
		           " and nvl(EfficientTime,'XX') = '"+sEfficientTime+"'";
             
  	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "ERATE_INFO";
	doTemp.setKey("Currency",true);		
	//设置币种下拉框内容
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px} ");
	//设置字段格式
	//doTemp.setCheckFormat("EfficientDate","3");
	doTemp.setAlign("ExchangeValue,Price,Unit","3");
	doTemp.setType("ExchangeValue,Price,Unit","Number");
	doTemp.setVisible("ExchangeValue,EfficientTime",false);
	doTemp.setReadOnly("ExchangeValue,EfficientTime", true);
	doTemp.setHTMLStyle("Currency,Price,Unit,EfficientDate","onBlur=parent.getExchangeValue()");
	doTemp.setRequired("Currency,Price,Unit,EfficientDate",true);	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //freeform格式
	dwTemp.ReadOnly = "0"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
			};
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			//特殊增加,如果为新增保存,保存后页面刷新一下,防止主键被修改
			as_save("myiframe0");
			return;
		}
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/ExchangeList.jsp","_self","");
	}
	
	//新增自动计算ExchangeValue字段的值  added by ylwang 2009-12-03
	function getExchangeValue(){
		dPrice = getItemValue(0,getRow(),"Price");
		dUnit = getItemValue(0,getRow(),"Unit");
		dExchangeValue = dPrice/dUnit;
		if(isNaN(dExchangeValue))
			dExchangeValue = 0.0;
		setItemValue(0,0,"ExchangeValue",dExchangeValue);
	}
	</script>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"EfficientTime","<%=StringFunction.getNow()%>");
			bIsInsert = true;
		}
	}
	</script>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>
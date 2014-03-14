<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: lzhang 	2011.04.25
			Tester:
			Content:LIBOR利率管理
			Input Param:
					Currency:币种
					InputDate:日期
					RateType:利率类型
			Output param:
			History Log: 
				update by yfliu 2007.9.3

		 */
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "LIBOR利率管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>

<html>
<head>
<title>利率管理</title>
<%
	String sCurrency = DataConvert.toRealString(request.getParameter("Currency"));
	String sInputDate = DataConvert.toRealString(request.getParameter("InputDate"));
	String sRateType = DataConvert.toRealString(request.getParameter("RateType"));

	if(sCurrency 	== null) 	sCurrency = "";
	if(sInputDate 	== null) 	sInputDate ="";
	if(sRateType 	== null) 	sRateType ="";


  	String sHeaders[][] = { 
		                        {"CurrencyName","币种"},
		                        {"Currency","币种"},
			            {"InputDate","生效日期"},  
			            {"RateType","利率类型"},
			            {"RateTypeName","利率类型"},
			            {"Rate","基准利率"}					        
				  };   		   		   		
	
	String sSql;
	
	sSql = " select InputDate,Currency,RateType,getItemName('GJRateType',RateType) as RateTypeName,getItemName('Currency',Currency) as CurrencyName,Rate "+
       	   " from LIBOR_INFO where InputDate = '"+sInputDate+"' and RateType = '"+sRateType+"' and Currency = '"+sCurrency+"' ";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	doTemp.UpdateTable="LIBOR_INFO";
	doTemp.setKey("InputDate,Currency,RateType",true);

	doTemp.setRequired("Currency,InputDate,RateType,Rate",true);
	doTemp.setVisible("RateTypeName,CurrencyName",false);
	doTemp.setCheckFormat("Rate","16");
	doTemp.setCheckFormat("InputDate","3");
	doTemp.setDDDWCode("RateType","GJRateType");
	doTemp.setDDDWSql("RateType","select ItemNo,ItemName from code_library where CodeNo = 'GJRateType' and left(ItemNo,1) in ('Y','Z')");
	doTemp.setDDDWCode("Currency","Currency");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
		String sButtons[][] = 	{
						{"true","","Button","保存","保存信息","finish()",sResourcesPath},
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

<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”
	var sRate = "" , sUpdateUserName ="" ,sUpdateTime ="";
	var sName ="";

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		sRate = getItemValue(0,getRow(),"Rate");
    	sUpdateUserName = "<%=CurUser.UserName%>";
    	sUpdateTime = "<%=StringFunction.getToday()%>";
    	
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"RateIDType","02");
			bIsInsert = true;
		}
    }
	
	function beforeInsert()
	{
       initSerialNo();//初始化流水号字段
	}
	
	function pageReload()
	{
		sAreaNo = getItemValue(0,getRow(),"AreaNo");//--重新获得流水号
		OpenPage("/SystemManage/SynthesisManage/LiborRateChangeInfo.jsp?AreaNo="+sAreaNo+"", "_self","");
	}
	
    //保存的同时把修改人,修改时间,新利率保存到rate_info_log表中
    function finish()
    {
    	var sTableName = "RATE_INFO_LOG";//表名
		var sColumnName = "AreaNo";//字段名
		var sPrefix = "";//前缀
		
    	if(bIsInsert)
    	{
    		beforeInsert();
    	}
   		as_save("myiframe0","");
    }
    
    function goBack()
    {
    	OpenPage("/SystemManage/SynthesisManage/LiborRatechangeList.jsp", "_self","");
    }
    
    /*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "RATE_INFO";//表名
		var sColumnName = "AreaNo";//字段名
		var sPrefix = "";//前缀
       
		//使用GetSerialNo.jsp来抢占一个流水号
		
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: hysun 	2006.10.23
			Tester:
			Content:利率管理
			Input Param:
					Currency:币种
					Type:状态
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
		String PG_TITLE = "汇率管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>

<html>
<head>
<title>利率管理</title>
<%
	String sAreaNo = DataConvert.toRealString(request.getParameter("AreaNo"));
	String sType = DataConvert.toRealString(request.getParameter("Type"));

	if(sAreaNo == null) sAreaNo = "";
	if(sType == null) sType ="";


  	String sHeaders[][] = { 
		                        {"Currency","币种"},
			            {"EfficientDate","生效日期"},  
			            {"RateName","利率名称"},
			            {"RateIDType","利率期限类型"},
			            {"RateType","利率类型"},
			            {"RangeFrom","起始期限月(不含)"},
			            {"RangeTo","截止期限月(含)"},
			            {"Rate","利率"}					        
				  };   		   		   		
	
	String sSql;
	
	sSql = " select AreaNo,Currency,RateName, "+
    	   " RateIDType,RateType,RangeFrom,RangeTo,Rate,EfficientDate" +
       	   " from RATE_INFO where AreaNo = '"+sAreaNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	doTemp.UpdateTable="RATE_INFO";
	doTemp.setKey("AreaNo",true);

	doTemp.setRequired("Currency,EfficientDate,RateName,RateIDType,ratetype,,RangeFrom,RangeTo,Rate",true);
	doTemp.setRequired("Currency,EfficientDate,ExchangeValue",true);
	doTemp.setCheckFormat("ExchangeValue","16");
	doTemp.setCheckFormat("EfficientDate","3");
	doTemp.setVisible("AreaNo",false);
	//doTemp.setReadOnly("RateIDType",true);
	doTemp.setCheckFormat("Rate","16");
	doTemp.setHTMLStyle("RateName"," style={width:300px}");
	//根据币种确定利率类型
	doTemp.appendHTMLStyle("Currency", "onBlur = \"javascript:parent.getRatetype()\" ");
	//sFlag为1时表示新增,为2表示修改/详情
	if( sType.equals("Read") )
	{	
		doTemp.setReadOnly("Currency,RateName,RateType,RangeFrom,RangeTo",true);
	}
	
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setDDDWCode("RateType","SystemRateType");
	doTemp.setDDDWCode("RateIDType","RateType");
	
	
	
	
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
    
    function getRatetype()
    {
   		var sCurrency = getItemValue(0,getRow(),"Currency");
   		if(sCurrency == "01")
   		{
   			setItemValue(0,getRow(),"ratetype","");
   		}else
   		{
   			setItemValue(0,getRow(),"ratetype","060");
   		}
   		
    }
	
	function beforeInsert()
	{
       initSerialNo();//初始化流水号字段
	}
	
	function pageReload()
	{
		sAreaNo = getItemValue(0,getRow(),"AreaNo");//--重新获得流水号
		OpenPage("/SystemManage/SynthesisManage/RateChangeInfo.jsp?AreaNo="+sAreaNo+"", "_self","");
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
    	//如果为新增保存,保存后页面刷新一下,防止主键被修改
   		as_save("myiframe0","pageReload()");
   	  	/*
   		sUpdateUserName = "<%=CurUser.UserName%>";
   		sAreaNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
   		sEfficientDate = getItemValue(0,getRow(),"EfficientDate");   		
   		sRateName = getItemValue(0,getRow(),"RateName");
   		sRateType = getItemValue(0,getRow(),"RateType");
   		sRateIDType = getItemValue(0,getRow(),"RateIDType");
   		sCurrency = getItemValue(0,getRow(),"Currency");
   		sRangeFrom = getItemValue(0,getRow(),"RangeFrom");
   		sRangeTo = getItemValue(0,getRow(),"RangeTo");
   		sNewRate = getItemValue(0,getRow(),"Rate");
   		if (typeof(sRate)=="undefined" || sRate.length==0)
   		{
   			sRate = sNewRate ;
   		}
   		RunMethod("BusinessManage","RateChangeRecord",sAreaNo+","+sEfficientDate+","+sRateName+","+sRateType+","+sRateIDType+","+sCurrency+","+sRangeFrom+","+sRangeTo+","+sRate+","+sUpdateUserName+","+sUpdateTime+","+sNewRate);
    	*/
    }
    
    function goBack()
    {
    	OpenPage("/SystemManage/SynthesisManage/RatechangeList.jsp", "_self","");
    }
    
    function getPrice()
    {
    	var sExchangeValue = parseFloat(getItemValue(0,getRow(),"ExchangeValue"));
    	var sPrice = sExchangeValue*100;
    	setItemValue(0,0,"Price",sPrice);
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
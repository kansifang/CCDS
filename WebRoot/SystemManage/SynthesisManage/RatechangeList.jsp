<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:hysun 2006.10.23
			Tester:
			Describe: 利率管理
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
		String PG_TITLE = "利率管理信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
		                        {"CurrencyName","币种"},
			            {"EfficientDate","生效日期"},  
			            {"RateName","利率名称"},
			            {"RateIDTypeName","利率期限类型"},
			            {"RateApplyType","利率类型"},
			            {"RangeFrom","起始期限月(不含)"},
			            {"RangeTo","截止期限月(含)"},
			            {"ExchangeValue","汇率"},
			            {"Rate","月利率"}					        
				  };   		   		
	
	sSql = " select AreaNo,Currency,getItemName('Currency',Currency) as CurrencyName,RateName,RateType,getItemName('SystemRateType',RateType) as RateApplyType, "+
           " RateIDType,getItemName('RateType',RateIDType) as RateIDTypeName,RangeFrom,RangeTo,Rate,EfficientDate" +
           " from RATE_INFO where 1=1 "+
           " order by Currency,RateType,RangeFrom ";
             
  	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "RATE_INFO";
	doTemp.setKey("AreaNo",true);
	doTemp.setVisible("AreaNo,Currency,RateIDType,RateType",false);
	//置字段是否可更新，主要是外部函数产生的，类似UserName\OrgName	    
	doTemp.setUpdateable("CurrencyName",false);
	doTemp.setHTMLStyle("RateName"," style={width:200px}");
	doTemp.setHTMLStyle("RateIDTypeName"," style={width:60px}");
	doTemp.setHTMLStyle("Rate"," style={width:60px}");
	doTemp.setType("Rate","number");
	doTemp.setCheckFormat("Rate","6");
	//生成查询条件
	//增加过滤器
	doTemp.setColumnAttribute("CurrencyName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.setType("Price","Number"); 
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//boolean sFlag1 = CurUser.hasRole("097");
	//out.println("sFlag1 = " + sFlag1);
	
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
		//update "删除"按纽为不可见 by yfliu 2007.8.28
		String sButtons[][] = {
		    {"true","","Button","新增","新增","newRecord()",sResourcesPath},
			{"true","","Button","修改/详情","修改/详情","viewAndEdit()",sResourcesPath},
			{"false","","Button","删除","删除","deleteRecord()",sResourcesPath},
			{"false","","Button","利率修改查询","利率修改查询","rateRecord()",sResourcesPath}
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
	function newRecord()
	{
		OpenPage("/SystemManage/SynthesisManage/RateChangeInfo.jsp", "_self","");
	}
	
	function viewAndEdit()
	{
		sAreaNo      = getItemValue(0,getRow(),"AreaNo");
		
		if (typeof(sAreaNo)=="undefined" || sAreaNo.length==0)		
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{      
			
			OpenPage("/SystemManage/SynthesisManage/RateChangeInfo.jsp?Type=Read&AreaNo="+sAreaNo, "_self","");
		
		}
	}
	
	function deleteRecord()
	{
		sCurrency   = getItemValue(0,getRow(),"Currency");
		if (typeof(sCurrency)=="undefined" || sCurrency.length==0)		
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	function rateRecord()
	{
		popComp("RateChangeRecord","/SystemManage/SynthesisManage/RateChangeRecord.jsp","","","");
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

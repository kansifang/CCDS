<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong  2012/06/19
		Tester:
		Describe: 预警处置选择列表
		Input Param:	
			
		Output Param:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警处置选择列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "预警处置选择列表";//--题头
	String sCustomerType =""; //客户类型 1为公司客户 2为同业客户 3为个人客户 4为信用共同体
	String sActionFlag = "";//操作标识02已完成
	//获得组件参数	
	
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","预警信号流水号"},
							{"CustomerName","客户名称"},
							{"SignalType","预警类型"},
							{"SignalLevel","预警级别"},	
							{"SignalStatus","预警状态"},
							{"CustomerOpenBalance","敞口金额"},									
							{"OperateUserName","登记人"},
							{"OperateOrgName","登记机构"},
							}; 
						
		sSql =	" select RS.SerialNo as SerialNo,"+
				" GetCustomerName(RS.ObjectNo) as CustomerName,"+
				" getItemName('SignalType',RS.SignalType) as SignalType,"+
				" getItemName('SignalLevel',RS.SignalLevel) as SignalLevel,"+
				" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus,"+
				" RS.CustomerOpenBalance as CustomerOpenBalance,"+
				" getUserName(RS.InputUserID) as OperateUserName,"+
				" getOrgName(RS.InputOrgID) as OperateOrgName "+
			" from FLOW_OBJECT FO,RISK_SIGNAL RS "+
			" where  FO.ObjectType =  'RiskSignalApply' "+
				" and  FO.ObjectNo = RS.SerialNo and FO.PhaseType='1040' "+
				" and FO.ApplyType='RiskSignalApply' and RS.SignalType='01' "+
				" and RS.SerialNo not in(select RS1.SerialNo from RISK_SIGNAL RS1,INSPECT_INFO II where II.ObjectNo=RS1.SerialNo  and II.ObjectType='RiskSignalDispose' and ( II.FinishDate ='' or II.FinishDate is null))"+
				" and not exists(select 1 from RISK_SIGNAL RS1 where RS1.RelativeSerialNo=RS.SerialNo and SignalType='02' and SignalStatus='30')"+
				" and RS.InputOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	//客户经理处置自己的预警 080,280,2A5,2D3,2J4,480
	if(CurUser.hasRole("080")||CurUser.hasRole("280")||CurUser.hasRole("2A5")
		||CurUser.hasRole("2D3")||CurUser.hasRole("2J4")||CurUser.hasRole("480"))
	{
		sSql = sSql+" and RS.InputUserID='"+CurUser.UserID+"' ";
	}
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "RISK_SIGNAL";	
	//设置关键字
	doTemp.setKey("SerialNo",true);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("OperateOrgName","style={width:250px} ");
	doTemp.setHTMLStyle("SignalType,SignalLevel,SignalStatus","style={width:60px} "); 	
	//设置对齐方式
	doTemp.setAlign("CustomerOpenBalance","3");
	doTemp.setType("CustomerOpenBalance","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("CustomerOpenBalance","2");
	

	//生成查询框
	//doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","OperateUserName","");
	doTemp.setFilter(Sqlca,"4","OperateOrgName","");
	
	doTemp.parseFilterData(request,iPostChange);
	
	//if("2".equals(sActionFlag))
	//{
	//	if(!doTemp.haveReceivedFilterCriteria())  doTemp.WhereClause+=" and 1=2";
	//}
		
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页 

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
			{"true","","Button","确定","确定","doReturn()",sResourcesPath},
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	function doReturn(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			self.returnValue=sSerialNo;//返回参数
			self.close();
		}
	}
	
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

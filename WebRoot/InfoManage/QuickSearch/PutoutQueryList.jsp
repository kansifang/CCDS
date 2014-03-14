<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   CYHui 2005-1-25
			Tester:
			Content: 合同信息快速查询
			Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：合同信息快速查询
		          
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "放贷信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "";
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	String isPutOutInfoM=CurUser.hasRole("097")?"Yes":"No";//是否放款修改员，是的话放款通过后仍然可以修改出账信息和收款人信息
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//定义表头文件
	String sHeaders[][] = { 							
					{"OperateOrgName","放贷机构"},
					{"PutoutOrgName","放贷机构"},
					{"ContractSerialNo","合同流水号"},
					{"SerialNo","出账流水号"},
					{"CustomerName","客户名称"},										
					{"BusinessTypeName","业务品种"},
					{"BusinessSum","金额"},
					{"Balance","余额"},										
					}; 
	
	sSql =	" select fo.ObjectType,fo.FlowNo,fo.PhaseNo,getOrgName(OperateOrgID) as OperateOrgName,"+
	" getOrgName(getHeaderOrgID(bp.OperateOrgID))||'-'||getOrgName(bp.OperateOrgID) as PutoutOrgName,bp.ContractSerialNo,bp.SerialNo ,"+
	" bp.CustomerName,getBusinessName(bp.BusinessType) as BusinessTypeName,bp.BusinessSum,GetBalanceByPutoutNo(bp.SerialNo) as Balance,bp.ExchangeType"+
	" from business_putout bp,flow_object fo"+
	" where fo.ObjectType='PutOutApply' "+
	" and fo.PhaseNo='1000'"+
	" and fo.ObjectNo=bp.SerialNo"+
	" and "+(isPutOutInfoM.equals("Yes")?"1=1":"bp.OperateOrgID in (select BelongOrgID from ORG_Belong where OrgID = '"+CurOrg.OrgID+"')")+
	" order by bp.SerialNo desc";
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("bp.SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	doTemp.setKey("bp.SerialNo",true);	
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("BusinessRate","style={width:60px} "); 		
	//设置对齐方式
	doTemp.setAlign("BusinessSum,BusinessRate,Balance","3");	
	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum,BailRatio","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setType("BusinessSum,RateFloat,BusinessRate,Balance,TermMonth,BailRatio","Number");
	doTemp.setCheckFormat("BusinessRate","16");
	
	doTemp.setVisible("OperateOrgName,ObjectType,FlowNo,PhaseNo,ExchangeType",false);
	
	//生成查询框
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","OperateOrgName","");		
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
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
			{"true","","Button","详细信息","详细信息","viewTab()",sResourcesPath},
			{"true","","Button","查看意见","查看意见","viewOpinions()",sResourcesPath},
			{"false","","Button","打印电子准贷证","打印电子准贷证","print()",sResourcesPath}
		};
		if(isPutOutInfoM.equals("Yes")){
			sButtons[2][0]="true";
		}
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

	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sIsPOM="<%=isPutOutInfoM%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		if (sIsPOM == "Yes") {
			sParamString += "&ViewID=000"
		}else{
			sParamString += "&ViewID=002"
		}
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得出账类型、出账流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	//added by bllou 2012-03-27 放款修改员可以修改已经被核心引过的出账信息
	/*~[Describe=打印出账通知书;InputParam=无;OutPutParam=无;]~*/
	function print(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		var sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sReturn = PopPage("/FormatDoc/PutOut/"+sExchangeType+".jsp?ObjectNo="+sObjectNo+"&ContractSerialNo="+sContractSerialNo,"","");	
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

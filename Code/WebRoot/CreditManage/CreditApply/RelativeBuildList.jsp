<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 2009-8-10 lpzhang
		Tester:
		Describe: 新增/引入房地产开发协议
		Input Param:
				ObjectType：对象类型（CreditApply）
				ObjectNo: 对象编号（申请流水号）
		Output Param:
				
		HistoryLog:				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增/引入房地产开发协议"; // 浏览器窗口标题 
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	//获得组件参数：对象类型、对象编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//显示标题				
	String[][] sHeaders = {		
							{"SerialNo","协议流水号"},              	
							{"CustomerName","开发商名称"},              
							{"ProjectName","按揭项目名称"},            
							{"Currency","币种"},                    
							{"LoanSum","按揭总额度金额"},           	
							{"PutOutDate","协议签署日期"},            	
							{"Maturity","协议到期日期"},           	
							{"InputUserName","登记人"},                  
							{"InputOrgName","登记机构"},                
							{"InputDate","登记日期"},                
							{"UpdateDate","更新日期"},    
						 };

	sSql =  " select SerialNo,CustomerName,ProjectName,LoanSum,"+
		    " getItemName('Currency',Currency) as Currency,PutOutDate,Maturity, "+
			" getUserName(InputUserID) as InputUserName,UpdateDate "+
			" from Ent_Agreement EA where EA.AgreementType = 'BuildAgreement'"+
		    " and EXISTS (select 1 from Apply_Relative AR where AR.ObjectType='BuildAgreement'"+
		    "            and  AR.SerialNo= '"+sObjectNo+"' and AR.ObjectNo =EA.SerialNo )";
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="Ent_Agreement";
	doTemp.setKey("SerialNo",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("Currency","2");
	
	doTemp.setType("LoanSum","Number");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency"," style={width:80px} ");
	
	//设置Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","引入","引入担保合同信息","importRecord()",sResourcesPath},
		{"true","","Button","详情","查看担保合同信息详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除担保合同信息","deleteRecord()",sResourcesPath},
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
		sObjectNo = "<%=sObjectNo%>";
		OpenComp("BuildAgreementInfo","/CreditManage/CreditLine/BuildAgreementInfo.jsp","ObjectNo="+sObjectNo,"_blank",OpenStyle)
		reloadSelf();
	}

	/*~[Describe=引入记录;InputParam=无;OutPutParam=无;]~*/
	function importRecord()
	{
	    //传入当前的条件即可
	    sParaString = "ObjectType"+",BuildAgreement"+","+"CurDate"+",<%=StringFunction.getToday()%>";		
		sReturn = selectObjectValue("SelectEntAgreement",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || sReturn=="_CLEAR_" || typeof(sReturn)=="undefined") return;
		sReturn= sReturn.split('@');
		sSerialNo = sReturn[0];
		//是否已经引入
		iCount = RunMethod("BusinessManage","CheckRelative","BuildAgreement,"+sSerialNo+",<%=sObjectNo%>");
		if(iCount>0)
		{
			alert("该协议已经引入，无需再次引入!");
			return;
		}
		sReturn=RunMethod("BusinessManage","InsertApplyRelative","BuildAgreement,"+sSerialNo+",<%=sObjectNo%>");
		alert("引入楼宇按揭协议成功！");
		reloadSelf();
		
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			sReturn=RunMethod("BusinessManage","DeleteApplyRelative","BuildAgreement,"+sSerialNo);
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			OpenComp("BuildAgreementInfo","/CreditManage/CreditLine/BuildAgreementInfo.jsp","ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo,"_blank",OpenStyle)
			//OpenPage("/CreditManage/CreditLine/BuildAgreementInfo.jsp?ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo,"right");
		}
	}

    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
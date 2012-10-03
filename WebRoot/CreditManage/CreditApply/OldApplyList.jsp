<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: wangdw 2012-3-21
		Tester:
		Describe: 显示变更原申请信息;
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
	String PG_TITLE = "原申请信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sRTableName = "";
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
	//根据sObjectType的不同，得到不同的关联表名和模版名
	sSql = " select RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
	sRTableName = Sqlca.getString(sSql);
	
	String sHeaders[][] = {
							{"SerialNo","申请编号"},
							{"CustomerID","客户编号"},							
							{"CustomerName","客户名称"},
							{"OccurTypeName","发生类型"},	
							{"BusinessTypeName","业务品种"},
							{"BusinessSum","金额"},
							{"OPERATEUSERNAME","经办人"},
							{"OPERATEORGNAME","经办机构"},
						  };

	sSql =  " select B.SerialNo,B.CustomerID,B.CustomerName,  "+
			" getItemName('OccurType',B.OccurType) as OccurTypeName, "+
			" getBusinessName(B.BusinessType) as BusinessTypeName,B.BusinessType,"+
			" B.BusinessSum,getUserName(B.OPERATEUSERID) as OPERATEUSERNAME,getOrgName(B.OPERATEORGID) as OPERATEORGNAME "+
			" from BUSINESS_APPLY as B ,"+sRTableName+" R "+
			" where "+
			" R.ObjectType='ApplyChange'"+
			" and R.objectno=b.serialno  "+
			" and R.serialno='"+sObjectNo+"'";
	System.out.println("sql======<><><><>"+sSql);
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("ObjectNo,ObjectType,RELATIVESERIALNO,BusinessType",false);
	doTemp.setUpdateable("GuarantyTypeName,GuarantyCurrency,InputUserName,InputOrgName",false);
	//设置格式
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setCheckFormat("GuarantyValue","2");
	doTemp.setHTMLStyle("GuarantyTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:180px} ");
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	//组织进行合计用参数 add by lpzhang 2010-1-21 
	String[][] sListSumHeaders = {{"GuarantyValue","担保金额"},
								  {"GuarantyCurrency","币种"}
								 };
	String sListSumSql = "Select getItemName('Currency',GC.GuarantyCurrency) as GuarantyCurrency,Sum(GC.GuarantyValue) as GuarantyValue from GUARANTY_CONTRACT GC "+doTemp.WhereClause +" group by  GuarantyCurrency";
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);
	
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
			{"true","","Button","申请详情","申请详情","viewTab()",sResourcesPath},
			{"true","","Button","查看调查报告","查看调查报告","viewReport()",sResourcesPath},
			{"true","","Button","查看审查报告","查看审查报告","viewCreateApproveReport()",sResourcesPath},
			{"true","","Button","查看批复报告","查看批复报告","viewApproveApproval()",sResourcesPath},
			
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List06;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			sReturn=RunMethod("BusinessManage","DeleteGuarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
			if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED") 
			{
				alert(getHtmlMessage('7'));//信息删除成功！
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('8'));//对不起，删除信息失败！
				return;
			}
		}
	}


	/*~[Describe=查看担保客户详情详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0)
				alert(getBusinessMessage('413'));//系统中不存在担保人的客户基本信息，不能查看！
			else
				openObject("Customer",sCustomerID,"002");
		}
	}


	/*~[Describe=金额汇总;InputParam=无;OutPutParam=无;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

	}
	/*~[Describe=查看申请详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sObjectType="CreditApply";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	/*~[Describe=查看调查报告;InputParam=无;OutPutParam=无;]~*/
	function viewReport()
	{
		//获得申请类型、申请流水号
		sObjectType = "CreditApply";
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sObjectNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm("是否查看系统生成的调查报告，点击“确定”查看！点击“取消”查看上传的调查报告！")){
			var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (typeof(sDocID)=="undefined" || sDocID.length==0)
			{
				alert(getBusinessMessage('505'));//调查报告还未填写，请先填写调查报告再查看！
				return;
			}
			sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
			if (sReturn == "false")
			{
				createReport();
				return;  
			}else
			{
				 if((sPhaseNo=="0010"||sPhaseNo=="3000")&&confirm(getBusinessMessage('503')))//调查报告有可能更改，是否生成调查报告后再查看！
				{
					createReport();
					return; 
				}else
				{				
					var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
					OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
				}
			}
		}
		else{
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}	
	}	
	/*~[Describe=查看授信业务批复报告;InputParam=无;OutPutParam=无;]~*/
	function viewApproveApproval()
	{	
	    //获得申请类型、申请流水号
		var sObjectType = "ApproveApproval";
		var sObjectNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	    
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+","+sObjectType);
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			alert("该业务无批复信息！");
			return;
		}else{
		    //判断是否提交
			var sColName = "FinishApproveUserID";
			var sTableName = "BUSINESS_APPLY";
			var sWhereClause = "String@SerialNo@"+sObjectNo;
		    sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('@');
				if(sReturn[1]=="null")
				{
					alert("批复未通过！");
					return;
				}
			}
			var sCompID = "PurposeInspectTab";
			var sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			var sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true&viewPrint=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		return true;
	}
	
	/*~[Describe=信审会委员查看审查报告;InputParam=无;OutPutParam=无;]~*/
	function viewCreateApproveReport()
	{
		sObjectType = "";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sObjectType = "CreditApply";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
	}	
		/*~[Describe=生成风险分类认定报告;InputParam=无;OutPutParam=无;]~*/
	function createReport()
	{
		//获得申请类型、申请流水号、客户编号
		sObjectType = "CreditApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert(getBusinessMessage('505'));//调查报告还未填写，请先填写调查报告再查看！
			return;
		}	
		var sAttribute = PopPage("/FormatDoc/DefaultPrint/GetAttributeAction.jsp?DocID="+sDocID,"","");
		
		if (confirm(getBusinessMessage('504'))) //是否要增加打印内容,如果是请点击确定按钮！
		{
			var sAttribute1 = PopPage("/Common/WorkFlow/DefaultPrintSelect.jsp?DocID="+sDocID+"&rand="+randomNumber(),"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
			if (typeof(sAttribute1)=="undefined" || sAttribute1.length==0)
				return;
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute1,"_blank02",CurOpenStyle); 
		}
		else
		{
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute,"_blank02",CurOpenStyle); 
		}
	}	
	
    
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
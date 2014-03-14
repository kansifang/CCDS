<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: lkzou 2010-10-28
			Tester:
			Describe: 贷款申请受理查询页面;
			Input Param:

			Output Param:
		
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "贷款申请受理查询页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//设置列表标题
	String sHeaders[][] = {
					{"CustomerName","客户名称"},
					{"SerialNo","借据号"},
					{"ArtificialNo","合同编号"},
					{"AcceptTime","受理时间"},
					{"DistributeTime","分配时间"},
					{"InvestigateTime","调查时间"},
					{"CheckTime","审查时间"},
					{"ApproveTime","审批时间"},
					{"PutOutDate","放款日期"},
					{"Days","办理天数"}
				  };

	String sSql =   " select CA.SerialNo as AcceptSerialNo,BD.CustomerName,BD.SerialNo,BC.ArtificialNo,"+
			" #AcceptTime as AcceptTime,"+//受理时间
			" #DistributeTime as DistributeTime,"+//分配时间
			" #InvestigateTime as InvestigateTime,"+//调查时间
			" #CheckTime as CheckTime,"+//审查时间
			" #ApproveTime as ApproveTime,"+//审批时间
			" BD.PutOutDate,"+//放款日期
			" (days(date(replace(BD.PutOutDate,#A,#B)))-days(date(replace(#AcceptTime,#A,#B)))) as Days"+//办理天数
			" from Business_Duebill BD,Business_Contract BC,Business_Approve BAP,Approve_Relative AR,Credit_Accept CA"+
			" where BD.RelativeSerialNo2=BC.SerialNo"+
			" and BC.RelativeSerialNo=BAP.SerialNo"+
			" and BAP.SerialNo=AR.SerialNo"+
			" and AR.ObjectType='AcceptSource'"+
			" and AR.ObjectNo=CA.SerialNo"+
			" order by BD.SerialNo desc ";
	
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("AcceptSerialNo,SerialNo,CustomerType,Status,Representative,InputUserID,InputOrgID,InputOrgName,InputDate",false);
	doTemp.setCheckFormat("PutOutDate","3");

    //设置查询框
    
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","PutOutDate","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//生成DW
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页
	//受理时间
	String sTempS=" (select substr(CAT1.BeginTime,1,10) from Credit_Accept_Track CAT1 "+
			" where CAT1.AcceptSerialNo=CA.SerialNo and CAT1.SerialNo=(select Max(SerialNo) from Credit_Accept_Track CAT2 "+
			"  where CAT2.AcceptSerialNo=CAT1.AcceptSerialNo and CAT2.Status ='1'))";
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#AcceptTime",sTempS);
	//分配时间
	sTempS=" (select substr(CAT1.BeginTime,1,10) from Credit_Accept_Track CAT1 "+
	" 		where CAT1.AcceptSerialNo=CA.SerialNo and CAT1.SerialNo=(select Max(SerialNo) from Credit_Accept_Track CAT2 "+
	" where CAT2.AcceptSerialNo=CAT1.AcceptSerialNo and CAT2.Status ='2'))";

	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#DistributeTime",sTempS);
	//调查时间
	sTempS=" (select substr(BeginTime,1,10) from Credit_Accept_Track where AcceptSerialNo=CA.SerialNo and Status ='6')";
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#InvestigateTime",sTempS);
	//审查时间
	sTempS=" (select substr(FT1.EndTime,1,10) from Flow_Task FT1 "+
	" where SerialNo=(select Max(SerialNo) from Flow_Task FT2 "+
	"  where FT2.ObjectType=FT1.ObjectType and FT2.ObjectNo=FT1.ObjectNo"+
	" 	and FT2.ObjectType='CreditApply' and FT2.ObjectNo=BAP.RelativeSerialNo and FT2.PhaseNo in('0010','3000')))";
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#CheckTime",sTempS);
	//审批时间
	sTempS=" (select substr(FT1.BeginTime,1,10) from Flow_Task FT1,Flow_Task FT2 "+
	" where FT1.ObjectType=FT2.ObjectType and FT1.ObjectNo=FT2.ObjectNo and FT1.SerialNo=FT2.RelativeSerialNo"+
	" and FT2.ObjectType='CreditApply' and FT2.ObjectNo=BAP.RelativeSerialNo and FT2.PhaseNo='1000')";
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#ApproveTime",sTempS);
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#A","'/'");
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#B","'-'");
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
			{"true","","Button","受理详情","查看/修改受理详情","viewAndEdit()",sResourcesPath},
			{"false","","Button","查看贷款申请表","查看贷款申请表","viewApplyTable()",sResourcesPath},
			{"false","","Button","时效跟踪","时效跟踪","followTime()",sResourcesPath},
			{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
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
    /*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteApply()
	{			
		var sSerialNo = getItemValue(0,getRow(),"AcceptSerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo= getItemValue(0,getRow(),"AcceptSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		else
		{
			var sStatus = "6";
	    	OpenComp("AcceptView","/BusinessManage/AcceptManage/AcceptView.jsp","SerialNo="+sSerialNo+"&Status="+sStatus,"_blank",OpenStyle);
		reloadSelf();		
		}
	}
	
	/*~[Describe=查看/打印贷款申请书;InputParam=无;OutPutParam=无;]~*/
	function viewApplyTable(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
		sDocID = "L003";
		if(sCustomerType=="01"){
		sDocID = "L001";
		}
		PopPage("/BusinessManage/AcceptManage/"+sDocID+".jsp?DocID="+sDocID+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		//获得加密后的业务受理流水号
		sEncryptSerialNo = PopPage("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sSerialNo+"&rand="+randomNumber(),"myprint10","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		//打开贷款申请通知单
		window.open("<%=sWebRootPath%>/FormatDoc/WorkDoc/"+sEncryptSerialNo+".html","_blank",OpenStyle,true);
	}	
	
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	
	/*~[Describe=时效跟踪;InputParam=无;OutPutParam=无;]~*/
	function followTime(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		PopPage("/BusinessManage/AcceptManage/FT001.jsp?DocID=FT001&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		//获得加密后的业务受理流水号
		sEncryptSerialNo = PopPage("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sSerialNo+"&rand="+randomNumber(),"myprint10","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		//打开时效跟踪表
		window.open("<%=sWebRootPath%>/FormatDoc/WorkDoc/"+sEncryptSerialNo+".html","_blank",OpenStyle,true);
	}	
	</script>
<%
	/*~END~*/
%>



<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>

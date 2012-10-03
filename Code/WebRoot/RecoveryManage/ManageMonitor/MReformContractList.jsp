<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/12/08
*	Tester:
*	Describe: 管理监控重组贷款合同信息列表
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "重组贷款合同信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%
	//定义变量	    
	String sSql = "";
	//定义变量：SQL语句,查询结果集,机构直属、区县标志
	String sSql1 = "";
	ASResultSet rs1 = null;
	String sOrgFlag = "",sReportType = "";
	//获得组件参数
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";
	//获得页面参数
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义标题
	String sHeaders[][] = {
							{"SerialNo","合同流水号"},
							{"OccurTypeName","发生类型"},
							{"CustomerName","客户名称"},
							{"VouchTypeName","主要担保方式"},
							{"BusinessSum","合同金额"},
							{"ReformTypeName","重组方式"},
							{"NewBusinessSum","新增授信金额"}
						}; 

 	sSql = " select BC.SerialNo as SerialNo," + 	
		   " getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
		   " BC.CustomerID as CustomerID,BC.CustomerName as CustomerName," + 
		   " getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
		   " BC.BusinessSum as BusinessSum,getItemName('ReformType',RI.ApplyType) as ReformTypeName,"+
		   " RI.NewBusinessSum as NewBusinessSum "+
		   " from BUSINESS_CONTRACT BC,CONTRACT_RELATIVE CR,REFORM_INFO RI "+
		   " where BC.SerialNo=CR.SerialNo and CR.ObjectNo=RI.SerialNo "+
		   " and CR.ObjectType='CapitalReform' ";
		   
	//根据树图取不同结果集	 
	if(sDealType.equals("070010"))//观察期重组贷款监控管理未监控
	{
		sSql+=" and (BC.ClassifyResult is null or BC.ClassifyResult='') "+
			" and days(replace(BC.PutOutDate,'/','-'))<=days(current date)-90 "+
			" and BC.OccurType='030' and (BC.FinishDate is  null or BC.FinishDate ='') "+
			" and not exists(select 1 from MONITOR_REPORT where ObjectNo=BC.SerialNo"+
			" and ReportType='030' and FinishDate is not null and FinishDate !=''  )";
	}else if(sDealType.equals("070020"))//观察期重组贷款监控管理未提交分类认定
	{
		sSql+=" and days(replace(BC.PutOutDate,'/','-'))<=days(current date)-180 and "+
			" (BC.ClassifyResult is null or BC.ClassifyResult='') and BC.OccurType='030' "+
			" and (BC.FinishDate is  null or BC.FinishDate ='') ";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	//设置共用格式
	doTemp.setVisible("CustomerID",false);
	//doTemp.setKeyFilter("SerialNo");		
    
	//设置行宽
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessSum,NewBusinessSum"," style={width:95px} ");

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,NewBusinessSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,NewBusinessSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,NewBusinessSum","3");
	doTemp.setAlign("OccurTypeName","2");
	
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,SerialNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(20); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","重组监控报告","重组监控报告","Reform_Report()",sResourcesPath},
		{"false","","Button","台帐详情","台帐详情","account_Vindicate()",sResourcesPath},
		{"true","","Button","客户详情","客户详情","customer_Info()",sResourcesPath},
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		{"false","","Button","分类认定详情","分类认定详情","classify_Info()",sResourcesPath},
		{"false","","Button","完成监控","完成监控","monitor_Complete()",sResourcesPath},
		{"false","","Button","提交分类认定","提交分类认定","classify_Refer()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","export_Excel()",sResourcesPath}
		};
	//根据不同树图显示按钮
	
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=重点监控报告;InputParam=无;OutPutParam=无;]~*/    
	function Reform_Report()
	{
		//获得还款流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			popComp("ReformReportList","/RecoveryManage/NPAManage/NPADailyManage/ReformReportList.jsp","ComponentName=重组监控报告列表&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
	}
	
	/*~[Describe=台帐信息维护;InputParam=无;OutPutParam=无;]~*/
	function account_Vindicate()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/AccountVindicateInfo.jsp?SerialNo="+sSerialNo+"&DealType=<%=sDealType%>&ViewType=ReformContract","_self",""); 
		}
	}
	
	/*~[Describe=完成监控;InputParam=无;OutPutParam=无;]~*/   
	function monitor_Complete()
	{
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			sReturn=RunMethod("PublicMethod","GetColValue","count(SerialNo),MONITOR_REPORT,String@ObjectNo@"+sSerialNo+"@String@ReportType@030");
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null" || sReturnInfo[1]=="0") 
			{	
				alert("请进行重组监控后再点击!");
				return;
			}else
			{
				//完成监控
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@FinishDate@<%=StringFunction.getToday()%>,MONITOR_REPORT,String@ObjectNo@"+sSerialNo+"@String@ReportType@030");
				if(sReturnValue == "TRUE")
				{
					alert(getHtmlMessage('71'));//操作成功
					self.location.reload();
				}else
				{
					alert(getHtmlMessage('72'));//操作失败
				}
			}
		}
	}
	
	/*~[Describe=查看客户详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function customer_Info()
	{
		//获得客户编号
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");
		}

	}
	
	/*~[Describe=风险分类详情;InputParam=无;OutPutParam=无;]~*/
	function classify_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			sCompID = "ClassifyHistoryList";
			sCompURL = "/CreditManage/CreditPutOut/ClassifyHistoryList.jsp";
			sParamString = "ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=提交分类认定;InputParam=无;OutPutParam=无;]~*/
	function classify_Refer()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenComp("ClassifyApplyMain","/Common/WorkFlow/ApplyMain.jsp","ComponentName=风险分类&ComponentType=MainWindow&ApplyType=ClassifyApply","","")
		}
	}
	
	/*~[Describe=导出Excel;InputParam=无;OutPutParam=无;]~*/
	function export_Excel()
	{
		amarExport("myiframe0");
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

<%@include file="/IncludeEnd.jsp"%>
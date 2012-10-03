<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.12      
		Tester:	
		Content: 新会计准则——审计结果确认
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "审计结果确认"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//存放 sql语句
	String sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	if(sAction==null) sAction="";
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sType==null) sType="";
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));
	if(sGrade==null) sGrade="";
	String sCondition1 = "";
	String sRightCondi = "";
	String sEqualRightCondi = "";//用于权限条件的参数传递
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//获取关联客户信息表数据	
	String sHeaders[][] = {
				 {"SerialNo","序号"},
	             {"AccountMonth","会计月份"},
				 {"LoanAccount","借据号"},
//				 {"ObjectNo","借据号"},
				 {"CustomerName","客户名称"},
				 {"Balance","贷款余额"},
				 {"PutoutDate","发放日"},
				 {"MaturityDate","到期日"},
				 {"AuditRate","实际利率(‰)"},
//				 {"VouchType","主要担保方式"},
//				 {"VouchTypeName","主要担保方式"},
				 {"MClassifyResultName","五级分类"},
				 {"MClassifyResult","五级分类"},
//				 {"AClassifyResultName","审计五级分类"},
//				 {"AClassifyResult","审计五级分类"},
				 {"Result1","管户员测算结果"},
				 {"Result2","支行认定结果"},
				 {"Result3","分行认定结果"},
				 {"Result4","总行认定结果"},
//				 {"AResult","审计认定结果"}
				 {"ManageOrgID","所属机构"}
			};
    sSql = " select  RR.SerialNo,RR.AccountMonth,RR.LoanAccount,RR.ObjectNo,RR.CustomerName,RR.Balance,RR.PutoutDate,RR.MaturityDate,RR.AuditRate, " +
    	   " getItemName('MFiveClassify',RR.MClassifyResult) as MClassifyResultName,RR.Result1,RR.Result2,RR.Result3,RR.Result4,RR.ManageOrgID " +
	       " from Reserve_Record RR ,Reserve_Total RT " +
	       " where RR.LoanAccount = RT.LoanAccount and RR.AccountMonth = RT. AccountMonth and RR.BusinessFlag = '1'  and RT.AuditStatFlag = '1'";
     if(sAction.equals("Finished") && sType.equals("Audit")){
		 	sRightCondi = " and (RR.MFinishdate is null and RR.UserID4 is not null)";
	 }
	sSql = sSql + sRightCondi;         

    sSql = sSql + " order by ObjectNo desc";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Record";
    doTemp.setKey("SerialNo,AccountMonth,ObjectNo",true);
    doTemp.setVisible("ObjectNo,SerialNo,ObjectNo,ManageOrgID",false);
 //   doTemp.setColumnAttribute("AccountMonth,CustomerName,ObjectNo","IsFilter","1");
	//doTemp.setCheckFormat("AccountMonth","6");
	doTemp.generateFilters(Sqlca);
 	doTemp.setFilter(Sqlca,"1","AccountMonth","Operators=EqualsString");
 	doTemp.setFilter(Sqlca,"2","CUstomerName","Operators=BeginsWith");
 	doTemp.setFilter(Sqlca,"3","LoanAccount","Operators=BeginsWith");
 	doTemp.setFilter(Sqlca,"4","ManageOrgID","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//设置在datawindows中显示的行数
	dwTemp.setPageSize(20); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "1"; 
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("LoanAccount");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //调试datawindow的Sql常用方法
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
		//6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"true","","Button","审计损失识别","审计损失识别","lossManage()",sResourcesPath},
			{"true","","Button","审计预测现金流","审计预测现金流","my_Input()",sResourcesPath},
			{"false","","Button","单笔撤销","单笔撤销","my_SingleCancel()",sResourcesPath},
			{"false","","Button","批量撤销","批量撤销","my_Cancel()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	function lossManage()
	{
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		if(typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0)
		{
			alert("请选择一条信息");
			return;
		}
		PopComp("ReserveLossView","/BusinessManage/ReserveManage/ReserveLossView.jsp","AccountMonth="+sAccountMonth+"&ObjectNo="+sObjectNo+"&CustomerName="+sCustomerName,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
	}
	
	function my_Input()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sMClassifyResult = getItemValue(0,getRow(),"MClassifyResult");
		sAClassifyResult = getItemValue(0,getRow(),"AClassifyResult");
		if(typeof(sLoanAccount) == "undefined" || sLoanAccount==""){
			 alert("请选择一条信息");
		     return;
		}
 		PopComp("CashPredictView","/BusinessManage/ReserveManage/CashPredictView.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&SerialNo="+sSerialNo+"&Grade=<%=sGrade%>","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
 		reloadSelf();
	}
	
	//单笔撤销业务
	function my_SingleCancel()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择一条借据信息！");
		}else
	    {
		
			if(confirm("确定将所选记录撤销回上一级吗？"))//确定信息补充完成吗？
			{
				
				sReturn=PopComp("singleCanclePredictAction","/BusinessManage/ReserveManage/singleCanclePredictAction.jsp","SerialNo="+sSerialNo+"&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if (sReturn=="00")
				{
					alert("撤销成功");
				}else
				{
					alert("撤销失败");
				}
				reloadSelf();
			}
		}
	}
	
	//全部撤销
	function my_Cancel()
	{
		var sReturn="";
		iCount=getRowCount(0);
		var sReturn="";
		if (iCount>0)
		{
			if (confirm("确定将下列记录撤销吗？"))//确定信息补充完成吗？
			{
				var sCondition="<%=sCondition1%>";
			 	sReturn=PopComp("CancelCashPredictAction","/BusinessManage/ReserveManage/CancelCashPredictAction.jsp","Type=<%=sType%>&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if (sReturn=="00")
				{
					alert("撤销成功");
				}else
				{
					alert("撤销失败");
				}
				reloadSelf();
			}
		}else 
		{
 			alert("没有需要撤销的记录");
 		}
	}
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	
	function filterAction(sObjectID,sFilterID,sObjectID2){
		oMyObj = document.all(sObjectID);
		oMyObj2 = document.all(sObjectID2);
		if(sFilterID=="1"){
		
		}else if(sFilterID=="4"){
			//弹出模态窗口选择框，并将返回值赋给sReturn
			sReturn = selectObjectInfo("Code","CodeNo=OrgInfo^请选择管户机构^","");
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_"){
				return;
			}else if(sReturn=="_CLEAR_"){
				oMyObj.value="";
				oMyObj2.value="";
			}else{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				oMyObj2.value=sReturns[1];
			}
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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.08      
		Tester:	
		Content: 新会计准则——预测现金流
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预测现金流"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,参数)它会自动适应window_open
	//获得阶段类型、页面标志、合同类型和完成标志
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth == null) sAccountMonth = "";
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	if(sLoanAccount == null) sLoanAccount = "";
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));
	if(sGrade == null) sGrade = "";
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sMFiveClassify = "", sAFiveClassify="", sBusinessRate="", sObjectNo = "";
	String month = StringFunction.getToday();
	month = month.substring(0,7);
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
				 {"AccountMonth","会计月份"},
	             {"ReturnDate","预计收回日期"},
	             {"LoanAccount","借据号"},
	             {"Grade","预测级别"},
	             {"PredictCapital","预计现金流-本金（元）"},
				 {"PredictInterest","预计现金流-利息（元）"},
				 {"Reason","现金流预测理由"},
				 {"GuarantyValue","预处置抵押品价值（元）"},
				 {"GuarantyReason","抵押品处置理由"},
				 {"EnsureValue","预计可收回的保证金额（元）"},
				 {"EnsureReason","保证金额理由"},
				 {"DueSum","合计金额（元）"},
				 {"Discount","折现率"},
				 {"DiscountValue","折现值（元）"}
	      };

	//获取管理类五级分类结果和审计类五级分类结果
	String stemp = "select MFiveClassify, AFiveClassify, BusinessRate from Reserve_total where LoanAccount = '"+sLoanAccount+"' and AccountMonth = '" + sAccountMonth + "'";
	ASResultSet rsTemp = Sqlca.getASResultSet(stemp);
	if(rsTemp.next()){
	    sMFiveClassify = rsTemp.getString("MFiveClassify") == null ? "" : rsTemp.getString("MFiveClassify");
	    sAFiveClassify = rsTemp.getString("AFiveClassify") == null ? "" : rsTemp.getString("AFiveClassify");
	    sBusinessRate = rsTemp.getString("BusinessRate") == null ? "0.0" : rsTemp.getString("BusinessRate");
	}
	rsTemp.getStatement().close();
	
	String sSql =  " select AccountMonth, ReturnDate, LoanAccount,Grade, PredictCapital , PredictInterest, Reason, "+
			   " GuarantyValue,GuarantyReason,EnsureValue, EnsureReason, DueSum, Discount, DiscountValue "+
     		   " from reserve_predictdata "+
     		   " where LoanAccount='"+sLoanAccount+"'" +
     		   " and AccountMonth='"+ sAccountMonth +"'"+ //add by ycsun 2008/11/08
     		   " and Grade ='" + sGrade + "'";
     
 	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "reserve_predictdata";
	
	//设置数据表名和主键
	doTemp.setKey("LoanAccount,AccountMonth",true);
	doTemp.setType("PredictCapital,PredictInterest,GuarantyValue,DiscountValue,DueSum,EnsureValue","Number");
	doTemp.setVisible("LoanAccount,AccountMonth,Grade,Reason,GuarantyReason,EnsureReason",false);
	doTemp.setHTMLStyle("ReturnDate,DueSum,Discount,DiscountValue","style={width:100px}");
    //置html格式
	doTemp.setHTMLStyle("Reason,GuarantyReason,EnsureReason"," style={width:150px}");
       
	//生成ASDataWindow对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);

	//设置为Grid风格
	dwTemp.Style="1";
	
	//设置为只读
	dwTemp.ReadOnly = "1";
	//生成HTMLDataWindow
	
	Vector vTemp = dwTemp.genHTMLDataWindow("LoanAccount");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//session.setAttribute(dwTemp.Name,dwTemp);
	
	
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
			{"true","","Button","新增","新增记录","my_Add()",sResourcesPath},
			{"true","","Button","查看详情","查看/修改详情","my_ViewEdit()",sResourcesPath},
			{"true","","Button","删除","删除记录","my_Del()",sResourcesPath},
			{"true","","Button","预测完成","预测完成","my_Confirm()",sResourcesPath},
			{"false","","Button","查看附件","查看附件","my_View()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>
<script language=javascript>
	
  	//双击某笔申请直接链接到业务信息详情页面
	function my_Add()
	{
		//modify by ycsun 2008/11/08 修改传入参数
		PopComp("CashPredictInfo","/BusinessManage/ReserveManage/CashPredictInfo.jsp","AccountMonth=<%=sAccountMonth%>"+"&LoanAccount=<%=sLoanAccount%>"+"&SerialNo=<%=sSerialNo%>"+"&Grade=<%=sGrade%>"+"&BusinessRate=<%=sBusinessRate%>","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}

	
	//查看合同信息详情
    function my_ViewEdit()
	{
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sReturnDate = getItemValue(0,getRow(),"ReturnDate");
		sGrade = getItemValue(0,getRow(),"Grade");
       	if (typeof(sLoanAccount) == "undefined" || sLoanAccount.length == 0)
		{
			alert(getHtmlMessage(1));
			return;
		}
		PopComp("CashPredictInfo","/BusinessManage/ReserveManage/CashPredictInfo.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&ReturnDate="+sReturnDate+"&Grade="+sGrade+"&SerialNo=<%=sSerialNo%>","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	//更新预测现金流到列表页面
	function my_Confirm(){
		sGrade = "<%=sGrade%>";
	    sAFiveClassify = "<%=sAFiveClassify%>";
	    sMFiveClassify = "<%=sMFiveClassify%>";
	    sSerialNo = "<%=sSerialNo%>";
	    //modify by ycsun 2008/11/13 模态窗口不弹出对话框
//	    sReturn = PopPage("/BusinessManage/ReserveManage/CheckAttachAction.jsp?ObjectNo="+sSerialNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
// 		if(sReturn == "01"){
//	           	alert("没有附件，请先上传附件！");
//	          	return;
//	    }
	    if(sAFiveClassify == "05" && sMFiveClassify == "05" ){//12-损失
	       alert("损失类贷款，不需要确认");
	       return;
	    }
	    iCount=getRowCount(0);
	    if(iCount == 0){
	       alert("请先预测现金流");
	       return;
	    }
		sLoanAccount= "<%=sLoanAccount%>";
		sAccountMonth = "<%=sAccountMonth%>";
		//modify by ycsun 2008/11/13 模态窗口不弹出对话框
	    sReturn = PopPage("/BusinessManage/ReserveManage/UpdateCashPredictAction.jsp?LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth+"&Grade="+sGrade,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
	    reloadSelf();
        if(sReturn == "00"){
           alert("预测成功");
        }
        if(sReturn != "00"){
           alert("预测失败");
        }
        //opener.opener.location.reload();
 	}
 	
 	//删除记录
 	function my_Del(){
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sReturnDate = getItemValue(0,getRow(),"ReturnDate");
		sGrade = getItemValue(0,getRow(),"Grade");
       	if (typeof(sReturnDate) == "undefined" || sReturnDate.length == 0)
		{
			alert(getHtmlMessage(1));
			return;
		}
		else
		{
			if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
			{
        		RunMethod("新会计准则","deletePredictData",sLoanAccount+","+sAccountMonth+","+sReturnDate+","+sGrade);
    		}
		}
		reloadSelf();
 	}
	function my_View(){
		sSerialNo = "<%=sSerialNo%>"; 
		if(typeof(sSerialNo) == "undefined" || sSerialNo==""){
			 alert("请选择一条查看信息");
		   return;
		}
        PopComp("AttachmentList1","/BusinessManage/ReserveManage/AttachmentList.jsp","ObjectNo="+sSerialNo+"&rand="+randomNumber(),"_blank");
   }
</script>

<script language=javascript>
    //bShowGridSum = true;
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
</script>

<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.12
		Tester:
		Content:  预测现金流
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预测现金流信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量

	//获得组件参数

	//获得页面参数
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sBusinessRate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessRate"));
	if(sBusinessRate==null) sBusinessRate="";
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	if(sLoanAccount==null) sLoanAccount="";
	String sReturnDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReturnDate"));
	if(sReturnDate==null) sReturnDate="";
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));
	if(sGrade==null) sGrade="";
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "CashPredictInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "Reserve_PredictData";
   	doTemp.setVisible("ObjectNo,GradeName",false);
   	doTemp.setHTMLStyle("Reason,GuarantyReason,EnsureReason","style={width:260;height:150}overflow:scroll");
   	doTemp.appendHTMLStyle("PredictInterest"," onBlur=\"javascript:parent.calDueSum()\" ");
	doTemp.appendHTMLStyle("PredictCapital"," onBlur=\"javascript:parent.calDueSum()\" ");
	doTemp.appendHTMLStyle("GuarantyValue"," onBlur=\"javascript:parent.calDueSum()\" ");
	doTemp.appendHTMLStyle("EnsureValue"," onBlur=\"javascript:parent.calDueSum()\" ");
	//获得基础数据参数是对公还是对个
	String sSqljjw = "select businessflag from reserve_record where LoanAccount = '" + sLoanAccount + "'";
	ASResultSet stempjjw = Sqlca.getASResultSet(sSqljjw);
	String tablejjw = "";
	if(stempjjw.next()){
		String sbusinessflag = stempjjw.getString("businessflag")==null ? "" : stempjjw.getString("businessflag");
		if(sbusinessflag.equals("1"))
		{
			tablejjw = "Reserve_Para";
		}
		else if(sbusinessflag.equals("2"))
		{
			tablejjw = "Reserve_IndPara";
		}
	}
	stempjjw.getStatement().close();
	//获得基础数据参数
	String stemp = "select basedate from " + tablejjw + " where AccountMonth = '" + sAccountMonth + "'";
    ASResultSet rsTemp = Sqlca.getASResultSet(stemp);
    String sBaseDate = "";
    if(rsTemp.next()){
       sBaseDate = rsTemp.getString("basedate")== null ? "" : rsTemp.getString("basedate");
    }
    rsTemp.getStatement().close();
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+","+sReturnDate+","+sLoanAccount+","+sGrade);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回","goBack()",sResourcesPath},
		{"false","","Button","上传附件","上传附件","Upload()",sResourcesPath},
		{"false","","Button","客户详情","客户详情","CustomerAndView()",sResourcesPath}
	};
	if(CurUser.hasRole("603"))
	{
		sButtons[3][0] = "true";
	}
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	function selectAccountMonth()
	{
		
		var sReturnDate = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=21;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sReturnDate)!="undefined" && sReturnDate!="")
		{	
			alert(sReturnDate);
			setItemValue(0,0,"ReturnDate",sReturnDate);
		}
		else
			setItemValue(0,0,"ReturnDate","");
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
			var sReturnDate=getItemValue(0,getRow(),"ReturnDate");
			var iCount = RunMethod("新会计准则","getReturnDate","<%=sLoanAccount%>"+","+"<%=sAccountMonth%>"+","+sReturnDate+","+"<%=sGrade%>");
			if(iCount==1)
			{
				alert("您已经预测了该预计回收日期，请重新预测！");
				bIsInsert=true;
				return;
			}
		}
		else{
			beforeUpdate();
		}
		var sDiscountValue = getItemValue(0,getRow(),"DiscountValue");
		if(sDiscountValue=="" )
		{
			var sVar = calDiscountValue();
		    if(sVar == 1){
		    	return 1;
		    }
		}
		
		as_save("myiframe0",sPostEvents);
	}
	
	function goBack()
	{
		self.close();
	}
	function Upload(){
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		PopComp("AddDocumentPreMessage","/BusinessManage/ReserveManage/AddDocumentPreMessage.jsp","ObjectType=ReserveImport&ObjectNo= <%=sSerialNo%>" + "&rand="+randomNumber(),"_blank","width=500,height=150,top=200,left=170;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 	
	}
	
	function CustomerAndView()
	{
		
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sCustomerID = RunMethod("新会计准则","CustomerAndView",sLoanAccount+","+sAccountMonth);
		if (sCustomerID=="1")
		{
			alert("客户编号为空，不存在客户详情");
			return;
		}
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }

        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];
        sReturnValue2 = sReturnValue[1];
        sReturnValue3 = sReturnValue[2];
		openObject("Customer",sCustomerID,"001");
		reloadSelf();
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		
	}
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,0,"LoanAccount","<%=sLoanAccount%>");
			setItemValue(0,0,"Grade","<%=sGrade%>");
			setItemValue(0,0,"Discount","<%=sBusinessRate%>");
		}	
    }
    
    function calDueSum()
    {
	    if(allowCalDueSum() == false){
	       return;
	    }
		dPredictInterest = getItemValue(0,getRow(),"PredictINTEREST");			
		dPredictCapital = getItemValue(0,getRow(),"PredictCapital");			
		dGuarantyValue = getItemValue(0,getRow(),"GuarantyValue");			
		dEnsureValue = getItemValue(0,getRow(),"EnsureValue");
		dDueSum = dPredictInterest + dPredictCapital + 	dGuarantyValue + dEnsureValue;
	    setItemValue(0,getRow(),"DueSum",dDueSum);	
	    calDiscountValue();

	}
	function allowCalDueSum()
	{
		dPredictInterest = getItemValue(0,getRow(),"PredictINTEREST");
      	if (typeof(dPredictInterest) == "undefined" || dPredictInterest.length == 0)
		{
			return false;
		}			
		dPredictCapital = getItemValue(0,getRow(),"PredictCapital");			
      	if (typeof(dPredictCapital) == "undefined" || dPredictCapital.length == 0)
		{
			return false;
		}
		dGuarantyValue = getItemValue(0,getRow(),"GuarantyValue");			
      	if (typeof(dGuarantyValue) == "undefined" || dGuarantyValue.length == 0)
		{
			return false;
		}
		dEnsureValue = getItemValue(0,getRow(),"EnsureValue");	
      	if (typeof(dEnsureValue) == "undefined" || dEnsureValue.length == 0)
		{
			return false;
		}
		return true;	   
	}
	function calDiscountValue(){
	   sReturnDate = getItemValue(0,getRow(),"ReturnDate");	
	   sBaseDate = "<%=sBaseDate%>";
	   if(typeof(sBaseDate)=="undefined" || sBaseDate.length ==0)
	   {
	   		alert("本笔业务的基础数据不存在，请录入本月份的基础数据！");
	   		return 1;
	   }
	   dDueSum = getItemValue(0,getRow(),"DueSum");	
	   dDiscount = getItemValue(0,getRow(),"Discount");	
	   var   n1   =   new   Date(sReturnDate).getTime();   
  	   var   n2   =   new   Date(sBaseDate).getTime();
  	   dYear = (n1-n2)/(24*60*60*1000*360);
	   tmp = Math.pow((1+dDiscount/100.0), dYear);
	   dDiscountValue = dDueSum/tmp;
	   dDiscountValue = Math.round(dDiscountValue * 100)/100.0;
	   if(isNaN(dDiscountValue))
	   {
	   		setItemValue(0,getRow(),"DiscountValue","");	
	   }else
	   {	   		
	    	setItemValue(0,getRow(),"DiscountValue",dDiscountValue);
	   }
	   return 0;
	}
   
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

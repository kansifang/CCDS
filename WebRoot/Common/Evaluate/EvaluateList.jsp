<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:    
		Tester:	
		Content: 客户列表
		Input Param:
              ObjectType:  对象类型
              ObjectNo  :  对象编号
              ModelType :  评估模型类型 010--信用等级评估   030--风险度评估  080--授信限额 018--信用村镇评定  具体由'EvaluateModelType'代码说明
              CustomerID：  客户代码        　        
		Output param:
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005.7.22 fbkang    页面整理
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "评估列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
	String sSql = "";//--存放sql语句
	String sObjectType = "";//--对象类型
	String sObjectNo = "";//--对象编号
	String sModelType = "";//--模型类型
	String sFag = "";//--标志
	String sCustomerType = "";//--客户类型
	String sModelTypeAttributes="";//--模型类型属性
	String sCustomerID = "";//--客户代码
    String sDisplayFinalResult="";//--显示结果
    //获得组件参数，对象类型、对象编号、模型类型、客户代码
	sObjectType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	sModelType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelType"));
	sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if (sModelType==null) 
		sModelType = "010"; //缺省模型类型为"信用等级评估"
	ASResultSet rs = null;
%>	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	sSql = "select * from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo='"+sModelType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sModelTypeAttributes = rs.getString("RelativeCode");
	}else{
		throw new Exception("模型类型 ["+sModelType+"] 没有定义。请查看CODE_LIBRARY:EvaluateModelType");
	}
	rs.getStatement().close();
	
	sDisplayFinalResult = StringFunction.getProfileString(sModelTypeAttributes,"DisplayFinalResult");
	
	//设置标题
	String sHeaders[][] =  { {"EvaluateDate","评估日期"},
	                         {"AccountMonth","会计月份"},
				             {"ModelTypeName","评估模型"},
				             {"ModelName","评估模型"},
				             {"CognDate","最终认定日期"},
				             {"EvaluateScore","系统评估得分"},
				             {"EvaluateResult","系统评估结果"},
				             {"OrgName","评估单位"},
				             {"UserName","评估客户经理"},
				             {"CognScore","人工认定得分"},
				             {"CognResult","人工认定结果"},
				             {"CognOrgName","最终认定单位"},
				             {"CognUserName","最终认定人"}
						   }; 
	String sHeaders1[][] = { {"EvaluateDate","评估日期"},
	                         {"AccountMonth","会计月份"},
				             {"ModelTypeName","评估模型"},
				             {"ModelName","评估模型"},
				             {"CognDate","最终认定日期"},
				             {"EvaluateScore","最高授信限额参考值(万元)"},
				             {"OrgName","评估单位"},
				             {"UserName","评估客户经理"},
				             {"CognScore","最终认定最高授信限额(万元)"},
				             {"CognResult","最终认定结果"},
				             {"CognOrgName","最终认定单位"},
				             {"CognUserName","最终认定人"}
							}; 
	sSql = " select AccountMonth,C.ModelName,EvaluateScore,EvaluateResult,CognScore,CognResult,"+
	       " ObjectType,ObjectNo,SerialNo,CognDate,R.ModelNo,OrgID,getOrgName(OrgID) as OrgName,"+
	       " UserID,getUserName(UserID) as UserName,CognOrgID,getOrgName(CognOrgID) as CognOrgName,"+
	       " CognUserID,getUserName(CognUserID) as CognUserName,R.FinishDate "+
	       " from EVALUATE_RECORD R,EVALUATE_CATALOG C" + 
	       " where ObjectType = '"+sObjectType+"' "+
	       " and ObjectNo = '"+sObjectNo+"' "+
	       " and R.ModelNo = C.ModelNo ";
	       
	if (sModelType.equals("030"))//  如果是业务风险评估，减少列表的项
	{		
		String sModelTypeName="风险度评估表";
		//风险度评估只对申请做，如果当前对象为合同和通知书，显示关联的申请的风险度评估
		if(sObjectType.equals("CreditApply"))//申请
		{	sSql = " select ObjectType,ObjectNo,SerialNo,EvaluateDate,R.ModelNo,AccountMonth, "+
				   " '风险度评估表' as ModelTypeName,EvaluateScore,OrgID,getOrgName(OrgID) as OrgName, "+
				   " UserID,getUserName(UserID) as UserName,R.FinishDate "+
			       " from EVALUATE_RECORD R " + 
			       " where ObjectType='"+sObjectType + "' and ObjectNo='"+ sObjectNo + "' ";
		 }
		else if(sObjectType.equals("ApproveApply"))//通知书
		{
			sSql = " select ObjectType,ObjectNo,R.SerialNo,EvaluateDate,R.ModelNo,AccountMonth, "+
				   " '风险度评估表' as ModelTypeName,EvaluateScore,OrgID,getOrgName(OrgID) as OrgName, "+
				   " UserID,getUserName(UserID) as UserName,R.FinishDate "+
				   " from EVALUATE_RECORD R, BUSINESS_APPROVE P "+
				   " where ObjectType='BusinessApply' "+
				   " and R.ObjectNo=P.RelativeSerialNo "+ 
				   " and P.SerialNo='"+sObjectNo+"' "; 
		}
		else if(sObjectType.equals("BusinessContract"))//合同
		{
			sSql = " select ObjectType,ObjectNo,R.SerialNo,EvaluateDate,R.ModelNo,AccountMonth, "+
				   " '风险度评估表' as ModelTypeName,EvaluateScore,OrgID,getOrgName(OrgID) as OrgName, "+
				   " UserID,getUserName(UserID) as UserName,R.FinishDate "+
				   " from EVALUATE_RECORD R, BUSINESS_CONTRACT P "+
				   " where ObjectType='BusinessApply' "+
				   " and R.ObjectNo=P.RelativeSerialNo "+ 
				   " and P.SerialNo='"+sObjectNo+"' "; 
		}		
	}else//其它阶段的评估
	{
		sSql += " and C.ModelType='"+sModelType+"'";
	}

	sSql += " order by AccountMonth DESC,SerialNo desc ";
	ASDataObject doTemp = new ASDataObject(sSql);
	if (sModelType.equals("080"))
	{
		doTemp.setHeader(sHeaders1);
		//设置不可见项
		doTemp.setVisible("EvaluateResult,CognScore,CognResult,CognOrgName,CognUserName,CognDate",false);
		  
	}
	else
	{
		doTemp.setHeader(sHeaders);
		doTemp.setVisible("CognScore,CognResult",false);
	}
	//设不可见
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,ModelNo,UserID,OrgID,CognUserID,CognOrgID,FinishDate",false);
	if(sDisplayFinalResult==null || !sDisplayFinalResult.equalsIgnoreCase("Y"))
	{
		doTemp.setVisible("EvaluateScore,EvaluateResult,CognScore,CognResult",false);
	}
	doTemp.setVisible("CognDate,CognOrgName,CognUserName",false);
	//设置宽度
	doTemp.setHTMLStyle("ModelName","style={width:200px} ");
	doTemp.setHTMLStyle("AccountMonth,CognDate,EvaluateScore,EvaluateResult,UserName,CognScore,CognResult","  style={width:80px}  ");
	//设置EvaluateScore的检查格式(1 String 2 Number 3 Date(yyyy/mm/dd) 4 DateTime(yyyy/mm/dd hh:mm:ss))
	doTemp.setCheckFormat("BusinessSum,EvaluateScore,CognScore","2");
	//设置EvaluateScore的字段类型("String","Number")
	doTemp.setType("EvaluateScore,CognScore","Number");
	
	if (sModelType.equals("080"))
	{
		doTemp.setHTMLStyle("EvaluateScore,CognScore","style={width:160px} ");	  
	}
	doTemp.setCheckFormat("EvaluateDate","3");
    doTemp.setHTMLStyle("OrgName","style={width:200px}"); 	
	doTemp.setAlign("EvaluateResult,CognResult","2");
	//生成过滤器
	doTemp.setColumnAttribute("AccountMonth","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//取是否停用并行客户信用等级评估
	String sIsInuse = Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
    if (sIsInuse== null) sIsInuse="" ;
%> 

<%/*END*/%>


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
			  {"true","","Button","新增","新增评估信息","my_add()",sResourcesPath},
			  {"true","","Button","删除","删除所选中的信息","my_del()",sResourcesPath},
			  {"true","","Button","详情","查看评估详情","my_detail()",sResourcesPath},
			  {"true","","Button","打印","打印评估详情","my_print()",sResourcesPath},
			  {"false","","Button","人工认定","调整认定原因说明","Reason()",sResourcesPath},
			  {"false","","Button","删除","删除信用等级评估申请","cancelApply()",sResourcesPath},
			  {"false","","Button","签署意见","打印评估详情","signOpinion()",sResourcesPath},
			  {"false","","Button","提交","打印评估详情","doSubmit()",sResourcesPath},
		     };
	if (sModelType.equals("030") || sModelType.equals("018") || sModelType.equals("080"))
	{
	    sButtons[3][0] = "false";
	}
	if (sModelType.equals("010") ||sModelType.equals("018")) {
		sButtons[4][0] = "false";
	}
	if(sModelType.equals("015"))
	{
		sButtons[1][0] = "false";
		sButtons[5][0] = "true";
		sButtons[6][0] = "false";
		sButtons[7][0] = "false";
		
	}
	//当停用并行信用评级时屏蔽“并行客户信用等级评估”下的新增删除按钮
	if(sObjectType.equals("NewEvaluate") && !sIsInuse.equals("2"))
	{
		sButtons[1][0] = "false";
		sButtons[0][0] = "false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script>
	//---------------------定义按钮事件---------------------//
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function my_add()
	{
		var stmp = CheckRole();
		if("true"==stmp)
		{    		
    		sReturn = PopPage("/Common/Evaluate/AddEvaluateMessage.jsp?Action=display&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ModelType=<%=sModelType%>&EditRight=100","","dialogWidth:350px;dialogHeight:350px;resizable:yes;scrollbars:no");
    		if(sReturn==null || sReturn=="" || sReturn=="undefined") return;
    		sReturns = sReturn.split("@");
    		sObjectType = sReturns[0];
    		sObjectNo = sReturns[1];
    		sModelType = sReturns[2];
    		sModelNo = sReturns[3];
    		sAccountMonth = sReturns[4];
    		
    		sReturn=PopPage("/Common/Evaluate/ConsoleEvaluateAction.jsp?Action=add&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ModelType="+sModelType+"&ModelNo="+sModelNo+"&AccountMonth="+sAccountMonth,"","dialogWidth=20;dialogHeight=20;resizable=yes;center:no;status:no;statusbar:no");
    		if (typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn == "EXIST")
    		{
    			alert(getBusinessMessage('189'));//本期信用等级评估记录已存在，请选择其他月份！
    			return;
    		}
    		
    		if(typeof(sReturn) != "undefined" && sReturn.length>=0 && sReturn != "failed")
    		{
    			var sEditable="true";
				OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID=<%=sCustomerID%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sReturn+"&Editable="+sEditable,"_blank",OpenStyle);
    		}
    	    reloadSelf();
	    }else
	    {
	        alert(getBusinessMessage('190'));//对不起，你没有信用等级评估的权限！
	    }
	}
	
	/*~[Describe=查看明细;InputParam=无;OutPutParam=无;]~*/
	function my_detail()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sUserID       = getItemValue(0,getRow(),"UserID");
		var sOrgID        = getItemValue(0,getRow(),"OrgID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			var sEditable="true";
			if(sUserID!="<%=CurUser.UserID%>")
				sEditable="false";
			OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID=<%=sCustomerID%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&Editable="+sEditable,"_blank",OpenStyle);
		    reloadSelf();
		}		
	}
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function my_del()
	{
		var stmp = CheckRole();
		if("true"==stmp)
		{
    		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    		var sUserID       = getItemValue(0,getRow(),"UserID");
    		var sOrgID        = getItemValue(0,getRow(),"OrgID");
    		
    		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    		{
    			alert(getHtmlMessage('1'));//请选择一条信息！
    		}else if(sUserID=='<%=CurUser.UserID%>')
    		{
	          	if(confirm(getHtmlMessage('2')))
	          	{
	          	  	sReturn=PopPage("/Common/Evaluate/ConsoleEvaluateAction.jsp?Action=delete&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo,"","dialogWidth=20;dialogHeight=20;resizable=yes;center:no;status:no;statusbar:no");
		    		if(sReturn=="success")
		    		{
		    			alert(getHtmlMessage('7'));//信息删除成功！
		    			reloadSelf();
		    		}else
		    		{
		    			alert(getHtmlMessage('8'));//对不起，删除信息失败！
		    		}		    	           
    		    } 
    		}else alert(getHtmlMessage('3'));
		}else
	    {
	       alert(getBusinessMessage('190'));//对不起，你没有信用等级评估的权限！
	    }
	}
	
	/*~[Describe=人工认定;InputParam=无;OutPutParam=无;]~*/
	function Reason()
	{
	    var stmp = CheckRole();
		if("true"==stmp)
		{
    		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    		var sUserID = getItemValue(0,getRow(),"UserID");
    		var sOrgID = getItemValue(0,getRow(),"OrgID");
    		var sModelNo = getItemValue(0,getRow(),"ModelNo");
    		var sFinishDate	= getItemValue(0,getRow(),"FinishDate");
    		
    		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    		{    		
    			alert(getHtmlMessage('1'));//请选择一条信息！  			
    		}else
    		{
    			OpenComp("EvaluateReason","/Common/Evaluate/Reason.jsp","FinishDate="+sFinishDate+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&ModelNo="+sModelNo,"_blank","height=600, width=800, left=0,top=0,toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
    		    reloadSelf();
    		}
    	}
	    else
	    {
	        alert(getBusinessMessage('190'));//对不起，你没有信用等级评估的权限！
	    }
	}
	/*~[Describe=打印;InputParam=无;OutPutParam=无;]~*/
	function my_print()
	{

		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sModelNo      = getItemValue(0,getRow(),"ModelNo");
		sSerialNo     = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！  	
		}else
		{
			PopPage("/Common/Evaluate/EvaluatePrint.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&rand="+randomNumber(),"_blank","");
 		}
	}
	/*~[Describe=评估校验;InputParam=无;OutPutParam=无;]~*/
	function CheckRole()
	{
	    var sCustomerID="<%=sCustomerID%>";
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
  
        if (typeof(sReturn)=="undefined" || sReturn.length==0){
        	return n;
        }
        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];        //客户主办权
        sReturnValue2 = sReturnValue[1];        //信息查看权
        sReturnValue3 = sReturnValue[2];        //信息维护权
        sReturnValue4 = sReturnValue[3];        //业务申办权

        if(sReturnValue3 =="Y2")
            return "true";
        else
            return "n";
	}
	//add by xhyong 增加流程提交功能
	//签署意见
	function signOpinion()
	{
     	//获得类型、流水号、流程编号、阶段编号
		var sObjectType = "Customer";
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sFlowNo = "EvaluateFlow";
		var sPhaseNo = "0010";
		sEvaluateScore = getItemValue(0,getRow(),"EvaluateScore");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if (typeof(sEvaluateScore)=="undefined" || sEvaluateScore.length==0){
			alert("请先进行模型评定！");//请先进行模型评定
			return;
		}
		//判断是否提交
		var sColName = "PhaseNo"+"~";
		var sTableName = "FLOW_OBJECT"+"~";
		var sWhereClause = "String@ObjectNo@"+sSerialNo+"@String@ObjectType@Customer"+"~";
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('@');
			if(sReturn[1] != "0010")
			{
				alert("已经提交,不用签署意见!");
				return;
			}
			
		}
		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		
		PopComp("SignEvaluateOpinionInfo","/Common/WorkFlow/SignEvaluateOpinionInfo.jsp","TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function cancelApply()
	{
		//获得类型、流水号
		var ObjectType = "Customer";
		var SerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(SerialNo)=="undefined" || SerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			var sReturn = RunMethod("WorkFlowEngine","DeleteCreditCognTask",ObjectType+","+SerialNo+",DeleteTask");
			if (typeof(sReturn) != "undefined" && sReturn.length>=0)
			{
				alert("删除成功！");
			}	
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}
	
	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function doSubmit()
	{
		//获得类型、申请流水号、流程编号、阶段编号
		var sObjectType = "Customer";
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sFlowNo = "EvaluateFlow";
		var sPhaseNo = "0010";
		sEvaluateScore = getItemValue(0,getRow(),"EvaluateScore");
	    sFinishDate = "<%=StringFunction.getToday()%>";
		sUserId="<%=CurUser.UserID%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if (typeof(sEvaluateScore)=="undefined" || sEvaluateScore.length==0){
			alert("请先进行模型评定！");//请先进行模型评定
			return;
		}
		
		//判断是否提交
		var sColName = "PhaseNo"+"~";
		var sTableName = "FLOW_OBJECT"+"~";
		var sWhereClause = "String@ObjectNo@"+sSerialNo+"@String@ObjectType@Customer"+"~";
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('@');
			if(sReturn[1] != "0010")
			{
				alert("已经提交,不用重复提交!");
				return;
			}
			
		}
		
		//获取任务流水号
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
	
		//检查是否签署意见
		var sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert("请先签署认定意见，然后再提交！");//先签署认定意见
			return;
		}

		//弹出审批提交选择窗口		
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined"){
			 return;
		}else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//提交成功！
				reloadSelf();
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}		
	} 
	//add end
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
	
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

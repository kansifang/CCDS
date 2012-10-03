<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.12      
		Tester:	
		Content: 新会计准则——公司业务_减值准备预测
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "减值准备预测"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>

<%
	//定义变量
	String sSql = "";//存放 sql语句
	
	String sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	if(sAction == null) sAction = "";
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sType == null) sType = "";
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));
	if(sGrade == null) sGrade = "";
	String sCondition1 = "";
	String sEqualCondition = "";
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
	             {"AccountMonth1","会计月份"},
				 {"LoanAccount","借据号"},
				 {"ObjectNo","借据号"},
				 {"Statorgid","贷款机构代码"},
				 {"StatOrgName","贷款机构名称"},
				 {"CustomerName","客户名称"},
				 {"BusinessSum","贷款金额"},
				 {"Balance","贷款余额"},
				 {"PutoutDate","发放日"},
				 {"MaturityDate","到期日"},
				 {"AuditRate","实际利率(‰)"},
				 {"VouchType","主要担保方式"},
				 {"VouchTypeName","主要担保方式"},
				 {"MClassifyResultName","五级分类"},
				 {"MClassifyResult","五级分类"},
				 {"AClassifyResultName","审计五级分类"},
				 {"AClassifyResult","审计五级分类"},
				 {"Result1","管户员测算结果"},
				 {"Result2","支行预测结果"},
				 {"Result3","分行预测结果"},
				 {"Result4","总行认定结果"},
				 {"MResult","总行最终认定结果"},
				 {"AResult","审计认定结果"},
				 {"ManageOrgID","管户机构"}
			};
	
	String sSql1 = "select  SerialNo, LoanAccount, AccountMonth, AccountMonth as AccountMonth1,getorgname(Statorgid) as StatOrgName, ObjectNo, CustomerName,BusinessSum, Balance," + 
	       " AuditRate,getItemName('MFiveClassify', MClassifyResult) as MClassifyResultName,MClassifyResult, "+
	       " getItemName('MFiveClassify', AClassifyResult) as AClassifyResultName,AClassifyResult, "+
	       " PutoutDate,MaturityDate,getItemName('VouchType', RR.VouchType) as VouchTypeName, "+
	       " Result1, Result2, Result3, Result4, MResult, AResult ,ManageOrgID " +
	       " from Reserve_Record RR where RR.BusinessFlag = '1' ";
    String sSql2 = " union select 'unInput' as SerialNo, RT.LoanAccount as LoanAccount, RT.AccountMonth as AccountMonth, AccountMonth as AccountMonth1, "+
    					" getorgname(RT.Statorgid) as StatOrgName, RT.DuebillNo as ObjectNo, RT.CustomerName as CustomerName, RT.BusinessSum as BusinessSum , RT.Balance as Balance, " + 
                        " RT.AuditRate as AuditRate,getItemName('MFiveClassify', RT.MFiveClassify) as MClassifyResultName, RT.MFiveClassify as MClassifyResult, " +
                        " getItemName('MFiveClassify', RT.AFiveClassify) as AClassifyResultName, RT.AFiveClassify as AClassifyResult, " +
	                    " RT.PutoutDate as PutoutDate,RT.Maturity as MaturityDate,getItemName('VouchType', RT.VouchType) as VouchTypeName , " + 
	                    " '' as Result1, '' as Result2, '' as Result3, '' as Result4, '' as MResult, '' as AResult ,RT.ManageOrgID as ManageOrgID from Reserve_Total RT " + 
	                    " where not exists (select * from Reserve_Record RR where RR.LoanAccount = RT.LoanAccount and RR.AccountMonth=RT.AccountMonth) "+
	                    " and getOrgSortNo(RT.Manageuserid) = getOrgSortNo('" + CurUser.UserID + "')" + 
	                    " and RT.ManageStatFlag = '2' " + //2-逐笔计提
	                    " and RT.BusinessFlag = '1' and (nvl(RT.MFiveClassify,'') <> '05' or nvl(RT.AFiveClassify,'') <> '05')" ;
	              
	  if(sAction.equals("UnFinished")){
	        if(CurUser.hasRole("601")){
			   	sRightCondi = " and (RR.FinishDate2 is null and RR.userid1 is not null )";//and getOrgSortNo(manageuserid)=getOrgSortNo('"+CurUser.UserID+"'))";
			}else if(CurUser.hasRole("602")){
			   	sRightCondi = " and (RR.FinishDate3 is null and RR.userid2 is not null )";//and substr(getOrgSortNo(manageuserid),1,6)=substr(getOrgSortNo('"+CurUser.UserID+"'),1,6))";
			}else if(CurUser.hasRole("603")){
			   	sRightCondi = " and (RR.FinishDate4 is null and RR.userid3 is not null)";
			}else if(CurUser.hasRole("604")){
				sRightCondi = " and (RR.MResult is not null and RR.MFinishdate is null and RR.UserID4 is not null)";
			}
			else if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")){
				sRightCondi = " and (RR.FinishDate1 is null and getOrgSortNo(RR.Manageuserid) = getOrgSortNo('" + CurUser.UserID + "'))";
			}     
     }else{
	        if(CurUser.hasRole("601")){
	           	sRightCondi = " and (RR.FinishDate2 is not null and RR.UserId2 = '" + CurUser.UserID + "' and getOrgSortNo(manageuserid)=getOrgSortNo('"+CurUser.UserID+"'))";
			}else if(CurUser.hasRole("602")){
	           	sRightCondi = " and (RR.FinishDate3 is not null and RR.UserId3 = '" + CurUser.UserID + "' and substr(getOrgSortNo(manageuserid),1,6)=substr(getOrgSortNo('"+CurUser.UserID+"'),1,6))";
			}else if(CurUser.hasRole("603")){
	           	sRightCondi = " and (RR.FinishDate4 is not null and RR.UserId4 = '" + CurUser.UserID + "')";
			}else if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")){
			  	sRightCondi = " and (RR.FinishDate1 is not null and RR.UserId1 = '" + CurUser.UserID + "')";
			}
	}
	        
	if(sAction.equals("Finished") && sType.equals("Input")){//信贷员
        sSql2 = sSql2 + " and 1=2";
        sSql1 = sSql1 + sRightCondi;
        sSql = sSql1 + sSql2;
    }else if(sAction.equals("UnFinished") && sType.equals("Input"))
    {
    	sSql1 = sSql1 + sRightCondi;
    	sSql = sSql1 + sSql2;
    }else
    {
    	sSql = sSql1 + sRightCondi; 
    }
    System.out.println("--------------------------------"+sSql);
    //sSql = sSql + " order by ObjectNo desc";
	ASDataObject doTemp = new ASDataObject(sSql);
	String sTemp = doTemp.WhereClause;
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Record";
    doTemp.setKey("SerialNo,AccountMonth,LoanAccount",true);
 //   doTemp.setColumnAttribute("AccountMonth,CustomerName,LoanAccount","IsFilter","1");
 //	doTemp.setDDDWSql("AccountMonth","select distinct AccountMonth,AccountMonth from Reserve_Total");
 	doTemp.generateFilters(Sqlca);
 	doTemp.setFilter(Sqlca,"1","AccountMonth","");
 	doTemp.setFilter(Sqlca,"2","CUstomerName","");
 	doTemp.setFilter(Sqlca,"3","LoanAccount","");
 	doTemp.setFilter(Sqlca,"4","ManageOrgID","");
    //doTemp.setCheckFormat("AccountMonth","6");
    doTemp.setHTMLStyle("LoanAccount","style={width:150px}");
    doTemp.setHTMLStyle("Result1,Result2,Result3,Result4,AResult","style={width:100px}");
    doTemp.setHTMLStyle("AccountMonth,PutoutDate,MaturityDate,MClassifyResultName,AClassifyResultName","style={width:80px}");
	doTemp.setVisible("ManageOrgID,AccountMonth,SerialNo,ObjectNo,MClassifyResult,AClassifyResult,VouchTypeName,StatOrgName,MResult,BusinessSum,AClassifyResultName,AResult",false);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	doTemp.setType("BusinessSum,Balance","Number");
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	if(doTemp.haveReceivedFilterCriteria())
	{
		sSql1 += doTemp.WhereClause.substring(sTemp.length());
	    sSql2 += doTemp.WhereClause.substring(sTemp.length());
	    String sSql3 = "";      
		if(sAction.equals("Finished") && sType.equals("Input")){//信贷员
        	sSql2 = sSql2 + " and 1=2";
        	sSql1 = sSql1 + sRightCondi;
        	sSql3 = sSql1 + sSql2;
    	}else if(sAction.equals("UnFinished") && sType.equals("Input"))
    	{
    		sSql1 = sSql1 + sRightCondi;
    		sSql3 = sSql1 + sSql2;
    	}else
    	{
    		sSql3 = sSql1 + sRightCondi; 
    	} 	
        doTemp = null;
	    dwTemp = null;
        doTemp = new ASDataObject(sSql3);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable="Reserve_Record";
		doTemp.setKey("SerialNo,AccountMonth,LoanAccount",true);
		//doTemp.setDDDWSql("AccountMonth","select distinct AccountMonth,AccountMonth from Reserve_Total");
		doTemp.generateFilters(Sqlca);
 		doTemp.setFilter(Sqlca,"1","AccountMonth","");
 		doTemp.setFilter(Sqlca,"2","CUstomerName","");
 		doTemp.setFilter(Sqlca,"3","LoanAccount","");
 		doTemp.setFilter(Sqlca,"4","ManageOrgID","");
		//doTemp.setCheckFormat("AccountMonth","6");
		doTemp.setHTMLStyle("LoanAccount","style={width:150px}");
		doTemp.setHTMLStyle("Result1,Result2,Result3,Result4,AResult","style={width:100px}");
		doTemp.setHTMLStyle("AccountMonth,PutoutDate,MaturityDate,MClassifyResultName,AClassifyResultName","style={width:80px}");
		doTemp.setVisible("ManageOrgID,AccountMonth,SerialNo,ObjectNo,MClassifyResult,AClassifyResult,VouchTypeName,StatOrgName,MResult,BusinessSum,AClassifyResultName,AResult",false);
		doTemp.setType("BusinessSum,Balance","Number");
		doTemp.parseFilterData(request,iPostChange);
		doTemp.multiSelectionEnabled = false;
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	}
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
			{"true","","Button","损失识别","损失识别","DiscernLoss()",sResourcesPath},
			{"true","","Button","预测现金流维护","预测现金流维护","my_Input()",sResourcesPath},
			{"true","","Button","单笔提交","单笔提交","my_Singlefinish()",sResourcesPath},
			{"true","","Button","批量提交","批量提交","my_Finish()",sResourcesPath},
			{"true","","Button","单笔撤销","单笔撤销","my_SingleCancel()",sResourcesPath},
			{"false","","Button","批量撤销","批量撤销","my_Cancel()",sResourcesPath},
			{"true","","Button","业务详情","业务详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","导出Excel","导出Excel","exportAll()",sResourcesPath}
	};
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
	{
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
	}
	if(sAction.equals("Finished"))
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
	}
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	
	function DiscernLoss()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		sMClassifyResult = getItemValue(0,getRow(),"MClassifyResult");
		sBalance = getItemValue(0,getRow(),"Balance");
		sPutoutDate = getItemValue(0,getRow(),"PutoutDate");
		sMaturityDate = getItemValue(0,getRow(),"MaturityDate");
		if(typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0)
		{
			alert("请选择一条信息");
			return;
		}
		sReturnValue = "";
 		if(sSerialNo == "unInput"){//如果是未预测的记录，向预测表中插入该记录
 		   sReturnValue = PopPage("/BusinessManage/ReserveManage/InsertRecordAction.jsp?LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth,"","resizable=yes;dialogWidth=0;dialogHeight=0;status:no;center:yes;status:yes;statusbar:no");
 		   if(sReturnValue == "01"){
 		      alert("数据库操作失败，请与管理员联系");
 		      return;
 		   }
 		}
		PopComp("ReserveLossView","/BusinessManage/ReserveManage/ReserveLossView.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&CustomerName="+sCustomerName+"&MClassifyResult="+sMClassifyResult+"&Balance="+sBalance+"&PutoutDate="+sPutoutDate+"&MaturityDate="+sMaturityDate,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
 		reloadSelf();
	}
	
	
	function my_Input(){
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
		
		var sMfiveClassify = RunMethod("新会计准则","checkFiveClassify",sLoanAccount+","+sAccountMonth);
		if(sMfiveClassify == "0")
		{
			alert("该笔借据"+ sAccountMonth +"没有五级分类!\n 请补录该期次的五级分类");
			PopComp("addFiveClassify","/BusinessManage/ReserveManage/addFiveClassify.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount,"resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			reloadNewSelf();
			return;
		}
 		PopComp("CashPredictView","/BusinessManage/ReserveManage/CashPredictView.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&Grade=<%=sGrade%>","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
 		reloadSelf();
	}
	
	function my_Singlefinish(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择一条借据信息！");
			return;
		}else
		{		
				sReturn = "";
				if ("<%=CurUser.hasRole("601")%>"=="true")
				{
					sReturn="确定将所选记录提交到分行行认定吗？";
				}
				else if("<%=CurUser.hasRole("602")%>"=="true")
				{
					sReturn="确定将所选记录提交到总行最终认定吗？";
				}else if("<%=CurUser.hasRole("603")%>"=="true")
				{
					sReturn="确定将所选记录提交到最终审计吗？";
				}else if("<%=CurUser.hasRole("480")%>"=="true" || "<%=CurUser.hasRole("280")%>"=="true" || "<%=CurUser.hasRole("080")%>"=="true")
				{
					sReturn="确定将所选记录提交吗？";				
			    }
				if(sSerialNo == "unInput"){
					alert("没有预测现金流，不能提交");
					return;
				}else if(confirm(sReturn))
				{
					var sCondition="<%=sCondition1%>";
		 			sReturnValue = PopComp("CheckInfoAction","/BusinessManage/ReserveManage/CheckInfoAction.jsp","SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"dialogWidth=42;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		 			//modify by ycsun 2008/11/13 模态窗口不弹出对话框
		 		/*	sReturn1 = PopPage("/BusinessManage/ReserveManage/CheckAttachAction.jsp?ObjectNo="+sSerialNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			 		if(sReturnValue== "99" || sReturn1=="01"){
			 			alert("没有通过资料完备性检查，不能提交！");
						return;
					}*/
					reloadSelf();
					sReturn=PopPage("/BusinessManage/ReserveManage/singleFinishCashPredictAction.jsp?SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
					if (sReturn=="00")
					{
						alert("单笔提交成功");
						
					}else
					{
						alert("单笔提交失败");
					}
					reloadSelf();
				}		
		}
	}
	
	//批量提交
	function my_Finish(){
		iCount=getRowCount(0);
		var sReturn="";
		if (iCount>0)
		{			
			if (confirm("确定提交吗？"))
			{
				var sCondition="<%=sCondition1%>";
			 	sReturn=PopComp("FinishCashPredictAction","/BusinessManage/ReserveManage/FinishCashPredictAction.jsp","Type=<%=sType%>"+"&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if (sReturn=="00")
				{
					alert("批量提交成功");
				}else	
				{
					alert("批量提交失败");
				}
				reloadSelf();
			}
		}else 
		{
		 	alert("没有需要提交的记录");
		}
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
				
				sReturn=PopPage("/BusinessManage/ReserveManage/singleCanclePredictAction.jsp?SerialNo="+sSerialNo+"&rand="+randomNumber(),"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
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
			 	sReturn=PopComp("CancelCashPredictAction","/BusinessManage/ReserveManage/CancelCashPredictAction.jsp","Type=<%=sType%>&BusinessFlag=1&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataEntInfo","/BusinessManage/ReserveDataPrepare/ReserveDataEntInfo.jsp","LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	// add by ycsun 2008/12/01 防止在刷新的过程中操作人员点其它的按钮
	function reloadNewSelf(){
		ShowDivMessage("系统正在处理中，请稍等...........",true,false);
		rememberPageRow();
		if(document.forms("DOFilter")==null){
			self.location.reload();
		} else if(typeof(document.forms("DOFilter"))=="undefined"){
			self.location.reload();
		}else{
			document.forms("DOFilter").submit();
		}
	}
	
	function hideDivMessage(){
		try{
			msgDiv.removeChild(msgTxt);
			msgDiv.removeChild(msgTitle);
			document.body.removeChild(msgDiv);
			document.all.msgIfm.removeNode();
			document.body.removeChild(bgDiv);
		}catch(e)
		{	
			;
		}
	}

	function ShowDivMessage(str,showGb,clickHide){
		
		//可以通过对象检查来判断窗口是否已打开
		//采取替换或者取消的操作来避免重复打开
		//提示文字尽量别超过2行,因为背景iframe动态高度不知道怎么弄。
		
	 	if(typeof msgDiv=="object")
			return ;	 	
	
		var msgw=300;//信息提示窗口的宽度
		var msgh=125;//信息提示窗口的高度
		var bordercolor="#336699";//提示窗口的边框颜色
	
		var scrollTop = document.body.scrollTop+document.body.clientHeight*0.4+"px";
		
		//**绘制信息层的低层iframe**/
		var ifmObj=document.createElement("iframe")
		ifmObj.setAttribute('id','msgIfm');
		ifmObj.setAttribute('align','center');
		ifmObj.style.background="white";
		ifmObj.style.border="0px none " + bordercolor;
		ifmObj.style.position = "absolute";
		ifmObj.style.left = "55%";
		ifmObj.style.top = scrollTop; //"40%";
		ifmObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
		ifmObj.style.marginLeft = "-225px" ;//文字位置
		ifmObj.style.marginTop = -75+document.documentElement.scrollTop+"px";
		ifmObj.style.width = msgw + "px";
		ifmObj.style.height =msgh + "px";
		ifmObj.style.textAlign = "center";
		ifmObj.style.lineHeight ="25px";
	
		ifmObj.style.zIndex = "9999";
		document.body.appendChild(ifmObj);
		
		//**绘制背景层**/	
		var bgObj=document.createElement("div");
		bgObj.setAttribute('id','bgDiv');
		bgObj.style.position="absolute";
		
		bgObj.style.top="0";//显示位置top
		bgObj.style.left="0";//显示位置left
		bgObj.style.background="#777";
		bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";//渐变色效果 
		bgObj.style.opacity="50%";//应该是透明度?
	
		//设置背景层 宽,高
		var sWidth,sHeight;
		sWidth=document.body.offsetWidth;
		
		sHeight=screen.height;
		bgObj.style.width="100%" ;//sWidth + "px";//改为100%更好,铺满窗口
		bgObj.style.height="100%" ;//sHeight + "px";
		
		bgObj.style.zIndex = "10000";//显示层次
	
		//背景层动作 点击关闭
		if(clickHide)
			bgObj.onclick=hideMessage;
		if(showGb)
			document.body.appendChild(bgObj);
		
		//**绘制信息层**/
		var msgObj=document.createElement("div")
		msgObj.setAttribute("id","msgDiv");
		msgObj.setAttribute("align","center");
		msgObj.style.background="white";
		msgObj.style.border="1px solid " + bordercolor;
		msgObj.style.position = "absolute";
		msgObj.style.left = "55%";
		msgObj.style.top= scrollTop; //"40%";
		msgObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
		msgObj.style.marginLeft = "-225px" ;//文字位置
		msgObj.style.marginTop = -75+document.documentElement.scrollTop+"px";
		msgObj.style.width = msgw + "px";
		msgObj.style.height =msgh + "px";
		msgObj.style.textAlign = "center";
		msgObj.style.lineHeight ="25px";
		msgObj.style.zIndex = "10001";
		
		document.body.appendChild(msgObj);
		
		//**绘制标题层**/ 点击关闭
		var title=document.createElement("h4");
		title.setAttribute("id","msgTitle");
		title.setAttribute("align","left");
		title.style.margin="0";
		title.style.padding="3px";
		title.style.background=bordercolor;
		title.style.filter="progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";
		title.style.opacity="0.75";
		title.style.border="1px solid " + bordercolor;
		title.style.height="18px";
		//title.style.width = msgw + "px";	
		title.style.font="12px Verdana, Geneva, Arial, Helvetica, sans-serif";
		title.style.color="white";
		
		title.innerHTML="系统处理中...";
		if(clickHide){
			title.innerHTML="关闭";
			title.style.cursor="pointer";			
			title.onclick = hideDivMessage;
		}	
		
		document.getElementById("msgDiv").appendChild(title);
		
		//**输出提示信息**/
		str = "<br>"+str.replace(/\n/g,"<br>");
		var txt=document.createElement("p");
		txt.style.margin="1em 0"
		txt.setAttribute("id","msgTxt");
		txt.innerHTML=str;
		document.getElementById("msgDiv").appendChild(txt);
			
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
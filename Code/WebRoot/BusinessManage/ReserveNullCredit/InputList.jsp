<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.12      
		Tester:	
		Content: 新会计准则——非信贷业务_减值准备预测
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "非信贷业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//存放 sql语句
	
	String sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));
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
				 {"LoanAccount","借据号"},
				 {"CustomerName","客户名称"},
				 {"BusinessSum","本期余额"},
				 {"Balance","贷款余额"},
				 {"Result1","管户员测算结果"},
				 {"Result2","支行认定结果"},
				 {"Result3","分行认定结果"},
				 {"Result4","总行认定结果"},
				 {"MResult","总行最终认定结果"},
				 {"AResult","审计认定结果"},
			};
	
	sSql = " select  SerialNo, LoanAccount, AccountMonth,  CustomerName,BusinessSum, Balance," + 
	       " Result1, Result2, Result3, Result4, MResult, AResult " +
	       " from Reserve_Record RR where RR.BusinessFlag = '3' ";
    String sSql2 = " union select 'unInput' as SerialNo, RN.AssetNo as AssetNo, RN.AccountMonth as AccountMonth,  RN.DebtorName as DebtorName, RN.AccountSum as AccountSum , RN.Balance as Balance, " + 
	                    " '' as Result1, '' as Result2, '' as Result3, '' as Result4, '' as MResult, '' as AResult from Reserve_Nocredit RN " + 
	                    " where not exists (select * from Reserve_Record RR where RR.LoanAccount = RN.AssetNo) "+
	                    " and RN.Manageuserid = '" + CurUser.UserID + "'" ; 
	                    
	  if(sAction.equals("UnFinished")){
	        if(CurUser.hasRole("601")){
			   	sRightCondi = " and (RR.FinishDate2 is null and RR.userid1 is not null)";
			   	sEqualRightCondi = " and (FinishDate2 is null and userid1 is not null)";
			}else if(CurUser.hasRole("602")){
			   	sRightCondi = " and (RR.FinishDate3 is null and RR.userid2 is not null)";
			   	sEqualRightCondi = " and (FinishDate3 is null and userid2 is not null)";
			}else if(CurUser.hasRole("603")){
			   	sRightCondi = " and (RR.FinishDate4 is null and RR.userid3 is not null)";
			   	sEqualRightCondi = " and (FinishDate4 is null and userid3 is not null)";
			}else if(CurUser.hasRole("604")){
				sRightCondi = " and (RR.MResult is not null and RR.MFinishdate is null and RR.UserID4 is not null)";
	        	sEqualRightCondi = " and (MResult is not null and MFinishdate is null and UserID4 is not null)"; 
			}
			else if(CurUser.hasRole("480")){
				sRightCondi = " and (RR.FinishDate1 is null and RR.Manageuserid = '" + CurUser.UserID + "')";
	        	sEqualRightCondi = " and (FinishDate1 is null and Manageuserid = '" + CurUser.UserID + "')"; 	        
			}     
     }else{
	        if(CurUser.hasRole("601")){
	           	sRightCondi = " and (RR.FinishDate2 is not null and RR.UserId2 = '" + CurUser.UserID + "')";
	           	sEqualRightCondi = " and (FinishDate2 is not null and RR.UserId2 = '" + CurUser.UserID + "')";
			}else if(CurUser.hasRole("602")){
	           	sRightCondi = " and (RR.FinishDate3 is not null and RR.UserId3 = '" + CurUser.UserID + "')";
	           	sEqualRightCondi = " and (FinishDate3 is not null and Manageuserid = '" + CurUser.UserID + "')";
			}else if(CurUser.hasRole("603")){
	           	sRightCondi = " and (RR.FinishDate4 is not null and RR.UserId4 = '" + CurUser.UserID + "')";
	           	sEqualRightCondi = " and (FinishDate4 is not null and Manageuserid = '" + CurUser.UserID + "')";
			}else if(CurUser.hasRole("480")){
			  	sRightCondi = " and (RR.FinishDate1 is not null and RR.Manageuserid = '" + CurUser.UserID + "')";
            	sEqualRightCondi = " and (FinishDate1 is not null and Manageuserid = '" + CurUser.UserID + "')";
			}
	}
	sSql = sSql + sRightCondi;         
	if(sAction.equals("Finished") && sType.equals("Input")){//信贷员
        sSql2 = sSql2 + " and 1=2";
        sSql = sSql + sSql2;
    }else if(sAction.equals("UnFinished") && sType.equals("Input"))
    {
    	sSql = sSql + sSql2;
    }
    //sSql = sSql + " order by ObjectNo desc";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Record";
    doTemp.setKey("SerialNo,AccountMonth,LoanAccount",true);
    doTemp.setColumnAttribute("AccountMonth,CustomerName,LoanAccount","IsFilter","1");
    //doTemp.setCheckFormat("AccountMonth","6");
	doTemp.setVisible("SerialNo",false);
	doTemp.generateFilters(Sqlca);
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
			{"false","","Button","损失识别","损失识别","lossManage()",sResourcesPath},
			{"true","","Button","预测现金流维护","预测现金流维护","my_Input()",sResourcesPath},
			{"true","","Button","单笔提交","单笔提交","my_Singlefinish()",sResourcesPath},
			{"true","","Button","批量提交","批量提交","my_Finish()",sResourcesPath},
			{"true","","Button","单笔撤销","单笔撤销","my_SingleCancel()",sResourcesPath},
			{"true","","Button","批量撤销","批量撤销","my_Cancel()",sResourcesPath},
			{"true","","Button","业务详情","业务详情","viewAndEdit()",sResourcesPath}
		};
	if(CurUser.hasRole("480"))
	{
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
	function lossManage()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		sMClassifyResult = getItemValue(0,getRow(),"MClassifyResultName");
		sBalance = getItemValue(0,getRow(),"Balance");
		sPutoutDate = getItemValue(0,getRow(),"PutoutDate");
		sMaturityDate = getItemValue(0,getRow(),"MaturityDate");
		sVouchType = getItemValue(0,getRow(),"VouchTypeName");

		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择一条信息");
			return;
		}
		PopComp("ReserveLossView","/BusinessManage/ReserveManage/ReserveLossView.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&CustomerName="+sCustomerName+"&Balance="+sBalance+"&PutoutDate="+sPutoutDate+"&MaturityDate="+sMaturityDate+"&MClassifyResult="+sMClassifyResult,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	function my_Input(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if(typeof(sLoanAccount) == "undefined" || sLoanAccount==""){
			 alert("请选择一条信息");
		     return;
		}
		sReturnValue = "";
 		if(sSerialNo == "unInput"){//如果是未预测的记录，向预测表中插入该记录
 		   sReturnValue = PopComp("InsertAction","/BusinessManage/ReserveNullCredit/InsertAction.jsp","LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth,"dialogWidth=20;dialogHeight=9;center:yes;status:no;statusbar:no");
 		   if(sReturnValue == "01"){
 		      alert("数据库操作失败，请与管理员联系");
 		      return;
 		   }
 		}
 		PopComp("CashPreView","/BusinessManage/ReserveNullCredit/CashPreView.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&SerialNo="+sSerialNo+"&Grade=<%=sGrade%>","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
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
				}else if("<%=CurUser.hasRole("480")%>"=="true")
				{
					sReturn="确定将所选记录提交吗？";				
			    }
				if(sSerialNo == "unInput"){
					alert("没有预测现金流，不能提交");
					return;
				}else if(confirm(sReturn))
				{
					var sCondition="<%=sCondition1%>";
		 			sReturnValue = PopComp("CheckInAction","/BusinessManage/ReserveNullCredit/CheckInAction.jsp","SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"dialogWidth=40;dialogHeight=20;center:yes;status:no;statusbar:no");
			 		if(sReturnValue== "99"){
			 			alert("没有通过资料完备性检查，不能提交！");
						return;
					}
					reloadSelf();
					sReturn=PopComp("singleFinishCashPreAction","/BusinessManage/ReserveNullCredit/singleFinishCashPreAction.jsp","SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"","dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
		alert(iCount);
		//return;
		var sReturn="";
		if (iCount>0)
		{			
			if (confirm("确定提交吗？"))
			{
				var sCondition="<%=sCondition1%>";
				/*
		 		sReturnValue = PopComp("CheckInAction","/BusinessManage/ReserveNullCredit/CheckInAction.jsp","Type=<%//=sType%>&rand="+randomNumber(),"dialogWidth=40;dialogHeight=20;center:yes;status:no;statusbar:no");
		 		if(sReturnValue == "01"){
				    alert("数据库检查数据出错，请与管理员联系");
				    return;
				}
			 	if(sReturnValue== "99"){
			 	     alert("没有通过资料完备性检查，不能提交！");
				     return;
				}
				*/	
			 	sReturn=PopComp("FinishCashPreAction","/BusinessManage/ReserveNullCredit/FinishCashPreAction.jsp","Type=<%//=sType%>"+"&RightCondi=<%=sRightCondi%>"+"&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
	//单笔撤销回上一阶段
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
				
				sReturn=PopComp("singleCanclePreAction","/BusinessManage/ReserveNullCredit/singleCanclePreAction.jsp","SerialNo="+sSerialNo+"&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
			 	sReturn=PopComp("CancelCashPreAction","/BusinessManage/ReserveNullCredit/CancelCashPreAction.jsp","Type=<%=sType%>&BusinessFlag=1&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
		var sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sAssetNo = getItemValue(0,getRow(),"AssetNo");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataInfo","/BusinessManage/ReserveDataPrepare/ReserveDataInfo.jsp","AccountMonth="+sAccountMonth+"&AssetNo="+sAssetNo,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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
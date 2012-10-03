<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.08      
		Tester:	
		Content: 新会计准则——公司业务
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "公司业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//存放 sql语句
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sCustomerID==null) sCustomerID="";
	String sCondition = DataConvert.toRealString(iPostChange,(String)request.getParameter("Condition"));
	String sAction = DataConvert.toRealString(iPostChange,(String)request.getParameter("Action"));
	String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("Type"));
	String sCondition1 = "";
	String sRightCondi = "";
	String sEqualRightCondi = "";//用于权限条件的参数传递
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//获取关联客户信息表数据	
	String sHeaders[][] = {
	             {"AccountMonth","会计月份"},
				 {"StatOrgName","支行名称"},
				 {"LoanAccount","贷款账号"},
				 {"ObjectNo","借据编号"},
				 {"CustomerName","客户名称"},
				 {"BusinessSum","贷款金额（元）"},
				 {"Balance","贷款余额（元）"},
				 {"MClassifyResultName","管理五级分类"},
				 {"AClassifyResultName","审计五级分类"},
				 {"PutoutDate","发放日"},
				 {"MaturityDate","到期日"},
				 {"VouchTypeName","主要担保方式"},
				 {"Result1","管户员测算结果"},
				 {"Result2","支行认定结果"},
				 {"Result3","分行认定结果"},
				 {"Result4","总行认定结果"},
				 {"MResult","最终认定结果"},
				 {"AResult","审计结果"}
			};
    sSql = "select  SerialNo, LoanAccount, AccountMonth, getorgname(Statorgid) as StatOrgName, ObjectNo, CustomerName,BusinessSum, Balance," + 
	       " getItemName('ReserveFCResult', MClassifyResult) as MClassifyResultName,MClassifyResult, "+
	       " getItemName('ReserveFCResult', AClassifyResult) as AClassifyResultName,AClassifyResult, "+
	       " PutoutDate,MaturityDate,getItemName('MainVouchType', RR.VouchType) as VouchTypeName, "+
	       " Result1, Result2, Result3, Result4, MResult, AResult " +
	       " from Reserve_Record RR where 1=1 ";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Record";
    doTemp.setKey("SerialNo,AccountMonth,ObjectNo",true);
    doTemp.setColumnAttribute("AccountMonth,CustomerName,ObjectNo","IsFilter","1");
	//doTemp.setFilter(Sqlca,"1","CustomerID","Operators=EqualsNumber,BeginsWith");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//设置在datawindows中显示的行数
	dwTemp.setPageSize(20); //add by hxd in 2005/02/20 for 加快速度
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "1"; 
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("ObjectNo");
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
			{"true","","Button","损失识别","损失识别","lossManage()",sResourcesPath},
			{"true","","Button","预测现金流维护","预测现金流维护","viewCurrence()",sResourcesPath},
			{"true","","Button","单笔提交","单笔提交","my_Singlefinish()",sResourcesPath},
			{"true","","Button","批量提交","批量提交","my_Finish()",sResourcesPath},
			{"true","","Button","单笔撤销","单笔撤销","my_Singlecancel()",sResourcesPath},
			{"true","","Button","批量撤销","批量撤销","my_Cancel()",sResourcesPath},
			{"true","","Button","业务详情","业务详情","viewAndEdit()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	
	function my_Singlefinish(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择一条借据信息！");
		}else
		{
					sReturn = "";
					if (<%=CurUser.hasRight("725")%>)
					{
					   sReturn="确定将所选记录提交到总行认定吗？";
					}
					else if(<%=CurUser.hasRight("735")%>)
					{
						 sReturn="确定将所选记录提交到总行最终认定吗？";
					}else if  (<%=CurUser.hasRight("020")%>)
					{
						 sReturn="确定将所选记录提交吗？";				
					}
					
					if (confirm(sReturn))
					{
					    if(sSerialNo == "unInput"){
					       alert("没有预测现金流，不能提交");
					       return;
					    }
						var sCondition="<%=sCondition1%>";
		 		        sReturnValue = self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ReserveManage/CheckInfoAction.jsp?SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"","dialogWidth=40;dialogHeight=20;center:yes;status:no;statusbar:no");
			 	        if(sReturnValue== "99"){
			 		      alert("没有通过资料完备性检查，不能提交！");
					      return;
				        }

						sReturn=self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ReserveManage/singleFinishCashPredictAction.jsp?SerialNo="+sSerialNo+"&Type=<%=sType%>&rand="+randomNumber(),"","dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
						if (sReturn=="00")
						{
							alert("单笔提交成功");
							window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/InputList.jsp?Action=<%=sAction%>&Type=<%=sType%>&Condition="+sCondition+"&rand="+randomNumber(),"_self","");
						}else
						{
							alert("单笔提交失败");
						}
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
		 		sReturnValue = self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ReserveManage/CheckInfoAction.jsp?Condition="+sCondition+"&RightCondi=<%=sRightCondi%>&Type=<%=sType%>&rand="+randomNumber(),"","dialogWidth=40;dialogHeight=20;center:yes;status:no;statusbar:no");
			 	if(sReturnValue== "99"){
			 	     alert("没有通过资料完备性检查，不能提交！");
				     return;
				}
				if(sReturnValue == "01"){
				    alert("数据库检查数据出错，请与管理员联系");
				    return;
				}
			 	sReturn=self.showModalDialog("<%=sWebRootPath%>/BusinessManage/ReserveManage/FinishCashPredictAction.jsp?Condition="+sCondition+"&RightCondi=<%=sEqualRightCondi%>&Type=<%=sType%>&rand="+randomNumber(),"","dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if (sReturn=="00")
				{
					alert("批量提交成功");
					window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/InputList.jsp?Condition="+sCondition+"&Action=<%=sAction%>&Type=<%=sType%>&rand="+randomNumber(),"_self","");
				}else	
				{
					alert("批量提交失败");
				}
			}
		}else 
		{
		 	alert("没有需要提交的记录");
		}
	}
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		//var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if (typeof(sCustomerID) == "undefined" || sCustomerID.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		
		var sReturn = PopComp("ReserveDataIndInfo","/BusinessManage/ReserveDataPrepare/ReserveDataIndInfo.jsp","","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }
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
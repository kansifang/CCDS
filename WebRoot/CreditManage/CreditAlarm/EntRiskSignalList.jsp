<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: 公司客户预警信号信息_List
		Input Param:			
			CustomerID：客户编号			  
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "公司客户预警信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
		
	//获得组件参数		
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));	
	//将空值转化为空字符串	
	if(sCustomerID == null) sCustomerID = "";
	
	//获得页面参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {							
							{"CustomerName","客户名称"},
							{"SignalName","预警信号"},
							{"SignalType","预警类型"},
							{"SignalStatusName","预警状态"},													
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记时间"}
						};
		
	sSql =  " select ObjectNo,GetCustomerName(ObjectNo) as CustomerName, "+
			" SignalName,getItemName('SignalType',SignalType) as SignalType, "+
			" getItemName('SignalStatus',SignalStatus) as SignalStatusName,SignalStatus, "+
			" GetOrgName(InputOrgID) as InputOrgName,InputUserID, "+
			" GetUserName(InputUserID) as InputUserName,InputDate,SerialNo, "+
			" ObjectType "+
			" from RISK_SIGNAL "+
			" where ObjectType = 'Customer' "+
			" and ObjectNo = '"+sCustomerID+"' "+
			" and SignalType = '01' ";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,SignalStatus,InputUserID",false);
	//设置格式
	doTemp.setHTMLStyle("CustomerName","style={width:200px}");
	doTemp.setHTMLStyle("SignalName","style={width:250px}");
	
	doTemp.setAlign("SignalType,SignalStatusName","2");
	//设置过滤器
	doTemp.setColumnAttribute("SignalName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},			
			{"true","","Button","详情","查看/修改预警信号详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"true","","Button","提交","提交所选中的记录","commitRecord()",sResourcesPath}		
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{		
		OpenPage("/CreditManage/CreditAlarm/EntRiskSignalInfo.jsp?EditRight=02","_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSignalStatus = getItemValue(0,getRow(),"SignalStatus");
		sUserID = getItemValue(0,getRow(),"InputUserID");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}else if(sUserID=='<%=CurUser.UserID%>' && sSignalStatus == '10')
		{			
			if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
			{
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}			
		}else alert(getHtmlMessage('3'));	
	}
			
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSignalStatus = getItemValue(0,getRow(),"SignalStatus");//--预警状态
		sUserID = getItemValue(0,getRow(),"InputUserID");//--用户代码
		if(sUserID=='<%=CurUser.UserID%>' && sSignalStatus == '10')
			sEditRight='02';
		else
			sEditRight='01';
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		
		OpenPage("/CreditManage/CreditAlarm/EntRiskSignalInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight,"_self","");
	}
	
	/*~[Describe=提交记录;InputParam=无;OutPutParam=无;]~*/
	function commitRecord()
	{
		sSignalStatus = getItemValue(0,getRow(),"SignalStatus");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		
		if(sSignalStatus == '10')
		{	
			if(confirm(getHtmlMessage('17'))) //确信需要提交该记录吗？
		    {
				//提交操作
				sReturn = RunMethod("PublicMethod","UpdateColValue","String@SignalStatus@20,RISK_SIGNAL,String@SerialNo@"+sSerialNo);
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
					alert(getHtmlMessage('9'));//提交失败！
					return;
				}else
				{
					alert("已经提交风险预警认定员认定");
					reloadSelf();
					alert(getHtmlMessage('18'));//提交成功！
				}				
		   	}
		}else alert(getHtmlMessage('28'));//已经提交的信息不能再次提交！
	}
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

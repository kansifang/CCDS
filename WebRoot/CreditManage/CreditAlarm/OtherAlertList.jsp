<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zrli 2008-08-27
		Tester:
		Content: 显示由批量接口生成的提示数据
		Input Param:			
			Days：	   
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "批量接口生成的提示数据"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
		
	//获得组件参数		
	String sAlarmType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AlarmType"));	
	//将空值转化为空字符串	
	if(sAlarmType == null) sAlarmType = "";	
	//获得页面参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//列表表头
	String sHeaders[][] = {
							{"ObjectNo","对象编号"},
							{"ObjectType","对象类型"},
							{"SerialNo","提示流水号"},													
							{"AlarmType","提示类型"},
							{"Status","状态"},
							{"Channel","渠道"},
							{"Attribute2","属性二"},
							{"Attribute3","属性三"},
							{"Remark","备注"},
							{"InputUserID","登记人"},												
							{"InputOrgID","登记机构"},
							{"InputTime","登记时间"},
							{"UpdateUserID","更新人"},
							{"UpdateTime","更新时间"}
						};
	sSql = 	" select ObjectNo,ObjectType, "+
			" SerialNo, "+
			" AlarmType,Status, "+
			" Channel,Attribute2,Attribute3, "+
			" Remark,getUserName(InputUserID) as InputUserID,InputOrgID,InputTime,UpdateUserID,UpdateTime"+
			" from Alarm_Generate " + 
			" where AlarmType='"+sAlarmType+"' and Status = '010' "+
			" and InputOrgID = '"+CurOrg.OrgID+"' ";
	//存货下降30%以上预警
	String sHeaders1[][] = {
							{"ObjectNo","客户编号"},
							{"ObjectType","对象类型"},
							{"SerialNo","提示流水号"},													
							{"AlarmType","提示类型"},
							{"Status","状态"},
							{"Channel","渠道"},
							{"Attribute2","属性二"},
							{"Attribute3","属性三"},
							{"Remark","备注"},
							{"InputUserID","登记人"},												
							{"InputOrgID","提示登记机构"},
							{"InputTime","提示登记时间"},
							{"UpdateUserID","更新人"},
							{"UpdateTime","更新时间"}
						};
	String sSql1 = 	" select ObjectNo,ObjectType, "+
			" SerialNo, "+
			" AlarmType,Status, "+
			" Channel,Attribute2,Attribute3, "+
			" Remark,getUserName(InputUserID) as InputUserID,InputOrgID,InputTime,UpdateUserID,UpdateTime"+
			" from Alarm_Generate " + 
			" where AlarmType='"+sAlarmType+"' and Status = '010' "+
			" and InputOrgID = '"+CurOrg.OrgID+"' ";
		
									
     //抵押物
	if(sAlarmType.equals("170")){
		sSql=sSql1;
		sHeaders=sHeaders1;
	//存单
	}else  if(sAlarmType.equals("020")){
		sSql=sSql1;
		sHeaders=sHeaders1;  
	//营业执照
	}
					
	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "Alarm_Generate";
	doTemp.setKey("SerialNo",true);
	//定义列表表头
	doTemp.setHeader(sHeaders);
	
	//设置格式
	doTemp.setVisible("ObjectType,SerialNo,AlarmType,Status,Attribute2,Attribute3,Remark,InputOrgID,UpdateUserID,UpdateTime",false);
	
	//设置过滤器
	doTemp.setColumnAttribute("ObjectNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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
			{"true","","Button","相关业务详情","相关业务详情","viewDetail()",sResourcesPath},
			{"true","","Button","删除","删除提示","deleteRecord()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------	
	/*~[Describe=相关业务详情;InputParam=无;OutPutParam=无;]~*/
	function viewDetail()
	{
		sAlarmType="<%=sAlarmType%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");	
		sAttribute2 = getItemValue(0,getRow(),"Attribute2");
		sAttribute3 = getItemValue(0,getRow(),"Attribute3");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//如果是抵押物信息
		if(sAlarmType=='010'){
			OpenPage("/CreditManage/GuarantyManage/PawnInfo.jsp?GuarantyStatus=02&GuarantyID="+sObjectNo+"&PawnType="+sAttribute2,"_self");
		}else if(sAlarmType=='020'){
			OpenPage("/CreditManage/GuarantyManage/ImpawnInfo.jsp?GuarantyStatus=02&GuarantyID="+sObjectNo+"&ImpawnType="+sAttribute2,"_self");
		}else if(sAlarmType=='030'){
			openObject("Customer",sObjectNo,"002");
		}else if(sAlarmType=='040'){
			OpenPage("/RecoveryManage/DunManage/DunInfo.jsp?SerialNo="+sObjectNo,"_self","");
		}else if(sAlarmType=='050'){			
			openObject("LawCase",sObjectNo,"002");
		}else if(sAlarmType=='060'){			
			openObject("LawCase",sObjectNo,"002");
		}else if(sAlarmType=='070'||sAlarmType=='080'){			
			openObject("BusinessContract",sObjectNo,"002");
		}
		
	}
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
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
	my_load(2,0,'myiframe0');

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

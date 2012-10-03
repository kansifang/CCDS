<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*   
		Author:   hxli 2005.8.11
		Tester:
		Content: 重组方案列表
		Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：补登中的重组方案列表			          
		Output param:
				SerialNo   : 重组申请序列号
				
		History Log: 		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "重组方案列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	String sComponentName = "";
	String PG_CONTENT_TITLE = "";
	
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		
	//定义显示标题
	String sHeaders[][] = { 							
								{"SerialNo","重组方案流水号"},
								{"ApplyType","重组贷款类型"},
								{"ApplyTypeName","重组贷款类型"},
								{"ProjectName","拟重组借款人"},
								{"BusinessSum","拟重组本金"},
								{"PaymentDate","拟重组期限"},
								{"InputUserName","登记人"},
								{"InputOrgName","登记机构"},
								{"InputDate","登记日期"}
							}; 
	
	//从申请信息表BUSINESS_APPLY中选出重组方案列表(经办人为当前用户、经办机构为当前机构、业务品种为6010)
	sSql =  " select SerialNo,ApplyType,"+
			" getItemName('ReformType',ApplyType) as ApplyTypeName,ProjectName," +	
			" BusinessSum,PaymentDate, " +	
			" getUserName(InputUserID) as InputUserName,getOrgName(InputOrgID) as InputOrgName,InputDate" +	
			" from BUSINESS_APPLY  " +
			" where  OperateUserID = '"+CurUser.UserID+"' " +
			" and  OperateOrgID = '"+CurOrg.OrgID+"' " +
			" and BusinessType = '6010' "+
			" order by SerialNo desc " ;
			
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_APPLY";	
	//设置关键字
	doTemp.setKey("SerialNo",true);	 
	//设置不可见项
	doTemp.setVisible("ApplyType,FlowNo,PhaseNo",false);
	//设置下拉框
	doTemp.setDDDWCode("ApplyType","ReformType");
	//设置字段显示宽度
	doTemp.setHTMLStyle("ApplyTypeName,ProjectName,BusinessSum,PaymentDate"," style={width:100px} ");
	doTemp.setHTMLStyle("PaymentDate,"," style={width:80px} ");
	doTemp.setHTMLStyle("ProjectName,"," style={width:120px} ");
	doTemp.setUpdateable("ApplyTypeName",false); 
	
	//设置对齐方式
	doTemp.setAlign("BusinessSum","3");
	doTemp.setType("BusinessSum","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum","2");
	
	//生成查询框
	doTemp.setColumnAttribute("ApplyType,ProjectName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页
	
	//删除重组方案附属信息
	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteBusiness(NPAReformApply,#SerialNo,DeleteBusiness)");
	
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
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{		
		sCompID = "NPAReformApply";
		sCompURL = "/RecoveryManage/RMApply/NPAReformCreationInfo.jsp";			
		sReturn = PopComp(sCompID,sCompURL,"","dialogWidth=30;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sReturn == "" || sReturn == "_CANCEL_" || typeof(sReturn) == "undefined") return;
		var sObjectNo = sReturn;  //申请编号
		openObject("NPAReformApply",sObjectNo,"001");
		reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,APPLY_RELATIVE,String@ObjectType@NPARefromApply@String@ObjectNo@"+sSerialNo);
			if (typeof(sReturn) != "undefined" && sReturn.length != 0)
			{
				alert("该重组方案已经与申请业务建立了关联关系，不能删除！");  
				return;
			}else
			{
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//申请流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");			
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		openObject("NPAReformApply",sSerialNo,"001");
		reloadSelf();
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

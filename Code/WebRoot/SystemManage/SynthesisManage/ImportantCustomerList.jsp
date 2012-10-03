<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:wangdw
		Tester:
		Describe: 重点客户管理
		Input Param:
		Output Param:
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "重点客户管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量：SQL语句
	String sSql = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = { 			                   
			                    {"CustomerName","客户名称"},						      
						        {"UserName","登记人"},
						        {"OrgName","登记机构"},
						        {"CustomerID","客户编号"},
						        {"LOANCARDNO","贷款账号"},
						        {"PlatformType_name","平台类型"},
						        {"PlatformType","平台类型"},
						        {"PLATFORMLEVEL_name","平台级别"},
						        {"PLATFORMLEVEL","平台级别"},
						        {"PLATFORMPROPERTY_name","平台性质"},
						        {"PLATFORMPROPERTY","平台性质"},
						        {"UpdateDate","更新日期"}
			               };   				   		
		   		
	
	sSql = " select SerialNo,CustomerName,nvl(CustomerID,'') as CustomerID,LOANCARDNO,InputOrgID,"
    		+"getItemName('PlatformLevel',PLATFORMLEVEL) as PLATFORMLEVEL_name,"
		    +"PLATFORMLEVEL,"
			+"getItemName('PlatformType',PlatformType) as PlatformType_name,"
			+"PlatformType,"
			+"getItemName('PlatfromProperty',PLATFORMPROPERTY) as PLATFORMPROPERTY_name, "
			+"PLATFORMPROPERTY,"
            +" getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName,"
           +"UpdateDate "+
		   " from CUSTOMER_IMPORTANT where 1=1 order by InputOrgID ";
	              
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "CUSTOMER_IMPORTANT";
	//设置主键
	doTemp.setKey("SerialNo",true);
	//设置字段的不可见
	doTemp.setVisible("SerialNo,InputOrgID,InputUserID,PLATFORMLEVEL,PLATFORMPROPERTY,PlatformType",false);
	//置字段是否可更新，主要是外部函数产生的，类似UserName\OrgName	    
	doTemp.setUpdateable("UserName,OrgName,Resouce",false);
	doTemp.setDDDWSql("PlatformType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'PlatformType'");
	doTemp.setDDDWSql("PLATFORMLEVEL","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'PlatformLevel'");
	doTemp.setDDDWSql("PLATFORMPROPERTY","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'PlatfromProperty'");
	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","LOANCARDNO","");
	//doTemp.setFilter(Sqlca,"3","PlatformType","");
	doTemp.setFilter(Sqlca,"3","PLATFORMLEVEL","");
	doTemp.setFilter(Sqlca,"4","PLATFORMPROPERTY","");
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	//dwTemp.setEvent("BeforeDelete","!CustomerManage.InsertHistoryInfoLog(#SerialNo,"+CurUser.UserID+",ChangeFinancePlatFormList)");
	dwTemp.setEvent("AfterDelete","!PublicMethod.UpdateColValue(String@ImportantFlag@None,ENT_INFO,String@CUSTOMERID@#CustomerID)");
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
		   {((CurUser.hasRole("097"))?"false":"true"),"","Button","新增","新增","my_add()",sResourcesPath},
		   {"true","","Button","详情","查看融资平台详情","viewAndEdit()",sResourcesPath},
		   {((CurUser.hasRole("097"))?"false":"true"),"","Button","删除","删除","deleteRecord()",sResourcesPath},
		  // {"true","","Button","历史记录查询","查看关联方更改情况","viewHistory()",sResourcesPath}
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
	function my_add()
	{ 	 
	    OpenPage("/SystemManage/SynthesisManage/ImportantCustomerInfo.jsp","_self","");
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

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/SystemManage/SynthesisManage/ImportantCustomerInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}
	
	
	function viewHistory()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");//--流水号
		//popComp("FinancePlatFormHistoryList","/SystemManage/SynthesisManage/FinancePlatFormHistoryList.jsp","SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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

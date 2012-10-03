<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:hldu
		Tester:
		Describe: 本行认可中介机构管理
		Input Param:
	              --sComponentName:组件名称
		Output Param:
		
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "本行认可中介机构管理信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));

	if(sSerialNo == null||"undefined".equals(sSerialNo)) sSerialNo = "";
	//定义变量
	String sSql="";//--存放sql语句
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = { 
							{"Attribute1","中介机构编号"},
		                    {"CustomerName","中介机构名称"},
		                    {"AuditOrgTypeName","中介机构类型"},
		                    {"EffectStartDate","有效起始日期"},
		                    {"EffectFinishDate","有效截止日期"},
							{"UpdateOrgName","更新机构"},
                            {"UpdateUser","更新人"},
                            {"UpdateDate","更新时间"}						  
                          };   		   		
	
 	  if(sSerialNo=="" )
    {
   		sSql = " select Attribute1,CustomerName,getItemName('AuditOrgType',AuditOrgType) as AuditOrgTypeName,EffectStartDate,EffectFinishDate,getOrgName(UpdateOrg) as UpdateOrgName,getUserName(UpdateUser) as UpdateUser,UpdateDate "+
		 		" from CUSTOMER_SPECIALLOG  where InstertType = 'ChangeAuditList' order by UpdateDate ";
    	
    }else
    {
    	
		sSql = " select Attribute1,CustomerName,getItemName('AuditOrgType',AuditOrgType) as AuditOrgTypeName,EffectStartDate,EffectFinishDate,getOrgName(UpdateOrg) as UpdateOrgName,getUserName(UpdateUser) as UpdateUser,UpdateDate "+
	  		   " from CUSTOMER_SPECIALLOG  where SerialNo ='"+sSerialNo+"' order by UpdateDate "; 
    }
 					 
  	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "CUSTOMER_SPECIALLOG";
	doTemp.setKey("SerialNo",true);		
	//设置币种下拉框内容
	//doTemp.setDDDWCode("Currency","Currency");
	//设置显示类型为数据型
//doTemp.setType("Rate","Number");//by jgao1 2008-10-20
	//生成查询条件
	//增加过滤器
	doTemp.setColumnAttribute(" ","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
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
			{"false","","Button","详情","查看基准利率情况","viewAndEdit()",sResourcesPath},
			{"false","","Button","历史记录查询","查看基准利率情况","viewHistory()",sResourcesPath},
			{"false","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
	    sRateID   = getItemValue(0,getRow(),"RateID");//--流水号
		if (typeof(sRateID)=="undefined" || sRateID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/SystemManage/SynthesisManage/RateInfo.jsp?RateID="+sRateID, "_self","");
		}
	}
	
	function viewHistory()
	{
		sRateID   = getItemValue(0,getRow(),"RateID");//--流水号
		if (typeof(sRateID)=="undefined" || sRateID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/SystemManage/SynthesisManage/RateInfo.jsp?RateID="+sRateID, "_self","");
		}
	}
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/AuditOrgList.jsp","_self","");
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

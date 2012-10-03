<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: pliu 2011-12-02
		Tester:
		Describe: 公司规模参数设定
		Input Param:
	              --sComponentName:组件名称
		Output Param:
		
		HistoryLog: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "企业规模参数设定控制"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";//--存放sql语句
	String sComponentName;//--组件名称
	String sArgumentType;
	String sArgumentType1="";
	String PG_CONTENT_TITLE;
	//获得页面参数	
	
	//获得组件参数	
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
	sArgumentType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ArgumentType"));
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";	
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = { 		
								{"SerialNo","流水号"},		                   
			                    {"ArgumentType","参数类型"},	
			                    {"IndustryName","企业分类"},
			                    {"GuideName","指标名称"},
			                    {"ExtraSmallType","微型企业"},
			                    {"SmallType","小型企业"},
			                    {"MediumType","中型企业"},
			                    {"LargeType","大型企业"},
						        {"InputUserName","登记人员"},
						        {"InputDate","登记日期"},
						        {"InputOrgName","登记机构"},
						        {"UpdateUserName","更新人员"},
						        {"UpdateDate","更新日期"},
						        {"UpdateOrgName","更新机构"}
			               };   				   		
		   		
    //如果是公职人员担保贷款行业管理
    if(sArgumentType.equals("001")){
    	sArgumentType1="IndustryList";
    //基准利率
    }
	sSql = " select SerialNo,ArgumentType,getItemName('IndustryName',IndustryName) as IndustryName,getItemName('GuideTitle',GuideName) as GuideName,ExtraSmallType,SmallType,MediumType,LargeType, "+
		   " getUserName(InputUser) as "+
		   " InputUserName,InputDate,getOrgName(InputOrg) as InputOrgName,getUserName(UpdateUser) as "+
		   " UpdateUserName,UpdateDate,getOrgName(UpdateOrg) as UpdateOrgName from INDUSTRY_CFG "+	            
		   " where ArgumentType='"+sArgumentType+"' ";
	              
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "INDUSTRY_CFG";
	//设置主键
	doTemp.setKey("SerialNo",true);
	//设置字段的不可见
	doTemp.setVisible("SerialNo,ArgumentType,ArgumentModelName,ArgumentValue",false);
	//设置number列
	doTemp.setCheckFormat("ArgumentValue","16");
	//置字段是否可更新，主要是外部函数产生的，类似UserName\OrgName	    
	doTemp.setUpdateable("ArgumentModelDes,InputUserName,InputOrgName,UpdateUserName,UpdateOrgName ",false);
	//设置html格式
	doTemp.setHTMLStyle("ArgumentModelName"," style={width:250px} ondblclick=\"javascript:parent.viewAndEdit()\"");
	doTemp.setHTMLStyle("ArgumentModelDes"," style={width:250px} ");
	
	//生成查询条件
	doTemp.generateFilters(Sqlca);
	//doTemp.setFilter(Sqlca,"1","ArgumentModel","");
	
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
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
		   {((CurUser.hasRole("097"))?"false":"true"),"","Button","新增","新增","my_add()",sResourcesPath},
		   {((CurUser.hasRole("097"))?"false":"true"),"","Button","删除","删除","deleteRecord()",sResourcesPath},
		   {"true","","Button","详情","查看详情","viewAndEdit()",sResourcesPath}
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
	    sArgumentType="<%=sArgumentType%>";
	    OpenPage("/SystemManage/ParameterManage/IndustryJudgeInfo.jsp?ArgumentType="+sArgumentType,"_self","");
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
		sArgumentModel = getItemValue(0,getRow(),"ArgumentModel");
		sFlag = "Info";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/SystemManage/ParameterManage/IndustryJudgeInfo.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag+"&ArgumentModel="+sArgumentModel, "_self","");
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

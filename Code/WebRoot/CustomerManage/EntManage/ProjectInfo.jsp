<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --fbkang 2005-7-26 
		Tester:
		Describe: --项目基本信息
		Input Param:
			ProjectNo：--当前项目编号
			
		Output Param:
			ProjectNo：--当前项目编号

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "项目基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";//--存放sql语句
	String sProjectType="",sTempSaveFlag="";//--项目类型
	String sTempletNo = "ProjectInfo";//--模板类型
	ASResultSet rs=null;
	//获得组件参数，项目编号
	String sProjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	String sObjectNo     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	//获得页面参数	

	//获得项目类型
	sSql = "select ProjectType,TempSaveFlag  from PROJECT_INFO where ProjectNo='"+sProjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		
	   sProjectType =DataConvert.toString(rs.getString("ProjectType"));//--项目类型
	   sTempSaveFlag = DataConvert.toString(rs.getString("TempSaveFlag"));//--项目类型
	}
	rs.getStatement().close(); 
	if(sProjectType == null ) sProjectType = "";
	if(sTempSaveFlag == null ) sTempSaveFlag = "";
	
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletFilter="  ColAttribute like '%"+sProjectType+"%'";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.setHTMLStyle("InputOrgName","style={width=250px}");
	//自动计算项目资本金比例(%)
	doTemp.setHTMLStyle("PlanTotalCast,ProjectCapital"," onchange=parent.getCapitalScale() ");
	//设置计划总投资(元)范围
	doTemp.appendHTMLStyle("PlanTotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"计划总投资(元)必须大于等于0！\" ");
	//设置固定资产投资(元)范围
	doTemp.appendHTMLStyle("CapitalAssertsCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"固定资产投资(元)必须大于等于0！\" ");
	//设置铺底流动资金(元)范围
	doTemp.appendHTMLStyle("Fund"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"铺底流动资金(元)必须大于等于0！\" ");
	//设置项目资本金(元)范围
	doTemp.appendHTMLStyle("ProjectCapital"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"项目资本金(元)必须大于等于0！\" ");
	//设置总建设期数范围
	doTemp.appendHTMLStyle("ConstructTimes"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"总建设期数必须大于等于0！\" ");
	//设置拆迁、补偿费(元)范围
	doTemp.appendHTMLStyle("Sum1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"拆迁、补偿费(元)必须大于等于0！\" ");
	//设置土地配套费用(元)范围
	doTemp.appendHTMLStyle("Sum2"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"土地配套费用(元)必须大于等于0！\" ");
	//设置土地直接出让成本投入(元)范围
	doTemp.appendHTMLStyle("Sum3"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"土地直接出让成本投入(元)必须大于等于0！\" ");
	//设置目前周边土地价格(元)范围
	doTemp.appendHTMLStyle("Sum4"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"目前周边土地价格(元)必须大于等于0！\" ");
	//设置土地开发项目预计销售价格(元)范围
	doTemp.appendHTMLStyle("Sum5"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"土地开发项目预计销售价格(元)必须大于等于0！\" ");
	//设置目前土地储备中心现有土地估算价值(元)范围
	doTemp.appendHTMLStyle("Sum6"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"目前土地储备中心现有土地估算价值(元)必须大于等于0！\" ");
	//设置土地开发项目我行贷款(元)范围
	doTemp.appendHTMLStyle("Sum7"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"土地开发项目我行贷款(元)必须大于等于0！\" ");
	//设置目前拥有土地数量(元)范围
	doTemp.appendHTMLStyle("Sum8"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"目前拥有土地数量(元)必须大于等于0！\" ");
	//设置目前拥有土地估计销售价值(元)范围
	doTemp.appendHTMLStyle("Sum9"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"目前拥有土地估计销售价值(元)必须大于等于0！\" ");
	//设置占地面积(平方米)范围
	doTemp.appendHTMLStyle("HoldArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"占地面积(平方米)必须大于等于0！\" ");
	//设置总建筑面积(平方米)范围
	doTemp.appendHTMLStyle("BuildArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"总建筑面积(平方米)必须大于等于0！\" ");
	//设置联建单位所分配房屋面积(平方米)范围
	doTemp.appendHTMLStyle("CoDistribute"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"联建单位所分配房屋面积(平方米)必须大于等于0！\" ");
	//设置还建面积(平方米)范围
	doTemp.appendHTMLStyle("RebuildArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"还建面积(平方米)必须大于等于0！\" ");
	//设置自营面积(平方米)范围
	doTemp.appendHTMLStyle("HomeArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"自营面积(平方米)必须大于等于0！\" ");
	//设置住宅面积(平方米)范围
	doTemp.appendHTMLStyle("HouseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"住宅面积(平方米)必须大于等于0！\" ");
	//设置商铺面积(平方米)范围
	doTemp.appendHTMLStyle("EmporiumArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"商铺面积(平方米)必须大于等于0！\" ");
	//设置写字间面积(平方米)范围
	doTemp.appendHTMLStyle("ScriptoriumArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"写字间面积(平方米)必须大于等于0！\" ");
	//设置车库面积(平方米)范围
	doTemp.appendHTMLStyle("CarportArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"车库面积(平方米)必须大于等于0！\" ");
	//设置其它面积(平方米)范围
	doTemp.appendHTMLStyle("OtherArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"其它面积(平方米)必须大于等于0！\" ");
	//设置总地价(元)范围
	doTemp.appendHTMLStyle("TotalLandValue"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"总地价(元)必须大于等于0！\" ");
	//设置项目容积率(%)范围
	doTemp.appendHTMLStyle("DimensionRadio"," myvalid=\"parseFloat(myobj.value,10)>=0  \" mymsg=\"项目容积率(%)大于等于0!\" ");
	//设置项目绿化率(%)范围
	doTemp.appendHTMLStyle("VirescenceRadio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"项目绿化率(%)的范围为[0,100]\" ");
	//设置计划总投资(元)范围
	doTemp.appendHTMLStyle("PlanTotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"计划总投资(元)必须大于等于0！\" ");
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//设置setEvent
	//设置插入和更新事件
    dwTemp.setEvent("AfterUpdate","!ProjectManage.AddProjectRelative(#ProjectNo,"+sObjectType+",#ObjectNo)");
   
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{sTempSaveFlag.equals("2")?"false":"true","","Button","暂存","暂时保存所有修改内容","saveRecordTemp()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{		
		//录入数据有效性检查
		if (!ValidityCheck()) return;	
		if(bIsInsert){
			beforeInsert();
		}
		setItemValue(0,getRow(),'TempSaveFlag',"2");//暂存标志（1：是；2：否）
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
		
	/*~[Describe=计算项目资本金比例;InputParam=无;OutPutParam=无;]~*/
	function getCapitalScale()
	{
		//计划总投资(元)
		sPlanTotalCast = getItemValue(0,getRow(),"PlanTotalCast");//--计划总投资
		if(typeof(sPlanTotalCast) == "undefined" || sPlanTotalCast.length == 0)
			sPlanTotalCast=1;
		
		//项目资本金(元)
		sProjectCapital = getItemValue(0,getRow(),"ProjectCapital");//--项目资本金
		if(typeof(sProjectCapital) == "undefined" || sProjectCapital.length == 0)
			sProjectCapital=0;
		
		//项目资本金比例（％）
		sProjectCapitalScale = Math.round(sProjectCapital/sPlanTotalCast*100);//--项目资金比例
		if(sProjectCapitalScale >= 0){
		   setItemValue(0,getRow(),"CapitalScale",sProjectCapitalScale);
		 }
		 else{//否则置为0
		   setItemValue(0,getRow(),"CapitalScale",0);
		 }

	}
	
	/*~[Describe=选择国标行业类型;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType()
	{

		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
			sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");		
	}
	
	function saveRecordTemp()
	{
		//0：表示第一个dw
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（1：是；2：否）
		as_save("myiframe0");   //再暂存
		setNeedCheckRequired(0);//最后再将必输项设置回来	
	}


	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ProjectNo","<%=sProjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"TempSaveFlag","1");//是否标志（1：是；2：否）
		
			bIsInsert = true;
		}
    }
    
    /*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		//检查开工日期和计划竣工日期的有效性
		sBeginBuildDate = getItemValue(0,getRow(),"BeginBuildDate");//--开始日期
		sExpectCompleteDate = getItemValue(0,getRow(),"ExpectCompleteDate");//--计划竣工日期
		if(typeof(sBeginBuildDate) != "undefined" && sBeginBuildDate != "" && 
		typeof(sExpectCompleteDate) != "undefined" && sExpectCompleteDate != "")
		{
			if(sExpectCompleteDate <= sBeginBuildDate)
			{
				alert(getBusinessMessage('153'));//计划竣工日期必须晚于开工日期！
				return false;
			}
		}
		
		//检查开工日期和竣工日期的有效性
		sExpectProductDate = getItemValue(0,getRow(),"ExpectProductDate");//--竣工日期
		if(typeof(sBeginBuildDate) != "undefined" && sBeginBuildDate != "" && 
		typeof(sExpectProductDate) != "undefined" && sExpectProductDate != "")
		{
			if(sExpectProductDate <= sBeginBuildDate)
			{
				alert(getBusinessMessage('154'));//竣工日期必须晚于开工日期！
				return false;
			}
		}
		
		//校验联建单位组织机构代码是否符合编码规则
		sCopartnerID = getItemValue(0,getRow(),"CopartnerID");//--联建单位组织机构代码
		if(typeof(sCopartnerID) != "undefined" && sCopartnerID != "" )
		{
			if(!CheckORG(sCopartnerID))
			{
				alert(getBusinessMessage('102'));//组织机构代码有误！						
				return false;
			}
		}
		
		return true;
	}
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

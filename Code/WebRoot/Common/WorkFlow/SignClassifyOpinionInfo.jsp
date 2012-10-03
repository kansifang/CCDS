<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:  xhyong 2009/08/19 
	Tester:
	Content: 风险分类认定签署意见
	Input Param:
		SerialNo 任务流水号
		ObjectNo 申请流水号
		ObjectType 申请类型
		CSerialNo 合同流水号
		CustomerID 客户ID
	Output param:
	History Log: 
	
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "风险分类认定签署意见";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	//定义参数:显示模板编号、首次发放日、客户类型、模型分类结果、Sql语句、查询结果集
	String sTempletNo = "";
	String sOriginalPutOutDate = "",sCustomerType = "",sResult1 = "";
	String sClassifyLevel1 = "",sClassifyLevel2 = "",sphasechoice = "", sphasechoice2 = "";
	String sCustomerName = "";
	String sSql = "";
	ASResultSet rs = null;
	//获取组件参数：任务流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sCSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CSerialNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sClassifyLevel = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassifyLevel"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sCSerialNo == null) sCSerialNo = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
	sSql = " select PhaseOpinion1,PhaseOpinion5 from Flow_opinion where serialNo in(select serialno from flow_task "+
	" where objectno = '"+sObjectNo+"' and objecttype = 'ClassifyApply' and Phaseno = '0020')";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sphasechoice = DataConvert.toString(rs.getString("PhaseOpinion1"));
		sphasechoice2 = DataConvert.toString(rs.getString("PhaseOpinion5"));
				
		//将空值转化成空字符串
		if(sphasechoice == null) sphasechoice = "";	
		if(sphasechoice2 == null) sphasechoice2 = "";	
	}
	rs.getStatement().close(); 
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	
	sTempletNo = "SignClassifyOpinionInfo";
		
	//按合同进行风险分类，获得首次发放日
	sSql = " select min(PUTOUTDATE) from BUSINESS_DUEBILL where RelativeSerialNo2 = '"+sCSerialNo+"' ";
	sOriginalPutOutDate = Sqlca.getString(sSql);
	if(sOriginalPutOutDate == null) sOriginalPutOutDate = "";
	
	//获得客户类型
	sSql = " select CustomerType,CustomerName from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerType = DataConvert.toString(rs.getString("CustomerType"));
		sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
				
		//将空值转化成空字符串
		if(sCustomerType == null) sCustomerType = "";
		if(sCustomerName == null) sCustomerName = "";
	}
	rs.getStatement().close(); 
	
	sCustomerType = Sqlca.getString(sSql);
	if(sCustomerType == null) sCustomerType = "";
	
	//获得申请相关信息:初分结果
	sSql = 	" select Result1,ClassifyLevel,ClassifyLevel2 "+
			" from CLASSIFY_RECORD "+
			" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sResult1 = rs.getString("Result1");
		sClassifyLevel1 = rs.getString("ClassifyLevel");
		sClassifyLevel2 = rs.getString("ClassifyLevel2");
		//将空值转化为空字符串
		if(sResult1 == null) sResult1 = "";
		if(sClassifyLevel1 == null) sClassifyLevel1 = "";
		if(sClassifyLevel2 == null) sClassifyLevel2 = "";
	}
	rs.getStatement().close();
	
	//通过显示模板产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//设置下拉框
	if(sCustomerType.substring(0,2).equals("01"))//公司客户使用10级分类
	{
		doTemp.setDDDWSql("PhaseOpinion1,PhaseOpinion5","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)=4 order by SortNo ");
	}else{
		doTemp.setDDDWSql("PhaseOpinion1,PhaseOpinion5","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)=2 order by SortNo ");
	}
	
	if("0010".equals(sPhaseNo) || "0020".equals(sPhaseNo)){
		doTemp.setVisible("phasechoice,phasechoice2",false);
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//定义后续事件

	//生成HTMLDataWindow
	//classify_record表的主键为SerialNo、ObjectType、ObjectNo的联合主键，为确保逻辑准确，增加传入参数，同时修改对应显示模板
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sObjectNo+","+sObjectType);
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
			{"true","","Button","删除","删除意见","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language="javascript">

	/*~[Describe=保存签署的意见;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		sObjectNo = "<%=sObjectNo%>";
		sObjectType = "<%=sObjectType%>";
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");	
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			var sTaskNo = "<%=sSerialNo%>";
			var sReturn = RunMethod("WorkFlowEngine","CheckOpinionInfo",sTaskNo);
			if(!(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn == "Null" || sReturn == "null" || sReturn == "NULL")){
				alert("此笔业务已签署意见，请刷新页面再签署意见！");
				return;
			}
			initOpinionNo();
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        sPhaseOpinion1 = getItemValue(0,getRow(),"PhaseOpinion1");
        if("<%=sPhaseNo%>"=="0010")
        {
        	sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@Result2@"+sPhaseOpinion1+",CLASSIFY_RECORD,String@SerialNo@<%=sObjectNo%>");
        }
        if("<%=sPhaseNo%>"=="0020"){
        	if(sPhaseOpinion1 < "<%=sClassifyLevel1%>"){
        		if(!confirm("您选择的分类认定结果（账面）高于客户经理风险分类结果(账面)，是否继续?")){
        			setItemValue(0,0,"PhaseOpinion1","");
        			return;
        		}
        	}
        }
        if("<%=sPhaseNo%>"=="0050"){
        	if(sPhaseOpinion1 < "<%=sphasechoice%>"){
        		if(!confirm("您选择的分类认定结果（账面）高于复核员风险分类结果(账面)，是否继续?")){
        			setItemValue(0,0,"PhaseOpinion1","");
        			return ;
        		}
        	}
        }
        
		as_save("myiframe0");
	}
	
	/*~[Describe=删除意见;InputParam=无;OutPutParam=无;]~*/
    function deleteRecord()
    {
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
	 	{
	   		alert("您还没有签署意见，不能做删除意见操作！");
	 	}
	 	else if(confirm("你确实要删除意见吗？"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("意见删除成功!");
	  		}
	   		else
	   		{
	    		alert("意见删除失败！");
	   		}
		}
		reloadSelf();
	} 
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initOpinionNo() 
	{
		var sTableName = "FLOW_OPINION";//表名
		var sColumnName = "OpinionNo";//字段名
		var sPrefix = "";//无前缀
								
		//使用GetSerialNo.jsp来抢占一个流水号
		var sOpinionNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sOpinionNo);
	}
	
	/*~[Describe=插入一条新记录;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		//如果没有找到对应记录，则新增一条，并可以设置字段默认值
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"OriginalPutOutDate","<%=sOriginalPutOutDate%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"PhaseOpinion2","<%=sResult1%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"CustomerID","<%=sCustomerID%>");
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");
		}
		setItemValue(0,0,"OriginalPutOutDate","<%=sOriginalPutOutDate%>");      
		setItemValue(0,getRow(),"phasechoice","<%=sphasechoice%>");
		setItemValue(0,getRow(),"phasechoice2","<%=sphasechoice2%>");
		setItemValue(0,getRow(),"PhaseOpinion3","<%=sClassifyLevel1%>");
		setItemValue(0,getRow(),"PhaseOpinion4","<%=sClassifyLevel2%>");
	}

	</script>
<%/*~END~*/%>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%@ include file="/IncludeEnd.jsp"%>
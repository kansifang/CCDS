<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:  bwang 
	Tester:
	Content: 信用等级认定签署意见
	Input Param:
		
	Output param:
	History Log: 
	
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信用等级认定签署意见";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	String sSql="";
	ASResultSet rs=null;
	String sCognResult="",sCustomerName="",sModelName="";
	String sAccountMonth="",sEvaluateDate="",sSystemScore="",sSystemResult="",sCustomerID="";
	//获取组件参数：任务流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	//取得当前阶段的评定结果
	sSql = " select ER.ObjectNo,getCustomerName(ER.ObjectNo) as CustomerName,"+
	   " CognResult,ER.AccountMonth ,"+
	   " EC.ModelName as ModelName,ER.EvaluateDate,ER.EvaluateScore,ER.EvaluateResult"+
	   " from EVALUATE_RECORD ER,EVALUATE_CATALOG EC" + 
       " where ER.ObjectType = '"+sObjectType + "'"+
       " and ER.SerialNo = '"+sObjectNo+"' and ER.ModelNo=EC.ModelNo";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCognResult = rs.getString("CognResult");
		sModelName=rs.getString("ModelName");
		sAccountMonth=rs.getString("AccountMonth");
	 	sEvaluateDate=rs.getString("EvaluateDate");
 		sSystemScore=rs.getString("EvaluateScore");
	 	sSystemResult=rs.getString("EvaluateResult");
	 	sCustomerID=rs.getString("ObjectNo");
	 	sCustomerName=rs.getString("CustomerName");
	 	
	 	if (sModelName==null)sModelName="";
	 	if (sAccountMonth==null)sAccountMonth="";
	 	if (sEvaluateDate==null)sEvaluateDate="";
	 	if (sSystemScore==null)sSystemScore="";
	 	if (sSystemResult==null)sSystemResult="";
	 	if (sCustomerID==null)sCustomerID="";
	 	if (sCustomerName==null)sCustomerName="";
		if(sCognResult ==null) sCognResult=""; 
	 
	}
	
	rs.getStatement().close();
	String sHeaders[][] = { 
							{"AccountMonth","会计月份"},
	                        {"ModelName","评估模型"},
	                        {"SystemScore","系统评估得分"},
	                        {"SystemResult","系统评估结果"},
	                        {"CustomerName","客户名称"},
	                        {"CognScore","人工评定得分"},
							{"CognResult","人工评定结果"},
							{"PhaseOpinion","评定原因说明"},
							{"InputTime","人工评定日期"},
							{"InputOrgName","评估单位"},
							{"InputUserName","评估人"}
			              };                 
		
	//定义SQL语句
	 sSql = 	" select SerialNo,'' as AccountMonth, PhaseChoice as ModelName,"+//会计月份,评估模型
	 			" SystemScore as SystemScore,SystemResult as SystemResult,"+//系统评估得分，系统评估结果
	 			" CognScore as CognScore,CognResult as CognResult,"+//人工评分，人工评定结果
	 			" OpinionNo,PhaseOpinion, CustomerId,CustomerName,"+//评定原因说明，客户名称
				" InputOrg,getOrgName(InputOrg) as InputOrgName,ObjectType,ObjectNo, "+
				" InputUser,getUserName(InputUser) as InputUserName, "+
				" InputTime,UpdateUser,UpdateTime "+
				" from FLOW_OPINION " +
				" where SerialNo='"+sSerialNo+"' ";
	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//定义列表表头
	doTemp.setHeader(sHeaders); 
	//对表进行更新、插入、删除操作时需要定义表对象、主键   
	doTemp.UpdateTable = "FLOW_OPINION";
	doTemp.setKey("SerialNo,OpinionNo",true);		
	//设置字段是否可见  
	doTemp.setVisible("AccountMonth,SerialNo,OpinionNo,InputOrg,InputUser,UpdateUser,UpdateTime,ObjectType,ObjectNo,CustomerId",false);		
	//设置不可更新字段
	doTemp.setUpdateable("InputOrgName,InputUserName,AccountMonth",false);
	//人工认定分数
	doTemp.setHTMLStyle("CognScore","	onChange=\"javascript:parent.setResult()\"	");
	//设置必输项
	doTemp.setRequired("CognScore,PhaseOpinion",true);
	doTemp.setAlign("SystemScore","3");
	doTemp.setType("CognScore,SystemScore","Number");

	//设置下拉框
	doTemp.setDDDWSql("SystemResult,CognResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CreditLevel' order by SortNo ");
	//设置只读属性
	doTemp.setReadOnly("InputOrgName,InputUserName,InputTime,AccountMonth,ModelName,CognResult,SystemScore,SystemResult,CustomerName",true);
	//编辑形式为备注栏
	doTemp.setEditStyle("PhaseOpinion","3");	
	//置html格式
	doTemp.setHTMLStyle("PhaseOpinion"," style={height:100px;width:50%;overflow:scroll;font-size:9pt;} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	//限制评定原因的输入字数
	doTemp.setLimit("PhaseOpinion",400);
			
	//生成ASDataWindow对象		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform形式
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			initOpinionNo();
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
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
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");	
			setItemValue(0,getRow(),"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,getRow(),"ModelName","<%=sModelName%>");
			setItemValue(0,getRow(),"EvaluateDate","<%=sEvaluateDate%>");
			setItemValue(0,getRow(),"SystemScore","<%=DataConvert.toDouble(sSystemScore)%>");
			setItemValue(0,getRow(),"SystemResult","<%=sSystemResult%>");	
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");	
		}      
		
			setItemValue(0,getRow(),"CognResult","<%=sCognResult%>");
		
	}
	
		/*~[Describe=根据分值换算评级结果;InputParam=无;OutPutParam=无;]~*/
	function setResult(){		
		//评估分值结果换算
		//需要根据具体情况进行调整
		var CognScore = getItemValue(0,getRow(),"CognScore");
		if(CognScore<0){
			alert("人工认定得分必须大于0！");
			setItemValue(0,getRow(),"CognScore","");
			setItemValue(0,getRow(),"CognResult","");
			setItemFocus(0,getRow(),"CognScore");
			return;
		}
		if (CognScore<60)
			result = "BB";
		else if (CognScore<76)
			result = "BBB";
		else if (CognScore<86)
			result = "A";
		else if (CognScore<95)
			result = "AA";
		else
			result = "AAA";			
		setItemValue(0,getRow(),"CognResult",result);
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
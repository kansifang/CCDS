<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   CChang 2003.8.25
	Tester:
	Content: 签署意见
	Input Param:
		TaskNo：任务流水号
		ObjectNo：对象编号
		ObjectType：对象类型
	Output param:
	History Log: zywei 2005/07/31 重检页面
					lpzhang 增加信用等级评估认定信息 2009-8-25 
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "签署意见";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	//获取组件参数：任务流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sBusinessType == null) sBusinessType = "";
	if(sApplyType == null) sApplyType = "";
	System.out.println("sCustomerID:"+sCustomerID);
	String Sql="",sCustomerType="",Sql1="";
	String sEvaluateSerialNo="",sEvaluateResult="",sCognResult="",sModelNo="",sTransformMethod ="",sModelDescribe="",sSmallEntFlag="";
	//并行信用等级评估变量
	String sIsInuse="";//是否停用并行客户信用评级
	String sNewEvaluateSerialNo = "";
	String sNewEvaluateResult = "" ;
	String sNewCognResult = "";
	String sNewModelNo = "";
	String sSModelNo = "";
	String sNewTransformMethod = "";
	String sNewModelDescribe  = "";
	double dNewEvaluateScore = 0.0;
	double dNewCognScore = 0.0;
	double dEvaluateScore=0.0,dCognScore=0.0;
	ASResultSet rs = null, rs1 = null;
	//String[][] sEvluateArr = new String[8][]; 
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	
	//取得客户信用等级评估信息 add by lpzhang 2009-8-24
	Sql = "select CustomerType from Customer_Info where CustomerID ='"+sCustomerID+"'";
	sCustomerType = Sqlca.getString(Sql);
	if(sCustomerType == null) sCustomerType="";
	
	//录入公司客客户、个人客户、同业客户信息时判断，是否“停用并行客户信用等级评估”
	sIsInuse = Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
	if (sIsInuse== null) sIsInuse="" ;
	//不是同业授信，非额度项下
	if( ("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") 
		&& sObjectType.equals("CreditApply") && !(sBusinessType.equals("1056") || sBusinessType.equals("1054")))
	{
		Sql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='Customer' "+
		       " and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth desc,SerialNo desc fetch first 1 rows only ";
		rs = Sqlca.getASResultSet(Sql);
		if(rs.next())
		{
			sEvaluateSerialNo = rs.getString("SerialNo");
			dEvaluateScore    = rs.getDouble("EvaluateScore");
			sEvaluateResult   = rs.getString("EvaluateResult");
			dCognScore        = rs.getDouble("CognScore");
			sCognResult       = rs.getString("CognResult");
			
			if(sEvaluateSerialNo == null) sEvaluateSerialNo ="";
			if(sEvaluateResult == null) sEvaluateResult ="";
			if(sCognResult == null) sCognResult ="";
		}
		rs.getStatement().close();
		
		if(sIsInuse.equals("2"))
		{
			Sql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='NewEvaluate' "+
		          " and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth desc,SerialNo desc fetch first 1 rows only ";
			rs = Sqlca.getASResultSet(Sql);
			if(rs.next())
			{
				sNewEvaluateSerialNo = rs.getString("SerialNo");
				dNewEvaluateScore    = rs.getDouble("EvaluateScore");
				sNewEvaluateResult   = rs.getString("EvaluateResult");
				dNewCognScore        = rs.getDouble("CognScore");
				sNewCognResult       = rs.getString("CognResult");
				
				if(sNewEvaluateSerialNo == null) sNewEvaluateSerialNo ="";
				if(sNewEvaluateResult == null) sNewEvaluateResult ="";
				if(sNewCognResult == null) sNewCognResult ="";
			}
			rs.getStatement().close();		
		}
		
		String sCustomerFlag="";
		if(sCustomerType.startsWith("03"))
		{
			sCustomerFlag = "IND_INFO";
			sModelNo = Sqlca.getString("select CreditBelong from "+sCustomerFlag+" where CustomerID = '"+sCustomerID+"'");
			
			if(sModelNo == null) sModelNo ="";
			sNewModelNo = Sqlca.getString("select NewCreditBelong from "+sCustomerFlag+" where CustomerID = '"+sCustomerID+"'");			
			if(sNewModelNo == null) sNewModelNo ="";
		}else{
			sCustomerFlag = "ENT_INFO";
			Sql ="select CreditBelong,NewCreditBelong,SmallEntFlag from "+sCustomerFlag+" where CustomerID = '"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(Sql);
			if(rs.next())
			{
				sModelNo = rs.getString("CreditBelong");
				sSmallEntFlag  = rs.getString("SmallEntFlag");
				
				if(sModelNo == null) sModelNo ="";
				if(sSmallEntFlag == null) sSmallEntFlag ="";
				sNewModelNo = rs.getString("NewCreditBelong");
				if(sNewModelNo == null) sNewModelNo ="";
			}
			rs.getStatement().close();
		}
		
		System.out.println("sModelNo:::"+sModelNo);
		if (sModelNo != null  && !sModelNo.equals("")) 
		{
			Sql1 = "select TransformMethod,ModelDescribe from EVALUATE_CATALOG where ModelNo = '"+sModelNo+"'";
			rs1 = Sqlca.getASResultSet2(Sql1);
			if(rs1.next())
			{
				sTransformMethod = rs1.getString("TransformMethod");
				sModelDescribe = rs1.getString("ModelDescribe");
				if(sTransformMethod == null) sTransformMethod ="";
				if(sModelDescribe == null) sModelDescribe ="";
			}
			rs1.getStatement().close();
		}
		
		if(sNewModelNo != null && !sNewModelNo.equals("") && sIsInuse.equals("2"))
		{
			Sql1 = " select TransformMethod,ModelDescribe from EVALUATE_CATALOG where ModelNo = '"+sNewModelNo+"' ";
			rs1 = Sqlca.getASResultSet2(Sql1);
			if(rs1.next())
			{
				sNewTransformMethod = rs1.getString("TransformMethod");
				sNewModelDescribe = rs1.getString("ModelDescribe");
				if(sNewTransformMethod == null) sNewTransformMethod ="";
				if(sNewModelDescribe == null) sNewModelDescribe ="";	
			}
			rs1.getStatement().close();
		}
	
	}
	
	String sHeaders[][]={   
							{"SystemScore","系统评估得分"},
				            {"SystemResult","系统评估结果"},
				            {"CognScore","人工评定得分"},
				            {"CognResult","人工评定结果"},
							{"NewSystemScore","并行系统评估得分"},
				            {"NewSystemResult","并行系统评估结果"},
				            {"NewCognScore","并行人工评定得分"},
				            {"NewCognResult","并行人工评定结果"},				            
				            {"PhaseChoice","调查意见"},
	                        {"PhaseOpinion","意见说明"},
	                        {"InputOrgName","登记机构"}, 
	                        {"InputUserName","登记人"}, 
	                        {"InputTime","登记日期"}                      
                        };                    
		
	//定义SQL语句
	String sSql = 	" select SerialNo,OpinionNo,"+
					" SystemScore,SystemResult,CognScore,CognResult,NewSystemScore,NewSystemResult,NewCognScore,NewCognResult,PhaseChoice,PhaseOpinion,"+
					" InputOrg,getOrgName(InputOrg) as InputOrgName, "+
					" InputUser,getUserName(InputUser) as InputUserName, "+
					" InputTime,UpdateUser,UpdateTime "+
					" from FLOW_OPINION " +
					" where SerialNo='"+sSerialNo+"' ";
	//out.println(sSql);
	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//定义列表表头
	doTemp.setHeader(sHeaders); 
	//对表进行更新、插入、删除操作时需要定义表对象、主键   
	doTemp.UpdateTable = "FLOW_OPINION";
	doTemp.setKey("SerialNo,OpinionNo",true);	
	//设置意见
	doTemp.setRequired("PhaseChoice",true);
	doTemp.setDDDWCode("PhaseChoice","PhaseChoice");
	//设置字段是否可见  
	doTemp.setVisible("SerialNo,OpinionNo,InputOrg,InputUser,UpdateUser,UpdateTime",false);		
	//设置不可更新字段
	doTemp.setUpdateable("InputOrgName,InputUserName",false);
	//设置必输项
	doTemp.setRequired("PhaseOpinion",true);
	//设置只读属性
	doTemp.setReadOnly("InputOrgName,InputUserName,InputTime",true);
	//编辑形式为备注栏
	doTemp.setEditStyle("PhaseOpinion","3");	
	//置html格式
	doTemp.setHTMLStyle("PhaseOpinion"," style={height:100px;width:50%;overflow:scroll;font-size:9pt;} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
		
	//有信用评估的时候才显示等
	doTemp.setVisible("SystemScore,CognScore,SystemResult,CognResult",false);
	//并行评级模板
	doTemp.setVisible("NewSystemScore,NewCognScore,NewSystemResult,NewCognResult",false);	
	if(("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") 
		&& sObjectType.equals("CreditApply") )
	{
		//并行评级模板
		if(sIsInuse.equals("2"))
		{
			doTemp.setReadOnly("NewSystemScore,NewSystemResult,NewCognResult",true);
			if(!(sBusinessType.equals("1056") || sBusinessType.equals("1054")) && !sSmallEntFlag.equals("1") && !sCustomerType.startsWith("03"))	
				doTemp.setRequired("NewSystemScore,NewCognScore,NewSystemResult,NewCognResult",true);
			doTemp.setVisible("NewSystemScore,NewCognScore,NewSystemResult,NewCognResult",true);
			doTemp.setHTMLStyle("NewCognScore","onChange=\"javascript:parent.setNewResult()\"	");
			doTemp.setAlign("NewSystemScore,NewCognScore","3");
			doTemp.setType("NewSystemScore,NewCognScore","Number");
		}
		doTemp.setReadOnly("SystemScore,SystemResult,CognResult",true);
		if(!(sBusinessType.equals("1056") || sBusinessType.equals("1054")) && !sSmallEntFlag.equals("1") && !sCustomerType.startsWith("03"))	
			doTemp.setRequired("SystemScore,CognScore,SystemResult,CognResult",true); 
		doTemp.setVisible("SystemScore,CognScore,SystemResult,CognResult",true);
		
		//人工认定分数
		doTemp.setHTMLStyle("CognScore","onChange=\"javascript:parent.setResult()\"	");
		doTemp.setAlign("SystemScore,CognScore","3");
		doTemp.setType("SystemScore,CognScore","Number");
	}
	
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
			{"false","","Button","获取信用评级","获取信用评级","getEvaluate()",sResourcesPath},
			};
			
	if(("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") 
		&& sObjectType.equals("CreditApply"))
			{
				sButtons[2][0] = "true";
			}
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
		as_save("myiframe0");
	}
	
	/*~[Describe=删除已删除意见;InputParam=无;OutPutParam=无;]~*/
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
		if((typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0 || sOpinionNo== 'Null' || sOpinionNo== 'null') )
		{
			alert("请降低IE浏览器安全设置！");
			return;
		}
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
		}        
	}
	
	
	/*~[Describe=根据分值换算评级结果;InputParam=无;OutPutParam=无;]~*/
	function setResult(){		
		//评估分值结果换算
		//需要根据具体情况进行调整
		var CognScore = getItemValue(0,getRow(),"CognScore");
		if(CognScore<0 || CognScore>100){
			alert("调整分请在0至100之间！");
			setItemValue(0,getRow(),"CognScore","");
			setItemValue(0,getRow(),"CognResult","");
			setItemFocus(0,getRow(),"CognScore");
			return;
		}
		sModelDescribe = "<%=sModelDescribe%>";
		if(typeof(sModelDescribe) != "undefined" && sModelDescribe != "") 
		{			
			var my_array = new Array();
			var str_array = new Array();
			my_array = sModelDescribe.split(",");
			for(var i=0;i<my_array.length;i++)
			{ 
				str_array = my_array[i].split("&");
				if(checkResult(str_array[0],str_array[1],CognScore))
				{
					result = str_array[2];
					setItemValue(0,getRow(),"CognResult",result);
					return;
				}
			}
			
		}else
		{
			alert("评估模板配置错误，请联系管理员！");
		}			

	}
		/*~[Describe=根据分值换算并行评级结果;InputParam=无;OutPutParam=无;]~*/
			function setNewResult(){		
		//评估分值结果换算
		//需要根据具体情况进行调整
		var NewCognScore = getItemValue(0,getRow(),"NewCognScore");
		if(NewCognScore<0 || NewCognScore>100){
			alert("调整分请在0至100之间！");
			setItemValue(0,getRow(),"NewCognScore","");
			setItemValue(0,getRow(),"NewCognResult","");
			setItemFocus(0,getRow(),"NewCognScore");
			return;
		}
		sModelDescribe = "<%=sNewModelDescribe%>";
		if(typeof(sModelDescribe) != "undefined" && sModelDescribe != "") 
		{			
			var my_array = new Array();
			var str_array = new Array();
			my_array = sModelDescribe.split(",");
			for(var i=0;i<my_array.length;i++)
			{ 
				str_array = my_array[i].split("&");
				if(checkResult(str_array[0],str_array[1],NewCognScore))
				{
					result = str_array[2];
					setItemValue(0,getRow(),"NewCognResult",result);
					return;
				}
			}
			
		}else
		{
			alert("评估模板配置错误，请联系管理员！");
		}			

	}
	//计算信用等级评级测试结果
	function checkResult(sSign,dNum,dCognScore)
	{
		if(sSign == "=")
		{
			if(dCognScore == dNum)
				return true;
			else
				return false;
		}else if(sSign == ">")
		{
			if(dCognScore > dNum)
				return true;
			else
				return false;
		}else if(sSign == ">=")
		{
			if(dCognScore >= dNum)
				return true;
			else
				return false;
		}else if(sSign == "<")
		{
			if(dCognScore < dNum)
				return true;
			else
				return false;
		}else if(sSign == "<=")
		{
			if(dCognScore <= dNum)
				return true;
			else
				return false;
		}else if(sSign == "<>")
		{
			if(dCognScore != dNum)
				return true;
			else
				return false;
		}else 
			return false;
		
	}
	
	/*~[Describe=获取信用评价信息;InputParam=无;OutPutParam=无;]~*/
    function getEvaluate()
    {
    	sEvaluateSerialNo = "<%=sEvaluateSerialNo%>";
   		dEvaluateScore    = "<%=dEvaluateScore%>";
	   	sEvaluateResult   = "<%=sEvaluateResult%>";
	   	dCognScore        = "<%=dCognScore%>";
	   	sCognResult       = "<%=sCognResult%>";
	    
	    if(!isNotNull(sEvaluateSerialNo))
	 	{
	   		alert("该客户没有任何信用等级评估记录，请先进行信用等级评估！");
	   		return;
	 	}else
	 	{
	 		setItemValue(0,getRow(),"SystemScore",dEvaluateScore);
	 		setItemValue(0,getRow(),"SystemResult",sEvaluateResult);
	 		setItemValue(0,getRow(),"CognScore",dCognScore);
	 		setItemValue(0,getRow(),"CognResult",sCognResult);
	 	}
	 	if("<%=sIsInuse%>" == "2")
	 	{
	 		sNewEvaluateSerialNo = "<%=sNewEvaluateSerialNo%>";
   			dNewEvaluateScore    = "<%=dNewEvaluateScore%>";
	   		sNewEvaluateResult   = "<%=sNewEvaluateResult%>";
	   		dNewCognScore        = "<%=dNewCognScore%>";
	   		sNewCognResult       = "<%=sNewCognResult%>";
	   		
	   		if(!isNotNull(sNewEvaluateSerialNo))
	   		{
	   			alert("该客户没有并行信用等级评估记录，请先进并行行信用等级评估！");
	   			return;
	   		}else
	   		{
	   			setItemValue(0,getRow(),"NewSystemScore",dNewEvaluateScore);
	 			setItemValue(0,getRow(),"NewSystemResult",sNewEvaluateResult);
	 			setItemValue(0,getRow(),"NewCognScore",dNewCognScore);
	 			setItemValue(0,getRow(),"NewCognResult",sNewCognResult);
	   		}	 	
	 	}
	 	
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
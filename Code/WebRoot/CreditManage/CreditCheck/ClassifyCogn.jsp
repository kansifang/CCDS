<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: lpzhang2010-6-3 
		Tester:
		Describe: 
		Input Param:
			SerialNo：分类流水号
			
				
		Output Param:			

				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "分类认定信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义参数:显示模板编号
	String sTempletNo = "";
		
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	String sTaskNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TaskNo"));
	String sRightType =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	String sCustomerID =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sObjectNo =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerType == null) sCustomerType = "";
	if(sTaskNo == null) sTaskNo = "";
	if(sRightType == null) sRightType = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sObjectNo == null) sObjectNo = "";
	System.out.println("sTaskNo：：："+sTaskNo+"sSerialNo:"+sSerialNo);
	String sBusinessType = "";
	String sOccurType = "";
	String sClassifyLevel1 = "";//客户经理初分结果
	ASResultSet rs = null;
	String sSql = "select BusinessType,OccurType from business_contract where serialno = '"+sObjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sBusinessType = rs.getString("BusinessType");
		sOccurType = rs.getString("OccurType");
	}
	rs.getStatement().close();
	sSql = "select ClassifyLevel from CLASSIFY_RECORD where serialno = '"+sSerialNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sClassifyLevel1 = rs.getString("ClassifyLevel");
	}
	rs.getStatement().close();
	
	if(sBusinessType == null) sBusinessType = "";	
	if(sOccurType == null) sOccurType = "";
	if(sClassifyLevel1 == null) sClassifyLevel1 = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	sTempletNo = "ClassifyCogn";
	//通过显示模板产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sCustomerType.startsWith("03")){
		doTemp.setVisible("Result3,ResultOpinion3,Result4,ResultUserName1,ResultOpinion4,ResultUserID2,classifyCondition3,Result5,ResultOpinion5,ResultUserID3,ResultOpinion2,ResultUserID4,classifyCondition1,ResultUserID5,classifyCondition2",false);
		doTemp.setDDDWSql("ResultUserName1,ClassifyLevel,ClassifyLevel2,Result1","select itemNo,itemName from Code_Library where CodeNo ='ClassifyResult' and  itemno in('01','02','03','04','05') and isinuse ='1' ");
		doTemp.setRequired("Result3,ResultOpinion3,Result4,ResultUserName1,ResultOpinion4,ResultUserID2,classifyCondition3,Result5,ResultOpinion5,ResultUserID3,ResultOpinion2,ResultUserID4,classifyCondition1,ResultUserID5,classifyCondition2",false);
	}else{
		doTemp.setDDDWSql("ClassifyLevel,ClassifyLevel2,Result1","select itemNo,itemName from Code_Library where CodeNo ='ClassifyResult' and  itemno not in('01','02','03','04','05') and isinuse ='1' ");
		doTemp.setDDDWSql("ResultUserName1","select itemNo,itemName from Code_Library where CodeNo ='ClassifyResult' and  itemno in('01','02','03','04','05') and isinuse ='1' ");
	}
	
	if(sBusinessType.startsWith("1")){
		doTemp.setVisible("ResultUserID4,classifyCondition1",false);
		doTemp.setRequired("ResultUserID4,classifyCondition1",false);
	}
	else if(sBusinessType.startsWith("2")){
		doTemp.setVisible("Result3,ResultOpinion3,Result4,ResultUserName1,ResultOpinion4,ResultUserID2,classifyCondition3,Result5,ResultOpinion5,ResultUserID3,ResultOpinion2,ResultUserID5,classifyCondition2",false);
		doTemp.setRequired("Result3,ResultOpinion3,Result4,ResultUserName1,ResultOpinion4,ResultUserID2,classifyCondition3,Result5,ResultOpinion5,ResultUserID3,ResultOpinion2,ResultUserID5,classifyCondition2",false);
	}			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//定义后续事件
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	System.out.println(doTemp.SourceSql);
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
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
			
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	function saveRecord(sPostEvents)
	{
		
		if (!ValidityCheck()) return;
		
		as_save("myiframe0",classifyOpinion());		
	}
	
	//签署意见
	function classifyOpinion()
	{
		var iOpinion="";
		sTaskNo= "<%=sTaskNo%>";
		sSerialNo= "<%=sSerialNo%>";
		sRemark = getItemValue(0,getRow(),"Remark");
		sRemark2 = getItemValue(0,getRow(),"Remark2");
		iOpinion = RunMethod("五级分类","是否已经签署意见",sTaskNo);
		if(iOpinion>0)
		{
			RunMethod("五级分类","更新签署意见",sRemark+","+sRemark2+","+sTaskNo);
		}else{
			var sTableName = "FLOW_OPINION";//表名
			var sColumnName = "OpinionNo";//字段名
			var sPrefix = "";//无前缀
								
			//使用GetSerialNo.jsp来抢占一个流水号
			var sOpinionNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			//将流水号置入对应字段
			RunMethod("五级分类","新增五级分类意见",sTaskNo+","+sOpinionNo+","+sSerialNo+",ClassifyApply,<%=CurUser.UserID%>,<%=CurOrg.OrgID%>,"+sRemark+","+sRemark2);
		}
		
	}
		
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
	}
	
	function ValidityCheck()
	{	
		sResult4 = getItemValue(0,0,"Result4");	
		sResult1 = getItemValue(0,0,"Result1");		
		sResult3 = getItemValue(0,0,"Result3");
		sResultOpinion3 = getItemValue(0,0,"ResultOpinion3");
		sResultUserName1 = getItemValue(0,0,"ResultUserName1");
		sClassifyLevel = getItemValue(0,0,"ClassifyLevel");
		sClassifyLevel2 = getItemValue(0,0,"ClassifyLevel2");
		sResultUserID2 = getItemValue(0,0,"ResultUserID2");//是否为关系人贷款
		sResult5 = getItemValue(0,0,"Result5");//是否为挪用贷款
		sResultUserID3 = getItemValue(0,0,"ResultUserID3");//是否为挪用贷款
		sResultUserID4 = getItemValue(0,0,"ResultUserID4");//是否存在表外授信业务垫款
		sResultUserID5 = getItemValue(0,0,"ResultUserID5");//是否为展期贷款
		if(sResult4 == "1"){
			if(typeof(sResultUserName1)=="undefined" || sResultUserName1.length==0 || sResultUserName1 == ""){
				alert("牵头行分类结果必需!");
				return false; 
			}	
		}else{
			if(!(typeof(sResultUserName1)=="undefined" || sResultUserName1.length==0 || sResultUserName1 == ""))
			{
				alert("如果选择的是“否”，则“牵头行分类结果”应该不能选择!");
				return false;
			}	
		}
		
		if(sResult3=="01" || sResult3=="02"){
			if(typeof(sResultOpinion3)=="undefined" || sResultOpinion3.length==0)
			{
				alert("当“是否为固定资产和在建工程项目贷款”为‘是’时候，“固定资产和在建工程项目贷款情况说明”为必输！");
				return false;
			}
			if(sResult3=="02"){
				if(sClassifyLevel <"0203" ){
					alert("当“是否为固定资产和在建工程项目贷款”为 “出现重大不利于贷款偿还因素”，最高分类认定为“关注3”");
					return false;
				}
			}
		}
		if(sClassifyLevel.substring(0,2) < sResultUserName1 )
		{
			alert("分类结果不能高于牵头行分类结果！");
			return false;
		}
		if(sResultUserID2=="03" && sClassifyLevel<"0202")
		{
			alert("关系人贷款并且条件不优于一般贷款，最高分类认定为“关注2”！");
			return false;
		}
		if(sResult5=="1" && sClassifyLevel<"0203")
		{
			alert("是挪用贷款，最高分类认定为“关注3”！");
			return false;
		}
		
		if(sResult5=="01" && sClassifyLevel<"0203")
		{
			alert("是挪用贷款，最高分类认定为“关注3”！");
			return false;
		}
		if(sResultUserID3=="05" && sClassifyLevel<"0301")
		{
			alert("是（重组后未逾期），最高分类认定为“次级1”！");
			return false;
		}
		if(sResultUserID3=="06" && (sClassifyLevel<"0400" || sClassifyLevel<"04") )
		{
			alert("是（重组后仍逾期），最高分类认定为“可疑”！");
			return false;
		}
		if(sResultUserID3=="07" && sClassifyLevel<"0201" )
		{
			alert("是（盘活追加），最高分类认定为“关注1”！");
			return false;
		}
		if(sResultUserID4=="08" && sClassifyLevel<"0203" )
		{
			alert("是表外授信业务垫款（30天以内），最高分类认定为“关注3”！");
			return false;
		}
		if(sResultUserID4=="09" && sClassifyLevel<"0302" )
		{
			alert("是表外授信业务垫款（31-90天以内），最高分类认定为“次级2”！");
			return false;
		}
		if(sResultUserID4=="10" &&(sClassifyLevel<"0400" || sClassifyLevel<"04"))
		{
			alert("是表外授信业务垫款（90天以上），最高分类认定为“可疑”！");
			return false;
		}
		
		if(sResultUserID5=="11" &&  sClassifyLevel<"0202")
		{
			alert("是展期（未逾期），最高分类认定为“关注2”！");
			return false;
		}
		if(sResultUserID5=="12" &&  sClassifyLevel<"0203")
		{
			alert("是展期（已逾期），最高分类认定为“关注3”！");
			return false;
		}
		/*
		if(sResult1 > sClassifyLevel){
			alert("“分类结果调整”不得高于“初分结果”");
			return false;
		}*/
	
		if("<%=sOccurType%>"=="020" )//发生方式为借新还旧
		{
			if("<%=sCustomerType%>".indexOf("01") == 0)//公司客户
			{
				if(sClassifyLevel<"0201"||sClassifyLevel2<"0201")
				{
					alert("发生方式为“借新还旧”的授信业务,“分类结果调整”不得高于“关注1”");
		    	   
			    }
		    }
		}
		if("<%=sOccurType%>"=="030" )//发生方式为资产重组
		{
			if("<%=sCustomerType%>".indexOf("01") == 0)//公司客户
			{
				if(sClassifyLevel<"0301"||sClassifyLevel2<"0301")
				{
					alert("发生方式为“重组”的授信业务,“分类结果调整”不得高于“次级1”");
				}
		    	    
		    }
		}
		return true;
		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	
	function initOpinionNo() 
	{
		var sTableName = "FLOW_OPINION";//表名
		var sColumnName = "OpinionNo";//字段名
		var sPrefix = "";//无前缀
								
		//使用GetSerialNo.jsp来抢占一个流水号
		var sOpinionNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if ("<%=sClassifyLevel1%>"=="")//如果没有找到对应记录，则设置字段默认值
		{
			if("<%=sOccurType%>"=="010" || "<%=sOccurType%>"=="065")//发生方式为新增和新增（续作）
			{
				if("<%=sCustomerType%>"=="03")//个人
			    {
					setItemValue(0,0,"ClassifyLevel","01");//正常
				    setItemValue(0,0,"ClassifyLevel2","01");
			    }else if("<%=sCustomerType%>".indexOf("01") == 0){//公司
				    setItemValue(0,0,"ClassifyLevel","0102");//正常2
				    setItemValue(0,0,"ClassifyLevel2","0102");
			    }
		    }
		    if("<%=sOccurType%>"=="030" )//发生方式为资产重组
		    {
		    	sReturn = RunMethod("BusinessManage","GetClassifyResult","NPAReformApply,<%=sObjectNo%>");
			    if (!(typeof(sReturn)=="undefined" || sReturn.length==0))
			    {	
			    	var sReturn1 = sReturn.split("@");
				    setItemValue(0,0,"ClassifyLevel",sReturn1[0]);
				    setItemValue(0,0,"ClassifyLevel2",sReturn1[1]);
			    }
		    }
		   if("<%=sOccurType%>"=="020" )//发生方式为借新还旧
		   {
			   sReturn = RunMethod("BusinessManage","GetClassifyResult","BusinessContract,<%=sObjectNo%>");//结果为空怎么办呢？
			   if (!(typeof(sReturn)=="undefined" || sReturn.length==0))
			   {	
				   var sReturn1 = sReturn.split("@");
				   setItemValue(0,0,"ClassifyLevel",sReturn1[0]);
				   setItemValue(0,0,"ClassifyLevel2",sReturn1[1]);
			   }
		    }
		}
    }
	

	</script>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	//bFreeFormMultiCol=true;
	
	my_load(2,0,'myiframe0');
	if("<%=sRightType%>"==""){
		 setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
        setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
        setItemValue(0,0,"UserIDName","<%=CurUser.UserName%>");
        setItemValue(0,0,"OrgIDName","<%=CurOrg.OrgName%>"); 
        }
	initRow(); //页面装载时，对DW当前记录进行初始化
	
	
	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>


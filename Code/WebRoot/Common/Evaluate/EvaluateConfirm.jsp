<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:    
		Tester:	
		Content: 客户列表
		Input Param:
			              --ObjectType:  对象类型
			              --ObjectNo  :  对象编号
			              --ModelType :  评估模型类型 010--信用等级评估   030--风险度评估  080--授信限额 018--信用村镇评定  具体由'EvaluateModelType'代码说明
			              --CustomerID：  客户代码        　        
		Output param:
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005.7.22 fbkang    页面整理
			2005.8.31 王业罡    代码检查,部分重构
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "评估人工认定"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
  //定义变量

  //获得组件参数，对象类型、对象编号、模型类型、客户代码
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
%>	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = { {"AccountMonth","会计月份"},
	                        {"ModelName","评估模型"},
	                        {"EvaluateDate","系统评估日期"},
	                        {"EvaluateScore","系统评估得分"},
	                        {"EvaluateResult","系统评估结果"},
				          	{"CognScore","人工评定得分"},
							{"CognResult","人工评定结果"},
							{"FinishDate","人工评定完成日期"},
							{"CognOrgName","评估单位"},
							{"CognUserName","评估人"},
	                        {"Evaluatelevel","评估级别"},
	                        {"Remark","调整说明"}
	};   				   		
	
	String sSql = " select R.SerialNo,R.AccountMonth,C.ModelName,C.ModelNo,R.EvaluateDate,R.EvaluateScore,R.EvaluateResult,R.CognScore,R.CognResult,R.FinishDate,R.Remark,"+
	       " R.CognOrgID,getOrgName(CognOrgID) as CognOrgName,R.CognUserID,getUserName(CognUserID) as CognUserName,Evaluatelevel"+
	       " from EVALUATE_RECORD R,EVALUATE_CATALOG C" + 
	       " where ObjectType='"+sObjectType + "' and SerialNo ='"+sSerialNo+"'and ObjectNo='"+ sObjectNo + "' order by AccountMonth DESC";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("SerialNo,ModelNo,CognUserID,CognOrgID,Evaluatelevel",false);
	
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	doTemp.setUpdateable("ModelName,CognOrgName,CognUserName",false);
	//设置宽度
	doTemp.setHTMLStyle("ModelName","style={width:300px} ");
	doTemp.setHTMLStyle("FinishDate,AccountMonth,EvaluateDate","  style={width:70px}  ");
	doTemp.setHTMLStyle("CognScore","	onChange=\"javascript:parent.setResult()\"	");
	doTemp.setCheckFormat("EvaluateScore,CognScore","2");
	doTemp.setType("EvaluateScore,CognScore","Number");
	doTemp.setDDDWSql("CognResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CreditLevel' and IsInUse='1' order by SortNo ");
	doTemp.setReadOnly("AccountMonth,ModelName,EvaluateDate,EvaluateScore,EvaluateResult,CognOrgName,CognUserName,FinishDate",true);
	
	doTemp.setHTMLStyle("Remark","style={width:300px;height:70px}");
	doTemp.setRequired("R.Remark",true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="0";      //设置为free风格
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%> 

<%/*END*/%>


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
			  {"true","","Button","保存","保存","my_save()",sResourcesPath},
			  {"true","","Button","提交","提交","my_Finished()",sResourcesPath},
	};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script>
	//---------------------定义按钮事件---------------------//

	function my_save(){
		sFinishDate  = getItemValue(0,getRow(),"FinishDate");
		if (typeof(sFinishDate)!="undefined" && sFinishDate.length>0){
			alert("该条记录已提交，无法修改人工认定信息！");
			return;
		}
		setItemValue(0,0,"CognUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"CognOrgID","<%=CurOrg.OrgID%>");
		as_save('myiframe0');
	}
	function my_Finished(){
		sFinishDate  = getItemValue(0,getRow(),"FinishDate");
		if (typeof(sFinishDate)!="undefined" && sFinishDate.length>0){
			alert("该条记录已提交，请确认！");
			return;
		}
		if(confirm("您确定要提交认定吗？")){
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			my_save(); 
		}
	}

</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

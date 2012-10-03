<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/* 
		Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
  		This software is the proprietary information of Amarsoft, Inc.  
 		Use is subject to license terms.
 		Author:FXie 2004.02.12
 		Tester:
 			
 		Content: 	信用等级评估调整
 		Input Param:
 			ObjectType：对象类型
 		    ObjectNo：对象编号
 			SerialNo：流水号 
 			ModelNo：模型编号 
 			FinishDate：完成认定日期		
 		Output param:
 					
 		History Log:  zbdeng 2004.02.09  
 	    			  Fxie   2004.02.20  增加最终认定
 	*/
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信用等级人工认定"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "",sObjectType = "",sObjectNo = "",sModelType = "";
	String sSerialNo = "",sFinishDate = "",sModelNo = "";
	String sRole = "",sResult = "",sLevel = "";
	
	//获取组件参数	
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	sModelNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
    sFinishDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishDate"));
    //将空值转化为空字符串
    if(sObjectType == null) sObjectType = "";
    if(sObjectNo == null) sObjectNo = "";
    if(sSerialNo == null) sSerialNo = "";    
    if(sModelNo == null) sModelNo = "";
    if(sFinishDate == null) sFinishDate = "";
    
    if(CurUser.hasRole("480"))
    {
        sRole = "3";
    }
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = { 
							{"AccountMonth","会计月份"},
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
	
	sSql = " select R.SerialNo,R.AccountMonth,C.ModelName,C.ModelNo,R.EvaluateDate,R.EvaluateScore,R.EvaluateResult,R.CognScore,R.CognResult,R.FinishDate,R.Remark,"+
	       " R.CognOrgID,getOrgName(CognOrgID) as CognOrgName,R.CognUserID,getUserName(CognUserID) as CognUserName,Evaluatelevel"+
	       " from EVALUATE_RECORD R,EVALUATE_CATALOG C" + 
	       " where ObjectType = '"+sObjectType + "' "+
	       " and SerialNo = '"+sSerialNo+"' "+
	       " and ObjectNo = '"+sObjectNo+"' "+
	       " and C.ModelNo = '"+sModelNo+"' "+
	       " order by AccountMonth DESC ";
	//out.print(sSql);
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设不可见
	doTemp.setVisible("SerialNo,ModelNo,CognUserID,CognOrgID,Evaluatelevel,FinishDate",false);
	//为了删除
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	doTemp.setUpdateable("ModelName,CognOrgName,CognUserName",false);
	//设置宽度
	doTemp.setHTMLStyle("CognOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("ModelName","style={width:300px} ");
	doTemp.setHTMLStyle("AccountMonth,EvaluateDate","  style={width:70px}  ");
	doTemp.setHTMLStyle("CognScore","	onChange=\"javascript:parent.setResult()\"	");
	doTemp.setCheckFormat("EvaluateScore,CognScore","2");
	doTemp.setType("EvaluateScore,CognScore","Number");
	doTemp.setAlign("FinishDate", "2");
	doTemp.setCheckFormat("FinishDate","3");
	
	doTemp.setDDDWSql("CognResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CreditLevel' order by SortNo ");
	doTemp.setReadOnly("AccountMonth,ModelName,EvaluateDate,EvaluateScore,EvaluateResult,CognOrgName,CognUserName",true);
	
	//style={color:#848284;width:70px}
	doTemp.setHTMLStyle("Remark","style={width:300px;height:70px}");
	doTemp.setHTMLStyle("FinishDate","style={width:80px");
	doTemp.setRequired("R.Remark",true);
	doTemp.setLimit("Remark",250);
	doTemp.setEditStyle("Remark","3");
	
	//设置人工评定得分范围
	doTemp.appendHTMLStyle("CognScore"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"人工评定得分必须大于等于0！\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);		
	dwTemp.Style="0";      //设置为free风格
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
			{(sFinishDate.equals("")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{(sFinishDate.equals("")?"true":"false"),"","Button","提交","提交信用等级认定","Finished()",sResourcesPath},
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

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		//录入数据有效性检查
		if (!ValidityCheck()) return;	
		//置最终评估人为当前用户
		setItemValue(0,0,"CognUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"CognOrgID","<%=CurOrg.OrgID%>");
		
		CheckEvaluate();
		as_save('myiframe0');
	}
	 
	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function Finished()
	{
	   sFinishDate  = getItemValue(0,getRow(),"FinishDate");
	   if(typeof(sFinishDate) != "undefined" && sFinishDate.length != 0)	   
	   {
	        alert(getBusinessMessage('196'));//该笔信用等级评估记录已认定完成，不能再进行认定！
	        return;
	   }
	   if(confirm(getHtmlMessage('40')))//提交后将不能进行修改操作，确定提交吗？
		 {
    	   setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
    	   saveRecord(); 
	   }
	}
	
	/*~[Describe=关闭页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{		
		self.close();
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{				
		return true;
	}
		
</script>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
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
		if (CognScore<45)
			result = "D";		
		else if (CognScore<58)
			result = "C";
		else if (CognScore<64)
			result = "CC";
		else if (CognScore<70)
			result = "CCC";
		else if (CognScore<75)
			result = "B";
		else if (CognScore<80)
			result = "BB";
		else if (CognScore<85)
			result = "BBB";
		else if (CognScore<90)
			result = "A";
		else if (CognScore<96)
			result = "AA";
		else
			result = "AAA";			
		setItemValue(0,getRow(),"CognResult",result);
	}
	
	/*~[Describe=检查信用评级;InputParam=无;OutPutParam=无;]~*/
	function CheckEvaluate()
	{
        var sCognResult = getItemValue(0,getRow(),"CognResult");
        var sCognLevel = "<%=sRole%>";
        var sSerialNo = getItemValue(0,getRow(),"SerialNo");
        var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        var sReturnValue=PopPage("/Common/Evaluate/CheckEvaluateAction.jsp?SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&CognLevel="+sCognLevel+"&CognResult="+sCognResult+"&AccountMonth="+sAccountMonth,"","resizable=yes;dialogWidth=21;dialogHeight=19;center:yes;status:no;statusbar:no");        
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/	
	function initRow(){
		oldScore = getItemValue(0,getRow(),"CognScore");
	    oldResult = getItemValue(0,getRow(),"CognResult");	    
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>


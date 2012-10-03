<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2010/02/01
*	Tester:
*	Describe: 信用评定表列表;
*	Input Param:
*		CustomerID：--当前客户编号
*		SerialNo:	--具体信息流水号
*		EditRight:--权限代码（01：查看权；02：维护权）
*	Output Param:     
*        
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信用评定表列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得页面参数
	
	//获得组件参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {	
							{"SerialNo","评定表流水号"},
							{"CustomerName","客户名称"},
							{"AssessFormTypeName","评定表"},
							{"AssessLevel","评定信用等级"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"},
							{"InputDate","登记日期"}
						   };
	
	String sSql = 	" Select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName, " +
					" AssessFormType,getItemName('AssessFormType',AssessFormType) as AssessFormTypeName,getItemName('AssessLevel',AssessLevel) as AssessLevel, "+
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName, " +
					" InputUserID,getUserName(InputUserID) as InputUserName, " +
					" InputDate  " +
					" from ASSESSFORM_INFO " +
					" Where ObjectNo = '"+sCustomerID+"'"+
					" and ObjectType='Customer' ";	  

	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置关键字
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,AssessFormType,ObjectNo,ObjectType,InputOrgID,InputUserID",false);
	if("0501".equals(sCustomerType))
	{
		doTemp.setVisible("AssessLevel",false);
	}
	doTemp.UpdateTable = "ASSESSFORM_INFO";
	//居中
	doTemp.setAlign("InputDate,CustomerName,AssessLevel","2");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("InputOrgName,InputUserName,InputDate"," style={width:80px} ");
	doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");
	
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
		{"true","","Button","新增","新增客户定量信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看客户定量信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除客户定量信息","deleteRecord()",sResourcesPath},
		{"true","","Button","打印","打印","my_Print()",sResourcesPath},
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
	function newRecord()
	{	
		var sCustomerType= "<%=sCustomerType%>";
		var sAssessFormType="";
		if(sCustomerType == "03" )//个人客户
		{
			//弹出对话选择框
			var sReturn = PopPage("/Common/Evaluate/AssessFormTypeChoice.jsp?ShowFlag=010","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sReturn)!="undefined" && sReturn.length!=0)
			{
				sReturn = sReturn.split("@");
				sAssessFormType = sReturn[0];
			}else
			{
				return;
			}
		}
		OpenPage("/Common/Evaluate/AssessformInfo.jsp?AssessFormType="+sAssessFormType+"&EditRight=01","_self","");	
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserID");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{	
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}
		}else alert(getHtmlMessage('3'));
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserID");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='01';
		else
			sEditRight='02';  
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAssessFormType = getItemValue(0,getRow(),"AssessFormType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/Common/Evaluate/AssessformInfo.jsp?SerialNo="+sSerialNo+"&AssessFormType="+sAssessFormType+"&EditRight="+sEditRight,"_self","");
		}
	}
	
	/*~[Describe=打印;InputParam=无;OutPutParam=无;]~*/
	function my_Print()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sAssessFormType = getItemValue(0,getRow(),"AssessFormType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！  	
		}else
		{
			sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sSerialNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false") //未生成出帐通知单
			{
				//生成出帐通知单	
				PopPage("/FormatDoc/Evaluate/"+sAssessFormType+".jsp?ObjectNo="+sSerialNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			}
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			OpenPage("/FormatDoc/POPreviewFile.jsp?ObjectNo="+sSerialNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
 		}
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content: 资本净额管理详情页面
			Input Param:
			       --SerialNO:流水号
			Output param:
			History Log: 
			-- fbkang on 2005/08/14 

		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "本行资本净额管理详细页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSerialNo="";//--流水号码
	String sSql="";//--存放sql语句
	//获得组件参数

	//获得页面参数	,流水号
    sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = {               
						    {"Remark","备注"},
		                    {"CapitalDate","日期"},	
		                    {"CapitalSum","资本净额"},		
		                    {"IsUsedCreditCheck","是否用于授信集中度校验"},
					        {"UserName","登记人"},
					        {"OrgName","登记机构"},
					        {"InputDate","登记日期"},
					        {"UpdateDate","更新日期"}
					   };   	
	  
		sSql = " select SerialNo,CapitalDate,CapitalSum,IsUsedCreditCheck,InputOrgID,getOrgName(InputOrgID) as "+
			   " OrgName,InputUserID,getUserName(InputUserID) as UserName,InputDate,UpdateDate from CAPITAL_SUM "+	            
			   " where SerialNo = '"+sSerialNo+"' ";
		
	    //sql产生datawindows
		ASDataObject doTemp = new ASDataObject(sSql);
		//头名称
		doTemp.setHeader(sHeaders);
		//修改表
		doTemp.UpdateTable = "CAPITAL_SUM";
	    //设置主键
		doTemp.setKey("SerialNo",true);
		//设置不可修改的列
		doTemp.setUpdateable("UserName,OrgName",false);
	    //设置不可见列
		doTemp.setVisible("SerialNo,InputOrgID,InputUserID",false);
		//设置必输项
		doTemp.setRequired("CapitalDate,CapitalSum",true);
		//设置只读列
		doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true); 
		//设置日期的格式
		doTemp.setCheckFormat("BeginDate,CapitalDate,InputDate,UpdateDate,EndDate","3");
		//设置宽度
		doTemp.setEditStyle("Remark","3");
		doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px} ");
		//下拉窗口
		doTemp.setDDDWCode("IsUsedCreditCheck","YesNo");
	    //设置number值类型
	    doTemp.setType("CapitalSum","Number");
		doTemp.setAlign("CapitalSum","3");
		doTemp.setUnit("CapitalSum","元");
		//doTemp.setCheckFormat("CapitalSum","10");
		//设置字段输入长度
		doTemp.setLimit("Remark",100);
		//设置数字型字段校验规则

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/
%>
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
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert)
		{
			beforeInsert();
			//特殊增加,如果为新增保存,保存后页面刷新一下,防止主键被修改
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/CapitalSumList.jsp","_self","");
	}	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

	<script language=javascript>

		/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--重新获得流水号
		OpenPage("/SystemManage/SynthesisManage/CapitalSumInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
	}
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
       initSerialNo();//初始化流水号字段
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");//--获得当前日期
		setItemValue(0,0,"UpdateDate",sDay);
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;

			sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
		}
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CAPITAL_SUM";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
       
		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

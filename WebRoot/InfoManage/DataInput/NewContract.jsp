<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   bma 2008-09-19
		Tester:
		Content: 新增垫款补登
		Input Param:		
		Output param:
		History Log: 	
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增垫款补登"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号
	
	//将空值转化成空字符串
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { 
			{"PutoutDate","垫款发生日期"},
			{"SerialNo","借据号"},
			{"CustomerID","客户编号"},
			{"RelativeSerialNo1","原业务编号"},
			{"BusinessType","垫款种类"}
          }; 
	String sSql = "	select PutoutDate,CustomerID,SerialNo,RelativeSerialNo1,BusinessType from BUSINESS_DUEBILL where 1=2 ";
	
	//sql产生datawindows
	ASDataObject doTemp = new ASDataObject(sSql);
	//头名称
	doTemp.setHeader(sHeaders);
	//修改表
	doTemp.UpdateTable = "BUSINESS_DUEBILL";
    //设置主键
	doTemp.setKey("SerialNo",true);
	//设置不可修改的列
	//doTemp.setUpdateable("UserName,OrgName,Resouce",false);
    //设置不可见列
	doTemp.setVisible("CustomerID",false);
	//设置必输项
	doTemp.setRequired("PutoutDate,BusinessType",true);
	//设置只读列
	doTemp.setReadOnly("SerialNo,RelativeSerialNo1",true); 
	//设置日期的格式
	doTemp.setCheckFormat("PutoutDate","3");
	
	//下拉窗口
    doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo like '1130%' and TypeNo <> '1130'");
    
    //缺省值为有效标志
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	doTemp.setUnit("RelativeSerialNo1"," <input type=button value=.. onclick=parent.selectDueBill()>");
	
	//生成HTMLDataWindow
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
			{"true","","Button","确认","确认新增垫款补登","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消垫款补登","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
		
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{		
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=确定;InputParam=后续事件;OutPutParam=无;]~*/
	function doCreation()
	{
		saveRecord("doReturn()");
	}
	
	function doReturn()
	{
		sSerialNo = getItemValue(0,0,"SerialNo");		
		top.returnValue = sSerialNo;
		insertBalance();
		top.close();
	}
	
	function insertBalance()//以原业务编号作为流水号从BUSINESS_DUEBILL表中取余额Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance
	{
		sSerialNo = getItemValue(0,0,"SerialNo");
		sRelativeSerialNo1 = getItemValue(0,0,"RelativeSerialNo1");
		RunMethod("WorkFlowEngine","insertBalance",sRelativeSerialNo1+","+sSerialNo);
	}
		   
    /*~[Describe=取消新增;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	function selectDueBill()
	{  
		sParaString = "OrgID"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectDueBill",sParaString,"@RelativeSerialNo1@0@CustomerID@1",0,0,"");
	}
							
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录			
			initSerialNo() 		//初始化流水号
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_DUEBILL";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "BD";//前缀
								
		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
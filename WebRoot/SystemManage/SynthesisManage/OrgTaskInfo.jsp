<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Describe: 变更客户信息
			Input Param:
			Output Param:
			HistoryLog: fbkang on 2005/08/14 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "变更客户信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//获得变量：客户编号
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sCustomerID == null) sCustomerID = "";
	if(sSerialNo == null) sSerialNo = "";
	
	//定义变量：sql语句
	String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//根据客户编号获取客户类型
	//通过显示模版产生ASDataObject对象doTemp
	String sHeaders[][] = {	
					{"SerialNo","流水号"},	
					{"Year","年度"},
					{"OrgID","机构编号"},								
					{"OrgName","机构名称"},
					{"TaskIndex","任务指标"},
					{"Remark","备注"},
					{"InputUserName","登记人"},
					{"InputorgName","登记机构"}	,	
					{"InputDate","登记日期"},
					{"UpdateDate","更新日期"}
		          };
   
   sSql = " select SerialNo,Year,OrgID,OrgName,"+
   		  " TaskIndex,Remark,"+
   		  " InputOrgID,getOrgName(InputOrgID) as InputOrgName,"+
   		  " InputUserID,getUserName(InputUserID) as InputUserName,"+
   		  " InputDate,UpdateDate,TempSaveFlag"+
   		  " from Org_Task_Info "+
          " where SerialNo='"+sSerialNo+"'";
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "Org_Task_Info";
	doTemp.setKey("SerialNo",true);
	//设置字段是否可见
	doTemp.setVisible("SerialNo,InputOrgID,InputUserID,TempSaveFlag",false);
	doTemp.setUpdateable("InputOrgName,InputUserName",false);
	doTemp.setCheckFormat("TaskIndex","5");
	doTemp.setEditStyle("Remark","3");
	doTemp.setLimit("Remark",250);
	doTemp.setLimit("Year",4);
	//设置编辑属性
	doTemp.setReadOnly("OrgID,OrgName,InputOrgName,InputUserName,InputDate,UpdateDate",true);
	doTemp.setUnit("OrgName"," <input type=button value=.. onclick=parent.selectOrgID()>");
	doTemp.setRequired("OrgName,TaskIndex",true);
	//doTemp.appendHTMLStyle("Year","myvalid=\"parseFloat(myobj.value,10)<0\" mymsg=\"请输入数字化的年度值！\" ");
	//设置必输项和可见性	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置为Grid风格
		
	Vector vTemp = dwTemp.genHTMLDataWindow(""+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
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
			   {"true","","Button","保存","保存变更客户信息","saveRecord()",sResourcesPath}
			   
			};
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------	
	//*~[Describe=保存信息;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		var sYear =getItemValue("0","0","Year");
		if(isNaN(sYear)==true){
			alert("请输入年度值！");
			return;
		}
        as_save("myiframe0","newRecord");        
	}
   
	
	
	//*~[Describe=获取机构编码;InputParam=无;OutPutParam=无;]~*/
	function selectOrgID()
	{
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号			
			setObjectValue("selectOrgID","","@OrgID@0@OrgName@1",0,0,"");		
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	/*~[Describe=初始化企业编号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "ORG_TASK_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			initSerialNo();
		    bIsInsert = true;
		   
		}
	}
			
			
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:  bgzhang 2008-04-07
			Tester:
			Content: 承兑行管理
			Input Param:
			Output param:
			History Log: 

		 */
	%>
<%
	/*~END~*/
%> 
 

<%
  	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
  %>
	<%
		String PG_TITLE = "承兑行管理详细界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql="";//--存放sql语句
	//获得组件参数

	//获得页面参数	,流水号
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = { 							
		{"ObjectType","对象类型"},										
		{"ObjectNo","对象编号"},
		{"SerialNo","流水号"},
		{"BillNo","票据编号"}, 
		{"BillType","票据类型"},     
		{"Writer","出票人名称"},
		{"WriterID","出票人账号"},
		{"BillSum","票面金额(元)"},	
		{"WriteDate","票据签发日"},
		{"Maturity","票据到期日"},
		{"AccountNo","出票人结算账号"},
		{"GatheringName","收款人名称"},
		{"AboutBankID","收款人账号"},
		{"AboutBankName","收款行行名"},
		{"FinishDate","解付日期"},
			}; 
		
		 sSql =	" select ObjectType,ObjectNo,SerialNo,BillNo,BillType,Writer,WriterID,BillSum, "+
			" WriteDate,Maturity,AccountNo,GatheringName,AboutBankID,AboutBankName,"+
			" FinishDate "+
			" from BILL_INFO " +
			" where ObjectType='"+sObjectType+"'  "+
			" and ObjectNo ='"+sObjectNo+"' order by SerialNo ";
	    //sql产生datawindows
		ASDataObject doTemp = new ASDataObject(sSql);
		//头名称
		doTemp.setHeader(sHeaders);
		//修改表
		doTemp.UpdateTable = "BILL_INFO";
	    //设置主键
		doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
		doTemp.setAlign("actualSum,actualint,Rate,BillSum,Term,EndorseTimes,AcceptDays","3");
		doTemp.setType("actualSum,actualint,Rate,BillSum","Number");
		doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
		doTemp.setCheckFormat("WriteDate,Maturity,FinishDate,SearchDate,ApproveDate,InputDate","3");
		doTemp.setVisible("ObjectType,ObjectNo",false); 
		doTemp.setDDDWCode("HolderID","BillResource");
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
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

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
	}	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

	<script language=javascript>

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;

		}
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
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: jytian 2004-12-21
			Tester:
			Describe:文档附件列表
			Input Param:
	       		文档编号:BatchNo
			Output Param:

			HistoryLog:zywei 2005/09/03 重检代码
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "文档附件列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量                     
    String sSql = "";   	
	//获得页面参数
	
	//获得组件参数
	String sSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));
%>
<%
	/*~END~*/
%>
<html>
<head>还款信息</head>
	<body leftmargin="0" topmargin="0" class="windowbackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
					<tr>
		              <td nowrap bgcolor= #dcdcdc bordercolorlight='#dcdcdc' bordercolordark='#dcdcdc' class="pt9song">
			            <table width=97% border=0 align="right" cellpadding=5 height=100%>
			              <tr>
			                    <td class="pt9song">
			                    <font color="#FFFFFF">
			                    <marquee behavior="scroll" DIRECTION="up" width=100% height=100%  scrollamount=2 scrolldelay=50 onMouseOver="this.stop();" onMouseOut="this.start();" bgcolor="#6382BC" style="padding-left:5">
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><zhp>&nbsp</p><p>&nbsp</p><p>&nbsp</p><!--加空行解决滚动区域的问题-->
				                 <%
				                 	String sInputDate = "",sLCustomerName = "",sActualPayBackDate="";
				                 		                  Double dActualPayBackSum=0.0,dBalance=0.0;
				                 		                  ASResultSet rs = Sqlca.getASResultSet("select InputDate,"+
				                 		                  								"LCustomerName,"+
				                 		                  								"LSum,"+
				                 		                  								"ActualPayBackDate,"+
				                 		                  								"ActualPayBackSum,"+
				                 				                  						"Balance"+
				                 		                  								" from Batch_Case_History"+
				                 				                  						" where SerialNo = '"+sSerialNo+"'");
				                 		                  while(rs.next()){
				                 		                    sInputDate = DataConvert.toString(rs.getString("InputDate"));
				                 		                    sLCustomerName = DataConvert.toString(rs.getString("LCustomerName"));
				                 		                    sActualPayBackDate = DataConvert.toString(rs.getString("ActualPayBackDate"));
				                 		                    dActualPayBackSum = rs.getDouble("ActualPayBackSum");
				                 		                    dBalance = rs.getDouble("Balance");
				                 		                    out.print("<li style='cursor:hand' >");
				                 		                    // out.print("<span onclick='javascript:openFile(\""+rs.getString(1)+"\")'>"+rs.getString(2)+"</span>");
				                 		                    out.print("<span>于"+sInputDate+"还款"+dActualPayBackSum+"元，余额"+dBalance+"元</span>");
				                 		                    //out.print("<img src='"+sResourcesPath+"/new.gif' border=0>");
				                 		                    out.print("<br><br>");
				                 		                  }
				                 		                  rs.getStatement().close();
				                 %>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
			                	</marquee>
			                    </font>
			                  </td>
			                 </tr>
		                </table>
	                 </td>
	                 <td nowrap bgcolor= #dcdcdc bordercolorlight='#dcdcdc' bordercolordark='#dcdcdc' class="pt9song">
			            <table width=97% border=0 align="right" cellpadding=5 height=100%>
			              <tr>
			                    <td class="pt9song">
			                    <font color="#FFFFFF">
			                    <marquee behavior="scroll" DIRECTION="up" width=100% height=100%  scrollamount=2 scrolldelay=50 onMouseOver="this.stop();" onMouseOut="this.start();" bgcolor="#6382BC" style="padding-left:5">
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><zhp>&nbsp</p><p>&nbsp</p><p>&nbsp</p><!--加空行解决滚动区域的问题-->
				                 <%
				                 	rs = Sqlca.getASResultSet("select InputDate,"+
				                 		                  								"LCustomerName,"+
				                 		                  								"LSum,"+
				                 		                  								"ActualPayBackDate,"+
				                 		                  								"ActualPayBackSum,"+
				                 				                  						"Balance"+
				                 		                  								" from Batch_Case_History"+
				                 				                  						" where SerialNo = '"+sSerialNo+"'");
				                 		                  while(rs.next()){
				                 		                    sInputDate = DataConvert.toString(rs.getString("InputDate"));
				                 		                    sLCustomerName = DataConvert.toString(rs.getString("LCustomerName"));
				                 		                    sActualPayBackDate = DataConvert.toString(rs.getString("ActualPayBackDate"));
				                 		                    dActualPayBackSum = rs.getDouble("ActualPayBackSum");
				                 		                    dBalance = rs.getDouble("Balance");
				                 		                    out.print("<li style='cursor:hand' >");
				                 		                    // out.print("<span onclick='javascript:openFile(\""+rs.getString(1)+"\")'>"+rs.getString(2)+"</span>");
				                 		                    out.print("<span>于"+sInputDate+"还款"+dActualPayBackSum+"元，余额"+dBalance+"元</span>");
				                 		                    //out.print("<img src='"+sResourcesPath+"/new.gif' border=0>");
				                 		                    out.print("<br><br>");
				                 		                  }
				                 		                  rs.getStatement().close();
				                 %>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
			                	</marquee>
			                    </font>
			                  </td>
			                 </tr>
		                </table>
	                 </td>
	                </tr>
				</table>
	</body>
</html>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	var bIsInsert = false; //标记DW是否处于“新增状态”
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0","");
	}
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CodeNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>


	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  mjpeng 2011-1-19
		Tester:
		Content:  --得到利率代号
		Input Param:
	        RateID：利率代号
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "基准利率历史修改记录"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得组件参数,利率代号
	String sRateID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RateID"));
	//将空值转化为空字符串
	if(sRateID == null) sRateID = "";           
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获取数据值 ;]~*/%>
<%     
	ASResultSet rs = null;
	String sSql = "select * From Rate_Info where RateID = '"+sRateID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		
		String sSql1 = "insert into RATE_INFOLOG values('"+DataConvert.toString(DataConvert.toString(rs.getString("AREANO")))+"','"+DataConvert.toString(rs.getString("EFFICIENTDATE"))+" "+DataConvert.toString(rs.getString("TERM"))+"',"+
						"'"+sRateID+"',"+rs.getDouble("RATE")+","+rs.getInt("RATECYC")+","+
						"'"+DataConvert.toString(rs.getString("CURRENCY"))+"','"+DataConvert.toString(rs.getString("STATUS"))+"','"+DataConvert.toString(rs.getString("REMARK"))+"',"+
						"'"+DataConvert.toString(rs.getString("RATENAME"))+"','"+DataConvert.toString(rs.getString("RATETYPE"))+"','"+DataConvert.toString(rs.getString("RATEIDTYPE"))+"',"+
						"'"+DataConvert.toString(rs.getString("TERM"))+"')";
		Sqlca.executeSQL(sSql1);
	}
	rs.close();
    
%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>

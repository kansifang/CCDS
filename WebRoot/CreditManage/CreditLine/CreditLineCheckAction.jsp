<%@ page  import="com.amarsoft.app.creditline.*" %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:jbye 2005-09-01 9:43
		Tester:
		Content: 执行额度检查
		Input Param:
			LineID： 	授信协议编号
			ObjectType：校验对象类型
				BusinessApply 申请对象
				BusinessApprove 批复对象
				BusinessContract 合同对象
			sObjectNo： 校验对象编号
				对应对象的 SerialNo
		Output param:
			sReturnValue : 是否可以通过检查
				Pass 通过
				Refuse 拒绝
		History Log: 
			jbye 按照实际的需要整体修改校验机制和错误展现机制

	 */
	%>
<%/*~END~*/%>

<%
	
	String []sErrorLog;
	sErrorLog = new String[30];
	int i = 0,num = 0;
	String sSql = "",sCheckResult = "",sReturnValue = "Refuse",sLineID = "",sObjectType = "",sObjectNo = "";
	ASResultSet rs = null;
	
	sLineID = DataConvert.toRealString(iPostChange,CurPage.getParameter("LineID"));
	sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	
	CreditLine line = new CreditLine(Sqlca,sLineID);
	sObjectType = "BusinessApply";
	sObjectNo = "BA20050714000001";
	/*
	double dBalance = line.getBalance(Sqlca);
	out.println("余额1："+dBalance);
	*/
	try
	{
		String sResult = "pass",sError = "";
		//进入检查模式
		line.enterCheckMode(Sqlca);
		//开始进行检查
		Vector errors = line.check(Sqlca,"LOG=Y",sObjectType,sObjectNo);
	    StringBuffer sbErrorNotes = new StringBuffer(); 
	    //解析错误类型
	    if(errors.size()>0){
	    	sResult = "fail";
	    	for(i=0;i<errors.size();i++){
	    		sbErrorNotes.append((String)errors.get(i)+";");
	    		sError = (String)errors.get(i);
	    		//取得sSource 被 ; 分割的第 1 个部分
	    		sError = StringFunction.getSeparate(sError,";",1);
	    		//取出字符串data中以字符串 ErrorType= 开始以字符串 ; 结束的字符串
	    		sError = StringFunction.getProfileString(sError,"ErrorType",";");
	    		//转换错误类型为中文
	    		sSql = "select ErrorTypeName from CL_ERROR_TYPE where  ErrorTypeID='"+sError+"'";
		        rs = Sqlca.getASResultSet(sSql);
		        if(rs.next())
				{ 
		        	sError = rs.getString("ErrorTypeName");
				}
				rs.getStatement().close();
				//将错误提示保存
				sErrorLog[i] = sError;
	    	}
	    }
		sCheckResult = sResult+"@"+sbErrorNotes.toString();
	}finally
	{
		//解除检查模式
		line.exitCheckMode(Sqlca);
	}
	//if(sResult.equals("pass"))	sCheckResult = "成功";
	num=i;
%>
<html>

<head>
<title>授信检查 <%=sLineID%></title>
</head>

<body bgcolor="#EAEAEA" >
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td width="62%" valign="top"> 

<p>系统探测到该授信项下出现的问题包括：</p>

<table width="100%" border="1" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">

<%
	
   	for(i=0;i<num;i++)
   	{
%>    
    	<tr bgcolor=#fafafa>
			<td >
				<font color=red>
	        			<%        			
	        			out.print((i+1)+"、"+sErrorLog[i]);
	        			%>
				</font>
			</td>	
		</tr>
<%  }
	//表示没有任何问题则返回值为 Pass
	if(i==0) {
		out.println("--        无");
		sReturnValue = "Pass";
	}
	
%>
	
</table>
	<tr>
		<td align = center> 
	       		 <input type="button" style="width:50px"  value=" 关  闭 " class="button" onclick="javascipt:go_back()">
	    </td>
    </tr>
</table>


</body>
</html>
<script language=javascript>
	function go_back()
	{
	    self.returnValue = "<%=sReturnValue%>";
	    self.close()
	}
	<%
	//如果没有任何问题自动关闭 add by jbye 2005-09-01 10:08
	/*
	if(i==0){	
		out.println("self.returnValue ='"+sReturnValue+"'");	
		out.println("self.close();");	
	}
	*/
	%>
</script>

<%@ include file="/IncludeEnd.jsp"%>

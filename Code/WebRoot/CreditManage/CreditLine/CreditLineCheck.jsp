<%@ page contentType="text/html; charset=GBK"%>
<%@ page  import="com.amarsoft.app.creditline.*" %>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:jbye 2005-09-01 9:43
		Tester:
		Content: 执行额度检查
		Input Param:
			LineID：授信协议编号
			ObjectType：校验对象类型
				CreditApply 申请对象
				AgreeApproveApply 批复对象
				BusinessContract 合同对象
			sObjectNo： 校验对象编号
				对应对象的 SerialNo
		Output param:
			sReturnValue : 是否可以通过检查
				Pass 通过
				Refuse 拒绝
		History Log: 
			jbye 按照实际的需要整体修改校验机制和错误展现机制
			zywei 重检代码 2005/12/23

	 */
	%>
<%/*~END~*/%>

<%
	
	String []sErrorLog = new String[30];
	int i = 0,num = 0,iCount = 0;
	String sSql = "",sReturnValue = "Pass",sLineID = "";
	String sObjectType = "",sObjectNo = "",sErrorTypeID = "",sErrorTypeName = "";
	ASResultSet rs = null;
	
	sLineID = DataConvert.toRealString(iPostChange,CurPage.getParameter("LineID"));
	sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	
	CreditLine line = new CreditLine(Sqlca,sLineID);

	//计算授信余额
	//double dBalance = line.getBalance(Sqlca);
	
	//计算授信敞口余额
	String dBalance2 = DataConvert.toMoney(line.getBalance(Sqlca,"LineSum2"));
	
	try
	{		
		//进入检查模式
		line.enterCheckMode(Sqlca);
		//开始进行检查
		Vector errors = line.check(Sqlca,"LOG=Y",sObjectType,sObjectNo);
	    StringBuffer sbErrorNotes = new StringBuffer(); 
	    
	    //解析错误类型
	    if(errors.size()>0){	    	
	    	for(i=0;i<errors.size();i++){
	    		sbErrorNotes.append((String)errors.get(i)+";");
	    		sErrorTypeID = (String)errors.get(i);
	    		//取得sSource 被 ; 分割的第 1 个部分
	    		sErrorTypeID = StringFunction.getSeparate(sErrorTypeID,";",1);
	    		//取出字符串data中以字符串 ErrorType= 开始以字符串 ; 结束的字符串
	    		sErrorTypeID = StringFunction.getProfileString(sErrorTypeID,"ErrorType",";");
	    		//转换错误类型为中文
	    		sSql = "select ErrorTypeName from CL_ERROR_TYPE where  ErrorTypeID='"+sErrorTypeID+"'";
		        rs = Sqlca.getASResultSet(sSql);
		        if(rs.next())
				{ 
		        	sErrorTypeName = rs.getString("ErrorTypeName");
				}
				rs.getStatement().close();

				//将错误提示保存
				sErrorLog[i] = sErrorTypeName;
				sReturnValue = "Refuse";
	    	}
	    	iCount = i;
	    }
	}finally
	{
		//解除检查模式
		line.exitCheckMode(Sqlca);
	}
	
	if(sReturnValue.equals("Pass"))	
	{
%>
	<script language=javascript>
		self.returnValue = "<%=sReturnValue%>";
		self.close();
	</script>
<%
	}else
	{
%>
<html>

<head>
<title>授信额度检查结果</title>
</head>

<body bgcolor="#EAEAEA" >
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td width="62%" valign="top"> 
	<p>系统自动检测当前业务与其占用的授信额度不符的要素为：</p>
	<table width="100%" border="1" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">
	<%	
   	for(i=0;i<iCount;i++)
   	{
	%>    
    	<tr bgcolor=#fafafa>
			<td >
				<font color=red>
    			<%   
	    			num = i + 1;     			
	    			out.print(num+":"+sErrorLog[i]);
    			%>
				</font>
			</td>	
		</tr>
	<%}%>	
	</table>
	<table width="100%" border="1" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">
		<tr>
			<td align = center> 
		    	<input type="button" style="width:50px"  value=" 关  闭 " class="button" onclick="javascipt: self.returnValue = '<%=sReturnValue%>';self.close();">
		    </td>
	    </tr>
    </table>
</table>

</body>
</html>
<%
}
%>

<%@ include file="/IncludeEnd.jsp"%>

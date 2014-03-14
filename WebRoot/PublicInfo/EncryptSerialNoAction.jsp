<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: zywei 2006-09-09
			Tester:
			Describe: 获得加密后的流水号
			Input Param:
		EncryptionType：加密类型
		SerialNo：流水号（加密前）
			Output Param:
		SerialNo：流水号（加密后）
			HistoryLog:
		 */
	%>
<%
	/*~END~*/
%>

<%
	//获得页面参数
		String sEncryptionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EncryptionType"));
		String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
		//将空值转化后空字符串
		if(sEncryptionType == null) sEncryptionType = "";
		if(sSerialNo == null) sSerialNo = "";
		
		//使用MD5加密技术进行加密
		if(sEncryptionType.equals("MD5"))
		{
	MD5 o_md5 = new MD5();
    		sSerialNo = o_md5.getMD5ofStr(sSerialNo);
		}
%>
 <script language=javascript>
	self.returnValue='<%=sSerialNo%>';
	self.close();
 </script>
<%@	include file="/IncludeEnd.jsp"%>
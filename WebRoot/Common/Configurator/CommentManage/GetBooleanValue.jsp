<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
 
<%
 	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
 %>
	<%
		/*
			Author:   
			Tester:
			Content: 主页面
			Input Param:
		          
			Output param:
		      
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>
<%
	String sTempStr = DataConvert.toRealString(iPostChange,(String)request.getParameter("sTempStr"));
	String sChangeValue = "" ;
	String tmpValue ="";
	String sTempValue = Sqlca.getString("select Count(*) from reg_comment_item where SortNo = '"+sTempStr+"'");
	out.println(sTempValue) ;
	if(Integer.parseInt(sTempValue) == 0) {
		sChangeValue = "1" ;
	}else {
		tmpValue = sTempStr.substring(0,4) ;
		String sMaxValue = Sqlca.getString("select Max(SortNo) from reg_comment_item where Sortno Like '%"+tmpValue+"%'") ;
		int sValue = Integer.parseInt(sMaxValue) ;
		int Value = sValue + 10 ;
		sChangeValue = String.valueOf(Value) ;
	}
%>
<script language=javascript>
	self.returnValue = "<%=sChangeValue%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
                                                                                                                    
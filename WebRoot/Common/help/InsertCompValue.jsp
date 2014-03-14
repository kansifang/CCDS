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
	String sYear = StringFunction.getToday().substring(0,4) ;
	//获得参数
	boolean isOk = false ;
	ASResultSet rs = null;
	int i = 0;
	String sCompID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CompID")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType")); 
	String sCommentItemID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CommentItemID"));
	String sSql = "" ;
	sSql = "select Count(*) from REG_COMMENT_RELA where Commentitemid = '"+sCommentItemID+"' and ObjectType='"+sObjectType+"' and ObjectNo = '"+sCompID+"'" ;
	rs = SqlcaRepository.getResultSet(sSql);
	if(rs.next()) {
		i = rs.getInt(1) ;
	}
	if(i > 0) {
		isOk = false ;
	}else {
		sSql = "insert into REG_COMMENT_RELA(CommentitemId,ObjectType,ObjectNo) values ('"+sCommentItemID+"','"+sObjectType+"','"+sCompID+"')" ;
		i = SqlcaRepository.executeSQL(sSql) ;
		if(i == 1) {
	isOk = true;
		}else {
	isOk = false ;
		}
	}
	rs.getStatement().close();
%>
<script language=javascript>
	//alert("<%=isOk%>") ;
	self.returnValue = "<%=isOk%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
                                      
							
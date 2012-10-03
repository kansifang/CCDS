<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
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
<%/*~END~*/%>
<%
	String sYear = StringFunction.getToday().substring(0,4) ;
	String sSql ="";
	int sValue=0;
	//获得参数	
	String sCommentText = DataConvert.toRealString(iPostChange,(String)request.getParameter("CommentText")); 
	String sCommentItemName = DataConvert.toRealString(iPostChange,(String)request.getParameter("CommentItemName")); 
	String sTableName = DataConvert.toRealString(iPostChange,(String)request.getParameter("TableName"));
	//String sCommentItemID = DBFunction.getSerialNo("REG_COMMENT_ITEM","CommentItemID",Sqlca);
	String sCommentItemID = "";
	String sMaxSerialNo = Sqlca.getString("select Max(CommentItemID) from REG_COMMENT_ITEM where CommentItemID like 'PIC%'");
	if(sMaxSerialNo==null) sCommentItemID = "PIC000001";
	else{
		int iMax = Integer.parseInt(sMaxSerialNo.substring(3));
		int iNewMax = iMax + 1;
		String sNewMax = String.valueOf(iNewMax);
		int iLength = 6 - sNewMax.length();
		String sPreZero = "";
		for(int i=0;i<iLength;i++) sPreZero += "0";
		sCommentItemID = "PIC"+sPreZero + sNewMax;

	}


	sSql = "insert into Reg_Comment_Item(CommentItemID,CommentItemName,SortNo,CommentItemType,CommentText,DogenHelp,InputUser,inputOrg,InputTime,UpdateUser,UpdateTime,Remark) values ('"+sCommentItemID+"','"+sCommentItemName+"','"+sCommentItemID+"','060','screens/"+sCommentText+"','false','"+CurUser.UserName+"','"+CurOrg.OrgName+"','"+StringFunction.getToday()+"','"+CurUser.UserName+"','"+StringFunction.getToday()+"','width=640 height=480')" ;
	sValue = Sqlca.executeSQL(sSql) ;

%>
<script language=javascript>
	self.returnValue = "<%=sCommentItemID%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
                                                                                                                    
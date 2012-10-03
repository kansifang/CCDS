<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%@ page language="java" 
 import="com.amarsoft.web.jspgen.*"     
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Dialog00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zxu 2005-01-21
		Tester:
		Content: 生成JSP页面
		Input Param:
                  
		Output param:
		                
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Dialog01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Dialog02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sSortNo; //排序编号
	
	//获得组件参数	
	String sPageID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PageID"));
	String sCompID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CompID"));
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ServerRootPath"));

	if(sPageID==null) sPageID="";
	if(sCompID==null) sCompID="";

	try{
	        System.out.println("writing sPageID:"+sPageID);

		String[][] ssURL = Sqlca.getStringMatrix("select PageURL, ItemDescribe from REG_PAGE_DEF,CODE_LIBRARY where PageID='"+sPageID+"' and CodeNo='JSPModel' and ItemNo=JspModel ");
		String sPageURL = ssURL[0][0];
		String sMdlURL = ssURL[0][1];
		
		String sData = ASJspReader.readFileToString(sRealPath+sMdlURL);
		
		ASJspGenerate jspGen = new ASJspGenerate(sRealPath,sPageID,CurUser);
	    
		String sbCodeBody = jspGen.parseJspModel(sData, Sqlca,sPageID,sCompID);

		ASJspWriter.writeToFile(sRealPath+sPageURL,sbCodeBody);
		%>
		<script language="javascript">
		self.returnValue="succeeded";
		self.close();
		</script>
		<%
	}catch(Exception ex){
		out.println("生成失败!错误:"+ex.toString());
		%>
		<script language="javascript">
		self.returnValue="failed";
		</script>
		<%
	}
 
	//获得页面参数	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>





<%@ include file="/IncludeEnd.jsp"%>

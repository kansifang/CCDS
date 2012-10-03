<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.util.ASLocator"%>
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
	StringBuffer sbReturn = new StringBuffer("");
	String sReturn;
	
	//获得组件参数	
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FilePath"));

	if(sRealPath==null) sRealPath="";

	try{
		System.out.println("Get Real Path File List--"+sRealPath);

		String[] saFileList = ASLocator.getFileList(sRealPath,".xml");
		for( int i=0; i < saFileList.length; i++ )
		{
			if( i > 0 ) sbReturn.append("$");
			sbReturn.append(saFileList[i]);
		}
		sReturn = sbReturn.toString();
		//oe.importFromXml(Sqlca,sObjectType+"_"+sObjectNo+".xml");
		%>
		<script language="javascript">
		self.returnValue="<%=sReturn%>";
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

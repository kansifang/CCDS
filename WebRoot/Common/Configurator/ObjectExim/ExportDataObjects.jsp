<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.util.ObjectExim"%>
<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Dialog00;Describe=注释区;]~*/
%>
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
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Dialog01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Dialog02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String[] saObjects ;
	String sOldObjectType="";
	String sObjectType,sObjectNo;
	ObjectExim oe=null;
	
	//获得组件参数	
	String sObjectValue =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("column_selection"));
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FilePath"));
		
	if(sObjectValue==null) sObjectValue="";
	if(sRealPath==null) sRealPath="";
	sRealPath = sRealPath.trim();
	
	//如果不是以“\”结束，自动加上
	if(sRealPath.length()>1 && !sRealPath.substring(sRealPath.length()-1).equals(ASConfigure.sCurSlash)){
		sRealPath = sRealPath + ASConfigure.sCurSlash;
	}
	
	try{
		saObjects = StringFunction.toStringArray(sObjectValue,"\r\n");
		Vector errors = new Vector();
		for(int i=0;i<saObjects.length-1;i++)
		{
	try{
		sObjectType=StringFunction.getSeparate(saObjects[i],".",1);
		sObjectNo=StringFunction.getSeparate(saObjects[i],".",2);
		if(sObjectType.indexOf("\\")>=0) throw new Exception("非法的对象类型名称："+sObjectType);
		if(sObjectType.indexOf("/")>=0) throw new Exception("非法的对象类型名称："+sObjectType);
		if(sObjectNo.indexOf("\\")>=0) throw new Exception("非法的对象名称："+sObjectNo+"["+sObjectType+"]");
		if(sObjectNo.indexOf("/")>=0) throw new Exception("非法的对象名称："+sObjectNo+"["+sObjectType+"]");
		if( sObjectType == "" || sObjectNo == "" )
			throw new Exception("信息定义不完整：ObjectType["+sObjectType+"].ObjectNo["+sObjectNo+"]");
		if( !sObjectType.equals(sOldObjectType) )
		{
			sOldObjectType = sObjectType;
			System.out.println("New ObjectExim:"+sObjectType);
			oe = new ObjectExim(Sqlca,sObjectType,sRealPath);
		}
		//oe.setSDefaultSchema("INFORMIX");
		System.out.println("Export DataObject--"+sObjectType+":"+sObjectNo);
		oe.exportToXml(Sqlca,sObjectNo);
	}catch(Exception ex){
		errors.add(ex.getMessage());
	}
		
		}
		System.out.println("导出完毕.............");
		if(errors.size()<=0){
%>
			<script language="javascript">
			self.returnValue="succeeded";
			alert("数据导出成功：请到您指定的目录下检查文件！");
			self.close();
			</script>
			<%
				}else{
				out.println("数据导出已完成，其中错误"+errors.size()+"个。");
				for(int i=0;i<errors.size();i++) out.println((String)errors.get(i)+"<br>");
			%>
			<script language="javascript">
			self.returnValue="failed";
			</script>
			<%
				}
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
<%
	/*~END~*/
%>





<%@ include file="/IncludeEnd.jsp"%>

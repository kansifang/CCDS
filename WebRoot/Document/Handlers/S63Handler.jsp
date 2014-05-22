<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.util.Date,com.lmt.baseapp.Import.base.*"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*

		 */
	%>
<%
	/*~END~*/
%> 

<%
 	//调用页面传入参数
  		String sType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type")));
 		String sConfigNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ConfigNo")));
 		String sKey =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Key")));
  		String sReportDate =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate")));
  		//FileUpload传入参数
  		String sClearTable =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClearTable")));
  		//FileUpload传入参数
  		String sFiles =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Files")));
  		//定义变量：SQL语句、意见详情
  		String sSql = "",sMessage="";
  		ASResultSet rs=null;
  		HashMap<String, String> mmReplace = new HashMap<String, String>();
  		HashMap<String, String> mmAutoSet = new HashMap<String, String>();
  		PreparedStatement ps1 = null,ps2 = null,ps3 = null,ps4 = null;
  		String sImportTableName="Batch_Import";
  		boolean isAutoCommit=false;
 		try {
 		 	isAutoCommit=Sqlca.conn.getAutoCommit();
 		 	Sqlca.conn.setAutoCommit(false);
 		 	Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and Key='"+sKey+"'");
 		 	//导入文件
 		 	EntranceImpl efih=new ExcelBigEntrance(sFiles,sImportTableName,CurUser,Sqlca);
 		 	efih.action(sConfigNo,sKey);
 	 		//更新配置号和报表日期
 	 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 	 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and Key='"+sKey+"' and ImportNo like 'N%000000'");
 	 		//计算总领增加额和比例
  		}catch (Exception e) {
 		 	sMessage=e.getMessage(); 	
 		 	out.println("An error occurs : " + e.toString());
 		 	sMessage="false";
 		 	e.printStackTrace();
 		 	Sqlca.conn.rollback();
 		 	throw e;
 		}finally{
 	 		Sqlca.conn.setAutoCommit(isAutoCommit);
 	 	}
 %>
<script language=javascript>
	self.returnValue = "<%=sMessage%>";
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>
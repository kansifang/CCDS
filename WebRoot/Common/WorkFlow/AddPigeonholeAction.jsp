<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-17
		Tester:
		Describe: 完成归档/取消归档操作的通用模块
		Input Param:
			ObjectType: 对象类型
			ObjectNo: 对象编号
			Pigeonholed:归档标志(Y/N)
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%
	String sObjectType = DataConvert.toRealString(iPostChange,request.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,request.getParameter("ObjectNo"));
    String sPigeonholed = DataConvert.toRealString(iPostChange,request.getParameter("Pigeonholed"));//归档标志取Y/N
	
	if (sPigeonholed==null) sPigeonholed="";
   	
   	 String sTable="";//归档/取消归档的表对象
     String sSql="";

	//根据sObjectType的不同，得到不同的关联表名
	sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sTable=DataConvert.toString(rs.getString("ObjectTable"));
	}
	rs.getStatement().close(); 
    
    if(sPigeonholed.equals("Y"))//已归档
        sSql="UPDATE " + sTable + " SET PigeonholeDate=null";
    else sSql="UPDATE " + sTable + " SET PigeonholeDate='" + StringFunction.getToday() + "'";
    
    sSql=sSql + " where SerialNo='" + sObjectNo + "'";
    Sqlca.executeSQL(sSql);
%>

<script language=javascript>
    self.returnValue="true";
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>
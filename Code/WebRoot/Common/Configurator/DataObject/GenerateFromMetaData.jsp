<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Dialog00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu 2005-01-05
		Tester:
		Content: 生成显示模版
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
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DoNo"));
	String sDatabaseID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DatabaseID"));
	String sTableID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TableID"));

	if(sDoNo==null) sDoNo="";
	if(sDatabaseID==null) sDatabaseID="";
    if (sTableID==null) sTableID=""; 


	sSql = "insert into DATAOBJECT_LIBRARY "
	+" ( "
	+"	DONo, "
	+"	ColIndex, "
	+"	ColTableName, "
	+"	ColActualName, "
	+"	ColName, "
	+"	ColHeader, "
	+"	ColType, "
	+"	colcheckformat, "
	+"	DataPrecision, "
	+"	DataScale, "
	+"	ColLimit, "
	+"	SortNo, "
	+"	coleditstyle, "
	+"	colalign, "
	+"	COLKEY, "
	+"	COLUPDATEABLE, "
	+"	COLVISIBLE, "
	+"	COLREADONLY, "
	+"	COLREQUIRED, "
	+"	COLSORTABLE, "
	+"	COLCHECKITEM, "
	+"	COLTRANSFERBACK, "
	+"	ISINUSE, "
	+"	colColumnType "
	+" ) "
	+" ( "
	+" select "
	+"	'"+sDoNo+"', "
	+"	ltrim(rtrim(SortNo||'0')), "
	+"	tableid, "
	+"	colid, "
	+"	colid, "
	+"	colname, "
	+"	case when ColType='NUMBER' then 'Number'  "
	+"		  when ColType='VARCHAR2' then 'String'  "
	+"	     else 'String' end, "
	+"	case when ColType='NUMBER' then (case when convert(int,DataScale)=0 then '5' else '2' end) "    //Sybase 版 Remark By wuxiong 2005-02-24
	+"		  when ColType='VARCHAR2' then '1'  "
	+"	     else '1' end, "
	+"	convert(numeric,DataPrecision), "	//Sybase 版 Remark By wuxiong 2005-02-24
	+"	convert(numeric,DataScale), "		//Sybase 版 Remark By wuxiong 2005-02-24
	+"   case when ColType='VARCHAR2' then ColLimit "
	+"		  when ColType='VARCHAR' then ColLimit "
	+"		  when ColType='CHAR' then ColLimit "
	+"	   	else '0' end, "
	+"	SortNo, "
	+"	'1', "//coleditstyle
	+"	case when ColType='NUMBER' then '3' when ColType='VARCHAR2' then '1' else '1' end, " //colalign
	+"	'0',  "//COLKEY
	+"	'1',  "//COLUPDATEABLE
	+"	'1',  "//colvisible
	+"	'0',  "//colreadonly
	+"	'0',  "//colrequired
	+"	'1',  "//colsortable
	+"	'1', "//COLCHECKITEM
	+"	'0', "//COLTRANSFERBACK,
	+"	'1', "//ISINUSE
	+"	'1' "	//colColumnType
	+" from meta_column  "
	+" where databaseid='"+sDatabaseID+"' and tableid='"+sTableID+"' "
	+" ) ";
	try{
		Sqlca.executeSQL(sSql);
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

<%@ include file="/IncludeBeginMD.jsp"%>
<%
String sDataSource = CurConfig.getConfigure("DataSource");
String sDataSourceReport = CurConfig.getConfigure("DataSource_Report");
//如果报表的数据源和主系统的数据源一致，则不再重新获取数据库连接
if (!sDataSource.equals(sDataSourceReport)) {
	if(Sqlca != SqlcaRepository)
	{
	    Sqlca.conn.commit();
	    Sqlca.disConnect();
	    Sqlca = null;
	}
	
	try{
		javax.sql.DataSource ds_report = ConnectionManager.getDataSource(sDataSourceReport);
	    Sqlca = ConnectionManager.getTransaction(ds_report);
	    //add in 2008/04/10,2008/02/14 for DataSourceName
	    Sqlca.setDataSourceName(sDataSourceReport);
	}catch(Exception ex){
		ex.printStackTrace();
	    throw new Exception("连接数据库失败！连接参数：<br>DataSource_Report:"+sDataSourceReport);
	}
}
%>
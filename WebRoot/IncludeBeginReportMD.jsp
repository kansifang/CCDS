<%@ include file="/IncludeBeginMD.jsp"%>
<%
String sDataSource = CurConfig.getConfigure("DataSource");
String sDataSourceReport = CurConfig.getConfigure("DataSource_Report");
//������������Դ����ϵͳ������Դһ�£��������»�ȡ���ݿ�����
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
	    throw new Exception("�������ݿ�ʧ�ܣ����Ӳ�����<br>DataSource_Report:"+sDataSourceReport);
	}
}
%>
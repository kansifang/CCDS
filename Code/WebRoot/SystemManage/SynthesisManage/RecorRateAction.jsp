<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  mjpeng 2011-1-19
		Tester:
		Content:  --�õ����ʴ���
		Input Param:
	        RateID�����ʴ���
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��׼������ʷ�޸ļ�¼"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//����������,���ʴ���
	String sRateID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RateID"));
	//����ֵת��Ϊ���ַ���
	if(sRateID == null) sRateID = "";           
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ȡ����ֵ ;]~*/%>
<%     
	ASResultSet rs = null;
	String sSql = "select * From Rate_Info where RateID = '"+sRateID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		
		String sSql1 = "insert into RATE_INFOLOG values('"+DataConvert.toString(DataConvert.toString(rs.getString("AREANO")))+"','"+DataConvert.toString(rs.getString("EFFICIENTDATE"))+" "+DataConvert.toString(rs.getString("TERM"))+"',"+
						"'"+sRateID+"',"+rs.getDouble("RATE")+","+rs.getInt("RATECYC")+","+
						"'"+DataConvert.toString(rs.getString("CURRENCY"))+"','"+DataConvert.toString(rs.getString("STATUS"))+"','"+DataConvert.toString(rs.getString("REMARK"))+"',"+
						"'"+DataConvert.toString(rs.getString("RATENAME"))+"','"+DataConvert.toString(rs.getString("RATETYPE"))+"','"+DataConvert.toString(rs.getString("RATEIDTYPE"))+"',"+
						"'"+DataConvert.toString(rs.getString("TERM"))+"')";
		Sqlca.executeSQL(sSql1);
	}
	rs.close();
    
%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>

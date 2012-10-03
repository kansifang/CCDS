<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat" %>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ndeng  2005.1.24
		Tester:
		Content: ������ɲ���
		Input Param:
			                sSerialNo: ��ˮ��
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>���������</title>
<%
	String sSql;
	boolean bFinishFlag=false;
	String sFinishType="";
	ASResultSet rs = null;
	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sInspectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("InspectType"));
	//����Ǵ�����;����
	if(sObjectType.equals("BusinessContract"))
	{
		sSql = "update INSPECT_INFO set finishdate='"+StringFunction.getToday()+"',UpdateDate='"+StringFunction.getToday()+"'"+
			" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'";
			Sqlca.executeSQL(sSql);
		sFinishType="Purpose";
		bFinishFlag=true;
	}
	//�����鱨�棬
	else if(sObjectType.equals("Customer"))
	{
		String sBeforDay="";
		String sToday="";
		sToday=StringFunction.getToday();
		sBeforDay=StringFunction.getRelativeDate(sToday,-10);//���10��ǰ������
		
		//��10�����������շ����Ĳ�����ɼ�鱨��
		sSql="select count(*) as ClassifyCount from CLASSIFY_RECORD where FinishDate > '"+sBeforDay+"' and FinishDate <= '"+sToday+"' and UserId='"+CurUser.UserID+"' and ObjectNo in(select serialno from business_contract where customerid='"+sObjectNo+"')";
		//out.println(sSql);

		rs = Sqlca.getResultSet(sSql);
		if(rs.next())
		{
			int count=rs.getInt("ClassifyCount");
			//out.println(count);
			if(count>0)
				bFinishFlag=true;
			else
				bFinishFlag=false;
		}
		rs.getStatement().close();
		
		//������ɼ���������ڲ��Թ������ȥ��
		bFinishFlag=true;
		//----------------end---------------

		if(bFinishFlag)
		{
			if(sObjectType.equals("BusinessContract"))
				sSql = "update INSPECT_INFO set finishdate='"+StringFunction.getToday()+"',UpdateDate='"+StringFunction.getToday()+"',InspectType = '010020'"+
			   			" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'";
			else if(sObjectType.equals("Customer") && sInspectType.equals("020010"))
				sSql = "update INSPECT_INFO set finishdate='"+StringFunction.getToday()+"',UpdateDate='"+StringFunction.getToday()+"',InspectType = '020020'"+
			   			" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'";
			else if(sObjectType.equals("Customer") && sInspectType.equals("040010"))
				sSql = "update INSPECT_INFO set finishdate='"+StringFunction.getToday()+"',UpdateDate='"+StringFunction.getToday()+"',InspectType = '040020'"+
			   			" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'";	
			Sqlca.executeSQL(sSql);
		}
		sFinishType="Inspect";
	}

%>
<script language=javascript>
	var FinishType="<%=sFinishType%>";
	if(<%=bFinishFlag%>)
		returnValue="finished";
	else
	{
		if(FinishType=="Purpose")
			returnValue="Purposeunfinish";
		if(FinishType=="Inspect")
			returnValue="Inspectunfinish";
	}
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
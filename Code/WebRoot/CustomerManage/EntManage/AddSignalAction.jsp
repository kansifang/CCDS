<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: �ͻ���Ϣ���
		Input Param:
			                
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>Ԥ���źŷ�����ʾ</title>
<%

	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sItems         = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Items"));
	
	//out.println(sCustomerID+"@"+sItems+"@"+sSerialNoAll);
	String sSignalType = "",sSerialNo="";
	String Today=StringFunction.getToday();
	int num=Integer.parseInt(StringFunction.getSeparate(sItems,"@",1));
	
	Sqlca.executeSQL("delete from RISK_SIGNAL where ObjectType='Customer' and ObjectNo='"+sCustomerID+"' ");
	for (int j=1;j<=num;j++)
	{
		sSignalType= StringFunction.getSeparate(sItems,"@",j+1) ;
		sSerialNo = DBFunction.getSerialNo("RISK_SIGNAL","SerialNo",Sqlca);
		Sqlca.executeSQL("insert into RISK_SIGNAL(ObjectType,ObjectNo,SerialNo,SignalType,InputOrgID,InputUserID,InputDate,UpdateDate) values('Customer','"+sCustomerID+"','"+sSerialNo+"','"+sSignalType+"','"+CurUser.OrgID+"','"+CurUser.UserID+"','"+Today+"','"+Today+"') ");		
	}

%>
<script language=javascript>
	alert("�޸�Ԥ���źŷ�����ʾ�ɹ���");
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
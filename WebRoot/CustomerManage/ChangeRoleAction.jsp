<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ndeng  2005.04.18
		Tester:
		Content: ת�ƿͻ�����Ȩ
		Input Param:
			  CustomerID���ͻ�����
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>
<%

	//�������

	//����������
	
	//���ҳ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sBelongUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BelongUserID"));
%>
<html>
<head>
<title>ת������Ȩ</title>

<%
      //��ԭ���û��Ե�ǰ�ͻ�������Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩȫ����Ϊ���ޡ�
      Sqlca.executeSQL("Update CUSTOMER_BELONG set BelongAttribute='2',BelongAttribute1='2',BelongAttribute2='2',BelongAttribute3='2',BelongAttribute4='2',ApplyStatus=null,ApplyRight=null where CustomerID='"+sCustomerID+"' and UserID='"+sBelongUserID+"'");
      //����ǰ�û��Ե�ǰ�ͻ�������Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩȫ����Ϊ���С�
      Sqlca.executeSQL("Update CUSTOMER_BELONG set BelongAttribute='1',BelongAttribute1='1',BelongAttribute2='1',BelongAttribute3='1',BelongAttribute4='1' where CustomerID='"+sCustomerID+"' and UserID='"+sUserID+"'");
      
      ASResultSet rs = null;
    	String sSql1 = "select * From CUSTOMER_BELONG where customerid = '"+sCustomerID+"' and userid = '"+sUserID+"'";
    	rs = Sqlca.getASResultSet(sSql1);
    	if(rs.next())
    	{
    		String sSerialNo1 = DBFunction.getSerialNo("CUSTOMER_BELONGLOG","SerialNo","CBL",Sqlca);
    		String sSql2 = "insert into CUSTOMER_BELONGLOG values "+
    		" ('"+sSerialNo1+"','"+rs.getString("CUSTOMERID")+"','"+rs.getString("ORGID")+"','"+rs.getString("USERID")+"', "+
    		" '"+rs.getString("BELONGATTRIBUTE")+"','"+rs.getString("BELONGATTRIBUTE1")+"','"+rs.getString("BELONGATTRIBUTE2")+"', "+
    		" '"+rs.getString("BELONGATTRIBUTE3")+"','"+rs.getString("BELONGATTRIBUTE4")+"','"+rs.getString("INPUTUSERID")+"', "+
    		" '"+rs.getString("INPUTORGID")+"','"+rs.getString("INPUTDATE")+"','"+rs.getString("UPDATEDATE")+"', "+
    		" '"+rs.getString("APPLYATTRIBUTE")+"','"+rs.getString("APPLYATTRIBUTE1")+"','"+rs.getString("APPLYATTRIBUTE2")+"', "+
    		" '"+rs.getString("APPLYATTRIBUTE3")+"','"+rs.getString("APPLYATTRIBUTE4")+"','"+rs.getString("REMARK")+"', "+
    		" '"+rs.getString("APPLYSTATUS")+"','"+rs.getString("APPLYREASON")+"','"+rs.getString("APPLYRIGHT")+"', "+
    		" '"+CurUser.UserID+"','"+CurUser.OrgID+"','"+StringFunction.getToday()+" "+StringFunction.getNow()+"')";
    		Sqlca.executeSQL(sSql2);
    	}
    	rs.close();

%>

<script language=javascript>
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>

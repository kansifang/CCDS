<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bqliu 2011-04-29
		Tester:
		Content: ����ĵ�0ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   
				FirstSection: 
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[0][0] = "false";
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
	String sCustomerName = "";
	String sCorpID = "";//��֯��������
	String sRegisterCapital = "";//ע���ʱ�
	String sRCCurrency = "";//ע���ʱ�����
	String sMostBusiness = "";//��Ӫ��Χ
	String sRegisterAdd = "";//ע���
	String sOfficeAdd = ""; //��Ӫ��
	
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName from Customer_Info where CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = " ";
	}
	rs2.getStatement().close();	
	
	rs2 = Sqlca.getResultSet("select EnterpriseName,CorpID,RegisterCapital,getItemName('Currency',RCCurrency) as CurrencyName,MostBusiness,"
										+"RegisterAdd,OfficeAdd "
										+"from ENT_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		//sCustomerName = rs2.getString("EnterpriseName");
		//if(sCustomerName == null) sCustomerName = " ";
		
		sCorpID = rs2.getString("CorpID");
		if(sCorpID == null) sCorpID = "";
		
		sRegisterCapital = rs2.getString("RegisterCapital");
		if(sRegisterCapital == null) sRegisterCapital = "";
		
		sRCCurrency = rs2.getString("CurrencyName");
		if(sRCCurrency == null) sRCCurrency = "";
		
		sMostBusiness = rs2.getString("MostBusiness");
		if(sMostBusiness == null) sMostBusiness = "";
		
		sRegisterAdd = rs2.getString("RegisterAdd");
		if(sRegisterAdd == null) sRegisterAdd = "";
		
		sOfficeAdd = rs2.getString("OfficeAdd");
		if(sOfficeAdd == null) sOfficeAdd = "";
	}
	
	rs2.getStatement().close();	
	
	String sIsDirector = " ";//�Ƿ����йɶ�
	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType = '50' and CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		 if(rs2.getInt(1)==0)sIsDirector = "��";
		 else sIsDirector = "��";
	}
	rs2.getStatement().close();	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 ><font style=' font-size: 25pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >���������Ϣ��</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 ><font style=' font-size: 15pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >(һ)����˻�����Ϣ</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >�ͻ���֯��������</td>");
    sTemp.append(" <td colspan=2 align=left class=td1 >"+sCorpID+"&nbsp;</td>");
  	sTemp.append(" <td align=center class=td1 >�ͻ�����</td>");
    sTemp.append(" <td colspan=2 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >ע���ʱ�(��Ԫ)</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sRegisterCapital+"&nbsp;</td>");
  	sTemp.append(" <td width=10% align=center class=td1 >����</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sRCCurrency+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >�Ƿ����йɶ�</td>");
    sTemp.append(" <td width=10% align=left class=td1 >"+sIsDirector+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" <td colspan=6 align=left valign=top class=td1 style='width:100%; height:50' >��Ӫ��Χ��<br/>&nbsp;&nbsp;"+sMostBusiness+"</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" <td colspan=3 align=left valign=top class=td1 style='width:100%; height:50' >ע��أ�<br/>&nbsp;&nbsp;"+sRegisterAdd+"</td>");
    sTemp.append(" <td colspan=3 align=left valign=top class=td1 style='width:100%; height:50' >��Ӫ�أ�<br/>&nbsp;&nbsp;"+sOfficeAdd+"</td>");
    sTemp.append(" </tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='"+CurComp.ClientID+"'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='"+CurPage.ClientID+"'>");
	sTemp.append("</form>");	



	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludeFDFooter.jsp"%>

<script language=javascript>
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//�ͻ���3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


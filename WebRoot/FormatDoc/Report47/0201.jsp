<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: ����ĵ�?ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   ���� 1:display;2:save;3:preview;4:export
				FirstSection: �ж��Ƿ�Ϊ����ĵ�һҳ
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount =6;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
	String sEnterpriseName = "";//�ͻ�����
	String sSuperCertTypeName = "" ;//���ù�ͬ������ 
	String sVillageName = "";//��������
	String sSuperCorpName = ""; //���ù�ͬ���ƿ���
	String sEmployeeNumber = "";//���ù�ͬ���ܻ���,
	String sSetupDate = "";//ũ������С�����ʱ��
	String sBailRatio = "";//����С�鱣֤�����
	String sBusinessType = Sqlca.getString("select BusinessType from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");	
	String sSql = "";
	ASResultSet rs = null;
	if("3050".equals(sBusinessType)){
		sSql = " select EnterpriseName,VillageName,EmployeeNumber,SetupDate,BailRatio from ENT_INFO where CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sEnterpriseName = rs.getString("EnterpriseName");
			sVillageName = rs.getString("VillageName");
			sEmployeeNumber = rs.getString("EmployeeNumber");
			sSetupDate = rs.getString("SetupDate");
			sBailRatio = rs.getString("BailRatio");
			if(sEnterpriseName == null) sEnterpriseName = "";
			if(sVillageName == null) sVillageName = "";
			if(sEmployeeNumber == null) sEmployeeNumber = "";
			if(sSetupDate == null) sSetupDate = "";
			if(sBailRatio == null) sBailRatio = "";
		}	
		rs.getStatement().close();
	}
	else if("3060".equals(sBusinessType)){
		sSql = " select EnterpriseName,getItemName('CreditGroupType',SuperCertType) as SuperCertTypeName ,"+
			   " VillageName,SuperCorpName,EmployeeNumber "+
			   " from ENT_INFO where CustomerID='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sEnterpriseName = rs.getString("EnterpriseName");
			sSuperCertTypeName = rs.getString("SuperCertTypeName");
			sVillageName = rs.getString("VillageName");
			sSuperCorpName = rs.getString("SuperCorpName");
			sEmployeeNumber = rs.getString("EmployeeNumber");
			if(sEnterpriseName == null) sEnterpriseName = "";
			if(sSuperCertTypeName == null) sSuperCertTypeName = "";
			if(sVillageName == null) sVillageName = "";
			if(sSuperCorpName == null) sSuperCorpName = "";
			if(sEmployeeNumber == null) sEmployeeNumber = "";
		}	
		rs.getStatement().close();		   
	}							  
	
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2 �����˻�����Ϣ</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1���ſ�</font></td> ");	
	sTemp.append("   </tr>");
	if("3050".equals(sBusinessType)){
		sTemp.append("   <tr>");
		sTemp.append(" <td width=25% align=left class=td1 > ���� </td>");
	    sTemp.append(" <td width=25% align=left class=td1 >"+sEnterpriseName+"&nbsp;</td>");
	  	sTemp.append(" <td width=25% align=left class=td1 > ũ�����ڵ� </td>");
	    sTemp.append(" <td width=25% align=left class=td1 >"+sVillageName+"&nbsp;</td>");
	    sTemp.append(" </tr>");
		sTemp.append("   <tr>");
		sTemp.append("     <td colspan='1' align=left class=td1 > ����С���Ա����  </td>");
	    sTemp.append("     <td colspan='1' align=left class=td1 >"+sEmployeeNumber+"&nbsp;</td>");
		sTemp.append("     <td colspan='1' align=left class=td1 > ����С��Э��ǩ��ʱ�� </td>");
		sTemp.append("     <td colspan='1' align=left class=td1 >"+sSetupDate+"&nbsp;</td>");
		sTemp.append("  </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("     <td colspan='1' align=left class=td1 > ����С�鱣֤����� </td>");
	    sTemp.append("     <td colspan='3' align=left class=td1 >"+sBailRatio+"&nbsp;</td>");
	    sTemp.append("  </tr>");
		
	}else if("3060".equals(sBusinessType)){
		sTemp.append("   <tr>");
		sTemp.append(" <td width=25% align=left class=td1 > ���� </td>");
	    sTemp.append(" <td width=25% align=left class=td1 >"+sEnterpriseName+"&nbsp;</td>");
	  	sTemp.append(" <td width=25% align=left class=td1 > ���� </td>");
	    sTemp.append(" <td width=25% align=left class=td1 >"+sSuperCertTypeName+"&nbsp;</td>");
	    sTemp.append(" </tr>");
		sTemp.append("   <tr>");
		sTemp.append("     <td colspan='1' align=left class=td1 > �������� </td>");
	    sTemp.append("     <td colspan='1' align=left class=td1 >"+sVillageName+"&nbsp;</td>");
		sTemp.append("     <td colspan='1' align=left class=td1 > �ƿ������� </td>");
		sTemp.append("     <td colspan='1' align=left class=td1 >"+sSuperCorpName+"&nbsp;</td>");
		 sTemp.append("  </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("     <td colspan='1' align=left class=td1 > �ܻ��� </td>");
	    sTemp.append("     <td colspan='3' align=left class=td1 >"+sEmployeeNumber+"&nbsp;</td>");
     	sTemp.append("  </tr>");
		
	}	

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

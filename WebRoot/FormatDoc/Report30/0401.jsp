<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu  2009.08.18
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
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	//��õ��鱨������
	String sAptitudeLevelInfo = "";   //�������ʼ���
	String sUptoDate = ""; //���ʱ��
	String sAnnualCheck = ""; //�Ƿ�ͨ�����
	String sCheckOrgName = "";//����������������
	
	String sSql = " select LevelInfo,getItemName('AptitudeLevelInfo',LevelInfo) as AptitudeLevelInfo, "+
				  " UptoDate,getOrgName(InputOrgID) as CheckOrgName from ENT_REALTYAUTH where CustomerID = '"+sCustomerID+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sAptitudeLevelInfo = rs.getString(2);
		if(sAptitudeLevelInfo == null) sAptitudeLevelInfo = "";
		
		sUptoDate = rs.getString(3);
		if(sUptoDate == null) sUptoDate = null;
		
		sCheckOrgName = rs.getString(4);
		if(sCheckOrgName == null) sCheckOrgName = "";
	}
	rs.getStatement().close();			  
%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0401.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4.1������˾�Ӫ�����������</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=20% align=left class=td1 > ��������  </td>");
  	sTemp.append("   <td width=20% align=left class=td1 > "+sAptitudeLevelInfo+"&nbsp  </td>");
  	sTemp.append("   <td width=15% align=left class=td1 > ���ʱ�� </td>");
    sTemp.append("   <td width=15% align=left class=td1 > "+sUptoDate+"&nbsp  </td>");
    sTemp.append("   <td width=15% align=left class=td1 > �Ƿ�ͨ����� </td>");
	sTemp.append("   <td width=15% align=left class=td1 > "+""+"&nbsp  </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > ����������������  </td>");
  	sTemp.append("   <td colspan='5' align=left class=td1 > "+sCheckOrgName+"&nbsp  </td>");
    sTemp.append("   </tr>");
    
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


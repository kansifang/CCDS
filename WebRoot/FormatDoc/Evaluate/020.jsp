<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: ����ĵ�0ҳ
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

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
		String sCustomerName = "";//����
		String sCertID = "";//���֤����
		String sSex = "";//�Ա�
		String sFamilyAdd = "";//��ס��ַ
		String sMobileTelephone = "";//��ϵ�绰
		String sWorkName = "";//������λ/��ҵ
		String sEngageTerm = "";//����
		String sPerFamilySum = "";//��ͥ�˾�������
		String sFamilyMainSum = "";//��ͥ��Ҫ�ʲ�
		String sFamilyPureSum = "";//��ͥ���ʲ�
		String sFamilyMember = "";//��ͥ��Ҫ��Ա
		String sFamilyTotalSum = "";//��ͥ��������
		String sOpinion = "";//�Ŵ���Ա���
		String sOpinion1 = "";//���������
		String sOpinion2 = "";//����С�����	
		String sOpinion3 = "";//֧�����
		String sInputDate = "";//����
	//�������
	String sSql = " Select CustomerName,getItemName('Sex','Sex') as Sex,CertID,FamilyAdd,MobileTelephone,"+
				  " WorkName,EngageTerm,PerFamilySum,FamilyMainSum,FamilyPureSum,FamilyMember,"+
				  " FamilyTotalSum,Opinion,Opinion1,Opinion2,Opinion3,InputDate"+
				  " from ASSESSFORM_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCustomerName = rs.getString("CustomerName");//��Ӫ������
		if(sCustomerName == null) sCustomerName = "";
		sCertID = rs.getString("CertID");//���֤����
		if(sCertID == null) sCertID = "";
		sSex = rs.getString("Sex");//�Ա�
		if(sSex == null) sSex = "";
		sFamilyAdd = rs.getString("FamilyAdd");//��ͥ��ַ
		if(sFamilyAdd == null) sFamilyAdd = "";
		sMobileTelephone = rs.getString("MobileTelephone");//��ϵ�绰
		if(sMobileTelephone == null) sMobileTelephone = "";
		sWorkName = rs.getString("WorkName");//������λ/��ҵ
		if(sWorkName == null) sWorkName = "";
		sEngageTerm = rs.getString("EngageTerm");//����
		if(sEngageTerm == null) sEngageTerm = "";
		sPerFamilySum = DataConvert.toMoney(rs.getDouble("PerFamilySum"));//��ͥ�˾�������
		if(sPerFamilySum == null) sPerFamilySum = "";
		sFamilyMainSum = DataConvert.toMoney(rs.getDouble("FamilyMainSum"));//��ͥ��Ҫ�ʲ�
		if(sFamilyMainSum == null) sFamilyMainSum = "";
		sFamilyPureSum = DataConvert.toMoney(rs.getDouble("FamilyPureSum"));//��ͥ���ʲ�
		if(sFamilyPureSum == null) sFamilyPureSum = "";
		sFamilyMember = rs.getString("FamilyMember");//��ͥ��Ҫ��Ա
		if(sFamilyMember == null) sFamilyMember = "";
		sFamilyTotalSum = DataConvert.toMoney(rs.getDouble("FamilyTotalSum"));//��ͥ��������
		if(sFamilyTotalSum == null) sFamilyTotalSum = "";
		sOpinion = rs.getString("Opinion");//�Ŵ���Ա���
		if(sOpinion == null) sOpinion = "";
		sOpinion1 = rs.getString("Opinion1");//���������
		if(sOpinion1 == null) sOpinion1 = "";
		sOpinion2 = rs.getString("Opinion2");//����С�����	
		if(sOpinion2 == null) sOpinion2 = "";
		sOpinion3 = rs.getString("Opinion3");//֧�����
		if(sOpinion3 == null) sOpinion3 = "";
		sInputDate = rs.getString("InputDate");//����
		if(sInputDate == null) sInputDate = "";
	}
	rs.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='002.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='7' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>���õȼ�������<br>&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1' width=10% class=td1 > ����</td>");
	sTemp.append("   <td align=left colspan='1' width=15% class=td1>"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' width=10% class=td1>�Ա�</td>");
	sTemp.append("   <td align=left colspan='1' width=15% class=td1>"+sSex+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' width=15% class=td1>���֤����</td>");
	sTemp.append("   <td align=left colspan='1' width=20% class=td1>"+sCertID+"&nbsp;</td>");	
	sTemp.append("   <td align=left colspan='1' rowspan='5' width=15% class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1' class=td1 > ��ס��ַ</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sFamilyAdd+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >��ϵ�绰</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sMobileTelephone+"&nbsp;</td>");
	sTemp.append("   </tr>");
		
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1' class=td1 > ������λ/��ҵ</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sWorkName+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>����</td>");
	sTemp.append("   <td align=left colspan='1' class=td1>"+sEngageTerm+"&nbsp;</td>");
	sTemp.append("   <td align=left rowspan='1' class=td1>��ͥ�˾�������(��Ԫ)</td>");
	sTemp.append("   <td align=left rowspan='1' class=td1>"+sPerFamilySum+"&nbsp;</td>");	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1' class=td1 > ��ͥ��Ҫ�ʲ�</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sFamilyMainSum+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >��ͥ���ʲ�(��Ԫ)</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sFamilyPureSum+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='1' class=td1 > ��ͥ��Ҫ��Ա</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sFamilyMember+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >��ͥ�������루��Ԫ��</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sFamilyTotalSum+"&nbsp;</td>");
	sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='7'> �ͻ����������ۣ�<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion+"<br/>"+""+"&nbsp;<br/><br/><br/><br/><br/>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ�£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='7'> �壨�ӣ�ί�������<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion1+"<br/>"+""+"&nbsp;<br/><br/><br/><br/><br/>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ�£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</td>");
    sTemp.append("   </tr>");
    
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='4'> ����С�������<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion2+"<br/>"+""+"&nbsp;<br/><br/><br/><br/>");
  	sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ�£�<br/><br/>"+
  				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��");
	sTemp.append("   <br/><br/><br/></td>");
  	sTemp.append("   <td align=left class=td1 colspan='3'> ֧�У�Ӫҵ���������<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion3+"<br/>"+""+"&nbsp;<br/><br/><br/><br/>");
  	sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ�£�<br/><br/>"+
  				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��");
	sTemp.append("   <br/><br/><br/></td>");
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
	
	if(sEndSection.equals("1"))
		sTemp.append("<br clear=all style='mso-special-character:line-break;'>");
	
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


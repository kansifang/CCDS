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
		String sRelaCustomerName = "";//�̻�����
		String sManageAdd = "";//��Ӫ��ַ
		String sCustomerName = "";//��Ӫ������
		String sCertID = "";//���֤����
		String sSex = "";//�Ա�
		String sAge = "";//����
		String sFamilyAdd = "";//��ͥ��ַ
		String sMobileTelephone = "";//��ϵ�绰
		String sManageArea = "";//��Ӫ��Χ
		String sPermitID = "";//ִ�պ���
		String sAssessItem2Name = "";//��Ӫ̯λ���
		Double dAssessItem2 = 0.0;//��Ӫ̯λ���
		String sAssessItem1Name = "";//��Ӫ̯λ����Ȩ
		Double dAssessItem1 = 0.0;//��Ӫ̯λ����Ȩ����
		String sAssessItem3Name = "";//�̻����ʲ�
		Double dAssessItem3 = 0.0;//�̻����ʲ�����
		String sAssessItem4Name = "";//�꾭Ӫ����
		Double dAssessItem4 = 0.0;//�꾭Ӫ�������
		String sAssessItem5Name = "";//�꾻����
		Double dAssessItem5 = 0.0;//�꾻�������
		String sAssessItem6Name = "";//�̻�������
		Double dAssessItem6 = 0.0;//�̻�����������
		String sAssessItem7Name = "";//���õĽ���
		Double dAssessItem7 = 0.0;//���õĽ��ɷ���
		String sAssessItem8Name = "";//Ӧ���˿����
		Double dAssessItem8 = 0.0;//Ӧ���˿��������
		String sAssessItem9Name = "";//�������д�����
		Double dAssessItem9 = 0.0;//�������д���������
		String sOtherCondition = "";//����
		String sAssessLevel = "";//�������õȼ�
		Double dAssessScore = 0.0;//�÷ֺϼ�
		String sOpinion = "";//�Ŵ���Ա���
		String sOpinion1 = "";//���������
		String sOpinion2 = "";//����С�����	
		String sOpinion3 = "";//֧�����
		String sInputDate = "";//����
	//�������
	String sSql = " select RelaCustomerName,ManageAdd,CustomerName,CertID,getItemName('Sex',Sex) as Sex,Age,FamilyAdd,MobileTelephone,ManageArea,PermitID,"+
				  " getItemName('ManageStallArea',AssessItem2) as AssessItem2Name,AssessItem2,"+
				  " getItemName('ManageStallDroit',AssessItem1) as AssessItem1Name,AssessItem1,"+
				  " getItemName('TotalAsset',AssessItem3) as AssessItem3Name,AssessItem3,"+
				  " getItemName('YearEarning',AssessItem4) as AssessItem4Name,AssessItem4,"+
				  " getItemName('YearRetainProfits',AssessItem5) as AssessItem5Name,AssessItem5,"+
     			  " getItemName('BizCredit',AssessItem6) as AssessItem6Name,AssessItem6,"+
				  " getItemName('FeePay',AssessItem7) as AssessItem7Name,AssessItem7,"+
				  " getItemName('FundCircs',AssessItem8) as AssessItem8Name,AssessItem8,"+
                  " getItemName('DepositTradeMete',AssessItem9) as AssessItem9Name,AssessItem9,"+
				  " OtherCondition,getItemName('AssessLevel',AssessLevel) as AssessLevel,AssessScore,"+
				  " Opinion,Opinion1,Opinion2,Opinion3,InputDate "+
				  " from ASSESSFORM_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sRelaCustomerName = rs.getString("RelaCustomerName");//�̻�����
		if(sRelaCustomerName == null) sRelaCustomerName = "";
		sManageAdd = rs.getString("ManageAdd");//��Ӫ��ַ
		if(sManageAdd == null) sManageAdd = "";
		sCustomerName = rs.getString("CustomerName");//��Ӫ������
		if(sCustomerName == null) sCustomerName = "";
		sCertID = rs.getString("CertID");//���֤����
		if(sCertID == null) sCertID = "";
		sSex = rs.getString("Sex");//�Ա�
		if(sSex == null) sSex = "";
		sAge = rs.getString("Age");//����
		if(sAge == null) sAge = "";
		sFamilyAdd = rs.getString("FamilyAdd");//��ͥ��ַ
		if(sFamilyAdd == null) sFamilyAdd = "";
		sMobileTelephone = rs.getString("MobileTelephone");//��ϵ�绰
		if(sMobileTelephone == null) sMobileTelephone = "";
		sManageArea = rs.getString("ManageArea");//��Ӫ��Χ
		if(sManageArea == null) sManageArea = "";
		sPermitID = rs.getString("PermitID");//ִ�պ���
		if(sPermitID == null) sPermitID = "";
		sAssessItem2Name = rs.getString("AssessItem2Name");//��Ӫ̯λ���
		if(sAssessItem2Name == null) sAssessItem2Name = "";
		dAssessItem2 = rs.getDouble("AssessItem2");//��Ӫ̯λ���
		if(dAssessItem2 == null) dAssessItem2 = 0.0;
		sAssessItem1Name = rs.getString("AssessItem1Name");//��Ӫ̯λ����Ȩ
		if(sAssessItem1Name == null) sAssessItem1Name = "";
		dAssessItem1 = rs.getDouble("AssessItem1");//��Ӫ̯λ����Ȩ����
		if(dAssessItem1 == null) dAssessItem1 = 0.0;
		sAssessItem3Name = rs.getString("AssessItem3Name");//�̻����ʲ�
		if(sAssessItem3Name == null) sAssessItem3Name = "";
		dAssessItem3 = rs.getDouble("AssessItem3");//�̻����ʲ�����
		if(dAssessItem3 == null) dAssessItem3 = 0.0;
		sAssessItem4Name = rs.getString("AssessItem4Name");//�꾭Ӫ����
		if(sAssessItem4Name == null) sAssessItem4Name = "";
		dAssessItem4 = rs.getDouble("AssessItem4");//�꾭Ӫ�������
		if(dAssessItem4 == null) dAssessItem4 = 0.0;
		sAssessItem5Name = rs.getString("AssessItem5Name");//�꾻����
		if(sAssessItem5Name == null) sAssessItem5Name = "";
		dAssessItem5 = rs.getDouble("AssessItem5");//�꾻�������
		if(dAssessItem5 == null) dAssessItem5 = 0.0;
		sAssessItem6Name = rs.getString("AssessItem6Name");//�̻�������
		if(sAssessItem6Name == null) sAssessItem6Name = "";
		dAssessItem6 = rs.getDouble("AssessItem6");//�̻�����������
		if(dAssessItem6 == null) dAssessItem6 = 0.0;
		sAssessItem7Name = rs.getString("AssessItem7Name");//���õĽ���
		if(sAssessItem7Name == null) sAssessItem7Name = "";
		dAssessItem7 = rs.getDouble("AssessItem7");//���õĽ��ɷ���
		if(dAssessItem7 == null) dAssessItem7 = 0.0;
		sAssessItem8Name = rs.getString("AssessItem8Name");//Ӧ���˿����
		if(sAssessItem8Name == null) sAssessItem8Name = "";
		dAssessItem8 = rs.getDouble("AssessItem8");//Ӧ���˿��������
		if(dAssessItem8 == null) dAssessItem8 = 0.0;
		sAssessItem9Name = rs.getString("AssessItem9Name");//�������д�����
		if(sAssessItem9Name == null) sAssessItem9Name = "";
		dAssessItem9 = rs.getDouble("AssessItem9");//�������д���������
		if(dAssessItem9 == null) dAssessItem9 = 0.0;
		sOtherCondition = rs.getString("OtherCondition");//����
		if(sOtherCondition == null) sOtherCondition = "";
		sAssessLevel = rs.getString("AssessLevel");//�������õȼ�
		if(sAssessLevel == null) sAssessLevel = "";
		dAssessScore = rs.getDouble("AssessScore");//�÷ֺϼ�
		if(dAssessScore == null) dAssessScore = 0.0;
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
	sTemp.append("	<form method='post' action='001.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>�̻����õȼ�������<br>&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='2' class=td1 > �̻�����</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sRelaCustomerName+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >��Ӫ��ַ</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sManageAdd+"&nbsp;</td>");
	sTemp.append("   <td align=left rowspan='5' class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='2' class=td1 > ��Ӫ������</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >���֤����</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sCertID+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='2' class=td1 > �Ա�</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sSex+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >����</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sAge+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='2' class=td1 > ��ͥ��ַ</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sFamilyAdd+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >��ϵ�绰</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sMobileTelephone+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan='2' class=td1 > ��Ӫ��Χ</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sManageArea+"&nbsp;</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >ִ�պ���</td>");
	sTemp.append("   <td align=left colspan='1' class=td1 >"+sPermitID+"&nbsp;</td>");
	sTemp.append("   </tr>");	



	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > ���</td>");
	sTemp.append("   <td align=left class=td1 >��������</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >������׼</td>");
	sTemp.append("   <td align=left class=td1 >ʵ�����</td>");
	sTemp.append("   <td align=center class=td1 >�÷�</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 1</td>");
	sTemp.append("   <td align=left class=td1 >��Ӫ̯λ���</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >��Ӫ�߾߱�����Ȩ5��;����0��</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem2Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem2+"&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 2</td>");
	sTemp.append("   <td align=left class=td1 >��Ӫ̯λ����Ȩ</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >���100�O����15��;���50�O����10��;���10�O����5��</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem1Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem1+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 3</td>");
	sTemp.append("   <td align=left class=td1 >�̻����ʲ�</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >���ʲ�100��Ԫ����20��;50��Ԫ����15��;20��Ԫ����10��</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem3Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem3+"&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 4</td>");
	sTemp.append("   <td align=left class=td1 >�꾭Ӫ����</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >������100��Ԫ����15��;50��Ԫ����10��;15��Ԫ����5��</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem4Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem4+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 5</td>");
	sTemp.append("   <td align=left class=td1 >�꾻����</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >�꾻����30������10��;15������5��;5������1��</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem5Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem5+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 6</td>");
	sTemp.append("   <td align=left class=td1 >�̻�������</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >����Ӫ��ðα�Ӳ�Ʒ�������а��С��غ�ͬ������5��</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem6Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem6+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 7</td>");
	sTemp.append("   <td align=left class=td1 >���õĽ���</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >���ڽ����г�����ѡ����޷ѡ�˰��ȸ��ַ���10��</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem7Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem7+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 8</td>");
	sTemp.append("   <td align=left class=td1 >Ӧ���˿����</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >�޶�����ǷӦ���˿�5��</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem8Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem8+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 9</td>");
	sTemp.append("   <td align=left class=td1 >�������д�����</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >�վ����15��Ԫ����15��;10��Ԫ����12��;5��Ԫ����10��</td>");
	sTemp.append("   <td align=left class=td1 >"+sAssessItem9Name+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+dAssessItem9+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 10</td>");
	sTemp.append("   <td align=left class=td1 >������</td>");
	sTemp.append("   <td align=left colspan='2' class=td1 >"+sOtherCondition+"&nbsp;</td>");
	sTemp.append("   <td align=left class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
	sTemp.append("   <td align=left width=5% class=td1 >"+""+"&nbsp;</td>");	
	sTemp.append("   <td align=left width=15% class=td1 > �������õȼ�</td>");
	sTemp.append("   <td align=left width=25% class=td1  >"+sAssessLevel+"&nbsp;</td>");
	sTemp.append("   <td align=left width=15% class=td1 bordercolor=#FFFFFF>"+""+"&nbsp;</td>");	
	sTemp.append("   <td align=left width=25% class=td1  >�÷ֺϼ�</td>");
	sTemp.append("   <td align=center width=10% class=td1 >"+dAssessScore+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='6'> �Ŵ���Ա�����<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion+"<br/>"+""+"&nbsp;<br/><br/><br/><br/><br/>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ�£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='6'> �����������<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion1+"<br/>"+""+"&nbsp;<br/><br/><br/><br/><br/>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ�£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</td>");
    sTemp.append("   </tr>");
    
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='3'> ����С�������<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion2+"<br/>"+""+"&nbsp;<br/><br/><br/><br/>");
  	sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ�£�<br/><br/>"+
  				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��");
	sTemp.append("   <br/><br/><br/></td>");
  	sTemp.append("   <td align=left class=td1 colspan='3'> ֧�������<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sOpinion3+"<br/>"+""+"&nbsp;<br/><br/><br/><br/>");
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


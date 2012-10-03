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
	//��õ��鱨������
	String sSql = "select ContractSerialNo,DuebillSerialNo,BP.CustomerID,BP.CustomerName,getBusinessName(BusinessType),"+
                  "getitemname('Currency',BusinessCurrency) as BusinessCurrency,getItemName('CreditLineFlag',CreditLineFlag),"+
				  "ContractSum,BusinessSum,Purpose,LoanTerm,PutOutDate,Maturity,BusinessRate,getItemName('ICCyc',ICCyc),FixCyc,"+
				  "getItemName('CorpusPayMethod1',CorpusPayMethod),getItemName('PZType',PZType),AccountNo,RiskRate,ProjectNo,"+
				  "FZAccountNo,FZANBalance,FZGuaBalance,CDate,getOrgName(OperateOrgID),OperateUserID,getItemName('CCode',CCode),"+
				  "getItemName('CCyc',CCyc),CreditAggreement,LoanType,GatheringName,RateFloat,"+
				  "CI.MFCustomerID,getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID "+
				  "from BUSINESS_PUTOUT BP,CUSTOMER_INFO CI where SerialNo = '"+sObjectNo+"' and BP.CustomerID = CI.CustomerID";
	String sContractSerialNo = "";
	String sDuebillSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessCurrency = "";
	String sCreditLineFlag = "";
	String sContractSum = "";
	String sBusinessSum = "";
	String sPurpose = "";
	String sLoanTerm = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sBusinessRate = "";
	String sICCyc = "";
	String sFixCyc = "";
	String sCorpusPayMethod = "";
	String sPZType = "";
	String sAccountNo = "";
	String sRiskRate = "";
	String sProjectNo = "";
	String sFZAccountNo = "";
	String sFZANBalance = "";
	String sFZGuaBalance = "";
	String sCDate = "";
	String sOperateOrgID = "";
	String sOperateUserID = "";
	String sCCode = "";
	String sCCyc = "";
	String sCreditAggreement = "";
	String sGatheringName = "";
	String sRateFloat = "";
	String sLoanType = "";
	String sMFCustomerID = "";
	String sCertTypeName = "";
	String sCertID = "";
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='2201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if(sContractSerialNo == null) sContractSerialNo = "";
		
		sDuebillSerialNo = rs2.getString(2);
		if(sDuebillSerialNo == null) sDuebillSerialNo = "";
		
		sCustomerID = rs2.getString(3);
		if(sCustomerID == null) sCustomerID = "";
		
		sCustomerName = rs2.getString(4);
		if(sCustomerName == null) sCustomerName = "";
		
		sBusinessTypeName = rs2.getString(5);
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		
		sBusinessCurrency = rs2.getString(6);
		if(sBusinessCurrency == null) sBusinessCurrency = "";
		
		sCreditLineFlag = rs2.getString(7);
		if(sCreditLineFlag == null) sCreditLineFlag = "";
		
		sContractSum = DataConvert.toMoney(rs2.getDouble(8));
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(9));
		
		sPurpose = rs2.getString(10);
		if(sPurpose == null) sPurpose = "";
		
		sLoanTerm = rs2.getString(11);
		if(sLoanTerm == null) sLoanTerm = "";
		
		sPutOutDate = rs2.getString(12);
		if(sPutOutDate == null) sPutOutDate = "";
		
		sMaturity = rs2.getString(13);
		if(sMaturity == null) sMaturity = "";
		
		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(6);
        nf.setMaximumFractionDigits(6);
		sBusinessRate = nf.format(rs2.getDouble(14));
		
		sICCyc = rs2.getString(15);
		if(sICCyc == null) sICCyc = "";
		
		sFixCyc = rs2.getString(16);
		if (sFixCyc == null){ 
			sFixCyc = "";
		}else{
			sFixCyc = String.valueOf(Integer.parseInt(sFixCyc));
		}
		
		sRateFloat = nf.format(rs2.getDouble(33));
		
		sCorpusPayMethod = rs2.getString(17);
		if(sCorpusPayMethod == null) sCorpusPayMethod = "";
		
		sPZType = rs2.getString(18);
		if(sPZType == null) sPZType = "";
		
		sAccountNo = rs2.getString(19);
		if(sAccountNo == null) sAccountNo = "";
		
        nf.setMinimumFractionDigits(0);
        nf.setMaximumFractionDigits(7);
		sRiskRate = nf.format(rs2.getDouble(20));
		
		sProjectNo = rs2.getString(21);
		if(sProjectNo == null) sProjectNo = "";
		
		sFZAccountNo = rs2.getString(22);
		if(sFZAccountNo == null) sFZAccountNo = "";
		
		sFZANBalance = rs2.getString(23);
		if (sFZANBalance == null){ 
			sFZANBalance = "";
		}else{
			sFZANBalance = DataConvert.toMoney(rs2.getDouble(23));
		}
		
		sFZGuaBalance = DataConvert.toMoney(rs2.getDouble(24));
		
		sCDate = rs2.getString(25);
		if(sCDate == null) sCDate = "";
		
		sOperateOrgID = rs2.getString(26);
		if(sOperateOrgID == null) sOperateOrgID = "";
		
		sOperateUserID = rs2.getString(27);	
		if(sOperateUserID == null) sOperateUserID = "";
		
		sCCode = rs2.getString(28);	
		if(sCCode == null) sCCode = "";
		
		sCCyc = rs2.getString(29);
		if(sCCyc == null) sCCyc = "";
		
		sCreditAggreement = rs2.getString(30);
		if(sCreditAggreement == null) sCreditAggreement = "";
		
		sLoanType = rs2.getString(31);
		if(sLoanType == null) sLoanType = "";
		
		sGatheringName = rs2.getString(32);
		if(sGatheringName == null) sGatheringName = "";
		
		sMFCustomerID = rs2.getString("MFCustomerID");
		if(sMFCustomerID == null) sMFCustomerID = "";
		
		sCertTypeName = rs2.getString("CertTypeName");
		if(sCertTypeName == null) sCertTypeName = "";
		
		sCertID = rs2.getString("CertID");
		if(sCertID == null) sCertID="";
		
		
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=center colspan=28 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>�ſ�֪ͨ��<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 > <u>&nbsp;&nbsp;"+sOperateOrgID+"&nbsp;&nbsp;</u>֧�У�������Ʋ��ţ� </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u>�������ˣ�������ҵ��:<u>&nbsp;&nbsp;"+sBusinessTypeName+"&nbsp;&nbsp;</u><br>�Ѿ�������ҵ���������򱨾���Ȩ����������ͬ�⣬��ͨ���ſ�������ˣ����㲿���ձ�֪ͨ��Ҫ�󣬰������������	   </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");		
		sTemp.append("   <td width=20% align=left class=td1 >��ͬ��ˮ��</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >������ˮ��</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >���Ŀͻ���</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sMFCustomerID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�ͻ�����</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 nowrap>"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >֤������</td>");
		sTemp.append("   <td align=left class=td1 nowrap>"+sCertTypeName+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >֤������</td>");
		sTemp.append("   <td align=left class=td1 >"+sCertID+"&nbsp;</td>");
		sTemp.append("   </tr>");			
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >����</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sBusinessCurrency+"&nbsp;</td>");
		sTemp.append("   </tr>");	
		/*
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >������Ŀ���</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sProjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��������</td>");
		sTemp.append("   <td align=left class=td1 >"+sLoanType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >������������</td>");
		sTemp.append("   <td align=left class=td1 >"+sGatheringName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��չ���˺�</td>");
		sTemp.append("   <td align=left class=td1 >"+sFZAccountNo+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���ʽ</td>");
		sTemp.append("   <td align=left class=td1 >"+sCorpusPayMethod+"&nbsp;</td>");
		sTemp.append("   </tr>");
		*/
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >���Ž�Ԫ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		/*
		sTemp.append("   <td align=left class=td1 >��չ�̱�֤���(Ԫ)</td>");
		sTemp.append("   <td align=left class=td1 >"+sFZGuaBalance+"&nbsp;</td>");
		sTemp.append("   </tr>");
		*/
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��Ϣ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >������</td>");
		sTemp.append("   <td align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >����</td>");
		sTemp.append("   <td align=left class=td1 >"+sLoanTerm+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >�ͻ��˺�</td>");
		sTemp.append("   <td align=left class=td1 >"+sAccountNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >ִ��������(%)</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessRate+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��ͬ��Ԫ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sContractSum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >������;</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sPurpose+"&nbsp;</td>");
		sTemp.append("   </tr>");
		/*
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�������ϵ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sRiskRate+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��չ�����˾���(Ԫ)</td>");
		sTemp.append("   <td align=left class=td1 >"+sFZANBalance+"&nbsp;</td>");
		sTemp.append("   </tr>");
		*/
		/*
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�̶�����</td>");
		sTemp.append("   <td align=left class=td1 >"+sFixCyc+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >�ۿ�����</td>");
		sTemp.append("   <td align=left class=td1 >"+sICCyc+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >������/��</td>");
		sTemp.append("   <td align=left class=td1 >"+sRateFloat+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��Ϣ����</td>");
		sTemp.append("   <td align=left class=td1 >"+sICCyc+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�ۿ�����</td>");
		sTemp.append("   <td align=left class=td1 >"+sCDate+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��ȴ����־</td>");
		sTemp.append("   <td align=left class=td1 >"+sCreditLineFlag+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >���Ŷ�ȱ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sCreditAggreement+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >ƾ֤����</td>");
		sTemp.append("   <td align=left class=td1 >"+sPZType+"&nbsp;</td>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >ժҪ����</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sCCode+"&nbsp;</td>");
		sTemp.append("   </tr>");
		*/
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 > �ſ���������ǩ�֣� </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=4 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>�ſ�ר���£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> ���ڣ�"+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >����֪ͨ�鹲���������ͻ�������ƺ��ĵ�����Ա��һ�ݣ�</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");	
	}
	
	rs2.getStatement().close();	
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

<%@include file="/FormatDoc/IncludePOFooter.jsp"%>

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


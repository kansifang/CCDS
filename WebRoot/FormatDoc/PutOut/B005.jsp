<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:    xhyong 2010/06/30
		Tester:
		Content: ���гжһ�Ʊ����ĵ�0ҳ
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
	
	String sSql = " select ContractSerialNo,BP.CustomerID,BP.CustomerName,BailAccount,"+
				  " getItemName('VouchType',VouchType) as VouchType,getItemName('KeapOrder',CorpusPayMethod),"+
				  " SecondPayAccount,BusinessSum,PutOutDate,Maturity,getBusinessName(BusinessType) as BusinessTypeName,getOrgName(OperateOrgID),SerialNo,DuebillSerialNo, "+
				  " CI.MFCustomerID,getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID,getitemname('Currency',BusinessCurrency) as BusinessCurrency, "+
				  " BP.ContractSum,Purpose "+
				  " from BUSINESS_PUTOUT BP,CUSTOMER_INFO CI where SerialNo = '"+sObjectNo+"' and BP.CustomerID = CI.CustomerID";
	String sTempSql = "select FlowNo from FLOW_OBJECT where ObjectNo='"+sObjectNo+"' and ObjectType='PutOutApply'";
	String sFlowNo = "";
	String sContractSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBailAccount = "";
	String sVouchType = "";
	String sCorpusPayMethod = "";
	String sSecondPayAccount = "";
	String sBusinessSum = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sBusinessTypeName = "";
	String sOperateOrgID = "";
	String sSerialNo1 = "";
	String sInterSerialNo = "";
	String sGatheringName = "";
	String sAccountNo = "";
	String sAboutBankName = "";
	String sBillSum = "";
	String sUserName = "";
	String sOrgName = "";
	String sDuebillSerialNo = "";
	String sMFCustomerID = "";
	String sCertTypeName = "";
	String sCertID = "";
	String sBusinessCurrency = "";
	String sContractSum = "";
	String sPurpose = "";
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='8315.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if( sContractSerialNo==null) sContractSerialNo= "";
		
		sCustomerID = rs2.getString(2);
		if( sCustomerID==null) sCustomerID= "";
		
		sCustomerName = rs2.getString(3);
		if( sCustomerName==null) sCustomerName= "";
		
		sBailAccount = rs2.getString(4);
		if(sBailAccount ==null) sBailAccount= "";
		
		sVouchType = rs2.getString(5);
		if(sVouchType ==null) sVouchType= "";
		
		sCorpusPayMethod = rs2.getString(6);
		if(sCorpusPayMethod ==null) sCorpusPayMethod= "";
		
		sSecondPayAccount = rs2.getString(7);
		if(sSecondPayAccount ==null) sSecondPayAccount= "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(8));
		
		sPutOutDate = rs2.getString(9);
		if(sPutOutDate ==null) sPutOutDate= "";
		
		sMaturity = rs2.getString(10);
		if( sMaturity==null) sMaturity= "";
		
		sBusinessTypeName = rs2.getString(11);
		
		sOperateOrgID = rs2.getString(12);
		
		sSerialNo1 = rs2.getString(13);
		
		sDuebillSerialNo = rs2.getString(14);
		if(sDuebillSerialNo == null) sDuebillSerialNo = "";
		
		sMFCustomerID = rs2.getString("MFCustomerID");
		if(sMFCustomerID == null) sMFCustomerID = "";
		
		sCertTypeName = rs2.getString("CertTypeName");
		if(sCertTypeName == null) sCertTypeName = "";
		
		sCertID = rs2.getString("CertID");
		if(sCertID == null) sCertID="";	
		
		sBusinessCurrency = rs2.getString("BusinessCurrency");
		if(sBusinessCurrency == null) sBusinessCurrency="";	
		
		sContractSum = DataConvert.toMoney(rs2.getDouble("ContractSum"));	
		
		sPurpose = rs2.getString("Purpose");
		if(sPurpose == null) sPurpose="";
		ASResultSet rs1 = Sqlca.getResultSet(sTempSql);
		if(rs1.next())
		{
			sFlowNo = rs1.getString("FlowNo");
			if(sFlowNo == null) sFlowNo="";
		}
		rs1.close();
		
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=center colspan=4 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>����ҵ��֪ͨ��<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 > <u>&nbsp;&nbsp;"+sOperateOrgID+"&nbsp;&nbsp;</u>֧�л�Ʋ��ţ� </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u>�������ˣ�������ҵ��:<u>&nbsp;&nbsp;"+sBusinessTypeName+"&nbsp;&nbsp;</u><br>�Ѿ�������ҵ���������򱨾���Ȩ����������ͬ�⣬��ͨ�����չܿ�(��)����ˣ����㲿���ձ�֪ͨ��Ҫ�󣬰������������	   </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 > ��ͬ��ˮ��</td>");
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
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		
		sTemp.append("   <td align=left class=td1 >֤������</td>");
		sTemp.append("   <td align=left class=td1 >"+sCertTypeName+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >֤������</td>");
		sTemp.append("   <td align=left class=td1 >"+sCertID+"&nbsp;</td>");
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");

		sTemp.append("   <td align=left class=td1 >����</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessCurrency+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���Ž��(Ԫ)</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��ʼ��</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��ͬ��Ԫ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sContractSum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >������</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >ִ��������(��)</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��֤�����(%)</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��֤����</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�����˺�</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��Ʊ������</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��Ʊ�������ʺ�</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >���гжһ�Ʊ��;</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sPurpose+"&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >������ʽ������</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 ><p>&nbsp;</p><p>&nbsp;</p></td>");	
		sTemp.append("   </tr>");
		if("SmallPutOutFlow".equals(sFlowNo))
		{
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=4 class=td1 > �ſ����Ա��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ܸ�����ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p>&nbsp;</p> </td>");
			sTemp.append("   </tr>");
		}else{
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=4 class=td1 > ���չܿ�(��)�����Ա��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���չܿ�(��)��������:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<p>&nbsp;</p> </td>");
			sTemp.append("   </tr>");
		}
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=4 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>���Ź��£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> ���ڣ�"+DataConvert.toDate_YMD(sDay)+"</td>");
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


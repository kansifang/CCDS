<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2009/11/16
		Tester:
		Content: ���շ����϶�����
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
	int iDescribeCount =10 ;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader1.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%	
	ASResultSet rs = null;
	String sSql = "";
	String sContractNo = "",sGuarantyTypeName = "";//��ͬ��
	String sCustomerName = "";//���������
	String sCustomerTypeName = "";//�ͻ����
	String sSetupDate = "";//��ҵ������
	String sRegisterAdd = "";//ע���ַ
	double dRegisterCapital = 0.00,dGuarantyRate = 0.00,dEvalNetValue=0.00;//ע���ʱ�,����Ѻ��,����������ֵ
	String sMostBusiness = "";//��Ӫҵ��
	String sBasicBank = "";//����������
	String sCreditLevel = "";//���õȼ�
	String sLegalName = "";//����������
	String sBusinessTypeName = "";//����Ʒ��
	double dBalance = 0.00;//���
	String sPutOutDate = "";//��ʼ��
	String sMaturity = "";//������
	String sPMDate = "";//��ֹ����
	String sPutpose = "";//��;
	String sGuarantorName = "";//��֤��
	double dInterestBalance = 0.00;//ǷϢ
	String sClassifyResultName = "";//���շ�����
	String sActualBusiness = ""; //
	
	//��ù�����ͬ��
	sSql = "select ObjectNo from CLASSIFY_RECORD where  serialno='"+sObjectNo+"'";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sContractNo = rs.getString("ObjectNo");
	}
	rs.getStatement().close();
	
	//��ÿͻ���
	sSql = "select CustomerID from BUSINESS_CONTRACT  where  serialno='"+sContractNo+"'";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
	}
	rs.getStatement().close();
	
	//��ÿͻ�������Ϣ
	sSql = " select CI.CustomerName as CustomerName,"+
				 " getItemName('CustomerType',CI.CustomerType) as CustomerTypeName,"+
				 " EI.SetupDate as SetupDate,EI.RegisterAdd as RegisterAdd,"+
				 " EI.RegisterCapital as RegisterCapital,EI.ActualBusiness as ActualBusiness,"+
				 " nvl(EI.BasicBank,'') as BasicBank,EI.CreditLevel as CreditLevel"+
				" from customer_info CI,ENT_INFO EI "+
				" where CI.CUSTOMERID=EI.CUSTOMERID "+
				 " and CI.CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sCustomerName = rs.getString("CustomerName");
		sCustomerTypeName = rs.getString("CustomerTypeName");
		sSetupDate = rs.getString("SetupDate");
		sRegisterAdd = rs.getString("RegisterAdd");
		dRegisterCapital = rs.getDouble("RegisterCapital");
		sActualBusiness = rs.getString("ActualBusiness");
		if(sActualBusiness == null) sActualBusiness = "";
		sBasicBank = rs.getString("BasicBank");
		sCreditLevel = rs.getString("CreditLevel");
		
 	}
	rs.getStatement().close();
	
	//ȡ����������
	sSql = " select getCustomerName(RelativeID) as LegalName"+
		" from customer_relative "+
		" where  CustomerID='"+sCustomerID+"' and RelationShip='0100'";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sLegalName = rs.getString("LegalName");
	}
	rs.getStatement().close();
	
	//ȡ��ͬ�����Ϣ
	sSql = " select BC.SerialNo as ContractNo,"+
			" getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			" BC.Balance/10000 as Balance,BC.PutOutDate as PutOutDate,"+
			" BC.Maturity as Maturity,'',BC.Purpose as Putpose,'',"+
			" (BC.InterestBalance1+BC.InterestBalance2)/10000 as InterestBalance,"+
			" getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName "+
		" from BUSINESS_CONTRACT BC "+
		" where BC.SerialNo='"+sContractNo+"' ";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sBusinessTypeName = rs.getString("BusinessTypeName");
		dBalance = rs.getDouble("Balance")/10000;
		sPutOutDate = rs.getString("PutOutDate");
		sMaturity = rs.getString("Maturity");
		sPutpose = rs.getString("Putpose");
		dInterestBalance = rs.getDouble("InterestBalance")/10000;
		sClassifyResultName = rs.getString("ClassifyResultName");
		if(sPutOutDate != null)
		{
			sPMDate = sPutOutDate+"��"+sMaturity;
		}
	}
	rs.getStatement().close();

	//ȡ������Ϣ
	sSql = " select nvl(GC.GuarantorName,'') as GuarantorName,"+
			" nvl(GI.GuarantyRate,0) as GuarantyRate,"+
			" nvl(GI.EvalNetValue,0) as EvalNetValue, "+
			" getItemName('GuarantyList',GI.GuarantyType) as GuarantyTypeName "+
		" from GUARANTY_RELATIVE GR,GUARANTY_CONTRACT GC,GUARANTY_INFO GI "+
		" where GR.contractNo=GC.SERIALNO and GR.GUARANTYID=GI.GUARANTYID "+
		" and GR.objectType='BusinessContract' "+
		" and GR.ObjectNo='"+sContractNo+"' ";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sGuarantorName = rs.getString("GuarantorName");
		dGuarantyRate = rs.getDouble("GuarantyRate");
		dEvalNetValue = rs.getDouble("EvalNetValue")/10000;
		sGuarantyTypeName = rs.getString("GuarantyTypeName");
	}
	rs.getStatement().close();
	String sNation = "";
	double dTotalBalance = Sqlca.getDouble("select sum(balance) from business_contract where customerid = '"+sCustomerID+"'");
	if(dTotalBalance > 5000000){
		sNation = "һ����ҵ";
	}else{
		sNation = "С��ҵ";
	}
	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0101.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=center colspan=15 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��˾��ͻ��Ŵ��ʲ����շ����϶���</font></td> ");	
	sTemp.append("   </tr>");	
	
    sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >���λ</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+CurOrg.OrgName+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >��������</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >"+""+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >���֣������</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >��λ����Ԫ</td>");
	sTemp.append("   </tr>");
		
    sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >���������</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >ע���ʱ�</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+dRegisterCapital+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >���˴���</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+sLegalName+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
    sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >��Ӫҵ��</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+sActualBusiness+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >���÷����׼</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+sNation+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >���õȼ�</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+sClassifyResultName+"&nbsp;</td>");
	sTemp.append("   </tr>");	
	
    sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >����ͬ��</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >���Ų�Ʒ����</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >���</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >��������</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >������</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >�Ƿ�ͷ���ҵ��</td>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >������ʽ</td>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >��Ϣ�������</td>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >������</td>");
	sTemp.append("   </tr>");		

	String sBusinessType = "";
	String sBusinessSum = "";
	//String sPutOutDate = "";
	//String sMaturity = "";
	String sLowRisk = "";
	String sVouchType = "";
	String sClassifyResult = "";
	sSql = " select getBusinessName(BusinessType) as BusinessType,BusinessSum,PutOutDate,Maturity,"+
		   " getItemName('YesNo',LowRisk) as LowRisk,getItemName('VouchType',VouchType) as VouchType,"+
		   " getItemName('ClassifyResult',ClassifyResult) as ClassifyResult "+
		   " from Business_Contract where SerialNo = '"+sContractNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		 sBusinessType = rs.getString("BusinessType");
		 sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
		 sPutOutDate = rs.getString("PutOutDate");
		 sMaturity = rs.getString("Maturity");
		 sLowRisk = rs.getString("LowRisk");
		 sVouchType = rs.getString("VouchType");
		 sClassifyResult = rs.getString("ClassifyResult");
		 if(sBusinessType == null) sBusinessType = "";
		 if(sBusinessSum == null) sBusinessSum = "";
		 if(sPutOutDate == null) sPutOutDate = "";
		 if(sMaturity == null) sMaturity = "";
		 if(sLowRisk == null) sLowRisk = "";
		 if(sVouchType == null) sVouchType = "";
		 if(sClassifyResult == null) sClassifyResult = "";
		 
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sContractNo+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sBusinessType+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sLowRisk+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sVouchType+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+""+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sClassifyResult+"&nbsp;</td>");
	}
	rs.getStatement().close(); 
	 
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1  colspan=9 align=left  ><font style=' font-size: 10pt;FONT-FAMILY:����;'>�ͻ���������������ɼ������������:</font></td>"); 	
	sTemp.append("   </tr>");	
  	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=15 class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   </tr>");
  	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1  colspan=9 align=left  ><font style=' font-size: 10pt;FONT-FAMILY:����;'>֧�С�Ӫҵ�����������:</font></td>"); 	
	sTemp.append("   </tr>");	
  	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=9 class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   </tr>");
     
  	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1  colspan=9 align=left  ><font style=' font-size: 10pt;FONT-FAMILY:����;'>���չܿز����϶�Ա�����϶����:</font></td>"); 	
	sTemp.append("   </tr>");	
  	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=9 class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:100'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
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

<script language=javascript >
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//�ͻ���3
	var config = new Object();  
	editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe2');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe3');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>
	
<%@ include file="/IncludeEnd.jsp"%>
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
	int iDescribeCount = 4;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	String sViewOnly = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewOnly")); 
	if(sViewOnly == null) sViewOnly = "";
	if("".equals(sViewOnly))
	{
		sButtons[1][0] = "true";
	}
	else
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	String sCustomerID = "";
	String sCustomerName = "";
	String sSql = " select ObjectNo"+
			" from INSPECT_INFO II"+
			" where II.SerialNo='"+sSerialNo+"'";
	
	ASResultSet rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sCustomerID=rs.getString(1);
	}
	rs.getStatement().close();
	if(sCustomerID == null) sCustomerID = "";
	String sOrgTypeName = "";
	String sCreditLevel = "";
	sSql = " select getCustomerName(CustomerID),getItemName('OrgType',OrgType) as OrgTypeName ,getItemName('CreditLevel',CreditLevel) as CreditLevel"+
		   " from Ent_info where customerID = '"+sCustomerID+"'";
	rs=Sqlca.getResultSet(sSql);
	if(rs.next()){
		sCustomerName = rs.getString(1);
		sOrgTypeName = rs.getString("OrgTypeName");
		sCreditLevel = rs.getString("CreditLevel");
	}
	rs.getStatement().close();
	if(sCustomerName == null) sCustomerName = "";
	if(sOrgTypeName == null) sOrgTypeName = "";
	if(sCreditLevel == null) sCreditLevel = "";
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='10.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=25 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>���ũ������</p>����Ԥ���ͻ�ר���鱨��</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa><strong>������Ŀ�ſ���</strong> </td>");
    sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >�ͻ����ƣ� </td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >��ҵ���ͣ�</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sOrgTypeName+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���ʱ�䣺</td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+StringFunction.getToday()+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���õȼ���</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sCreditLevel+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=17% class=td1 >���Ų�Ʒ����</td>");
	sTemp.append("   <td width=10% class=td1 >��ͬ���</td>");
	sTemp.append("   <td width=15% class=td1 >����</td>");
	sTemp.append("   <td width=10% class=td1 >���</td>");
	sTemp.append("   <td width=15% class=td1 >������</td>");	
	sTemp.append("   <td width=13% class=td1 >������</td>");
	sTemp.append("   <td width=20% class=td1 >�������</td>");	
    sTemp.append("   </tr>"); 
    String sBusinessTypeName = "";
    String sContractSerialNo = "";
    String sPayCyc = "";
    String sBalance = "0.00";
    String sMaturity = ""; 
    String sVouchTypeName = ""; 
    String sBusinessCurrency = "";
    String sPutOutDate = "";
	sSql = " select getBusinessName(BusinessType) as BusinessTypeName,SerialNo,getItemName('Currency',businesscurrency) as BusinessCurrency, "+
		   " getItemName('CorpusPayMethod1',PayCyc)as PayCyc,Balance,PutOutDate,Maturity,getItemName('VouchType',VouchType) as VouchTypeName"+
		   " from BUSINESS_CONTRACT where CustomerID = '"+sCustomerID+"'";
    rs = Sqlca.getResultSet(sSql);
    while(rs.next()){
    	sBusinessTypeName = rs.getString("BusinessTypeName");
    	sContractSerialNo = rs.getString("SerialNo");
    	sPayCyc = rs.getString("PayCyc");
    	sBalance = DataConvert.toMoney(rs.getDouble("Balance"));
    	sMaturity = rs.getString("Maturity");
    	sPutOutDate = rs.getString("PutOutDate");
    	sVouchTypeName = rs.getString("VouchTypeName");
    	sBusinessCurrency = rs.getString("BusinessCurrency");
    	if(sBusinessTypeName == null) sBusinessTypeName = "";
    	if(sContractSerialNo == null) sContractSerialNo = "";
    	if(sPayCyc == null)sPayCyc = "";
   	 	if(sBalance == null) sBalance="0.00";
    	if(sMaturity == null) sMaturity = "";
    	if(sVouchTypeName == null) sVouchTypeName = "";
    	if(sBusinessCurrency == null) sBusinessCurrency = "";
    	if(sPutOutDate == null) sPutOutDate = "";
    	sTemp.append("   <tr>");
		sTemp.append("   <td colspan=1 class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sBusinessCurrency+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sBalance+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sVouchTypeName+"&nbsp;</td>");
	    sTemp.append("   </tr>");  
    }
   	double dTotalBalance = Sqlca.getDouble(" select sum(Balance) from BUSINESS_CONTRACT where CustomerID = '"+sCustomerID+"'");
   	String sTotalBalance = DataConvert.toMoney(String.valueOf(dTotalBalance));
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3 align=left class=td1 >�ϼƣ�");
	sTemp.append("   </td>");
	sTemp.append("   <td colspan=1 class=td1 >"+sTotalBalance+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���ճ��ڣ�");
	sTemp.append("   </td>");
	sTemp.append("   <td colspan=2 class=td1 >"+""+"&nbsp;</td>");
    sTemp.append("   </tr>");
    
    rs.getStatement().close();
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa>�ϴμ�����ڼ��������");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");         
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa>����Ԥ���ź��������");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa>�����ʩ��ʵ���");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa>�������ۼ�Ӧ�Դ�ʩ");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1>�������ۼ�Ӧ�Դ�ʩ:");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("   �ͻ�����ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�</td>");
    sTemp.append("   </tr>");

	sTemp.append("   <td colspan=7 align=left class=td1>���Ÿ����������");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");     
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	//sTemp.append(myOutPut("1",sMethod,"name='describe105' style='width:100%; height:150'",getUnitData("describe105",sData)));
	sTemp.append("   <br>");
	sTemp.append("  <br/><br/><br/><br/> ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�</td>");
    sTemp.append("   </tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
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
	editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe2');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe3');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe4');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


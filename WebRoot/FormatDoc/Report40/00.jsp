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
	int iDescribeCount = 1;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//��õ��鱨������
	String sRegisterAdd = "";		//ע���ַ
	String sRegisterCapital = "";	//ע���ʱ�
	double dRegisterCapital = 0.0;
	String sSellSum = "";          //���ʲ�
	double dSellSum = 0.0 ;
	String sEnterpriseName = "" ;    //��ҵ����
	String sCreditLevel = "" ;//��������
	
	//�����˻�����Ϣ
	ASResultSet rs2 = Sqlca.getResultSet("select RegisterAdd,RegisterCapital,SellSum,EnterpriseName,CreditLevel "
							+"from ENT_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		sRegisterAdd = rs2.getString(1);
		if(sRegisterAdd == null) sRegisterAdd=" ";
		
		sRegisterCapital = DataConvert.toMoney(rs2.getDouble(2)/10000);
		if(sRegisterCapital == null) sRegisterCapital="0";
		
		sSellSum = DataConvert.toMoney(rs2.getDouble(3)/10000);
		if(sSellSum == null) sSellSum="0";
		
		sEnterpriseName = rs2.getString(4);
		if(sEnterpriseName == null) sEnterpriseName=" ";
		
		sCreditLevel = rs2.getString(5);
		if(sCreditLevel == null) sCreditLevel=" ";
	}
	rs2.getStatement().close();	
	
	String sFictitiousPerson = "";//���˴���
	sFictitiousPerson = Sqlca.getString("select CustomerName from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and RelationShip = '0100'");
	if(sFictitiousPerson == null) sFictitiousPerson = "";

 %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='5' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��һ�������˻�����Ϣ</font></td>"); 	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='5' align=left class=td1 > ��ҵ���ƣ�"+sEnterpriseName+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='2' align=left class=td1 > ���������ˣ�"+sFictitiousPerson+"&nbsp;</td>");
    sTemp.append("   <td colspan='3' align=left class=td1 > ��λ��ַ�� "+sRegisterAdd+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='5' align=left class=td1 > ���񱨱���ƻ�����"+" "+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='2' align=left class=td1 > ע���ʱ� ��"+sRegisterCapital+"&nbsp;��Ԫ�����</td>");
    sTemp.append("   <td colspan='3' align=left class=td1 > ���ʲ� ��"+sSellSum+"&nbsp;��Ԫ�����</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='5' align=left class=td1 > ����������"+sCreditLevel+"&nbsp;</td>");
	sTemp.append("   </tr>");
																	
	//�����˻�����Ϣ
	sTemp.append("   <tr>");
  	sTemp.append("   <td  width=10% rowspan='4' align=center class=td1 > �ɶ����</td>");
    sTemp.append("   <td  align=left class=td1 > �ɶ�����</td>");
    sTemp.append("   <td  align=left class=td1 > �ɶ�����</td>");
    sTemp.append("   <td  align=left class=td1 > ���ʱ���</td>");
    sTemp.append("   <td  align=left class=td1 > ���ʷ�ʽ</td>");
	sTemp.append("   </tr>");
	String sCustomerName = "";    //�ɶ�����
	String sRelationShipName = "";    //���ʷ�ʽ					
	String sInvestmentProp = "";    //���ʱ���	
	rs2 = Sqlca.getResultSet("select CustomerName,InvestmentProp,RelationShip,"
							+" getItemName('RelationShip',RelationShip) as RelationShipName "
							+" from CUSTOMER_RELATIVE   where CustomerID = '"+sCustomerID+"'  and RelationShip like '52%'  and length(RelationShip)>2 order by InvestmentSum desc ");
	
	int k=1;
	while(rs2.next()){
	
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName=" ";
		
		sRelationShipName = rs2.getString(4);
		if(sRelationShipName == null) sRelationShipName=" ";
		
		sInvestmentProp = rs2.getString(2);
		if(sInvestmentProp == null) sInvestmentProp=" ";
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td  align=left class=td1 > "+sCustomerName+"&nbsp; </td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+ " "+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+sInvestmentProp+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+sRelationShipName+"&nbsp;</td>");
	    k++;
	    sTemp.append("   </tr>");	    
	}
	rs2.getStatement().close();
	while(k<4){
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td  align=left class=td1 > "+""+"&nbsp; </td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+ " "+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
	    sTemp.append("   </tr>");	 
	    k++; 
	}

	sTemp.append("   <tr>");
  	sTemp.append("   <td  width=10% rowspan='4' align=center class=td1 > ��Ҫ������ҵ</td>");
    sTemp.append("   <td  align=left class=td1 > ��ҵ����</td>");
    sTemp.append("   <td  align=left class=td1 > �عɱ���</td>");
    sTemp.append("   <td  align=left class=td1 > ע���ʱ�(��Ԫ)</td>");
    sTemp.append("   <td  align=left class=td1 > ��Ӫ��Χ</td>");
    sTemp.append("   </tr>");
	String sInvestmentSum="";	//ע���ʱ�
	double dInvestmentSum=0.0;
	String sDescribe="";		//��Ҫ��Ӫ��Χ
	
	rs2 = Sqlca.getResultSet(" select CustomerName,InvestmentProp,InvestmentSum, Describe" +
					" from CUSTOMER_RELATIVE " +
					" where CustomerID = '"+sCustomerID+"' "+
					" and RelationShip like '56%' "+
					" and length(RelationShip)>2 ");
	k=1;
	while(rs2.next()){
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName=" ";
		
		sInvestmentProp = rs2.getString(2);
		if(sInvestmentProp == null) sInvestmentProp=" ";
		
		sInvestmentSum = rs2.getString(3);
		if(sInvestmentSum == null) sInvestmentSum="0";
		dInvestmentSum = DataConvert.toDouble(sInvestmentSum)/10000;
		
		sDescribe = rs2.getString(4);
		if(sDescribe == null) sDescribe=" ";
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td  align=left class=td1 > "+sCustomerName+"&nbsp; </td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+sInvestmentProp+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+dInvestmentSum+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+sDescribe+"&nbsp;</td>");
	    k++;
	    sTemp.append("   </tr>");
	}
	rs2.getStatement().close();
	while(k<4){
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td  align=left class=td1 > "+""+"&nbsp; </td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+ " "+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
	    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
	    sTemp.append("   </tr>");	 
	    k++; 
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
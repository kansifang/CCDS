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
	int iDescribeCount = 2;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//��õ��鱨������
	String sRegisterAdd = "";		//ע���ַ
	String sRegisterCapital = "";	//ע���ʱ�
	String sEnterpriseName = "" ;    //��ҵ����
	String sSetupDate = ""; //����ʱ��
	String sMostBusiness = "";//��Ӫ��Χ
	String sIndustryName = "" ;//��ҵ����
	String sEmployeeNumber = "";//ְ������
	String sLicenseNo = ""; //Ӫҵִ��
	String sBasicBank = "";//����������
	String sLoanCardNo = "";//�����
	//�����˻�����Ϣ
	ASResultSet rs2 = Sqlca.getResultSet(" select EnterpriseName,SetupDate,RegisterCapital,RegisterAdd,MostBusiness,"+
										 " getItemName('IndustryName',IndustryName) as IndustryName,EmployeeNumber,LicenseNo,BasicBank,LoanCardNo "+
										 " from ENT_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		sRegisterAdd = rs2.getString("RegisterAdd");
		if(sRegisterAdd == null) sRegisterAdd=" ";
		
		sRegisterCapital = DataConvert.toMoney(rs2.getDouble("RegisterCapital"));
		if(sRegisterCapital == null) sRegisterCapital="";
		
		sEnterpriseName = rs2.getString("EnterpriseName");
		if(sEnterpriseName == null) sEnterpriseName=" ";
		
		sMostBusiness = rs2.getString("MostBusiness");
		if(sMostBusiness == null) sMostBusiness=" ";
		
		sIndustryName = rs2.getString("IndustryName");
		if(sIndustryName == null) sIndustryName=" ";
		
		sEmployeeNumber = rs2.getString("EmployeeNumber");
		if(sEmployeeNumber == null) sEmployeeNumber=" ";
		
		sLicenseNo = rs2.getString("LicenseNo");
		if(sLicenseNo == null) sLicenseNo=" ";
		
		sBasicBank = rs2.getString("BasicBank");
		if(sBasicBank == null) sBasicBank=" ";
		
		sLoanCardNo = rs2.getString("LoanCardNo");
		if(sLoanCardNo == null) sLoanCardNo=" ";
		
		sSetupDate = rs2.getString("SetupDate");
		if(sSetupDate == null) sSetupDate=" ";		
	}
	rs2.getStatement().close();	
	
	String sFictitiousPerson = "";//���˴���
	sFictitiousPerson = Sqlca.getString("select CustomerName from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and RelationShip = '0100'");
	if(sFictitiousPerson == null) sFictitiousPerson = "";

 %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0101.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���������˻������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��һ�������˸ſ�</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > ��ҵ���ƣ�</td>");
   	sTemp.append("   <td colspan='3' align=left class=td1 > "+sEnterpriseName+"&nbsp;</td>");  
   	sTemp.append("   <td colspan='1' align=left class=td1 > ����ʱ�䣺</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sSetupDate+"&nbsp;</td>");  	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > ע���ʱ�(��Ԫ)��</td>");
   	sTemp.append("   <td colspan='1' align=left class=td1 > "+sRegisterCapital+"&nbsp;</td>");  
   	sTemp.append("   <td colspan='1' align=left class=td1 > ע���ַ��</td>");   	
  	sTemp.append("   <td colspan='3' align=left class=td1 >"+sRegisterAdd+"&nbsp;</td>");  	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > ��Ӫ��Χ��</td>");
   	sTemp.append("   <td colspan='5' align=left class=td1 > "+sMostBusiness+"&nbsp;</td>");  	 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
   	sTemp.append("   <td colspan='1' align=left class=td1 > ��ҵ��</td>");   	
  	sTemp.append("   <td colspan='3' align=left class=td1 >"+sIndustryName+"&nbsp;</td>"); 
   	sTemp.append("   <td colspan='1' align=left class=td1 > ������</td>");   	
  	sTemp.append("   <td colspan='1' align=left class=td1 >"+sEmployeeNumber+"&nbsp;</td>");    	 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > Ӫҵִ�գ�</td>");
   	sTemp.append("   <td colspan='3' align=left class=td1 > "+sLicenseNo+"&nbsp</td>");  
   	sTemp.append("   <td colspan='1' align=left class=td1 > �Ƿ���죺</td>");   	
	sTemp.append("   <td colspan=1 class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:30'",getUnitData("describe1",sData)));
	sTemp.append("   &nbsp;</td>");	
	sTemp.append("   </tr>");		
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' width=15% height=30px align=left class=td1 > ���������ˣ�</td>");
    sTemp.append("   <td colspan='1' width=15% align=left class=td1 >"+sFictitiousPerson+"&nbsp;</td>");
  	sTemp.append("   <td colspan='1' width=15% align=left class=td1 > ���������У�</td>");
    sTemp.append("   <td colspan='1' width=20% align=left class=td1 >"+sBasicBank+"&nbsp;</td>");
  	sTemp.append("   <td colspan='1' width=15% align=left class=td1 > ������ţ�</td>");
    sTemp.append("   <td colspan='1' width=25% align=left class=td1 >"+sLoanCardNo+"&nbsp;</td>");        
	sTemp.append("   </tr>");
	String sCustomerName = "";
	String sEngageTerm = "";
	rs2 = Sqlca.getASResultSet("select CustomerName,EngageTerm from CUSTOMER_RELATIVE  where CustomerID='"+sCustomerID+"' and RelationShip = '0109'");
	if(rs2.next()){
		sCustomerName = rs2.getString("CustomerName");
		sEngageTerm = rs2.getString("EngageTerm");
		if(sCustomerName == null) sCustomerName = "";
		if(sEngageTerm == null) sEngageTerm = "";
	}
	rs2.getStatement().close();
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > ʵ���ƿ��ˣ�</td>");
    sTemp.append("   <td colspan='1' align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > ��ҵ����(��)��</td>");
    sTemp.append("   <td colspan='1' align=left class=td1 >"+sEngageTerm+"&nbsp;</td>");
  	sTemp.append("   <td colspan='1' align=left class=td1 > �Ƿ��в�����¼��</td>");
	sTemp.append("   <td colspan='1' class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:30'",getUnitData("describe2",sData)));
	sTemp.append("   &nbsp;</td>");
		       
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
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
	int iDescribeCount =9;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
//Add by zhaominglei 060308

	String sFullName = "";			//����
	String sCertType = "";			//֤������
	String sCertID = "";				//֤������
	String sSex = "";						//�Ա�
	String sBirthday = "";			//��������
	String sEduExperience = "";	//���ѧ��
	String sEduDegree = "";			//���ѧλ
	String sNativePlace = "";		//������ַ
	String sMarriage = "";			//����״��
	String sFamilyAdd = "";			//��ס��ַ
	String sFamilyZIP = "";		//��ס��ַ�ʱ�
	String sCommAdd = "";				//ͨѶ��ַ
	String sCommZip = "";				//ͨѶ��ַ�ʱ�
	String sOccupation = "";		//ְҵ	
	String sHeadShip = "";			//ְ��
	String sPosition = "";			//ְ��
	String sIndustryTypeName = "";	//Ŀǰ������ҵ
	String sWorkCorp = "";			//��λ����
	String sNationality = "";         //����
	String sPopulationNum = "";        //��ͥ�˿���
	String sYearIncome = ""; //����������
	String sPopulationIncome = ""; //���˾�����
	String sWorkingPopulationNum = ""; //�Ͷ����˿���
	String sHoldBond = ""; //�м�֤��
	String sProduceData = ""; //���ɾ�Ӫ��ģ
	String sFamilyMonthIncome = ""; //��ͥ������
	String sOtherAssert = ""; //�����ʲ�
	String sDebtValue = "" ;//��������
	//�����˻�����Ϣ
	ASResultSet rs2 = Sqlca.getResultSet("select FullName,getItemName('CertType',CertType) as CertType,CertID,getItemName('Sex',Sex) as Sex,Birthday,getItemName('EducationExperience',EduExperience) as EduExperience,getItemName('EducationDegree',EduDegree) as EduDegree,"
							+"NativePlace,getItemName('Marriage',Marriage) as Marriage,FamilyAdd,FamilyZIP,CommAdd,CommZip,getItemName('Occupation',Occupation) as Occupation,getItemName('HeadShip',HeadShip) as HeadShip,"
							+"getItemName('TechPost',Position) as Position,getItemName('IndustryType',UnitKind) as IndustryTypeName,WorkCorp,"+
							" getItemName('Nationality',Nationality) as Nationality,PopulationNum,YearIncome,FamilyMonthIncome "
							+"from IND_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		sFullName = rs2.getString(1);
		if(sFullName == null) sFullName=" ";
		
		sCertType = rs2.getString(2);
		if(sCertType == null) sCertType=" ";
		
		sCertID = rs2.getString(3);
		if(sCertID == null) sCertID=" ";
		
		sSex = rs2.getString(4);
		if(sSex == null) sSex=" ";
		
		sBirthday = rs2.getString(5);
		if(sBirthday == null) sBirthday=" ";
		
		sEduExperience = rs2.getString(6);
		if(sEduExperience == null) sEduExperience=" ";
		
		sEduDegree = rs2.getString(7);
		if(sEduDegree == null) sEduDegree=" ";
		
		sNativePlace = rs2.getString(8);
		if(sNativePlace == null) sNativePlace=" ";
		
		sMarriage = rs2.getString(9);
		if(sMarriage == null) sMarriage=" ";
		
		sFamilyAdd = rs2.getString(10);
		if(sFamilyAdd == null) sFamilyAdd=" ";
		
		sFamilyZIP = rs2.getString(11);
		if(sFamilyZIP == null) sFamilyZIP=" ";
		
		sCommAdd = rs2.getString(12);
		if(sCommAdd == null) sCommAdd=" ";
		
		sCommZip = rs2.getString(13);
		if(sCommZip == null) sCommZip=" ";
		
		sOccupation = rs2.getString(14);
		if(sOccupation == null) sOccupation=" ";
		
		sHeadShip = rs2.getString(15);
		if(sHeadShip == null) sHeadShip=" ";
		
		sPosition = rs2.getString(16);
		if(sPosition == null) sPosition=" ";
		
		sIndustryTypeName = rs2.getString(17);
		if(sIndustryTypeName == null) sIndustryTypeName=" ";
		
		sWorkCorp = rs2.getString(18);
		if(sWorkCorp == null) sWorkCorp=" ";
		
		sNationality = rs2.getString(19);
		if(sNationality == null) sNationality="";

		sPopulationNum = rs2.getString(20);
		if(sPopulationNum == null) sPopulationNum = "";
		
		sYearIncome = DataConvert.toMoney(rs2.getDouble(21));
		if(sYearIncome == null) sYearIncome = "";
		
		sFamilyMonthIncome = DataConvert.toMoney(rs2.getDouble(22));
		if(sFamilyMonthIncome == null) sFamilyMonthIncome = "";				
	}
	rs2.getStatement().close();	
	
	rs2 = Sqlca.getASResultSet(" select sum(nvl(BondSum,0)*getErate(BondCurrency,'01','')) from CUSTOMER_BOND"+
						" Where CustomerID = '"+sCustomerID+"'"); 
	if(rs2.next()){
		sHoldBond = DataConvert.toMoney(rs2.getDouble(1));
		if(sHoldBond == null) sHoldBond = "";
	}	
	rs2.getStatement().close();
	
	rs2 = Sqlca.getASResultSet(" select sum(AssetValue) from IND_OASSET where CustomerID = '"+sCustomerID+"'");
	if(rs2.next()){
		sOtherAssert = DataConvert.toMoney(rs2.getDouble(1));
		if(sOtherAssert == null) sOtherAssert = "0";
	}
	rs2.getStatement().close();
	
	rs2 = Sqlca.getASResultSet(" select sum(DebtValue) from IND_ODEBT where CustomerID = '"+sCustomerID+"'");
	if(rs2.next()){
		sDebtValue = DataConvert.toMoney(rs2.getDouble(1));
		if(sDebtValue == null) sDebtValue = "0";
	}				
	rs2.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2 �����˻�����Ϣ�ſ�</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1���ſ�</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append(" <td width=15% align=center class=td1 > ���� </td>");
    sTemp.append(" <td width=15%  align=left class=td1 >"+sFullName+"&nbsp;</td>");
  	sTemp.append(" <td width=15% align=center class=td1 > ���� </td>");
    sTemp.append(" <td colspan='3' align=left class=td1 >"+sNationality+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ֤������ </td>");
    sTemp.append("     <td colspan='1' align=left class=td1 >"+sCertType+"&nbsp;</td>");
	sTemp.append("     <td width=15% align=center class=td1 > ֤������ </td>");
	sTemp.append("     <td colspan='3' align=left class=td1 >"+sCertID+"&nbsp;</td>");
	 sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td width=15% align=center class=td1 > �Ա� </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sSex+"&nbsp;</td>");
   	sTemp.append("     <td width=15% align=center class=td1 > �������� </td>");
    sTemp.append("     <td colspan='3' align=left class=td1 >"+sBirthday+"&nbsp;</td>");
     sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td width=15% align=center class=td1 > ���ѧ�� </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sEduExperience+"&nbsp;</td>");
	sTemp.append("     <td width=15% align=center class=td1 > ���ѧλ </td>");
    sTemp.append("     <td colspan='3' align=left class=td1 >"+sEduDegree+"&nbsp;</td>");
   sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > ������ַ </td>");
    sTemp.append("     <td colspan='5' align=left class=td1 >"+sNativePlace+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td width=15% align=center class=td1 > ����״�� </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sMarriage+"&nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 > ��ͥ�˿������ˣ� </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sPopulationNum+"&nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 > ���У��Ͷ����˿ڣ��ˣ� </td>");
//    sTemp.append("     <td width=15% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append("     <td width=15%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td width=15% align=center class=td1 > ����������(Ԫ) </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sYearIncome+"&nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 > ��ͥ�����루Ԫ�� </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sFamilyMonthIncome+"&nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 > �м�֤ȯ��Ԫ�� </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sHoldBond+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td width=15% align=center class=td1 > ��ס��ַ </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sFamilyAdd+"&nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 > ��ס��ַ�ʱ� </td>");
    sTemp.append("     <td colspan='3' align=left class=td1 >"+sFamilyZIP+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td width=15% align=center class=td1 > ͨѶ��ַ </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sCommAdd+"&nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 > ͨѶ��ַ�ʱ� </td>");
    sTemp.append("     <td colspan='3' align=left class=td1 >"+sCommZip+"&nbsp;</td>");
    sTemp.append("  </tr>");
//	sTemp.append("   <tr>");
//	sTemp.append("     <td colspan='4' align=left class=td1 > ��Ӫ��Χ��<br>"+MostBusiness+"&nbsp;</td>");
//    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ְҵ </td>");
    sTemp.append("     <td colspan='5' align=center class=td1 >"+sOccupation+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > ְ�� </td>");
    sTemp.append("     <td colspan='5' align=center class=td1 >"+sHeadShip+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ְ�� </td>");
    sTemp.append("    <td colspan='5' align=center class=td1 >"+sPosition+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > ��λ���� </td>");
    sTemp.append("     <td colspan='5' align=center class=td1 >"+sWorkCorp+"&nbsp;</td>");
    sTemp.append("  </tr>");

        
    sTemp.append("   <tr>");
	sTemp.append("     <td width=15% align=center class=td1 > ��Ӫ�ֺ� </td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 >Ӫҵִ�պ� </td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:25'",getUnitData("describe10",sData)));
	sTemp.append("   &nbsp;</td>");    
	sTemp.append("     <td width=15% align=center class=td1 > ��Ӫ��Χ </td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:25'",getUnitData("describe11",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("  </tr>");


         
    sTemp.append("   <tr>");
	sTemp.append("     <td width=15% align=center class=td1 > �����ʲ���Ԫ�� </td>");
//    sTemp.append("     <td colspan=2 align=left class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   <td colspan=2  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 > �����ʲ�(Ԫ�� </td>");
    sTemp.append("     <td colspan=2 align=left class=td1 >"+sOtherAssert+"&nbsp;</td>");
//    sTemp.append("     <td width=15% align=center class=td1 > �м�֤ȯ </td>");
//    sTemp.append("     <td width=15% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append("  </tr>");    
    sTemp.append("   <tr>");
	sTemp.append("     <td width=15% align=center class=td1 > Ŀǰ������ҵ </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sIndustryTypeName+"&nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 > ��������Ӫ����ģ </td>");
//    sTemp.append("     <td width=15% align=left class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   <td width=15%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 > �����ʽ�Ԫ�� </td>");
//    sTemp.append("     <td width=15% align=left class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   <td width=15%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:25'",getUnitData("describe5",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td width=15% align=center class=td1 > ���Ҵ��Ԫ�� </td>");
//    sTemp.append("     <td width=15% align=left class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   <td width=15%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:25'",getUnitData("describe6",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 > ������ծ��Ԫ��</td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sDebtValue+"&nbsp;</td>");
    sTemp.append("     <td width=15% align=center class=td1 > ������ծ��Ԫ�� </td>");
//    sTemp.append("     <td width=15% align=left class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   <td width=15%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:25'",getUnitData("describe8",sData)));
	sTemp.append("  &nbsp; </td>");
    sTemp.append("  </tr>");
//End by zhaominglei 060308
    
    sTemp.append(" </tr>");
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

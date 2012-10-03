<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   wangdw 2009.08.21
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
	int iDescribeCount = 13;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	String sMonthIncome    = "";			//���˹���������
	String sOverDueBalance = "";			//���ڽ��
	String sEvaluateScore  = "";			//���÷���
	String sFamilyStatus   = "";			//��ס״��
	double dOverDueBalance = 0.0;			//���ڽ��
	double dEvaluateScore  = 0.0;
    double dEvaluateModulus= 0.0; 			//��������ϵ��
	double dVouchModulus   = 0.0;    		//������ʽϵ��
    double dRiskEvaluate   = 0.0;    		//���ŷ��ն�

	int    otherdk		   = 0;				//������������
	//�����롢��ס״��
	String sSql1 = " select YearIncome,FamilyStatus  from IND_INFO where CustomerID = '"+sCustomerID+"'";
	ASResultSet rs1 = Sqlca.getResultSet(sSql1);
	if(rs1.next())
	{
		sMonthIncome = DataConvert.toMoney(rs1.getDouble("YearIncome")/12);
		if(sMonthIncome == null) sMonthIncome = "";
		
		sFamilyStatus = rs1.getString("FamilyStatus");
		if(sFamilyStatus == null) sFamilyStatus = "";
	}
	rs1.getStatement().close();		
	//����������
	String sSql3 = "select count(*) as otherdk from Business_Contract  where customerid = '"+sCustomerID+"'  and (FinishDate is  null or FinishDate ='') ";
	ASResultSet rs3 = Sqlca.getResultSet(sSql3);
	if(rs3.next())
	{
		otherdk = rs3.getInt("otherdk");
	}
	rs3.getStatement().close();
	//���ڽ��
	String sSql4 = "select sum(OverDueBalance) as OverDueBalance from Business_Contract where CustomerID ='"+sCustomerID+"' and  ( FinishDate = ''  or FinishDate IS NULL)  and OverDueBalance>0";
	ASResultSet rs4 = Sqlca.getResultSet(sSql4);
	if(rs4.next())
	{
		dOverDueBalance = rs4.getDouble("OverDueBalance");
		sOverDueBalance = DataConvert.toMoney(dOverDueBalance);
		if(sOverDueBalance == null) sOverDueBalance = "";
	}
	rs4.getStatement().close();
	//���ű������÷���
	String sSql5 = "select EvaluateScore from Evaluate_Record where ObjectType = 'Customer' and ObjectNo='"+sCustomerID+"' order by AccountMonth DESC fetch first 1 row only ";
	ASResultSet rs5 = Sqlca.getResultSet(sSql5);
	if(rs5.next())
	{
		dEvaluateScore = rs5.getDouble("EvaluateScore");
		sEvaluateScore = DataConvert.toMoney(dEvaluateScore);
		if(sEvaluateScore == null) sEvaluateScore = "";
	}
	rs5.getStatement().close();
	//��������ϵ����������ʽϵ�������ŷ��ն�
	String sSql6 = "select VouchModulus,RiskEvaluate,EvaluateModulus from Risk_Evaluate where ObjectNo ='"+sObjectNo+"' and ObjectType='CreditApply'";
	ASResultSet rs6 = Sqlca.getResultSet(sSql6);
	if(rs6.next())
	{
		dVouchModulus    = rs6.getDouble("VouchModulus");
		dRiskEvaluate 	 = rs6.getDouble("RiskEvaluate");
		dEvaluateModulus = rs6.getDouble("EvaluateModulus");
	}
	rs6.getStatement().close();
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0102.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1.2������ѯ�����������ϣ������ˡ���ͬ�����ˡ�����������������£�</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=20 height='34' class=td1 >");
	sTemp.append(" 	 ��1��");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"�޲������ü�¼"));
	sTemp.append("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"���������"));
	sTemp.append("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"�ڸ�������ϵͳ���޼�¼"));
	sTemp.append("   </td>");  	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=20 height='34' class=td1 >");
	sTemp.append(" 	 ��2��");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"���������"));
	sTemp.append("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
  	sTemp.append("   �ϼƣ�<u>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:5%; height:25'",getUnitData("describe5",sData)));
	sTemp.append("</u>��&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
  	sTemp.append("   �ϼ��»��<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:15%; height:25'",getUnitData("describe6",sData)));
	sTemp.append("</u>      Ԫ&nbsp;</td>");
	sTemp.append("   </tr>");


	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% colspan=20  height='34' align=left class=td1 >��3��");
  	sTemp.append("   �ϼ��»���ռ�ϼ������������");

	sTemp.append("&nbsp;<u>");  	
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:20%; height:25'",getUnitData("describe7",sData)));
	sTemp.append("</u>      %&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=20 height='34'class=td1 >");
	sTemp.append(" 	 ��4��");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"�н������"));
  	sTemp.append("   ���ڽ��ϼƣ�<u>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("</u>      Ԫ&nbsp;</td>");
 	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% colspan=20 height='34' align=left class=td1 >��5��");
  	sTemp.append("   ���������ű������÷�����<u>");
	sTemp.append(sEvaluateScore);
	sTemp.append("</u>��");
	sTemp.append("</td>");
 	sTemp.append("   </tr>");
 	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1.3����������ס�������</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=20 class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe10'",getUnitData("describe10",sData),"���в�Ȩ@����@����"));
	sTemp.append("   </td>");  	
	sTemp.append("   </tr>");
		

	sTemp.append(" <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1.4�������ʲ������</font></td>"); 	
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='6' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:150'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");

	sTemp.append(" <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1.5</font></td>"); 	
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >����ҵ�����ŷ��ն�R��</td>");
  	sTemp.append("   	<td width=15%  align=right class=td1 >");
	sTemp.append(dRiskEvaluate);
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >��������ϵ����</td>");
  	sTemp.append("   	<td width=15%  align=right class=td1 >");
	sTemp.append(dEvaluateModulus);
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >������ʽϵ����</td>");
  	sTemp.append("   	<td width=15%  align=right class=td1 >");
	sTemp.append(dVouchModulus);
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 height='34' align=left colspan=20 >&nbsp</font></td>"); 	
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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   wangdw 2012.05.21
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
	int iDescribeCount = 100;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//��õ��鱨������
	String sMonthIncome    = "";			//���˹���������	
	String sFamilyStatus   = "";			//��ס״��
	String sEvaluateScore  = "";			//���÷���
	String sOverDueBalance = "";			//���ڽ��
	double dOverDueBalance = 0.0;			//���ڽ��
	double dEvaluateScore  = 0.0;
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
	//���ű������÷���
	String sSql3 = "select EvaluateScore from Evaluate_Record where ObjectType = 'Customer' and ObjectNo='"+sCustomerID+"' order by AccountMonth DESC fetch first 1 row only ";
	ASResultSet rs3 = Sqlca.getResultSet(sSql3);
	if(rs3.next())
	{
		dEvaluateScore = rs3.getDouble("EvaluateScore");
		sEvaluateScore = DataConvert.toMoney(dEvaluateScore);
		if(sEvaluateScore == null) sEvaluateScore = "";
	}
	//����������
//	String sSql4 = "select count(*) as otherdk from Business_Contract  where customerid = '"+sCustomerID+"'  and (FinishDate is  null or FinishDate ='') ";
//	ASResultSet rs4 = Sqlca.getResultSet(sSql4);
//	if(rs4.next())
//	{
//		otherdk = rs4.getInt("otherdk");
//	}
	//���ڽ��
	String sSql5 = "select sum(OverDueBalance) as OverDueBalance from Business_Contract where CustomerID ='"+sCustomerID+"' and  ( FinishDate = ''  or FinishDate IS NULL)  and OverDueBalance>0";
	ASResultSet rs5 = Sqlca.getResultSet(sSql5);
	if(rs5.next())
	{
		dOverDueBalance = rs5.getDouble("OverDueBalance");
		sOverDueBalance = DataConvert.toMoney(dOverDueBalance);
		if(sOverDueBalance == null) sOverDueBalance = "";
	}
	rs1.getStatement().close();	
	rs3.getStatement().close();	
//	rs4.getStatement().close();	
	rs5.getStatement().close();	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0302.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");

	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.2�����˱�֤����֤�˻��������</font></td>"); 		sTemp.append("   </tr>");
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >3.2.1 ��֤�˴�ҵ�����ȣ�");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='20' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");

	sTemp.append("   <tr>"); 
	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >3.2.2 ���˼���ͬ�����ˣ�����ż�����������");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >���˹���������ϼ�(Ԫ)��<u>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:10%; height:25'",getUnitData("describe18",sData)));
	sTemp.append("</u>&nbsp;&nbsp;����������(Ԫ)��<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:10%; height:25'",getUnitData("describe2",sData)));
	sTemp.append("</u>�ϼ�������(Ԫ)��<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:10%; height:25'",getUnitData("describe3",sData)));
	sTemp.append("</u>   </td>");
	sTemp.append("   <tr>"); 
    
	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >��ͬ�����˹���������ϼ�(Ԫ)��<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:10%; height:25'",getUnitData("describe4",sData)));
	sTemp.append("</u>&nbsp;&nbsp;&nbsp;&nbsp;����������(Ԫ)��<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:10%; height:25'",getUnitData("describe5",sData)));
	sTemp.append("</u>�ϼ�������(Ԫ)��<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:10%; height:25'",getUnitData("describe6",sData)));
	sTemp.append("</u>   </td>");
	sTemp.append("   <tr>"); 

	sTemp.append("   <tr>"); 
	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >3.2.3 ����ѯ�����������ϣ������ˡ���ͬ�����ˡ�����������������£�");
    sTemp.append("   </tr>");

	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >��1�� ");
  	sTemp.append(myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"�޲������ü�¼"));
  	sTemp.append(myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"���������"));
//	if(otherdk==0)
//	{
//		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;���������&nbsp;&nbsp;&nbsp;&nbsp;");
//	}
//	else
//	{
//		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;���������&nbsp;&nbsp;&nbsp;&nbsp;");
//	}
  	sTemp.append(myOutPutCheck("4",sMethod,"name='describe9'",getUnitData("describe9",sData),"�ڸ�������ϵͳ���޼�¼"));  	
	sTemp.append("   </td>");
	sTemp.append("   <tr>"); 
//	if(otherdk==0)
//	{
//		sTemp.append("   <tr>");
//		sTemp.append(" 	 <td colspan=20 height='34' class=td1 >");
//		sTemp.append(" 	 ��2��");
//		sTemp.append("���������");
//		sTemp.append("</td>");
//		sTemp.append("   </tr>");
//	}
//	else
//	{
		sTemp.append("   <tr>");
		sTemp.append(" 	 <td colspan=20 height='34' class=td1 >");
		sTemp.append(" 	 ��2��&nbsp;");
		sTemp.append(myOutPutCheck("4",sMethod,"name='describe10'",getUnitData("describe10",sData),"���������"));
		sTemp.append("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
	  	sTemp.append("   �ϼƣ�<u>");
	  	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:5%; height:25'",getUnitData("describe11",sData)));
		sTemp.append("</u>��&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
	  	sTemp.append("   �ϼ��»��<u>");
		sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:15%; height:25'",getUnitData("describe12",sData)));
		sTemp.append("</u>      Ԫ&nbsp;</td>");
		sTemp.append("   </tr>");
//	}
    

	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >��3��&nbsp; ");
  	sTemp.append("�ϼ��»���ռ�ϼ������������<u>"); 
  	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:10%; height:25'",getUnitData("describe13",sData)));
	sTemp.append("</u>%   </td>");
	sTemp.append("   <tr>"); 
	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=20 height='34'class=td1 >");
	sTemp.append(" 	 ��4��&nbsp;");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe19'",getUnitData("describe19",sData),"�н������"));
  	sTemp.append("   ���ڽ��ϼƣ�&nbsp;<u>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:5%; height:25'",getUnitData("describe20",sData)));
	sTemp.append("</u>      Ԫ&nbsp;</td>");
 	sTemp.append("   </tr>");
	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >��5�� ");
  	sTemp.append("&nbsp"); 
  	sTemp.append("��֤�����ű������÷�����<u>"); 
  	sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:5%; height:25'",getUnitData("describe21",sData)));
  	sTemp.append("</u>��  </td>");
	sTemp.append("   <tr>"); 

		sTemp.append("   <tr>"); 
	  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >3.2.4 ");
	  	sTemp.append("��������ס�����&nbsp&nbsp&nbsp"); 
	  	sTemp.append(myOutPutCheck("4",sMethod,"name='describe14'",getUnitData("describe14",sData),"���в�Ȩ"));
	  	sTemp.append(myOutPutCheck("4",sMethod,"name='describe15'",getUnitData("describe15",sData),"����"));
	  	sTemp.append(myOutPutCheck("4",sMethod,"name='describe16'",getUnitData("describe16",sData),"����"));  	
		sTemp.append("   </td>");
		sTemp.append("   <tr>"); 

  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >3.2.5 �����ʲ������");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='20' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe17' style='width:100%; height:150'",getUnitData("describe17",sData)));
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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu  2009.08.18
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
	
	//��ñ��
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,i=0;
	String sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '07__' and ObjectType = '"+sObjectType+"'";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(i=0;i<sNo.length;i++)
	{		
		sNo1[i] = "7."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(i=0;i<sNo.length;i++)
	{
		if(sNo[i].equals(sTreeNo.substring(0,4)))  break;
	}	
	
	sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	String sGuarangtorID = "";//�����ͻ�ID��
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();
	
	sSql = "select OccurOrg,BusinessType,getItemName('OtherBusinessType',BusinessType) as BusinessTypeName, "+
	              "Balance,BeginDate,Maturity,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,BusinessSum "+
	              "from CUSTOMER_OACTIVITY where CustomerID = '"+sGuarangtorID+"'and BusinessType ='02' and Balance >0";
	String sOccurOrg = "";
	String sBusinessType = "";
	String sBusinessTypeName = "";
	String sBalance  = "";
	String sBeginDate = "";
	String sMaturity = "";
	String sClassifyResult = "";
	String sBusinessSum = "";
	String sGuarantyTypeName = "";
		
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='070207.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=18 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > "+sNo1[i]+".7��������������δ����������� </font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=center class=td1 > ����  </td>");
    sTemp.append("   <td width=10% align=center class=td1 > Ʒ�� </td>");
    sTemp.append("   <td width=10% align=center class=td1 > ���Ŷ��(��Ԫ) </td>");
    sTemp.append("   <td width=11% align=center class=td1 > ���(��Ԫ) </td>");
    sTemp.append("   <td width=12% align=center class=td1 > ��ʼ�� </td>");
    sTemp.append("   <td width=12% align=center class=td1 > ������ </td>");
    sTemp.append("   <td width=15% align=center class=td1 > ������ʽ </td>");
    sTemp.append("   <td width=15% align=center class=td1 > �弶���� </td>");
	sTemp.append("   </tr>");

	 rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sOccurOrg = rs2.getString(1);
		if(sOccurOrg == null) sOccurOrg = " ";
		sBusinessType = rs2.getString(2);
		sBusinessTypeName = rs2.getString(3);
		if(sBusinessTypeName == null) sBusinessTypeName = " ";
		sBalance = DataConvert.toMoney(rs2.getDouble(4)/10000);
		sBeginDate = rs2.getString(5);
		if(sBeginDate == null) sBeginDate = " ";
		sMaturity = rs2.getString(6);
		if(sMaturity == null) sMaturity = " ";
		sClassifyResult = rs2.getString(7);
		if(sClassifyResult == null) sClassifyResult = " ";
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(8)/10000);
	//	sGuarantyTypeName = rs2.getString(9);
		//if(sGuarantyTypeName == null) sGuarantyTypeName = " ";
		
		if(sBusinessType.equals("020"))
		{
			sTemp.append("   <tr>");
		  	sTemp.append("   <td width=15%  align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
		    sTemp.append("   <td width=10% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		    sTemp.append("   <td width=10% align=center class=td1 >"+sBusinessSum+"&nbsp; </td>");
		    sTemp.append("   <td width=11% align=center class=td1 >"+sBalance+"&nbsp;</td>");
		    sTemp.append("   <td width=12% align=center class=td1 >"+sBeginDate+"&nbsp;</td>");
		    sTemp.append("   <td width=12% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
		    sTemp.append("   <td width=15% align=center class=td1 >"+sGuarantyTypeName+"/&nbsp;</td>");    
		    sTemp.append("   <td width=15% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
			sTemp.append("   </tr>");
		}
		else
		{
			sTemp.append("   <tr>");
		  	sTemp.append("   <td width=15% align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
		    sTemp.append("   <td width=10% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		    sTemp.append("   <td width=10% align=center class=td1 >"+sBusinessSum+"&nbsp; </td>");
		    sTemp.append("   <td width=11% align=center class=td1 >"+sBalance+"&nbsp;</td>");
		    sTemp.append("   <td width=12% align=center class=td1 >"+sBeginDate+"&nbsp;</td>");
		    sTemp.append("   <td width=12% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
		    sTemp.append("   <td width=15% align=center class=td1 >"+sGuarantyTypeName+"/&nbsp;</td>");    
		    sTemp.append("   <td width=15% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
			sTemp.append("   </tr>");
		}
    }
    
    rs2.getStatement().close();	
    
	sSql = "select sum(BusinessSum),sum(Balance) "+
	              "from CUSTOMER_OACTIVITY where CustomerID = '"+sGuarangtorID+"'and BusinessType ='02' and Balance >0";
	rs2 = Sqlca.getResultSet(sSql);
	String sSum = "";
	String sSum1 = "" ;
	while(rs2.next())
	{
		sSum += DataConvert.toMoney(rs2.getDouble(1)/10000); 
		sSum1 += DataConvert.toMoney(rs2.getDouble(2)/10000);
	}	
	rs2.getStatement().close();
	sTemp.append("   <tr>");
	sTemp.append("   	<td colspan='2' align=center class=td1 > �ϼ�: </td>");
	sTemp.append("   	<td align=center class=td1 >"+sSum+"&nbsp</td>");
	sTemp.append("   	<td align=center class=td1 >"+sSum1+"&nbsp</td>");
	sTemp.append("   	<td colspan='4' align=left class=td1 >"+"/"+"&nbsp;</td>");
	sTemp.append("</tr>");
	    
   
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

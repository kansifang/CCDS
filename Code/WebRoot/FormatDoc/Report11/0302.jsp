<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bqliu 2011-04-29
		Tester:
		Content: ����ĵ�0ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   
				FirstSection: 
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//��õ��鱨������
	
	int k = 0;   
	String sRowSubject = "";		//������ 
	String sNewReportDate2 = "���������";		//������������
	String sYear="",sMonth="";	
	
	String [] ssyYearReportDate = {"������","������","������"};   //������걨����
	String [] ssyYearReportNo = {"0","0","0"};     			//������걨��
	
	
	String sNewReportNo2 = "";		//����������
	
	
	//���������±�
	double dsyValue = 0;
	String ssyValue[] = {"0","0","0","0","0"};
	String ssyProportion[] = {"0","0","0","0","0"};
	
	//�����һ��������걨
	String ssyValue1[] = {"0","0","0","0","0"};
	String ssyProportion1[] = {"0","0","0","0","0"};
	
	//����ڶ���������걨
	String ssyValue2[] = {"0","0","0","0","0"};
	String ssyProportion2[] = {"0","0","0","0","0"};
	
	//���������������걨
	String ssyValue3[] = {"0","0","0","0","0"};
	String ssyProportion3[] = {"0","0","0","0","0"};
	
	//*****************************************�����ṹ�ͶԱ�*****************************
	//ȡ���±�������
    String lastDate = Sqlca.getString("select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' ");
	
	//ȡ������������
	ASResultSet rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%2' and ReportScope = GETEVALUATESCOPE('"+sCustomerID+"',ReportDate)"+
	" and Reportdate ='"+lastDate+"'" );
	
	if(rs2.next())
	{
		sYear = rs2.getString("Year");	//����
		if(sYear == null) 
		{
			sNewReportDate2 = "���������";
		}
		else
		{
			sMonth = rs2.getString("Month");	//����
			sNewReportDate2 = sYear + " ��" +sMonth+" ��";
		}
		sNewReportNo2 = rs2.getString("ReportNo");	//���������
	}	
	rs2.getStatement().close();
	
	rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo2+"' And RowSubject in ('501','502','505','515','517')");
	while(rs2.next())
	{
		sRowSubject = rs2.getString("RowSubject");
		if (sRowSubject.equals("501"))		//��Ӫҵ������
		{
			ssyValue[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			dsyValue = rs2.getDouble("Col2value");
			ssyProportion[0] = "100";		
		}
		if( dsyValue == 0) continue;
		if (sRowSubject.equals("502"))	//��Ӫҵ��ɱ�
		{
			ssyValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);	
		}
		else if (sRowSubject.equals("505"))	//��Ӫҵ������
		{
			ssyValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
		else if (sRowSubject.equals("515"))	//�����ܶ�
		{
			ssyValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
		else if (sRowSubject.equals("517"))	//������
		{
			ssyValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
	}
	rs2.getStatement().close();
	
	//�걨
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%2'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
		" order by Year Desc"); 
	
	k = 2;
	while (k >= 0)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//����
			if(sYear == null) 
			{
				ssyYearReportDate[k] = "������";
			}
			else
			{
				ssyYearReportDate[k] = sYear + " ��";
			}
			ssyYearReportNo[k] = rs2.getString("ReportNo");	//�ʲ���ծ���걨��
		}
		k --;
	}
	rs2.getStatement().close();
	
	//��һ��
	if (!ssyYearReportDate[0].equals("������"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[0]+"' And RowSubject in ('501','502','505','515','517')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("501"))		//��Ӫҵ������
			{
				ssyValue1[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				dsyValue = rs2.getDouble("Col2value");
				ssyProportion1[0] = "100";		
			}
			if( dsyValue == 0) continue;
			if (sRowSubject.equals("502"))	//��Ӫҵ��ɱ�
			{
				ssyValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("505"))	//��Ӫҵ������
			{
				ssyValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("515"))	//�����ܶ�
			{
				ssyValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//������
			{
				ssyValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
		rs2.getStatement().close();
	}
	//�ڶ���	
	if (!ssyYearReportDate[1].equals("������"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[1]+"' And RowSubject in ('501','502','505','515','517')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("501"))		//��Ӫҵ������
			{
				ssyValue2[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				dsyValue = rs2.getDouble("Col2value");
				ssyProportion2[0] = "100";			
			}
			if( dsyValue == 0) continue;
			if (sRowSubject.equals("502"))	//��Ӫҵ��ɱ�
			{
				ssyValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("505"))	//��Ӫҵ������
			{
				ssyValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("515"))	//�����ܶ�
			{
				ssyValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//������
			{
				ssyValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
	    rs2.getStatement().close();
	}
            //������	
	if (!ssyYearReportDate[2].equals("������"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[2]+"' And RowSubject in ('501','502','505','515','517') order by RowSubject ");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("501"))		//��Ӫҵ������
			{
				ssyValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				dsyValue = rs2.getDouble("Col2value");
				ssyProportion3[0] = "100";
			}
			if( dsyValue == 0) continue;
			if (sRowSubject.equals("502"))	//��Ӫҵ��ɱ�
			{
				ssyValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("505"))	//��Ӫҵ������
			{
				ssyValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				ssyProportion3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);
			}
			else if (sRowSubject.equals("515"))	//�����ܶ�
			{
				ssyValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//������
			{
				ssyValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
		rs2.getStatement().close();
	}
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0302.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >2�������ṹ�ͶԱ�</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+ssyYearReportDate[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyYearReportDate[1]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+ssyYearReportDate[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sNewReportDate2+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��Ŀ&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��Ӫҵ������&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[0]+"</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[0]+"</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[0]+"</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[0]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��Ӫҵ��ɱ�&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[1]+"</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[1]+"</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[1]+"</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[1]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��Ӫҵ������&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[2]+"</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[2]+"</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[2]+"</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[2]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >�����ܶ�&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[3]+"</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[3]+"</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[3]+"</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[3]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >������&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[4]+"</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[4]+"</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[4]+"</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[4]+"&nbsp;</td>");
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


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
	double dValue = 0;//Ӧ���ܶ�
	double Unit=10000;//����λ��,Ĭ��Ϊ��Ԫ
	
	double d010 = 0.0;//Ӧ���˿��ܶ�
	String[] sysValue = {"0","0","0","0"};
	String[] sProportion = {"0","0","0","0"};
	double d015 = 0.0;//����Ӧ�տ��ܶ�
	String[] sysValue1 = {"0","0","0","0"};
	String[] sProportion1 = {"0","0","0","0"};
	String sReportDate = "";  	 //�ʲ���ծ���걨����
	String sYear = "xx";
	String sMonth = "xx";
	String sNewReportDate3 = "";
	
	ASResultSet rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportDate from CUSTOMER_FSRECORD "+
			" where CustomerID ='"+sCustomerID+"' "+
			//" and ReportPeriod='04' and AuditFlag in ('2','3')"+
			" order by ReportDate Desc");  
	
	if(rs2.next())
	{
		sYear = rs2.getString("Year");	//����
		if(sYear == null) 
		{
			sNewReportDate3 = "���������";
		}
		else
		{
			sMonth = rs2.getString("Month");	//����
			sNewReportDate3 = sYear + " ��"+sMonth+" ��";
		}
		sReportDate = rs2.getString("ReportDate");
	}
	rs2.getStatement().close();
    
    
	//���Ӧ���ܶ�
	rs2 = Sqlca.getResultSet("select sum(FOASum) from ENT_FOA where FOAType in ('01','02') and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'");
	if(rs2.next())
	{
		dValue = rs2.getDouble(1)/Unit;
	}
	rs2.getStatement().close();
	
	if(dValue >0 )
	{
	String sAccountYears = "";
	//Ӧ���˿����(Ӧ���˿��ܶ�)
	String sSql1="select sum(FOASum) from ENT_FOA" 
		         +" where FOAType='01'"
		         +" and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
	rs2 = Sqlca.getResultSet(sSql1);
	if(rs2.next())
	{
		d010 = rs2.getDouble(1)/Unit;
		sysValue[3] = DataConvert.toMoney(d010);
		sProportion[3] = DataConvert.toMoney(d010/dValue*100);
	}
	rs2.getStatement().close();   
	     
	String sSql2="select AccountYears,sum(FOASum) from ENT_FOA" 
		         +" where FOAType='01'"
		         +" and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'" 
		         +" group by AccountYears";
	if(d010>0)
	{
		rs2 = Sqlca.getResultSet(sSql2);
		while(rs2.next()) 
		{
			sAccountYears = rs2.getString(1);
			double dysValue = 0.0;
			if(sAccountYears.equals("01"))
			{
				sysValue[0] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion[0] = DataConvert.toMoney(dysValue/d010*100);
			}
			else if(sAccountYears.equals("02"))
			{
				sysValue[1] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion[1] = DataConvert.toMoney(dysValue/d010*100);
			}
			else if(sAccountYears.equals("03"))
			{
				sysValue[2] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion[2] = DataConvert.toMoney(dysValue/d010*100);
			}
		}
		rs2.getStatement().close();
	}
	
	//Ӧ���˿����(����Ӧ�տ�)
	String sSql3="select sum(FOASum) from ENT_FOA" 
		         +" where FOAType='02'"
		         +" and CustomerID = '"+sCustomerID+"'";  
	rs2 = Sqlca.getResultSet(sSql3);
	if(rs2.next())
	{
		d015 = rs2.getDouble(1)/Unit;
		sysValue1[3] = DataConvert.toMoney(d015);
		sProportion1[3] = DataConvert.toMoney(d015/dValue*100);
	}
	rs2.getStatement().close(); 
	
	String sSql4="select AccountYears,sum(FOASum) from ENT_FOA" 
		         +" where FOAType='02'"
		         +" and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'"  
		         +" group by AccountYears";
	if(d015>0)
	{         
		rs2 = Sqlca.getResultSet(sSql4);
		while(rs2.next())
		{
			sAccountYears = rs2.getString(1);
			double dysValue = 0.0;
			if(sAccountYears.equals("01"))
			{
				sysValue1[0] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion1[0] = DataConvert.toMoney(dysValue/d015*100);
			}
			else if(sAccountYears.equals("02"))
			{
				sysValue1[1] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion1[1] = DataConvert.toMoney(dysValue/d015*100);
			}
			else if(sAccountYears.equals("03"))
			{
				sysValue1[2] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion1[2] = DataConvert.toMoney(dysValue/d015*100);
			}
		}
		rs2.getStatement().close();
	}
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0304.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=9 ><font style=' font-size: 15pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >4��Ӧ�տ������("+sNewReportDate3+")</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >�������&nbsp;</td>");
    sTemp.append(" <td colspan=2 align=center class=td1 >1�꣨��������&nbsp;</td>");
  	sTemp.append(" <td colspan=2 align=center class=td1 >1-2�꣨����&nbsp;</td>");
    sTemp.append(" <td colspan=2 align=center class=td1 >2������&nbsp;</td>");
  	sTemp.append(" <td colspan=2 align=center class=td1 >�ϼ�&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >&nbsp;</td>");
    sTemp.append(" <td width=15% align=center class=td1 >����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=5% align=center class=td1 >%&nbsp;</td>");
  	sTemp.append(" <td width=15% align=center class=td1 >����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=5% align=center class=td1 >%&nbsp;</td>");
  	sTemp.append(" <td width=15% align=center class=td1 >����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=5% align=center class=td1 >%&nbsp;</td>");
  	sTemp.append(" <td width=15% align=center class=td1 >����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=5% align=center class=td1 >%&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <td align=center class=td1 > Ӧ���˿�</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue[0]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sProportion[0]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue[1]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sProportion[1]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue[2]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sProportion[2]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue[3]+"</td>");
	sTemp.append("	 <td align=center class=td1 >"+sProportion[3]+"</td>");
    sTemp.append("  </tr>");
   	
	sTemp.append("  <tr>");
	sTemp.append("   <td  align=center class=td1 > ����Ӧ�տ�</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue1[0]+"</td>");
    sTemp.append("   <td  align=center class=td1 >"+sProportion1[0]+"</td>");
    sTemp.append("   <td  align=center class=td1 >"+sysValue1[1]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sProportion1[1]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue1[2]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sProportion1[2]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue1[3]+"</td>");
	sTemp.append("	 <td align=center class=td1 >"+sProportion1[3]+"</td>");
    sTemp.append("  </tr>");
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


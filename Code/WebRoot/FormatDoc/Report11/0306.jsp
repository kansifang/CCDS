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
	double Unit = 10000;//����λ��,Ĭ��Ϊ��Ԫ
	String sReportDate = "";  	 //�ʲ���ծ���걨����
	String sYear = "xx";
	String sMonth = "xx";
	String sNewReportDate3 = "";
	
	ASResultSet rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportDate from CUSTOMER_FSRECORD "+
			" where CustomerID ='"+sCustomerID+"' "+
			//"  and ReportPeriod='04' and AuditFlag in ('2','3')"+
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
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0306.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=4 ><font style=' font-size: 15pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >6���̶��ʲ��������ʲ�����("+sNewReportDate3+")</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=30% align=center class=td1 >Ʒ��&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >%&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >�Ƿ��Ѻ&nbsp;</td>");
    sTemp.append(" </tr>");
    
    String sSql121 = "select sum(EvalValue) from ENT_FIXEDASSETS where FixedAssetsType in ('01','02','03','04') and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
    rs2 = Sqlca.getResultSet(sSql121);
    double sum = 0.0;
	if(rs2.next())
		sum = rs2.getDouble(1)/Unit;
	rs2.getStatement().close();
	
	String sSql12 = "select EvalValue,getItemName('DepreciationWay',Depreciation) as Depreciation,Rate,getItemName('ImpawnStatus',ImpawnStatus) as ImpawnStatus from ENT_FIXEDASSETS where FixedAssetsType = '01' and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
	rs2 = Sqlca.getResultSet(sSql12);
	String sEvalValue = "";				//�̶��ʲ����(��Ԫ)
    String sImpawnStatus = "";//�Ƿ��Ѻ
    
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    String sProportions="0.0";//ռ��
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
	    sImpawnStatus = rs2.getString("ImpawnStatus");
		sTemp.append("  <tr>");
		sTemp.append("   <td align=center class=td1 >���ݽ�����</td>");
	    sTemp.append("   <td align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sImpawnStatus+"&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td align=center class=td1 >���ݽ�����</td>");
	    sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
	//�����豸
	String sSql13 = "select EvalValue,getItemName('DepreciationWay',Depreciation) as Depreciation,Rate,getItemName('ImpawnStatus',ImpawnStatus)  as ImpawnStatus from ENT_FIXEDASSETS where FixedAssetsType = '02' and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
	rs2 = Sqlca.getResultSet(sSql13);
	sEvalValue = "";
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    String sProportions="0.0";//ռ��
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
	    sImpawnStatus = rs2.getString("ImpawnStatus");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >�����豸</td>");
	    sTemp.append("   <td align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sImpawnStatus+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td align=center class=td1 >�����豸</td>");
	    sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
	//���乤��
	String sSql14 = "select EvalValue,getItemName('DepreciationWay',Depreciation) as Depreciation,Rate,getItemName('ImpawnStatus',ImpawnStatus) as ImpawnStatus  from ENT_FIXEDASSETS where FixedAssetsType = '03' and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
	rs2 = Sqlca.getResultSet(sSql14);
	sEvalValue = "";
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    String sProportions="0.0";//ռ��
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
	    sImpawnStatus = rs2.getString("ImpawnStatus");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >���乤��</td>");
	    sTemp.append("   <td align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td  align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sImpawnStatus+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td align=center class=td1 >���乤��</td>");
	    sTemp.append("   <td  align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td  align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
    //����
	sTemp.append("  <tr>");
	sTemp.append("   <td align=center class=td1 >����</td>");
    sTemp.append("   <td  align=center class=td1 >0.0&nbsp;</td>");
    sTemp.append("   <td  align=center class=td1 >0.0&nbsp;</td>");
    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
	sTemp.append("  </tr>");
	
	//����
	String sSql16 = "select EvalValue,getItemName('DepreciationWay',Depreciation) as Depreciation,Rate,getItemName('ImpawnStatus',ImpawnStatus) as ImpawnStatus  from ENT_FIXEDASSETS where FixedAssetsType = '04' and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
	rs2 = Sqlca.getResultSet(sSql16);
	sEvalValue = "";
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    String sProportions="0.0";//ռ��
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
	    sImpawnStatus = rs2.getString("ImpawnStatus");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >����</td>");
	    sTemp.append("   <td  align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sImpawnStatus+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td  align=center class=td1 >����</td>");
	    sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td  align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
	//�ϼ�
	sTemp.append("  <tr>");
	sTemp.append("   <td  align=center class=td1 > �ϼ� </td>");
    sTemp.append("   <td  align=center class=td1 >"+DataConvert.toMoney(sum)+"&nbsp;</td>");
    sTemp.append("   <td  align=center class=td1 >&nbsp;</td>");
    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
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


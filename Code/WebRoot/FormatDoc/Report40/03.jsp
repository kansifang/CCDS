<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.21
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
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	int k = 0;
	int iMoneyUnit = 100000000;
	String sYearN = "���������";
	String sYear="",sMonth="";	
	String sYearNSerialNo = "";
	String sYearSerialNo[] = {"",""};
	String sYearReportDate[]  = {"���������","���������","���������"};
	String sValue[] = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String sValue1[] = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String sValue2[] = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
    
    ASResultSet rs = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,SerialNo "+
					" from CUSTOMER_FSRATION "+
					" where CustomerID ='"+sCustomerID+"'"+
					" And  ReportDate = (select max(ReportDate) as MaxReportDate from CUSTOMER_FSRATION where CustomerID = '"+sCustomerID+"')");	
	if(rs.next())
	{
		sYear = rs.getString("Year");	//����
		if(sYear == null) 
		{
			sYearN = "���������";
		}
		else
		{
			sMonth = rs.getString("Month");	//����
			sYearN = sYear + "��" +sMonth+"��";
		}
		sYearNSerialNo = rs.getString("SerialNo");	//����ʲ���ծ���
		sYearReportDate[0] = rs.getString("ReportDate");
	}	
	rs.getStatement().close();	
				
	if(!sYearN.equals("���������")){
		rs = Sqlca.getResultSet(" select TotalAsset,OwnEquities,TotalDeposit,TotalLoan,Taking,RetProfit,CapitalFullRate,CoreCapitalRate,"+
								 " OneLoanRate,TenLoanRate,BadLoanRate,DepositLoanRate,LiquidityRate,AssetIncomeRate,RetIncomeRate "+
								 " from CUSTOMER_FSRATION where SerialNo='"+sYearNSerialNo+"'");
		if(rs.next()){
			sValue[0] = DataConvert.toMoney(rs.getDouble("TotalAsset")/iMoneyUnit);          //���ʲ�
			sValue[1] = DataConvert.toMoney(rs.getDouble("OwnEquities")/iMoneyUnit);  		//������Ȩ��
			sValue[2] = DataConvert.toMoney(rs.getDouble("TotalDeposit")/iMoneyUnit); 		//����ܶ�
			sValue[3] = DataConvert.toMoney(rs.getDouble("TotalLoan")/iMoneyUnit);    		//�����ܶ�
			sValue[4] = DataConvert.toMoney(rs.getDouble("Taking")/iMoneyUnit);       		//Ӫҵ����
			sValue[5] = DataConvert.toMoney(rs.getDouble("RetProfit")/iMoneyUnit);			//������
			sValue[6] = DataConvert.toMoney(rs.getDouble("CapitalFullRate"));		//�ʱ�������
			sValue[7] = DataConvert.toMoney(rs.getDouble("CoreCapitalRate"));		//�����ʱ�������
			sValue[8] = DataConvert.toMoney(rs.getDouble("OneLoanRate"));			//��һ�ͻ��������
			sValue[9] = DataConvert.toMoney(rs.getDouble("TenLoanRate"));			//ʮ��ͻ��������
			sValue[10] = DataConvert.toMoney(rs.getDouble("BadLoanRate"));		//��������
			sValue[11] = DataConvert.toMoney(rs.getDouble("DepositLoanRate"));	//�����
			sValue[12] = DataConvert.toMoney(rs.getDouble("LiquidityRate"));		//�����Ա���
			sValue[13] = DataConvert.toMoney(rs.getDouble("AssetIncomeRate"));	//�ʲ�������
			sValue[14] = DataConvert.toMoney(rs.getDouble("RetIncomeRate"));		//���ʲ�������																					
		}	
		rs.getStatement().close();					 
	}
	if("".equals(sYear))
	{
		sYear = StringFunction.getToday().substring(1,4);
	}
	String sYearN_1 = String.valueOf(Integer.parseInt(sYear) - 1)+"/12";
	String sYearN_2 = String.valueOf(Integer.parseInt(sYear) - 2)+"/12";
	rs = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,SerialNo from CUSTOMER_FSRATION "+
	" where CustomerID ='"+sCustomerID+"'"+
	" and  ReportDate in('"+sYearN_1+"','"+sYearN_2+"')"+
	" order by Year Desc");
	k = 0;
	while (k < 2)
	{
		if(rs.next())
		{
			sYear = rs.getString("Year");	//����
			if(sYear == null) 
			{
				sYearReportDate[k] = "������";
			}
			else
			{
				sMonth = rs.getString("Month");	//����
				sYearReportDate[k+1] = sYear + "��"+sMonth+"��";;
				sYearSerialNo[k] = rs.getString("SerialNo");	
				sYearReportDate[k+1] = rs.getString("ReportDate");
			}
		}
		k ++;
	}
	rs.getStatement().close();  

	if(!sYearReportDate[1].equals("�����������")){
		rs = Sqlca.getResultSet(" select TotalAsset,OwnEquities,TotalDeposit,TotalLoan,Taking,RetProfit,CapitalFullRate,CoreCapitalRate,"+
								 " OneLoanRate,TenLoanRate,BadLoanRate,DepositLoanRate,LiquidityRate,AssetIncomeRate,RetIncomeRate"+
								 " from CUSTOMER_FSRATION where SerialNo='"+sYearSerialNo[0]+"'");
		if(rs.next()){
			sValue1[0] = DataConvert.toMoney(rs.getDouble("TotalAsset")/iMoneyUnit);          //���ʲ�
			sValue1[1] = DataConvert.toMoney(rs.getDouble("OwnEquities")/iMoneyUnit);  		//������Ȩ��
			sValue1[2] = DataConvert.toMoney(rs.getDouble("TotalDeposit")/iMoneyUnit); 		//����ܶ�
			sValue1[3] = DataConvert.toMoney(rs.getDouble("TotalLoan")/iMoneyUnit);    		//�����ܶ�
			sValue1[4] = DataConvert.toMoney(rs.getDouble("Taking")/iMoneyUnit);       		//Ӫҵ����
			sValue1[5] = DataConvert.toMoney(rs.getDouble("RetProfit")/iMoneyUnit);			//������
			sValue1[6] = DataConvert.toMoney(rs.getDouble("CapitalFullRate"));		//�ʱ�������
			sValue1[7] = DataConvert.toMoney(rs.getDouble("CoreCapitalRate"));		//�����ʱ�������
			sValue1[8] = DataConvert.toMoney(rs.getDouble("OneLoanRate"));			//��һ�ͻ��������
			sValue1[9] = DataConvert.toMoney(rs.getDouble("TenLoanRate"));			//ʮ��ͻ��������
			sValue1[10] = DataConvert.toMoney(rs.getDouble("BadLoanRate"));		//��������
			sValue1[11] = DataConvert.toMoney(rs.getDouble("DepositLoanRate"));	//�����
			sValue1[12] = DataConvert.toMoney(rs.getDouble("LiquidityRate"));		//�����Ա���
			sValue1[13] = DataConvert.toMoney(rs.getDouble("AssetIncomeRate"));	//�ʲ�������
			sValue1[14] = DataConvert.toMoney(rs.getDouble("RetIncomeRate"));		//���ʲ�������																			
		}	
		rs.getStatement().close();				
	}
	
	if(!sYearReportDate[2].equals("�����������")){
		rs = Sqlca.getResultSet(" select TotalAsset,OwnEquities,TotalDeposit,TotalLoan,Taking,RetProfit,CapitalFullRate,CoreCapitalRate,"+
								 " OneLoanRate,TenLoanRate,BadLoanRate,DepositLoanRate,LiquidityRate,AssetIncomeRate,RetIncomeRate"+
								 " from CUSTOMER_FSRATION where SerialNo='"+sYearSerialNo[1]+"'");
		if(rs.next()){
			sValue2[0] = DataConvert.toMoney(rs.getDouble("TotalAsset")/iMoneyUnit);          //���ʲ�
			sValue2[1] = DataConvert.toMoney(rs.getDouble("OwnEquities")/iMoneyUnit);  		//������Ȩ��
			sValue2[2] = DataConvert.toMoney(rs.getDouble("TotalDeposit")/iMoneyUnit); 		//����ܶ�
			sValue2[3] = DataConvert.toMoney(rs.getDouble("TotalLoan")/iMoneyUnit);    		//�����ܶ�
			sValue2[4] = DataConvert.toMoney(rs.getDouble("Taking")/iMoneyUnit);       		//Ӫҵ����
			sValue2[5] = DataConvert.toMoney(rs.getDouble("RetProfit")/iMoneyUnit);			//������
			sValue2[6] = DataConvert.toMoney(rs.getDouble("CapitalFullRate"));		//�ʱ�������
			sValue2[7] = DataConvert.toMoney(rs.getDouble("CoreCapitalRate"));		//�����ʱ�������
			sValue2[8] = DataConvert.toMoney(rs.getDouble("OneLoanRate"));			//��һ�ͻ��������
			sValue2[9] = DataConvert.toMoney(rs.getDouble("TenLoanRate"));			//ʮ��ͻ��������
			sValue2[10] = DataConvert.toMoney(rs.getDouble("BadLoanRate"));		//��������
			sValue2[11] = DataConvert.toMoney(rs.getDouble("DepositLoanRate"));	//�����
			sValue2[12] = DataConvert.toMoney(rs.getDouble("LiquidityRate"));		//�����Ա���
			sValue2[13] = DataConvert.toMoney(rs.getDouble("AssetIncomeRate"));	//�ʲ�������
			sValue2[14] = DataConvert.toMoney(rs.getDouble("RetIncomeRate"));		//���ʲ�������																					
		}	
		rs.getStatement().close();		
	}		
%>
 
 
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��������Ҫ�������ݣ���λ����Ԫ��%��</font></td>"); 	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 >"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sYearReportDate[2]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sYearReportDate[1]+"&nbsp;</td>");
     sTemp.append("  <td width=25% align=left class=td1 > "+sYearReportDate[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > ���ʲ�"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[0]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[0]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > ������Ȩ��"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[1]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[1]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[1]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > ����ܶ�"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[2]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[2]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > �����ܶ�"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[3]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[3]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[3]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > Ӫҵ����"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[4]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[4]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[4]+"&nbsp;</td>");
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > ������"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[5]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[5]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[5]+"&nbsp;</td>");
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > �ʱ�������(��8%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[6]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[6]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[6]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > �����ʱ�������(��4%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[7]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[7]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[7]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > ��һ�ͻ�������ʣ���10%��"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[8]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[8]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[8]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > ʮ��ͻ��������(��50%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[9]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[9]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[9]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > ��������(��4%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[10]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[10]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[10]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > �����(��75%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[11]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[11]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[11]+"&nbsp;</td>");
	sTemp.append("   </tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > �����Ա���(��25%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[12]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[12]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[12]+"&nbsp;</td>");
	sTemp.append("   </tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > �ʲ�������(��0.6%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[13]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[13]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[13]+"&nbsp;</td>");
	sTemp.append("   </tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > ���ʲ�������(��11%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[14]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[14]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[14]+"&nbsp;</td>");
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
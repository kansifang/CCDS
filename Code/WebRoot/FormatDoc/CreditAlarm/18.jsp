<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
	/*
		Author:   pliu  2011.09.13
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
	int iDescribeCount = 9;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>
<% 
    //���水ť,Ԥ����ť�ɼ���ʶ
    String sViewOnly = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewOnly"));
    String sViewPrint = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewPrint"));
    if(sViewOnly == null) sViewOnly = "";
    if(sViewPrint == null) sViewPrint = "";
    if("true".equals(sViewOnly))
    {
    	sButtons[1][0] = "true";
    	sButtons[0][0] = "false";
    }
    else
    {
    	sButtons[1][0] = "true";
    	sButtons[0][0] = "true";
    	sButtons[1][0] = "true";

    }


    String sCustomerName = "";//�ͻ�����
    String ssObjectNo = "";//
    String sLoanCardNo = "";//�����
    String sSignalLevel = "";//Ԥ������
    String sOrgName = "";//Ԥ�����沿��
    String sAlarmApplyDate = "";//Ԥ����������
    String sApproveDate = "";//Ԥ����׼����
    String sCustomerOpenBalance = "";//��׼���
    String sCreditLevel = "";//�ͻ����õȼ�
    String sCustomerType = "";//�ͻ�����
    String sName = "";//��˾�����
    String sSql = " select objectNo,getCustomerName(ObjectNo) as CustomerName,"+
                  " getItemName('SignalLevel',RISK_SIGNAL.SignalLevel) as SignalLevel,"+
                  " GetOrgName(InputOrgID) as InputOrgName,"+
                  " AlarmApplyDate,ApproveDate,CustomerOpenBalance,CreditLevel"+
	              " from RISK_SIGNAL where serialno = '"+sObjectNo+"'";
    ASResultSet rs=Sqlca.getResultSet(sSql);
    if(rs.next()){
	  ssObjectNo = rs.getString("objectNo");
	  sCustomerName = rs.getString("CustomerName");
	  sSignalLevel = rs.getString("SignalLevel");
	  sOrgName = rs.getString("InputOrgName");
	  sAlarmApplyDate = rs.getString("AlarmApplyDate");
	  sApproveDate = rs.getString("ApproveDate");
	  sCustomerOpenBalance = rs.getString("CustomerOpenBalance");
	  sCreditLevel = rs.getString("CreditLevel");
   }
    rs.getStatement().close();
    
    if(sCustomerName == null)sCustomerName = "";
    if(sSignalLevel == null)sSignalLevel = "";
    if(sOrgName == null)sOrgName = "";
    if(sAlarmApplyDate == null)sAlarmApplyDate = "";
    if(sApproveDate == null)sApproveDate = "";
    if(sCustomerOpenBalance == null)sCustomerOpenBalance = "";
    if(sCreditLevel == null)sCreditLevel = "";
    
	//��ȡ�ͻ�����
	sSql = " select CustomerType from CUSTOMER_INFO where CustomerID = '"+ssObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerType = DataConvert.toString(rs.getString("CustomerType"));
		if(sCustomerType == null) sCustomerType = "";		
	}
	rs.getStatement().close();
	
    //��ѯ����Ż����֤��
    if(sCustomerType.substring(0,2).equals("01")){
     sName = "��ҵ";
     sSql =  " select LoanCardNo"+
             " from CUSTOMER_INFO"+
             " where customerid ='"+ssObjectNo+"'";
    rs=Sqlca.getResultSet(sSql);
    if(rs.next()){
	    sLoanCardNo = rs.getString("LoanCardNo");
	    if(sLoanCardNo == null) sLoanCardNo = "";
    }
    rs.getStatement().close();
	}else if(sCustomerType.substring(0,2).equals("03")){
		sName = "����";
	    sSql =  " select Certid"+
                " from CUSTOMER_INFO"+
                " where customerid ='"+ssObjectNo+"'";
        rs=Sqlca.getResultSet(sSql);
        if(rs.next()){
        sLoanCardNo = rs.getString("Certid");
        if(sLoanCardNo == null) sLoanCardNo = "";
    }
    rs.getStatement().close();
	}

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='18.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=10  ><br><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:white' >���ũ���������ŷ���Ԥ�����ñ���</font><br><br></td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >&nbsp;");
	sTemp.append("   <br>���ͻ���:�����£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����ڣ�&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��<br><br>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa><strong>"+sName+"�ſ�</strong> </td>");
    sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >�ͻ����� </td>");
    sTemp.append("   <td colspan=8 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3.5 align=left class=td1 >�����(������Ϊ���֤��)</td>");
	sTemp.append("   <td colspan=6.5 align=left class=td1 >"+sLoanCardNo+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >Ԥ������</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >"+sSignalLevel+"&nbsp;</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >Ԥ�����沿��</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >"+sOrgName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >Ԥ����������</td>");
	sTemp.append("   <td colspan=2.5 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' ",getUnitData("describe1",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >������׼����</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' ",getUnitData("describe2",sData))+"&nbsp;</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >��׼���</td>");
	sTemp.append("   <td colspan=1.5 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' ",DataConvert.toMoney(getUnitData("describe3",sData)))+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >�ͻ����õȼ�</td>");
	sTemp.append("   <td colspan=2.5 align=left class=td1 >"+sCreditLevel+"&nbsp;</td>");
    sTemp.append("   </tr>");

    

	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa><strong>����ҵ��ſ�</strong> </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=5% class=td1 >���</td>");
	sTemp.append("   <td width=15% class=td1 >�����˺�</td>");
	sTemp.append("   <td width=10% class=td1 >���Ų�Ʒ����</td>");
	sTemp.append("   <td width=15% class=td1 >��ݽ��</td>");
	sTemp.append("   <td width=15% class=td1 >���</td>");
	sTemp.append("   <td width=15% class=td1 >������</td>");	
	sTemp.append("   <td width=15% class=td1 >������</td>");
	sTemp.append("   <td width=10% class=td1 >���շ�����̬</td>");	
    sTemp.append("   </tr>");


	
	

    String sBillNo = "";
    String sBusinessType = "";
    Double sBusinessSum =0.0;
    Double sBalance = 0.0;
    String sPutOutDate = "";
    String sMaturity = "";
    String sClassifyresult = "";
    //����ҵ��ſ���ѯ
     sSql = " select SerialNo,getBusinessName(BusinessType)as businessname,businesssum,balance,putoutdate,maturity,getItemname('ClassifyResult',Classifyresult) as ClassifyresultName "+		  
		    " from BUSINESS_DUEBILL where Customerid = '"+ssObjectNo+"' and balance>0 and (finishdate is null or finishdate = '')";
    rs = Sqlca.getResultSet(sSql);
 
    int count = 1;
    Double calbusinesssum = 0.0,calbalance = 0.0;
    while(rs.next()){
    	sBillNo = rs.getString("SerialNo");
    	sBusinessType = rs.getString("businessname");
    	sBusinessSum = rs.getDouble("BusinessSum");
    	sBalance = rs.getDouble("Balance");
    	sPutOutDate = rs.getString("PutOutDate");
    	sMaturity = rs.getString("Maturity");
    	sClassifyresult = rs.getString("ClassifyresultName");
        //}
        if(sBillNo == null) sBillNo = "";
        if(sBusinessType == null) sBusinessType = "";
        if(sBusinessSum == null) sBusinessSum = 0.0;
        if(sBalance == null) sBalance = 0.0;
        if(sPutOutDate == null) sPutOutDate = "";
        if(sMaturity == null) sMaturity = "";
        if(sClassifyresult == null) sClassifyresult = "";
    	sTemp.append("   <tr>");
    	sTemp.append("   <td width=5% class=td1 >"+count+"&nbsp;</td>");
    	sTemp.append("   <td width=15% class=td1 >"+sBillNo+"&nbsp;</td>");
    	sTemp.append("   <td width=10% class=td1 >"+sBusinessType+"&nbsp;</td>");
    	sTemp.append("   <td width=15% class=td1 >"+DataConvert.toMoney(sBusinessSum)+"&nbsp;</td>");
    	sTemp.append("   <td width=15% class=td1 >"+DataConvert.toMoney(sBalance)+"&nbsp;</td>");
    	sTemp.append("   <td width=15% class=td1 >"+sPutOutDate+"&nbsp;</td>");	
    	sTemp.append("   <td width=15% class=td1 >"+sMaturity+"&nbsp;</td>");
    	sTemp.append("   <td width=10% class=td1 >"+sClassifyresult+"&nbsp;</td>");		
        sTemp.append("   </tr>"); 
        count++;
        calbusinesssum += sBusinessSum;
        calbalance += sBalance;
        //rrs.getStatement().close();
    }

    
    rs.getStatement().close();

   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >�ϼ�");
	sTemp.append("   </td>");
	sTemp.append("   <td colspan=2 class=td1 >"+""+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+DataConvert.toMoney(calbusinesssum)+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+DataConvert.toMoney(calbalance)+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���ճ���");
	sTemp.append("   </td>");
	sTemp.append("   <td colspan=4 class=td1 >"+DataConvert.toMoney(sCustomerOpenBalance)+"&nbsp;</td>");
    sTemp.append("   </tr>");
            
	    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>����Ԥ���źŵ���״");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>����Ԥ�����ô�ʩ��ʵʩЧ��");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:150'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
   	 
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>���ù���������������");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:150'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
   	 
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>��һ��ʵʩ�ƻ�");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:150'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>������Ҫ˵��������");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:150'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;");
	sTemp.append("   <br>");
	sTemp.append("   ���ǩ�֣�  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("  ������ǩ�֣�   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�");
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
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
	editor_generate('describe5');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe6');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe7');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe8');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe9');		//��Ҫhtml�༭,input��û��Ҫ

<%
	}
%>	
</script>

<%@ include file="/IncludeEnd.jsp"%>




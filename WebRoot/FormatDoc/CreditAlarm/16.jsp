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
	int iDescribeCount = 4;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>
<% 
    //���水ť,Ԥ����ť�ɼ���ʶ
    String sViewOnly = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewOnly"));
    String sViewPrint = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewPrint"));
    if(sViewOnly == null) sViewOnly = "";
    if(sViewPrint == null) sViewPrint = "";
    if("".equals(sViewOnly))
    {
    	sButtons[1][0] = "true";
    	sButtons[0][0] = "true";
    	sButtons[1][0] = "true";
    }
    else
    {
    	sButtons[1][0] = "true";
    	sButtons[0][0] = "false";

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
    String sMessageContent = "";//Ԥ��˵��
    String sSql = " select objectNo,getCustomerName(ObjectNo) as CustomerName,MessageContent,"+
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
	  sMessageContent = rs.getString("MessageContent");
	  
   }
    rs.getStatement().close();
    
    if(sCustomerName == null)sCustomerName = "";
    if(sSignalLevel == null)sSignalLevel = "";
    if(sOrgName == null)sOrgName = "";
    if(sAlarmApplyDate == null)sAlarmApplyDate = "";
    if(sApproveDate == null)sApproveDate = "";
    if(sCustomerOpenBalance == null)sCustomerOpenBalance = "";
    if(sCreditLevel == null)sCreditLevel = "";
    if(sMessageContent == null)sMessageContent = "";
    
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
	sTemp.append("	<form method='post' action='16.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���ũ���������ŷ���Ԥ������������</font></td>"); 	
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
	sTemp.append("   <td colspan=2 align=left class=td1 >������� </td>");
	sTemp.append("   <td colspan=8 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
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
	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>����Ԥ���ź�����");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");         
	sTemp.append("   <tr>");
	String sSignalName = "";
	String sSignalName1 = "";
	int cal = 1;
	//Ԥ���ź����ݲ�ѯ
		sSql =  " select CR.SignalName as SignalName"+
		        " from Customer_RiskSignal CR,Risk_Signal RS,RISKSIGNAL_RELATIVE RR"+
		        " where RR.ObjectNo = CR.SerialNo "+
		        " and RS.SerialNo=RR.SerialNo and RR.ObjectType='RiskSignal' "+
		        " and RS.SerialNo = '"+sObjectNo+"'";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next()){
		sSignalName = rs.getString("SignalName");
		sSignalName1 += cal+ "."+sSignalName+"<br><br><br>";
		cal++;
	}
	rs.getStatement().close();
	sTemp.append("   <td colspan=10 align=left class=td1 ><br>"+sSignalName1);
	if(!sMessageContent.equals("")){
	sTemp.append( sMessageContent+"<br><br></td>");}
	sTemp.append(" <br>");
    sTemp.append("   </tr>"); 
    
    //��ȡ���鿴�Լ�ǩ����������Ӧ�Ľ׶�
    String sOpinion="",sOpinion0="",sOpinion1="",sOpinion2="",sOpinion3="",sOpinion4="",sOpinion5="",sOpinion6="",sOpinion7="",sOpinion8="";
    String sCheckUser="",sCheckUser0="",sCheckUser1="",sCheckUser2="",sCheckUser3="",sCheckUser4="",sCheckUser5="",sCheckUser6="",sCheckUser7="",sCheckUser8="";
    String sCheckDate="",sCheckDate0="",sCheckDate1="",sCheckDate2="",sCheckDate3="",sCheckDate4="",sCheckDate5="",sCheckDate6="",sCheckDate7="",sCheckDate8="";
    String sPhaseNo="",sCurPhaseNo = "",sEndTime = "",sOrgId= "",sOrgPhaseNo = "";
	//sCurPhaseNo = Sqlca.getString("select PhaseNo from flow_task where flowno ='RiskSignalFlow' and UserID = '"+CurUser.UserID+"' ");
	//sOrgid = Sqlca.getString("select orgid from flow_task where flowno ='RiskSignalFlow' and UserID = '"+CurUser.UserID+"' ");
	sSql = " select PhaseNo,EndTime,OrgID from flow_task where ObjectType='RiskSignalApply'  and ObjectNo='"+sObjectNo+"' and flowno ='RiskSignalFlow' and UserID = '"+CurUser.UserID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{  
		sCurPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));
	    if(sCurPhaseNo== null) sCurPhaseNo = "";
	    sOrgId = DataConvert.toString(rs.getString("OrgId"));
	    if(sOrgId == null) sOrgId= "";
	    sEndTime = DataConvert.toString(rs.getString("EndTime"));
	    sOrgPhaseNo = Sqlca.getString("select max(PhaseNo) from flow_task where ObjectType='RiskSignalApply'  and ObjectNo='"+sObjectNo+"' and flowno ='RiskSignalFlow' and OrgID = '"+sOrgId+"' ");
	    if(!(sEndTime.equals("")||sEndTime == null)) sCurPhaseNo=sOrgPhaseNo;
	    else sEndTime = "";
	} 
	rs.getStatement().close();
	int i =DataConvert.toInt( Sqlca.getString("select count(*) from FLOW_OBJECT FO  where FO.ObjectType =  'RiskSignalApply' and  FO.ObjectNo = '"+sObjectNo+"' and FO.PhaseType='1040' "));
	System.out.print(i);
	if(i>0&&(CurUser.hasRole("28B")||CurUser.hasRole("08A")||CurUser.hasRole("089")||CurUser.hasRole("289")||CurUser.hasRole("282")||CurUser.hasRole("421")||CurUser.hasRole("0P6")||CurUser.hasRole("2P6")))sCurPhaseNo ="1000";
	
	sSql = " select RO.Opinion,FT.PhaseNo,RO.CheckDate,getUserName(RO.CheckUser) as CheckUser from RISKSIGNAL_OPINION RO,FLOW_TASK FT where FT.Serialno=RO.SerialNo  and FT.ObjectType='RiskSignalApply' and FT.PhaseNo<='"+sCurPhaseNo+"' and RO.ObjectNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
   	while(rs.next())
	{  
		sOpinion = DataConvert.toString(rs.getString("Opinion"));
	    if(sOpinion == null) sOpinion = "";
	    sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));
	    if(sPhaseNo == null) sPhaseNo = "";
	    sCheckUser = DataConvert.toString(rs.getString("CheckUser"));
	    if(sCheckUser == null) sCheckUser= "";
	    sCheckDate = DataConvert.toString(rs.getString("CheckDate"));
	    if(sCheckDate == null) sCheckDate = "";
	    if(sPhaseNo.equals("0010"))
	    {
	    	sOpinion0=sOpinion;
	    	sCheckUser0=sCheckUser;
	    	sCheckDate0=sCheckDate;
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>�ͻ�����Ԥ���ź�ʶ���ˣ����");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=left class=td1 >"+sOpinion0);
	    	//sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser0+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�"+sCheckDate0+"<br><br></td>");
	        sTemp.append("   </tr>");
	    }else if(sPhaseNo.equals("0020")||sPhaseNo.equals("0040")||sPhaseNo.equals("0240"))
	    {
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>����֧���г�{Ӫҵ������ֱӪ�ŶӸ�����)���");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;"+sOpinion);
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����(��)�£�");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ���ڣ�"+sCheckDate+"&nbsp;<br><br></td>");
	        sTemp.append("   </tr>");
	    }
	    else if(sPhaseNo.equals("0130") || sPhaseNo.equals("0110"))
	    {
	    	if(sPhaseNo.equals("0110"))
	    	{
	    		
	    		sTemp.append("   <tr>");
		    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>ֱ��֧�пͻ����Ÿ��������");
		    	sTemp.append("   </td>");
		        sTemp.append("   </tr>");         
		    	sTemp.append("   <tr>");
		        sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;");
		        sTemp.append("   <br>");
		    	sTemp.append("   <br>");
		    	sTemp.append("   <br>");
		    	sTemp.append("   <br>");
		    	sTemp.append("   <br>");
		    	sTemp.append("   <br>");
		    	sTemp.append("   <br>");
		    	sTemp.append("   <br>");
		    	sTemp.append("   <br>");
		    	sTemp.append("   <br>");
		    	sTemp.append("   <br>");
		    	sTemp.append("   ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����(��)�£�");
		    	sTemp.append("   <br>");
		    	sTemp.append("   <br>");
		    	sTemp.append("   ���ڣ�&nbsp;<br><br></td>");
		        sTemp.append("   </tr>"); 
	    	}
	    	
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>ֱ��֧���г������м��ſͻ����������");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");         
	    	sTemp.append("   <tr>");
	        sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;"+sOpinion);
	        sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����(��)�£�");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ���ڣ�"+sCheckDate+"&nbsp;<br><br></td>");
	        sTemp.append("   </tr>"); 
	    }else if(sPhaseNo.equals("0060"))
	    {
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>����֧�����Ź��������Ա���");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");         
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;"+sOpinion);
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�"+sCheckDate+"<br><br></td>");
	    	sTemp.append("   </tr>");
	    }else if(sPhaseNo.equals("0070"))
	    {
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>����֧�����Ź����������");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");         
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;"+sOpinion);
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ǩ�֣�");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ���ڣ�"+sCheckDate+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����(��)�£�<br><br></td>");
	        sTemp.append("   </tr>");
	    }else if(sPhaseNo.equals("0080"))
	    {
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>����֧�������г����");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");         
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;"+sOpinion);
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�"+sCheckDate+"<br><br></td>");
	        sTemp.append("   </tr>"); 
	    	
	    }else if(sPhaseNo.equals("0090"))
	    {
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>����֧���г����");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");         
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;"+sOpinion);
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�"+sCheckDate+"<br><br></td>");
	        sTemp.append("   </tr>");
	    }else if(sPhaseNo.equals("0150"))
	    {
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>�������Ź��������Ա���");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");         
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;"+sOpinion);
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�"+sCheckDate+"<br><br></td>");
	    	sTemp.append("   </tr>");
	    }else if(sPhaseNo.equals("0160"))
	    {
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>�������Ź����ܾ������");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");         
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;"+sOpinion);
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ǩ�֣�");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ���ڣ�"+sCheckDate+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����(��)�£�<br><br></td>");
	        sTemp.append("   </tr>"); 
	    	
	    }else if(sPhaseNo.equals("0170"))
	    {
	     	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>���������г����");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");         
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;"+sOpinion);
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�"+sCheckDate+"<br><br></td>");
	        sTemp.append("   </tr>"); 
	    }else if(sPhaseNo.equals("0180"))
	    {
	     	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>���չܿ�ίԱ�����");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");         
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;"+sOpinion);
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�"+sCheckDate+"<br><br></td>");
	        sTemp.append("   </tr>"); 
	    }else if(sPhaseNo.equals("0190"))
	    {
	    	sTemp.append("   <tr>");
	    	sTemp.append("   <td colspan=10 align=center class=td1 bgcolor=#aaaaaa>�����г����");
	    	sTemp.append("   </td>");
	        sTemp.append("   </tr>");         
	    	sTemp.append("   <tr>");

	    	sTemp.append("   <td colspan=9 align=left class=td1 style='width:100%; height:200'>&nbsp;"+sOpinion);
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   <br>");
	    	sTemp.append("   ǩ�֣�"+sCheckUser+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�"+sCheckDate+"<br><br></td>");
	        sTemp.append("   </tr>"); 
	    }
	}
	rs.getStatement().close();

   	
   	
    
     
    
   	 
   	
  
   
   
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
    editor_generate('describe4');		//��Ҫhtml�༭,input��û��Ҫ
	//editor_generate('describe5');		//��Ҫhtml�༭,input��û��Ҫ

<%
	}
%>	
</script>

<%@ include file="/IncludeEnd.jsp"%>




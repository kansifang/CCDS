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
	int iDescribeCount = 9;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
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
		sButtons[0][0] = "true";
	}
	else
	{
		sButtons[0][0] = "false";
	}

    String sql = "select PhaseNo from flow_Object where objectno='"+sObjectNo+
    "' and ObjectType='CreditApproveApply' and UserID='"+CurUser.UserID+"' ";
    String sPhaseNo = Sqlca.getString(sql);

    if(sPhaseNo == null) sPhaseNo = "";

    if("1000".equals(sPhaseNo) && "".equals(sViewPrint))
	{
		sButtons[1][0] = "true";
	}
	else
	{
		sButtons[1][0] = "false";
	}
%>
<%
    
	//��õ��鱨������
	
	String sApprovalNo = "";
	String sCreditAggreement = "";
	String sBusinessType = "";
	String sBusinessTypeName = "";
	String sOrgName = "";
	String sCustomerID = "";
    String sCustomerName = "";
    int sTermMonth = 0;
    Integer sTermDay = 0;
    String sRateFloat1 = "";
    String sRateFloat2 = "";
    double dRateFloat = 0;
    String sVouchType = "";
    String sMainVouchType = "";
    String sBusinessSum = "";
    String sBusinessSum2 = "";
    String sPurpose = "";
    String sYear = "xx";
    String sMonth = "xx";
    String sDay = "xx";
    String sApproveDate = "";
    String sRateFloatType = "";
    //ȡ�����е���Ϣ
	sql = "select BUSINESSTYPE,ApprovalNo,CustomerID,CreditAggreement,getOrgName(OperateOrgID) as OrgName,CustomerName,"+
	             "TermMonth,TermDay,RateFloat,RateFloatType,BusinessType,getBusinessName(BusinessType) as BusinessTypeName, "+
	             " VouchType,Purpose,"+
	             " nvl(BusinessSum,0)*geterate(Businesscurrency,'01',ERateDate) as BusinessSum,ApproveDate"+
	             " from Business_Apply where SerialNo ='"+sObjectNo+"'";
	
    ASResultSet rs2 = Sqlca.getResultSet(sql);
    if(rs2.next()){
    	
    	sRateFloatType =rs2.getString("RateFloatType");
    	if(sRateFloatType == null) sRateFloatType=" ";
    	
    	sApprovalNo = rs2.getString("ApprovalNo");
    	if(sApprovalNo == null) sApprovalNo=" ";
    	
    	sCustomerID = rs2.getString("CustomerID");
    	if(sCustomerID == null) sCustomerID=" ";
    	
    	sCreditAggreement = rs2.getString("CreditAggreement");
    	if(sCreditAggreement == null) sCreditAggreement=" ";
    	
    	sOrgName = rs2.getString("OrgName");
    	if(sOrgName == null) sOrgName=" ";
    	
    	sCustomerName = rs2.getString("CustomerName");
    	if(sCustomerName == null) sCustomerName=" ";
    	
    	sTermMonth = rs2.getInt("TermMonth");
    	
    	sTermDay = rs2.getInt("TermDay");
    	//if(sTermDay != null && sTermDay != 0) sTermMonth=sTermMonth+1;
    	
    	sBusinessType = rs2.getString("BusinessType");
    	if(sBusinessType == null) sBusinessType=" ";
    	
    	if(sBusinessType.startsWith("3")){
    		sRateFloat1 = "/";
    	}else{
    		// if(sBusinessType.equals("2050030"))//��������֤
    		if(sBusinessType.startsWith("2"))//����ҵ��
    		   { sRateFloat1 = "/";  }
    	     else{
    		    dRateFloat = rs2.getDouble("RateFloat");
        	    if(dRateFloat >=0){
        		if(sRateFloatType.equals("0"))//�����ٷֱ�
        		sRateFloat1 = "ͬ�ڻ�׼�����ϸ�"+DataConvert.toMoney(dRateFloat)+"%";
        		else sRateFloat1 = "ͬ�ڻ�׼�����ϸ�"+DataConvert.toMoney(dRateFloat)+"���ٷֵ�";
        	   
        	    }else {
        		dRateFloat = 0-dRateFloat;
        		if(sRateFloatType.equals("0"))//�����ٷֱ�
        		sRateFloat1 = "ͬ�ڻ�׼�����¸�"+DataConvert.toMoney(dRateFloat)+"%";
        		else sRateFloat1 = "ͬ�ڻ�׼�����¸�"+DataConvert.toMoney(dRateFloat)+"���ٷֵ�";
        	}
    	     }
    	}
    	
    	
    	sBusinessTypeName = rs2.getString("BusinessTypeName");
    	if(sBusinessTypeName == null) sBusinessTypeName=" ";
    	
    	sVouchType = rs2.getString("VouchType");
    	if(sVouchType == null) sVouchType=" ";
   	
    	sPurpose = rs2.getString("Purpose");
    	if(sPurpose == null) sPurpose=" ";
    	
    	sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum"));
    	
    	sApproveDate = rs2.getString("ApproveDate");
    	if(sApproveDate == null) sApproveDate="";
    	if(!"".equals(sApproveDate)) {
    		sYear = sApproveDate.substring(0,4);
    		sMonth = sApproveDate.substring(5,7);
    		sDay = sApproveDate.substring(8,10);
    	}
    }
    rs2.getStatement().close();
    if(sVouchType.length() >= 3){
	    sMainVouchType =  Sqlca.getString("select itemname from Code_Library where codeno='VouchType' and itemno='"+sVouchType.substring(0,3)+"'");
	    if(sMainVouchType == null) sMainVouchType=" ";
    }
    
    //��ȡ�����������
    String sSql = "select sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)) "+
	    " from BUSINESS_CONTRACT where customerID='"+sCustomerID+"'"+
	    " and BusinessType not like '30%' and (LOWRISK <> '1' or LOWRISK is null) and (FinishDate = '' or FinishDate is null)  ";
	rs2 = Sqlca.getResultSet(sSql);
	String sSumCreditBalance = "";
	while(rs2.next())
	{	
	    sSumCreditBalance = DataConvert.toMoney(rs2.getDouble(1));
	    if(sSumCreditBalance == null) sSumCreditBalance="0";
	}
	rs2.getStatement().close();

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=6 ><font style=' font-size: 25pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ũ����������ҵ������</font><br><br>");	
	sTemp.append("   ��ţ�"+sApprovalNo+"&nbsp;</td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >�ʱ�����</td>");
    sTemp.append(" <td colspan=5 align=left class=td1 >"+sOrgName+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >������</td>");
    sTemp.append(" <td colspan=5 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width='10%' align=center class=td1 >������</td>");
    sTemp.append(" <td width='25%' align=left class=td1 >"+sBusinessSum+"Ԫ&nbsp;</td>");
    sTemp.append(" <td width='9%' align=center class=td1 >����</td>");
    sTemp.append(" <td width='22%' align=left class=td1 >"+sTermMonth+"����"+sTermDay+"��&nbsp;</td>");
    sTemp.append(" <td width='9%' align=center class=td1 >����</td>");
    sTemp.append(" <td width='25%' align=left class=td1 >"+sRateFloat1+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >ҵ������</td>");
    sTemp.append(" <td colspan=5 align=left class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >��Ҫ������ʽ</td>");
    sTemp.append(" <td colspan=5 align=left class=td1 >"+sMainVouchType+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" <td colspan=6 align=left valign=top class=td1 style='width:100%; height:50' ><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��Ȩ��������"+sYear+"��"+sMonth+"��"+sDay+"����׼����������:<br>");
    sTemp.append("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����������<br></td>");
    sTemp.append(" </tr>");
    
    //��ȡ���������˵�������ˮ
	sSql = 	" select SerialNo from Flow_Task "+
			" where  SerialNo =( select RelativeSerialNo  from Flow_Task where PhaseNo ='1000' and ObjectNo='" + sObjectNo + "' and ObjectType='CreditApply')"+ 
			" and ObjectNo='" + sObjectNo + "' "+
			" and ObjectType='CreditApply' ";
	String sLaskFlowSerialNo= Sqlca.getString(sSql);

	sql = "select TermMonth,TermDay,RateFloat, "+
	      " nvl(BusinessSum,0)*geterate(Businesscurrency,'01','') as BusinessSum2"+
	      " from Flow_Opinion where SerialNo ='"+sLaskFlowSerialNo+"'";
	rs2 = Sqlca.getResultSet(sql);
	if(rs2.next()){
		sBusinessSum2 = DataConvert.toMoney(rs2.getDouble("BusinessSum2"));
    
		dRateFloat = rs2.getDouble("RateFloat");
		 //if(sBusinessType.equals("2050030"))//��������֤
		 if(sBusinessType.startsWith("2"))
		   { sRateFloat2 = "/";  }
	     else{
    	  if(dRateFloat >=0){
    		if(sRateFloatType.equals("0"))//�����ٷֱ�
        		sRateFloat2 = "ͬ�ڻ�׼�����ϸ�"+DataConvert.toMoney(dRateFloat)+"%";
    		else sRateFloat2 = "ͬ�ڻ�׼�����ϸ�"+DataConvert.toMoney(dRateFloat)+"���ٷֵ�";
    	}else {
    		dRateFloat = 0-dRateFloat;
    		if(sRateFloatType.equals("0"))//�����ٷֱ�
        		sRateFloat2 = "ͬ�ڻ�׼�����¸�"+DataConvert.toMoney(dRateFloat)+"%";
    		else sRateFloat2 = "ͬ�ڻ�׼�����¸�"+DataConvert.toMoney(dRateFloat)+"���ٷֵ�";
    	}
	     }
        sTermMonth = rs2.getInt("TermMonth");
    	sTermDay = rs2.getInt("TermDay");
    	//if(sTermDay != null && sTermDay != 0) sTermMonth=sTermMonth+1;
	}
	rs2.getStatement().close();
	
    sTemp.append("   <tr>");
  	sTemp.append(" <td colspan=2 align=center class=td1 >����Ʒ��</td>");
    sTemp.append(" <td width='9%' align=center class=td1 >����&nbsp;</td>");
    sTemp.append(" <td width='22%' align=center class=td1 >���&nbsp;</td>");
    sTemp.append(" <td width='9%' align=center class=td1 >����&nbsp;</td>");
    sTemp.append(" <td width='25%' align=center class=td1 >����&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td colspan=2 valign=top align=center class=td1 >"+sBusinessTypeName+"&nbsp;<br>");
  	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:25'",getUnitData("describe8",sData))+"&nbsp;</td>");
    sTemp.append(" <td align=center valign=top class=td1 >�����&nbsp;</td>");
    sTemp.append(" <td align=center valign=top class=td1 >"+sBusinessSum2+"Ԫ&nbsp;<br>");
    sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData))+"&nbsp;</td>");
    sTemp.append(" <td align=center valign=top class=td1 >"+sTermMonth+"����"+sTermDay+"��&nbsp;<br>");
    sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData))+"&nbsp;</td>");
    if(sBusinessType.startsWith("3")){
    	 sTemp.append(" <td align=center valign=top class=td1 >");
	}else{
		 sTemp.append(" <td align=center valign=top class=td1 >"+sRateFloat2+"&nbsp;<br>");	   
	}
    sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:25'",getUnitData("describe3",sData))+"&nbsp;</td>");
    sTemp.append(" </tr>");
    
    sTemp.append("   <tr>");
    sTemp.append(" <td colspan=6 align=left valign=top class=td1 style='width:100%; height:300' ><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������;��"+sPurpose+"&nbsp;");
    sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:50' align=center",getUnitData("describe4",sData)));
    sTemp.append("<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����ϵͳ��������"+sSumCreditBalance+"Ԫ&nbsp;<br>");
    sTemp.append("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��Ҫ������ʽ:"+sMainVouchType+"&nbsp;");
    sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:50' align=center",getUnitData("describe5",sData)));
    sTemp.append("<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ǰ������ȷ����ʵ����������<br>");
    sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:150; ' align=center",getUnitData("describe6",sData)));
    sTemp.append("<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ҫ��<br>");
    sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:150' align=center",getUnitData("describe7",sData)));

    String sApproveOrgName = "xxxx";//������������
	String sEndTime = "";//��������ʱ��
	String sApproveOrgID = "";//������������ID
	String sEndPhaseNo = "";//���ս׶�
	String sEndFlowNo = "";//������������
	String sFinalDepartment = "����������";//���ղ���
	sYear = "xx"; sMonth = "xx"; sDay = "xx";
	sql = "select FT1.OrgName as OrgName,FT1.OrgID as OrgID,FT1.FlowNo as FlowNo,FT1.PhaseNo as PhaseNo,FT1.EndTime as EndTime from Flow_Task FT1,Flow_Task FT2 "+
	      "where FT1.SerialNo = FT2.RelativeSerialNo and FT2.ObjectType = 'CreditApproveApply' and FT2.ObjectNo='"+sObjectNo+"' and FT2.PhaseNo='1000'";
	rs2 = Sqlca.getResultSet(sql);
	if(rs2.next()){
		sApproveOrgName = rs2.getString("OrgName");
		sEndTime = rs2.getString("EndTime");
		sApproveOrgID = rs2.getString("OrgID");
		sEndPhaseNo = rs2.getString("PhaseNo");
		sEndFlowNo = rs2.getString("FlowNo");
		if(sApproveOrgName == null) sApproveOrgName="";
		if(sEndTime == null) sEndTime="";
		if(sApproveOrgID == null) sApproveOrgID="";
		if(sEndPhaseNo == null) sEndPhaseNo="";
		if(sEndFlowNo == null) sEndFlowNo="";
		
		if(!"".equals(sEndTime)) {
			sYear = sEndTime.substring(0,4);
			sMonth = sEndTime.substring(5,7);
			sDay = sEndTime.substring(8,10);
		}
		
	}
	rs2.getStatement().close();
	//��ѯ�������������׶�
	sql = "select FT1.FlowNo as FlowNo,FT1.PhaseNo as PhaseNo from Flow_Task FT1,Flow_Task FT2 "+
    "where FT1.SerialNo = FT2.RelativeSerialNo and FT2.ObjectType = 'CreditApply' and FT2.ObjectNo='"+sObjectNo+"' and FT2.PhaseNo='1000'";
	rs2 = Sqlca.getResultSet(sql);
	if(rs2.next()){
	
		sEndPhaseNo = rs2.getString("PhaseNo");
		sEndFlowNo = rs2.getString("FlowNo");
		
		if(sEndPhaseNo == null) sEndPhaseNo="";
		if(sEndFlowNo == null) sEndFlowNo="";
		
	}
	rs2.getStatement().close();
	if("EntCreditFlowTJ01".equals(sEndFlowNo)&&"0230".equals(sEndPhaseNo))
	{
		sFinalDepartment="���ũ��������С��ҵ�����ֲ�";
	}else if("IndCreditFlowTJ01".equals(sEndFlowNo)&&"0210".equals(sEndPhaseNo))
	{
		sFinalDepartment="���ũ�����и���ҵ�������ֲ�";
	}else{
		sFinalDepartment = sApproveOrgName+"����������";
	}
    sTemp.append("<br><br><br><br><p align=right>"+sFinalDepartment+"<br>"+sYear+"��"+sMonth+"��"+sDay+"��</p><br><br><br>");
    sTemp.append("<font style=' font-size: 7pt;FONT-FAMILY:����;color:black;' >");
    sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:20' align=left",getUnitData("describe9",sData))+"</font></td>");	
    sTemp.append(" </tr>");
    sTemp.append("<tr>");
    sTemp.append(" <td align=left colspan=6 class=td1 >");
    if("���ũ��������С��ҵ�����ֲ�".equals(sFinalDepartment)||"���ũ�����и���ҵ�������ֲ�".equals(sFinalDepartment))
    {
    	sTemp.append(" <font style=' font-size:10pt;FONT-FAMILY:����;' >"+"�����ˣ�"+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����ˣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"</font>");
    }else
    {
    	sTemp.append(" <font style=' font-size:10pt;FONT-FAMILY:����;' >"+"�����ˣ�"+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�����ˣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����ˣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"</font>");
    }
    sTemp.append(" </td>");
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
	editor_generate('describe4');
	editor_generate('describe5'); 
	editor_generate('describe6');
	editor_generate('describe7');
	editor_generate('describe9');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

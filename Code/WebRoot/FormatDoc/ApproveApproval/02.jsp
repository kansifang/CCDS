<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.creditline.bizlets.*,com.amarsoft.biz.bizlet.*" %>

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
    "' and ObjectType='CreditApproveApply' and UserID='"+CurUser.UserID+"'";
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
	
	int iMoneyUnit = 10000 ;  //��λ��Ԫ
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
    String sBusinesscurrency = "";
    String sPurpose = "";
    String sToday = StringFunction.getToday();
    String sYear = sToday.substring(0,4);
    String sMonth = sToday.substring(5,7);
    String sDay = sToday.substring(8);
    String sFinishYear = "";//����������
    String sFinishMonth = "";//���չ�������
    String sFinishDay = "";//����������
    String sEndTime = "";//������������ʱ��
    String sRateFloatType = "";
    //ȡ�����е���Ϣ
	sql = "select ApprovalNo,CustomerID,CreditAggreement,getOrgName(OperateOrgID) as OrgName,CustomerName,"+
	             "TermMonth,TermDay,RateFloat,RateFloatType,BusinessType,getBusinessName(BusinessType) as BusinessTypeName, "+
	             " VouchType,Purpose,"+
	             " nvl(BusinessSum,0)*geterate(Businesscurrency,'01',ERateDate) as BusinessSum"+
	             " from Business_Apply where SerialNo ='"+sObjectNo+"'";
	//getItemName('Currency',Businesscurrency) as Businesscurrency,Purpose,
	
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
    	
    	dRateFloat = rs2.getDouble("RateFloat");
    	if(dRateFloat >=0){
    		if(sRateFloatType.equals("0"))//�����ٷֱ�
        		sRateFloat2 = "ͬ�ڻ�׼�����ϸ�"+DataConvert.toMoney(dRateFloat)+"%";
    		else sRateFloat1 = "ͬ�ڻ�׼�����ϸ�"+DataConvert.toMoney(dRateFloat)+"���ٷֵ�";
    	}else {
    		dRateFloat = 0-dRateFloat;
    		if(sRateFloatType.equals("0"))//�����ٷֱ�
        		sRateFloat2 = "ͬ�ڻ�׼�����ϸ�"+DataConvert.toMoney(dRateFloat)+"%";
    		else sRateFloat1 = "ͬ�ڻ�׼�����¸�"+DataConvert.toMoney(dRateFloat)+"���ٷֵ�";
    	}
    	if(sBusinessType.startsWith("3")){
    		sRateFloat1 = "/";
    	}
    	//if(sBusinessType.equals("2050030"))//��������֤
    	if(sBusinessType.startsWith("2"))//����ҵ��
    	  { sRateFloat1 = "/";  }
    	

    	sBusinessTypeName = rs2.getString("BusinessTypeName");
    	if(sBusinessTypeName == null) sBusinessTypeName=" ";
    	
    	sVouchType = rs2.getString("VouchType");
    	if(sVouchType == null) sVouchType=" ";
    	
    	sPurpose = rs2.getString("Purpose");
    	if(sPurpose == null) sPurpose=" ";
    	
    	sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum"));
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
	    sSumCreditBalance = DataConvert.toMoney(rs2.getDouble(1)/10000);
	    if(sSumCreditBalance == null) sSumCreditBalance="0";
	}
	rs2.getStatement().close();
	
	//ȡ��������ʱ��
    sSql = "select EndTime from FLOW_TASK where ObjectType = 'CreditApply' and ObjectNo='"+sObjectNo+"' and phaseno in('1000','8000') ";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sEndTime = rs2.getString("EndTime");
		if(sEndTime.length()>=10)
		{
			sFinishYear = sEndTime.substring(0,4);
	    	sFinishMonth = sEndTime.substring(5,7);
	    	sFinishDay = sEndTime.substring(8,10);
		}
	}
	rs2.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='02.jsp' name='reportInfo'>");	
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
  	sTemp.append(" <td width='15%' align=center class=td1 >������</td>");
    sTemp.append(" <td width='25%' align=left class=td1 >"+sBusinessSum+"Ԫ&nbsp;</td>");
    sTemp.append(" <td width='10%' align=center class=td1 >����</td>");
    sTemp.append(" <td width='15%' align=left class=td1 >"+sTermMonth+"����"+sTermDay+"��&nbsp;</td>");
    sTemp.append(" <td width='10%' align=center class=td1 >����</td>");
    sTemp.append(" <td width='25%' align=left class=td1 >"+sRateFloat1+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >ҵ������</td>");
    sTemp.append(" <td colspan=5 align=left class=td1 >"+sBusinessTypeName);
    sTemp.append(myOutPut("1",sMethod,"name='describe0' style='width:100%; height:25; ' align=center",getUnitData("describe0",sData)));
    sTemp.append("&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >��Ҫ������ʽ</td>");
    sTemp.append(" <td colspan=5 align=left class=td1 >"+sMainVouchType+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" <td colspan=6 align=left valign=top class=td1 style='width:100%; height:300' >");
    sTemp.append(" <br>&nbsp;&nbsp;&nbsp;&nbsp;��Ȩ��������"+sFinishYear+"��"+sFinishMonth+"��"+sFinishDay+"�նԸ���Ŀ������������������:<br>");
    sTemp.append("<br>��ͬ�Ȿ���������롣<br>");
 	sTemp.append("<br><br>&nbsp;&nbsp;&nbsp;&nbsp;δͨ��ԭ��<br>");
    sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150; ' align=center",getUnitData("describe1",sData)));
    
    String sApproveOrgName = "xxxx";//������������
	String sEndApproveTime = "";//��������ʱ��
	String sEndPhaseNo = "";//���ս׶�
	String sEndFlowNo = "";//������������
	String sFinalDepartment = "����������";//���ղ���
	sYear = "xx"; sMonth = "xx"; sDay = "xx";
	sql = "select OrgName,EndTime from Flow_Task where SerialNo=(select RelativeSerialNo from Flow_task where ObjectType = 'CreditApproveApply' and ObjectNo='"+sObjectNo+"' and PhaseNo = '1000')";
	rs2 = Sqlca.getResultSet(sql);
	if(rs2.next()){
		sApproveOrgName = rs2.getString("OrgName");
		sEndApproveTime = rs2.getString("EndTime");
		if(sApproveOrgName==null) sApproveOrgName="";
		if(sEndApproveTime==null) sEndApproveTime="";
		if(sEndApproveTime.length()>=10) {
			sYear = sEndApproveTime.substring(0,4);
			sMonth = sEndApproveTime.substring(5,7);
			sDay = sEndApproveTime.substring(8,10);
		}
	}
	rs2.getStatement().close();
	sql = "select FlowNo,PhaseNo from Flow_Task where SerialNo=(select RelativeSerialNo from Flow_task where ObjectType = 'CreditApply' and ObjectNo='"+sObjectNo+"' and PhaseNo = '8000')";
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
    sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:630; height:20' align=left",getUnitData("describe2",sData))+"</font></td>");	
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
	editor_generate('describe1');
	editor_generate('describe2');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

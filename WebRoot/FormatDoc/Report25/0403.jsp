<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   Author:   zwhu 2009.08.18
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
	int iDescribeCount =0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	String sBusinessTypeName = "";    //ҵ��Ʒ��
	String sCurrencyType = "";    //����					
	String sBusinessSum = "";    //���
	double dBusinessSum=0.0;											
	String sBailRatio = "";   	//��֤�����
	double dBailRatio = 0.00;
	String sTermmonth = "" ;		//���ޣ��£�
	String sBusinessRate = "";    //����		
	String sVouchTypeName="";  //������ʽ			
	String sPurpose = "";
	String sCorpusPayMethodName = "" ;//���ʽ
	String sDrawingTypeName = "";//��ʽ
	String sContextInfo = "";//���˵��
	String sPaySource = ""; //����˵��
	String sSpace = "0.00";	
	String sApplyType = "";//���ŷ�ʽ				
	//�����˻�����Ϣ
	ASResultSet rs2 = Sqlca.getResultSet("select BUSINESSTYPE,getBusinessName(BUSINESSTYPE) as BusinessTypeName,getItemName('Currency',BusinessCurrency),"
								+" BusinessSum,BailRatio,TermMonth,BusinessRate ,getItemName('VouchType',VouchType) as VouchTypeName,"
								+" Purpose,getItemName('CorpusPayMethod',CorpusPayMethod),getItemName('DrawingType',DrawingType),"
								+" ContextInfo,PaySource,"
								+" BusinessSum*getErate(BusinessCurrency,'01',ERateDate) as BusinessSum1 ,"
								+" nvl(BailSum,0)*getErate(nvl(BailCurrency,'01'),'01','') as BailSum1 "
								+" ,getItemName('BusinessApplyType',ApplyType) as ApplyType "
								+"  from BUSINESS_apply   where SerialNo='"+sObjectNo+"'" );
	while(rs2.next()){
		String sBusinessType = rs2.getString(1);
		if(sBusinessType == null) sBusinessType = "";
		
		sBusinessTypeName = rs2.getString(2);
		if(sBusinessTypeName == null) sBusinessTypeName=" ";
	
		sCurrencyType = rs2.getString(3);
		if(sCurrencyType == null) sCurrencyType=" ";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(4)/10000);
		if(sBusinessSum == null) sBusinessSum="0";
		
		sBailRatio = rs2.getString(5);
		if(sBailRatio == null) sBailRatio="0";
		dBailRatio = DataConvert.toDouble(sBailRatio);
		
		sTermmonth = rs2.getString(6);
		if(sTermmonth == null) sTermmonth=" ";
		
		sBusinessRate = rs2.getString(7);
		if(sBusinessRate == null) sBusinessRate=" ";
		
		sVouchTypeName = rs2.getString(8);
		if(sVouchTypeName == null) sVouchTypeName = "";
		
		sPurpose = rs2.getString(9);
		if(sPurpose == null) sPurpose = "";
		
		sCorpusPayMethodName = rs2.getString(10);
		if(sCorpusPayMethodName == null) sCorpusPayMethodName = "";
		
		sDrawingTypeName = rs2.getString(11);
		if(sDrawingTypeName == null) sDrawingTypeName = "";
		
		sContextInfo = rs2.getString(12);
		if(sContextInfo == null) sContextInfo = "";
		
		sPaySource = rs2.getString(13);
		if(sPaySource == null) sPaySource = "";		
		
		if(sBusinessType.startsWith("2")){
			sSpace = DataConvert.toMoney(rs2.getDouble("BusinessSum1")/10000-rs2.getDouble("BailSum1")/10000);
		}
		
		sApplyType = rs2.getString("ApplyType");
		if(sApplyType == null) sApplyType = "";				
	}
	rs2.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='0403.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4.3������˱�����������</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > ���ŷ�ʽ </td>");
    sTemp.append(" 		<td width=15% align=center class=td1 > ����Ʒ�� </td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >����</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 >����Ԫ��</td>");
   	sTemp.append(" 		<td width=15% align=center class=td1 >��֤�����%</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 >���ޣ��£�</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 >��/���ʡ�(��)</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > "+sApplyType+"&nbsp; </td>");
    sTemp.append(" 		<td width=15% align=center class=td1 >  "+sBusinessTypeName+"&nbsp; </td>");
    sTemp.append(" 		<td width=10% align=center class=td1 > "+sCurrencyType+"&nbsp;</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 > "+sBusinessSum+"&nbsp;</td>");
   	sTemp.append(" 		<td width=15% align=center class=td1 > "+dBailRatio+"&nbsp;</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 > "+sTermmonth+"&nbsp;</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 > "+sBusinessRate+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > ��Ҫ������ʽ </td>");
    sTemp.append(" 		<td colspan='3' align=center class=td1 >"+sVouchTypeName+"&nbsp;</td>");
    sTemp.append(" 		<td width=15% align=center class=td1 > ���ų��ڣ���Ԫ�� </td>");
    sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sSpace+"&nbsp;</td>");
    sTemp.append(" 	</tr>");   
     
    sTemp.append("   <tr>");
    sTemp.append(" 		<td  align=center class=td1 > ������;�� </td>");
  	sTemp.append("   	<td colspan='6' align=left class=td1 >"+sPurpose+"&nbsp;"); 
	sTemp.append("</td>");
    sTemp.append(" 	</tr>");
  
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > �����ʽ�� </td>");
  	sTemp.append("   	<td colspan='6' align=left class=td1 >"+"���ʽ--"+sCorpusPayMethodName+"<br/>"+"��ʽ--"+sDrawingTypeName);
	sTemp.append("&nbsp;</td>");
    sTemp.append(" 	</tr>"); 

  
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu  2009.08.13
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
	int iDescribeCount = 3;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//��õ��鱨������
	String sBusinessTypeName = "";		//ҵ��Ʒ��
	String sBusinessSum = "";			//���
	double dBusinessSum=0.0;
	String sTermMonth ="";            //����
	String sCurrencyType = "";		//����
	String sBailRatio = "";		//��֤�����
	String sBusinessRate = "";	//����
	String sCycleFlag = "";	//�Ƿ�ѭ��
	String sVouchTypeName = "";
	ASResultSet rs2 = Sqlca.getASResultSet(" select BusinessType,getBusinessName(BusinessType) as BusinessTypeName,BusinessSum,"
										+" TermMonth,getItemName('Currency',BusinessCurrency) as CurrencyType,BailRatio,BusinessRate,"
										+" getItemName('YesNo',CYCLEFLAG) as CycleFlagName ,getItemName('VouchType',VouchType) as VouchTypeName "
										+" from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	while(rs2.next()){
		sBusinessTypeName = rs2.getString(2);
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(3));
		if(sBusinessSum == null) sBusinessSum = "0";	
		
		sTermMonth = rs2.getString(4);
		if(sTermMonth == null) sTermMonth = "";	
		
		sCurrencyType = rs2.getString(5);
		if(sCurrencyType == null) sCurrencyType = "";	
		
		sBailRatio = rs2.getString(6);
		if(sBailRatio == null) sBailRatio = "";	
		
		sBusinessRate = rs2.getString(7);
		if(sBusinessRate == null) sBusinessRate = "";
			
		sCycleFlag = rs2.getString(8);
		if(sCycleFlag == null) sCycleFlag = "";	
		
		sVouchTypeName = rs2.getString(9);
		if(sVouchTypeName == null) sVouchTypeName = "";
	}												
	rs2.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='1203.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >12.3���ۺ����Ϸ�����ͬ�ⰴ�����·�ʽ��������</font></td> ");	
	sTemp.append("   </tr>");
		
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=left class=td1 > ������� </td>");
    sTemp.append(" 		<td colspan='2' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td  align=left class=td1 > ���ŷ�ʽ </td>");
    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=left class=td1 > ���Ŷ�ȣ�Ԫ�� </td>");
    sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
    sTemp.append(" 		<td  align=left class=td1 > �������ޣ��£� </td>");
    sTemp.append(" 		<td  align=left class=td1 >"+sTermMonth+"&nbsp;</td>");
    sTemp.append(" 	</tr>"); 
       
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=left class=td1 > ����Ʒ�� </td>");
    sTemp.append(" 		<td  align=left class=td1 >���� </td>");
    sTemp.append(" 		<td  align=left class=td1 > ��Ԫ�� </td>");
//    sTemp.append(" 		<td  align=left class=td1 >��֤����� </td>");
    sTemp.append(" 		<td  align=left class=td1 >���ޣ��£�</td>");
    sTemp.append(" 		<td  align=left class=td1 >ִ��������</td>");
//    sTemp.append(" 		<td  align=left class=td1 >�Ƿ�ѭ��</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=left class=td1 > "+sBusinessTypeName+"&nbsp; </td>");
    sTemp.append(" 		<td  align=left class=td1 >"+sCurrencyType+"&nbsp;</td>");
    sTemp.append(" 		<td   align=left class=td1 > "+sBusinessSum+"&nbsp; </td>");
//    sTemp.append(" 		<td  align=left class=td1 >"+sBailRatio+"&nbsp;</td>");
    sTemp.append(" 		<td  align=left class=td1 >"+sTermMonth+"&nbsp;</td>");
	sTemp.append(" 		<td  align=left class=td1 >"+sBusinessRate+"&nbsp;</td>");
//    sTemp.append(" 		<td  align=left class=td1 >"+sCycleFlag+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
//    sTemp.append(" 		<td  align=left class=td1 > ��������</td>");
//    sTemp.append(" 		<td colspan='2' align=left class=td1 >"+""+"&nbsp;</td>");
  	sTemp.append(" 		<td  align=left class=td1 > �������ų��ڣ���Ԫ��</td>");
    sTemp.append(" 		<td  colspan='2' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td  align=left class=td1 > �����ܳ��ڣ���Ԫ�� </td>");
    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=left class=td1 > ��Ҫ������ʽ </td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sVouchTypeName+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  colspan='7' align=left class=td1 > <p>��ע:</p> </td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='7' align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td   colspan='7' align=left class=td1 > Э��ͻ��������</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='7' align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td   colspan='7' align=left class=td1 > �Ƿ�ͬ������ͻ�������� </td>");
    sTemp.append("	 </tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='7' align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:50'",getUnitData("describe3",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td   colspan='7' align=left class=td1 > �ͻ��������ʵ�Ը������ش���© </td>");
    sTemp.append("	 </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("     <td  colspan='7' height='85' align=right class=td1 > <p> �����ˣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> <p> Э���ˣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p></td>");
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
	editor_generate('describe1');
	editor_generate('describe2');
	editor_generate('describe3');	
<%
	}
%>	
</script>	

	
<%@ include file="/IncludeEnd.jsp"%>

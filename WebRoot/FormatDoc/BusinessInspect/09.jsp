<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
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
	int iDescribeCount = 103;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//�жϸñ����Ƿ����
	String sSql="select finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next())
	{
		FinishFlag = rs.getString("finishdate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null)
	{
		sButtons[1][0] = "true";
	}
	else
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
	String sCustomerID = "";
	String sCustomerName = "";
	String sOrgTypeName = "";
	String sOtheCreditLevel = "";
	sSql = " select ObjectNo"+
			" from INSPECT_INFO II"+
			" where II.SerialNo='"+sSerialNo+"'";
	
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sCustomerID=rs.getString(1);
	}
	rs.getStatement().close();
	if(sCustomerID == null) sCustomerID = "";
	sSql = " select getCustomerName(CustomerID)"+
		   " from Ind_info where customerID = '"+sCustomerID+"'";
	rs=Sqlca.getResultSet(sSql);
	if(rs.next()){
		sCustomerName = rs.getString(1);
	}
	rs.getStatement().close();
	if(sCustomerName == null) sCustomerName = "";
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='09.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=25 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>���ũ������</p>���˿ͻ������鱨��</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa><strong>������Ŀ�ſ���</strong> </td>");
    sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >��������ƣ� </td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >����ҵ�����</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >��鷽ʽ��</td>");
	sTemp.append("   <td colspan=3 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:40'",getUnitData("describe1",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���ʱ�䣺</td>");
	sTemp.append("   <td colspan=2 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:40'",getUnitData("describe2",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >����˻�����Ϣ�����</td>");
	sTemp.append("   <td colspan=3 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:40'",getUnitData("describe3",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >�ϴμ�����ڼ������</td>");
	sTemp.append("   <td colspan=2 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:40'",getUnitData("describe4",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=17% class=td1 >���Ų�Ʒ����</td>");
	sTemp.append("   <td width=10% class=td1 >��ͬ���</td>");
	sTemp.append("   <td width=10% class=td1 >���</td>");
	sTemp.append("   <td width=13% class=td1 >������</td>");
	sTemp.append("   <td width=15% class=td1 >������ʽ</td>");
	sTemp.append("   <td width=20% class=td1 >�������</td>");
	sTemp.append("   <td width=15% class=td1 >������ʽ</td>");		
    sTemp.append("   </tr>"); 
    String sBusinessTypeName = "";
    String sContractSerialNo = "";
    String sPayCyc = "";
    String sBalance = "0.00";
    String sMaturity = ""; 
    String sVouchTypeName = ""; 
	sSql = " select getBusinessName(BusinessType) as BusinessTypeName,SerialNo,"+
		   " getItemName('CorpusPayMethod1',PayCyc)as PayCyc,Balance,Maturity,getItemName('VouchType',VouchType) as VouchTypeName"+
		   " from BUSINESS_CONTRACT where CustomerID = '"+sCustomerID+"'";
    rs = Sqlca.getResultSet(sSql);
    int i = 4;
    while(rs.next()){
        i++;
    	String name = "describe"+i;
    	sBusinessTypeName = rs.getString(1);
    	sContractSerialNo = rs.getString(2);
    	sPayCyc = rs.getString(3);
    	sBalance = DataConvert.toMoney(rs.getDouble(4));
    	sMaturity = rs.getString(5);
    	sVouchTypeName = rs.getString(6);
    	if(sBusinessTypeName == null) sBusinessTypeName = "";
    	if(sContractSerialNo == null) sContractSerialNo = "";
    	if(sPayCyc == null)sPayCyc = "";
   	 	if(sBalance == null) sBalance="0.00";
    	if(sMaturity == null) sMaturity = "";
    	if(sVouchTypeName == null) sVouchTypeName = "";
    	sTemp.append("   <tr>");
		sTemp.append("   <td colspan=1 class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sBalance+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sVouchTypeName+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >");
		sTemp.append(myOutPut("1",sMethod,"name='"+name+"' style='width:100%; height:40'",getUnitData(name,sData)));
		sTemp.append("   &nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sPayCyc+"&nbsp;</td>");
	    sTemp.append("   </tr>");  
    }
    rs.getStatement().close();
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 bgcolor=#aaaaaa>����˸����������");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan=7 align=left class=td1 "+myShowTips(sMethod)+" ><p>�����������롢������������ͥ�ȱ仯�����</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");         
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe100' style='width:100%; height:150'",getUnitData("describe100",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 bgcolor=#aaaaaa>�������Ϊ����");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe101' style='width:100%; height:150'",getUnitData("describe101",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 bgcolor=#aaaaaa>���ڼ��������");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe102' style='width:100%; height:150'",getUnitData("describe102",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 bgcolor=#aaaaaa>�������ۼ�Ӧ�Դ�ʩ");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1>�������ۼ�Ӧ�Դ�ʩ:");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe103' style='width:100%; height:150'",getUnitData("describe103",sData)));
	sTemp.append("   <br>");
	sTemp.append("   �ͻ�����ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1>����������չ������:");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	//sTemp.append(myOutPut("1",sMethod,"name='describe104' style='width:100%; height:150'",getUnitData("describe104",sData)));
	sTemp.append("   <br>");
	sTemp.append("  <br/><br/><br/><br/> ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1>Ӫҵ����ֱ��֧�м��������縺�������:");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");     
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	//sTemp.append(myOutPut("1",sMethod,"name='describe105' style='width:100%; height:150'",getUnitData("describe105",sData)));
	sTemp.append("   <br>");
	sTemp.append("  <br/><br/><br/><br/> ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�</td>");
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
	editor_generate('describe100');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe101');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe102');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe103');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


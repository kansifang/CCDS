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
	int iDescribeCount = 116;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
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
	sSql = " select getCustomerName(CustomerID),getItemName('OrgType',OrgType) as OrgTypeName,CreditLevel"+
		   " from ent_info where customerID = '"+sCustomerID+"'";
	rs=Sqlca.getResultSet(sSql);
	if(rs.next()){
		sCustomerName = rs.getString(1);
		sOrgTypeName = rs.getString(2);
		sOtheCreditLevel = rs.getString(3);
	}
	rs.getStatement().close();
	if(sCustomerName == null) sCustomerName = "";
	if(sOrgTypeName == null) sOrgTypeName = "";
	if(sOtheCreditLevel == null) sOtheCreditLevel = "";
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='07.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=25 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>���ũ������</p>��˾�ͻ�һ����ճ����鱨��</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���λ��</td>");
	sTemp.append("   <td colspan=3 class=td1 > "+CurOrg.OrgName);
	//sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:40'",getUnitData("describe5",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���ʱ�䣺</td>");
	sTemp.append("   <td colspan=2 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:40'",getUnitData("describe6",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa><strong>������Ŀ�ſ���</strong> </td>");
    sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >�ͻ����ƣ� </td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >��ҵ���ͣ�</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sOrgTypeName+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >��鷽ʽ��</td>");
	sTemp.append("   <td colspan=3 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:30'",getUnitData("describe1",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���õȼ���</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sOtheCreditLevel+"&nbsp;</td>");
    sTemp.append("   </tr>");
    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >�����������ڣ�</td>");
	sTemp.append("   <td colspan=3 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:30'",getUnitData("describe2",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 rowspan = 2 align=left class=td1 >�����������ݣ�</td>");
	sTemp.append("   <td colspan=2 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:30'",getUnitData("describe3",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���ڡ�ǷϢ�����</td>");
	sTemp.append("   <td colspan=3 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe116' style='width:100%; height:30'",getUnitData("describe116",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
	sTemp.append("   <td width=17% class=td1 >���Ų�Ʒ����</td>");
	sTemp.append("   <td width=10% class=td1 >��ͬ���</td>");
	sTemp.append("   <td width=10% class=td1 >����</td>");
	sTemp.append("   <td width=10% class=td1 >���</td>");
	sTemp.append("   <td width=10% class=td1 >������</td>");
	sTemp.append("   <td width=13% class=td1 >������</td>");
	sTemp.append("   <td width=20% class=td1 >����������</td>");		
    sTemp.append("   </tr>"); 
    String sBusinessTypeName = "";
    String sContractSerialNo = "";
    String sCurrencyName = "";
    String sBalance = "0.00";
    String sMaturity = ""; 
    String sVouchTypeName = ""; 
    String sPutOutDate = "";
	sSql = " select getBusinessName(BusinessType) as BusinessTypeName,SerialNo,"+
		   " getItemName('Currency',BusinessCurrency)as CurrencyName,Balance,Maturity,getItemName('VouchType',VouchType)"+ 
		   " as VouchTypeName,PutOutDate"+
		   " from BUSINESS_CONTRACT where CustomerID = '"+sCustomerID+"'";
    rs = Sqlca.getResultSet(sSql);
    int i =3;
    while(rs.next()){
    	i++;
    	String name = "describe"+i;
    	sBusinessTypeName = rs.getString(1);
    	sContractSerialNo = rs.getString(2);
    	sCurrencyName = rs.getString(3);
    	sBalance = DataConvert.toMoney(rs.getDouble(4));
    	sMaturity = rs.getString(5);
    	sVouchTypeName = rs.getString(6);
    	sPutOutDate = rs.getString(7);
    	if(sBusinessTypeName == null) sBusinessTypeName = "";
    	if(sContractSerialNo == null) sContractSerialNo = "";
    	if(sCurrencyName == null)sCurrencyName = "";
   	 	if(sBalance == null) sBalance="0.00";
    	if(sMaturity == null) sMaturity = "";
    	if(sVouchTypeName == null) sVouchTypeName = "";
    	if(sPutOutDate == null) sPutOutDate = "";
    	sTemp.append("   <tr>");
		sTemp.append("   <td colspan=1 class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sCurrencyName+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sBalance+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >"+sMaturity+"&nbsp;</td>");
		//sTemp.append("   <td colspan=1 class=td1 >"+sVouchTypeName+"&nbsp;</td>");
		sTemp.append("   <td colspan=1 class=td1 >");
		sTemp.append(myOutPut("1",sMethod,"name='"+name+"' style='width:100%; height:40'",getUnitData(name,sData)));
		sTemp.append("   &nbsp;</td>");
	    sTemp.append("   </tr>");  
    }
    rs.getStatement().close();
  
    sTemp.append(" <tr>");	     
	sTemp.append("   <td colspan=7 align=center class=td1  bgcolor=#aaaaaa  >�ϴμ�����ڼ����������<br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan=7 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe100' style='width:100%; height:150'",getUnitData("describe100",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
   	
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa >�ͻ�����Ӫ״������");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >�ͻ���Ӫ����״����������ӯ����������ӪЧ�ʡ������ԺͶ��ڳ�ծ���������ڳ�ծ�����ȣ�:<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe101' style='width:100%; height:150'",getUnitData("describe101",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa>�ͻ��ǲ���״������");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >�ͻ�������Ӫ״������������۾�Ӫ�������������׹�Ӧ������������������������ȣ���:<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe102' style='width:100%; height:150'",getUnitData("describe102",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");   
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >�ͻ����и�ծ�����и�ծ״��������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe103' style='width:100%; height:150'",getUnitData("describe103",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");   
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >�ͻ�����ˮƽ������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe104' style='width:100%; height:150'",getUnitData("describe104",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >�ͻ��ش���������������¡���Ȩ����֯�ܹ�����Ӫ���ԡ����á����ɾ��׵ȣ�<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe105' style='width:100%; height:150'",getUnitData("describe105",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >�ͻ����Ų�Ʒ��飺���ο��̶��ʲ����Ʊ��ҵ��ó�����ʵ����Ҫ��<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe106' style='width:100%; height:150'",getUnitData("describe106",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1  bgcolor=#aaaaaa>�Կͻ���Լ��������������ж�<br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan=7 align=left class=td1 >�Կͻ���������ӦΪ��<br/>");
	sTemp.append(myOutPut("1",sMethod,"name='describe107' style='width:100%; height:150'",getUnitData("describe107",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa >�ͻ������������");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >�����˵����ʸ񼰻�����Ӫ״����<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe108' style='width:100%; height:150'",getUnitData("describe108",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >�Ե����˵�������������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe109' style='width:100%; height:150'",getUnitData("describe109",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >�Ե����˵�����Ը������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe110' style='width:100%; height:150'",getUnitData("describe110",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1  bgcolor=#aaaaaa>�֣��ʣ�Ѻ��������<br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >��������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe111' style='width:100%; height:150'",getUnitData("describe111",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");    
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >�������ۣ�<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe112' style='width:100%; height:150'",getUnitData("describe112",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1 bgcolor=#aaaaaa >��֤������飺<br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>"); 
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe113' style='width:100%; height:150'",getUnitData("describe113",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");   
      
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=center class=td1  bgcolor=#aaaaaa>�������ۼ�Ӧ�Դ�ʩ");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >�������ۼ�Ӧ�Դ�ʩ��<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe114' style='width:100%; height:150'",getUnitData("describe114",sData)));
	sTemp.append("   <br>");
	sTemp.append("   �ͻ�����ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >���Ÿ����������<br>");
	//sTemp.append(myOutPut("1",sMethod,"name='describe115' style='width:100%; height:150'",getUnitData("describe115",sData)));
	sTemp.append("   <br>");
	sTemp.append("   <br/><br/><br/><br/>ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ڣ�</td>");
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
	editor_generate('describe104');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe105');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe106');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe107');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe108');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe109');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe110');		//��Ҫhtml�༭,input��û��Ҫ		
	editor_generate('describe111');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe112');		//��Ҫhtml�༭,input��û��Ҫ   
	editor_generate('describe113');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe114');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


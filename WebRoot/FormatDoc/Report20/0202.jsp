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
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 9;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[0][0] = "true";
	sButtons[1][0] = "false";
%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='0202.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2������˹����ͻ���Ϣ</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.1����˵�ǰ����ɶ�  ���֣������</font></td> ");	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append(" 		<td  width=20% align=center class=td1 > ���������� </td>");
	sTemp.append(" 		<td width=20% align=center class=td1 >֤������ </td>");
	sTemp.append(" 		<td width=15% align=center class=td1 > ���ʷ�ʽ </td>");
	sTemp.append(" 		<td width=15% align=center class=td1 >���ʽ���Ԫ ����ң�</td>");
	sTemp.append(" 		<td width=10% align=center class=td1 >ռ�ȣ�%��</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >����ʱ��</td>");
	sTemp.append(" 	</tr>");
	
    //--------------------- ȡ�ɶ���Ϣ-----------------------
    String sCertID ="";   //֤������
	String sCustomerName = "";    //�ɶ�����
	String sRelationShipName = "";    //���ʷ�ʽ					
	String sInvestmentProp = "";    //���ʱ���
	double dInvestmentProp = 0.00;											
	String sInvestmentSum = "";    //ʵ��Ͷ�ʽ��	
	double dInvestmentSum=0.0;		
	String sInvestDate = "";    //Ͷ��ʱ��							
	//�����˻�����Ϣ
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerID,CERTID,CustomerName,InvestmentProp,RelationShip,"
								+"getItemName('RelationShip',RelationShip) as RelationShipName, "
								+"nvl(InvestmentSum,0)*getERate(CurrencyType,'01','') as InvestmentSum,InvestDate "
								+"  from CUSTOMER_RELATIVE   where CustomerID = '"+sCustomerID+"'  and RelationShip like '52%'  and length(RelationShip)>2 order by InvestmentSum desc ");
	int j=1;
	while(rs2.next()&&j<4){
		sCertID = rs2.getString(2);
		if(sCertID == null) sCertID=" ";
	
		sCustomerName = rs2.getString(3);
		if(sCustomerName == null) sCustomerName=" ";
		
		sRelationShipName = rs2.getString(6);
		if(sRelationShipName == null) sRelationShipName=" ";
		
		sInvestmentProp = rs2.getString(4);
		if(sInvestmentProp == null) sInvestmentProp="0";
		dInvestmentProp = DataConvert.toDouble(sInvestmentProp);
		
		sInvestmentSum = DataConvert.toMoney(rs2.getDouble(7));
		if(sInvestmentSum == null) sInvestmentSum=" ";
		
		sInvestDate = rs2.getString(8);
		if(sInvestDate == null) sInvestDate=" ";
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td  width=20% align=center class=td1 > "+sCustomerName+"&nbsp; </td>");
	    sTemp.append(" 		<td width=20% align=center class=td1 > "+sCertID+"&nbsp;</td>");
	    sTemp.append(" 		<td width=15% align=center class=td1 >"+sRelationShipName+"&nbsp;</td>");
	    sTemp.append(" 		<td width=15% align=center class=td1 >"+sInvestmentSum+"&nbsp;</td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 >"+dInvestmentProp+"&nbsp;</td>");
	    sTemp.append(" 		<td colspan='2' align=center class=td1 >"+sInvestDate+"&nbsp;</td>");
	    sTemp.append(" 	</tr>");
    	j++;
	}
	rs2.getStatement().close();
    sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.2������˵Ĺ�ȨͶ��������ϲ�����Χ�ڣ� ���֣������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td rowspan='2' width=20% align=center class=td1 > ��Ͷ����ҵ���� </td>");
    sTemp.append(" 		<td rowspan='2' width=20% align=center class=td1 >��֯�������� </td>");
    sTemp.append(" 		<td rowspan='2' width=15% align=center class=td1 > Ͷ�ʽ���Ԫ�� </td>");
    sTemp.append(" 		<td rowspan='2' width=15% align=center class=td1 >�ֹɱ�����%��</td>");
    sTemp.append(" 		<td colspan='3' width=30% align=center class=td1 >Ͷ�����棨��Ԫ��</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td   width=10% align=center class=td1 > ǰһ�� </td>");
    sTemp.append(" 		<td   width=10% align=center class=td1 >ǰ���� </td>");
    sTemp.append(" 		<td   width=10% align=center class=td1 > ǰ����</td>");
    sTemp.append(" 	</tr>");
    
    //--------------------- ��ȨͶ�����-----------------------
   rs2 = Sqlca.getResultSet("select CustomerID,CERTID,CustomerName,InvestmentProp,nvl(InvestmentSum,0)*geterate(CurrencyType,'01','')"
								+"  from CUSTOMER_RELATIVE   where CustomerID = '"+sCustomerID+"'  and RelationShip like '02%'  and length(RelationShip)>2 order by InvestmentSum desc ");
	int k =1;
	while(rs2.next()&&k<4){
		sCertID = rs2.getString(2);
		if(sCertID == null) sCertID=" ";
	
		sCustomerName = rs2.getString(3);
		if(sCustomerName == null) sCustomerName=" ";
		
		sInvestmentProp = rs2.getString(4);
		if(sInvestmentProp == null) sInvestmentProp="0";
		dInvestmentProp = DataConvert.toDouble(sInvestmentProp);
		
		sInvestmentSum = DataConvert.toMoney(rs2.getDouble(5));
		if(sInvestmentSum == null) sInvestmentSum="0";
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td  width=20% align=center class=td1 > "+sCustomerName+"&nbsp; </td>");
	    sTemp.append(" 		<td width=20% align=center class=td1 > "+sCertID+"&nbsp;</td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 >"+sInvestmentSum+"&nbsp;</td>");
	    sTemp.append(" 		<td width=15% align=center class=td1 >"+dInvestmentProp+"&nbsp;</td>");
	    for(int num=1;num<4;num++){
	    	String name = "describe"+num*k;
   	  		sTemp.append("   <td align=left class=td1 >");
  			sTemp.append(myOutPut("2",sMethod,"name='"+name+"' style='width:100%; height:35'",getUnitData(name,sData)));
			sTemp.append("&nbsp;</td>");
	    }
	    sTemp.append(" 	</tr>");
    	k++;
	}
	rs2.getStatement().close();
	//------------------------ȡ���ſͻ���Ϣ----------------
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.3����˵��������ſͻ���Ϣ</font></td> ");	
	sTemp.append("   </tr>");
     sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan='2' align=center class=td1 > ���Ź�ϵ��ҵ���� </td>");
    sTemp.append(" 		<td colspan='2' align=center class=td1 >��֯�������� </td>");
    sTemp.append(" 		<td colspan='3'align=center class=td1 > �����˹�ϵ</td>");
    sTemp.append(" 	</tr>");
    
    
    rs2 = Sqlca.getResultSet("select CustomerID,CERTID,CustomerName,RelationShip,getItemName('RelationShip',RelationShip) as RelationShipName " 
								+" from CUSTOMER_RELATIVE    where RelativeID <> '"+sCustomerID+"'"  
								+" and CustomerID in  ( select CustomerID from CUSTOMER_RELATIVE  where RelativeID = '"+sCustomerID+"'"
								+"and RelationShip like '04%'  ) and RelationShip like '04%' order by Whethen1 desc");
    int l=1;
	while(rs2.next()&&l<4){
		sCertID = rs2.getString(2);
		if(sCertID == null) sCertID=" ";
	
		sCustomerName = rs2.getString(3);
		if(sCustomerName == null) sCustomerName=" ";
		
		sRelationShipName = rs2.getString(5);
		if(sRelationShipName == null) sRelationShipName=" ";
		
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td  colspan='2' align=center class=td1 > "+sCustomerName+"&nbsp; </td>");
	    sTemp.append(" 		<td colspan='2' align=center class=td1 > "+sCertID+"&nbsp;</td>");
	    sTemp.append(" 		<td colspan='3' align=center class=td1 >"+sRelationShipName+"&nbsp;</td>");
	    sTemp.append(" 	</tr>");
    	l++;
	}
	rs2.getStatement().close();
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
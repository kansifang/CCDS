<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu 2008/09/20
		Tester:
		Content: ���鱨��������
		Input Param:
			SerialNo: �ĵ���ˮ��
			ObjectNo��ҵ����ˮ��
			Method:   ���� 1:display;2:save;3:preview;4:export
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 1;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
	String sRelativeName = "";
	String sInvestmentSum = "";
	String sInvestmentProp = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
		StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='040103.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.1.3����Ӧ��������</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=10% align=center class=td1 >"+" &nbsp;</td>");
  	sTemp.append("   <td width=30% align=center class=td1 > ǰ������Ӧ��  </td>");
    sTemp.append("   <td width=20% align=center class=td1 > ����Ԫ�� </td>");
    sTemp.append("   <td width=25% align=center class=td1 > ռȫ���ɹ����ʣ� </td>");
	sTemp.append("   </tr>");
	String sSql = "select CustomerName,"
				   +"InvestmentSum,InvestmentProp "
				   +"from CUSTOMER_RELATIVE "
				   +"where CustomerID='"+sCustomerID+"' "
			       +"and RelationShip='9901' "
				   +"order by InvestmentProp desc";
				   
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	int j=1;
	while(true)
	{
		if(rs2.next())
		{
			sRelativeName = rs2.getString(1);
			if(sRelativeName == null) sRelativeName = " ";
			sInvestmentSum = DataConvert.toMoney(rs2.getDouble(2));
			sInvestmentProp = DataConvert.toMoney(rs2.getDouble(3));
			sTemp.append("   <tr>");
			sTemp.append("   <td width=10% align=left class=td1 >"+j+"&nbsp; </td>");
	  		sTemp.append("   <td width=30% align=left class=td1 >"+sRelativeName+"&nbsp; </td>");
	    	sTemp.append("   <td width=20% align=right class=td1 >"+sInvestmentSum+"&nbsp;</td>");
	    	sTemp.append("   <td width=25% align=right class=td1 >"+sInvestmentProp+"&nbsp;</td>");
			sTemp.append("   </tr>");
		}
		j++;
		if(j==4) break;
	}
	rs2.getStatement().close();	
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" >�ӹ��������۸񡢼۸��ȶ��ԡ����������ȷ���Թ�Ӧ�̽���������");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
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
			editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ 
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

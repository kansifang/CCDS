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
	int iDescribeCount = 1;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='5' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >������������ҵ���������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='5' align=left class=td1 > �������Ƿ��й�ҵ��������ҵ�����ࣩ����Լ���:"+" "+"&nbsp;</td>");
	sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 colspan='5'> ");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:80'",getUnitData("describe1",sData)));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    String sSumBusinessSum = "";
    double dSumBusinessSum = 0.0;
    String sYear = StringFunction.getToday();
    int sLastYear = DataConvert.toInt(sYear.substring(0,4))-1;
    String sBeginLastYear = String.valueOf(sLastYear)+"/01/01";
    String sEndLastYear = String.valueOf(sLastYear)+"/12/31";
    String sSql = " select sum(BusinessSum*geterate(Businesscurrency,'01',ERateDate)) from BUSINESS_CONTRACT "+
    			  " where CustomerID = '"+sCustomerID+"' and BeginDate between '"+sBeginLastYear+"' and '"+sEndLastYear+"'";
    ASResultSet rs = Sqlca.getASResultSet(sSql);
    if(rs.next()){
    	sSumBusinessSum = rs.getString(1);
    	if(sSumBusinessSum == null) sSumBusinessSum = "0";
    	dSumBusinessSum = DataConvert.toDouble(sSumBusinessSum)/10000;
    }			  
    rs.getStatement().close();
    sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='2' align=left class=td1 > ����������ܶ�(�����)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td colspan='3' align=left class=td1 > "+dSumBusinessSum+"��Ԫ&nbsp;</td>");
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
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   wangdw 2012.05.21
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
	int iDescribeCount = 2;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//��õ��鱨������
	String sBusinessType = "";				//ҵ��Ʒ��
	String sVouchType    = "";				//������ʽ
	double sBusinessSum  = 0.0;				//������
	int sTermMonth	 = 0;					//����
	double sBusinessRate	 = 0.0;				//����
	String sCorPusPayMethod = "";			//���ʽ
	String sSql1="select getBusinessName(BusinessType) as BusinessType,"
		+"getItemName('VouchType',VouchType) as VouchType,BusinessSum,TermMonth,BusinessRate,"
		+"getItemName('CorpusPayMethod2',CorPusPayMethod) as CorPusPayMethod from "
		+"BUSINESS_APPLY where serialno = '"+sObjectNo+"'";
	System.out.println("sql===<><>"+sSql1);
	ASResultSet rs1 = Sqlca.getResultSet(sSql1);
	
	if(rs1.next())
	{
		sBusinessType = rs1.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = " ";
		sVouchType = rs1.getString("VouchType");
		if(sVouchType == null) sVouchType = " ";
		sBusinessSum = rs1.getDouble("BusinessSum");
		sTermMonth = rs1.getInt("TermMonth");
		sBusinessRate = rs1.getDouble("BusinessRate");
		sCorPusPayMethod = rs1.getString("CorPusPayMethod");
		if(sCorPusPayMethod == null) sCorPusPayMethod = " ";
	}	
	rs1.getStatement().close();	
	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='05.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");

    
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.1�� ����ͻ������ۺ����������</font></td>"); 		sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    

	sTemp.append("   <tr>"); 
	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >����˽������������ʵ����ȫ�������˾��л������������ϸ��˴�����������ͬ�⣺");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >");
  	sTemp.append("��1��<u>");
  	sTemp.append(sBusinessType);
  	sTemp.append("</u>��ҵ��Ʒ�֣����������ʽΪ��");
  	sTemp.append(sVouchType);
	sTemp.append("   </td>");
	sTemp.append("   <tr>"); 

	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >");
  	sTemp.append("��2��");
  	sTemp.append("��<u>");
  	sTemp.append(sBusinessSum/10000);
  	sTemp.append("</u>��Ԫ������<u>");
  	sTemp.append(sTermMonth/12);
  	sTemp.append("</u>�ꣻ");
  	sTemp.append("������<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:15%; height:25'",getUnitData("describe0",sData)));
	sTemp.append("</u>%;");
	sTemp.append("   </td>");
	sTemp.append("   <tr>"); 
	
	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >");
  	sTemp.append("��3��");
  	sTemp.append("���ڻ����<u>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:10%; height:25'",getUnitData("describe1",sData)));
  	sTemp.append("</u>Ԫ��");
	sTemp.append("   </td>");
	sTemp.append("   <tr>"); 

	sTemp.append("   <tr>"); 
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >");
  	sTemp.append("��4��");
  	sTemp.append("���ʽ:&nbsp;&nbsp;<u>");
  	sTemp.append(sCorPusPayMethod);
  	sTemp.append("</u>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>"); 

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
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
	int iDescribeCount = 5;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//��õ��鱨������
	String 	sThirdParty1 = "";				//�Ƿ���Ϣ
	double	dFZANBALANCE = 0.0;				//��Ϣ����
	String  sSql1 = "select ThirdParty1,FZANBALANCE from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'";
	ASResultSet rs1 = Sqlca.getResultSet(sSql1);
	if(rs1.next())
	{
		sThirdParty1 = rs1.getString("ThirdParty1");
		if(sThirdParty1 == null) sThirdParty1 = " ";
		dFZANBALANCE = rs1.getDouble("FZANBALANCE");
	}
	rs1.getStatement().close();
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2��������;�͵�һ������Դ����</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1����Ӫ��λ���</font></td>"); 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' colspan=2 align=left class=td1 >��1����λ����</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >ע���ʱ�����Ԫ��</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' colspan=2 align=left class=td1 >��2������ʱ��</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:25'",getUnitData("describe3",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >��Ӫҵ��</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' colspan=20 align=left class=td1 >2.2�����δ����Ƿ�����Ϣ");
  	if(sThirdParty1.equals("1"))
  	{
  		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;��");
  		sTemp.append("&nbsp;��Ϣ����:&nbsp;");
  		sTemp.append(dFZANBALANCE);
  		sTemp.append("%");
  	}else
  	{
  		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;��");
  	}	
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3��������;</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='20' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
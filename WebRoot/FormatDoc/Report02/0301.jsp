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
	int iDescribeCount = 4;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%!
	//��û������ڵķ���
	String getBranchOrgID(String sOrgID,Transaction Sqlca) throws Exception {
		String sUpperOrgID = sOrgID;
		int sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		while (sLevel > 3) {
			sUpperOrgID = Sqlca.getString("select RelativeOrgID from Org_Info where OrgID='"+sOrgID+"'");
			if (sUpperOrgID == null) break;
			sOrgID = sUpperOrgID;
			sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		}
		return sOrgID;
	}
	
%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	String sOrgID = getBranchOrgID(CurOrg.OrgID,Sqlca);
	String sDefaultValue = "",sDirID1 = "false",sDirID2 = "false",sDirID3 = "false",sDirID4 = "false";
	String sSql = "select DefaultValue from FORMATDOC_PARA where orgid = '"+sOrgID+"' and docid = '"+sDocID+"'"; 
	ASResultSet rs2 = Sqlca.getASResultSet(sSql);
	if(rs2.next()) sDefaultValue = rs2.getString(1);
	rs2.getStatement().close();
	StringTokenizer stx = null;
	stx = new StringTokenizer(sDefaultValue,",");
	String sDirID = "";
	while(stx.hasMoreTokens())
	{
		sDirID = stx.nextToken();
		if(sDirID.equals("0301")) sDirID1 = "true";
		if(sDirID.equals("0302")) sDirID2 = "true";
		if(sDirID.equals("0303")) sDirID3 = "true";
		if(sDirID.equals("0304")) sDirID4 = "true";
	}
	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0301.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	if(sMethod.equals("4") && sDirID1.equals("true"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3�������˾�Ӫ�������</font></td>"); 	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.1����������ʷ�ظ�;�Ӫս��</font></td>"); 	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" >������������ʷ�ظ��Ȩ�ṹ�ݱ估���꾭Ӫս�Է�����ش���������ݡ�");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	else if(sMethod.equals("1") || sMethod.equals("2") || sMethod.equals("3"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3�������˾�Ӫ�������</font></td>"); 	
		sTemp.append("   </tr>");
		if(sDirID1.equals("true"))
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.1����������ʷ�ظ�;�Ӫս��(����)</font></td>"); 	
			sTemp.append("   </tr>");
		}
		else
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.1����������ʷ�ظ�;�Ӫս��</font></td>"); 	
			sTemp.append("   </tr>");
		}
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" >������������ʷ�ظ��Ȩ�ṹ�ݱ估���꾭Ӫս�Է�����ش���������ݡ�");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	} 
	
	if(sMethod.equals("4") && sDirID2.equals("true"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.2��������������ҵ����</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > ����������ҵ������ҵ���к�۷�����˵�����ҶԴ���ҵ�����߷��뵼�򣬷��������˵���ҵ��λ�Ͳ�Ʒ���ԣ�������ҵ����ҵ���ߺ������Ŵ������Ƿ�֧�֣�");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	else if(sMethod.equals("1") || sMethod.equals("2") || sMethod.equals("3"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		if(sDirID2.equals("true"))
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.2��������������ҵ����(����)</font></td>"); 	
			sTemp.append("   </tr>");
		}
		else
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.2��������������ҵ����</font></td>"); 	
			sTemp.append("   </tr>");
		}	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > ����������ҵ������ҵ���к�۷�����˵�����ҶԴ���ҵ�����߷��뵼�򣬷��������˵���ҵ��λ�Ͳ�Ʒ���ԣ�������ҵ����ҵ���ߺ������Ŵ������Ƿ�֧�֣�");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	
	if(sMethod.equals("4") && sDirID3.equals("true"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3�������˾�Ӫ������� </font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" ><p>ͨ�����¼�������������˾�Ӫ�������������</p>");
	  	sTemp.append("     <p>1����ҵ��ģ����Ӫҵ��</p>");
	  	sTemp.append("     <p>2�������豸������ˮƽ���Ƚ��Է�����������������ҵ�������з�����������</p>");
	  	sTemp.append("     <p>3����ҵ������������</p>");
	  	sTemp.append("     <p>&nbsp;&nbsp;&nbsp;&nbsp;A��Ҫ�������ֵ��г��ݶ�������Ƶȣ�</p>");
	  	sTemp.append("     <p>&nbsp;&nbsp;&nbsp;&nbsp;B����ҵ�ĺ��ľ������ƣ�������Ҫ����������Ƚϣ�</p>");
	  	sTemp.append("     &nbsp;&nbsp;&nbsp;&nbsp;C����һ���ģ��ҵ�����޷��ṩ���徺�����֡��г���������Ϣ����Ӧ���ط��������˵ľ�Ӫ��ɫ���ڸ���ҵ�еĺ��ľ�������");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	else if(!sMethod.equals("4"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		if(sDirID3.equals("true"))
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3�������˾�Ӫ�������(����) </font></td>"); 	
			sTemp.append("   </tr>");	
		}
		else
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3�������˾�Ӫ������� </font></td>"); 	
			sTemp.append("   </tr>");
		}
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" ><p>ͨ�����¼�������������˾�Ӫ�������������</p>");
	  	sTemp.append("     <p>1����ҵ��ģ����Ӫҵ��</p>");
	  	sTemp.append("     <p>2�������豸������ˮƽ���Ƚ��Է�����������������ҵ�������з�����������</p>");
	  	sTemp.append("     <p>3����ҵ������������</p>");
	  	sTemp.append("     <p>&nbsp;&nbsp;&nbsp;&nbsp;A��Ҫ�������ֵ��г��ݶ�������Ƶȣ�</p>");
	  	sTemp.append("     <p>&nbsp;&nbsp;&nbsp;&nbsp;B����ҵ�ĺ��ľ������ƣ�������Ҫ����������Ƚϣ�</p>");
	  	sTemp.append("     &nbsp;&nbsp;&nbsp;&nbsp;C����һ���ģ��ҵ�����޷��ṩ���徺�����֡��г���������Ϣ����Ӧ���ط��������˵ľ�Ӫ��ɫ���ڸ���ҵ�еĺ��ľ�������");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	
	if(sMethod.equals("4") && sDirID4.equals("true"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.4�������˾�Ӫģʽ����</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > ������������������Ӫģʽ������������ҵ��ԭ�����Ƿ���ڡ���Ʒ�Ƿ���ڡ��Ƿ����ϼӹ����Ƿ����������ó������ҵ�Ƿ�������Ӫ��������Ӫ���Ƿ�չ������ó�׵ȡ�");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	else if(!sMethod.equals("4"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		if(sDirID4.equals("true"))
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.4�������˾�Ӫģʽ����(����)</font></td>"); 	
			sTemp.append("   </tr>");	
		}
		else
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.4�������˾�Ӫģʽ����</font></td>"); 	
			sTemp.append("   </tr>");	
		}
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > ������������������Ӫģʽ������������ҵ��ԭ�����Ƿ���ڡ���Ʒ�Ƿ���ڡ��Ƿ����ϼӹ����Ƿ����������ó������ҵ�Ƿ�������Ӫ��������Ӫ���Ƿ�չ������ó�׵ȡ�");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
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
	editor_generate('describe2');
	editor_generate('describe3');
	editor_generate('describe4');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
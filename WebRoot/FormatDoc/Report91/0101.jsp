<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   wangdw  2012.05.17
		Tester:
		Content: ����ĵ�2ҳ
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
<% 
	sButtons[1][0] = "false";
%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	String sCustomerName = " ";
	//������Ϣ	
	ASResultSet rs1 = Sqlca.getResultSet("select BA.CustomerName,"
										+"getOrgName(BA.OperateOrgID) as OperateOrgName,"
										+"getUserName(BA.OperateUserID) as OperateUserName "
										+"from BUSINESS_APPLY BA where BA.SerialNo='"+sObjectNo+"'");
	if(rs1.next())
	{
		sCustomerName = rs1.getString("CustomerName");
	}
	rs1.getStatement().close();
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0101.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=19 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+"1�����˶Խ����"+sCustomerName+"�ľ�Ӫ�Դ��������뼰�й������Ѿ���ˣ������ʵ��ӳ���£�"+"</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append(" <tr>");	
  	sTemp.append("<td align=left class=td1 >&nbsp;&nbsp;&nbsp;&nbsp;1.1����������˻��������������˴�ҵ���������������ȣ�");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='19' align=left class=td1 >");
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu 20100506
		Tester:
		Content: ����ĵ�0ҳ
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
	int iDescribeCount = 9;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%

	String sCustomerName = Sqlca.getString("Select CustomerName from Customer_Info where CustomerID = '"+sCustomerID+"'");
 %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���ũ������΢С����ҵ<br/>������鱨��</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > �ͻ�����:");
	sTemp.append(" </td>");
	sTemp.append("   <td align=left class=td1 width=80% >"+sCustomerName+"&nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > �걨��λ:");
	sTemp.append(" </td>");
	sTemp.append("   <td align=left class=td1 width=80% >"+CurOrg.OrgName+"&nbsp;</td>");
    sTemp.append("   </tr>");   

	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > ������:");
	sTemp.append(" </td>");
	sTemp.append("   <td align=left class=td1 width=80% >"+CurUser.UserName+"&nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > ��������:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:100'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > �Ϸ��Ϲ������:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > ��ҵ�ſ�:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:100'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
 	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > �������ط���:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:100'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
 	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > �ǲ������ط���:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:100'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
   	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > ��������:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:100'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	   
  	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > ���ŷ��շ���:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:100'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
   	sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > �ۺ�Ч�����:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:100'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > �ۺ�������:");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 width=80% >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:100'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");	
	sTemp.append(" <td colspan=2 align=left class=td1 width=20% > �����ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");	
	sTemp.append(" <td align=left class=td1 width=20% > ��������:");
	sTemp.append(" </td>");
	sTemp.append("   <td align=left class=td1 width=80% >&nbsp;<br/><br/><br/><br/><br/><br/><br/><br/>�����ǩ��:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��");
	sTemp.append(" </td>");
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

<script language="javascript">
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
	editor_generate('describe5');
	editor_generate('describe6');
	editor_generate('describe7');
	editor_generate('describe8');
	editor_generate('describe9');	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

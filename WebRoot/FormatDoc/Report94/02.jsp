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
	int iDescribeCount = 14;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
   //��õ��鱨������
    double dEvaluateModulus = 0.0; //��������ϵ��
    double dVouchModulus = 0.0;  //������ʽϵ��
    double dRiskEvaluate = 0.0;  //���ŷ��ն�
	//�����˻�����Ϣ
	//sVouchModulus1 = Sqlca.getString("select CL.Attribute3 from code_library CL ,BUSINESS_APPLY BA where BA.VouchType =CL.ItemNo and CL.CodeNo='VouchType' and BA.SerialNo ='"+sObjectNo+"'");
	ASResultSet rs2 = Sqlca.getResultSet("select VouchModulus,RiskEvaluate,EvaluateModulus from Risk_Evaluate where ObjectNo ='"+sObjectNo+"' and ObjectType='CreditApply'");
	if(rs2.next())
	{
		dVouchModulus = rs2.getDouble("VouchModulus");
		dRiskEvaluate = rs2.getDouble("RiskEvaluate");
		dEvaluateModulus = rs2.getDouble("EvaluateModulus");
	}
	rs2.getStatement().close();
%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='02.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=20 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4������ҵ�����ŷ��ն�</font></td>"); 	
	sTemp.append("   </tr>");		
	sTemp.append("   <tr>");     	   
    sTemp.append("   <td  colspan=20 align=left class=td1 > ����ҵ�����ŷ��ն�R��<u>"+dRiskEvaluate+"</u>");	
	sTemp.append("   ��������ϵ����<u>"+dEvaluateModulus+"</u>");
	sTemp.append("   ������ʽϵ����<u>"+dVouchModulus+"</u>");
	sTemp.append("   &nbsp;</td>");   
    sTemp.append("   </tr>");
    sTemp.append("  <tr>");	
	sTemp.append("  <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5����ϵͳ��ѯ�������ˡ���ͥĿǰ�����д�������������ѷ���δ����ġ����ڰ����еģ�</font></td>"); 	
	sTemp.append("  </tr>");		
	sTemp.append("  <tr>");
    //sTemp.append("  <td colspan=1 align=left class=td1 >(1)</td>");
    sTemp.append("  <td colspan=10  align=left class=td1 > (1)&nbsp�����ˣ����˴����ۼ��������<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:15%; height:25'",getUnitData("describe0",sData)));
	sTemp.append("</u>��Ԫ��&nbsp&nbsp�ۼƽ������<u>");    	
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:15%; height:25'",getUnitData("describe1",sData)));
	sTemp.append("</u>ƽ���� ");  

	sTemp.append("  <br>");
    //sTemp.append("  <td colspan=1 align=left class=td1 >(2)</td>");
    sTemp.append("  (2)&nbsp��&nbsp&nbspͥ�����˴����ۼ��������<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:15%; height:25'",getUnitData("describe2",sData)));  
	sTemp.append("</u>��Ԫ��&nbsp&nbsp�ۼƽ������<u>");	    
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:15%; height:25'",getUnitData("describe3",sData))); 
	sTemp.append("</u>ƽ���� ");	

    sTemp.append("  <br>");
    sTemp.append("  (3)&nbsp������������¾������<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:15%; height:25'",getUnitData("describe4",sData))); 
    sTemp.append("</u>Ԫ���´����<u>");	
    sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:15%; height:25'",getUnitData("describe5",sData))); 
    sTemp.append("</u>%&nbsp;<br>"); 
    sTemp.append("  &nbsp&nbsp&nbsp&nbsp��ͥ���ݴ���֧��<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:15%; height:25'",getUnitData("describe13",sData))); 
    sTemp.append("</u>Ԫ���ϼ�֧���������<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:15%; height:25'",getUnitData("describe6",sData))); 
    sTemp.append("</u>%&nbsp;<br>"); 
    sTemp.append("  &nbsp&nbsp&nbsp&nbsp��ͥ��ծ�ܶ�<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:15%; height:25'",getUnitData("describe7",sData))); 
    sTemp.append("</u>Ԫ��ȫ��ծ���¾���������������<u>");	
    sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:15%; height:25'",getUnitData("describe8",sData))); 
    sTemp.append("</u>%&nbsp;</td>");     
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1  colspan=10 >ע����������Ϊ��ҵ���ɶ���ʵ�ʿ����˻��ˣ�������ҵһ�������ɷݵģ��ɰ�����ҵ��һ��Ȼ��ֹ���������±�����ҵ�ɷ��䴿����Ӧ��������������˳ֹɱ����������룬�������˵��������˶���������¹�ռ��");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");    
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6������˳ֹ���ҵ�������</font></td>"); 	
	sTemp.append("   </tr>");	
	//sTemp.append("   <tr>");
  	//sTemp.append("   <td width=15% align=left class=td1 "+myShowTips(sMethod)+" >��ȷ����ҵ�񷢷ŵ�ǰ��������Ҫ������������Լ�ȵȣ���������ط�������ע�����");
  	//sTemp.append("   </td>");
    //sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=10  class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:75'",getUnitData("describe9",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");   
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7���������˵��</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1  colspan=10>(1)&nbsp����˼����ͥ�����ʲ����</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td  align=left class=td1  colspan=10>");
  	sTemp.append(myOutPut("1",sMethod,"name='describe10' style='width:100%; height:50'",getUnitData("describe10",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 colspan=10>(2)&nbsp����˼����ͥ������ծ���</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td  align=left class=td1  colspan=10>");
  	sTemp.append(myOutPut("1",sMethod,"name='describe11' style='width:100%; height:50'",getUnitData("describe11",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 colspan=10>(3)&nbsp������Ҫ˵�������</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td  align=left class=td1  colspan=10>");
  	sTemp.append(myOutPut("1",sMethod,"name='describe12' style='width:100%; height:50'",getUnitData("describe12",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("</div>");
	sTemp.append("</table>");	
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
	editor_generate('describe9');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe10');	
	editor_generate('describe11');	
	editor_generate('describe12');	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

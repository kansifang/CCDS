<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: ����ĵ�0301ҳ
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
	int iDescribeCount = 100;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//��õ��鱨������
	//��õ��鱨������
	ASResultSet rs2 = null;
	String sSql = "";
	String sGuarantyLocation = "";//������ַ
	String sGuarantyRightID = "";//������
	String sAboutOtherID1 = "";//����֤��
	String sThirdParty1 = "";//������;
	double dGuarantyAmount = 0;//�������
	String sGuarantyDate = "";//�������
	String sOwnerTime = "";//ʹ������
	
	
	
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0301.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=11 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >������Ѻ�����</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=11  >1.��Ѻ������</td> ");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left  colspan=11  >1.1 ��Ѻ����ϸ");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	
	sTemp.append("   <tr>");
		sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >������ַ </td>");
	    sTemp.append("   <td colspan=2 align=center class=td1 >��Ȩ֤��</td>");
	    sTemp.append("   <td colspan=3 align=center class=td1 >���ء�����Ȩ����Ϣ</td>");
	    sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >�������</td>");
	    sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >�������</td>");
	    sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >�ṹ����</td>");
	    sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >ʹ������</td>");
	    sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >���������</td>");
	 sTemp.append("   </tr>");
	 sTemp.append("   <tr>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >����֤��</td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >����֤��</td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >����ʹ��Ȩ����</td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >������;</td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >������;</td>");
	 sTemp.append("   </tr>");
	 int i=2 ;
	//��ȡ��Ѻ����Ϣ
		sSql = "select GI.GuarantyLocation,GI.GuarantyRightID,GI.AboutOtherID1,"+
				" GI.ThirdParty1,GI.GuarantyAmount,GI.GuarantyDate,OwnerTime  "+
			" from GUARANTY_RELATIVE GR,GUARANTY_INFO GI "+
			" where GR.ObjectType='CreditApply' "+
			" and GR.GuarantyID=GI.GuarantyID and GR.ObjectNo='"+sObjectNo+"' ";
		rs2 = Sqlca.getResultSet(sSql);
		while(rs2.next())
		{	
			sGuarantyLocation =  rs2.getString("GuarantyLocation");//������ַ
			if(sGuarantyLocation==null) sGuarantyLocation="";
			sGuarantyRightID =  rs2.getString("GuarantyRightID");//������
			if(sGuarantyRightID==null) sGuarantyRightID="";
			sAboutOtherID1 =  rs2.getString("AboutOtherID1");//����֤��
			if(sAboutOtherID1==null) sAboutOtherID1="";
			sThirdParty1 =  rs2.getString("ThirdParty1");//������;
			if(sThirdParty1==null) sThirdParty1="";
			dGuarantyAmount =  rs2.getDouble("GuarantyAmount");//�������
			sGuarantyDate =  rs2.getString("GuarantyDate");//�������
			if(sGuarantyDate==null) sGuarantyDate="";
			sOwnerTime =  rs2.getString("OwnerTime");//ʹ������
			if(sOwnerTime==null) sOwnerTime="";
			
			 sTemp.append("   <tr>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sGuarantyLocation+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sGuarantyRightID+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sAboutOtherID1+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >");
			    sTemp.append(myOutPut("2",sMethod,"name='describe"+i+"' style='width:100%;' ",getUnitData("describe"+i,sData))+"");
			    sTemp.append("  </td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sThirdParty1+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >");
			    sTemp.append(myOutPut("2",sMethod,"name='describe"+(i+1)+"' style='width:100%;' ",getUnitData("describe"+(i+1),sData))+"");
			    sTemp.append("  </td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+dGuarantyAmount+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sGuarantyDate+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >");
			    sTemp.append(myOutPut("2",sMethod,"name='describe"+(i+2)+"' style='width:100%;' ",getUnitData("describe"+(i+2),sData))+"");
			    sTemp.append("  </td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sOwnerTime+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >");
			    sTemp.append(myOutPut("2",sMethod,"name='describe"+(i+3)+"' style='width:100%;' ",getUnitData("describe"+(i+3),sData))+"");
			    sTemp.append("  </td>");
			 sTemp.append("   </tr>");
			 i=i+4;
			
		}
		rs2.getStatement().close();
		
	/*
	 sTemp.append("   <tr>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	  	sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	sTemp.append("   </tr>");
	*/
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left  colspan=11  >ע��(1)��Ȩ֤�ţ����ڷ���֤������֤�ֱ����ĵ�������ֱ���д����֤������֤�ţ����ڷ�����������֤��һ�ĵ���������д���ط���Ȩ֤�ţ����ڲ��ܰ�������֤�ĵ���������д����֤�š�<br>"
			+"(2)���ء�����Ȩ����Ϣ������ʹ��Ȩ���Ͱ������á�����ͻ�����������;����סլ����ҵ����ҵ��������סլ�ȣ�������;����סլ����ҵ����ҵ�ȡ�<br>"
			+"(3)�ṹ���Ͱ������ֻ졢ש�졢שľ�ȡ�");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >1.2 ��ȷ�ϵ�Ѻ�����Ƿ���ڲ�Ʒ����취����ȷ�涨�ġ�����ҵ�񲻿�������������;�ǹ�ҵ�õصģ���ҵ����֤�ϵ���;�ǳ����ģ����ػ�ȡ��ʽ�ǻ����ġ��Լ�������;Ϊ���������õء������õص���������� <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe0' style='width:100%; height:150'",getUnitData("describe0",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >1.3 ��������Ϣ��˵����Ѻ���Ƿ���ڹ����˼������˵������Ϣ�����ʴ��������Ƿ���ȡ�ù���Ȩ�˵�ͬ�⡣ <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
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
	editor_generate('describe0');		//��Ҫhtml�༭,input��û��Ҫ 
	editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ 
	
																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


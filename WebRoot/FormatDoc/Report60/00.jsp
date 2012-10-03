<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.18
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
	int iDescribeCount = 25;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader1.jsp"%>

<%
	//��õ��鱨������
	int iDays = 30;
	String sToday = StringFunction.getToday();
	
	String sLawEffectDate = "";
	String sVouchEffectDate = "";
	String sLawEffectDateInfo = "";
	String sVouchEffectDateInfo = "";
	String sBeginString = StringFunction.getRelativeDate(sToday,iDays);
	int dToday = Integer.parseInt(StringFunction.replace(sToday,"/",""));
	int dBeginString = Integer.parseInt(StringFunction.replace(sBeginString,"/",""));
	Calendar calendar1 = new GregorianCalendar(Integer.parseInt(sToday.substring(0,4)),Integer.parseInt(sToday.substring(5,7)),Integer.parseInt(sToday.substring(8,10)));
	String sSql = " select BC.LawEffectDate, BC.VouchEffectDate "+
				  " from MONITOR_REPORT MR,BUSINESS_CONTRACT BC where BC.SerialNo = MR.ObjectNo and MR.SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{	
		sLawEffectDate = rs.getString(1); 
		sVouchEffectDate = rs.getString(2);
	}
	rs.getStatement().close();
	if(sLawEffectDate == null) sLawEffectDate = "";
	if(sVouchEffectDate == null) sVouchEffectDate = "";
	if(!"".equals(sLawEffectDate))
	{
		int dLawEffectDate = Integer.parseInt(StringFunction.replace(sLawEffectDate,"/",""));
		if(dLawEffectDate<dToday)
		{
			Calendar calendar2 = new GregorianCalendar(Integer.parseInt(sLawEffectDate.substring(0,4)),Integer.parseInt(sLawEffectDate.substring(5,7)),Integer.parseInt(sLawEffectDate.substring(8,10)));
			int diff = (int)((calendar1.getTimeInMillis()-calendar2.getTimeInMillis())/1000/60/60/24);
			sLawEffectDateInfo = "����"+diff+"��";
		}
		else if(dBeginString<=dLawEffectDate)
		{
			sLawEffectDateInfo = "��Ч";
		}
		else if(dBeginString>dLawEffectDate)
		{
			sLawEffectDateInfo = "�ж�ʱЧ";
		}
	}
	if(!"".equals(sVouchEffectDate))
	{
		int dVouchEffectDate = Integer.parseInt(StringFunction.replace(sVouchEffectDate,"/",""));
		if(dVouchEffectDate<dToday)
		{
			Calendar calendar2 = new GregorianCalendar(Integer.parseInt(sVouchEffectDate.substring(0,4)),Integer.parseInt(sVouchEffectDate.substring(5,7)),Integer.parseInt(sVouchEffectDate.substring(8,10)));
			int diff = (int)((calendar1.getTimeInMillis()-calendar2.getTimeInMillis())/1000/60/60/24);
			sVouchEffectDateInfo = "����"+diff+"��";
		}
		else if(dBeginString<=dVouchEffectDate)
		{
			sVouchEffectDateInfo = "��Ч";
		}
		else if(dBeginString>dVouchEffectDate)
		{
			sVouchEffectDateInfo = "�ж�ʱЧ";
		}
	}	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���治�������ص��ر���</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >һ���ͻ�����������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >1��������Ӫ��״");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>��ͻ������򲻿ɿ�����ԭ��ͣ�����رգ������ʲ���ծ������׼ʵʩ�Ʋ����沢������������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:80'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >2����Ҫ�ʲ���״");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>��ͻ���Ҫ��Ȩ���̶��ʲ�����ת�á���Ѻ�����ޣ�Ӱ����ϵͳծȨʵ�ֵ������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:80'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >3���߹���Ա��״");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>��ͻ��߹���Ա��������Υ������������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:80'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >4���������");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>��ͻ������漰�ش����ϵȷ��ɾ��ף�Ӱ��ϵͳծȨʵ�ֵ������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:80'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >5���ӷ�ծ���");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>��ͻ������ӷ�����ծ�����ͼ����Ϊ��<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:80'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >6�����ſͻ���������ҵ���");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>����ſͻ���������ҵ�ľ�Ӫ���ʲ�������״���䶯��ϵͳծȨʵ�ֵ�Ӱ�졣<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:80'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >7���Ϲ澭Ӫ״��");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>��ͻ��Ƿ���������Υ�澭Ӫ�ܵ����̡�˰�����������ء�������������ܲ��Ŵ����������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:80'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >8�������ʸ�״��");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>�Ӫҵִ���Ƿ���죬�Ƿ���Ч���Ƿ�ע���������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4'  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:80'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >9���������");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>�����Ӱ��ϵͳծȨʵ�ֵ������</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:80'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");      
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >������֤����������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >1�������������ʸ����");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>�������Ӫҵִ���Ƿ���죬�Ƿ������ҵ��������������۵����������Ƿ�߱������ʸ�<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe10' style='width:100%; height:80'",getUnitData("describe10",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >2�������˾�Ӫ��״");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>�������������Ӫ��������״���������Ƿ�߱�����������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe11' style='width:100%; height:80'",getUnitData("describe11",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >3���������ʲ���״");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>��������ʲ���״�����۵����˵���Ч�ʲ��Ƿ�߱�����������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe12' style='width:100%; height:80'",getUnitData("describe12",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >4������ʱЧ״��");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>�����ʱЧ�Ƿ���Ч����ʱЧ������������ʱЧ�Ƿ����覴úͷ��ɾ��ס�<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe13' style='width:100%; height:80'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >5������������״��������");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>����������ü�¼���Ƿ������ϻ������Ӱ��ϵͳծȨʵ�ֵ������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe14' style='width:100%; height:80'",getUnitData("describe14",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�����֣��ʣ�Ѻ����������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >1���֣��ʣ�Ѻ��ʵ��״��");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>���۵֣��ʣ�Ѻʵ����״�Ƿ���á��Ƿ���ڱ��ʡ���ʧ��������ʧ�������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe15' style='width:100%; height:80'",getUnitData("describe15",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >2���֣��ʣ�Ѻ��Ȩ��״��");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>���۵֣��ʣ�Ѻ��Ȩ���Ƿ���Ч���Ƿ񰴹涨�����˵Ǽ��������Ǽ������Ƿ���ڣ��Ƿ�����˱��գ���Ѻ˳��������ܳ�Ȩ�������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe16' style='width:100%; height:80'",getUnitData("describe16",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >3���֣��ʣ�Ѻ����ּ�ֵ״��");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>�֣��ʣ�Ѻ��������ۻ��г����ʼۣ����������������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe17' style='width:100%; height:80'",getUnitData("describe17",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >4���֣��ʣ�Ѻ��״��");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>���۵֣��ʣ�Ѻ���Ƿ����𺦵֣��ʣ�Ѻ��ʵ�Ȩ������Ϊ���磺ת������֣��ʣ�Ѻ��ظ���Ѻ������ת�á����⡢���ֵ֣��ʣ�Ѻ�����ʹ�֣��ʣ�Ѻ���ֵ���ٵ���Ϊ�������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe18' style='width:100%; height:80'",getUnitData("describe18",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ġ�ʱЧ������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=25% align=left class=td1 >1������ʱЧ��Ч��");
	sTemp.append("   <td width=25% align=left class=td1 >" +sLawEffectDateInfo+"&nbsp;");
	sTemp.append("   <td width=25% align=left class=td1 >2������ʱЧ��Ч��");
	sTemp.append("   <td width=25% align=left class=td1 >" +sVouchEffectDateInfo+"&nbsp;");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >3���ж�ʱЧ��ʩ</font>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>����ڴ���֪ͨ�顢�����������֤����֪ͨ�飬�ֳ���֤���գ��ʼĴ���֤�����˻����գ����ߣ�����֧�������ծ�����Ʋ��������ٲã�������⡢���йز�������ծȨ��Ҫ��ծ�������������ͬ����������������������շ�ʽ�ȡ�<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe19' style='width:100%; height:80'",getUnitData("describe19",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >4����ʱЧ���ȴ�ʩ</font>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>������ϻ򵣱�ʱЧ�󣬲�ȡ�˺��ֲ��ȴ�ʩ��<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe20' style='width:100%; height:80'",getUnitData("describe20",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >5����ʱЧ������</font>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>���ʱЧ���������ˡ�<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe21' style='width:100%; height:80'",getUnitData("describe21",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�塢Ӱ���峥�ķ�������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>�ۺϷ�������Ӱ������峥�ĸ��ַ������ء�<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe22' style='width:100%; height:80'",getUnitData("describe22",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���������ʲ�������Ǳ��</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>�ۺϷ������۲����ʲ�������Ǳ����<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe23' style='width:100%; height:80'",getUnitData("describe23",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ߡ������ʲ������մ��ô�ʩ</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>��ϲ����ʲ�������Ǳ����Ӱ���峥�ķ������أ��ƶ������ʲ������մ��ô�ʩ��˵�����մ�ʩִ�������������⼰��һ���Ĺ����������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe24' style='width:100%; height:80'",getUnitData("describe24",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ˡ��������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>������Ҫ˵�������<font color='red'>(*����)</font></p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4'  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe25' style='width:100%; height:80'",getUnitData("describe25",sData)));
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
	editor_generate('describe2');
	editor_generate('describe3');
	editor_generate('describe4');
	editor_generate('describe5');
	editor_generate('describe6');
	editor_generate('describe7');
	editor_generate('describe8');
	editor_generate('describe9');
	editor_generate('describe10');
	editor_generate('describe11');	
	editor_generate('describe12');	
	editor_generate('describe13');	
	editor_generate('describe14');	
	editor_generate('describe15');	
	editor_generate('describe16');	
	editor_generate('describe17');	
	editor_generate('describe18');	
	editor_generate('describe19');	
	editor_generate('describe20');	
	editor_generate('describe21');	
	editor_generate('describe22');	
	editor_generate('describe23');	
	editor_generate('describe24');	
	editor_generate('describe25');																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


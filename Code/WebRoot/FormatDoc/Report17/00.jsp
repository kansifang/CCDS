<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   Author:   zwhu 2009.08.18
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
	int iDescribeCount = 3;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[0][0] = "true";
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
	String sInputOrgName = "";
	String sCustomerName = "";
	String sBirthday = "";
	String sSex = "";
	String sNativePlace = ""; //������ַ
	String sWorkCorp = "";//������λ
	String sUnitKind = "" ;//��ҵ
	String sHeadShip = ""; //ְ��
	String sEduExperience = "" ;//ѧ��
	String sMarriage = "";
	String sPopulationNum = "";//�˿�
	String sFamilyAdd = "";//סַ
	String sMonthIncome = "";//������
	String sFamilyMonthIncome = "";
	String sEvaluateResult = "";//�ͻ��������õȼ�
	int iAge = 0;
	//�����˻�����Ϣ
	sInputOrgName = Sqlca.getString("select getOrgName(InputOrgID) as InputOrgName from business_apply where SerialNo = '"+sObjectNo+"'");
	String sSql = " select getCustomerName(Customerid) as CustomerName,Birthday,getItemName('Sex',Sex) as Sex ,NativePlace,WorkCorp, "+
				  " getItemName('IndustryType',UnitKind) as UnitKind,getItemName('HeadShip',HeadShip) as HeadShip,"+
				  " getItemName('EducationExperience',EduExperience) as EduExperience, getItemName('Marriage',Marriage) as Marriage,"+
				  " PopulationNum,FamilyAdd,YearIncome,FamilyMonthIncome from IND_INFO where CustomerID = '"+sCustomerID+"'";
				  
				  
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName=" ";
		sBirthday = rs2.getString("Birthday");
		if(sBirthday == null) sBirthday=" ";
		sSex = rs2.getString("Sex");
		if(sSex == null) sSex=" ";
		sNativePlace = rs2.getString("NativePlace");
		if(sNativePlace == null) sNativePlace=" ";
		sWorkCorp = rs2.getString("WorkCorp");
		if(sWorkCorp == null) sWorkCorp = "";
		sUnitKind = rs2.getString("UnitKind");
		if(sUnitKind == null) sUnitKind=" ";
		sHeadShip = rs2.getString("HeadShip");
		if(sHeadShip == null) sHeadShip=" ";
		sEduExperience = rs2.getString("EduExperience");
		if(sEduExperience == null) sEduExperience=" ";
		sMarriage = rs2.getString("Marriage");
		if(sMarriage == null) sMarriage=" ";
		sPopulationNum = rs2.getString("PopulationNum");
		if(sPopulationNum == null) sPopulationNum=" ";
		sFamilyAdd = rs2.getString("FamilyAdd");
		if(sFamilyAdd == null) sFamilyAdd=" ";
		sMonthIncome = DataConvert.toMoney(rs2.getDouble("YearIncome")/12);
		sFamilyMonthIncome = DataConvert.toMoney(rs2.getDouble("FamilyMonthIncome"));		
		if(sBirthday != null && !"".equals(sBirthday) && !" ".equals(sBirthday))
		{
			iAge = Integer.parseInt(StringFunction.getToday().substring(0,4))-Integer.parseInt(sBirthday.substring(0,4));
		}		
	}
	rs2.getStatement().close();	
	//��ȡ�ͻ����������������
	sSql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='Customer' "+
	" and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth  desc fetch first 1 rows only ";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sEvaluateResult   = rs.getString("EvaluateResult");
		if(sEvaluateResult == null) sEvaluateResult ="";
	}
	rs.getStatement().close();
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >һ���������</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > �ʱ����� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sInputOrgName+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > ������ </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sInputOrgName+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > �������� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > ���� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+iAge+"&nbsp;</td>");
    sTemp.append(" 	</tr>");    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > �Ա�</td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sSex+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > �������ڵ� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sNativePlace+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > �ֹ�����λ </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sWorkCorp+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > ��ҵ </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sUnitKind+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > ְ�� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sHeadShip+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > ѧ�� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sEduExperience+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=center class=td1 > ����״�� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sMarriage+"&nbsp;</td>");
    sTemp.append(" 		<td width=17% align=center class=td1 > �����˿� </td>");
    sTemp.append(" 		<td width=15% align=left class=td1 >"+sPopulationNum+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > ��סַ </td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sFamilyAdd+"&nbsp;</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ���������� </td>");
    sTemp.append("     <td align=left class=td1 >"+sMonthIncome+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ��ͥ������ </td>");
    sTemp.append("     <td align=left class=td1 >"+sFamilyMonthIncome+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ��ͥ��֧�� </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:'70'",getUnitData("describe1",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > Ӫҵִ�պ� </td>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:'70'",getUnitData("describe2",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > �̻�/��ҵ���� </td>");
  	sTemp.append("   <td colspan='3' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:'70'",getUnitData("describe3",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("	 </tr>");  
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=15% align=center class=td1 > ��������õȼ������� </td>");
  	sTemp.append(" 		<td colspan='3' align=left class=td1 > ϵͳ���������"+sEvaluateResult+" </td>");
    sTemp.append("	 </tr>"); 
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

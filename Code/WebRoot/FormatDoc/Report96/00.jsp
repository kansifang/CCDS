<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   wangdw  2012.05.17
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
	int iDescribeCount = 4;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
	String sCustomerName  = "";			//�������
	String sOrgName       = "";			//������	
	String sUserName  	  = "";			//�ʱ�����
	String sBirthday      = "";			//����
	String sNativePlace   = "";			//������ַ
	String sFAMILYADD	  = "";			//��ס��ַ	
	String sWorkcorp      = "";			//������λ
	String sHeadship      = "";			//ְ��	  				
	String sEduExperience = "";			//ѧ��
	String sMarriage      = "";			//����״��
	String sGUARANTORNAME = "";			//������
	int    child 		  = 0 ;			//��Ů����
	int    iAge       = 0;
	String sSex = "";
	//������Ϣ	
	ASResultSet rs1 = Sqlca.getResultSet("select BA.CustomerName,"
										+"getOrgName(BA.OperateOrgID) as OperateOrgName,"
										+"getUserName(BA.OperateUserID) as OperateUserName "
										+"from BUSINESS_APPLY BA where BA.SerialNo='"+sObjectNo+"'");
	//�ͻ���Ϣ
	ASResultSet rs2 = Sqlca.getResultSet("select II.FAMILYADD,II.Birthday,getItemName('Sex',Sex) as Sex,II.NativePlace,"
										+"II.WORKCORP,getItemName('HeadShip',HeadShip) as HeadShip, "
										+"getItemName('EducationExperience',EduExperience) as EduExperience,"
										+"getItemName('Marriage',Marriage) as Marriage"
										+" from IND_INFO II where II.CUSTOMERID='"+sCustomerID+"'");
	ASResultSet rs3 = Sqlca.getResultSet("select count(*) as Child from customer_relative where RelationShip = '0603' and CustomerID ='"+sCustomerID+"'");

	ASResultSet rs4 = Sqlca.getResultSet("SELECT GUARANTORNAME FROM GUARANTY_CONTRACT GC  WHERE EXISTS "
										+"( SELECT AR.ObjectNo FROM APPLY_RELATIVE AR  WHERE AR.SerialNo = '"+sObjectNo+"' AND "
										+"AR.ObjectType='GuarantyContract' AND AR.ObjectNo = GC.SerialNo) AND ContractStatus = '010'  "
										+"group by GUARANTORNAME");
	if(rs1.next())
	{
		sCustomerName = rs1.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = " ";
		sOrgName = rs1.getString("OperateOrgName");
		if(sOrgName == null) sOrgName = " ";
		sUserName = rs1.getString("OperateUserName");
		if(sUserName == null) sUserName = " ";
		if(sBirthday != null && !"".equals(sBirthday) && !" ".equals(sBirthday))
		{
			iAge = Integer.parseInt(StringFunction.getToday().substring(0,4))-Integer.parseInt(sBirthday.substring(0,4));
		}		
	}
	if(rs2.next())
	{
		sBirthday = rs2.getString("Birthday");
		if(sBirthday == null) sBirthday = " ";
		if(!"".equals(sBirthday) && !" ".equals(sBirthday))
		{
			iAge = Integer.parseInt(StringFunction.getToday().substring(0,4))-Integer.parseInt(sBirthday.substring(0,4));
		}
		sSex = rs2.getString("Sex");
		if(sSex == null) sSex = " ";
		sNativePlace = rs2.getString("NativePlace");
		if(sNativePlace == null) sNativePlace = " ";
		sWorkcorp = rs2.getString("WORKCORP");
		if(sWorkcorp == null) sWorkcorp = " ";
		sHeadship = rs2.getString("HEADSHIP");
		if(sHeadship == null) sHeadship = " ";
		sEduExperience = rs2.getString("EduExperience");
		if(sEduExperience == null) sEduExperience=" ";
		sMarriage = rs2.getString("Marriage");
		if(sMarriage == null) sMarriage=" ";
		sFAMILYADD = rs2.getString("FAMILYADD");
	}
	if(rs3.next()) child = rs3.getInt(1);
	while(rs4.next())
	{
		sGUARANTORNAME = rs4.getString("GUARANTORNAME")+"��"+sGUARANTORNAME;
	}
	rs1.getStatement().close();	
	rs2.getStatement().close();	
	rs3.getStatement().close();
	rs4.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=4 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���˴�����鱨�棨�¸�ʧҵС����</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=15% align=left class=td1 >�ʱ�������</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+sOrgName+"&nbsp;</td>");
  	sTemp.append(" <td width=15% align=left class=td1 >�����У�</td>");
    sTemp.append(" <td colspan='5'  align=left class=td1 >"+sOrgName+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=left class=td1 >�������ˣ�</td>");
    sTemp.append(" <td colspan='5'width=35%  align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
  	sTemp.append(" <td width=15% align=left class=td1 >���估�Ա�</td>");
    sTemp.append(" <td colspan='5' width=35% align=left class=td1 >"+iAge+"/"+sSex+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=left class=td1 >�������ڵأ�</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
    sTemp.append(" &nbsp;</td>");
  	sTemp.append(" <td width=15% align=left class=td1 >ԭ������λ��</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+sWorkcorp+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=left class=td1 >�־�Ӫ��λ��</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData)));
    sTemp.append("&nbsp;</td>");
  	sTemp.append(" <td width=15% align=left class=td1 >ѧ����</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+sEduExperience+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=left class=td1 >����״����</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+sMarriage+"&nbsp;</td>");
  	sTemp.append(" <td width=15% align=left class=td1 >������Ů��</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+child+"&nbsp;</td>");
    sTemp.append(" </tr>");
    
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=left class=td1 >������ַ��</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+sNativePlace+"&nbsp;</td>");
  	sTemp.append(" <td width=15% align=left class=td1 >��ס��ַ��</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+sFAMILYADD+"&nbsp;</td>");
    sTemp.append(" </tr>");

	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=left class=td1 >�����Ͷ����ţ�</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:25'",getUnitData("describe3",sData)));
    sTemp.append("&nbsp;</td>");
  	sTemp.append(" <td width=15% align=left class=td1 >�����Ͷ����ţ�</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
    sTemp.append("&nbsp;</td>");
    sTemp.append(" </tr>");

	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=left class=td1 >�����ˣ�</td>");
    sTemp.append(" <td colspan=20' align=left class=td1 >"+sGUARANTORNAME+"&nbsp;</td>");
    sTemp.append(" </tr>");
    
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


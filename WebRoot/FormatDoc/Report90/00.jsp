<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
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
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
	String sCustomerName = "";       //�ͻ�����
	String sSex = "";                //�Ա�
	String sBirthDay = "";           //���� 
	String sNativePlace = "";        //����
	String sWorkCorp = "";           //������λ
	String sHeadShip = "";           //ְ��
	String sEduExperience = "";      //ѧ��
	String sMarriage = "";           //����״��
	String sOperateOrgName = "";     //������
	String sOrgName = "";            //�ʱ�����
	int iCount = 0 ;                 //������Ů��
	int iOld = 0;                    //����  
	String sOrgID = CurOrg.OrgID;    //��ǰ�û�������
	//��ȡ������Ů����
	iCount = Integer.parseInt(Sqlca.getString("select count(*) as Child from customer_relative where RelationShip = '0603' and CustomerID =(select CustomerID from BUSINESS_APPLY where SerialNo ='"+sObjectNo+"')"));
	//��ȡ�ʱ���������
	sOrgName = Sqlca.getString("select getOrgName('"+sOrgID+"') as sOrgName from ORG_INFO");
	//��ȡ�ͻ�������Ϣ
	ASResultSet rs2 = Sqlca.getResultSet("select FullName,getItemName('Sex1',Sex) as Sex,BirthDay,NativePlace,WorkCorp,getItemName('HeadShip',HeadShip) as HeadShip,getItemName('EducationExperience1',EduExperience) as EduExperience,getItemName('Marriage',Marriage) as Marriage,getOrgName(InputOrgID) as OperateOrgName from IND_INFO where CustomerID=(select CustomerID from BUSINESS_APPLY where SerialNo ='"+sObjectNo+"')");
	if(rs2.next())
	{
		sCustomerName = rs2.getString("FullName");
		if(sCustomerName == null) sCustomerName = "";
		sSex = rs2.getString("Sex");
		if(sSex == null) sSex = " ";
		sBirthDay = rs2.getString("BirthDay");
		if(sBirthDay == null) sBirthDay = "";
		sNativePlace = rs2.getString("NativePlace");
		if(sNativePlace == null) sNativePlace = "";
		sWorkCorp = rs2.getString("WorkCorp");
		if(sWorkCorp == null) sWorkCorp = "";
		sHeadShip = rs2.getString("HeadShip");
		if(sHeadShip == null) sHeadShip = "  ";
		sEduExperience = rs2.getString("EduExperience");
		if(sEduExperience == null) sEduExperience = "";
		sMarriage = rs2.getString("Marriage");
		if(sMarriage == null) sMarriage = "  ";
		sOperateOrgName = rs2.getString("OperateOrgName");
		if(sOperateOrgName == null) sOperateOrgName = "";
	}	
	rs2.getStatement().close();	
	if(!sBirthDay.equals(""))
	{	
	   sBirthDay = sBirthDay.substring(0,4);
	   iOld = Integer.parseInt(StringFunction.getToday().substring(0,4))-Integer.parseInt(sBirthDay);
	}
	//��ȡ�ͻ�����
	//iOld = Integer.parseInt(StringFunction.getToday().substring(0,4))-Integer.parseInt(sBirthDay);
	//select count(*) from customer_relative where RelationShip = '0603' and CustomerID = '2010011300000008'
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();

	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���˴�����鱨��(������)</font></td> ");	
	sTemp.append(" </tr>");	
	sTemp.append(" <tr>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > �ʱ�������</td>");
  	sTemp.append(" <td colspan=2 align=left class=td1 >"+sOrgName+"&nbsp</td>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > �����У�</td>");
    sTemp.append(" <td colspan=2 align=left class=td1 >"+sOperateOrgName+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append(" <tr>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > �������ˣ�</td>");
    sTemp.append(" <td colspan=2 align=left class=td1 >"+sCustomerName+"&nbsp</td>");
    sTemp.append(" <td colspan=3 align=center class=td1 > ���估�Ա�</td>");
    sTemp.append(" <td colspan=2 align=left class=td1 >"+iOld+""+sSex+"&nbsp</td>");
    sTemp.append(" </tr>");
	sTemp.append(" <tr>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > �������ڵأ�</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+sNativePlace+"&nbsp;</td>");
    sTemp.append(" <td colspan=3 align=center class=td1 > ���ڹ�����λ��</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+sWorkCorp+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append(" <tr>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > ְ��</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+sHeadShip+"&nbsp;</td>");
    sTemp.append(" <td colspan=3 align=center class=td1 > ѧ����</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+sEduExperience+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append(" <tr>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > ����״����</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+sMarriage+"&nbsp;</td>");
    sTemp.append(" <td colspan=3 align=center class=td1 > ������Ů��</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+iCount+"&nbsp;</td>");
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


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bqliu 2011-04-29
		Tester:
		Content: ����ĵ�0ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   
				FirstSection: 
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
	//��õ��鱨������
	String sGuarantyNo = "";//������
	ASResultSet rs2 = Sqlca.getResultSet("select GuarantyNo from FORMATDOC_DATA where SerialNo='"+sSerialNo+"' and ObjectNo ='"+sObjectNo+"'");
	if(rs2.next())
	{
		sGuarantyNo = rs2.getString(1);
	}
	rs2.getStatement().close();	
	
	
	String sSql = "select getItemName('GuarantyList',GuarantyType) as GuarantyTypeName,GuarantyID,"+
				  "GuarantyName,OwnerName,GuarantyDescribe2,GuarantyPrice,BeginDate,GuarantyAmount,"+
				  "ThirdParty3,getItemName('YesNo',Flag1) as Flag1,EvalNetValue,getOrgName(InputOrgID) as GuarantyRegOrg,ConfirmValue,GuarantyRate "+
				  "from GUARANTY_INFO where GuarantyID = '"+sGuarantyNo+"'";
	
	String sGuarantyTypeName = "";	//��Ѻ�����
	String sGuarantyID = "";		//��Ѻ����
	String sGuarantyName = "";		//��Ѻ������
	String sOwnerName = "";			//��Ѻ�������Ȩ��
	String sEvalNetValue = "";		//��ʽ������ֵ
	String sGuarantyRegOrg = "";	//��Ѻ��Ǽǻ���
	String sConfirmValue = "";		//����ȷ�ϼ�ֵ
	double dGuarantyRate = 0;		//��Ѻ��
	
	rs2= Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sGuarantyTypeName = rs2.getString("GuarantyTypeName");
		if(sGuarantyTypeName == null) sGuarantyTypeName = "";
		
		sGuarantyID = rs2.getString("GuarantyID");
		if(sGuarantyID == null) sGuarantyID = "";
		
		sGuarantyName = rs2.getString("GuarantyName");
		if(sGuarantyName == null) sGuarantyName = "";
		
		sOwnerName = rs2.getString("OwnerName");
		if(sOwnerName == null) sOwnerName = "";
		
		sEvalNetValue = DataConvert.toMoney(rs2.getDouble("EvalNetValue")/10000);
		
		sGuarantyRegOrg = rs2.getString("GuarantyRegOrg");
		if(sGuarantyRegOrg == null) sGuarantyRegOrg = "";
		
		sConfirmValue = DataConvert.toMoney(rs2.getDouble("ConfirmValue")/10000);
		
		dGuarantyRate = rs2.getDouble("GuarantyRate");
	}
	rs2.getStatement().close();
	
	//��ñ��
	String sTreeNo = "";
	String sTreeNo1 = "";
	String[] sNo = null;
	String[] sNo2 = null;
	String[] sNo1 = null; 
	int iNo=1,i=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '070_' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo1 += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo2 = sTreeNo1.split(",");
	iNo = sNo2.length;
	
	int j=0; 
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '04%' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	iNo++;
	for(j=0;j<sNo.length;j++)
	{	
		//iNo++;	
		sNo1[j] = "8."+iNo+"."+(j+1);		
	}
	
	sSql = "select TreeNo,DirName from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	String sTreeName = "";
	if(rs2.next()){
		sTreeNo = rs2.getString(1);
		sTreeName = rs2.getString(2);	
	}	
	rs2.getStatement().close();
	for(j=0;j<sNo.length;j++)
	{
		if(sNo[j].equals(sTreeNo))  break;
	}	
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='030601.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=4 ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >��һ���֣��ʣ�Ѻ�������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=25% align=center class=td1 >�֣��ʣ�������&nbsp;</td>");
  	sTemp.append(" <td width=25% align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
  	sTemp.append(" <td width=25% align=center class=td1 >�֣��ʣ�����&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+sGuarantyID+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=25% align=center class=td1 >�֣��ʣ���������&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+sOwnerName+"&nbsp;</td>");
  	sTemp.append(" <td width=25% align=center class=td1 >�֣��ʣ����ֵ����Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+sEvalNetValue+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >�֣��ʣ���Ǽǻ���&nbsp;</td>");
    sTemp.append(" <td colspan=3 align=center class=td1 >"+sGuarantyRegOrg+"&nbsp;</td>");
  	
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=25% align=center class=td1 >����ȷ�ϼ�ֵ����Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+sConfirmValue+"&nbsp;</td>");
  	sTemp.append(" <td width=25% align=center class=td1 >�֣��ʣ�Ѻ�ʣ�%��&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+dGuarantyRate+"&nbsp;</td>");
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


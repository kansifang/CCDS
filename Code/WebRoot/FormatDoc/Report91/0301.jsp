<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   wangdw 2012.05.21
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
	int iDescribeCount = 100;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%

	StringBuffer sTemp=new StringBuffer();

	sTemp.append("<form method='post' action='0301.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3���ڶ�������Դ����</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.1����Ѻ</font></td>"); 	
	sTemp.append("   </tr>");	
	//��õ��鱨������
	String	sGuarantyLocation = "";					//������ϸ��ַ
	String	sGuarantySubType  = "";					//��������
	String  sGuarantyDescribe3= "";					//��������
	String  sGuarantyAmount   = "";					//�������
	String  sEvalNetValue	  = "";					//��Ѻ��������ֵ
	String	sGuarantyRate	  = "";					//��Ѻ��
	String  sGUARANTYTYPE	  = "";					//��Ѻ������
	
	String  sGuarantyName	  = "";					//��Ѻ������
	double dGuarantyAmount 	  = 0.0;
	double dEvalNetValue      = 0.0;
	double dGuarantyRate	  = 0.0;
	int i = 0;
	int j = 0;
	String sql1 = "select GuarantyLocation,"
		+"getItemName('GagaType',GuarantySubType) as GuarantySubType, "
		+" getItemName('GuarantyGroundAttribute1',GuarantyDescribe3) as GuarantyDescribe3,"
		+"GuarantyAmount,EvalNetValue,GuarantyRate from GUARANTY_INFO "
		+"where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where "
		+"ObjectType = 'CreditApply' and ObjectNo = '"+sObjectNo+"' ) and guarantytype = '010010'  Order by UpdateDate";
	//������Ѻ	
	ASResultSet rs1 = Sqlca.getResultSet(sql1);
	while(rs1.next()){
		i++;
		//������ϸ��ַ
		sGuarantyLocation = rs1.getString("GuarantyLocation");
		if(sGuarantyLocation == null) sGuarantyLocation = "";
		//��������
		sGuarantySubType = rs1.getString("GuarantySubType");
		if(sGuarantySubType == null) sGuarantySubType = "";
		//��������
		sGuarantyDescribe3 = rs1.getString("GuarantyDescribe3");
		if(sGuarantyDescribe3 == null) sGuarantyDescribe3 = "";
		//�������
		dGuarantyAmount = rs1.getDouble("GuarantyAmount");
		sGuarantyAmount = DataConvert.toMoney(dGuarantyAmount);
		if(sGuarantyAmount == null) sGuarantyAmount = "";
		//��Ѻ��������ֵ
		dEvalNetValue = rs1.getDouble("EvalNetValue")/10000;
		sEvalNetValue = DataConvert.toMoney(dEvalNetValue);
		if(sEvalNetValue == null) sEvalNetValue = "";
		//��Ѻ��
		dGuarantyRate = rs1.getDouble("GuarantyRate");
		sGuarantyRate = DataConvert.toMoney(dGuarantyRate);
		if(sGuarantyRate == null) sGuarantyRate = "";
		
		sTemp.append("   <tr>");
	  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >�����˵�Ѻ����"+i+"����ַ��<u>");
	  	sTemp.append(sGuarantyLocation);
		sTemp.append("</u>&nbsp&nbsp�������ʣ�<u>");
		sTemp.append(sGuarantySubType);
		sTemp.append("</u>&nbsp&nbsp�������ʣ�<u>");
		sTemp.append(sGuarantyDescribe3);
		sTemp.append("</u>   </td>");
		sTemp.append("   </tr>");

		sTemp.append("   <tr>");
	  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >���������<u>");
		sTemp.append(sGuarantyAmount);
		sTemp.append("</u>�O&nbsp������ֵ��<u>");
		sTemp.append(sEvalNetValue);
		sTemp.append("</u>��Ԫ����Ѻ��Ϊ<u>");
		sTemp.append(sGuarantyRate);
		sTemp.append("</u>%");
		sTemp.append("   </td>");
		sTemp.append("   </tr>");
		
	}

	String sql2 = "select GuarantyName,EvalNetValue,GuarantyRate,getItemName('GuarantyList',GUARANTYTYPE) AS GUARANTYTYPE from GUARANTY_INFO "
		+"where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where "
		+"ObjectType = 'CreditApply' and ObjectNo = '"+sObjectNo+"' ) and guarantytype in "
		+"('010020','010025','010030','010040','010050')  Order by UpdateDate";
	//������Ѻ	
	ASResultSet rs2 = Sqlca.getResultSet(sql2);
	while(rs2.next()){
		j++;
		//��Ѻ������
		sGuarantyName = rs2.getString("GuarantyName");
		sGUARANTYTYPE = rs2.getString("GUARANTYTYPE");
		if(sGuarantyName == null) sGuarantyName = "";
		//��Ѻ��������ֵ
		dEvalNetValue = rs2.getDouble("EvalNetValue")/10000;
		sEvalNetValue = DataConvert.toMoney(dEvalNetValue);
		if(sEvalNetValue == null) sEvalNetValue = "";
		//��Ѻ��
		dGuarantyRate = rs2.getDouble("GuarantyRate");
		sGuarantyRate = DataConvert.toMoney(dGuarantyRate);
		if(sGuarantyRate == null) sGuarantyRate = "";
		sTemp.append("   <tr>");
	  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >������Ѻ"+j+"&nbsp;&nbsp;");
	  	sTemp.append("<u>");
	  	sTemp.append(sGUARANTYTYPE);	
	  	sTemp.append("</u>");
	  	sTemp.append("&nbsp;&nbsp;��Ѻ�����ƣ�<u>");
	  	sTemp.append(myOutPut("2",sMethod,"name='describe"+j+"' style='width:10%; height:25'",getUnitData("describe"+j,sData)));
		sTemp.append("</u>������ֵ��<u>");
		sTemp.append(sEvalNetValue);
		sTemp.append("</u>��Ԫ����Ѻ��Ϊ<u>");
		sTemp.append(sGuarantyRate);
		sTemp.append("</u>%");
		sTemp.append("   </td>");
		sTemp.append("   </tr>");
		
	}	
	rs1.getStatement().close();	
	rs2.getStatement().close();	
	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td height='34'colspan=20  align=left class=td1 >��Ѻ���������������");
  	sTemp.append(myOutPutCheck("3",sMethod,"name='describe0'",getUnitData("describe0",sData),"��Ѻ���������ǿ@��Ѻ���������һ��@��Ѻ�����������"));
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xiongtao  2010.05.26
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
	int iDescribeCount = 42;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	String sOrgFlag = Sqlca.getString("select OrgFlag from Org_Info where orgid = '"+CurOrg.OrgID+"'");
	if(sOrgFlag == null) sOrgFlag = "";
	//�жϸñ����Ƿ����
	sButtons[0][5] = "my_save1()";
	String sSql="select finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next())
	{
		FinishFlag = rs.getString("finishdate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null)
	{
		sButtons[1][0] = "false";
		sButtons[3][0] = "true";
	}
	else
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
	if((CurUser.hasRole("210") && "030".equals(sOrgFlag)) || CurUser.hasRole("410")){
		sButtons[0][0] = "true";
	}
	int iCount = 0 ;
	String sCustomerID = "";
	String sCustomerName = "";
	String sOrgTypeName = "";//��ҵ����
	sSql = " select ObjectNo"+
			" from INSPECT_INFO II"+
			" where II.SerialNo='"+sSerialNo+"'";
	
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sCustomerID=rs.getString(1);
	}
	rs.getStatement().close();
	if(sCustomerID == null) sCustomerID = "";
	sSql = " select getCustomerName(CustomerID) as CustomerName, getItemName('OrgType',OrgType) as OrgTypeName "+
		   " from ENT_INFO where customerID = '"+sCustomerID+"'";
	rs=Sqlca.getResultSet(sSql);
	if(rs.next()){
		sCustomerName = rs.getString("CustomerName");
		sOrgTypeName = rs.getString("OrgTypeName");
	}
	rs.getStatement().close();
	if(sCustomerName == null) sCustomerName = "";
	if(sOrgTypeName == null) sOrgTypeName = "";
	for(int i=2;i<18;i++){
		String sScore = getUnitData("describe"+i*2,sData);
			if(!("".equals(sScore) || sScore == null)){
			if(sScore.endsWith(";")){
				sScore = sScore.substring(0,1);
			}
			iCount += Integer.parseInt(sScore.trim());
		}	
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='15.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=4 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>���ũ������</p>΢С��ҵ�����鱨��</font></td>"); 	
	sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 width=30% align=left class=td1 >�ͻ����ƣ� </td>");
    sTemp.append("   <td colspan=1 width=30% align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 width=20% align=left class=td1 >��ҵ���ͣ�</td>");
	sTemp.append("   <td colspan=1 width=20% align=left class=td1 >"+sOrgTypeName+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >��鷽ʽ��</td>");
	sTemp.append("   <td colspan=1 class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:30'",getUnitData("describe1",sData)));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���ʱ�䣺</td>");
	sTemp.append("   <td colspan=1 class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:30'",getUnitData("describe2",sData)));
	sTemp.append("   &nbsp;</td>");
    sTemp.append("   </tr>");
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >һ�����ѡ���� </td>");
    sTemp.append("   <td colspan=1 align=left class=td1 >�Ƿ��д����</td>");
    sTemp.append("   <td colspan=1 align=left class=td1 >�÷����</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >1����Ҫ�ɶ��Ƿ����仯��5�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe3'",getUnitData("describe3",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe4'",getUnitData("describe4",sData),"0@1@2@3@4@5&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >2����Ȩ�ṹ�Ƿ����仯��3�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe5'",getUnitData("describe5",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe6'",getUnitData("describe6",sData),"0@1@2@3&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >3��Ӫҵִ���Ƿ���죨3�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe7'",getUnitData("describe7",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe8'",getUnitData("describe8",sData),"0@1@2@3&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >4����ҵ��Ӫҵ���Ƿ����仯��5�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe9'",getUnitData("describe9",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe10'",getUnitData("describe10",sData),"0@1@2@3@4@5&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >5�����������˾�Ӫ�����Ƿ����仯��4�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe11'",getUnitData("describe11",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe12'",getUnitData("describe12",sData),"0@1@2@3@4&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >6��ʵ�ʿ������Ƿ���ֻ���Σ����5�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe13'",getUnitData("describe13",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe14'",getUnitData("describe14",sData),"0@1@2@3@4@5&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >7��ʵ�ʿ������Ƿ����ġ��������ɵ���Ϊ��10�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe15'",getUnitData("describe15",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe16'",getUnitData("describe16",sData),"0@1@2@3@4@5@6@7@8@9@10"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >8����������Ҫ������Ա�Ƿ��������4�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe17'",getUnitData("describe17",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe18'",getUnitData("describe18",sData),"0@1@2@3@4&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >9���Ƿ���ۡ�������Ҫ�������ԡ���Ӫ�ԵĹ̶��ʲ���7�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe19'",getUnitData("describe19",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe20'",getUnitData("describe20",sData),"0@1@2@3@4@5@6@7&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >10�������˾�Ӫ�����ͣ�ͣ�10�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe21'",getUnitData("describe21",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe22'",getUnitData("describe22",sData),"0@1@2@3@4@5@6@7@8@9@10"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >11���֣��ʣ�Ѻ���ֵ�Ƿ��½���3�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe23'",getUnitData("describe23",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe24'",getUnitData("describe24",sData),"0@1@2@3&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >12���֣��ʣ�Ѻ���Ƿ�����գ����յ�һ�������Ƿ�<br/>Ϊ���У����ս���Ƿ��ܹ��������д����5�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe25'",getUnitData("describe25",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe26'",getUnitData("describe26",sData),"0@1@2@3@4@5&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >13����֤�˵�����Ը�Ƿ��������仯��10�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe27'",getUnitData("describe27",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe28'",getUnitData("describe28",sData),"0@1@2@3@4@5@6@7@8@9@10"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >14����֤��������Ӫ�Ƿ��������Ƿ���д���������8�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe29'",getUnitData("describe29",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe30'",getUnitData("describe30",sData),"0@1@2@3@4@5@6@7@8&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >15���Ƿ���������������Ӱ�����д��Ϣ�������գ�8�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe31'",getUnitData("describe31",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe32'",getUnitData("describe32",sData),"0@1@2@3@4@5@6@7@8&nbsp;"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=2 align=left class=td1 >16�����������10�֣�</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe33'",getUnitData("describe33",sData),"��@��"));
	sTemp.append("      </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe34'",getUnitData("describe34",sData),"0@1@2@3@4@5@6@7@8@9@10"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=3 align=left class=td1 >�ϼƵ÷�</td>");
    sTemp.append("   <td colspan=1 align=left class=td1 >"+iCount+"&nbsp;</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=4 align=left class=td1 >�ۺϷ���</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=4 align=left class=td1 >1����������</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe35' style='width:100%; height:150'",getUnitData("describe35",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=4 align=left class=td1 >2����ʩ������</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe36' style='width:100%; height:150'",getUnitData("describe36",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");				
	sTemp.append("   <tr>");
    sTemp.append("   <td colspan=4 align=left class=td1 >3����������</td>");
	sTemp.append("   </tr>");
			
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe37' style='width:100%; height:150'",getUnitData("describe37",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1>�ͻ�����ǩ�֣�</td>");
   	sTemp.append("   <td colspan=1 align=left class=td1 ><br>");
	sTemp.append(myOutPut("2",sMethod,"name='describe38' style='width:100%; height:35'",getUnitData("describe38",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1>����:</td>");
   	sTemp.append("   <td colspan=1 align=left class=td1 ><br>");
	sTemp.append(myOutPut("2",sMethod,"name='describe39' style='width:100%; height:35'",getUnitData("describe39",sData)));
	sTemp.append("&nbsp;</td>");	
    sTemp.append("   </tr>");    
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=4 align=left class=td1 >�������г������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe40' style='width:100%; height:150'",getUnitData("describe40",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
    
       
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1>ǩ�֣�</td>");
   	sTemp.append("   <td colspan=1 align=left class=td1 ><br>");
	sTemp.append(myOutPut("2",sMethod,"name='describe41' style='width:100%; height:35'",getUnitData("describe41",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1 align=left class=td1>����:</td>");
   	sTemp.append("   <td colspan=1 align=left class=td1 ><br>");
	sTemp.append(myOutPut("2",sMethod,"name='describe42' style='width:100%; height:35'",getUnitData("describe42",sData)));
	sTemp.append("&nbsp;</td>");	
    sTemp.append("   </tr>");
	
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
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
		editor_generate('describe35');		//��Ҫhtml�༭,input��û��Ҫ
		editor_generate('describe36');		//��Ҫhtml�༭,input��û��Ҫ
		editor_generate('describe37');		//��Ҫhtml�༭,input��û��Ҫ
		editor_generate('describe40');
	<%
		}
	%>	
	function my_cal(){
		iCount = "<%=iCount%>";
		if(iCount<70){
			alert("�˿ͻ�����Ԥ����������ע��������!");
		}
	}
	
	function my_save1()
	{
		reportInfo.target = "mypost0";
		reportInfo.Method.value = "2"; //1:display;2:save;3:preview;4:export
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();	
		sCompID = "BusinessInspect15";//΢С��ҵ�����鱨��
		sCompURL = "/FormatDoc/BusinessInspect/15.jsp";
		sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
		OpenComp(sCompID,sCompURL,sParamString,"TabContentFrame");		
	}
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


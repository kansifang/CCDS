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
	int iDescribeCount = 17;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	String sEvaluateResult="";
	String sSql = "";
	ASResultSet rs = null;
	
	//��ȡ�ͻ����������������
	sSql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='Customer' "+
	" and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth  desc fetch first 1 rows only ";
	rs = Sqlca.getASResultSet(sSql);
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
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��   ��   ��   ��</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '17' width=50px > ����˻����������");
	sTemp.append(" </td>");
	sTemp.append(" <td >��һ����ҵ���������");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		"��ҵ���������꣬��Ӫ�ص㣬ע���ʱ����٣����˴�����˭����Ҫ�ɶ���˭���ɶ��ı������½��н���</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:100'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >����������˺Ϲ��Է�����");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" ������Ƿ��ṩӪҵִ�ա���֯��������֤�������֤����֤���Ƿ���Ϸ��ɹ涨����Ӫҵִ�����ޡ�ʵ�ʾ�Ӫ��Χ�Ƿ���涨��Ӫ��Χһ�µȣ��������Ƿ���ƣ��Ƿ�Ϊ����ָ����������������ǵ�ԭ��</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    

    sTemp.append(" <tr>");
	sTemp.append(" <td  >����������˾�Ӫ�����");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" ��ҵ��Ҫ��Ӫʲô�������ĸ���ҵ�����Ʒ�����������ͣ�Ŀǰ��ҵ����ҵ�еĵ�λ����������Σ���������Ӫ�����Σ�����ҵ�����徭Ӫ��������������ۡ�</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:100'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >���ģ��������ҵ�������������");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" ��ҵ�����������Σ�ǰ����Σ���ҵ�ھ����Ƿ��ң��Խ����ҵ������Ӱ����Ρ�</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:100'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >���壩����Ʒ�м���ҵ������ܣ�");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" �������䣬ѧ������ҵ���飬���˵�����״�������ŵ���������޲�����¼�������м����еĸ��˴��������</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:100'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");     

    sTemp.append(" <tr>");
	sTemp.append(" <td  >�����������еĺ���ǰ����");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:100'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");      
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '8' width=50px > ����˵Ĳ������");
	sTemp.append(" </td>");
	sTemp.append(" <td >��һ����Ҫ����ָ�꣺");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  				"1�������� ����Ҫ�����������ٶ����ֽ���ʵȣ�</p>"+
				"<p>&nbsp;&nbsp;&nbsp;&nbsp;2��ӯ���ԣ���Ҫ������Ӫҵ�������ʡ��������ʡ����ʲ������ʵȣ�</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;3����Ӫ��������Ҫ���������ת�ʡ�Ӧ���ʿ���ת�ʵȣ�</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;4����ծ���� ÿһ��ָ���Ӧ�Ը�ָ�������������</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:100'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >���������ڵ���Ҫ���⣺");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		"ָ��Ĳ����Լ�����������ݵĲ����Խ���˵������������˵�������ŷ����޶�˵����</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:100'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    

    sTemp.append(" <tr>");
	sTemp.append(" <td  >����������״�������жϣ�");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:100'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
	
    
    sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '1' width=50px > ��������õȼ�������");
	sTemp.append(" </td>");
  	sTemp.append("   <td  align=left class=td1 >ϵͳ���������"+sEvaluateResult);
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
    
    
	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '14' width=50px > ������;��������Դ����");
	sTemp.append(" </td>");
	sTemp.append(" <td >��һ����ʷ���������");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		"���е���ʷ���ż�������������е���ʷ���ż����ⵣ����Ŀǰ�Ĵ���״̬�����������ţ���</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe10' style='width:100%; height:100'",getUnitData("describe10",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >������������;��");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		"1�� �����ʽ�����������������ʽ��������з�����Ԥ�Ƶ����۶��Ƿ��ܺ���ҵ����Ľ��ƥ�䣬Ŀǰ�Ƿ��ж����������Ļؿʽ��ʲô�������ļ۸����ȷ���������Ƿ�����ö����Ƿ��Ǻͽ����ҵ�ĳ��ں����Ĺ�ϵ������Ļؿ��¼��Ρ�Ŀǰ�Ƿ�ǩ���˲ɹ���ͬ�����ʽ��ʲô���۸��Ƿ����</p>"+
  		"<p>&nbsp;&nbsp;&nbsp;&nbsp;2�� �̶��ʲ�������ڼ������켰�̶��ʲ�Ͷ��Ĵ������ṩ���У�����Ŀ��������м�Ҫ��������װ��ʱ�䣬����ʱ�䣬��ʽ�ܹ�����������ʱ�估��ʱ�ܲ�������ȣ����Ը���ĿͶ������������������������԰��ֽ������в��㣩�������ڼ�ͨ���ø����̶��ʲ�Ͷ���������������Ƿ��������ƥ�䣬����������Ƿ����</p>"+
  		"<p>&nbsp;&nbsp;&nbsp;&nbsp;3�� ���ش�����������ش����������취ִ�У�����Ŀ�����������������ӺϹ�����飬���Ը����ش������е����Ľ��н��ܣ���Ŀ���������Ƿ���ȫ��ע��ÿһ�����ĵ��ĺţ����ؼ۸�ķ�����</p>"+
  		"<p>&nbsp;&nbsp;&nbsp;&nbsp;4�� ���ز�������������ز������������취ִ�У�����Ŀ���������������Ϲ�����飬֤���Ƿ���ȫ������������٣�ռ�ض��٣���Ŀ��Ͷ���٣��ʽ���γ�룬�Գ����Ϊ���٣�������˾��������Σ������������ʲ��ɶ���λ�Ƿ��нϸߵ����ʣ�������ɶ����м�Ҫ�������翪������Щ¥�̵ȣ���Ŀǰ��Ŀ������Σ�Ԥ�ƺ�ʱ�ⶥ����ʱ��ȡ��������ʱ��ס�����۶��٣����ܱ�¥�̵ıȽϣ���������ǰ����Σ�Ԥ�ƵĿͻ�Ⱥ����Щ��</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe11' style='width:100%; height:100'",getUnitData("describe11",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");    

    sTemp.append(" <tr>");
	sTemp.append(" <td  >������������;�Ϲ��Է�����");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" ������;�Ƿ�����������߹涨���Ƿ��ʱ�������������Ƿ�������й涨</p>"+
		"<p>&nbsp;&nbsp;&nbsp;&nbsp;1�������ʽ�����Ƿ��ṩ��Ӧ��ͬ����ͬ�Ƿ�Ϸ�����</p>"+
		"<p>&nbsp;&nbsp;&nbsp;&nbsp;2����Ŀ������ز�����������ش����������Ƿ��ṩ����ļ������ģ�û������ļ���˵������</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe12' style='width:100%; height:100'",getUnitData("describe12",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >���ģ�������Դ��");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>&nbsp;&nbsp;&nbsp;&nbsp;"+
  		" ������Դ����Щ��ҲӦ���ղ�ͬ�������;������Դ�ķ���</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe13' style='width:100%; height:100'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append(" <tr>");
	sTemp.append(" <td  >���壩����Ŀ�ܹ������д��������棺");
	sTemp.append(" </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe14' style='width:100%; height:100'",getUnitData("describe14",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");     

	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '2' width=50px > �ڶ�������Դ����������");
	sTemp.append(" </td>");
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>��֤�����"+
  				"<p>&nbsp;&nbsp;&nbsp;&nbsp;�����������Ӫ���������������������ü�¼�����ս����ģʽд��</p>"+
				"<p>����Ѻ�����</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;����Ѻ��飨֤�����룬�����ʹ��Ȩ���ͣ���;����ֹ���ڣ�Ŀǰ��״̬�����豸��ע���豸���ͣ�ͨ�û���ר�ã���Ȩ������Ȩ�Ƿ��������Ƿ�����ظ�/�ָ��Ѻ��������ֵ���豸��Ӧע�������ֵ��������������������Ѻ�ʣ��ۺ϶��١�</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;����Ѻ���������ۣ�����������������ֵ�ߵ͵�</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe15' style='width:100%; height:100'",getUnitData("describe15",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
 
 	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '2' width=50px > �ر����˵��");
	sTemp.append(" </td>");
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >"+
  				"<p>&nbsp;&nbsp;&nbsp;&nbsp;˵���˱ʴ�����ڵ�������������Ƿ�ǷϢ���Ƿ�Ϊ���ϴ���������е���������</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe16' style='width:100%; height:100'",getUnitData("describe16",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
 
	sTemp.append(" <tr>");	
	sTemp.append(" <td  rowspan = '2' width=50px > �������������");
	sTemp.append(" </td>");
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >"+
  				"<p>&nbsp;&nbsp;&nbsp;&nbsp;��һ���ۺϹ��ɱ������ŵ����ƺͷ��յ㡣</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;�����������Ҫ�ķ�������������������Ч�ķ��������ƴ�ʩ��</p>"+
 				"<p>&nbsp;&nbsp;&nbsp;&nbsp;�������Ա������ŵķ����Ƿ�ɿأ��Լ�����������ܷ�ƽ��������ȷ���жϣ��ܽ�ó��͹۹����������ۡ����У�</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe17' style='width:100%; height:100'",getUnitData("describe17",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>"); 
	sTemp.append("   <tr>"); 
  	sTemp.append("   <td colspan ='2' align=right class=td1 >�����Ա��"+CurUser.UserName+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	sTemp.append("���ڣ�"+StringFunction.getToday()+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br/><br/><br/></td>");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

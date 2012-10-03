<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu  2010.04.15
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
	int iDescribeCount = 1;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	String sCustomerID = "";
	String sInputOrgName = "";
	String sCustomerName = "";
	String sBusinessSum = "";
    int iTermMonth = 0;
    double dBusinessRate = 0.0;
    String sBusinessTypeName = "";
    String sVouchTypeName = "";
    String sPurpose = "";
    String sSql = "";
    ASResultSet rs = null;
    
    sSql = " select CustomerName,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,"+
    	   " TermMonth,BusinessRate,getBusinessName(BusinessType) as BusinessTypeName,"+
		   " getItemName('VouchType',VouchType) as VouchTypeName,getOrgName(InputOrgID) as InputOrgName,Purpose,CustomerID "+
		   " from Business_Apply where SerialNo = '"+sObjectNo+"'";
    rs = Sqlca.getASResultSet(sSql);
    if(rs.next()){
    	sCustomerName = rs.getString("CustomerName");
    	if(sCustomerName == null) sCustomerName = "";
    	sBusinessSum =  DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
    	if(sBusinessSum == null) sBusinessSum = "";
    	iTermMonth = rs.getInt("TermMonth");
    	dBusinessRate = rs.getDouble("BusinessRate");
    	sBusinessTypeName = rs.getString("BusinessTypeName");
    	if(sBusinessTypeName == null) sBusinessTypeName = "";	
    	sVouchTypeName = rs.getString("VouchTypeName");
    	if(sVouchTypeName == null) sVouchTypeName = "";	
    	sInputOrgName = rs.getString("InputOrgName");
    	if(sInputOrgName == null) sInputOrgName = "";	
    	sPurpose = rs.getString("Purpose");
    	if(sPurpose == null) sPurpose = "";	    
    	sCustomerID = rs.getString("CustomerID");
    	if(sCustomerID == null) sCustomerID = "";	 	    	    	
    }
	rs.getStatement().close();  
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='12.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 bgcolor=#aaaaaa height=40px><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���ũ�������������ίԱ������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>��ţ�"+sObjectNo+" </td>");
    sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >�ʱ��С��磺 </td>");
    sTemp.append("   <td colspan=5 align=left class=td1 >"+sInputOrgName+"&nbsp;</td>");
    sTemp.append("   </tr>");
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >�����ˣ� </td>");
    sTemp.append("   <td colspan=5 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append("   </tr>");  
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 width=15% align=left class=td1 >�������Ԫ����</td>");
	sTemp.append("   <td colspan=1 width=15% align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 width=17% align=left class=td1 >���ޣ��£���</td>");
	sTemp.append("   <td colspan=1 width=18% align=left class=td1 >"+iTermMonth+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 width=18% align=left class=td1 >���ʣ��룩��</td>");
	sTemp.append("   <td colspan=1 width=18% align=left class=td1 >"+dBusinessRate+"&nbsp;</td>");	
    sTemp.append("   </tr>");   
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >ҵ�����ࣺ </td>");
    sTemp.append("   <td colspan=5 align=left class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
    sTemp.append("   </tr>"); 
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1 align=left class=td1 >������ʽ�� </td>");
    sTemp.append("   <td colspan=5 align=left class=td1 >"+sVouchTypeName+"&nbsp;</td>");
    sTemp.append("   </tr>");         
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>���ũ����������������ίԱ����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;���ٿ���&nbsp;&nbsp;&nbsp;�λ��飬�����������Ŀ������飬������£�");
	sTemp.append("   <br/><br/>��ͬ�Ȿ����������<br/>��	δͨ��ԭ��"); 
	sTemp.append("   </td>"); 
    sTemp.append("   </tr>");   
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   </td>");
    sTemp.append("   </tr>"); 
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=right class=td1 height=60px >�����£���&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<br/> ����:"+StringFunction.getToday()+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
    sTemp.append("   </tr>");   
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=40px >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�����ˣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
	"����ˣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
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
	editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
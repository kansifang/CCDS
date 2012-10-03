<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:    zwhu  2010.04.15
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

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
    String sSql = "";
    ASResultSet rs = null;
	double dCount = Sqlca.getDouble(" select count(*) from INSPECT_INFO  where SerialNo='"+sSerialNo+"' and ObjectNO='"+sObjectNo+"'"+
		   							" and ObjectType='"+sObjectType+"' and HtmlData is not null");
	if(dCount == 0){
		sData[2][0] = "describe2";
		sData[2][1] = "1��ȷ�����������Ϸ�����ȫ����Ч��<br/> 2������������ʵ���뾭���з��չ�����ˣ���Ȩǩ����ǩ�ֺ󷽿ɷſ";
	}
	String sCustomerID = "";
	String sInputOrgName = "";
	String sCustomerName = "";
	String sBusinessSum = "";
    int iTermMonth = 0;
    double dBusinessRate = 0.0;
    String sBusinessTypeName = "";
    String sVouchTypeName = "";
    String sFinalBusinessSum = "";
    int iFinalTermMonth = 0;
    double dFinalbusinessRate = 0.0;   
    String sPurpose = "";
    String sTotalBalance = "";
    String sFinalBusinessCurrencyName = "";
    
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
	
	sTotalBalance = DataConvert.toMoney(Sqlca.getDouble(" select sum(nvl(Balance,0)*getERate(BusinessCurrency,'01',ERateDate)) "+
														" from Business_Contract where CustomerID = '"+sCustomerID+"'")); 
	if(sTotalBalance == null) sTotalBalance = "";
	
	String sFinalOpinionSerialNo = Sqlca.getString(" select RelativeSerialNo from flow_task where ObjectNo = '"+sObjectNo+"' and "+
			   									   " ObjectType = '"+sObjectType+"' and PhaseNo ='1000'");	
	if(sFinalOpinionSerialNo == null) sFinalOpinionSerialNo = "";		   									   	
	String sApproveTime = Sqlca.getString(" select EndTime from Flow_Task where SerialNo = '"+sFinalOpinionSerialNo+"'");	
	if(sApproveTime == null) sApproveTime = "";   									   
	sSql = " select getItemName('Currency',BusinessCurrency) as BusinessCurrencyName ,"+
		   " nvl(BusinessSum,0)*getERate(BusinessCurrency,'01','') as BusinessSum,"+
		   " TermMonth,BusinessRate from Flow_Opinion where SerialNo = '"+sFinalOpinionSerialNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sFinalBusinessCurrencyName = rs.getString("BusinessCurrencyName");
		if(sFinalBusinessCurrencyName == null) sFinalBusinessCurrencyName = "";
		sFinalBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
		iFinalTermMonth = rs.getInt("TermMonth");
		dFinalbusinessRate = rs.getDouble("BusinessRate");
	}
	rs.getStatement().close();	   		   									   											
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='11.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 bgcolor=#aaaaaa height=40px><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���ũ����������ҵ������</font></td>"); 	
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
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>��Ȩ��������"+sApproveTime+" ��׼���������£� </td>");
    sTemp.append("   </tr>");   
  	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>�� ����������</td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >����Ʒ�֣�</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���֣�</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >����Ԫ����</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���ޣ��£���</td>");
	sTemp.append("   <td colspan=1 align=left class=td1 >���ʣ��룩��</td>");	
    sTemp.append("   </tr>"); 
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+sFinalBusinessCurrencyName+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+sFinalBusinessSum+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+iFinalTermMonth+"&nbsp;</td>");
	sTemp.append("   <td colspan=1 class=td1 >"+dFinalbusinessRate+"&nbsp;</td>");
    sTemp.append("   </tr>");         
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>�� ������;�� </td>");
    sTemp.append("   </tr>");
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:50%'",getUnitData("describe1",sData)));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>�� ����ϵͳ�������� </td>");
    sTemp.append("   </tr>");
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>"+sTotalBalance+"&nbsp;</td>");
    sTemp.append("   </tr>");    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>�� ������ʽ��</td>");
    sTemp.append("   </tr>");
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>"+sVouchTypeName+"&nbsp;</td>");
    sTemp.append("   </tr>");    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>�� �ڽ�������ǰ������ȷ����ʵ���������� </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");    
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 height=30px>�� Ҫ��</td>");
    sTemp.append("   </tr>");   
 	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
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
	editor_generate('describe2');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe3');		//��Ҫhtml�༭,input��û��Ҫ	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
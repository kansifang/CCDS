<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2011/02/15
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
	int iDescribeCount = 9;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>
<% 
    //���水ť,Ԥ����ť�ɼ���ʶ
    String sViewOnly = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewOnly"));
    String sViewPrint = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewPrint"));
    if(sViewOnly == null) sViewOnly = "";
    if(sViewPrint == null) sViewPrint = "";
    if("".equals(sViewOnly))
	{
		sButtons[0][0] = "true";
	}
	else
	{
		sButtons[0][0] = "false";
	}

   sButtons[1][0] = "true";
%>
<%
    
	//��õ��鱨������
	
	String sInputOrgName = "";//����֧������
	String sInputOrgID = "";//�������
	String sCustomerID = "";//�ͻ�ID
	String sInputDate = "" ;//��������
    String sCustomerName = "";//�ͻ�����
    String sSql = "";
    String sOrgFlag = "";//������ʶ
    String sOpinion1 = "",sOpinion2 = "",sOpinion3 = "",sOpinion4 = "",sOpinion5 = "",sOpinion6 = "";
    //ȡ�����е���Ϣ
	sSql = "select InputDate,getOrgName(InputOrgID) as InputOrgName,InputOrgID,CustomerName "+
	             " from Business_Apply where SerialNo ='"+sObjectNo+"'";
	
    ASResultSet rs2 = Sqlca.getResultSet(sSql);
    if(rs2.next()){
    	
    	sInputDate = rs2.getString("InputDate");
    	if(sInputDate == null) sInputDate="XXXX/XX/XX";
    	sInputOrgName = rs2.getString("InputOrgName");
    	if(sInputOrgName == null) sInputOrgName=" ";
    	sInputOrgID = rs2.getString("InputOrgID");
    	if(sInputOrgID == null) sInputOrgID="";
    	sCustomerName = rs2.getString("CustomerName");
    	if(sCustomerName == null) sCustomerName="";
    }
    rs2.getStatement().close();
    
    //��ȡ�����������
    sSql = "select OrgFlag from ORG_INFO where OrgID='"+sInputOrgID+"'  ";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{	
		sOrgFlag = rs2.getString("OrgFlag");
    	if(sOrgFlag == null) sOrgFlag="";
	}
	rs2.getStatement().close();

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=8 bgcolor=#aaaaaa>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <font style=' font-size: 25pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >&nbsp;&nbsp;&nbsp;���ũ���������ŷ������������</font>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   �걨֧�У�"+sInputOrgName+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�������ڣ�"+sInputDate.substring(0,4)+"��"+sInputDate.substring(5,7)+"��"+sInputDate.substring(8,10)+"��");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center height=30 class=td1 >֧������");
	sTemp.append("   </td>");
	sTemp.append("   <td colspan=6 align=left height=30 class=td1>&nbsp;"+sInputOrgName);
	sTemp.append("   ");
	sTemp.append("  </td>");
    sTemp.append("   </tr>"); 
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center height=30 class=td1 >�ͻ�����");
	sTemp.append("   </td>");
	sTemp.append("   <td colspan=6 align=left height=30 class=td1>&nbsp;"+sCustomerName);
	sTemp.append("   ");
	sTemp.append("  </td>");
    sTemp.append("   </tr>"); 
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 >�����������");
	sTemp.append("   </td>");
	sTemp.append("   <td colspan=6 align=left class=td1>&nbsp;");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150; ' align=center",getUnitData("describe1",sData)));
	sTemp.append("  </td>");
    sTemp.append("   </tr>"); 
    
    //��ȡ����ͻ��������
    sSql = "select fo.phaseopinion from flow_task ft ,flow_opinion fo "+
	    " where ft.serialno=fo.serialno and ft.objectno='"+sObjectNo+"' "+
	    " and ft.PhaseNo='0010' order by ft.serialno fetch first 1 row only ";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{	
		sOpinion1=rs2.getString(1);
		if(sOpinion1==null) sOpinion1="";
	}
	rs2.getStatement().close();
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 >����ͻ����������ǩ��");
	sTemp.append("   </td>");
	sTemp.append("   <td colspan=6 align=left class=td1>&nbsp;"+sOpinion1);
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ����");
	sTemp.append("   <br>");
	sTemp.append("   </tr>"); 
	
	//��ȡЭ��ͻ��������
    sSql = "select fo.phaseopinion from flow_task ft ,flow_opinion fo "+
	    " where ft.serialno=fo.serialno and ft.objectno='"+sObjectNo+"' "+
	    " and ft.PhaseNo='0020' order by ft.serialno fetch first 1 row only ";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sOpinion2=rs2.getString(1);
		if(sOpinion2==null) sOpinion2="";
	}
	rs2.getStatement().close();
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 >Э��ͻ����������ǩ��");
	sTemp.append("   </td>");
	sTemp.append("   <td colspan=6 align=left class=td1>&nbsp;"+sOpinion2);
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ����");
	sTemp.append("   <br>");
	sTemp.append("   </tr>"); 
	
	//��ȡ֧���г����ͻ����ܾ������
    sSql = "select fo.phaseopinion from flow_task ft ,flow_opinion fo "+
	    " where ft.serialno=fo.serialno and ft.objectno='"+sObjectNo+"'"+
	    " and exists(select 1 from user_role where userid=ft.userid "+
	    " and RoleID in('410','210') and  status='1' ) order by ft.serialno fetch first 1 row only ";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{	
		sOpinion3=rs2.getString(1);
		if(sOpinion3==null) sOpinion3="";
	}
	rs2.getStatement().close();
	sTemp.append("   <tr>");
	if("030".equals(sOrgFlag)||"9900".equals(sInputOrgID))//�����ֱ��֧������ʾ�������л���
	{
		sTemp.append("   <td colspan=2 align=center class=td1 >֧���г����ͻ����ܾ��������ǩ��");
		sTemp.append("   </td>");
	}else{

		sTemp.append("   <td colspan=2 align=center class=td1 >֧���г������ǩ��");
		sTemp.append("   </td>");
	}
	sTemp.append("   <td colspan=6 align=left class=td1>&nbsp;"+sOpinion3);
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ����");
	sTemp.append("   <br>");
	sTemp.append("   </tr>");
	
    
    if(!"030".equals(sOrgFlag)&&!"9900".equals(sInputOrgID))//�������ֱ��֧������ʾ�������л���
    {
    	//��ȡ����֧�������Ա������
       sSql = "select fo.phaseopinion from flow_task ft ,flow_opinion fo "+
	    " where ft.serialno=fo.serialno and ft.objectno='"+sObjectNo+"' "+
	    " and exists(select 1 from user_role where userid=ft.userid "+
	    " and RoleID in('2B3','2B7','2C3') and  status='1' ) order by ft.serialno fetch first 1 row only ";
    	rs2 = Sqlca.getResultSet(sSql);
    	if(rs2.next())
    	{
    		sOpinion4=rs2.getString(1);
    		if(sOpinion4==null) sOpinion4="";
    	}
    	rs2.getStatement().close();
    	sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=center class=td1 >����֧�������Ա�����ǩ��");
		sTemp.append("   </td>");
		sTemp.append("   <td colspan=6 align=left class=td1>&nbsp;"+sOpinion4);
		sTemp.append("   <br>");
		sTemp.append("   <br>");
		sTemp.append("   <br>");
		sTemp.append("   <br>");
		sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ����");
		sTemp.append("   <br>");
		sTemp.append("   </tr>"); 
    	
    	//��ȡ����֧�����������������
        sSql = "select fo.phaseopinion from flow_task ft ,flow_opinion fo "+
	    " where ft.serialno=fo.serialno and ft.objectno='"+sObjectNo+"'"+
	    " and exists(select 1 from user_role where userid=ft.userid "+
	    " and RoleID in('2B1') and  status='1' ) order by ft.serialno fetch first 1 row only ";
    	rs2 = Sqlca.getResultSet(sSql);
    	if(rs2.next())
    	{
    		sOpinion5=rs2.getString(1);
    		if(sOpinion5==null) sOpinion5="";
       	}
    	rs2.getStatement().close();
    	sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=center class=td1 >����֧�������������������ǩ��");
		sTemp.append("   </td>");
		sTemp.append("   <td colspan=6 align=left class=td1>&nbsp;"+sOpinion5);
		sTemp.append("   <br>");
		sTemp.append("   <br>");
		sTemp.append("   <br>");
		sTemp.append("   <br>");
		sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ����");
		sTemp.append("   <br>");
		sTemp.append("   </tr>"); 
		    
	    //��ȡ����֧�зֹܷ��ո��г����
	    sSql = "select fo.phaseopinion from flow_task ft ,flow_opinion fo "+
	    " where ft.serialno=fo.serialno and ft.objectno='"+sObjectNo+"'"+
	    "  and exists(select 1 from user_role where userid=ft.userid "+
	    " and RoleID in('208') and  status='1' ) order by ft.serialno fetch first 1 row only ";
	   	rs2 = Sqlca.getResultSet(sSql);
	    if(rs2.next())
	    {
	    	sOpinion6=rs2.getString(1);
			if(sOpinion6==null) sOpinion6=""; 
	     }
	    rs2.getStatement().close();
	    sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=center class=td1 >����֧�зֹܷ��ո��г������ǩ��");
		sTemp.append("   </td>");
		sTemp.append("   <td colspan=6 align=left class=td1>&nbsp;"+sOpinion6);
		sTemp.append("   <br>");
		sTemp.append("   <br>");
		sTemp.append("   <br>");
		sTemp.append("   <br>");
		sTemp.append("  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ�£�");
		sTemp.append("   <br>");
		sTemp.append("   </tr>");
    }
    
    
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
	//editor_generate('describe1');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

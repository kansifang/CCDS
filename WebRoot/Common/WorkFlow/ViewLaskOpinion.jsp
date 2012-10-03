<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 *�鿴����������� 2010-4-6 lpzhang
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//��ȡҳ�����
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
    String sObjectNo= DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sCurFlowNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("FlowNo"));
	String sCurPhaseNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("PhaseNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType==null)sObjectType="";
	if(sObjectNo==null)sObjectNo="";
	if(sCurFlowNo==null)sCurFlowNo="";
	if(sCurPhaseNo==null)sCurPhaseNo="";
	
    String sSql="",sLaskFlowSerialNo="",sBASerialNo ="";

	int iCountRecord=0;//�����жϼ�¼�Ƿ����������

	ASResultSet rs = null;

	//��ѯ������ˮ��
	sSql = " select RelativeSerialNo from Business_Contract where SerialNo = "+
           " (select ContractSerialNo From Business_PutOut where SerialNo ='" + sObjectNo + "' ) ";
	sBASerialNo= Sqlca.getString(sSql);
	if(sBASerialNo==null) sBASerialNo="";
	//����
	if("CreditApproveApply".equals(sObjectType))
	{
		sBASerialNo = sObjectNo;
	}
	//��ȡ���������˵�������ˮ
	sSql = 	" select SerialNo from Flow_Task "+
			" where  SerialNo =( select RelativeSerialNo  from Flow_Task where PhaseNo in('1000','8000') and ObjectNo='" + sBASerialNo + "' and ObjectType='CreditApply')"+ 
			" and ObjectNo='" + sBASerialNo + "' "+
			" and ObjectType='CreditApply' ";

    sLaskFlowSerialNo= Sqlca.getString(sSql);
	
	
	//������Ա��������� FLOW_OPINION �� ,�����Ҫ��ʾһЩ���������Ҫ�޸�ǩ����������������
	//FLOW_MODEL��ӵĶ�������鿴Ȩ�޵��жϣ�ͨ�� Attribute2,
	sSql = 	" select FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction,FT.BeginTime, "+
			" FT.EndTime,getItemName('PhaseChoice',FO.PhaseChoice) as PhaseChoice,FO.PhaseOpinion,FO.PhaseOpinion1,FO.PhaseOpinion2,FO.PhaseOpinion3, "+
			" FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles, "+
			" FO.BusinessSum,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName,FO.TermMonth,FO.TermDay, "+
			" FO.BaseRate,getItemName('RateFloatType',FO.RateFloatType) as RateFloatTypeName ,FO.RateFloat,FO.BusinessRate,FO.BailSum,"+
			" FO.BailRatio,FO.PdgRatio,FO.PdgSum"+
			" from FLOW_TASK FT,FLOW_OPINION FO,FLOW_MODEL FM "+
			" where FT.Serialno=FO.SerialNo "+
			" and FT.FlowNo=FM.FlowNo "+
			" and FT.PhaseNo=FM.PhaseNo "+
			" and (FO.PhaseOpinion is not null) "+
			" and FT.ObjectNo='" + sBASerialNo + "' "+
			" and FT.ObjectType='CreditApply' " +
			" and FT.SerialNo = '"+sLaskFlowSerialNo+"'";
	
	rs=Sqlca.getASResultSet(sSql);
%>
<html>
<head>
<title>��������</title>
</head>
<body leftmargin="0" topmargin="0" class="pagebackground">
  <table width="100%" cellpadding="3" cellspacing="0" border="0" >
    <%
        
        while (rs.next())
        {
			
			iCountRecord++;						
    %>
    <tr>
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr>
            <td colspan=2 bgcolor="#CCCCCC">
                <b>�׶�����:</b><%=DataConvert.toString(rs.getString("PhaseName"))%>&nbsp;&nbsp;
                <b>������:</b><%=DataConvert.toString(rs.getString("UserName"))%>&nbsp;&nbsp;
                <b>��������������:</b><%=DataConvert.toString(rs.getString("OrgName"))%>&nbsp;&nbsp;
            </td>
        </tr>
        <tr>
            <td width=50%><b>�յ�ʱ��:</b><%=DataConvert.toString(rs.getString("BeginTime"))%>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(rs.getString("EndTime"))%></td>
        </tr>
        
        <tr>
            <td width=50%><b>�������:</b><%=DataConvert.toString(rs.getString("PhaseChoice"))%>
            <td width=50%></td>
        </tr>
                <tr>            
			<td width=50%><b>ҵ�����:</b><%=DataConvert.toString(rs.getString("BusinessCurrencyName"))%></td>
            <td width=50%><b>������(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%></td>
        </tr>
        <tr>            
			<td width=50%><b>����(��):</b><%=rs.getInt("TermMonth")%></td>
            <td width=50%><b>��(��):</b><%=rs.getInt("TermDay")%></td>
        </tr>
        <tr>            
			<td width=50%><b>��׼������(%):</b><%=rs.getDouble("BaseRate")%></td>
            <td width=50%><b>���ʸ�����ʽ:</b><%=DataConvert.toString(rs.getString("RateFloatTypeName"))%></td>
        </tr>
        <tr>            
			<td width=50%><b>���ʸ���ֵ:</b><%=rs.getDouble("RateFloat")%></td>
            <td width=50%><b>ִ��������(��):</b><%=rs.getDouble("BusinessRate")%></td>
        </tr>
        <tr>            
			<td width=50%><b>��֤����(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("BailSum"))%></td>
            <td width=50%><b>��֤�����(%):</b><%=rs.getDouble("BailRatio")%></td>
        </tr>
        <tr>            
			<td width=50%><b>�����ѽ��(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("PdgSum"))%></td>
            <td width=50%><b>��������(��):</b><%=rs.getDouble("PdgRatio")%></td>
        </tr>
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n�����˵����"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            </td>
        </tr>        
      </table>
	  </td>
    </tr>
    <tr>
	<td>&nbsp;
	  </td>
    </tr>
    <%
    }
    rs.getStatement().close();
    
    
    %>
 
  </table>
</body>
</html>
<%
	//���û���������û���ҵ���Ӧ�Ķ������Զ��ر�
	if (iCountRecord==0||sObjectNo.equals("")){
%>
<script>
    alert("Ŀǰ��ҵ��δ�������������ܲ鿴�����");
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>
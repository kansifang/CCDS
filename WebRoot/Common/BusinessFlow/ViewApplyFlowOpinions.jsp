<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: byhu 2004.12.21
 * Tester:
 *
 * Content: �鿴��������
 * Input Param:
 *      ObjectType: ��������
 *          CreditApply: ����
 *          ApproveApply: �����������
 *          PutOutApply:  ����
 *      ObjectNo:   ������
 *		FlowNo�����̺�
 *		PhaseNo���׶κ�
 * Output param:
 *
 * History Log: zywei 2006/02/22 ���Ӳ鿴�Լ�ǩ��������������ǩ��
 */%>

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
	
    String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sTempPrivilegePhases="",sPhaseAction="";
	boolean bRolePrivilege = false; //��Щ�׶��ܿ�
	boolean bPhasePrivilege = false;//
	boolean bPhaseMatch = false;//�жϵ�ǰ��������׶��Ƿ��ڶ�Ӧ����Ȩ�׶�

	String sFlowNo = "";
	String sPhaseNo = "";
	String sSelfOpinionPhase = "";
	String sSelfOpinion = "";
	String sPhaseName = "";
	String sUserName = "";
	String sOrgName = "";
	String sBeginTime = "";
	String sEndTime = "";
	String sCustomerName = "";
	String sBusinessType="";
	String sBusinessCurrencyName = "";
	String sRateFloatTypeName = "";
	double dBusinessSum = 0.0;
	double dBaseRate = 0.0;
	double dRateFloat = 0.0;
	double dBusinessRate = 0.0;
	double dBailSum = 0.0;
	double dBailRatio = 0.0;
	double dPromisesFeeRatio = 0.0;
	double dPromisesFeeSum = 0.0;
	double dPdgRatio = 0.0;
	double dPdgSum = 0.0;
	int iTermYear = 0;
	int iTermMonth = 0;
	int iTermDay = 0;
	int iCountRecord=0;//�����жϼ�¼�Ƿ����������

	ASResultSet rs = null;
	//��ȡ����ҵ����Ϣ
	sSql = 	" select BusinessType,getBusinessName(BusinessType) as BusinessTypeName,BillNum,getItemName('OccurType',OccurType) as OccurTypeName, "+
	" getItemName('VouchType',VouchType) as VouchTypeName "+
	" from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sBusinessType = rs.getString("BusinessType");
	}
	rs.getStatement().close();
	
	
	//��ȡ���鿴�Լ�ǩ����������Ӧ�Ľ׶�
	sSql = 	" select Attribute6 from FLOW_MODEL "+
	" where FlowNo = '"+sCurFlowNo+"' "+
	" and PhaseNo = '"+sCurPhaseNo+"' ";
	sSelfOpinionPhase = Sqlca.getString(sSql);
	if(sSelfOpinionPhase == null) sSelfOpinionPhase = "";
	//��ȡ���鿴�Լ�ǩ��������Ϣ
	if(!sSelfOpinionPhase.equals(""))
	{
		sSql =  " select FO.CustomerName,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName, "+
		" FO.BusinessSum,FO.TermYear,FO.TermMonth,FO.TermDay,FO.BaseRate,FO.RateFloat,FO.BusinessRate, "+
		" getItemName('RateFloatType',FO.RateFloatType) as RateFloatTypeName,FO.BailSum,FO.BailRatio,FO.PromisesFeeRatio,FO.PromisesFeeSum, "+
		" FO.PdgRatio,FO.PdgSum,FO.PhaseOpinion,"+ //FO.PhaseOpinion1,FO.PhaseOpinion2,FO.PhaseOpinion3, "+
		" FT.PhaseName,FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime "+
		" from FLOW_TASK FT,FLOW_OPINION FO "+
		" where FT.Serialno=FO.SerialNo "+				
		" and (FO.PhaseOpinion is not null) "+
		" and FO.InputUser = '"+CurUser.UserID+"' "+
		" and FT.ObjectNo='" + sObjectNo + "' "+
		" and FT.ObjectType='"+ sObjectType +"'"+
		" and FT.FlowNo = '"+sCurFlowNo+"' "+
		" and FT.PhaseNo= '"+sCurPhaseNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{			
	sCustomerName = rs.getString("CustomerName");
	sBusinessCurrencyName = rs.getString("BusinessCurrencyName");
	dBusinessSum = rs.getDouble("BusinessSum");
	dBaseRate = rs.getDouble("BaseRate");
	sRateFloatTypeName = rs.getString("RateFloatTypeName");
	dRateFloat = rs.getDouble("RateFloat");
	dBusinessRate = rs.getDouble("BusinessRate");			
	dBailSum = rs.getDouble("BailSum");
	dBailRatio = rs.getDouble("BailRatio");
	dPromisesFeeRatio = rs.getDouble("PromisesFeeRatio");
	dPromisesFeeSum = rs.getDouble("PromisesFeeSum");
	dPdgRatio = rs.getDouble("PdgRatio");
	dPdgSum = rs.getDouble("PdgSum");			
	iTermYear = rs.getInt("TermYear");
	iTermMonth = rs.getInt("TermMonth");
	iTermDay = rs.getInt("TermDay");
	//sSelfOpinion = rs.getString("PhaseOpinion")+"\r\n"+rs.getString("PhaseOpinion1")+"\r\n"+rs.getString("PhaseOpinion2")+"\r\n"+rs.getString("PhaseOpinion3");
	sSelfOpinion = rs.getString("PhaseOpinion");
	sPhaseName = rs.getString("PhaseName");
	sUserName = rs.getString("UserName");
	sOrgName = rs.getString("OrgName");
	sBeginTime = rs.getString("BeginTime");
	sEndTime = rs.getString("EndTime");
	iCountRecord = iCountRecord + 1;
		}
		rs.getStatement().close();
	}
	//������Ա��������� FLOW_OPINION �� ,�����Ҫ��ʾһЩ���������Ҫ�޸�ǩ����������������
	//FLOW_MODEL��ӵĶ�������鿴Ȩ�޵��жϣ�ͨ�� Attribute2,
	sSql = 	" select FO.CustomerName,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName, "+
	" FO.BusinessSum,FO.TermYear,FO.TermMonth,FO.TermDay,FO.BaseRate,FO.RateFloat,FO.BusinessRate, "+
	" getItemName('RateFloatType',FO.RateFloatType) as RateFloatTypeName,FO.BailSum,FO.BailRatio,FO.PromisesFeeRatio,FO.PromisesFeeSum,  "+
	" FO.PdgRatio,FO.PdgSum,FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction, "+
	" FT.BeginTime,FT.EndTime,FT.PhaseChoice,FO.PhaseOpinion,FO.PhaseOpinion1,FO.PhaseOpinion2,FO.PhaseOpinion3, "+
	" FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles "+
	" from FLOW_TASK FT,FLOW_OPINION FO,FLOW_MODEL FM "+
	" where FT.Serialno=FO.SerialNo "+
	" and FT.FlowNo=FM.FlowNo "+
	" and FT.PhaseNo=FM.PhaseNo "+
	" and (FO.PhaseOpinion is not null) "+
	" and FT.ObjectNo='" + sObjectNo + "' "+
	" and FT.ObjectType='"+ sObjectType +"'";
	if(sSelfOpinionPhase.equals(""))
		sSql += " ORDER BY FT.SerialNo";
	else
		sSql += " and FT.PhaseNo <> '"+sSelfOpinionPhase+"' ORDER BY FT.SerialNo";
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
    	sOpinionRightType = rs.getString("OpinionRightType");    //�鿴�����ʽ all_except(�ų�һЩ�׶�) none_except(ѡ��һЩ�׶�)
    	sOpinionRightPhases = rs.getString("OpinionRightPhases");//��ͬ�鿴�����ʽ��Ӧ�Ľ׶�
    	sOpinionRightRoles = rs.getString("OpinionRightRoles");  //����鿴��Ȩ��ɫ
    	sPhaseAction = rs.getString("PhaseAction");
    	//����ֵת��Ϊ���ַ���
    	if(sOpinionRightType == null) sOpinionRightType = "";
    	if(sOpinionRightPhases == null) sOpinionRightPhases = "";
    	if(sOpinionRightRoles == null) sOpinionRightRoles = "";
    	if(sPhaseAction == null) sPhaseAction = "";

    	//1���жϸ��û��Ƿ�ӵ����Ȩ��ɫ
    	if(sOpinionRightRoles.equals("")) bRolePrivilege = false;
    	else{
    		Object[] roles = CurUser.roles.getKeys();
    		for(int i=0;i<roles.length;i++){
    			if(sOpinionRightRoles.indexOf((String)roles[i])>=0){
    				bRolePrivilege = true;
    				break;
    			}
    		}
    	}
    	
    	//2���жϵ�ǰ��������׶��Ƿ���ģ�Ͷ�Ӧ����Ȩ�׶�
    	if(sOpinionRightPhases.equals("")) bPhaseMatch = false;			
    	else{
    		int iCountPhases = StringFunction.getSeparateSum(sOpinionRightPhases,",");
    		
    		String sTempFlowPhase,sTempFlow,sTempPhase;
    		for(int i=0;i<iCountPhases;i++){
    			sTempFlowPhase = StringFunction.getSeparate(sOpinionRightPhases,",",i+1);					
    			if(sTempFlowPhase.indexOf(".")<0) sTempFlowPhase = sCurFlowNo + "." + sTempFlowPhase;					
    			if(sTempFlowPhase.equals(sCurFlowNo+"."+sCurPhaseNo)){
    				bPhaseMatch = true;
    				break;
    			}
    		}
    	}
    	
    	//3�����ݲ鿴�����ʽ�Ĳ�ͬ���ж��Ƿ������ʾ
    	if(sOpinionRightType.equals("") || sOpinionRightType.equals("none_except")){
    		bPhasePrivilege = bPhaseMatch;
    	}else{
    		bPhasePrivilege = !bPhaseMatch;				
    	}
    	
    	//bPhasePrivilege = true; bRolePrivilege = true;
    	//4�������ж��Ƿ���ʾ������������Ҫ��ʾ��������ж���һ�����
    	//���û��Ƿ������Ȩ��ɫ���ý׶�����Ƿ����ڸ�����ɲ鿴�׶Ρ��ý׶��Ƿ�����			
    	if(!bPhasePrivilege && !bRolePrivilege && sPhaseAction.indexOf("��������")<0) continue;
    	iCountRecord++;
    %>
    <tr>
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr>            
			<td width=50%><b>�׶�����:</b><%=DataConvert.toString(rs.getString("PhaseName"))%></td>
            <td width=50%><b>������:</b><%=DataConvert.toString(rs.getString("UserName"))%></td>
        </tr>
        <tr>            
			<td width=50%><b>��������������:</b><%=DataConvert.toString(rs.getString("OrgName"))%></td>
            <td width=50%><b>�ͻ�����:</b><%=DataConvert.toString(rs.getString("CustomerName"))%></td>
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
            <td width=50%><b>ִ��������(%):</b><%=rs.getDouble("BusinessRate")%></td>
        </tr>
        <tr>            
			<td width=50%><b>��֤����(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("BailSum"))%></td>
            <td width=50%><b>��֤�����(%):</b><%=rs.getDouble("BailRatio")%></td>
        </tr>
        <%
        	if(!"2050".equals(sBusinessType.substring(0,4))){
        %>
        <tr>            
			<td width=50%><b>��ŵ�ѽ��(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("PromisesFeeSum"))%></td>
            <td width=50%><b>��ŵ����(%):</b><%=rs.getDouble("PromisesFeeRatio")%></td>
        </tr>
        <%
        	}
        %>
        <tr>            
			<td width=50%><b>�����ѽ��(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("PdgSum"))%></td>
            <td width=50%><b>��������(��):</b><%=rs.getDouble("PdgRatio")%></td>
        </tr>
        <tr>
            <td width=50%><b>�յ�ʱ��:</b><%=DataConvert.toString(rs.getString("BeginTime"))%></td>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(rs.getString("EndTime"))%></td>
        </tr>
        
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n�������"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n") + "\r\n        " +
                     StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion1")).trim(),"\\r\\n","\r\n") + "\r\n        " +
                     StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion2")).trim(),"\\r\\n","\r\n") + "\r\n        " +
                     StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion3")).trim(),"\\r\\n","\r\n")%>
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
        
        //չ�ֱ����������Լ�ǩ������
        if(!sSelfOpinionPhase.equals(""))
        {
    %>
    <tr>
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr>            
			<td width=50%><b>�׶�����:</b><%=DataConvert.toString(sPhaseName)%></td>
            <td width=50%><b>������:</b><%=DataConvert.toString(sUserName)%></td>
        </tr>
        <tr>            
			<td width=50%><b>��������������:</b><%=DataConvert.toString(sOrgName)%></td>
            <td width=50%><b>�ͻ�����:</b><%=DataConvert.toString(sCustomerName)%></td>
        </tr>
        <tr>            
			<td width=50%><b>ҵ�����:</b><%=DataConvert.toString(sBusinessCurrencyName)%></td>
            <td width=50%><b>������(Ԫ):</b><%=dBusinessSum%></td>
        </tr>
        <tr>            
			<td width=50%><b>����(��):</b><%=iTermMonth%></td>
            <td width=50%><b>��(��):</b><%=iTermDay%></td>
        </tr>
        <tr>            
			<td width=50%><b>��׼������(%):</b><%=dBaseRate%></td>
            <td width=50%><b>���ʸ�����ʽ:</b><%=DataConvert.toString(sRateFloatTypeName)%></td>
        </tr>
        <tr>            
			<td width=50%><b>���ʸ���ֵ:</b><%=dRateFloat%></td>
            <td width=50%><b>ִ����(��)����(��):</b><%=dBusinessRate%></td>
        </tr>
        <tr>            
			<td width=50%><b>��֤����(Ԫ):</b><%=dBailSum%></td>
            <td width=50%><b>��֤�����(%):</b><%=dBailRatio%></td>
        </tr>
        <tr>            
			<td width=50%><b>�����ѽ��(Ԫ):</b><%=dPdgSum%></td>
            <td width=50%><b>��������(��):</b><%=dPdgRatio%></td>
        </tr>
        <tr>
            <td width=50%><b>�յ�ʱ��:</b><%=DataConvert.toString(sBeginTime)%>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(sEndTime)%></td>
        </tr>
        
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n�������"+ StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")%>
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
        %>
 
  </table>
</body>
</html>
<%
	//���û���������û���ҵ���Ӧ�Ķ������Զ��ر�
	if (iCountRecord==0||sObjectNo.equals("")){
%>
<script>
    alert("Ŀǰ��ҵ��û�������Բ鿴�����������");
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>
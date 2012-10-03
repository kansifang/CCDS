<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
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
 		IsPrintFlag:��ӡ��ʶ:true false
 * Output param:
 *
 * History Log:  lpzhang �������õȼ������϶���Ϣ 2009-8-25 
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
	String sIsPrintFlag = DataConvert.toRealString(iPostChange,CurPage.getParameter("IsPrintFlag"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType==null)sObjectType="";
	if(sObjectNo==null)sObjectNo="";
	if(sCurFlowNo==null)sCurFlowNo="";
	if(sCurPhaseNo==null)sCurPhaseNo="";
	if(sIsPrintFlag==null)sIsPrintFlag="";
	
    String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sTempPrivilegePhases="",sPhaseAction="";
	boolean bRolePrivilege = false; //��Щ�׶��ܿ�
	boolean bPhasePrivilege = false;//
	boolean bPhaseMatch = false;//�жϵ�ǰ��������׶��Ƿ��ڶ�Ӧ����Ȩ�׶�
	
	String sFinalFlowNo = "";//���ս׶�
	String sFinalRelativeSerialNo = "";//���������׶ι�����ˮ��
	String sFinalUserID = "";//����������
	String sFlowNo = ""; 
	String FOPhaseChoice = "";
	String sSelfOpinionPhase = "";
	String sSelfOpinion = "";
	String sPhaseName = "";
	String sUserName = "";
	String sOrgName = "";
	String sBeginTime = "";
	String sEndTime = "";
	String sCustomerName = "";
	String sApplyCustomerName = "";
	String sBusinessCurrencyName = "";
	String sRateFloatTypeName = "";
	String sCognResult = "";
	String sBusinessTypeName = "";
	String sOccurTypeName = "";
	String sVouchTypeName = "";
	double dBusinessSum = 0.0;
	double dBaseRate = 0.0;
	double dRateFloat = 0.0;
	double dBusinessRate = 0.0;
	double dBailSum = 0.0;
	double dBailRatio = 0.0;
	double dPdgRatio = 0.0;
	double dPdgSum = 0.0;
	int iTermYear = 0;
	int iTermMonth = 0;
	int iTermDay = 0;
	int iCountRecord=0;//�����жϼ�¼�Ƿ����������
	int iRow=0,jRow=0;//���ڱ������
	String sReportType = "";
	double dCount = 0;
	ASResultSet rs = null;
	
	sSql =  " select getBusinessName(BusinessType) as BusinessTypeName,"+
			"CustomerName,getItemName('OccurType',OccurType) as OccurTypeName,"+
			"getItemName('VouchType',VouchType) as VouchTypeName "+
		" from BUSINESS_APPLY where SerialNo='"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sBusinessTypeName = DataConvert.toString(rs.getString("BusinessTypeName"));
		sApplyCustomerName = DataConvert.toString(rs.getString("CustomerName"));
		sOccurTypeName = DataConvert.toString(rs.getString("OccurTypeName"));
		sVouchTypeName = DataConvert.toString(rs.getString("VouchTypeName"));
	}
	rs.getStatement().close();
	
	if("CreditApply".equals(sObjectType) && CurUser.hasRole("0B3")){
		sSql = " select Phaseno,RelativeSerialno from flow_task "+
			   " where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"' and (PhaseNo ='1000' or PhaseNo ='8000')";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sFinalFlowNo = rs.getString("Phaseno");
			if(sFinalFlowNo == null) sFinalFlowNo = "";
			sFinalRelativeSerialNo = rs.getString("RelativeSerialno");
			if(sFinalRelativeSerialNo == null) sFinalRelativeSerialNo = "";
		}	   
		rs.getStatement().close();
		if(!"".equals(sFinalRelativeSerialNo))
			sFinalUserID = Sqlca.getString("select Userid from Flow_task where SerialNo = '"+sFinalRelativeSerialNo+"'");
		if(sFinalUserID == null) sFinalUserID = "";
		dCount = Sqlca.getDouble("select count(*) from User_Role where UserID = '"+sFinalUserID+"' and (RoleID = '012' or RoleID = '0B1')");
		if(dCount>0 && "1000".equals(sFinalFlowNo)){
			sReportType = "11";
		}else if(dCount>0 && "8000".equals(sFinalFlowNo)){
			sReportType = "12";
		}
		if(dCount == 0){
			dCount = Sqlca.getDouble("select count(*) from User_Role where UserID = '"+sFinalUserID+"' and RoleID = '010'");
			if(dCount>0 && "1000".equals(sFinalFlowNo)){
			sReportType = "13";
			}else if(dCount>0 && "8000".equals(sFinalFlowNo)){
				sReportType = "14";
			}
		}
	
	}
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
				" getItemName('RateFloatType',FO.RateFloatType) as RateFloatTypeName,FO.BailSum,FO.BailRatio, getItemName('PhaseChoice',FO.PhaseChoice) as FOPhaseChoice,"+
				" FO.SystemScore as SystemScore,FO.SystemResult as SystemResult,"+//ϵͳ�����÷֣�ϵͳ�������
	 			" FO.CognScore as CognScore,FO.CognResult as CognResult,"+//�˹����֣��˹��������
				" FO.PdgRatio,FO.PdgSum,FO.PhaseOpinion,FT.PhaseName,FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime "+
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
			dPdgRatio = rs.getDouble("PdgRatio");
			dPdgSum = rs.getDouble("PdgSum");			
			iTermYear = rs.getInt("TermYear");
			iTermMonth = rs.getInt("TermMonth");
			iTermDay = rs.getInt("TermDay");
			sSelfOpinion = rs.getString("PhaseOpinion");
			sPhaseName = rs.getString("PhaseName");
			sUserName = rs.getString("UserName");
			sOrgName = rs.getString("OrgName");
			sBeginTime = rs.getString("BeginTime");
			sEndTime = rs.getString("EndTime");
			FOPhaseChoice = rs.getString("FOPhaseChoice");
			iCountRecord = iCountRecord + 1;
		}
		rs.getStatement().close();
	}
	
	//������Ա��������� FLOW_OPINION �� ,�����Ҫ��ʾһЩ���������Ҫ�޸�ǩ����������������
	//FLOW_MODEL��ӵĶ�������鿴Ȩ�޵��жϣ�ͨ�� Attribute2,
	sSql = 	" select FO.CustomerName,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName, "+
			" FO.BusinessSum,FO.TermYear,FO.TermMonth,FO.TermDay,FO.BaseRate,FO.RateFloat,FO.BusinessRate, "+
			" getItemName('RateFloatType',FO.RateFloatType) as RateFloatTypeName,FO.BailSum,FO.BailRatio,getItemName('PhaseChoice',FO.PhaseChoice) as FOPhaseChoice, "+
			" FO.PdgRatio,FO.PdgSum,FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction, "+
			" FT.BeginTime,FT.EndTime,FT.PhaseChoice,FO.PhaseOpinion,FO.PhaseOpinion1,FO.PhaseOpinion2,FO.PhaseOpinion3, "+
			" FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles,"+
			" FO.SystemScore as SystemScore,FO.SystemResult as SystemResult,"+//ϵͳ�����÷֣�ϵͳ�������
 			" FO.CognScore as CognScore,FO.CognResult as CognResult"+//�˹����֣��˹��������
			" from FLOW_TASK FT,FLOW_OPINION FO,FLOW_MODEL FM "+
			" where FT.Serialno=FO.SerialNo "+
			" and FT.FlowNo=FM.FlowNo "+
			" and FT.PhaseNo=FM.PhaseNo ";
	//����ǿͻ������ֻ��ʾ�Լ�����Լ���������������������Ϊ�ڵ���������ʱû����ȷ��sCurPhaseNo���롣2D3
	if(CurUser.hasRole("480")||CurUser.hasRole("280")||CurUser.hasRole("080")||CurUser.hasRole("080")||CurUser.hasRole("2D3") ){
		sSql += "and (FT.UserID='"+CurUser.UserID+"' or FT.PhaseNo='3000' or FT.PhaseNo='0010' or FT.PhaseAction='���'  or FT.PhaseAction='�˻ز�������' or FT.PhaseAction='��׼') ";
	}
	sSql +=	" and ( FT.PhaseNo<='"+sCurPhaseNo+"' or FT.PhaseNo='3000' or FT.PhaseAction='���' or FT.PhaseAction='�˻ز�������' or FT.PhaseAction='��׼') "+//ֻ�ܲ鿴�¼���������ܿ��ϼ����,���Կ��������Ϻ���׼��� add by zrli 
			" and (FO.PhaseOpinion is not null) "+
			" and FT.ObjectNo='" + sObjectNo + "' "+
			" and FT.ObjectType='"+ sObjectType +"'";
	if("true".equals(sIsPrintFlag))
	{
		sSql += "  and FT.OrgID='"+CurOrg.OrgID+"' ";
	}
	if(sSelfOpinionPhase.equals(""))
		sSql += " ORDER BY FT.SerialNo";
	else
		sSql += " and FT.PhaseNo <> '"+sSelfOpinionPhase+"' ORDER BY FT.SerialNo";
	rs=Sqlca.getASResultSet(sSql);
	
	String sButtons[][] = {
		{"false","","Button","��ӡ����","��ӡ����","print()",sResourcesPath},
		{"false","","Button","��ӡ����","��ӡ����","print()",sResourcesPath},
	};
	
	if("1000".equals(sFinalFlowNo) && "CreditApply".equals(sObjectType) && CurUser.hasRole("0B3") && dCount>0 ){
		sButtons[0][0] = "true";
	}else if("8000".equals(sFinalFlowNo) && "CreditApply".equals(sObjectType)&& CurUser.hasRole("0B3") && dCount>0){
		sButtons[0][1] = "true";
	}
%>

<html>
<head>
<title>��������</title>
</head>
<body leftmargin="0" topmargin="0" class="pagebackground">
<form name="opinion">
  <table width="100%" cellpadding="3" cellspacing="0" border="0" >
    	<tr height=1 valign=top id="buttonback" >
		<td colspan=2>
			<table>
				<tr>
					<td>
						&nbsp;
	    		</td>
				<td class="buttonback">
				<% //���������ӡԱ:
					if(CurUser.hasRole("4P1")||CurUser.hasRole("2P1")||CurUser.hasRole("0P1")){ %>
				    	<table>
						<tr>
				  		<td>
							<%=
								HTMLControls.generateButton("��ӡ","��ӡ","spreadsheetPrintout(formatContent());",sResourcesPath)
							%>
						</td> 
						</tr>
				    	</table>
				   <% }%>
				</td>
				</tr>
			</table>
		</td>
	</tr>
	
	
	<tr>
		<td>
			<table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
				<tr> 
					<td width=50%><b>������ˮ��:</b><%=sObjectNo%></td>
					<td width=50%><b>�ͻ�����:</b><%=sApplyCustomerName%></td>
				</tr>
				<tr>            
					<td width=50%><b>��������:</b><%=sOccurTypeName%></td>
					<td width=50%><b>ҵ��Ʒ��:</b><%=sBusinessTypeName%></td>
				</tr> 
				<tr>            
					<td colspan=2 width=50%><b>��Ҫ������ʽ:</b><%=sVouchTypeName%></td>
				</tr>  
			</table>
		</td>
	</tr>
    <%
        
        while (rs.next())
        {
			sOpinionRightType = rs.getString("OpinionRightType");    //�鿴�����ʽ all_except(�ų�һЩ�׶�) none_except(ѡ��һЩ�׶�)
			sOpinionRightPhases = rs.getString("OpinionRightPhases");//��ͬ�鿴�����ʽ��Ӧ�Ľ׶�
			sOpinionRightRoles = rs.getString("OpinionRightRoles");  //����鿴��Ȩ��ɫ
			sPhaseAction = rs.getString("PhaseAction");
			sCognResult = rs.getString("CognResult");//�϶����
			//����ֵת��Ϊ���ַ���
			if(sOpinionRightType == null) sOpinionRightType = "";
			if(sOpinionRightPhases == null) sOpinionRightPhases = "";
			if(sOpinionRightRoles == null) sOpinionRightRoles = "";
			if(sPhaseAction == null) sPhaseAction = "";
			if(sCognResult == null) sCognResult = "";

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
        <tr id=<%=iRow++%>>            
			<td width=50%><b>�׶�����:</b><%=DataConvert.toString(rs.getString("PhaseName"))%><input type=hidden value='�׶����ƣ�<%=DataConvert.toString(rs.getString("PhaseName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>������:</b><%=DataConvert.toString(rs.getString("UserName"))%><input type=hidden value='�����ˣ�<%=DataConvert.toString(rs.getString("UserName"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>��������������:</b><%=DataConvert.toString(rs.getString("OrgName"))%><input type=hidden value='��������������:<%=DataConvert.toString(rs.getString("OrgName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>�ͻ�����:</b><%=DataConvert.toString(rs.getString("CustomerName"))%><input type=hidden value='�ͻ�����:<%=DataConvert.toString(rs.getString("CustomerName"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>ҵ�����:</b><%=DataConvert.toString(rs.getString("BusinessCurrencyName"))%><input type=hidden value='ҵ�����:<%=DataConvert.toString(rs.getString("BusinessCurrencyName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>>
			</td>
			<% if("�ͻ��������".equals(rs.getString("PhaseName"))||
	              "Э��ͻ�����".equals(rs.getString("PhaseName"))||
            	  "֧��Э��Ա���".equals(rs.getString("PhaseName"))){%>
            	<td width=50%><b>������(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%><input type=hidden value='������(Ԫ):<%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
            <%}else{%>
            	<td width=50%><b>�������(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%><input type=hidden value='�������(Ԫ):<%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
            <% }%>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>����(��):</b><%=rs.getInt("TermMonth")%><input type=hidden value='����(��):<%=rs.getInt("TermMonth")%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>��(��):</b><%=rs.getInt("TermDay")%><input type=hidden value='��(��):<%=rs.getInt("TermDay")%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <%if(!(sCurFlowNo.equals("CreditFlow") || sCurFlowNo.equals("CreditFlow03")) ){ //lpzhang 2009-12-23 %> 
        <tr id=<%=iRow++%>>            
			<td width=50%><b>��׼������(%):</b><%=rs.getDouble("BaseRate")%><input type=hidden value='��׼������(%):<%=rs.getDouble("BaseRate")%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>���ʸ�����ʽ:</b><%=DataConvert.toString(rs.getString("RateFloatTypeName"))%><input type=hidden value='���ʸ�����ʽ:<%=DataConvert.toString(rs.getString("RateFloatTypeName"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>���ʸ���ֵ:</b><%=rs.getDouble("RateFloat")%><input type=hidden value='���ʸ���ֵ:<%=rs.getDouble("RateFloat")%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>ִ��������(��):</b><%=rs.getDouble("BusinessRate")%><input type=hidden value='ִ��������(��):<%=rs.getDouble("BusinessRate")%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>��֤����(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("BailSum"))%><input type=hidden value='��֤����(Ԫ):<%=DataConvert.toMoney(rs.getDouble("BailSum"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>��֤�����(%):</b><%=rs.getDouble("BailRatio")%><input type=hidden value='��֤�����(%):<%=rs.getDouble("BailRatio")%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>�����ѽ��(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("PdgSum"))%><input type=hidden value='�����ѽ��(Ԫ):<%=DataConvert.toMoney(rs.getDouble("PdgSum"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>��������(��):</b><%=rs.getDouble("PdgRatio")%><input type=hidden value='��������(��):<%=rs.getDouble("PdgRatio")%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
     <%} %>  
     <%if(!sCognResult.equals("")){ %>
        <tr id=<%=iRow++%>>            
			<td width=50%><b>���õȼ��϶��÷�:</b><%=DataConvert.toMoney(rs.getDouble("CognScore"))%><input type=hidden value='���õȼ��϶��÷�:<%=DataConvert.toMoney(rs.getDouble("CognScore"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>���õȼ��϶����:</b><%=DataConvert.toString(sCognResult)%><input type=hidden value='���õȼ��϶����:<%=DataConvert.toString(sCognResult)%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
     <%} %>
        <tr id=<%=iRow++%>>
            <td width=50%><b>�յ�ʱ��:</b><%=DataConvert.toString(rs.getString("BeginTime"))%><input type=hidden value='�յ�ʱ��:<%=DataConvert.toString(rs.getString("BeginTime"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(rs.getString("EndTime"))%><input type=hidden value='���ʱ��:<%=DataConvert.toString(rs.getString("EndTime"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>
        <% if("0010".equals(rs.getString("PhaseNo"))||"0020".equals(rs.getString("PhaseNo"))){%>
            <td width=50% ><b>�������:</b><%=DataConvert.toString(rs.getString("FOPhaseChoice"))%><input type=hidden value='�������:<%=DataConvert.toString(rs.getString("FOPhaseChoice"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
        <%} else{%>    
        	 <td width=50% ><b>����������:</b><%=DataConvert.toString(rs.getString("FOPhaseChoice"))%><input type=hidden value='����������:<%=DataConvert.toString(rs.getString("FOPhaseChoice"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
        <%} %>	 
            <td width=50% ><input type=hidden value='' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n�����˵����"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            	<input type=hidden value='<%="\r\n�������"+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(iRow)+"L"%>>
            	<input type=hidden value='' name=<%="R"+String.valueOf(iRow)+"R"%>>	<!--�����ж��Ƿ����һ��һ��-->
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
        <tr id=<%=jRow++%>>            
			<td width=50%><b>�׶�����:</b><%=DataConvert.toString(rs.getString("PhaseName"))%><input type=hidden value='�׶����ƣ�<%=DataConvert.toString(rs.getString("PhaseName"))%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>������:</b><%=DataConvert.toString(rs.getString("UserName"))%><input type=hidden value='�����ˣ�<%=DataConvert.toString(rs.getString("UserName"))%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>��������������:</b><%=DataConvert.toString(sOrgName)%><input type=hidden value='��������������:<%=DataConvert.toString(sOrgName)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>�ͻ�����:</b><%=DataConvert.toString(sCustomerName)%><input type=hidden value='�ͻ�����:<%=DataConvert.toString(sCustomerName)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>ҵ�����:</b><%=DataConvert.toString(sBusinessCurrencyName)%><input type=hidden value='ҵ�����:<%=DataConvert.toString(sBusinessCurrencyName)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <% if("�ͻ��������".equals(rs.getString("PhaseName"))||
            	  "Э��ͻ�����".equals(rs.getString("PhaseName"))||
            	  "֧��Э��Ա���".equals(rs.getString("PhaseName"))){%>
            	<td width=50%><b>������(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%><input type=hidden value='������(Ԫ):<%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
            <%}else{%>
            	<td width=50%><b>�������(Ԫ):</b><%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%><input type=hidden value='�������(Ԫ):<%=DataConvert.toMoney(rs.getDouble("BusinessSum"))%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
            <% }%>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>����(��):</b><%=iTermMonth%><input type=hidden value='����(��):<%=iTermMonth%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>��(��):</b><input type=hidden value='��(��):' name=<%="R"+String.valueOf(jRow)+"R"%>><%=iTermDay%></td>
        </tr>
      <%if(!(sCurFlowNo.equals("CreditFlow") || sCurFlowNo.equals("CreditFlow03")) ){ //lpzhang 2009-12-23 %> 
        <tr id=<%=jRow++%>>            
			<td width=50%><b>��׼������(%):</b><%=dBaseRate%><input type=hidden value='��׼������(%):<%=dBaseRate%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>���ʸ�����ʽ:</b><%=DataConvert.toString(sRateFloatTypeName)%><input type=hidden value='���ʸ�����ʽ:<%=DataConvert.toString(sRateFloatTypeName)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>���ʸ���ֵ:</b><%=dRateFloat%><<input type=hidden value='���ʸ���ֵ:<%=dRateFloat%>' name=<%="R"+String.valueOf(jRow)+"L"%>>/td>
            <td width=50%><b>ִ��������(��):</b><%=dBusinessRate%><input type=hidden value='ִ��������(��):<%=dBusinessRate%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>��֤����(Ԫ):</b><%=dBailSum%><input type=hidden value='��֤����(Ԫ):<%=dBailSum%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>��֤�����(%):</b><%=dBailRatio%><input type=hidden value='��֤�����(%):<%=dBailRatio%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>�����ѽ��(Ԫ):</b><%=dPdgSum%><input type=hidden value='�����ѽ��(Ԫ):<%=dPdgSum%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>��������(��):</b><%=dPdgRatio%><input type=hidden value='��������(��):<%=dPdgRatio%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
     <%} %>  
     <%if(!sCognResult.equals("")){ %>
        <tr id=<%=jRow++%>>            
			<td width=50%><b>���õȼ��϶��÷�:</b><%=DataConvert.toMoney(rs.getDouble("CognScore"))%><input type=hidden value='���õȼ��϶��÷�:<%=DataConvert.toMoney(rs.getDouble("CognScore"))%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>���õȼ��϶����:</b><%=DataConvert.toString(sCognResult)%><input type=hidden value='���õȼ��϶����:<%=DataConvert.toString(sCognResult)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
     <%} %>
        <tr id=<%=jRow++%>>
            <td width=50%><b>�յ�ʱ��:</b><%=DataConvert.toString(sBeginTime)%><input type=hidden value='�յ�ʱ��:<%=DataConvert.toString(sBeginTime)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(sEndTime)%><input type=hidden value='���ʱ��:<%=DataConvert.toString(sEndTime)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>
        <% if("0010".equals(rs.getString("PhaseNo"))||"0020".equals(rs.getString("PhaseNo"))){%>
            <td width=50% ><b>�������:</b><%=DataConvert.toString(rs.getString("FOPhaseChoice"))%><input type=hidden value='�������:<%=DataConvert.toString(rs.getString("FOPhaseChoice"))%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
        <%} else{%>    
        	 <td width=50% ><b>����������:</b><%=DataConvert.toString(rs.getString("FOPhaseChoice"))%><input type=hidden value='����������:<%=DataConvert.toString(rs.getString("FOPhaseChoice"))%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
        <%} %>	 
            <td width=50% ><input type=hidden value='' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        
        <tr id=<%=jRow++%>>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n�����˵����"+ StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
                <input type=hidden value='<%="\r\n�������"+StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(jRow)+"L"%>>
            <input type=hidden value='' name=<%="R"+String.valueOf(jRow)+"R"%>>	<!--�����ж��Ƿ����һ��һ��-->
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
  </form>
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
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function print()
	{
		var sObjectNo = "<%=sObjectNo%>";
		var sObjectType = "<%=sObjectType%>";
		var sReportType = "<%=sReportType%>";
		var sSerialNo = "";
		sSerialNo = RunMethod("BusinessManage","SelectInpcetReport",sObjectNo+","+sObjectType);
		if(typeof(sSerialNo) == "undefined" || sSerialNo == "" || sSerialNo == "Null" || sSerialNo == "null" || sSerialNo == "NULL") {
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddAVAction.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		}	
		sCompID = "InspectTab";
		sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
		sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&ReportType="+sReportType+"&SerialNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function formatContent()
	{
		var sContentNew = "",i=0;
		var iRowCount = 1;
		if("<%=sSelfOpinionPhase%>" != "")	iRowCount =<%=jRow%>;
		else	iRowCount =<%=iRow%>;
	
		var iColCount = 2;
		sContentNew +="<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=gb_2312-80\">";
		sContentNew += "<STYLE>"; 
		sContentNew += ".table {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}";
		sContentNew += ".td {  font-size: 9pt;border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}.inputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}.pt16songud{font-family: '����','����';font-size: 16pt;font-weight:bold;text-decoration: none}.myfont{font-family: '����','����';font-size: 9pt;font-weight:bold;text-decoration: none}"
		sContentNew += "</STYLE>";
		
		sContentNew += "<table align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF >";
		sContentNew += "<tr>";
		sContentNew += "    <td colspan="+iColCount+" align=middle style='color:black;padding-left:2px;background:silver;font-size:18.0pt;font-weight:700;font-family:����;' height=53>ҵ������������</td>";
		sContentNew += "</tr>";
		sContentNew += "<tr>";
		sContentNew += "    <td align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>��������ˮ�š�<%=sObjectNo%></td>";
		sContentNew += "    <td align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>���ͻ����ơ�<%=sApplyCustomerName%></td>";
		sContentNew += "</tr>";
		sContentNew += "<tr>";
		sContentNew += "    <td align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>���������͡�<%=sOccurTypeName%></td>";
		sContentNew += "    <td align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>��ҵ��Ʒ�֡�<%=sBusinessTypeName%></td>";
		sContentNew += "</tr>";
		sContentNew += "<tr>";
		sContentNew += "    <td colspan="+iColCount+" align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>����Ҫ������ʽ��"+"<%=sVouchTypeName%></td>";
		sContentNew += "</tr>";
		
		for(i=1;i<=iRowCount;i++)
		{
			
			if(document.forms("opinion").elements("R"+i+"R").value == "amarsoft")	//�����ֻ����һ��һ��
			{
				sContentNew += "<tr height=50 style='mso-height-source:userset;height:38.1pt'>";
				sContentNew += "    <td colspan="+iColCount+" align=left style='background-color:#CCC8EB;color:black;padding-left:2px;mso-font-charset:0;vertical-align:top;text-align:left;'>"+document.forms("opinion").elements("R"+i+"L").value+"</td>";
				sContentNew += "</tr>";
			}
			else
			{
				sContentNew += "<tr>";
				sContentNew += "    <td align=left>"+document.forms("opinion").elements("R"+i+"L").value+"</td>";
				sContentNew += "    <td align=left>"+document.forms("opinion").elements("R"+i+"R").value+"</td>";
				sContentNew += "</tr>";
			}
		}	
		
		sContentNew += "</table>";
		//��ֹ�򵼳�������̫С������EXCELʱ�������
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		
		return(sContentNew);		
	}
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
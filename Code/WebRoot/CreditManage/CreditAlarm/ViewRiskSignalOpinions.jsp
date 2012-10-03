<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: xhyong 2011/03/28
 * Tester:
 *
 * Content: �鿴�������
 * Input Param:
 *      ObjectType: ��������
 *      ObjectNo:   ������
 *		FlowNo�����̺�
 *		PhaseNo���׶κ�
 * Output param:
 *
 * History Log: 
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
	
    String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sTempPrivilegePhases="",sPhaseAction="";
	boolean bRolePrivilege = false; //��Щ�׶��ܿ�
	boolean bPhasePrivilege = false;//
	boolean bPhaseMatch = false;//�жϵ�ǰ��������׶��Ƿ��ڶ�Ӧ����Ȩ�׶�

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
	String sBusinessCurrencyName = "";
	String sRateFloatTypeName = "";
	String sCognResult = "";
	int iCountRecord=0;//�����жϼ�¼�Ƿ����������

	ASResultSet rs = null;
	//��ȡ���鿴�Լ�ǩ����������Ӧ�Ľ׶�
	sSql = 	" select Attribute6 from FLOW_MODEL "+
			" where FlowNo = '"+sCurFlowNo+"' "+
			" and PhaseNo = '"+sCurPhaseNo+"' ";
	sSelfOpinionPhase = Sqlca.getString(sSql);
	if(sSelfOpinionPhase == null) sSelfOpinionPhase = "";
	//��ȡ���鿴�Լ�ǩ��������Ϣ
	if(!sSelfOpinionPhase.equals(""))
	{
		sSql =  " select getItemName('PhaseChoice',RO.ConfirmType) as FOPhaseChoice,"+
				" RO.SignalLevel,RO.Opinion,FT.PhaseName,FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime "+
				" from FLOW_TASK FT,RISKSIGNAL_OPINION RO "+
				" where FT.Serialno=RO.SerialNo "+				
				" and (RO.Opinion is not null) "+
				" and RO.CheckUser = '"+CurUser.UserID+"' "+
				" and FT.ObjectNo='" + sObjectNo + "' "+
				" and FT.ObjectType='"+ sObjectType +"'"+
				" and FT.FlowNo = '"+sCurFlowNo+"' "+
				" and FT.PhaseNo= '"+sCurPhaseNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{			
			sSelfOpinion = rs.getString("Opinion");
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
	sSql = 	" select getItemName('PhaseChoice',RO.ConfirmType) as FOPhaseChoice,RO.Opinion, "+
			" RO.SignalLevel,FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction, "+
			" FT.BeginTime,FT.EndTime,FT.PhaseChoice,FT.EndTime, "+
			" FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles "+
			" from FLOW_TASK FT,RISKSIGNAL_OPINION RO,FLOW_MODEL FM "+
			" where FT.Serialno=RO.SerialNo "+
			" and FT.FlowNo=FM.FlowNo "+
			" and FT.PhaseNo=FM.PhaseNo "+
			" and (RO.Opinion is not null) "+
			" and FT.ObjectNo='" + sObjectNo + "' "+
			" and FT.ObjectType='"+ sObjectType +"'";
	
	if(CurUser.hasRole("2A5")||CurUser.hasRole("2J4")||CurUser.hasRole("2D3")||CurUser.hasRole("080")||CurUser.hasRole("280")||CurUser.hasRole("480")){
		sSql += "and (FT.UserID='"+CurUser.UserID+"' or FT.PhaseNo='3000' or FT.PhaseNo='0010' or FT.PhaseAction='���'  or FT.PhaseAction='�˻ز�������' or FT.PhaseAction='��׼') ";
	}
	sSql +=	" and ( FT.PhaseNo<='"+sCurPhaseNo+"' or FT.PhaseNo='3000' or FT.PhaseAction='���' or FT.PhaseAction='�˻ز�������' or FT.PhaseAction='��׼') ";//ֻ�ܲ鿴�¼���������ܿ��ϼ����,���Կ��������Ϻ���׼��� add by zrli 
			
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
            <td width=50%><b>�϶����:</b><%=DataConvert.toString(rs.getString("FOPhaseChoice"))%></td>
            <td width=50%><b>Ԥ������:</b><%=DataConvert.toString(rs.getString("SignalLevel"))%></td>
        </tr>
	  	<tr>            
			<td width=50%><b>�϶�����:</b><%=DataConvert.toString(rs.getString("OrgName"))%></td>
            <td width=50%><b>�϶���:</b><%=DataConvert.toString(rs.getString("UserName"))%></td>
        </tr>
        <tr>            
			<td width=50%><b>�϶�ʱ��:</b><%=DataConvert.toString(rs.getString("EndTime"))%></td>
            <td width=50%><b></b></td>
        </tr>
        
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n���϶������"+ StringFunction.replace(DataConvert.toString(rs.getString("Opinion")).trim(),"\\r\\n","\r\n")
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
    alert("Ŀǰ��ҵ��û�������Բ鿴�����������");
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>
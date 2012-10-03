<%
/* 
 *Author: xhyong 2009/08/24
 * Content: �鿴���շ����϶����
 * Input Param:
 * Output param:
 *
 * History Log: 
	 bqliu 2011-06-16
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
	String sResult1 = "";
	String sClassifyLevel1 = "";
	String sClassifyLevel2 = "";
	//����ֵת��Ϊ���ַ���
	if(sObjectType==null)sObjectType="";
	if(sObjectNo==null)sObjectNo="";
	if(sCurFlowNo==null)sCurFlowNo="";
	if(sCurPhaseNo==null)sCurPhaseNo="";
	
    String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sPhaseAction="";
	boolean bRolePrivilege = false; //��Щ�׶��ܿ�
	boolean bPhasePrivilege = false;//
	boolean bPhaseMatch = false;//�жϵ�ǰ��������׶��Ƿ��ڶ�Ӧ����Ȩ�׶�

	int iCountRecord=0;//�����жϼ�¼�Ƿ����������

	ASResultSet rs = null;
	//������������Ϣ:���ֽ��
	sSql = 	" select getItemName('ClassifyResult',Result1) as Result1,getItemName('ClassifyResult',ClassifyLevel) as ClassifyLevel, "+
			" getItemName('ClassifyResult',ClassifyLevel2) as ClassifyLevel2 "+
	        " from CLASSIFY_RECORD "+
			" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sResult1 = rs.getString("Result1");
		sClassifyLevel1 = rs.getString("ClassifyLevel");
		sClassifyLevel2 = rs.getString("ClassifyLevel2");
		//����ֵת��Ϊ���ַ���
		if(sResult1 == null) sResult1 = "";
		if(sClassifyLevel1 == null) sClassifyLevel1 = "";
		if(sClassifyLevel2 == null) sClassifyLevel2 = "";
	}
	rs.getStatement().close();
	
	
	//������Ա��������� FLOW_OPINION �� ,�����Ҫ��ʾһЩ���������Ҫ�޸�ǩ����������������
	//FLOW_MODEL��ӵĶ�������鿴Ȩ�޵��жϣ�ͨ�� Attribute3,
	sSql = 	" select FO.CustomerName, "+//�ͻ�����
			" FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction, "+
			" FT.BeginTime,FT.EndTime,FT.PhaseChoice,"+
			" FO.PhaseOpinion,FO.PhaseOpinion6,getItemName('ClassifyResult',FO.PhaseOpinion1) as PhaseOpinion1, "+
			" getItemName('ClassifyResult',FO.PhaseOpinion2) as PhaseOpinion2,getItemName('ClassifyResult',FO.PhaseOpinion3) as PhaseOpinion3, "+//�϶������ϵͳ�����÷֣�ϵͳ����������˹����
			" getItemName('ClassifyResult',FO.PhaseOpinion4) as PhaseOpinion4,getItemName('ClassifyResult',FO.PhaseOpinion5) as PhaseOpinion5,"+
			" getItemName('ClassifyResult',FO.phasechoice) as phasechoice1,getItemName('ClassifyResult',FO.phasechoice2) as phasechoice2,"+
			" FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles "+
			" from FLOW_TASK FT,FLOW_OPINION FO,FLOW_MODEL FM "+
			" where FT.Serialno=FO.SerialNo "+
			" and FT.FlowNo=FM.FlowNo "+
			" and FT.PhaseNo=FM.PhaseNo "+
			" and (FO.PhaseOpinion is not null) "+
			" and FT.ObjectNo='" + sObjectNo + "' "+
			" and FT.ObjectType='"+ sObjectType +"'"+
		    " ORDER BY FT.BeginTime";
	rs=Sqlca.getASResultSet(sSql);
%>
<html>
<head>
<title>��������</title>
</head>
<body leftmargin="0" topmargin="0" class="pagebackground">
  <table width="100%" cellpadding="3" cellspacing="0" border="0" >
    <%
        int n = 1;
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
				
				String sTempFlowPhase;
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
        	<td width=50%><b>ϵͳ�������ֽ��:</b><%=DataConvert.toString(rs.getString("PhaseOpinion2"))%></td>   
        	<td width=50%> </td>      
        </tr>
        <tr>   
            <td width=50%><b>�ͻ����������ֽ�������棩:</b><%=DataConvert.toString(rs.getString("PhaseOpinion3"))%></td>
            <td width=50%><b>�ͻ����������ֽ����ʵ�ʣ�:</b><%=DataConvert.toString(rs.getString("PhaseOpinion4"))%></td>
        </tr>
        <% if(n>2){%>
        <tr>   
        	<td width=50%><b>���շ��ิ�˽�������棩:</b><%=DataConvert.toString(rs.getString("phasechoice1"))%></td>  
        	<td width=50%><b>���շ��ิ�˽����ʵ�ʣ�:</b><%=DataConvert.toString(rs.getString("phasechoice2"))%></td>       
        </tr>
        <% }%>
        <%if(n>1){%>
        <tr>   
            <td width=50%><b>�����϶���������棩:</b><%=DataConvert.toString(rs.getString("PhaseOpinion1"))%></td>
            <td width=50%><b>�����϶������ʵ�ʣ�:</b><%=DataConvert.toString(rs.getString("PhaseOpinion5"))%></td>
        </tr>
        <% }%>
        <tr>
            <td width=50%><b>��ʼʱ��:</b><%=DataConvert.toString(rs.getString("BeginTime"))%></td>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(rs.getString("EndTime"))%></td>
        </tr>
        
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n�����������������棩��"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n")
                     %>
                     <%="\r\n��������������ʵ�ʣ���"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion6")).trim(),"\\r\\n","\r\n")
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
    n++;
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
    alert("Ŀǰ�˷��շ��໹û�������Բ鿴���϶������");
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>
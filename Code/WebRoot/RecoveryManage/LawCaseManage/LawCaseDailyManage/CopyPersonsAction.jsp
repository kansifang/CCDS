<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XXGe 2004-11-22
 * Tester:
 * Content: �ڰ��������Ա��Ϣ���в����ʼ��Ϣ
 * Input Param:
 *		  
 * Output param:
 *			
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sSql = "";
	String sSql1 = "";	 
	ASResultSet rs = null;
	String sAgentName = "",sBelongAgency = "",sPractitionerTime = "";
	String sCompetenceNo = "",sPersistNo = "",sSelfOrgName = "";
	String sDuty = "",sDegree = "",sSpecialty = "",sTypicalCase = "";
	String sAddress = "",sPostNo = "",sRelationTel = "",sRelationMode = "";
	int sAge = 0;
   	
	//��ü�¼��ˮ�š���Ա���02��Ժ����Ա��03������
	String 	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String 	sPersonType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PersonType"));
	//��ô��������ͣ�010����Ա����020��Ƹ��ʦ
	String 	sAgentType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AgentType"));
	if(sAgentType == null) sAgentType = "";
	//�����Ա��Ϣ��š�������š��������
	String 	sContractInfo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractInfo"));
	String 	sBelongNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BelongNo"));
	String 	sDepartType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DepartType"));
	if(sDepartType == null) sDepartType = "";
	String 	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
   	 sSql =  "  select AgentName,BelongAgency,PractitionerTime,CompetenceNo,SelfOrgName,"+
	   	 	 "  PersistNo,Duty,Age,Degree,Specialty,TypicalCase,AgentAdd,PostNo,RelationTel,RelationMode "+
	   	 	 "  from AGENT_INFO "+
             "  where SerialNo ='"+sContractInfo+"' ";
   
   	rs = Sqlca.getASResultSet(sSql);    	  	
   	if(rs.next())
	 {
	        //��Ժ��Ա���ơ�������Ժ����ҵʱ�䡢�ʸ�֤��š�ִҵ֤���
	        sAgentName = DataConvert.toString(rs.getString("AgentName"));		
	        sBelongAgency = DataConvert.toString(rs.getString("BelongAgency"));
	        sPractitionerTime = DataConvert.toString(rs.getString("PractitionerTime"));		
	        sCompetenceNo = DataConvert.toString(rs.getString("CompetenceNo")); 
	        sPersistNo = DataConvert.toString(rs.getString("PersistNo")); 
	        sSelfOrgName=DataConvert.toString(rs.getString("SelfOrgName")); 
	        //ְ�����䡢ѧ����ר�������Ͱ�������ַ���ʱࡢ��ϵ�绰��������ϵ��ʽ
	        sDuty = DataConvert.toString(rs.getString("Duty")); 
	        sAge = rs.getInt("Age"); 
	        sDegree = DataConvert.toString(rs.getString("Degree")); 
	        sSpecialty = DataConvert.toString(rs.getString("Specialty")); 
	        sTypicalCase = DataConvert.toString(rs.getString("TypicalCase")); 
	        sAddress = DataConvert.toString(rs.getString("AgentAdd")); 
	        sPostNo = DataConvert.toString(rs.getString("PostNo")); 
	        sRelationTel = DataConvert.toString(rs.getString("RelationTel")); 
	        sRelationMode = DataConvert.toString(rs.getString("RelationMode")); 
	        if (sPersonType.equals("02")) //��Ժ����Ա��Ϣ
			{
		    	sSql1 = " insert into LAWCASE_PERSONS(SerialNo,ObjectNo,ObjectType,DepartType,PersonType,PersonNo,PersonName,OrgNo,OrgName, "+
		    			" Duty,ContactTel,OrgAddress,PostalCode,OtherContactType,InputOrgID,InputUserID,InputDate) "+
				        " values('"+sSerialNo+"','"+sObjectNo+"','LAWCASE_INFO','"+sDepartType+"','02','"+sContractInfo+"','"+sAgentName+"',"+
				        " '"+sBelongNo+"','"+sBelongAgency+"','"+sDuty+"','"+sRelationTel+"','"+sAddress+"','"+sPostNo+"',"+
				        " '"+sRelationMode+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+ StringFunction.getToday() + "')";
				
			}
		
		if (sPersonType.equals("03")) //��������Ϣ
		{
		     if(sAge == 0)
		     {
		       	sSql1 = " insert into LAWCASE_PERSONS(SerialNo,ObjectNo,ObjectType,PersonType,PersonNo,PersonName,"+
      				   	" AgentType,SelfOrgName,OrgNo,OrgName,PractitionerTime,CompetenceNo,PersistNo,Duty,Degree,Specialty,TypicalCase,ContactTel,"+
      				   	" OrgAddress,PostalCode,OtherContactType,InputOrgID,InputUserID,InputDate) "+
			           	" values('"+sSerialNo+"','"+sObjectNo+"','LAWCASE_INFO','03','"+sContractInfo+"','"+sAgentName+"','"+sAgentType+"','"+sSelfOrgName+"','"+sBelongNo+"','"+sBelongAgency+"','"+sPractitionerTime+"',"+
			           	" '"+sCompetenceNo+"','"+sPersistNo+"','"+sDuty+"','"+sDegree+"','"+sSpecialty+"','"+sTypicalCase+"','"+sRelationTel+"','"+sAddress+"','"+sPostNo+"',"+
				       	" '"+sRelationMode+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+ StringFunction.getToday() + "')";
		     }else
		     {
		     	sSql1 = " insert into LAWCASE_PERSONS(SerialNo,ObjectNo,ObjectType,PersonType,PersonNo,PersonName,"+
      					" AgentType,SelfOrgName,OrgNo,OrgName,PractitionerTime,CompetenceNo,PersistNo,Duty,Age,Degree,Specialty,TypicalCase,ContactTel,"+
      					" OrgAddress,PostalCode,OtherContactType,InputOrgID,InputUserID,InputDate) "+
			         	" values('"+sSerialNo+"','"+sObjectNo+"','LAWCASE_INFO','03','"+sContractInfo+"','"+sAgentName+"','"+sAgentType+"','"+sSelfOrgName+"','"+sBelongNo+"','"+sBelongAgency+"','"+sPractitionerTime+"',"+
			         	" '"+sCompetenceNo+"','"+sPersistNo+"','"+sDuty+"',"+sAge+",'"+sDegree+"','"+sSpecialty+"','"+sTypicalCase+"','"+sRelationTel+"','"+sAddress+"','"+sPostNo+"',"+
				        " '"+sRelationMode+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+ StringFunction.getToday() + "')";
		     }	
		}		
		Sqlca.executeSQL(sSql1);
	}
	rs.getStatement().close();
	
%>
<script language=javascript>
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
package com.amarsoft.app.lending.bizlets;
/**
 * xhyong 20110510 ��ʼ����������
 * 
 * */
import java.sql.Date;
import java.text.SimpleDateFormat;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.ASResultSet;



public class InitializeCreditApproveFlow extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		if(sObjectType == null) sObjectType = "";
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		//�������
		String sOrgID = (String)this.getAttribute("OrgID");
		if(sObjectNo == null) sObjectNo = "";
		//��ǰ���̺�
		String sTempFlowNo = (String)this.getAttribute("FlowNo");
		if(sTempFlowNo == null) sTempFlowNo = "";

		//String sTempOrgID = "";//������������
		String sOrgName = "";//������������
		String sUserName = "";//����������
		String sUserID = "";//����������
		String sFlowName = "";//��������
		String sPhaseName = "";//�׶�����
		String sPhaseType = "";//���������׶�
		String sBeginTime = "";//��ʼʱ��
		String sSerialNo = "";//������ˮ��
		String sSql = "";//SQL
		String sFlowNo = "CreditApproveFlow01";//���̱��
		String sPhaseNo = "";//�׶α��
		String sApplyType = "";//��������
		String sApprovalNo = "";//������
		String sMainOrgIDStr = "";//����ǰ��λ
		String sIsApproveFLag = "";//�Ƿ�������
		String sCommunityagreement = "";//������ͬ���Ⱥ�
		//�����������ѯ�����
		ASResultSet rs=null;
		
		//���˹�˾һ���������������
		if("EntCreditFlowTJ01".equals(sTempFlowNo) || "IndCreditFlowTJ01".equals(sTempFlowNo))
		{
			//�����ù�ͬ�����������
			sSql = " select Communityagreement from business_apply where  communityagreement is not null and communityagreement<>'' and Serialno='"+sObjectNo+"' ";
			sCommunityagreement = Sqlca.getString(sSql);
			if(sCommunityagreement == null) sCommunityagreement = "";
			if("".equals(sCommunityagreement))
			{
				sIsApproveFLag="1";
			}
		}
		//ȡ�û�������
		sSql = " select OrgName from ORG_INFO where OrgID = '"+sOrgID+"' ";
		sOrgName = Sqlca.getString(sSql);
		
		//��ó�ʼ���׶��˺ͻ���
		if("EntCreditFlowTJ01".equals(sTempFlowNo))//��˾һ���������
		{
			//����
			if("9900".equals(sOrgID))
			{
				//��ȡ���û�����:��Ӧϵͳ�׶�:��С��ҵ�����ֲ����Ա,���й�˾��������������Ա
				sSql = " select UserID,UserName from FLOW_TASK where ObjectType='CreditApply' " +
						" and  PhaseNo in('0220','0260') and  FlowNo='"+sTempFlowNo+"' and OrgID = '"+sOrgID+"' "+
						" and ObjectNO='"+sObjectNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{ 
					sUserID = rs.getString("UserID");
					sUserName = rs.getString("UserName");
					//����ֵת���ɿ��ַ���
					if(sUserID == null) sUserID = "";
					if(sUserName == null) sUserName = "";
				}
				rs.getStatement().close(); 
			}else{//����֧��
				//��ȡ���û�����
				sSql = " select UserID,UserName from FLOW_TASK where ObjectType='CreditApply' " +
						" and  PhaseNo='0130' and  FlowNo='"+sTempFlowNo+"' and OrgID = '"+sOrgID+"' "+
						" and ObjectNO='"+sObjectNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{ 
					sUserID = rs.getString("UserID");
					sUserName = rs.getString("UserName");
					//����ֵת���ɿ��ַ���
					if(sUserID == null) sUserID = "";
					if(sUserName == null) sUserName = "";
				}
				rs.getStatement().close();
			}
			
		}else{//����һ���������
			//����
			if("9900".equals(sOrgID))
			{
				//��ȡ���û�����
				sSql = " select UserID,UserName from FLOW_TASK where ObjectType='CreditApply' " +
						" and  PhaseNo='0200' and  FlowNo='"+sTempFlowNo+"' and OrgID = '"+sOrgID+"' "+
						" and ObjectNO='"+sObjectNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{ 
					sUserID = rs.getString("UserID");
					sUserName = rs.getString("UserName");
					//����ֵת���ɿ��ַ���
					if(sUserID == null) sUserID = "";
					if(sUserName == null) sUserName = "";
				}
				rs.getStatement().close(); 
			}else{//����֧��
				//��ȡ���û�����
				sSql = " select UserID,UserName from FLOW_TASK where ObjectType='CreditApply' " +
						" and  PhaseNo='0130' and  FlowNo='"+sTempFlowNo+"' and OrgID = '"+sOrgID+"' "+
						" and ObjectNO='"+sObjectNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{ 
					sUserID = rs.getString("UserID");
					sUserName = rs.getString("UserName");
					//����ֵת���ɿ��ַ���
					if(sUserID == null) sUserID = "";
					if(sUserName == null) sUserName = "";
				}
				rs.getStatement().close();
			}
		}
        //ȡ����������
		sSql = " select FlowName,InitPhase from FLOW_CATALOG where FlowNo = '"+sFlowNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			sFlowName = rs.getString("FlowName");
			sPhaseNo = rs.getString("InitPhase");
			//����ֵת���ɿ��ַ���
			if(sFlowName == null) sFlowName = "";
			if(sPhaseNo == null) sPhaseNo = "";
		}
		rs.getStatement().close(); 	    
        //ȡ�ý׶�����
		sSql = " select PhaseName,PhaseType from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			sPhaseName = rs.getString("PhaseName");
			sPhaseType = rs.getString("PhaseType");
			
			//����ֵת���ɿ��ַ���
			if(sPhaseName == null) sPhaseName = "";
			if(sPhaseType == null) sPhaseType = "";
		}
		rs.getStatement().close(); 
		//��ÿ�ʼ����
	    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();	 
	    //��������Ĭ��Ϊ:sObjectType"CreditApproveApply"
	    sApplyType = "CreditApproveApply";
	    //����ֵת���ɿ��ַ���
	    if(sObjectType == null) sObjectType = "";
	    if(sObjectNo == null) sObjectNo = "";
	    if(sPhaseType == null) sPhaseType = "";
	    if(sApplyType == null) sApplyType = "";
	    if(sFlowNo == null) sFlowNo = "";
	    if(sFlowName == null) sFlowName = "";
	    if(sPhaseNo == null) sPhaseNo = "";
	    if(sPhaseName == null) sFlowName = "";
	    if(sUserID == null) sUserID = "";
	    if(sUserName == null) sUserName = "";
	    if(sOrgID == null) sOrgID = "";
	    if(sOrgName == null) sOrgName = "";

	    //�����̶����FLOW_OBJECT������һ����Ϣ
	    String sSql1 =  " Insert into FLOW_OBJECT(ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName,PhaseNo, " +
			    	    " PhaseName,OrgID,OrgName,UserID,UserName,InputDate) " +
			            " values ('CreditApproveApply','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"', " +
			            " '"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sOrgName+"','"+sUserID+"', "+
			            " '"+sUserName+"','"+StringFunction.getToday()+"') ";
	    //�����������FLOW_TASK������һ����Ϣ
	    sSerialNo = DBFunction.getSerialNo("FLOW_TASK","SerialNo",Sqlca);
        String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
         				" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime) "+
         				" values ('"+sSerialNo+"','CreditApproveApply','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"', " + 
         				" '"+sFlowNo+"','"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sUserID+"', " +
         				" '"+sUserName+"','"+sOrgName+"','"+sBeginTime+"' )";
		if(sOrgID.length()>=4){
			sMainOrgIDStr = sOrgID.substring(0,4);
		}else{
			sMainOrgIDStr = sOrgID;
			for(int i=sOrgID.length();i<4;i++){
				sMainOrgIDStr = "0"+ sMainOrgIDStr;
			}
		}
        sApprovalNo=sMainOrgIDStr+ DBFunction.getSerialNo("BUSINESS_APPLY","ApprovalNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca).substring(2,12);
        String sSql3 =  " Update BUSINESS_APPLY set ApprovalNo='"+sApprovalNo+"',IsApproveFLag='"+sIsApproveFLag+"' where SerialNo='"+sObjectNo+"'";
	    //ִ�в������
	    Sqlca.executeSQL(sSql1);
	    Sqlca.executeSQL(sSql2);
	    Sqlca.executeSQL(sSql3);
	    
	    return "1";
	    
	 }

}

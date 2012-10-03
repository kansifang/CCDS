package com.amarsoft.app.lending.bizlets;
/**
 * History Log modified by fhuang 2007.01.08 ������С��ҵ����ѡ��
 * 
 * */
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.ASResultSet;


public class InitializeFlow extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//��������
		String sApplyType = (String)this.getAttribute("ApplyType");
		//���̱��
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//�׶α��
		String sPhaseNo = (String)this.getAttribute("PhaseNo");	
		//�û�����
		String sUserID = (String)this.getAttribute("UserID");
		//��������
		String sOrgID = (String)this.getAttribute("OrgID");
        		
		//�������:�û����ơ��������ơ��������ơ��׶����ơ��׶����͡���ʼʱ�䡢������ˮ�š�SQL
		String sUserName = "";
		String sOrgName = "";
		String sFlowName = "";
		String sPhaseName = "";	
		String sPhaseType = "";
		String sBeginTime = "";
		String sSerialNo = "";
		String sSql = "";
		//�����������ѯ�����
		ASResultSet rs=null;
		
		if(sObjectType == null) sObjectType = "";
		
		System.out.println("sObjectType:"+sObjectType+"#sObjectNO:"+sObjectNo);
		if(sObjectType.equals("PutOutApply"))
		{
			String sCustomerType="",sBusinessType="",sNationRisk="";
			sSql = "select getCustomerType(CustomerID) as CustomerType,BusinessType,NationRisk from Business_PutOut where SerialNo='"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{ 
				sCustomerType = rs.getString("CustomerType");
				sBusinessType = rs.getString("BusinessType");
				sNationRisk = rs.getString("NationRisk");
				
				//����ֵת���ɿ��ַ���
				if(sCustomerType == null) sCustomerType = "";
				if(sBusinessType == null) sBusinessType = "";
				if(sNationRisk == null) sNationRisk = "";
			}
			rs.getStatement().close(); 
			
			if (sCustomerType == null||sCustomerType.equals("")) 
				throw new Exception("��ȡ�ͻ����ʹ�������ϵϵͳ����Ա��");
			if("918010100".equals(sOrgID)){
				sFlowNo = "CompanyPutOutFlow";
			}
			else if(sCustomerType.startsWith("03"))//����
				sFlowNo="IndPutOutFlow";
			else{
				//��ѯ��ҵ�����뷢������
				String sContractNo = Sqlca.getString("select ContractSerialNo from Business_PutOut where SerialNo ='"+sObjectNo+"'");
				if(sContractNo == null) sContractNo="";

				String sSmallEntFlag = Sqlca.getString("select SmallEntFlag from ENT_INFO where CustomerID = (select CustomerID from Business_Contract where SerialNo = '"+sContractNo+"')");
				if(sSmallEntFlag == null) sSmallEntFlag = "";
				if("1".equals(sSmallEntFlag))
				{
					sFlowNo="SmallPutOutFlow";//΢С��ҵ�ſ�����
				}else{
					sFlowNo="EntPutOutFlow";
				}
			}
		}
		
		//��ȡ���û�����
		sSql = " select UserName from USER_INFO where UserID = '"+sUserID+"' ";
		sUserName = Sqlca.getString(sSql);
	   	    
	    //ȡ�û�������
		sSql = " select OrgName from ORG_INFO where OrgID = '"+sOrgID+"' ";
		sOrgName = Sqlca.getString(sSql);
	    	    
        //ȡ����������
		sSql = " select FlowName from FLOW_CATALOG where FlowNo = '"+sFlowNo+"' ";
		sFlowName = Sqlca.getString(sSql);
			    
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
			            " values ('"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"', " +
			            " '"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sOrgName+"','"+sUserID+"', "+
			            " '"+sUserName+"','"+StringFunction.getToday()+"') ";
	    //�����������FLOW_TASK������һ����Ϣ
	    sSerialNo = DBFunction.getSerialNo("FLOW_TASK","SerialNo",Sqlca);
        String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
         				" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime) "+
         				" values ('"+sSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"', " + 
         				" '"+sFlowNo+"','"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sUserID+"', " +
         				" '"+sUserName+"','"+sOrgName+"','"+sBeginTime+"' )";

	   
	    //ִ�в������
	    Sqlca.executeSQL(sSql1);
	    Sqlca.executeSQL(sSql2);
	    	    
	    return "1";
	    
	 }

}

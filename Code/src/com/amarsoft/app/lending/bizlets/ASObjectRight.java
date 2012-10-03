package com.amarsoft.app.lending.bizlets;
/*
Author: --��ҵ� 2005-08-11
Tester:
Describe: --Ȩ���ж�
Input Param:

Output Param:

HistoryLog:
*/


import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.context.ASUser;
import com.amarsoft.biz.bizlet.Bizlet;


public class ASObjectRight extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{
		//��ȡ�������������������ţ���ͼID���û����		
		String sMethodName = (String)this.getAttribute("MethodName");	
		String sObjectType=(String)this.getAttribute("ObjectType");
		String sObjectNo=(String)this.getAttribute("ObjectNo");
		String sViewID=(String)this.getAttribute("ViewID");
		String sUserID=(String)this.getAttribute("UserID");
		
		String sReturn="";
		if(sMethodName.equals("rightOfCustomer"))
			sReturn=rightOfCustomer(Sqlca,sObjectNo,sViewID,sUserID);
		else if(sMethodName.equals("rightOfApply"))
			sReturn=rightOfApply(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		else if(sMethodName.equals("rightOfApprove"))
			sReturn=rightOfApprove(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		else if(sMethodName.equals("rightOfContract"))
			sReturn=rightOfContract(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		else if(sMethodName.equals("rightOfCreditLine"))
			sReturn=rightOfContract(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		else if(sMethodName.equals("rightOfPutOut"))
			sReturn=rightOfPutOut(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		else
			sReturn=rightOfViewId(sObjectNo,sViewID,sUserID);
		
		return sReturn;
	}
	
    //  ����ViewID�ж�,001�ɱ༭������ֻ��
	public String rightOfViewId(String pObjectNo, String pViewID, String pUserID) {
		if (pViewID.equals("001"))
			return "All";
		else
			return "ReadOnly";
	}
	
	//�ͻ�����Ȩ���ж�
    public String rightOfCustomer(Transaction Sqlca,String pObjectNo, String pViewID, String pUserID) throws Exception {
    	String sReturn = "ReadOnly";

		if (pViewID.equals("000"))
		{
			sReturn = "All";
			return sReturn;
		}

		if (!pViewID.equals("001"))
		{
			return sReturn;
		}
		
		ASResultSet rs=null;
		//����ǳ����û�����ֱ�ӷ�������Ȩ��
		rs = Sqlca.getASResultSet("select RoleID from USER_ROLE where RoleID = '000' and UserID = '"+pUserID+"'");
        if (rs.next()) {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        
        //�ܻ��˿��Խ�������ά��
        String sBelongAttribute1 = ""; //��Ϣ�鿴Ȩ
        String sBelongAttribute2 = ""; //��Ϣά��Ȩ
        rs = Sqlca.getASResultSet("select BelongAttribute1,BelongAttribute2 from CUSTOMER_BELONG where CustomerID = '"+pObjectNo+"' and UserID = '"+pUserID+"'");
        if (rs.next()) {
        	sBelongAttribute1 = rs.getString("BelongAttribute1");
        	sBelongAttribute2 = rs.getString("BelongAttribute2");
        	//����ֵת��Ϊ���ַ���
        	if(sBelongAttribute1 == null) sBelongAttribute1 = "";
        	if(sBelongAttribute2 == null) sBelongAttribute2 = "";
        	if(sBelongAttribute2.equals("1"))
        		sReturn = "All";
        	else if(sBelongAttribute1.equals("1"))
        		sReturn = "ReadOnly";
        	return sReturn;
        }
        rs.getStatement().close();
        
        return sReturn;
    }

	//�������Ȩ���ж�
	public String rightOfApply(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        
		if (pViewID.equals("000"))
		{
			sReturn = "All";
			return sReturn;
		}

		if (!pViewID.equals("001"))
		{
			return sReturn;
		}
        ASResultSet rs = null;

        //����ǳ����û�����ֱ�ӷ�������Ȩ��
        rs = Sqlca.getASResultSet("select RoleID from USER_ROLE where RoleID = '000' and UserID = '"+pUserID+"'");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        //����Ǽ��˿���������δ�ύPhaseNo='0010'���˻ز������Ͻ׶�PhaseNo='3000'��������ά��
        rs = Sqlca.getASResultSet("select ObjectNo from FLOW_OBJECT where ObjectType = '"+pObjectType+"' and ObjectNo = '"+pObjectNo+"' and UserId = '"+pUserID+"' and  (PhaseNo='0010' or PhaseNo='3000')");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        
        return sReturn;
    }
	
	//���������������Ȩ���ж�
	public String rightOfApprove(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        
		if (pViewID.equals("000"))
		{
			sReturn = "All";
			return sReturn;
		}

		if (!pViewID.equals("001"))
		{
			return sReturn;
		}
        ASResultSet rs = null;

        //����ǳ����û�����ֱ�ӷ�������Ȩ��
        rs = Sqlca.getASResultSet("select RoleID from USER_ROLE where RoleID = '000' and UserID = '"+pUserID+"'");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        //������������Ǽ��˿����������������δ�ύPhaseNo='0010'���˻ز������Ͻ׶�PhaseNo='3000'��������ά��
        rs = Sqlca.getASResultSet("select ObjectNo from FLOW_OBJECT where ObjectType = '"+pObjectType+"' and ObjectNo = '"+pObjectNo+"' and UserId = '"+pUserID+"' and  (PhaseNo='0010' or PhaseNo='3000')");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        
        return sReturn;
    }
	
	//��ͬȨ���ж�
	public String rightOfContract(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";

		if (pViewID.equals("000"))
		{
			sReturn = "All";
			return sReturn;
		}
		
		if (!pViewID.equals("001"))
		{
			return sReturn;
		}
		
        ASResultSet rs = null;

        //����ǳ����û�����ֱ�ӷ�������Ȩ��
        rs = Sqlca.getASResultSet("select RoleID from USER_ROLE where RoleID = '000' and UserID = '"+pUserID+"'");
        if (rs.next()) {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
       
        //ʵ�����û�
        ASUser CurUser = new ASUser(pUserID,Sqlca);
        //��ͬ�ڲ��Ǳ�־Ϊδ���ȣ��ҵ�ǰ�û�Ϊ��Ͻ����ʱ������ά������
        rs = Sqlca.getASResultSet("select ReinforceFlag from BUSINESS_CONTRACT where SerialNo='"+pObjectNo+"' and ManageOrgID like '"+CurUser.OrgID+"%'");
        if (rs.next()) {
        	String sReinforceFlag = rs.getString("ReinforceFlag");
        	if (sReinforceFlag==null) sReinforceFlag="";
        	if (sReinforceFlag.equals("010")) //���Ǳ�־ReinforceFlag��010��δ���ǣ�020���Ѳ��ǣ�
        	{
        		sReturn = "All";
        		return sReturn;
        	}
        }
        rs.getStatement().close();
        
        //��ͬΪ�ۺ�����Э��ʱ������Ѿ��������������ҵ������ռ�ã�Ҳ���ܽ����޸�
        String sBusinessType = "";
        rs = Sqlca.getASResultSet("select BusinessType from BUSINESS_CONTRACT where SerialNo='"+pObjectNo+"' ");
        if (rs.next()) {
        	sBusinessType = rs.getString("BusinessType");
        	if(sBusinessType == null) sBusinessType = "";
        }
        rs.getStatement().close();
        
        if(sBusinessType.length() >=1 && sBusinessType.substring(0,1).equals("3")) //���
        {	
        	rs = Sqlca.getASResultSet("select SerialNo from BUSINESS_APPLY where CreditAggreement = '"+pObjectNo+"'");
        	if (!rs.next())
        	{        		
    			sReturn = "All";
    			return sReturn;        		
        	}
        	rs.getStatement().close();
        }else
        {        
	        //��ͬ�ܻ��ˡ��Ǽ��ˡ���ȫ�ܻ����ں�ͬû������Ŵ��Һ�ͬ����û�н��ʱ����ά������
	        rs = Sqlca.getASResultSet("select SerialNo from BUSINESS_CONTRACT where SerialNo='"+pObjectNo+"' and (InputUserID = '"+pUserID+"' or ManageUserID = '"+pUserID+"') and (PigeonholeDate is null or PigeonholeDate='')");
	        if (rs.next()) {        	
	        	rs.getStatement().close();
	        	rs = Sqlca.getASResultSet("select SerialNo from BUSINESS_PUTOUT where ContractSerialNo = '"+pObjectNo+"'");
	        	if (!rs.next())
	        	{
	        		rs.getStatement().close();
	        		rs = Sqlca.getASResultSet("select RelativeSerialNo2  from BUSINESS_DUEBILL where RelativeSerialNo2='"+pObjectNo+"'");
	        		if (!rs.next())
	        		{
	        			sReturn = "All";
	        			return sReturn;
	        		}else
	        		{
	        			rs.getStatement().close();
	        		}
	        	}else
	        	{
	        		rs.getStatement().close();
	        	}
	        }else
	        {
	        	rs.getStatement().close();
	        }
        } 
        return sReturn;
    }
	
	//���ʶ���Ȩ���ж�
	public String rightOfPutOut(Transaction Sqlca,String pObjectType,String pObjectNo,String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        
		if (pViewID.equals("000"))
		{
			sReturn = "All";
			return sReturn;
		}

		if (!pViewID.equals("001"))
		{
			return sReturn;
		}
        ASResultSet rs = null;

        //����ǳ����û�����ֱ�ӷ�������Ȩ��
        rs = Sqlca.getASResultSet("select RoleID from USER_ROLE where RoleID = '000' and UserID = '"+pUserID+"'");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        //���ʵǼ��˿����ڳ���δ�ύPhaseNo='0010'���˻ز������Ͻ׶�PhaseNo='3000'��������ά��
        rs = Sqlca.getASResultSet("select ObjectNo from FLOW_OBJECT where ObjectType = '"+pObjectType+"' and ObjectNo = '"+pObjectNo+"' and UserId = '"+pUserID+"' and  (PhaseNo = '0010' or PhaseNo = '3000')");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
       
        return sReturn;
    }
}

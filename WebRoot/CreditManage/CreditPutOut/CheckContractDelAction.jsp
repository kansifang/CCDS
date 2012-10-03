<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:      ndeng 2005.02.02
 * Tester:
 *
 * Content: ����ͬ�Ƿ���ɾ��
 * Input Param:
 *			ObjectNo:��ͬ��ˮ��
                
 * Output param:
 * History Log: zywei 2006/08/12  
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<% 
    //�������
    String sRight = "",sReturnValue = "",sSql = "",sFinishDate = "";
    String sPigeonholeDate = "",sManageUserID = "",sBusinessType = "";
    String sReinforceFlag = "",sRelativeSerialNo = "";
    int iCount = 0;
    ASResultSet rs = null;
    
    //��ȡ�������    
    
    //��ȡҳ���������ͬ��ˮ��
    String sObjectNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	//��ȡ��ͬ���ս����ڡ��鵵���ڡ��ܻ��ˡ�ҵ��Ʒ����Ϣ
	sSql = 	" select FinishDate,PigeonholeDate,ManageUserID,BusinessType,ReinforceFlag,RelativeSerialNo "+
			" from BUSINESS_CONTRACT "+
			" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getResultSet(sSql);
    if(rs.next())
    {
        sFinishDate = rs.getString("FinishDate");
        sPigeonholeDate = rs.getString("PigeonholeDate");
        sManageUserID = rs.getString("ManageUserID");
        sBusinessType = rs.getString("BusinessType");
        sReinforceFlag = rs.getString("ReinforceFlag");
        sRelativeSerialNo = rs.getString("RelativeSerialNo");
        //����ֵת��Ϊ���ַ���
        if(sFinishDate == null) sFinishDate = "";
        if(sPigeonholeDate == null) sPigeonholeDate = "";
        if(sManageUserID == null) sManageUserID = "";
        if(sBusinessType == null) sBusinessType = "";
        if(sReinforceFlag == null) sReinforceFlag = "";
        if(sRelativeSerialNo == null) sRelativeSerialNo = "";
    }
    rs.getStatement().close();
    
    if(sReinforceFlag.equals("")) //�����ĺ�ͬ
    {
	    if(sFinishDate.equals("")) //δ�ս�
	    {
	    	if(sPigeonholeDate.equals("")) //δ��ɷŴ�
	    	{
	    		if(sBusinessType.substring(0,1).equals("3")) //���Ŷ��
	    		{
	    			//�������Ŷ���Ƿ�����ҵ��ռ�ù�
	    			sSql = 	" select count(SerialNo) "+
	    					" from BUSINESS_APPLY where "+
	    					" CreditAggreement = '"+sObjectNo+"' ";
	    			rs = Sqlca.getASResultSet(sSql);
		    		if(rs.next())
		    			iCount = rs.getInt(1);
		    		rs.getStatement().close();
		    		
		    		if(iCount > 0) //���Ŷ���ѱ�ռ��
		    		{
		    			 sReturnValue = "Use";
		    		}else
		    		{
		    			if(!sManageUserID.equals(CurUser.UserID)) //�����Ŵ���Ա�ܻ�
		    			{
		    				sReturnValue = "Other";
		    			}
		    		} 
	    		}else
	    		{
		    		//���ú�ͬ�Ƿ���ڷſ���Ϣ
		    		sSql = 	" select count(SerialNo) "+
		    				" from BUSINESS_PUTOUT "+
		    				" where ContractSerialNo = '"+sObjectNo+"' ";
		    		rs = Sqlca.getASResultSet(sSql);
		    		if(rs.next())
		    			iCount = rs.getInt(1);
		    		rs.getStatement().close();
		    			
		    		if(iCount <= 0) //��δ����
		    		{
		    			if(!sManageUserID.equals(CurUser.UserID)) //�����Ŵ���Ա�ܻ�
		    			{
		    				sReturnValue = "Other";
		    			}
		    		}else //�ѳ���
		    		{
		    			sReturnValue = "PutOut";
		    		}
		    	}
	    	}else //����ɷŴ�
	    	{
	    		sReturnValue = "Pigeonhole";
	    	}
	    }else //���ս�
	    {
	    	sReturnValue = "Finish";
	    }
	}else //�����ǻ���ɲ���
	{
		sReturnValue = "Reinforce";
	}
	//���ȡ���ɹ���ô�͸���BA�����Ƿ��ѵǼǺ�ͬ��־ added by zrli 
	if(sReturnValue.equals("")){
		sSql =  " update BUSINESS_APPLY set ContractExsitFlag = null where SerialNo = '"+sRelativeSerialNo+"' ";
		Sqlca.executeSQL(sSql);	
	}
%>
<script language=javascript> 

    self.returnValue="<%=sReturnValue%>";
    self.close();
</script>		
<%@ include file="/IncludeEnd.jsp"%>
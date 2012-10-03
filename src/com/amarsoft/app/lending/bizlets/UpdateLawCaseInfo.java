package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateLawCaseInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
        //hxli 2005-8-5  
	 	//�Զ���ô���Ĳ���ֵ
		ASResultSet rs = null;
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sBookType   = (String)this.getAttribute("BookType");
		String ssDate   = (String)this.getAttribute("sDate");
		//�������
		String sCasePhase = "";
		String sCaseStatus = "";
		String sCourtStatus = "";
		String sCognizanceResult = "";
		String pCognizanceResult = "";
		String pIntoEffectDate = "";
		String pCasePhase = "";
		String pCaseStatus = "";
		String pCourtStatus = "";
		String sSql = "";
		//���߲�����ȡ��Ҫ��ֵ
		//�Ӱ�����Ϣ����ѡ�񰸼������׶Ρ�������ǰ���Ͻ��̡�������������Ժ
		sSql= " select CasePhase,CaseStatus,CourtStatus,CognizanceResult from LAWCASE_INFO"+
			  " where SerialNo = '"+sObjectNo+"'";
		rs = Sqlca.getResultSet(sSql);
	    if(rs.next())
	    {
	    	sCasePhase = rs.getString("CasePhase");
	    	sCaseStatus = rs.getString("CaseStatus");
	    	sCourtStatus = rs.getString("CourtStatus");
	    	sCognizanceResult = rs.getString("CognizanceResult");
	    }
	    
	    rs.getStatement().close();
	    
	    //�ж�̨����Ϣ�����Ƿ������������ļ�¼ 
	    int ICount = 0;
	    sSql= " select count(*) from LAWCASE_BOOK"+
			  " where ObjectNo = '"+sObjectNo+"' and BookType = '"+sBookType+"'"+
			  " and AppDate in(select max(AppDate) from LAWCASE_BOOK "+
			  " where ObjectNo='"+sObjectNo+"' and BookType = '"+sBookType+"')";
	    rs = Sqlca.getResultSet(sSql);
	    if(rs.next())
	    {
	    	ICount = rs.getInt(1);
	    }
	    
	    rs.getStatement().close();
	    
	    //��������������Ķ�����¼����ѡ����������Ϊ������������������Ϣ 
	    if(ICount>0)
	    {
	    	sSql= " select nvl(CognizanceResult,'') as CognizanceResult,nvl(IntoEffectDate,'') as IntoEffectDate,"+
	    		  " nvl(AcceptedCourt,'') as AcceptedCourt from LAWCASE_BOOK"+
				  " where ObjectNo = '"+sObjectNo+"' and BookType = '"+sBookType+"'"+
				  " and AppDate in (select max(AppDate) from LAWCASE_BOOK where ObjectNo='"+sObjectNo+"' and BookType = '"+sBookType+"')";
		    rs = Sqlca.getResultSet(sSql);
		    if(rs.next())
		    {
		    	pCognizanceResult = rs.getString("CognizanceResult");
		    	pIntoEffectDate = rs.getString("IntoEffectDate");
		    	pCourtStatus = rs.getString("AcceptedCourt");
		    }
		    
		    rs.getStatement().close();
	    }
	    if(pIntoEffectDate==null) pIntoEffectDate = "";
	    //���Ϊ֧����̨�ʣ��򰸼�������ǰ�׶Ρ����������κ����Ͻ��� 
	    if(sBookType.equals("010")) 
	    {
	    	pCasePhase="010"; 
		    pCaseStatus=sBookType; 	    	
	    }
	    //���Ϊ��ǰ��ǫ̈̄�ʣ��򰸼�������ǰ�׶�
	    if(sBookType.equals("020")) 
	    {
	    	pCasePhase="010"; 
	    	pCaseStatus=sBookType; 	    	
	    }
	    //���Ϊ���ϱ�ǫ̈̄�ʣ��򰸼����������н׶� 
	    if(sBookType.equals("026")) 
	    {
	    	pCasePhase="020"; 
	    }
	    //���Ϊ����̨�ʣ��򰸼����������н׶� 
	    if(sBookType.equals("030")) 
	    {
	    	pCasePhase="020"; 
	    	pCaseStatus=sBookType; 	    	
	    }
	    //���Ϊһ�󡢶�������̨�ʣ��򰸼����������н׶� 
	    if((sBookType.equals("040") || sBookType.equals("050") || sBookType.equals("060")) &&  ssDate.compareTo(pIntoEffectDate)>=0 && !pIntoEffectDate.equals(""))
	    {
	    	pCasePhase="025"; 
	    	pCaseStatus=sBookType; 	 
	    }
	    else
	    {
	    	pCasePhase="020"; 
	    	pCaseStatus=sBookType; 
	    }
	    //���Ϊִ�С��Ʋ�̨�ʣ��򰸼�����ִ���н׶� 
	    if(sBookType.equals("070") || sBookType.equals("080")) 
	    {
	    	pCasePhase="030"; 
	    	pCaseStatus=sBookType; 	    	
	    }
	    //���Ϊ��̨֤�ʣ��򰸼�������ǰ�׶�
	    if(sBookType.equals("065"))
	    {
	    	pCasePhase="010"; 
	    	pCaseStatus=sBookType; 
	    }
	    //���Ϊ�ٲ�̨�ʣ��򰸼����������н׶� 
	    if(sBookType.equals("068"))
	    {
	    	pCasePhase="020"; 
	    	pCaseStatus=sBookType; 
	    }
	    
	    
	    	    
        //�������ԭ���Ͻ����ڰ����½���֮ǰ�� ����°������Ͻ���   
	    //pCaseStatus=pCaseStatus.substring(1,4);
	    if(sCaseStatus==null || sCaseStatus.equals("")) sCaseStatus="000";
	    
	    if(Integer.parseInt(sCaseStatus)<=Integer.parseInt(pCaseStatus))
	    {
	    	sSql=" update LAWCASE_INFO set CaseStatus='"+pCaseStatus+"',"+
		         " OldCourtStatus='"+sCourtStatus+"',"+
		         " CourtStatus='"+pCourtStatus+"',"+
		         " OldCaseStatus='"+sCaseStatus+"',"+
		         " OldCognizeResult='"+sCognizanceResult+"',"+
		         " CognizanceResult='"+pCognizanceResult+"' where SerialNo='"+sObjectNo+"'";
		    
		    
		    Sqlca.executeSQL(sSql);
	    }
	    
        //��������׶η����仯������°����Ľ׶� 
	    //if(sCasePhase<=pCasePhase)
	   	if(Integer.parseInt(sCasePhase)<=Integer.parseInt(pCasePhase))
	    {
	    	sSql=" update LAWCASE_INFO set CasePhase='"+pCasePhase+"',"+
		         " OldCasePhase='"+sCasePhase+"'"+
		         " where SerialNo='"+sObjectNo+"'";
		    
		    Sqlca.executeSQL(sSql);
	    }
	    //���ԭ�����׶�Ϊ��ִ�н׶Σ������º�׶�Ϊ�����У�����°����Ľ׶�
	    if(sCasePhase.equals("025") && pCasePhase.equals("020"))
	    {
	    	sSql=" update LAWCASE_INFO set CasePhase='"+pCasePhase+"',OldCasePhase='"+sCasePhase+"',"+
	    		 " CaseStatus='"+pCaseStatus+"',"+
		         " OldCourtStatus='"+sCourtStatus+"',"+
		         " CourtStatus='"+pCourtStatus+"',"+
		         " OldCaseStatus='"+sCaseStatus+"',"+
		         " OldCognizeResult='"+sCognizanceResult+"',"+
		         " CognizanceResult='"+pCognizanceResult+"' where SerialNo='"+sObjectNo+"'";
		    
		    Sqlca.executeSQL(sSql);
	    }

	    
	    return null;
	 }

}

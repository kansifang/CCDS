package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateEvaluateRecord extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sObjectNo = (String)this.getAttribute("sObjectNo");
		String sCognResult = (String)this.getAttribute("sCognResult");
		String sCognreason = (String)this.getAttribute("sPhaseOpinion");
		String sUserID = (String)this.getAttribute("sUserId");
		String sPhaseNo = (String)this.getAttribute("sPhaseNo");
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sCognResult == null) sCognResult = "" ;
		if(sCognreason == null) sCognreason = "" ;
		if(sUserID == null) sUserID ="";
		if(sPhaseNo == null) sPhaseNo="";
		
		String sSql = "";
		String sRoleId= "",sUserName="";
		ASResultSet rs = null;
		//�����û��Ľ�ɫ��ȷ�������õȼ���¼���е���Щ�ֶν��и���
		sSql = "select RoleId from USER_ROLE where UserId='"+sUserID+"' and Status='1' order by RoleID";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next()) sRoleId+=","+rs.getString("RoleId");
		rs.getStatement().close();
		
		sSql = "select UserName from USER_INFO where UserId='"+sUserID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()) sUserName = rs.getString("UserName");
		rs.getStatement().close();
		
	
		sSql="update EVALUATE_RECORD set CognUserId  = '"+sUserID+"',CognResult ='"+sCognResult+"',Cognreason='"+sCognreason+"' where SerialNo = '"+sObjectNo+"'";		
		Sqlca.executeSQL(sSql);
		
		return "1";
	}	

}

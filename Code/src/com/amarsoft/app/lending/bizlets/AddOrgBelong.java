package com.amarsoft.app.lending.bizlets;

/*
Author: --zywei 2006-01-17
Tester:
Describe: --��������ʱ��ͬʱ��ORG_BELONG������Ӧ�Ļ�����Ĳ�ι�ϵ
		  --Ŀǰ����ҳ�棺OrgInfo
Input Param:
		OrgID: �������
		RelativeOrgID: �ϼ��������
Output Param:

HistoryLog:
*/

import java.util.*;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddOrgBelong extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		//�Զ���ô���Ĳ���ֵ	  	    
		String sOrgID = (String)this.getAttribute("OrgID");
		String sRelativeOrgID = (String)this.getAttribute("RelativeOrgID");
				
		//����ֵת��Ϊ���ַ���
		if(sOrgID == null) sOrgID = "";
		if(sRelativeOrgID == null) sRelativeOrgID = "";	
				
		//�������
		Vector o_OrgInfo = new Vector();
		ASResultSet rs = null;
		String sSql = "";
		String sBelongOrgID = "";
		int iCount = 0;
		
		//�жϸû������ϼ�����֮��Ĳ�ι�ϵ�Ƿ��Ѵ���
		sSql = 	" select count(OrgID) from ORG_BELONG "+
				" where OrgID = '"+sOrgID+"' "+
				" and BelongOrgID = '"+sRelativeOrgID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		//�û������ϼ�����֮��Ĳ�ι�ϵ������
		if(iCount < 1)
		{
			//ɾ���û������ϼ�����֮��Ĳ�ι�ϵ������������
			Sqlca.executeSQL("delete from ORG_BELONG where BelongOrgID = '"+sOrgID+"'");
			
			//��ȡ�û����������ϼ��������
			sSql = 	" select distinct OrgID from ORG_BELONG "+
					" where BelongOrgID = '"+sRelativeOrgID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
				o_OrgInfo.add(rs.getString("OrgID"));
			rs.getStatement().close();
			
			o_OrgInfo.add(sOrgID);
			//�����û������ϼ�����֮��Ĳ�ι�ϵ
			if(o_OrgInfo.size() > 0)
			{
				for(int i=0;i<o_OrgInfo.size();i++)
				{
					sBelongOrgID = (String)o_OrgInfo.get(i);
					sSql = 	" insert into ORG_BELONG(OrgID,BelongOrgID) "+
							" values('"+sBelongOrgID+"','"+sOrgID+"') ";
					Sqlca.executeSQL(sSql);
				}
			}
		}
		
		
		
		return "1";
	}

}

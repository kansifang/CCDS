package com.lmt.app.cms;

/*
Author: --zywei 2006-01-17
Tester:
Describe: --��������ʱ��ͬʱ��ORG_BELONG������Ӧ�Ļ�����Ĳ�ι�ϵ
		  --Ŀǰ����ҳ�棺OrgInfo
Input Param:
		OrgID: �������
		RelativeOrgID: �ϼ��������
Output Param:

HistoryLog: ---modified by wwhe 20090909
					�ϳ������ϼ�����������org_belong
					���е���һ�����������Ȩ�޲鿴�����Լ�֧�л���
					������һ��������Ȩ�޲鿴֧��
					
					9999 ����Ϊ�����������л�����
					
				
					
*/

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.sql.Transaction;

public class AddOrgBelong extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		//�Զ���ô���Ĳ���ֵ	  	    
		String sOrgID 		= (String)this.getAttribute("OrgID");
		String sOrgLevel	= (String)this.getAttribute("OrgLevel");
		String sSortNo 		= (String)this.getAttribute("SortNo");
		String sRelativeOrgID 	= (String)this.getAttribute("RelativeOrgID");
				
		//����ֵת��Ϊ���ַ���
		if(sOrgID == null) sOrgID = "";
		if(sOrgLevel == null) sOrgLevel = "";	
		if(sSortNo == null) sSortNo = "";	
		if(sRelativeOrgID == null) sRelativeOrgID = "";	
		
		//����ǰɾ����û������йؼ�¼����ֹ�����ظ�
		Sqlca.executeSQL("delete from ORG_BELONG where BelongOrgID = '"+sOrgID+"'");
		Sqlca.executeSQL("delete from ORG_BELONG where OrgID = '"+sOrgID+"'");
		
		//1:����
		if(sOrgLevel.equals("0"))
		{
			//���¼������Ĳ鿴Ȩ��:���в���Ӧ�ÿ��Բ鿴�������ţ������������в��ţ�
			Sqlca.executeSQL("insert into ORG_BELONG select '"+sOrgID+"',OrgID from org_info where OrgID<>'"+sOrgID+"'");
			//���ϼ�����������Ȩ�ޣ����в��ţ�Ӧ�ñ��������в��ź�����鿴��
			Sqlca.executeSQL("insert into ORG_BELONG select OrgID,'"+sOrgID+"' from org_info where Orglevel='0'");
		}	
		
		//2:����
		if(sOrgLevel.equals("3"))
		{
			//���¼������Ĳ鿴Ȩ��:���в���Ӧ�ÿ��Բ鿴�������������ź�����
			Sqlca.executeSQL("insert into ORG_BELONG select '"+sOrgID+"',OrgID from org_info where RelativeOrgID = '"+sOrgID+"' or OrgID='"+sOrgID+"'");
			//���ϼ�����������Ȩ�ޣ����в��ţ�Ӧ�ñ����е����в��Ų鿴��
			Sqlca.executeSQL("insert into ORG_BELONG select OrgID,'"+sOrgID+"' from org_info where Orglevel='0'");
		}	
		
		//3��֧��
		if(sOrgLevel.equals("6"))
		{
			//���¼������Ĳ鿴Ȩ��:֧�в���Ӧ�ÿ��Բ鿴��֧���������ź�����
			Sqlca.executeSQL("insert into ORG_BELONG select '"+sOrgID+"',OrgID from org_info where RelativeOrgID = '"+sOrgID+"' or OrgID='"+sOrgID+"'");
			//���ϼ�����������Ȩ�ޣ�֧�в��ţ�Ӧ�ñ��������в��ţ����������в鿴��
			Sqlca.executeSQL("insert into ORG_BELONG select OrgID,'"+sOrgID+"' from org_info where Orglevel='0' or OrgID = '"+sRelativeOrgID+"'");
		}	
		
		//��������ţ�����������������û���������е�����ſ�ͷ������±�����������š�
		String sHeaderSortNo = Sqlca.getString("select SortNo from org_info where OrgID='"+sRelativeOrgID+"'");

		if(!sSortNo.startsWith(sHeaderSortNo))
		{   
			String sMaxSortNo = Sqlca.getString("select max(SortNo) from org_info where SortNo like '"+sHeaderSortNo+"%'");
			String sNewSortNo = "";
			if(sHeaderSortNo.equals(sMaxSortNo)){
				sNewSortNo = "0"+(Integer.parseInt(sMaxSortNo)+"00"+1);
			}else{
			    sNewSortNo = "0"+(Integer.parseInt(sMaxSortNo)+1);
			}
			
			Sqlca.executeSQL("update Org_Info set SortNo='"+sNewSortNo+"' where OrgID='"+sOrgID+"'");
		}
		return "1";
	}

}

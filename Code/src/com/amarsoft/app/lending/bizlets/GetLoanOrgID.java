/*
Author:   wangdw 2012/08/24
Tester:
Describe: ��ȡ�ſ����Ļ������
Input Param:
		SerialNo: ������ˮ��
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetLoanOrgID extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{	
		String sSerialNo ="";
		String sOrgFlag  ="";
		String sOrgID = "";
		String sLoanOrgID = "";
		String sRelativeOrgID = "";
		String sAPPROVEUSERID = "";
		boolean isZhongXiao = false;
		boolean isGeRen = false;
		String zhongXiao = "0N6";
		String geRen = "0B8";
		String sql1 = "";
		String sql2 = "";
		ASResultSet rs1=null;
		ASResultSet rs2=null;
		sSerialNo = (String)this.getAttribute("SerialNo");
		sql1 = "select nvl(OrgFlag,'') as OrgFlag,OrgID from Org_info where OrgID = (select OrgID from FLOW_TASK where " +
				"ObjectType = 'CreditApply' and ObjectNo =  '"+sSerialNo+"'  and PhaseNo='0010')";
		rs1 = Sqlca.getResultSet(sql1);
		if(rs1.next())
		{
			sOrgFlag = rs1.getString("OrgFlag");
			sOrgID   = rs1.getString("OrgID");
		}
		rs1.getStatement().close();
		//�жϷ�������Ƿ���ֱ��֧�з���ҵ��
		//ֱ��֧�з���
		if(sOrgFlag.equals("030"))
		{
			//ȡ������������id
			sql2 = "select nvl(APPROVEUSERID,'') as APPROVEUSERID from BUSINESS_APPLY where serialno =  '"+sSerialNo+"'";
			rs2 = Sqlca.getResultSet(sql2);
			if(rs2.next())
			{
				sAPPROVEUSERID = rs2.getString("APPROVEUSERID");
			}
			rs2.getStatement().close();
			//�жϸ�ҵ��������������Ƿ������С��ҵ��������Ȩ
			sql2 = "select * from user_role where userid='"+sAPPROVEUSERID+"' and roleid='"+zhongXiao+"'";
			rs2 = Sqlca.getResultSet(sql2);
			if(rs2.next())
			{
				isZhongXiao = true;
			}
			rs2.getStatement().close();
			//�жϸ�ҵ��������������Ƿ���и���ҵ����������Ȩ
			sql2 = "select * from user_role where userid='"+sAPPROVEUSERID+"' and roleid='"+geRen+"'";
			rs2 = Sqlca.getResultSet(sql2);
			if(rs2.next())
			{
				isGeRen = true;
			}
			//��ѯcodelibrary
			//ȡ���������˵Ľ�ɫ
			//�ж������������Ƿ���0N6��С��ҵ�ֲ�����������--������С��ҵ�ſ�����
			//�ж������������Ƿ���0B8����ҵ�������ֲ�������--���и��˷ſ�����
			//��������� ���зſ�����
			rs2.getStatement().close();
			if(isZhongXiao)
			{
				sql2 = "select itemno from code_library where codeno = 'LoanOrgIDMain' where itemname = '"+zhongXiao+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sLoanOrgID = rs2.getString("itemno");
				}
			}else if (isGeRen)
			{
				sql2 = "select itemno from code_library where codeno = 'LoanOrgIDMain' where itemname = '"+geRen+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sLoanOrgID = rs2.getString("itemno");
				}
			}else
			{
				sql2 = "select itemno from code_library where codeno = 'LoanOrgIDMain' where itemname != '"+geRen+"' and itemname != '"+geRen+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sLoanOrgID = rs2.getString("itemno");
				}
			}
		}else{
			//sLoanOrgID = "����֧�зſ�����";
			//ȡ�÷��������orgflag �����010������/֧�� ��ȡ�ϼ������ķſ������ֶ�
			//ȡ�÷��������orgflag �����020��������/040�������� ��ȡ�������ķſ������ֶ�
			if(sOrgFlag.equals("010"))
			{
				sql2 = "SELECT RelativeOrgID FROM  ORG_INFO WHERE OrgID ='"+sOrgID+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sRelativeOrgID = rs2.getString("RelativeOrgID");
				}
				sql2 = "select LoanOrgID  from ORG_INFO where OrgID ='"+sRelativeOrgID+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sLoanOrgID = rs2.getString("LoanOrgID");
				}
			}else if(sOrgFlag.equals("020")||sOrgFlag.equals("040"))
			{
				sql2 = "select LoanOrgID  from ORG_INFO where OrgID ='"+sOrgID+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sLoanOrgID = rs2.getString("LoanOrgID");
				}
			}
		}
		rs2.getStatement().close();
		return sLoanOrgID;
	}
}


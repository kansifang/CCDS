/*
Author:   wangdw 2012/08/17
Tester:
Describe: ����ҵ��Ʒ�ֻ�ȡ��Ŀ�Ų����³��˱��Ŀ�ֶ�
Input Param:
		SerialNo: ������ˮ��
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetSubjectByBusinessType extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{	
		String sSerialNo ="";
		//��ȡ����
		sSerialNo = (String)this.getAttribute("SerialNo");
		ASResultSet rs2=null;
		ASResultSet rs3=null;
		String sBusinessType = "";			//ҵ��Ʒ��
		String sTermMonth = "";				//������
		int iTermMonth = 0;					//������
		String sVouchType = "";				//������ʽ
		String sTimeLimitType = "";			//��������
		String sBankGroupFlag = "";			//���Ŵ���
		String sSUBJECTNO = "";				//��Ŀ��
		String sAGRILOANFLAG = "";			//�Ƿ���ũ
		String sql2 = "select BusinessType,TermMonth,VouchType from BUSINESS_PUTOUT where serialno='"+sSerialNo+"'";
		String sql3 = "select BC.BankGroupFlag,BC.AGRILOANFLAG from BUSINESS_CONTRACT BC,BUSINESS_PUTOUT BP where " +
				"BP.CONTRACTSERIALNO=BC.serialno and BP.serialno='"+sSerialNo+"'";
		try {
			rs2=Sqlca.getResultSet(sql2);
			rs3=Sqlca.getResultSet(sql3);
			if(rs2.next())
			{
				sBusinessType = rs2.getString("BusinessType")==null?"":rs2.getString("BusinessType");
				sVouchType = rs2.getString("VouchType")==null?"":rs2.getString("VouchType").substring(0, 3);
				sTermMonth = rs2.getString("TermMonth")==null?"":rs2.getString("TermMonth");
				//�����������Ϊ��
				if(sTermMonth.equals(null)||sTermMonth.equals(""))
				{
					sTimeLimitType = "";
				}else
				{
					iTermMonth = Integer.parseInt(rs2.getString("TermMonth")==null?"":rs2.getString("TermMonth"));
					//������޴���12������Ϊ�г���
					if(iTermMonth>12)
					{
						sTimeLimitType = "02";//�г���
					}else 
					//�������С�ڵ���12������Ϊ����	
					{
						sTimeLimitType = "01";//����
					}
					
				}
			}
			if(rs3.next())
			{
				sBankGroupFlag = rs3.getString("BankGroupFlag")==null?"":rs3.getString("BankGroupFlag");
				//����ñʴ�����1ֱ�����Ż���2������Ŵ���ҵ����
				//��ҵ��Ʒ����Ϊ���Ŵ���
				if(sBankGroupFlag.equals("1")||sBankGroupFlag.equals("3"))
				{
					//���Ŵ���
					sBusinessType = "1060";
				}
				//�Ƿ���ũ 1 �� 2 ��
				sAGRILOANFLAG = rs3.getString("AGRILOANFLAG")==null?"":rs3.getString("AGRILOANFLAG");
			}
			sql2 = "select SUBJECTNO from BUSINESSTYPE_SUBJECT where BUSINESSTYPE='"+sBusinessType+"' " +
					"and (VOUCHTYPE='"+sVouchType+"' or VOUCHTYPE = '060') and (TIMELIMITTYPE = '"+sTimeLimitType+"' or TIMELIMITTYPE = '09') " +
							"and (isfarmer = '"+sAGRILOANFLAG+"' or isfarmer is null) fetch first 1 rows only";
			rs2=Sqlca.getResultSet(sql2);
			if(rs2.next())
			{
				sSUBJECTNO = rs2.getString("SUBJECTNO")==null?"":rs2.getString("SUBJECTNO");
				Sqlca.executeSQL("update BUSINESS_PUTOUT set subject = "+sSUBJECTNO+" where serialno="+sSerialNo+"");
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		rs2.getStatement().close();
		rs3.getStatement().close();
		return "123";
	}
}


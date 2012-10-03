/*
Author:   wangdw 2012/08/24
Tester:
Describe: ���ݺ�ͬ�Ż�ȡ������
Input Param:
		SerialNo: ������ˮ��
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetShenqinghaoByHetonghao extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{	
		String sSerialNo ="";
		String sql1 = "";
		String sql2 = "";
		String sRELATIVESERIALNO = "";
		String sAPPLYTYPE = "";
		String sCREDITAGGREEMENT = "";
		ASResultSet rs1 = null;
		ASResultSet rs2 = null;
		//��ȡ����
		sSerialNo = (String)this.getAttribute("SerialNo");
		sql1= "select nvl(RELATIVESERIALNO,'') as RELATIVESERIALNO,nvl(APPLYTYPE,'') as APPLYTYPE,nvl(CREDITAGGREEMENT,'') as CREDITAGGREEMENT from BUSINESS_CONTRACT where serialno='"+sSerialNo+"'";
		rs1 = Sqlca.getASResultSet(sql1);
		if(rs1.next())
		{
			sRELATIVESERIALNO = rs1.getString("RELATIVESERIALNO");		//������
			sAPPLYTYPE 		  = rs1.getString("APPLYTYPE");				//���뷽ʽ
			sCREDITAGGREEMENT = rs1.getString("CREDITAGGREEMENT");		//ʹ������Э���	
		}
		rs1.getStatement().close();
		//����Ƕ������ҵ��
		if("DependentApply".equals(sAPPLYTYPE))
		{
			sql2 = "select RELATIVESERIALNO from BUSINESS_CONTRACT where where serialno=serialno='"+sCREDITAGGREEMENT+"'";
			rs2 = Sqlca.getASResultSet(sql2);
			if(rs2.next())
			{
				sRELATIVESERIALNO = rs2.getString("RELATIVESERIALNO");	//������
			}
		}
		return sRELATIVESERIALNO;
	}
}
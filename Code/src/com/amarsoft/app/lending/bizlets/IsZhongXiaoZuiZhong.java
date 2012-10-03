package com.amarsoft.app.lending.bizlets;
/*
		Author: --wangdw 2012/07/25
		Tester:
		Describe: --���ݺ�ͬ���жϸñ�ҵ���������Ϣ�������������Ƿ���0N6��С��ҵ�����ֲ�������Ȩ��
		Input Param:
				CONTRACTNO:--������ˮ��
		Output Param:
				return������ֵ��TRUE --����С��ҵ��������,FALSE--����С��ҵ����������

		HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;

public class IsZhongXiaoZuiZhong extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sSql = "";
		ASResultSet rs = null;
		String sObjectNo = "";
		String sCONTRACTNO = "";
		String sReturn = "";
		String sAPPROVEUSERID = "";  //����������id
		String sAPPLYTYPE = "";		 //���뷽ʽ
		String sCREDITAGGREEMENT = "";//ʹ������Э���
		sObjectNo = (String)this.getAttribute("ObjectNo");

        sSql = "select CONTRACTNO from Guaranty_Apply where SERIALNO = '"+sObjectNo+"'";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
        {
        	sCONTRACTNO = rs.getString("CONTRACTNO");
        }
        //rs.getStatement().close();
        
		sSql = "select  nvl(BA.APPROVEUSERID,'') as APPROVEUSERID,nvl(BA.CREDITAGGREEMENT,'') as CREDITAGGREEMENT,nvl(BC.APPLYTYPE,'') as APPLYTYPE from business_apply BA,BUSINESS_CONTRACT BC where BC.RELATIVESERIALNO=BA.serialno " +
				"and BC.serialno='"+sCONTRACTNO+"'";
		 rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sAPPROVEUSERID    = rs.getString("APPROVEUSERID");
			sAPPLYTYPE 		  = rs.getString("APPLYTYPE");
			sCREDITAGGREEMENT = rs.getString("CREDITAGGREEMENT");
		}
		//����ñʴ����ͬ�Ƕ�����µ�ҵ����ȡ�ñʶ�ȵ�����������
		if("DependentApply".equals(sAPPLYTYPE))
		{
			sSql = "select  nvl(BA.APPROVEUSERID,'') from business_apply BA,BUSINESS_CONTRACT BC where BC.RELATIVESERIALNO=BA.serialno " +
			"and BC.serialno='"+sCREDITAGGREEMENT+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sAPPROVEUSERID = rs.getString("APPROVEUSERID");
			}
		}
		sSql = "select * from user_role where userid='"+sAPPROVEUSERID+"' and roleid='0N6'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sReturn = "TRUE";
		}else
		{
			sReturn = "FALSE";
		}
		rs.getStatement().close();
		return sReturn;
	}
}

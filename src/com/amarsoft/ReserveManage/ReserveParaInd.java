package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;


public class ReserveParaInd {
	
	private Transaction Sqlca = null;
		
	public ReserveParaInd(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
	
	/**
	 * ���ݻ���·ݻ�ȡ��Ӧ�ļ�ֵ׼������
	 * @param sAccountMonth ����·�
	 * @return ArrayList ����Ϊ������·ݡ�����ھ�ʶ���ڼ䡢��ƿھ�ʶ���ڼ䡢......
	 */
	public ArrayList getReservePara(String sAccountMonth) throws Exception
	{
		//�������		
		ArrayList alReserveParaInd = new ArrayList();//��ŵ�ǰ����·ݵļ�ֵ׼������
		ASResultSet rs = null;
		String sSql = "";
		
		//������֯���������ȡ�ͻ���Ϣ
		sSql = 	" select AccountMonth,AAdjustValue,ALossRate1, "+
				" ALossRate2,OverDueDaysAdjust1,OverDueDaysAdjust2,OverDueDaysAdjust3,OverDueDaysAdjust4,OverDueDaysAdjust5,OverDueDaysAdjust6, "+
				" BaseDate,LastAccountMonth, Grade "+
				" from RESERVE_INDPARA "+
				" where AccountMonth = '"+sAccountMonth+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
            alReserveParaInd.add(0, rs.getString("AccountMonth") == null ? "" : rs.getString("AccountMonth"));//����·�
            alReserveParaInd.add(1, rs.getString("AAdjustValue") == null ? "" : rs.getString("AAdjustValue"));//��ƿھ�����ϵ��			
            alReserveParaInd.add(2, rs.getString("ALossRate1") == null ? "" : rs.getString("ALossRate1"));//��������������ʧ��
            alReserveParaInd.add(3, rs.getString("ALossRate2") == null ? "" : rs.getString("ALossRate2"));//��ƹ�ע�������ʧ��
            alReserveParaInd.add(4, rs.getString("OverDueDaysAdjust1") == null ? "" : rs.getString("ALossRate3"));//������������ϵ��
            alReserveParaInd.add(5, rs.getString("OverDueDaysAdjust2") == null ? "" : rs.getString("ALossRate4"));//����1-30��������ϵ��
            alReserveParaInd.add(6, rs.getString("OverDueDaysAdjust3") == null ? "" : rs.getString("ALossRate5"));//����31-90��������ϵ��
            alReserveParaInd.add(7, rs.getString("OverDueDaysAdjust4") == null ? "" : rs.getString("ALossRate5"));//����91-180��������ϵ��
            alReserveParaInd.add(8, rs.getString("OverDueDaysAdjust5") == null ? "" : rs.getString("ALossRate5"));//����181-360��������ϵ��
            alReserveParaInd.add(9, rs.getString("OverDueDaysAdjust6") == null ? "" : rs.getString("ALossRate5"));//����360������������ϵ��
            alReserveParaInd.add(10, rs.getString("BaseDate") == null ? "" : rs.getString("BaseDate"));//��׼����
            alReserveParaInd.add(11, rs.getString("LastAccountMonth") == null ? "" : rs.getString("LastAccountMonth"));//��һ�»���·�
            alReserveParaInd.add(12, rs.getString("Grade") == null ? "" : rs.getString("Grade"));//���¸��¼�ֵ׼��ʹ�õ��ֽ�������
			
		}
		rs.getStatement().close();
		
		return alReserveParaInd;
	}
}

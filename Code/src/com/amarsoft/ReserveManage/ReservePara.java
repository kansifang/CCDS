package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;


public class ReservePara {
	
	private Transaction Sqlca = null;
		
	public ReservePara(Transaction Sqlca)
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
		ArrayList alReservePara = new ArrayList();//��ŵ�ǰ����·ݵļ�ֵ׼������
		ASResultSet rs = null;
		String sSql = "";
		
		//������֯���������ȡ�ͻ���Ϣ
		sSql = 	" select AccountMonth,MLossTerm,ALossTerm,MAdjustValue,AAdjustValue, "+
				" MLossRate1,MLossRate2,MLossRate3,MLossRate4,MLossRate5,ALossRate1, "+
				" ALossRate2,ALossRate3,ALossRate4,ALossRate5,MBToCRate,MBToDRate, "+
				" MBToERate,ABToCRate,ABToDRate,ABToERate,MAToBRate,MAToCRate, "+
				" MAToDRate,MAToERate,AAToBRate,AAToCRate,AAToDRate,AAToERate, "+
				" BaseDate,LastAccountMonth, Grade "+
				" from RESERVE_PARA "+
				" where AccountMonth = '"+sAccountMonth+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			alReservePara.add(0, rs.getString("AccountMonth") == null ? "" : rs.getString("AccountMonth"));//����·�
			alReservePara.add(1, rs.getString("MLossTerm") == null ? "" : rs.getString("MLossTerm"));//����ھ�ʶ���ڼ�
			alReservePara.add(2, rs.getString("ALossTerm") == null ? "" : rs.getString("ALossTerm"));//��ƿھ�ʶ���ڼ�
			alReservePara.add(3, rs.getString("MAdjustValue") == null ? "" : rs.getString("MAdjustValue"));//����ھ�����ϵ��
			alReservePara.add(4, rs.getString("AAdjustValue") == null ? "" : rs.getString("AAdjustValue"));//��ƿھ�����ϵ��			
			alReservePara.add(5, rs.getString("MLossRate1") == null ? "" : rs.getString("MLossRate1"));//���������������ʧ��
			alReservePara.add(6, rs.getString("MLossRate2") == null ? "" : rs.getString("MLossRate2"));//�����ע�������ʧ��
			alReservePara.add(7, rs.getString("MLossRate3") == null ? "" : rs.getString("MLossRate3"));//����μ��������ʧ��
			alReservePara.add(8, rs.getString("MLossRate4") == null ? "" : rs.getString("MLossRate4"));//��������������ʧ��
			alReservePara.add(9, rs.getString("MLossRate5") == null ? "" : rs.getString("MLossRate5"));//������ʧ�������ʧ��
			alReservePara.add(10, rs.getString("ALossRate1") == null ? "" : rs.getString("ALossRate1"));//��������������ʧ��
			alReservePara.add(11, rs.getString("ALossRate2") == null ? "" : rs.getString("ALossRate2"));//��ƹ�ע�������ʧ��
			alReservePara.add(12, rs.getString("ALossRate3") == null ? "" : rs.getString("ALossRate3"));//��ƴμ��������ʧ��
			alReservePara.add(13, rs.getString("ALossRate4") == null ? "" : rs.getString("ALossRate4"));//��ƿ����������ʧ��
			alReservePara.add(14, rs.getString("ALossRate5") == null ? "" : rs.getString("ALossRate5"));//�����ʧ�������ʧ��
			alReservePara.add(15, rs.getString("MBToCRate") == null ? "" : rs.getString("MBToCRate"));//������עת�μ�Ǩ����
			alReservePara.add(16, rs.getString("MBToDRate") == null ? "" : rs.getString("MBToDRate"));//������עת����Ǩ����
			alReservePara.add(17, rs.getString("MBToERate") == null ? "" : rs.getString("MBToERate"));//������עת��ʧǨ����
			alReservePara.add(18, rs.getString("ABToCRate") == null ? "" : rs.getString("ABToCRate"));//��ƹ�עת�μ�Ǩ����
			alReservePara.add(19, rs.getString("ABToDRate") == null ? "" : rs.getString("ABToDRate"));//��ƹ�עת����Ǩ����
			alReservePara.add(20, rs.getString("ABToERate") == null ? "" : rs.getString("ABToERate"));//��ƹ�עת��ʧǨ����
			alReservePara.add(21, rs.getString("MAToBRate") == null ? "" : rs.getString("MAToBRate"));//���������ת��ע�μ�Ǩ����
			alReservePara.add(22, rs.getString("MAToCRate") == null ? "" : rs.getString("MAToCRate"));//���������ת�μ�Ǩ����
			alReservePara.add(23, rs.getString("MAToDRate") == null ? "" : rs.getString("MAToDRate"));//���������ת����Ǩ����
			alReservePara.add(24, rs.getString("MAToERate") == null ? "" : rs.getString("MAToERate"));//���������ת��ʧǨ����
			alReservePara.add(25, rs.getString("AAToBRate") == null ? "" : rs.getString("AAToBRate"));//�������ת��ע�μ�Ǩ����
			alReservePara.add(26, rs.getString("AAToCRate") == null ? "" : rs.getString("AAToCRate"));//�������ת�μ�Ǩ����
			alReservePara.add(27, rs.getString("AAToDRate") == null ? "" : rs.getString("AAToDRate"));//�������ת����Ǩ����
			alReservePara.add(28, rs.getString("AAToERate") == null ? "" : rs.getString("AAToERate"));//�������ת��ʧǨ����			
			alReservePara.add(29, rs.getString("BaseDate") == null ? "" : rs.getString("BaseDate"));//��׼����
			alReservePara.add(30, rs.getString("LastAccountMonth") == null ? "" : rs.getString("LastAccountMonth"));//��һ�»���·�
			alReservePara.add(31, rs.getString("Grade") == null ? "" : rs.getString("Grade"));//���¸��¼�ֵ׼��ʹ�õ��ֽ�������
			
		}
		rs.getStatement().close();
		
		return alReservePara;
	}


	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			java.sql.Connection conn = ConnectionManager.getConnection("jdbc:oracle:thin:@128.1.250.64:1521:ebank2",
					"oracle.jdbc.driver.OracleDriver", "credit", "credit");
			Transaction Sqlca = new Transaction(conn);
//			ReservePara t = new ReservePara(Sqlca);			
//			ArrayList al = t.getAandBLossRate("2007/11", "A", "Q");
//			
//			Sqlca.conn.commit();
//			for(int i =0; i< al.size(); i++){
//				System.out.println(al.get(i));
//			}
			
		}catch(Exception e)
		{
			e.printStackTrace();
			System.out.println(e.toString());
		}
	}
}

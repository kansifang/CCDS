package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import java.util.Vector;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;



public class ReservePredictData {
	
	private Transaction Sqlca = null;
	
	public ReservePredictData(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
	
	/**
	 * ���ݻ���·ݡ������ʺź�Ԥ�⼶������Ӧ��Ԥ���ֽ�����Ϣ
	 * @param sAccountMonth ����·ݣ�sLoanAccountNo �����ʺţ�sGrade Ԥ�⼶��
	 * @return ArrayList ����Ϊ������·ݡ�Ԥ���ջ����ڡ���ݺš�......
	 */
	public Vector getPredictCapital(String sAccountMonth,String sLoanAccountNo,String sGrade) throws Exception
	{
		//�������
		Vector vPredictCapital = new Vector();//��Ż���·ݺʹ����ʺŶ�ӦԤ���ֽ�����Ϣ
		ArrayList alPredictCapital = null;//���ÿһ��Ԥ���ֽ�����Ϣ
		ASResultSet rs = null;
		String sSql = "";
		
		sSql = 	" select AccountMonth,ReturnDate,ObjectNo,Grade, "+
				" PredictCapital,PredictInterest,Reason,GuarantyValue, "+
				" GuarantyReason,EnsureValue,EnsureReason,DueSum, "+
				" Discount,DiscountValue, LoanAccount "+
				" from RESERVE_PREDICTDATA "+
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' "+
				" and Grade = '"+sGrade+"' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			alPredictCapital = new ArrayList();
			alPredictCapital.add(0, rs.getString("AccountMonth")== null ? "" : rs.getString("AccountMonth"));//����·�
			alPredictCapital.add(1, rs.getString("ReturnDate")== null ? "" : rs.getString("ReturnDate"));//Ԥ���ջ�����
			alPredictCapital.add(2, rs.getString("ObjectNo")== null ? "" : rs.getString("ObjectNo"));//��ݺ�
			alPredictCapital.add(3, rs.getString("Grade")== null ? "" : rs.getString("Grade"));//Ԥ�⼶��
			alPredictCapital.add(4, rs.getString("PredictCapital")== null ? "" : rs.getString("PredictCapital"));//Ԥ���ֽ�������
			alPredictCapital.add(5, rs.getString("PredictInterest")== null ? "" : rs.getString("PredictInterest"));//Ԥ���ֽ�����Ϣ
			alPredictCapital.add(6, rs.getString("Reason")== null ? "" : rs.getString("Reason"));//�ֽ���Ԥ������
			alPredictCapital.add(7, rs.getString("GuarantyValue")== null ? "" : rs.getString("GuarantyValue"));//Ԥ�ƴ��õĵ�ѺƷ��ֵ
			alPredictCapital.add(8, rs.getString("GuarantyReason")== null ? "" : rs.getString("GuarantyReason"));//��ѺƷ��������
			alPredictCapital.add(9, rs.getString("EnsureValue")== null ? "" : rs.getString("EnsureValue"));//Ԥ�ƿ��ջصı�֤���
			alPredictCapital.add(10, rs.getString("EnsureReason")== null ? "" : rs.getString("EnsureReason"));//��֤�������
			alPredictCapital.add(11, rs.getString("DueSum")== null ? "" : rs.getString("DueSum"));//�ϼƽ��
			alPredictCapital.add(12, rs.getString("Discount")== null ? "" : rs.getString("Discount"));//������
			alPredictCapital.add(13, rs.getString("DiscountValue")== null ? "" : rs.getString("DiscountValue"));//����ֵ
			alPredictCapital.add(14, rs.getString("LoanAccount")== null ? "" : rs.getString("LoanAccount"));//�����ʺ�
			
			vPredictCapital.add(alPredictCapital);
		}
		rs.getStatement().close();	
		
		return vPredictCapital;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			
		}catch(Exception e)
		{
			System.out.println(e.toString());
		}
	}
}

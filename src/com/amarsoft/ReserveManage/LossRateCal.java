package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.Transaction;



public class LossRateCal {

	private String sAccountMonth;//�����·�
	private ReserveTotal rt = null;
	private String sMAScope;
	
	public LossRateCal(Transaction Sqlca, String sAccountMonth, String sMAScope)
	{		
		this.sAccountMonth = sAccountMonth;
		rt = new ReserveTotal(Sqlca);
		this.sMAScope = sMAScope;
	}
	
	/**
	 * ��ȡ���������������ʧ��
	 * @return
	 * @throws Exception
	 */
	public ArrayList getLossRate()throws Exception{
		ArrayList al = new ArrayList();
		//��������ı�����ʧ��
		al.add(calRate("03")+"");
		al.add(calRate("04")+"");
		al.add(calRate("05")+"");
		//���ڵ�ƽ����ʧ��
		al.add(calLossRate("03")+"");
		al.add(calLossRate("04")+"");
		al.add(calLossRate("05")+"");
		//���ڵļ�Ȩ��ʧ��
		al.add(calWLossRate("03")+"");
		al.add(calWLossRate("04")+"");
		al.add(calWLossRate("05")+"");
		return al;
	}
	
	/**
	 * �μ��������ʧ�ʣ����μ�������ֵ׼���ܶ�+��������μ�����/���μ����������ܶ�μ��������Ϣ�����ܶ�+��������μ�����
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	private double calRate(String sFiveResult)throws Exception{
		//���㱾����ʧ��
		return calRate(this.sAccountMonth, sFiveResult);
	}
	
	/**
	 * ��ȡĳ�ڵĴ�����ʧ��
	 * @param sAccountMonth
	 * @param sMAScope
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	private double calRate(String sAccountMonth, String sFiveResult)throws Exception{
		double dFiveBalance = rt.getFiveBalance(sAccountMonth, sMAScope, sFiveResult);
		double dFiveRBBalance = rt.getFiveRBBalance(sAccountMonth, sMAScope, sFiveResult);
		double dFiveCancelSum = rt.getFiveCancelSum(sAccountMonth, sMAScope, sFiveResult);
		double dFiveInterest = rt.getFiveInterest(sAccountMonth, sMAScope, sFiveResult);
		double dAllSum = dFiveBalance + dFiveInterest + dFiveCancelSum;
		if(dAllSum == 0.0)dAllSum = 1.0;
		double dFiveLossRate = (dFiveRBBalance + dFiveCancelSum)/dAllSum;
		return dFiveLossRate;
	}
	
	/**
	 * �μ������ƽ����ʧ�ʣ���ǰ����ʧ�ʣ�������ʧ�ʣ�������ʧ�ʣ�/3
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	private double calLossRate(String sFiveResult)throws Exception{
    	//��ȡ���ڻ�����
    	int iYear = Integer.parseInt(this.sAccountMonth.substring(0,4));
    	int iLastYear = iYear -1;
    	int iSecLastYear = iYear - 2;
    	double dSecLastLossRate = calRate(iSecLastYear+"/12", sFiveResult);
    	double dLastLossRate = calRate(iLastYear+"/12", sFiveResult);    
        double dLossRate = calRate(this.sAccountMonth, sFiveResult);
		return (dSecLastLossRate + dLastLossRate + dLossRate)/3.0;
	}
	
	
	/**
	 * �μ��������ʧ�ʼ�Ȩƽ��ֵ����ǰ��μ�������ֵ׼���ܶ�+ǰ��������μ������
	 *                        +ȥ��μ�������ֵ׼���ܶ�+ȥ������μ������
	 *                        +���ڴμ�������ֵ׼���ܶ�+���ں����μ�����
	 *                        /
	 *                        ��ǰ��μ����������ܶǰ��μ��������Ϣ�����ܶ�+ǰ�걾������μ������
	 *                        +ȥ��μ����������ܶȥ��μ��������Ϣ�����ܶ�+ȥ������μ������
	 *                        +���ڴμ����������ܶ���ڴμ��������Ϣ�����ܶ�+���ں����μ�����
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	private double calWLossRate(String sFiveResult)throws Exception{
    	//��ȡ���ڻ�����
    	int iYear = Integer.parseInt(this.sAccountMonth.substring(0,4));
    	int iLastYear = iYear -1;
    	int iSecLastYear = iYear - 2;

		double dSecLastFiveBalance = rt.getFiveBalance(iSecLastYear+"/12", sMAScope, sFiveResult);
		double dSecLastFiveRBBalance = rt.getFiveRBBalance(iSecLastYear+"/12", sMAScope, sFiveResult);
		double dSecLastFiveCancelSum = rt.getFiveCancelSum(iSecLastYear+"/12", sMAScope, sFiveResult);
		double dSecLastFiveInterest = rt.getFiveInterest(iSecLastYear+"/12", sMAScope, sFiveResult);
		
		double dLastFiveBalance = rt.getFiveBalance(iLastYear+"/12", sMAScope, sFiveResult);
		double dLastFiveRBBalance = rt.getFiveRBBalance(iLastYear+"/12", sMAScope, sFiveResult);
		double dLastFiveCancelSum = rt.getFiveCancelSum(iLastYear+"/12", sMAScope, sFiveResult);
		double dLastFiveInterest = rt.getFiveInterest(iLastYear+"/12", sMAScope, sFiveResult);
		
		double dFiveBalance = rt.getFiveBalance(this.sAccountMonth, sMAScope, sFiveResult);
		double dFiveRBBalance = rt.getFiveRBBalance(this.sAccountMonth, sMAScope, sFiveResult);
		double dFiveCancelSum = rt.getFiveCancelSum(this.sAccountMonth, sMAScope, sFiveResult);
		double dFiveInterest = rt.getFiveInterest(this.sAccountMonth, sMAScope, sFiveResult);
		
		double dAllSum = dSecLastFiveBalance + dSecLastFiveInterest + dSecLastFiveCancelSum +
        				 dLastFiveBalance + dLastFiveInterest + dLastFiveCancelSum + 
        				 dFiveBalance + dFiveInterest + dFiveCancelSum;
		if(dAllSum == 0.0)dAllSum = 1.0;
		double dWLossRate = (dSecLastFiveRBBalance + dSecLastFiveCancelSum +
				             dLastFiveRBBalance + dLastFiveCancelSum +
				             dFiveRBBalance + dFiveCancelSum)/dAllSum;
				             
		return dWLossRate;
	}

}

package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.Transaction;



public class LossRateCal {

	private String sAccountMonth;//本期月份
	private ReserveTotal rt = null;
	private String sMAScope;
	
	public LossRateCal(Transaction Sqlca, String sAccountMonth, String sMAScope)
	{		
		this.sAccountMonth = sAccountMonth;
		rt = new ReserveTotal(Sqlca);
		this.sMAScope = sMAScope;
	}
	
	/**
	 * 获取不良贷款的所有损失率
	 * @return
	 * @throws Exception
	 */
	public ArrayList getLossRate()throws Exception{
		ArrayList al = new ArrayList();
		//单独计算的本期损失率
		al.add(calRate("03")+"");
		al.add(calRate("04")+"");
		al.add(calRate("05")+"");
		//本期的平均损失率
		al.add(calLossRate("03")+"");
		al.add(calLossRate("04")+"");
		al.add(calLossRate("05")+"");
		//本期的加权损失率
		al.add(calWLossRate("03")+"");
		al.add(calWLossRate("04")+"");
		al.add(calWLossRate("05")+"");
		return al;
	}
	
	/**
	 * 次级类贷款损失率＝（次级类贷款减值准备总额+本年核销次级类贷款）/（次级类贷款贷款总额＋次级类贷款利息调整总额+本年核销次级类贷款）
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	private double calRate(String sFiveResult)throws Exception{
		//计算本期损失率
		return calRate(this.sAccountMonth, sFiveResult);
	}
	
	/**
	 * 获取某期的贷款损失率
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
	 * 次级类贷款平均损失率＝（前年损失率＋上年损失率＋本期损失率）/3
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	private double calLossRate(String sFiveResult)throws Exception{
    	//获取本期会计年份
    	int iYear = Integer.parseInt(this.sAccountMonth.substring(0,4));
    	int iLastYear = iYear -1;
    	int iSecLastYear = iYear - 2;
    	double dSecLastLossRate = calRate(iSecLastYear+"/12", sFiveResult);
    	double dLastLossRate = calRate(iLastYear+"/12", sFiveResult);    
        double dLossRate = calRate(this.sAccountMonth, sFiveResult);
		return (dSecLastLossRate + dLastLossRate + dLossRate)/3.0;
	}
	
	
	/**
	 * 次级类贷款损失率加权平均值＝（前年次级类贷款减值准备总额+前年年核销次级类贷款
	 *                        +去年次级类贷款减值准备总额+去年核销次级类贷款
	 *                        +本期次级类贷款减值准备总额+本期核销次级类贷款）
	 *                        /
	 *                        （前年次级类贷款贷款总额＋前年次级类贷款利息调整总额+前年本年核销次级类贷款
	 *                        +去年次级类贷款贷款总额＋去年次级类贷款利息调整总额+去年核销次级类贷款
	 *                        +本期次级类贷款贷款总额＋本期次级类贷款利息调整总额+本期核销次级类贷款）
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	private double calWLossRate(String sFiveResult)throws Exception{
    	//获取本期会计年份
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

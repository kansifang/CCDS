package com.amarsoft.ReserveManage;
/**
 * 名词转换：
 * 管理层口径不良贷款本期【转回】减值准备－－改为管理层口径不良贷款本期【折现回拨】减值准备
 * 管理层口径不良贷款本期【冲销】减值准备－－改为"管理层口径不良贷款本期【转回】减值准备"
 *
 * 
 */

import java.util.ArrayList;
import java.util.Vector;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;



public class ReserveCalculate {
	
	private Transaction Sqlca = null;
	
	public ReserveCalculate(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}

	/**
	 * 根据会计月份、贷款帐号和统计口径获取正常类贷款的组合计提减值准备
	 * 注意：针对管理正常类贷款损失率、管理口径识别期间、管理口径调整系数、这三指标均暂时与审计用同一个值计算
	 * @param alReserveTotal 依次为：会计月份、贷款帐号、......,sAccountMonth 会计月份,sScope 统计口径
	 * @return double 组合计提减值准备
	 */
	public double getACompReserveSum(ArrayList alReserveTotal,String sAccountMonth,String sScope) throws Exception
	{
		//定义变量		
		ArrayList alReservePara = new ArrayList();//存放减值计提参数信息		
		double dACompReserveSum = 0.0;//存放正常类贷款的组合计提减值准备
		double dExchangeRate = 0.0;//本期汇率
		double dBalance = 0.0;//本期本金
		double dInterest = 0.0;//本期利息调整
		double dMLossRate1 = 0.0;//管理正常类贷款损失率
		double dALossRate1 = 0.0;//审计正常类贷款损失率
		double dMLossTerm = 0.0;//管理口径识别期间
		double dALossTerm = 0.0;//审计口径识别期间
		double dMAdjustValue = 0.0;//管理口径调整系数
		double dAAdjustValue = 0.0;//审计口径调整系数
		
		
		//获得贷款数据库基础信息
		dExchangeRate = DataConvert.toDouble((String)alReserveTotal.get(31));//本期汇率
		dBalance = DataConvert.toDouble((String)alReserveTotal.get(30));//本期本金(目前余额)
		dInterest = DataConvert.toDouble((String)alReserveTotal.get(37));//本期利息调整
		
		//获取相应会计月份的减值计提参数信息
		ReservePara reservePara = new ReservePara(this.Sqlca);
		alReservePara = reservePara.getReservePara(sAccountMonth);
		if(!alReservePara.isEmpty())
		{
			//审计正常类贷款损失率
			String sALossRate1 = (String)alReservePara.get(10);
			if(sALossRate1 == null || sALossRate1.equals(""))sALossRate1 = "0.0";
			dALossRate1 = Double.parseDouble(sALossRate1)/100.0;
			dMLossRate1 = dALossRate1;
			
			//审计口径识别期间
			String sALossTerm = (String)alReservePara.get(2);
			if(sALossTerm == null || sALossTerm.equals(""))sALossTerm = "0.0";
			dALossTerm = Double.parseDouble(sALossTerm)/365.0;
			dMLossTerm = dALossTerm;
			
			//审计口径调整系数
			String sAAdjustValue = (String)alReservePara.get(4);
			if(sAAdjustValue == null || sAAdjustValue.equals(""))sAAdjustValue = "0.0";
			dAAdjustValue = Double.parseDouble(sAAdjustValue);
			dMAdjustValue = dAAdjustValue;
			
			//dMLossRate1 = Double.parseDouble((String)alReservePara.get(5));//管理正常类贷款损失率
			//dALossRate1 = Double.parseDouble((String)alReservePara.get(10));//审计正常类贷款损失率
			//dMLossTerm = Double.parseDouble((String)alReservePara.get(1));//管理口径识别期间
			//dALossTerm = Double.parseDouble((String)alReservePara.get(2));//审计口径识别期间
			//dMAdjustValue = Double.parseDouble((String)alReservePara.get(3));//管理口径调整系数
			//dAAdjustValue = Double.parseDouble((String)alReservePara.get(4));//审计口径调整系数
		}	
		
		if(sScope.equals("M")) //管理层口径
		{
			/*
			正常类贷款减值准备
			=本期汇率X(本期本金+本期利息调整)X本期正常类贷款损失率X本期损失识别期间X本期调整系数*/
			dACompReserveSum = dExchangeRate * (dBalance + dInterest) * dMLossRate1 * dMLossTerm * dMAdjustValue;
		}
		
		if(sScope.equals("A")) //审计口径
		{
			/*
			正常类贷款减值准备				
			=本期汇率X(本期本金+本期利息调整)X本期正常类贷款损失率X本期损失识别期间X本期调整系数*/
			dACompReserveSum = dExchangeRate * (dBalance + dInterest) * dALossRate1 * dALossTerm * dAAdjustValue;
		}
		
		return dACompReserveSum;
	}

    /**
     * 个人贷款组合计提计算公式
     * 根据会计月份、贷款帐号和统计口径获取正常类贷款的组合计提减值准备
     * 注意：针对管理正常类贷款损失率、管理口径识别期间、管理口径调整系数、这三指标均暂时与审计用同一个值计算
     * @param alReserveTotal 依次为：会计月份、贷款帐号、......,sAccountMonth 会计月份,sScope 统计口径
     * @return double 组合计提减值准备
     */
    public double getPACompReserveSum(ArrayList alReserveTotal,String sAccountMonth,String sScope) throws Exception
    {
        //定义变量      
        ArrayList alReservePara = new ArrayList();//存放减值计提参数信息      
        double dACompReserveSum = 0.0;//存放正常类贷款的组合计提减值准备
        double dExchangeRate = 0.0;//本期汇率
        double dBalance = 0.0;//本期本金
        double dInterest = 0.0;//本期利息调整
        double dMLossRate1 = 0.0;//管理正常类贷款损失率
        double dALossRate1 = 0.0;//审计正常类贷款损失率
        double dMAdjustValue = 0.0;//管理口径调整系数
        double dAAdjustValue = 0.0;//审计口径调整系数
        double dAOverDueDaysAdjust1 = 0.0;//审计口径正常调整系数
        double dAOverDueDaysAdjust2 = 0.0;//审计口径逾期1-30天数调整系数
        double dAOverDueDaysAdjust3 = 0.0;//逾期31-90天数调整系数
        double dAOverDueDaysAdjust4 = 0.0;//逾期91-180天数调整系数
        double dAOverDueDaysAdjust5 = 0.0;//逾期181-360天数调整系数
        double dAOverDueDaysAdjust6 = 0.0;//逾期360天以上数调整系数
        double dTemp = 0.0;//逾期天数调整系数
        
        //获得贷款数据库基础信息
        dExchangeRate = Double.parseDouble((String)alReserveTotal.get(31));//本期汇率
        dBalance = Double.parseDouble((String)alReserveTotal.get(30));//本期本金(目前余额)
        dInterest = DataConvert.toDouble((String)alReserveTotal.get(37));//本期利息调整
        
        //获取相应会计月份的减值计提参数信息
        ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
        alReservePara = reservePara.getReservePara(sAccountMonth);
        if(!alReservePara.isEmpty())
        {
            //审计正常类贷款损失率
            String sALossRate1 = (String)alReservePara.get(2);
            if(sALossRate1 == null || sALossRate1.equals(""))sALossRate1 = "0.0";
            dALossRate1 = DataConvert.toDouble(sALossRate1)/100.0;
            dMLossRate1 = dALossRate1;
            
            //审计口径调整系数
            String sAAdjustValue = (String)alReservePara.get(1);
            if(sAAdjustValue == null || sAAdjustValue.equals(""))sAAdjustValue = "0.0";
            dAAdjustValue = DataConvert.toDouble(sAAdjustValue);
            dMAdjustValue = dAAdjustValue;
            
            //审计口径调整系数
            dAOverDueDaysAdjust1 = DataConvert.toDouble((String)alReservePara.get(4));
            dAOverDueDaysAdjust2 = DataConvert.toDouble((String)alReservePara.get(5));
            dAOverDueDaysAdjust3 = DataConvert.toDouble((String)alReservePara.get(6));
            dAOverDueDaysAdjust4 = DataConvert.toDouble((String)alReservePara.get(7));
            dAOverDueDaysAdjust5 = DataConvert.toDouble((String)alReservePara.get(8));
            dAOverDueDaysAdjust6 = DataConvert.toDouble((String)alReservePara.get(9));
           
            double dOverDueDays = DataConvert.toDouble((String)alReserveTotal.get(72));
            if(dOverDueDays>0 && dOverDueDays<=30){
                dTemp = dAOverDueDaysAdjust2;
            }
            else if(dOverDueDays>30 && dOverDueDays<=90){
                dTemp = dAOverDueDaysAdjust3;
            }
            else if(dOverDueDays>90 && dOverDueDays<=180){
                dTemp = dAOverDueDaysAdjust4;
            }
            else if(dOverDueDays>180 && dOverDueDays<=360){
                dTemp = dAOverDueDaysAdjust5;
            }
            else if(dOverDueDays>360){
                dTemp = dAOverDueDaysAdjust6;
            }else{
                dTemp = dAOverDueDaysAdjust1;
            }

        }   
        
        if(sScope.equals("M")) //管理层口径
        {
            /*
            正常类贷款减值准备
            =本期汇率X(本期本金+本期利息调整)X本期正常类贷款损失率X本期损失识别期间X本期调整系数*/
            dACompReserveSum = dExchangeRate * (dBalance + dInterest) * dMLossRate1 * dMAdjustValue *dTemp ;
        }
        
        if(sScope.equals("A")) //审计口径
        {
            /*
            正常类贷款减值准备               
            =本期汇率X(本期本金+本期利息调整)X本期正常类贷款损失率X本期损失识别期间X本期调整系数*/
            dACompReserveSum = dExchangeRate * (dBalance + dInterest) * dALossRate1  * dAAdjustValue *dTemp;
        }
        
        return dACompReserveSum;
    }

	/**
	 * 根据会计月份、贷款帐号和统计口径获取关注类贷款的组合计提减值准备
	 * @param alReserveTotal 依次为：会计月份、贷款帐号、......,sAccountMonth 会计月份,sScope 统计口径
	 * @return double 组合计提减值准备
	 */
	public double getBCompReserveSum(ArrayList alReserveTotal,String sAccountMonth,String sScope) throws Exception
	{
		//定义变量		
		ArrayList alReservePara = new ArrayList();//存放减值计提参数信息		
		double dBCompReserveSum = 0.0;//存放关注类贷款的组合计提减值准备
		double dExchangeRate = 0.0;//本期汇率
		double dBalance = 0.0;//本期本金
		double dInterest = 0.0;//本期利息调整
		double dMLossRate2 = 0.0;//管理关注类贷款损失率
		double dALossRate2 = 0.0;//审计关注类贷款损失率
		double dMLossTerm = 0.0;//管理口径识别期间
		double dALossTerm = 0.0;//审计口径识别期间
		double dMAdjustValue = 0.0;//管理口径调整系数
		double dAAdjustValue = 0.0;//审计口径调整系数
		
		//获得贷款数据库基础信息
		dExchangeRate = DataConvert.toDouble((String)alReserveTotal.get(31));//本期汇率
		dBalance = DataConvert.toDouble((String)alReserveTotal.get(30));//本期本金(目前余额)
		dInterest = DataConvert.toDouble((String)alReserveTotal.get(37));//本期利息调整
		
		//获取相应会计月份的减值计提参数信息
		ReservePara reservePara = new ReservePara(this.Sqlca);
		alReservePara = reservePara.getReservePara(sAccountMonth);
		if(!alReservePara.isEmpty())
		{				
			//审计关注类贷款损失率
			String sALossRate2 = (String)alReservePara.get(11);
			if(sALossRate2 == null || sALossRate2.equals(""))sALossRate2 = "0.0";
			dALossRate2 = DataConvert.toDouble(sALossRate2)/100.0;
			dMLossRate2 = dALossRate2;
			
			//审计口径识别期间
			String sALossTerm = (String)alReservePara.get(2);
			if(sALossTerm == null || sALossTerm.equals(""))sALossTerm = "0.0";
			dALossTerm = DataConvert.toDouble(sALossTerm)/365.0;
			dMLossTerm = dALossTerm;
			
			//审计口径调整系数
			String sAAdjustValue = (String)alReservePara.get(4);
			if(sAAdjustValue == null || sAAdjustValue.equals(""))sAAdjustValue = "0.0";
			dAAdjustValue = DataConvert.toDouble(sAAdjustValue);
			dMAdjustValue = dAAdjustValue;

			//dMLossRate2 = DataConvert.toDouble((String)alReservePara.get(6));//管理关注类贷款损失率
			//dALossRate2 = DataConvert.toDouble((String)alReservePara.get(11));//审计关注类贷款损失率
			//dMLossTerm = DataConvert.toDouble((String)alReservePara.get(1));//管理口径识别期间
			//dALossTerm = DataConvert.toDouble((String)alReservePara.get(2));//审计口径识别期间
			//dMAdjustValue = DataConvert.toDouble((String)alReservePara.get(3));//管理口径调整系数
			//dAAdjustValue = DataConvert.toDouble((String)alReservePara.get(4));//审计口径调整系数 
		}
		
		if(sScope.equals("M")) //管理层口径
		{
			/*
			关注类贷款减值准备				
			=本期汇率X(本期本金+本期利息调整)X本期关注类贷款损失率X本期损失识别期间X本期调整系数*/
			dBCompReserveSum = dExchangeRate * (dBalance + dInterest) * dMLossRate2 * dMLossTerm * dMAdjustValue;
		}
		
		if(sScope.equals("A")) //审计口径
		{
			/*
			关注类贷款减值准备				
			=本期汇率X(本期本金+本期利息调整)X本期关注类贷款损失率X本期损失识别期间X本期调整系数*/
			dBCompReserveSum = dExchangeRate * (dBalance + dInterest) * dALossRate2 * dALossTerm * dAAdjustValue;
		}
		
		return dBCompReserveSum;
	}
    
    /**
     * 个人贷款，组合计提
     * 根据会计月份、贷款帐号和统计口径获取关注类贷款的组合计提减值准备
     * @param alReserveTotal 依次为：会计月份、贷款帐号、......,sAccountMonth 会计月份,sScope 统计口径
     * @return double 组合计提减值准备
     */
    public double getPBCompReserveSum(ArrayList alReserveTotal,String sAccountMonth,String sScope) throws Exception
    {
        //定义变量      
        ArrayList alReservePara = new ArrayList();//存放减值计提参数信息      
        double dBCompReserveSum = 0.0;//存放关注类贷款的组合计提减值准备
        double dExchangeRate = 0.0;//本期汇率
        double dBalance = 0.0;//本期本金
        double dInterest = 0.0;//本期利息调整
        double dMLossRate2 = 0.0;//管理关注类贷款损失率
        double dALossRate2 = 0.0;//审计关注类贷款损失率
        double dMAdjustValue = 0.0;//管理口径调整系数
        double dAAdjustValue = 0.0;//审计口径调整系数
        double dAOverDueDaysAdjust1 = 0.0;//审计口径正常调整系数
        double dAOverDueDaysAdjust2 = 0.0;//审计口径逾期1-30天数调整系数
        double dAOverDueDaysAdjust3 = 0.0;//逾期31-90天数调整系数
        double dAOverDueDaysAdjust4 = 0.0;//逾期91-180天数调整系数
        double dAOverDueDaysAdjust5 = 0.0;//逾期181-360天数调整系数
        double dAOverDueDaysAdjust6 = 0.0;//逾期360天以上数调整系数
        double dTemp = 0.0;//逾期天数调整系数
        
        //获得贷款数据库基础信息
        dExchangeRate = DataConvert.toDouble((String)alReserveTotal.get(31));//本期汇率
        dBalance = DataConvert.toDouble((String)alReserveTotal.get(30));//本期本金(目前余额)
        dInterest = DataConvert.toDouble((String)alReserveTotal.get(37));//本期利息调整
        
        //获取相应会计月份的减值计提参数信息
        ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
        alReservePara = reservePara.getReservePara(sAccountMonth);
        if(!alReservePara.isEmpty())
        {
            //审计正常类贷款损失率
            String sALossRate2 = (String)alReservePara.get(3);
            if(sALossRate2 == null || sALossRate2.equals(""))sALossRate2 = "0.0";
            dALossRate2 = DataConvert.toDouble(sALossRate2)/100.0;
            dMLossRate2 = dALossRate2;
            
            //审计口径调整系数
            String sAAdjustValue = (String)alReservePara.get(1);
            if(sAAdjustValue == null || sAAdjustValue.equals(""))sAAdjustValue = "0.0";
            dAAdjustValue = DataConvert.toDouble(sAAdjustValue);
            dMAdjustValue = dAAdjustValue;
            
            //审计口径调整系数
            dAOverDueDaysAdjust1 = DataConvert.toDouble((String)alReservePara.get(4));
            dAOverDueDaysAdjust2 = DataConvert.toDouble((String)alReservePara.get(5));
            dAOverDueDaysAdjust3 = DataConvert.toDouble((String)alReservePara.get(6));
            dAOverDueDaysAdjust4 = DataConvert.toDouble((String)alReservePara.get(7));
            dAOverDueDaysAdjust5 = DataConvert.toDouble((String)alReservePara.get(8));
            dAOverDueDaysAdjust6 = DataConvert.toDouble((String)alReservePara.get(9));
           
            double dOverDueDays = DataConvert.toDouble((String)alReserveTotal.get(72));
            if(dOverDueDays>0 && dOverDueDays<=30){
                dTemp = dAOverDueDaysAdjust2;
            }
            else if(dOverDueDays>30 && dOverDueDays<=90){
                dTemp = dAOverDueDaysAdjust3;
            }
            else if(dOverDueDays>90 && dOverDueDays<=180){
                dTemp = dAOverDueDaysAdjust4;
            }
            else if(dOverDueDays>180 && dOverDueDays<=360){
                dTemp = dAOverDueDaysAdjust5;
            }
            else if(dOverDueDays>360){
                dTemp = dAOverDueDaysAdjust6;
            }else{
                dTemp = dAOverDueDaysAdjust1;
            }

        }   
        
        if(sScope.equals("M")) //管理层口径
        {
            /*
            关注类贷款减值准备               
            =本期汇率X(本期本金+本期利息调整)X本期关注类贷款损失率X本期损失识别期间X本期调整系数*/
            dBCompReserveSum = dExchangeRate * (dBalance + dInterest) * dMLossRate2 * dMAdjustValue * dTemp;
        }
        
        if(sScope.equals("A")) //审计口径
        {
            /*
            关注类贷款减值准备               
            =本期汇率X(本期本金+本期利息调整)X本期关注类贷款损失率X本期损失识别期间X本期调整系数*/
            dBCompReserveSum = dExchangeRate * (dBalance + dInterest) * dALossRate2 * dAAdjustValue * dTemp;
        }
        
        return dBCompReserveSum;
    }

	
	/**
	 * 根据会计月份、贷款帐号和统计口径获取相应的单项计提减值准备
	 * @param alReserveTotal 依次为：会计月份、贷款帐号、......,sScope 统计口径
	 * @return double 单项计提减值准备
	 */
	public double getSingleReserveSum(ArrayList alReserveTotal,String sScope) throws Exception
	{
		//定义变量			
		String sCurAccountMonth = "";//本期会计月份
		String sLoanAccountNo = "";//贷款帐号
		double dSingleReserveSum = 0.0;//存放单项计提减值准备金
		double dExchangeRate = 0.0;//本期汇率
		double dBalance = 0.0;//本期本金
		double dInterest = 0.0;//本期利息调整
        String sBusinessFlag = ""; //业务标识 1-对公贷款   2-个人贷款
		String sMFiveClassify = "";//管理层五级分类
		String sAFiveClassify = "";//审计五级分类
		double dTotalBadPrdDiscount = 0.0;//本期现金流折现值
		double dMBadPrdDiscount = 0.0;//本期管理层现金流折现值
		double dABadPrdDiscount = 0.0;//本期审计现金流折现值
		
		//获得贷款数据库基础信息
		sCurAccountMonth = (String)alReserveTotal.get(0);//会计月份
		sLoanAccountNo = (String)alReserveTotal.get(1);//贷款帐号
		dExchangeRate = DataConvert.toDouble((String)alReserveTotal.get(31));//本期汇率
		dBalance = DataConvert.toDouble((String)alReserveTotal.get(30));//本期本金(目前余额)
		dInterest = DataConvert.toDouble((String)alReserveTotal.get(37));//本期利息调整
		sMFiveClassify = (String)alReserveTotal.get(34);//管理层五级分类
		sAFiveClassify = (String)alReserveTotal.get(35);//审计五级分类
        sBusinessFlag = (String)alReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
		//将空值转换为空字符串
		if(sMFiveClassify == null) sMFiveClassify = "";
		if(sAFiveClassify == null) sAFiveClassify = "";
		//本期现金流折现值
		dTotalBadPrdDiscount = getTotalBadPrdDiscount(sCurAccountMonth,sLoanAccountNo,sBusinessFlag);
		//损失类贷款默认本期现金流折现值为0
		if(!sMFiveClassify.equals("05"))
			dMBadPrdDiscount = dTotalBadPrdDiscount;
		if(!sAFiveClassify.equals("05"))
			dABadPrdDiscount = dTotalBadPrdDiscount;
				
		if(sScope.equals("M")) //管理层口径
		{
			/*
			不良贷款减值准备
			=单项计提准备金
			=本期汇率X(本期本金+本期利息调整)-本期现金流折现值*/
			dSingleReserveSum = dExchangeRate * (dBalance + dInterest) - dMBadPrdDiscount;
		}
		
		if(sScope.equals("A")) //审计口径
		{
			/*
			不良贷款减值准备
			=单项计提准备金
			=本期汇率X(本期本金+本期利息调整)-本期现金流折现值*/
			dSingleReserveSum = dExchangeRate * (dBalance + dInterest) - dABadPrdDiscount;
		}
		
		return dSingleReserveSum;
	}
	
	/**
	 * 获得本期不良贷款预测现金流折现值
	 * @param alReserveTotal 依次为：会计月份、贷款帐号、......
	 * @return ArrayList 依次为：管理层口径不良贷款本期预测现金流贴现值、审计口径不良贷款本期预测现金流贴现值
	 */
	public ArrayList getCurPredictCapital(ArrayList alReserveTotal) throws Exception
	{
		//定义变量		
		ArrayList alCurPredictCapital = new ArrayList();//存放管理层口径和审计口径的不良贷款本期预测现金流信息
		String sAccountMonth = "";//本期会计月份
		String sLoanAccountNo = "";//贷款帐号
		String sMFiveClassify = "";//本期管理层五级分类
		String sAFiveClassify = "";//本期审计五级分类
        String sBusinessFlag = "";//业务标识 1-对公贷款   2-个人贷款
		double dMTotalBadPrdDiscount = 0.0;//管理层口径不良贷款本期预测现金流贴现值
		double dATotalBadPrdDiscount = 0.0;//审计口径不良贷款本期预测现金流贴现值
		
		//获取本期贷款数据库基础数据
		sAccountMonth = (String)alReserveTotal.get(0);//本期会计月份
		sLoanAccountNo = (String)alReserveTotal.get(1);//贷款帐号
		sMFiveClassify = (String)alReserveTotal.get(34);//本期管理层五级分类		
		sAFiveClassify = (String)alReserveTotal.get(35);//本期审计五级分类
        sBusinessFlag = (String)alReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
		//将空值转换为空字符串
		if(sMFiveClassify == null) sMFiveClassify = "";
		if(sAFiveClassify == null) sAFiveClassify = "";
		
		//不良贷款需要计算本期现金流折现值
		if(!sMFiveClassify.equals("01") && !sMFiveClassify.equals("02") || !sAFiveClassify.equals("01") && !sAFiveClassify.equals("02"))
		{
			//损失类贷款默认本期现金流折现值为0，其他不良贷款需要按照公式计算
			if(!sMFiveClassify.equals("05") && !sAFiveClassify.equals("05")) //管理层口径和审计口径都不为损失类，则本期现金流折现值相等，即为公式计算所得
			{
				dMTotalBadPrdDiscount = getTotalBadPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
				dATotalBadPrdDiscount = dMTotalBadPrdDiscount;
			}else if(sMFiveClassify.equals("05") && !sAFiveClassify.equals("05"))//管理层口径为损失类，而审计口径都不为损失类，则管理层口径本期现金流折现值为0，而审计口径本期现金流折现值等于公式计算所得
			{
				dATotalBadPrdDiscount = getTotalBadPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
			}else if(!sMFiveClassify.equals("05") && sAFiveClassify.equals("05"))//管理层口径不为损失类，而审计口径都为损失类，则审计口径本期现金流折现值为0，而管理层口径本期现金流折现值等于公式计算所得
			{
				dMTotalBadPrdDiscount = getTotalBadPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
			}
		}
		
		alCurPredictCapital.add(0, String.valueOf(dMTotalBadPrdDiscount));
		alCurPredictCapital.add(1, String.valueOf(dATotalBadPrdDiscount));
		
		return alCurPredictCapital;
	}
	
	/**
	 * 获得本期不良贷款预测现金流折现值
	 * @param alReserveTotal 依次为：会计月份、贷款帐号、......
	 * @return ArrayList 依次为：管理层口径不良贷款本期预测现金流贴现值、审计口径不良贷款本期预测现金流贴现值
	 */
	public double getCurPredictCapital(ArrayList alReserveTotal, String sScope) throws Exception
	{
		//定义变量		
		String sAccountMonth = "";//本期会计月份
		String sLoanAccountNo = "";//贷款帐号
		String sFiveClassify = "";//本期五级分类
		String sBusinessFlag = "";//业务标识 1-对公贷款   2-个人贷款
		double dTotalBadPrdDiscount = 0.0;//不良贷款本期预测现金流贴现值
		
		//获取本期贷款数据库基础数据
		sAccountMonth = (String)alReserveTotal.get(0);//本期会计月份
		sLoanAccountNo = (String)alReserveTotal.get(1);//贷款帐号
        sBusinessFlag = (String)alReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
		if(sScope.equals("M")){
			sFiveClassify = (String)alReserveTotal.get(34);//本期管理层五级分类
		}else{
			sFiveClassify = (String)alReserveTotal.get(35);//本期审计五级分类
		}
		//将空值转换为空字符串
		if(sFiveClassify == null) sFiveClassify = "";
		
		//不良贷款需要计算本期现金流折现值, 损失类贷款默认本期现金流折现值为0
		if(sFiveClassify.equals("03") || sFiveClassify.equals("04")){
			dTotalBadPrdDiscount = getTotalBadPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);				
		}
		
		return dTotalBadPrdDiscount;
	}

	/**
	 * 根据不良贷款本期预测现金流获得不良贷款本期预测现金流贴现值
	 * @param sAccountMonth 会计月份，sLoanAccountNo 贷款帐号
	 * @return double 不良贷款本期预测现金流贴现值
	 */
	public double getTotalBadPrdDiscount(String sAccountMonth,String sLoanAccountNo,String sBusinessFlag) throws Exception
	{
		//定义变量
		Vector vPredictCapital = new Vector();//存放会计月份和贷款帐号对应预测现金流信息
		ArrayList alPredictCapital = new ArrayList();//存放每一笔预测现金流信息
		ArrayList alReservePara = new ArrayList();//存放当前会计月份的减值准备参数
		String sBaseDate = "";//基准日期
		String sReturnDate = "";//预计收回日期
		String sGrade = ""; //预测现金流使用的级别
		double dDiscountRate = 0.0;//折现率(即贷款数据库中的贷款实际利率)
		double dDueSum = 0.0;//每笔本期预测现金流
		double dTotalBadPrdDiscount = 0.0;//不良贷款预测现金流贴现值合计值
		double dBadPrdDiscount = 0.0;//每笔不良贷款预测现金流贴现值
		
		//获得相应会计月份的减值准备参数
        if("1".equals(sBusinessFlag)){
    		ReservePara reservePara = new ReservePara(this.Sqlca);
    		alReservePara = reservePara.getReservePara(sAccountMonth);
    		if(!alReservePara.isEmpty()){
    			sBaseDate = (String)alReservePara.get(29);
    		    sGrade = (String)alReservePara.get(31);
    		    if(sGrade.equals(""))sGrade = "04";//04-总行认定结果
    		}
        }else{
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sAccountMonth);
            if(!alReservePara.isEmpty()){
                sBaseDate = (String)alReservePara.get(29);
                sGrade = (String)alReservePara.get(31);
                if(sGrade.equals(""))sGrade = "04";//04-总行认定结果
            }
        }
		//获得会计月份的有效现金流数据（以最高审批级别Grade为05）
		ReservePredictData reservePredictData = new ReservePredictData(this.Sqlca);
		vPredictCapital = reservePredictData.getPredictCapital(sAccountMonth,sLoanAccountNo,sGrade);
		if(!vPredictCapital.isEmpty())
		{
			for(int i=0;i<vPredictCapital.size();i++)
			{
				alPredictCapital = (ArrayList)vPredictCapital.get(i);
				if(!alPredictCapital.isEmpty())
				{
					sReturnDate = (String)alPredictCapital.get(1);
					dDiscountRate = DataConvert.toDouble((String)alPredictCapital.get(12));
					dDueSum = DataConvert.toDouble((String)alPredictCapital.get(11));
					//获取每笔预测现金流的贴现值
					dBadPrdDiscount = getBadPrdDiscount(dDueSum,sReturnDate,sBaseDate,dDiscountRate);
					//dBadPrdDiscount = DataConvert.toDouble((String)alPredictCapital.get(13));
				}
				dTotalBadPrdDiscount += dBadPrdDiscount;
			}
		}
		
		return dTotalBadPrdDiscount;
	}
	
	/**
	 * 获得本期不良贷款上期预测现金流本期折现值
	 * @param alLastReserveTotal 会计月份（上一期）对应的贷款数据库基础数据、alCurReserveTotal 会计月份（本期）对应的贷款数据库基础数据
	 * @return ArrayList 依次为：管理层口径不良贷款上一期预测现金流本期贴现值、审计口径不良贷款上一期预测现金流本期贴现值
	 */
	public ArrayList getLastPredictCapital(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal) throws Exception
	{
		//定义变量		
		ArrayList alLastPredictCapital = new ArrayList();//存放管理层口径和审计口径的不良贷款上期预测现金流本期折现值信息
		String sAccountMonth = "";//本期会计月份
		String sLoanAccountNo = "";//贷款帐号
		String sLastMFiveClassify = "";//上期管理层五级分类
		String sLastAFiveClassify = "";//上期审计五级分类
        String sLastManageStatFlag = "";//上期计提方式
		double dMTotalBadLastPrdDiscount = 0.0;//管理层口径不良贷款上一期预测现金流本期贴现值
		double dATotalBadLastPrdDiscount = 0.0;//审计口径不良贷款上一期预测现金流本期贴现值
		String sBusinessFlag = "";////业务标识 1-对公贷款   2-个人贷款
		//获取本期贷款数据库基础数据
		sAccountMonth = (String)alCurReserveTotal.get(0);//本期会计月份
		sLoanAccountNo = (String)alCurReserveTotal.get(1);//贷款帐号
		//获取上期贷款数据库基础数据
		sLastMFiveClassify = (String)alLastReserveTotal.get(34);//上期管理层五级分类		
		sLastAFiveClassify = (String)alLastReserveTotal.get(35);//上期审计五级分类
        sLastManageStatFlag = (String)alLastReserveTotal.get(70);//上期记提方式
        sBusinessFlag = (String)alCurReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
		//将空值转换为空字符串
		if(sLastMFiveClassify == null) sLastMFiveClassify = "";
		if(sLastAFiveClassify == null) sLastAFiveClassify = "";
		
		
        
		if(sLastManageStatFlag.equals("2"))//单笔计提，上期不良贷款需要计算上期预测现金流本期折现值
		{
			//当上期贷款的管理层口径和审计口径五级分类为损失类，则上月不存在预测现金流，因此上期预测现金流本期折现值，反之，需要按照公式计算
			if(!sLastMFiveClassify.equals("05") && !sLastAFiveClassify.equals("05")) //管理层口径和审计口径都不为损失类，则上期预测现金流本期折现值相等，即为公式计算所得
			{
				dMTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
				dATotalBadLastPrdDiscount = dMTotalBadLastPrdDiscount;
			}else if(!sLastMFiveClassify.equals("05") && sLastAFiveClassify.equals("05")) //管理层口径上期预测现金流本期折现值为公式计算所得，审计口径上期预测现金流本期折现值为0
			{
				dMTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
			}else if(sLastMFiveClassify.equals("05") && !sLastAFiveClassify.equals("05")) //审计口径上期预测现金流本期折现值为公式计算所得，管理层口上期预测现金流本期折现值径为0
			{
				dATotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
			}
		}
		
		alLastPredictCapital.add(0, String.valueOf(dMTotalBadLastPrdDiscount));
		alLastPredictCapital.add(1, String.valueOf(dATotalBadLastPrdDiscount));
		
		return alLastPredictCapital;
	}

	/**
	 * 获得本期不良贷款上期预测现金流本期折现值
	 * @param alLastReserveTotal 会计月份（上一期）对应的贷款数据库基础数据、alCurReserveTotal 会计月份（本期）对应的贷款数据库基础数据
	 * @return ArrayList 依次为：管理层口径不良贷款上一期预测现金流本期贴现值、审计口径不良贷款上一期预测现金流本期贴现值
	 */
	public double getLastPredictCapital(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal, String sScope) throws Exception
	{
		//定义变量		
		String sAccountMonth = "";//本期会计月份
		String sLoanAccountNo = "";//贷款帐号
		String sLastFiveClassify = "";//上期五级分类
        String sLastManageStatFlag = "";//上期计提方式
        String sBusinessFlag = "";//业务标识 1-对公贷款   2-个人贷款
		double dTotalBadLastPrdDiscount = 0.0;//不良贷款上一期预测现金流本期贴现值
		//获取本期贷款数据库基础数据
		sAccountMonth = (String)alCurReserveTotal.get(0);//本期会计月份
		sLoanAccountNo = (String)alCurReserveTotal.get(1);//贷款帐号
        
        sBusinessFlag = (String)alCurReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
		//获取上期贷款数据库基础数据
		if(sScope.equals("M")){
			sLastFiveClassify = (String)alLastReserveTotal.get(34);//上期管理层五级分类
		}else{
			sLastFiveClassify = (String)alLastReserveTotal.get(35);//上期审计五级分类
		}
        sLastManageStatFlag = (String)alLastReserveTotal.get(70);//上期计提方式
		//将空值转换为空字符串
		if(sLastFiveClassify == null) sLastFiveClassify = "";
		
		//上期贷款为单笔计提, 损失类，则上月不存在预测现金流
		if(sLastManageStatFlag.equals("2") && !sLastFiveClassify.equals("05")){
				dTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
		}
		
		return dTotalBadLastPrdDiscount;
	}

	/**
	 * 根据不良贷款上一期预测现金流获得不良贷款上一期预测现金流本期贴现值
	 * @param sCurAccountMonth 会计月份（本期），sLoanAccountNo 贷款帐号
	 * @return double 不良贷款上一期预测现金流本期贴现值
	 */
	public double getTotalBadLastPrdDiscount(String sCurAccountMonth,String sLoanAccountNo,String sBusinessFlag) throws Exception
	{
		//定义变量
		Vector vPredictCapital = new Vector();//存放会计月份和贷款帐号对应预测现金流信息
		ArrayList alPredictCapital = new ArrayList();//存放每一笔预测现金流信息
		ArrayList alReservePara = new ArrayList();//存放当前会计月份的减值准备参数
		ArrayList alLastReservePara = new ArrayList();//存放上期会计月份的减值准备参数
		String sLastAccountMonth = "";//会计月份（上一期）
		String sLastGrade = "";//上一期更新减值准备使用的现金流级别
		String sBaseDate = "";//基准日期
		String sReturnDate = "";//预计收回日期
		double dDiscountRate = 0.0;//折现率(即贷款数据库中的贷款实际利率)
		double dDueSum = 0.0;//每笔本期预测现金流
		double dTotalBadPrdDiscount = 0.0;//不良贷款预测现金流贴现值合计值
		double dBadPrdDiscount = 0.0;//每笔不良贷款预测现金流贴现值
		if("1".equals(sBusinessFlag)){
    		//获得相应会计月份的减值准备参数
    		ReservePara reservePara = new ReservePara(this.Sqlca);
    		alReservePara = reservePara.getReservePara(sCurAccountMonth);
    		if(!alReservePara.isEmpty())
    		{
    			sBaseDate = (String)alReservePara.get(29);
    			sLastAccountMonth = (String)alReservePara.get(30);
    		}
    		
    		alLastReservePara = reservePara.getReservePara(sLastAccountMonth);
    		if(!alLastReservePara.isEmpty())
    		{
    			sLastGrade = (String)alReservePara.get(31);
    			if(sLastGrade.equals(""))sLastGrade = "04";//04-总行认定结果
    		}
        }else{
            //获得相应会计月份的减值准备参数
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
            {
                sBaseDate = (String)alReservePara.get(10);
                sLastAccountMonth = (String)alReservePara.get(11);
            }
            
            alLastReservePara = reservePara.getReservePara(sLastAccountMonth);
            if(!alLastReservePara.isEmpty())
            {
                sLastGrade = (String)alReservePara.get(12);
                if(sLastGrade.equals(""))sLastGrade = "04";//04-总行认定结果
            }
            
        }
		
		//获取会计月份（上一期）的有效现金流数据（以最高审批级别Grade为05）
		ReservePredictData reservePredictData = new ReservePredictData(this.Sqlca);
		vPredictCapital = reservePredictData.getPredictCapital(sLastAccountMonth,sLoanAccountNo,sLastGrade);
		if(!vPredictCapital.isEmpty())
		{
			for(int i=0;i<vPredictCapital.size();i++)
			{
				alPredictCapital = (ArrayList)vPredictCapital.get(i);
				if(!alPredictCapital.isEmpty())
				{
					sReturnDate = (String)alPredictCapital.get(1);
					dDiscountRate = DataConvert.toDouble((String)alPredictCapital.get(12));
					dDueSum = DataConvert.toDouble((String)alPredictCapital.get(11));
					//获取每笔预测现金流的贴现值
					dBadPrdDiscount = getBadPrdDiscount(dDueSum,sReturnDate,sBaseDate,dDiscountRate);
				}
				dTotalBadPrdDiscount += dBadPrdDiscount;
			}
		}
		
		return dTotalBadPrdDiscount;
	}
		
	/**
	 * 根据不良贷款每笔本期预测现金流获得不良贷款每笔本期预测现金流贴现值
	 * @param dDueSum 每笔本期预测现金流,sReturnDate 预计收回日期,sBaseDate 基准日期,dDiscountRate 折现率(即贷款数据库中的贷款实际利率)
	 * @return double 不良贷款每笔本期预测现金流贴现值
	 */
	private double getBadPrdDiscount(double dDueSum,String sReturnDate,String sBaseDate,double dDiscountRate) throws Exception
	{
		//定义变量
		double dBadPrdDiscount = 0.0;//不良贷款预测现金流贴现值		
		double dYears = 0.0;//年数
					
		//将预计收回日期与基准日期之间的时间差折算为年
		dYears = StringDeal.getQuot(sReturnDate, sBaseDate) / 365.0;
		
		//根据计算公式（ci/（1+r）^yi）获得相应的不良贷款预测现金流贴现值
		dBadPrdDiscount = dDueSum / Math.pow((1 + dDiscountRate/100.0),dYears);
		
		return dBadPrdDiscount;
	}
			
	/**
	 * 当该笔贷款为本期新增贷款时，获得审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 * @param alReserveTotal 依次为：会计月份、贷款帐号、......
	 * @return ArrayList 依次为：审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 */
	public ArrayList ReserveCalculateFormula1(ArrayList alReserveTotal) throws Exception
	{
		//定义变量
		ArrayList alReserveCalculateData = new ArrayList();//存放减值准备的相关信息
		String sCurAccountMonth = "";//本期会计月份
		String sMFiveClassify = "";//管理层五级分类
		String sAFiveClassify = "";//审计五级分类
        String sManageStatFlag = "";//记提方式 1-组合方式  2-单笔计提
        String sBusinessFlag = "";//业务标识 1-对公贷款   2-个人贷款
		
		//以下字段为贷款数据库中的要素	
		double dMCancelReserveSum = 0.0;//管理层口径本期核销减值准备
		double dACancelReserveSum = 0.0;//审计口径本期核销减值准备
		double dMExforLoss = 0.0;//管理层口径本期贷款汇兑损益
		double dAExforLoss = 0.0;//审计口径本期贷款汇兑损益
		double dMBadReserveSum = 0.0;//管理层口径不良贷款本期计提减值准备
		double dMBadMinusSum = 0.0;//管理层口径不良贷款本期冲销减值准备
		double dMBadRetSum = 0.0;//管理层口径不良贷款本期转回减值准备
		double dABadReserveSum = 0.0;//审计口径不良贷款本期计提减值准备
		double dABadMinusSum = 0.0;//审计口径不良贷款本期冲销减值准备
		double dABadRetSum = 0.0;//审计口径不良贷款本期转回减值准备
		double dMNormalReserveSum = 0.0;//管理层口径正常贷款本期计提减值准备
		double dMNormalMinusSum = 0.0;//管理层口径正常贷款本期冲销减值准备
		double dANormalReserveSum = 0.0;//审计口径正常贷款本期计提减值准备
		double dANormalMinusSum = 0.0;//审计口径正常贷款本期冲销减值准备
		
		//获得贷款数据表基础数据
		sCurAccountMonth = (String)alReserveTotal.get(0);//会计月份
		sMFiveClassify = (String)alReserveTotal.get(34);//管理层五级分类		
		sAFiveClassify = (String)alReserveTotal.get(35);//审计五级分类
        sManageStatFlag = (String)alReserveTotal.get(70);//记提方式 1-组合方式  2-单笔计提
        sBusinessFlag = (String)alReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
		//将空值转换为空字符串
		if(sMFiveClassify == null) sMFiveClassify = "";
		if(sAFiveClassify == null) sAFiveClassify = "";
        if(sBusinessFlag == null) sBusinessFlag = "";
		
		//按照管理层五级分类口径进行计算
        if(sManageStatFlag.equals("1")){//组合方式
    		if(sMFiveClassify.equals("01"))//0为正常
    		{
    			//获取组合计提准备金，计入管理层口径正常贷款本期计提减值准备
                if(sBusinessFlag.equals("1")){//对公贷款
                    dMNormalReserveSum = getACompReserveSum(alReserveTotal,sCurAccountMonth,"M");
                }else{//个人贷款
                    dMNormalReserveSum = getPACompReserveSum(alReserveTotal,sCurAccountMonth,"M");
                }
    		}else if(sMFiveClassify.equals("02"))//02为关注
    		{
    			//获取组合计提准备金，计入管理层口径正常贷款本期计提减值准备
                if(sBusinessFlag.equals("1")){//对公贷款
                    dMNormalReserveSum = getBCompReserveSum(alReserveTotal,sCurAccountMonth,"M");
                }else{//个人贷款
                    dMNormalReserveSum = getPBCompReserveSum(alReserveTotal,sCurAccountMonth,"M");
                }
    		}
        }
		else//单笔计提  03为次级、04为可疑、05为损失
		{
			//获取单项计提准备金，计入管理层口径不良贷款本期计提减值准备
			dMBadReserveSum = getSingleReserveSum(alReserveTotal,"M");
		}
				
		//按照审计口径五级分类口径进行计算
        if(sManageStatFlag.equals("1")){//组合方式
    		if(sAFiveClassify.equals("01"))//01为正常
    		{
    			//获取组合计提准备金，计入审计口径正常贷款本期计提减值准备
                if(sBusinessFlag.equals("1")){//对公贷款
                    dANormalReserveSum = getACompReserveSum(alReserveTotal,sCurAccountMonth,"A");
                }else{//个人贷款
                    dANormalReserveSum = getPACompReserveSum(alReserveTotal,sCurAccountMonth,"A");
                }
                
    		}else if(sAFiveClassify.equals("02"))//02为关注
    		{
    			//获取组合计提准备金，计入审计口径正常贷款本期计提减值准备
                if(sBusinessFlag.equals("1")){//对公贷款
                    dANormalReserveSum = getBCompReserveSum(alReserveTotal,sCurAccountMonth,"A");
                }else{//个人贷款
                    dANormalReserveSum = getPBCompReserveSum(alReserveTotal,sCurAccountMonth,"A");
                }
            }
		}else//单笔计提  03为次级、04为可疑、05为损失
		{
			//获取单项计提准备金，计入审计口径不良贷款本期计提减值准备
			dABadReserveSum = getSingleReserveSum(alReserveTotal,"A");
		}
		
		//将上述计算获得的数据存放在alReserveCalculateData中
		alReserveCalculateData.add(0, String.valueOf(dMCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dACancelReserveSum));
		alReserveCalculateData.add(2, String.valueOf(dMExforLoss));	
		alReserveCalculateData.add(3, String.valueOf(dAExforLoss));		
		alReserveCalculateData.add(4, String.valueOf(dMBadReserveSum));
		alReserveCalculateData.add(5, String.valueOf(dMBadMinusSum));
		alReserveCalculateData.add(6, String.valueOf(dMBadRetSum));		
		alReserveCalculateData.add(7, String.valueOf(dABadReserveSum));
		alReserveCalculateData.add(8, String.valueOf(dABadMinusSum));
		alReserveCalculateData.add(9, String.valueOf(dABadRetSum));		
		alReserveCalculateData.add(10, String.valueOf(dMNormalReserveSum));		
		alReserveCalculateData.add(11, String.valueOf(dMNormalMinusSum));		
		alReserveCalculateData.add(12, String.valueOf(dANormalReserveSum));
		alReserveCalculateData.add(13, String.valueOf(dANormalMinusSum));		
		
		return alReserveCalculateData;
	}
	
	/**
	 * 当上期某笔贷款本期完全收回时，获得审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 * @param alLastReserveTotal 会计月份（上一期）对应的贷款数据库基础数据、alCurReserveTotal 会计月份（本期）对应的贷款数据库基础数据
	 * @return ArrayList 依次为：审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 */
	public ArrayList ReserveCalculateFormula2(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal) throws Exception
	{
		//定义变量
		ArrayList alReserveCalculateData = new ArrayList();//存放减值准备的相关信息
		//double dLastMBadReserveSum = 0.0;//上期的管理层口径不良贷款计提减值准备
		//double dLastABadReserveSum = 0.0;//上期的审计口径不良贷款计提减值准备
		//double dLastMNormalReserveSum = 0.0;//上期的管理层口径正常贷款本期计提减值准备
		//double dLastANormalReserveSum = 0.0;//上期的审计口径正常贷款本期计提减值准备
		double dLastMBadReserveBalance = 0.0;//上期管理层口径不良贷款减值准备余额
		double dLastABadReserveBalance = 0.0;//上期审计口径不良贷款减值准备余额
		double dLastMNormalReserveBalance = 0.0;//上期管理层口径正常贷款本期减值准备余额
		double dLastANormalReserveBalance = 0.0;//上期审计口径正常贷款本期减值准备余额		
		double dLastBalance = 0.0;//上期的目前余额（原币）
		double dLastInterest = 0.0;//上期的利息调整
		double dLastExchangeRate = 0.0;//上期的汇率
		double dExchangeRate = 0.0;//本期汇率
		double dLastMReserveBalance = 0.0; //管理层上期计提的减值准备余额
		double dLastAReserveBalance = 0.0; //审计层上期计提的减值准备余额
		String sLastMFiveClassify = "";//上期的管理层五级分类
		String sLastAFiveClassify = "";//上期的审计五级分类
        String sLastManageStatFlag = "";//上期记提方式 1-组合方式  2-单笔计提
        String sCurBusinessFlag = "";//本期业务标识 1-对公贷款   2-个人贷款
		//以下字段为贷款数据库中的要素	
		double dMCancelReserveSum = 0.0;//管理层口径本期核销减值准备
		double dACancelReserveSum = 0.0;//审计口径本期核销减值准备
		double dMExforLoss = 0.0;//管理层口径本期贷款汇兑损益
		double dAExforLoss = 0.0;//审计口径本期贷款汇兑损益
		double dMBadReserveSum = 0.0;//管理层口径不良贷款本期计提减值准备
		double dMBadMinusSum = 0.0;//管理层口径不良贷款本期冲销减值准备－－改为管理层口径不良贷款本期转回减值准备
		double dMBadRetSum = 0.0;//管理层口径不良贷款本期转回减值准备--管理层口径不良贷款本期折现回拨减值准备
		double dABadReserveSum = 0.0;//审计口径不良贷款本期计提减值准备
		double dABadMinusSum = 0.0;//审计口径不良贷款本期冲销减值准备
		double dABadRetSum = 0.0;//审计口径不良贷款本期转回减值准备
		double dMNormalReserveSum = 0.0;//管理层口径正常贷款本期计提减值准备
		double dMNormalMinusSum = 0.0;//管理层口径正常贷款本期冲销减值准备
		double dANormalReserveSum = 0.0;//审计口径正常贷款本期计提减值准备
		double dANormalMinusSum = 0.0;//审计口径正常贷款本期冲销减值准备
	
		//获得上期贷款数据库基础数据
        sCurBusinessFlag = (String)alCurReserveTotal.get(71);//本期业务标识 1-对公贷款   2-个人贷款
		//dLastMBadReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(47));//上期的管理层口径不良贷款计提减值准备
		//dLastABadReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(53));//上期的审计口径不良贷款计提减值准备
		//dLastMNormalReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(58));//上期的管理层口径正常贷款本期计提减值准备
		//dLastANormalReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(61));//上期的审计口径正常贷款本期计提减值准备
		dLastBalance = DataConvert.toDouble((String)alLastReserveTotal.get(30));//上期的目前余额（原币）
		dLastInterest = DataConvert.toDouble((String)alLastReserveTotal.get(37));//上期的利息调整
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));//上期的汇率
		sLastMFiveClassify = (String)alLastReserveTotal.get(34);//上期管理层五级分类
		sLastAFiveClassify = (String)alLastReserveTotal.get(35);//上期审计五级分类
        sLastManageStatFlag = (String)alLastReserveTotal.get(70);//上期记提方式
		dLastMBadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(51));//管理层口径不良贷款本期减值准备余额
		dLastABadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(57));//审计口径不良贷款本期减值准备余额
		dLastMNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(60));//管理层口径正常贷款本期减值准备余额
		dLastANormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(63));//审计口径正常贷款本期减值准备余额
		
		//获得本期贷款数据库基础数据
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));//本期汇率
		
		//根据计算公式（上期应计提的减值准备+(上期原币本金+上期原币利息调整)×（本期汇率－上期汇率））获得管理层口径不良贷款本期冲销减值准备
		//dMBadMinusSum = dLastMBadReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//根据计算公式（上期应计提的减值准备+(上期原币本金+上期原币利息调整)×（本期汇率－上期汇率））获得审计口径不良贷款本期冲销减值准备
		//dABadMinusSum = dLastABadReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//根据计算公式（上期应计提的减值准备+(上期原币本金+上期原币利息调整)×（本期汇率－上期汇率））获得管理层口径正常贷款本期冲销减值准备
		//dMNormalMinusSum = dLastMNormalReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//根据计算公式（上期应计提的减值准备+(上期原币本金+上期原币利息调整)×（本期汇率－上期汇率））获得审计口径正常贷款本期冲销减值准备
		//dANormalMinusSum = dLastANormalReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//根据计算公式（(上期正常贷款组合计提准备金×（本期汇率/上期汇率-1））获得管理层口径本期贷款汇兑损益和审计口径本期贷款汇兑损益
        if(sLastManageStatFlag.equals("1")){//组合计提
    		if(sLastMFiveClassify.equals("01")|| sLastMFiveClassify.equals("02")){
    		    dMExforLoss = dLastMNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
    		    dLastMReserveBalance = dLastMNormalReserveBalance;
    			//根据计算公式 (本期转回减值准备=上期应计提的减值准备＋本期减值准备汇兑损)获取管理层本期转回减值准备和审计本期转回减值准备
    			dMNormalMinusSum = dLastMReserveBalance + dMExforLoss;
    		}
        }else{
			//根据计算公式（(上期原币本金+上期原币利息调整)×（本期汇率－上期汇率））获得管理层口径本期贷款汇兑损益和审计口径本期贷款汇兑损益
			dMExforLoss = (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
			//根据计算公式 本期减值准备折现回拨=(上期现金流本期折现值-上期现金流折现值)
			dMBadRetSum = getTotalBadLastPrdDiscount((String)alCurReserveTotal.get(0),(String)alCurReserveTotal.get(1),sCurBusinessFlag)- getTotalBadPrdDiscount((String)alLastReserveTotal.get(0),(String)alLastReserveTotal.get(1),(String)alLastReserveTotal.get(71));
			dLastMReserveBalance = dLastMBadReserveBalance;
			//根据计算公式 (本期转回减值准备=上期应计提的减值准备＋本期减值准备汇兑损－本期减值准备折现回拨)获取管理层本期转回减值准备和审计本期转回减值准备
			dMBadMinusSum = dLastMReserveBalance + dMExforLoss - dMBadRetSum;
		}
		
        if(sLastManageStatFlag.equals("1")){//组合计提
    		if(sLastAFiveClassify.equals("01")|| sLastAFiveClassify.equals("02")){
    		    dAExforLoss = dLastANormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
    		    dLastAReserveBalance = dLastANormalReserveBalance;
    			//根据计算公式 (本期转回减值准备=上期应计提的减值准备＋本期减值准备汇兑损)获取管理层本期转回减值准备和审计本期转回减值准备
    			dANormalMinusSum = dLastAReserveBalance + dAExforLoss;
    		}
        }else{
			//根据计算公式（(上期原币本金+上期原币利息调整)×（本期汇率－上期汇率））获得管理层口径本期贷款汇兑损益和审计口径本期贷款汇兑损益
			dAExforLoss = (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
			//根据计算公式 本期减值准备折现回拨=(上期现金流本期折现值-上期现金流折现值)
			dABadRetSum = getTotalBadLastPrdDiscount((String)alCurReserveTotal.get(0),(String)alCurReserveTotal.get(1),sCurBusinessFlag)- getTotalBadPrdDiscount((String)alLastReserveTotal.get(0),(String)alLastReserveTotal.get(1),(String)alLastReserveTotal.get(71));
			dLastAReserveBalance = dLastABadReserveBalance;
			//根据计算公式 (本期转回减值准备=上期应计提的减值准备＋本期减值准备汇兑损－本期减值准备折现回拨)获取管理层本期转回减值准备和审计本期转回减值准备
			dABadMinusSum = dLastAReserveBalance + dAExforLoss - dABadRetSum;
		}
				
		//将上述计算获得的数据存放在alReserveCalculateData中
		alReserveCalculateData.add(0, String.valueOf(dMCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dACancelReserveSum));
		alReserveCalculateData.add(2, String.valueOf(dMExforLoss));	
		alReserveCalculateData.add(3, String.valueOf(dAExforLoss));	
		alReserveCalculateData.add(4, String.valueOf(dMBadReserveSum));
		alReserveCalculateData.add(5, String.valueOf(dMBadMinusSum));
		alReserveCalculateData.add(6, String.valueOf(dMBadRetSum));		
		alReserveCalculateData.add(7, String.valueOf(dABadReserveSum));
		alReserveCalculateData.add(8, String.valueOf(dABadMinusSum));
		alReserveCalculateData.add(9, String.valueOf(dABadRetSum));		
		alReserveCalculateData.add(10, String.valueOf(dMNormalReserveSum));		
		alReserveCalculateData.add(11, String.valueOf(dMNormalMinusSum));		
		alReserveCalculateData.add(12, String.valueOf(dANormalReserveSum));
		alReserveCalculateData.add(13, String.valueOf(dANormalMinusSum));		
		
		return alReserveCalculateData;
	}
	
	/**
	 * 当上期某笔贷款本期完全核销时，获得审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 * @param alLastReserveTotal 会计月份（上一期）对应的贷款数据库基础数据、alCurReserveTotal 会计月份（本期）对应的贷款数据库基础数据
	 * @return ArrayList 依次为：审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 */
	public ArrayList ReserveCalculateFormula3(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal) throws Exception
	{
		//定义变量
		ArrayList alReserveCalculateData = new ArrayList();//存放减值准备的相关信息
		//double dLastMBadReserveSum = 0.0;//上期的管理层口径不良贷款本期计提减值准备
		//double dLastABadReserveSum = 0.0;//上期的审计口径不良贷款本期计提减值准备
		double dLastMBadReserveBalance = 0.0;//上期管理层口径不良贷款减值准备余额
		double dLastABadReserveBalance = 0.0;//上期审计口径不良贷款减值准备余额
		double dLastMNormalReserveBalance = 0.0;//上期管理层口径正常贷款本期减值准备余额
		double dLastANormalReserveBalance = 0.0;//上期审计口径正常贷款本期减值准备余额		
		double dLastBalance = 0.0;//上期的目前余额（原币）
		double dLastInterest = 0.0;//上期的利息调整
		double dLastExchangeRate = 0.0;//上期的汇率
		double dExchangeRate = 0.0;//本期汇率
		double dLastMReserveBalance = 0.0; //管理层上期计提的减值准备余额
		double dLastAReserveBalance = 0.0; //审计层上期计提的减值准备余额
		String sLastMFiveClassify = "";//上期的管理层五级分类
		String sLastAFiveClassify = "";//上期的审计五级分类
        String sLastManageStatFlag = "";//上期记提方式 1-组合方式  2-单笔计提
						
		//以下字段为贷款数据库中的要素	
		double dMCancelReserveSum = 0.0;//管理层口径本期核销减值准备
		double dACancelReserveSum = 0.0;//审计口径本期核销减值准备
		double dMExforLoss = 0.0;//管理层口径本期贷款汇兑损益
		double dAExforLoss = 0.0;//审计口径本期贷款汇兑损益
		double dMBadReserveSum = 0.0;//管理层口径不良贷款本期计提减值准备
		double dMBadMinusSum = 0.0;//管理层口径不良贷款本期冲销减值准备
		double dMBadRetSum = 0.0;//管理层口径不良贷款本期转回减值准备
		double dABadReserveSum = 0.0;//审计口径不良贷款本期计提减值准备
		double dABadMinusSum = 0.0;//审计口径不良贷款本期冲销减值准备
		double dABadRetSum = 0.0;//审计口径不良贷款本期转回减值准备
		double dMNormalReserveSum = 0.0;//管理层口径正常贷款本期计提减值准备
		double dMNormalMinusSum = 0.0;//管理层口径正常贷款本期冲销减值准备
		double dANormalReserveSum = 0.0;//审计口径正常贷款本期计提减值准备
		double dANormalMinusSum = 0.0;//审计口径正常贷款本期冲销减值准备
		
		//获得上期贷款数据库基础数据
		//dLastMBadReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(47));//上期的管理层口径不良贷款本期计提减值准备
		//dLastABadReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(53));//上期的审计口径不良贷款本期计提减值准备
		dLastBalance = DataConvert.toDouble((String)alLastReserveTotal.get(30));//上期的目前余额（原币）
		dLastInterest = DataConvert.toDouble((String)alLastReserveTotal.get(37));//上期的利息调整
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));//上期的汇率
		sLastMFiveClassify = (String)alLastReserveTotal.get(34);//上期管理层五级分类
		sLastAFiveClassify = (String)alLastReserveTotal.get(35);//上期审计五级分类
        sLastManageStatFlag = (String)alLastReserveTotal.get(70);//上期记提方式
		dLastMBadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(51));//管理层口径不良贷款本期减值准备余额
		dLastABadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(57));//审计口径不良贷款本期减值准备余额
		dLastMNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(60));//管理层口径正常贷款本期减值准备余额
		dLastANormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(63));//审计口径正常贷款本期减值准备余额
		
		//获得本期贷款数据库基础数据
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));//本期汇率
		
		//根据计算公式（上期应计提的减值准备+(上期原币本金+上期原币利息调整)×（本期汇率－上期汇率））获得管理层口径本期核销减值准备
		//dMCancelReserveSum = dLastMBadReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//根据计算公式（上期应计提的减值准备+(上期原币本金+上期原币利息调整)×（本期汇率－上期汇率））获得审计口径本期核销减值准备
		//dACancelReserveSum = dLastABadReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//根据计算公式（(上期原币本金+上期原币利息调整)×（本期汇率－上期汇率））获得管理层口径本期贷款汇兑损益和审计口径本期贷款汇兑损益
		dMExforLoss = (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		dAExforLoss = dMExforLoss;
       
		//根据计算公式（(上期正常贷款组合计提准备金×（本期汇率/上期汇率-1））获得管理层口径本期贷款汇兑损益和审计口径本期贷款汇兑损益
        if(sLastManageStatFlag.equals("1")){//组合计提
    		if(sLastMFiveClassify.equals("01")|| sLastMFiveClassify.equals("02")){
    		    dMExforLoss = dLastMNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
    		    dLastMReserveBalance = dLastMNormalReserveBalance;
    		}
        }else{
			//根据计算公式（(上期原币本金+上期原币利息调整)×（本期汇率－上期汇率））获得管理层口径本期贷款汇兑损益和审计口径本期贷款汇兑损益
			dMExforLoss = (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
			//根据计算公式 本期减值准备折现回拨=(上期现金流本期折现值-上期现金流折现值)
			dMBadRetSum = getTotalBadLastPrdDiscount((String)alCurReserveTotal.get(0),(String)alCurReserveTotal.get(1),(String)alCurReserveTotal.get(71))- getTotalBadPrdDiscount((String)alLastReserveTotal.get(0),(String)alLastReserveTotal.get(1),(String)alLastReserveTotal.get(71));
			dLastMReserveBalance = dLastMBadReserveBalance;
		}
		
        if(sLastManageStatFlag.equals("1")){//组合计提
    		if(sLastAFiveClassify.equals("01")|| sLastAFiveClassify.equals("02")){
    		    dAExforLoss = dLastANormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
    		    dLastAReserveBalance = dLastANormalReserveBalance;
    		}
        }else{
			//根据计算公式（(上期原币本金+上期原币利息调整)×（本期汇率－上期汇率））获得管理层口径本期贷款汇兑损益和审计口径本期贷款汇兑损益
			dAExforLoss = (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
			//根据计算公式 本期减值准备折现回拨=(上期现金流本期折现值-上期现金流折现值)
			dABadRetSum = getTotalBadLastPrdDiscount((String)alCurReserveTotal.get(0),(String)alCurReserveTotal.get(1),(String)alCurReserveTotal.get(71))- getTotalBadPrdDiscount((String)alLastReserveTotal.get(0),(String)alLastReserveTotal.get(1),(String)alLastReserveTotal.get(71));
			dLastAReserveBalance = dLastABadReserveBalance;
		}
		
		//根据计算公式 (本期核销减值准备=上期应计提的减值准备＋本期减值准备汇兑损－本期减值准备折现回拨)获取管理层本期转回减值准备和审计本期转回减值准备
		dMCancelReserveSum = dLastMReserveBalance + dMExforLoss - dMBadRetSum;
		dACancelReserveSum = dLastAReserveBalance + dAExforLoss - dABadRetSum;
		
		//将上述计算获得的数据存放在alReserveCalculateData中
		alReserveCalculateData.add(0, String.valueOf(dMCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dACancelReserveSum));
		alReserveCalculateData.add(2, String.valueOf(dMExforLoss));	
		alReserveCalculateData.add(3, String.valueOf(dAExforLoss));
		alReserveCalculateData.add(4, String.valueOf(dMBadReserveSum));
		alReserveCalculateData.add(5, String.valueOf(dMBadMinusSum));
		alReserveCalculateData.add(6, String.valueOf(dMBadRetSum));		
		alReserveCalculateData.add(7, String.valueOf(dABadReserveSum));
		alReserveCalculateData.add(8, String.valueOf(dABadMinusSum));
		alReserveCalculateData.add(9, String.valueOf(dABadRetSum));		
		alReserveCalculateData.add(10, String.valueOf(dMNormalReserveSum));		
		alReserveCalculateData.add(11, String.valueOf(dMNormalMinusSum));		
		alReserveCalculateData.add(12, String.valueOf(dANormalReserveSum));
		alReserveCalculateData.add(13, String.valueOf(dANormalMinusSum));		
		
		return alReserveCalculateData;
	}
		
	/**
	 * 当某笔贷款上期为正常贷款，本期为不良贷款时，获得审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 * @param alLastReserveTotal 会计月份（上一期）对应的贷款数据库基础数据、alCurReserveTotal 会计月份（本期）对应的贷款数据库基础数据
	 * @return ArrayList 依次为：审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 */
	public ArrayList ReserveCalculateFormula4(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal, String sScope) throws Exception
	{
		//定义变量
		ArrayList alReserveCalculateData = new ArrayList();//存放减值准备的相关信息		
		String sCurAccountMonth = "";//当前会计月份
		String sLoanAccountNo = "";//贷款帐号
		double dBalance = 0.0;//本期目前余额（原币）
		double dInterest = 0.0;//本期利息调整		
		double dExchangeRate = 0.0;//本期汇率
		double dLastNormalReserveBalance = 0.0;//上期正常贷款本期减值准备余额
		double dLastExchangeRate = 0.0;//上期的汇率
		String sBusinessFlag = "";//			业务标识 1-对公贷款   2-个人贷款	
		//以下字段为贷款数据库中的要素	
		double dCancelReserveSum = 0.0;//本期核销减值准备
		double dExforLoss = 0.0;//本期贷款汇兑损益
		double dBadReserveSum = 0.0;//不良贷款本期计提减值准备
		double dBadMinusSum = 0.0;//不良贷款本期冲销减值准备
		double dBadRetSum = 0.0;//不良贷款本期转回减值准备
		double dNormalReserveSum = 0.0;//正常贷款本期计提减值准备
		double dNormalMinusSum = 0.0;//正常贷款本期冲销减值准备
        sBusinessFlag = (String)alCurReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
		//获得上期贷款数据库基础数据
		if(sScope.equals("M")){//管理层
			dLastNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(60));
		}else{//审计层
			dLastNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(63));
		}
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));//上期的汇率
		//获得本期贷款数据库基础数据
		sCurAccountMonth = (String)alCurReserveTotal.get(0);//会计月份
		sLoanAccountNo = (String)alCurReserveTotal.get(1);//贷款帐号
		dBalance = DataConvert.toDouble((String)alCurReserveTotal.get(30));//本期目前余额（原币）
		dInterest = DataConvert.toDouble((String)alCurReserveTotal.get(37));//本期利息调整		
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));//本期汇率
        if(dLastExchangeRate==0){
            dLastExchangeRate =1;
        }
						
		//根据计算公式（上期正常贷款组合计提准备金×本期汇率/上期汇率）获得管理层口径正常贷款本期冲销减值准备
		dNormalMinusSum = dLastNormalReserveBalance * dExchangeRate / dLastExchangeRate;
		//根据计算公式（本期汇率×(本期本金+本期利息调整)-本期现金流折现值）获得管理层口径不良贷款本期计提减值准备
		dBadReserveSum = dExchangeRate * (dBalance + dInterest) - getTotalBadPrdDiscount(sCurAccountMonth,sLoanAccountNo,sBusinessFlag);
				
		//根据计算公式（(上期正常贷款组合计提准备金×（本期汇率/上期汇率-1））获得管理层口径本期贷款汇兑损益和审计口径本期贷款汇兑损益
		dExforLoss = dLastNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
				
		//将上述计算获得的数据存放在alReserveCalculateData中
		alReserveCalculateData.add(0, String.valueOf(dCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dExforLoss));	
		alReserveCalculateData.add(2, String.valueOf(dBadReserveSum));
		alReserveCalculateData.add(3, String.valueOf(dBadMinusSum));
		alReserveCalculateData.add(4, String.valueOf(dBadRetSum));		
		alReserveCalculateData.add(5, String.valueOf(dNormalReserveSum));		
		alReserveCalculateData.add(6, String.valueOf(dNormalMinusSum));		
		
		return alReserveCalculateData;
	}

	/**
	 * 当某笔贷款上期为不良贷款，本期为正常贷款时，获得审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 * @param alLastReserveTotal 会计月份（上一期）对应的贷款数据库基础数据、alCurReserveTotal 会计月份（本期）对应的贷款数据库基础数据
	 * @return ArrayList 依次为：审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 */
	public ArrayList ReserveCalculateFormula5(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal, String sScope) throws Exception
	{
		//定义变量
		ArrayList alReserveCalculateData = new ArrayList();//存放减值准备的相关信息
		ArrayList alReservePara = new ArrayList();//存放减值准备的参数
		String sCurAccountMonth = "";//本期会计月份
		String sLastAccountMonth = "";//上期会计月份
		String sLoanAccountNo = "";//贷款帐号
		double dExchangeRate = 0.0;//本期汇率
		String sFiveClassify = "";//五级分类
        String sBusinessFlag = "";//业务标识 1-对公贷款   2-个人贷款
		double dLastBadReserveBalance = 0.0;//上期不良贷款减值准备余额
		double dLastBalance = 0.0;//上期的目前余额（原币）
		double dLastInterest = 0.0;//上期的利息调整
		double dLastExchangeRate = 0.0;//上期的汇率
								
		//以下字段为贷款数据库中的要素	
		double dCancelReserveSum = 0.0;//本期核销减值准备
		double dExforLoss = 0.0;//本期贷款汇兑损益
		double dBadReserveSum = 0.0;//不良贷款本期计提减值准备
		double dBadMinusSum = 0.0;//不良贷款本期冲销减值准备
		double dBadRetSum = 0.0;//不良贷款本期转回减值准备
		double dNormalReserveSum = 0.0;//正常贷款本期计提减值准备
		double dNormalMinusSum = 0.0;//正常贷款本期冲销减值准备
		
		//获得本期贷款数据库基础信息
		sCurAccountMonth = (String)alCurReserveTotal.get(0);//本期会计月份
		sLoanAccountNo  = (String)alCurReserveTotal.get(1);//贷款帐号
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));//本期汇率
        sBusinessFlag = (String)alLastReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
		if(sScope.equals("M")){
			sFiveClassify = (String)alCurReserveTotal.get(34);//管理层五级分类
			dLastBadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(51));//上期管理层口径不良贷款减值准备余额
		}else{
			sFiveClassify = (String)alCurReserveTotal.get(35);//审计五级分类
			dLastBadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(57));//上期审计口径不良贷款减值准备余额
		}
		//将空值转换为空字符串
		if(sFiveClassify == null) sFiveClassify = "";
        if(sBusinessFlag == null) sBusinessFlag = "";
		
		//获得上期贷款数据库基础信息
		dLastBalance = DataConvert.toDouble((String)alLastReserveTotal.get(30));//上期的目前余额（原币）
		dLastInterest = DataConvert.toDouble((String)alLastReserveTotal.get(37));//上期的利息调整
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));//上期的汇率

        //获得相应会计月份的减值准备参数
        if("1".equals(sBusinessFlag)){
            ReservePara reservePara = new ReservePara(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(30);
        }else{
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(11);
        }
		//获得上期现金流折现值
		double dLastTotalBadPrdDiscount = getTotalBadPrdDiscount(sLastAccountMonth,sLoanAccountNo,sBusinessFlag);
		if(sScope.equals("M")){//管理层
			if(((String)alLastReserveTotal.get(34)).equals("05")){
				dLastTotalBadPrdDiscount = 0.0;
			}
		}else{//审计层
			if(((String)alLastReserveTotal.get(35)).equals("05")){
				dLastTotalBadPrdDiscount = 0.0;
			}			
		}
		//获得上期现金流本期折现值
		double dTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sCurAccountMonth,sLoanAccountNo,(String)alCurReserveTotal.get(71));
		if(sScope.equals("M")){//管理层
			if(((String)alLastReserveTotal.get(34)).equals("05")){
				dTotalBadLastPrdDiscount = 0.0;
			}
		}else{//审计层
			if(((String)alLastReserveTotal.get(35)).equals("05")){
				dTotalBadLastPrdDiscount = 0.0;
			}			
		}
		
		//根据计算公式（上期现金流本期折现值-上期现金流折现值）获得管理层口径不良贷款本期转回减值准备和审计口径不良贷款本期转回减值准备
		dBadRetSum = dTotalBadLastPrdDiscount - dLastTotalBadPrdDiscount;

		//根据计算公式（上期不良贷款单项计提准备金+（本期汇率-上期汇率）×(上期本金+上期利息调整)－本期减值准备折现回拨）获得管理层口径不良贷款本期冲销减值准备
		dBadMinusSum = dLastBadReserveBalance + (dExchangeRate - dLastExchangeRate) * (dLastBalance + dLastInterest) - dBadRetSum;
				
		//按照五级分类口径进行计算
		if(sFiveClassify.equals("01"))//0为正常
		{
			//获取组合计提准备金，计入正常贷款本期计提减值准备
            if(sBusinessFlag.equals("1")){//对公贷款
                dNormalReserveSum = getACompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }else{
                dNormalReserveSum = getPACompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }
		}else if(sFiveClassify.equals("02"))//02为关注
		{
			//获取组合计提准备金，计入正常贷款本期计提减值准备
            if(sBusinessFlag.equals("1")){//对公贷款
                dNormalReserveSum = getBCompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }else{//个人贷款
                dNormalReserveSum = getPBCompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }
		}
										
		//根据计算公式（（本期汇率-上期汇率）×(上期本金+上期利息调整)）获得本期贷款汇兑损益
		dExforLoss = (dExchangeRate - dLastExchangeRate) * (dLastBalance + dLastInterest);
		
		//将上述计算获得的数据存放在alReserveCalculateData中
		alReserveCalculateData.add(0, String.valueOf(dCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dExforLoss));	
		alReserveCalculateData.add(2, String.valueOf(dBadReserveSum));
		alReserveCalculateData.add(3, String.valueOf(dBadMinusSum));
		alReserveCalculateData.add(4, String.valueOf(dBadRetSum));		
		alReserveCalculateData.add(5, String.valueOf(dNormalReserveSum));		
		alReserveCalculateData.add(6, String.valueOf(dNormalMinusSum));		
		
		return alReserveCalculateData;
	}

	/**
	 * 当某笔贷款上期为正常贷款，本期为正常贷款时，获得审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 * @param alLastReserveTotal 会计月份（上一期）对应的贷款数据库基础数据、alCurReserveTotal 会计月份（本期）对应的贷款数据库基础数据
	 * @return ArrayList 依次为：审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 */
	public ArrayList ReserveCalculateFormula6(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal, String sScope) throws Exception
	{
		//定义变量
		ArrayList alReserveCalculateData = new ArrayList();//存放减值准备的相关信息
		ArrayList alReservePara = new ArrayList();//存放减值准备的参数
		String sCurAccountMonth = "";//当前会计月份
		String sLastAccountMonth = "";//上期会计月份
		double dLastExchangeRate = 0.0;//上期的汇率
		double dLastNormalReserveBalance = 0.0;//上期正常贷款组合计提准备金
		double dCurNormalReserveBalance = 0.0;//本期正常贷款组合计提准备金
		double dExchangeRate = 0.0;//本期汇率
		String sFiveClassify = "";//五级分类
        String sBusinessFlag = "";//业务标识 1-对公贷款   2-个人贷款
		double dCurCalculateSum = 0.0;//根据公式获得计算结果
		
						
		//以下字段为贷款数据库中的要素	
		double dCancelReserveSum = 0.0;//本期核销减值准备
		double dExforLoss = 0.0;//本期贷款汇兑损益
		double dBadReserveSum = 0.0;//不良贷款本期计提减值准备
		double dBadMinusSum = 0.0;//不良贷款本期冲销减值准备
		double dBadRetSum = 0.0;//不良贷款本期转回减值准备
		double dNormalReserveSum = 0.0;//正常贷款本期计提减值准备
		double dNormalMinusSum = 0.0;//正常贷款本期冲销减值准备
		
		//获得本期贷款数据库基础信息
		sCurAccountMonth = (String)alCurReserveTotal.get(0);//会计月份
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));//本期汇率
		if(sScope.equals("M")){
			sFiveClassify = (String)alCurReserveTotal.get(34);//管理层五级分类
			dLastNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(60));//上期管理层口径正常贷款组合计提准备金
		}
		else{
			sFiveClassify = (String)alCurReserveTotal.get(35);//审计五级分类
			dLastNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(63));//上期审计口径正常贷款组合计提准备金
		}
        sBusinessFlag = (String)alCurReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
		//将空值转换为空字符串
		if(sFiveClassify == null) sFiveClassify = "";
        if(sBusinessFlag == null) sBusinessFlag = "";
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));//上期的汇率
		if(dLastExchangeRate == 0){//防止后面做除法分母为零
            dLastExchangeRate = 1 ;      
        }
		
		//按照五级分类口径进行计算
		if(sFiveClassify.equals("01"))//0为正常
		{
			//获得本期正常贷款组合计提准备金
            if(sBusinessFlag.equals("1")){//对公贷款
                dCurNormalReserveBalance = getACompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }else{
                dCurNormalReserveBalance = getPACompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }
		}else if(sFiveClassify.equals("02"))//02为关注
		{
			//获得本期正常贷款组合计提准备金
            if(sBusinessFlag.equals("1")){//对公贷款
                dCurNormalReserveBalance = getBCompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }else{//个人贷款
                dCurNormalReserveBalance = getPBCompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }
		}
								
		//根据计算公式（本期正常贷款组合计提准备金-上期正常贷款组合计提准备金-上期正常贷款组合计提准备金×（本期汇率/上期汇率-1））获得管理层口径计算结果和审计口径计算结果
		dCurCalculateSum = dCurNormalReserveBalance - dLastNormalReserveBalance - dLastNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
		
		//当管理层口径计算结果大于0，则根据计算公式（本期正常贷款组合计提准备金-上期正常贷款组合计提准备金-上期正常贷款组合计提准备金×（本期汇率/上期汇率-1））获得管理层口径正常贷款本期计提减值准备
		if(dCurCalculateSum > 0)
			dNormalReserveSum = dCurNormalReserveBalance - dLastNormalReserveBalance - dLastNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
		else //反之，根据计算公式（上期正常贷款组合计提准备金+上期正常贷款组合计提准备金×（本期汇率/上期汇率-1）-本期正常贷款组合计提准备金）获得管理层口径正常贷款本期冲销减值准备
			dNormalMinusSum = dLastNormalReserveBalance + dLastNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1) - dCurNormalReserveBalance;
						
		//根据计算公式（上期正常贷款组合计提准备金×（本期汇率/上期汇率-1））获得管理层口径本期贷款汇兑损益和审计口径本期贷款汇兑损益
		dExforLoss = dLastNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
				
		//将上述计算获得的数据存放在alReserveCalculateData中
		alReserveCalculateData.add(0, String.valueOf(dCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dExforLoss));
		alReserveCalculateData.add(2, String.valueOf(dBadReserveSum));
		alReserveCalculateData.add(3, String.valueOf(dBadMinusSum));
		alReserveCalculateData.add(4, String.valueOf(dBadRetSum));		
		alReserveCalculateData.add(5, String.valueOf(dNormalReserveSum));		
		alReserveCalculateData.add(6, String.valueOf(dNormalMinusSum));		
		
		return alReserveCalculateData;
	}

	/**
	 * 当某笔贷款上期为不良贷款，本期为不良贷款时，获得审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 * @param alLastReserveTotal 会计月份（上一期）对应的贷款数据库基础数据、alCurReserveTotal 会计月份（本期）对应的贷款数据库基础数据
	 * @return ArrayList 依次为：审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 */
	private ArrayList ReserveCalculateFormula7(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal,String sBusinessFlag) throws Exception
	{
		//定义变量
		ArrayList alReserveCalculateData = new ArrayList();//存放减值准备的相关信息
		ArrayList alReservePara = new ArrayList();//存放减值准备的参数
		String sCurAccountMonth = "";//当前会计月份
		String sLastAccountMonth = "";//上期会计月份
		String sLoanAccountNo = "";//贷款帐号
		double dBalance = 0.0;//本期的目前余额（原币）
		double dInterest = 0.0;//本期的利息调整
		double dExchangeRate = 0.0;//本期汇率
		double dCurTotalBadPrdDiscount = 0.0;//本期现金流折现值
		double dTotalBadLastPrdDiscount = 0.0;//上期现金流本期折现值		
		double dLastTotalBadPrdDiscount = 0.0;//上期现金流折现值
		double dLastBalance = 0.0;//上期的目前余额（原币）
		double dLastInterest = 0.0;//上期的利息调整
		double dLastExchangeRate = 0.0;//上期的汇率
		//double dCurCalculateSum = 0.0;//根据公式获得计算结果
						
		//以下字段为贷款数据库中的要素	
		double dMCancelReserveSum = 0.0;//管理层口径本期核销减值准备
		double dACancelReserveSum = 0.0;//审计口径本期核销减值准备
		double dMExforLoss = 0.0;//管理层口径汇兑损益
		double dAExforLoss = 0.0;//审计口径汇兑损益		
		double dMBadReserveSum = 0.0;//管理层口径不良贷款本期计提减值准备
		double dMBadMinusSum = 0.0;//管理层口径不良贷款本期冲销减值准备
		double dMBadRetSum = 0.0;//管理层口径不良贷款本期转回减值准备
		double dABadReserveSum = 0.0;//审计口径不良贷款本期计提减值准备
		double dABadMinusSum = 0.0;//审计口径不良贷款本期冲销减值准备
		double dABadRetSum = 0.0;//审计口径不良贷款本期转回减值准备
		double dMNormalReserveSum = 0.0;//管理层口径正常贷款本期计提减值准备
		double dMNormalMinusSum = 0.0;//管理层口径正常贷款本期冲销减值准备
		double dANormalReserveSum = 0.0;//审计口径正常贷款本期计提减值准备
		double dANormalMinusSum = 0.0;//审计口径正常贷款本期冲销减值准备
		String sCurBusinessFlag = "";//本期业务标识 1-对公贷款   2-个人贷款
		String sLastBusinessFlag = "";//上期业务标识 1-对公贷款   2-个人贷款
		//获取当前的会计月份
		sCurAccountMonth = (String)alCurReserveTotal.get(0);
		sLoanAccountNo = (String)alCurReserveTotal.get(1);//获取贷款帐号
        sLastBusinessFlag = (String)alLastReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
        sCurBusinessFlag = (String)alCurReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
        //获得相应会计月份的减值准备参数
        if("1".equals(sBusinessFlag)){
            ReservePara reservePara = new ReservePara(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(30);
        }else{
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(11);
        }
		
		//获得本期现金流折现值
		dCurTotalBadPrdDiscount = getTotalBadPrdDiscount(sCurAccountMonth,sLoanAccountNo,sCurBusinessFlag);
		double dMCurTotalBadPrdDiscount = dCurTotalBadPrdDiscount;//管理层
		double dACurTotalBadPrdDiscount = dCurTotalBadPrdDiscount;//审计层
		if(((String)alCurReserveTotal.get(34)).equals("05")){
			dMCurTotalBadPrdDiscount = 0.0;
		}
		if(((String)alCurReserveTotal.get(35)).equals("05")){
			dACurTotalBadPrdDiscount = 0.0;
		}
		//获得上期现金流折现值
		dLastTotalBadPrdDiscount = getTotalBadPrdDiscount(sLastAccountMonth,sLoanAccountNo,sLastBusinessFlag);
		double dMLastTotalBadPrdDiscount = dLastTotalBadPrdDiscount;//管理层
		double dALastTotalBadPrdDiscount = dLastTotalBadPrdDiscount;//审计层
		if(((String)alLastReserveTotal.get(34)).equals("05")){
			dMLastTotalBadPrdDiscount = 0.0;
		}
		if(((String)alLastReserveTotal.get(35)).equals("05")){
			dALastTotalBadPrdDiscount = 0.0;
		}
		//获得上期现金流本期折现值
		dTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sCurAccountMonth,sLoanAccountNo,(String)alCurReserveTotal.get(71));
		double dMTotalBadLastPrdDiscount = dTotalBadLastPrdDiscount;//管理层
		double dATotalBadLastPrdDiscount = dTotalBadLastPrdDiscount;//审计层
		if(((String)alLastReserveTotal.get(34)).equals("05")){
			dMTotalBadLastPrdDiscount = 0.0;
		}
		if(((String)alLastReserveTotal.get(35)).equals("05")){
			dATotalBadLastPrdDiscount = 0.0;
		}
		
		//获得上期的目前余额（原币）
		dLastBalance = DataConvert.toDouble((String)alLastReserveTotal.get(30));
		//获得上期的利息调整
		dLastInterest = DataConvert.toDouble((String)alLastReserveTotal.get(37));
		//获得上期的汇率
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));
		//获得本期的目前余额（原币）
		dBalance = DataConvert.toDouble((String)alCurReserveTotal.get(30));
		//获得本期的利息调整
		dInterest = DataConvert.toDouble((String)alCurReserveTotal.get(37));
		//获得本期汇率
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));
		
		//根据计算公式（[（本期本金+本期利息调整）-（上期本金+上期利息调整）]×本期汇率+（上期现金流本期折现值-本期现金流折现值））获得计算结果
		//dCurCalculateSum = ((dBalance + dInterest) - (dLastBalance + dLastInterest)) * dExchangeRate + (dTotalBadLastPrdDiscount - dCurTotalBadPrdDiscount);
		double dMCurCalculateSum = ((dBalance + dInterest) - (dLastBalance + dLastInterest)) * dExchangeRate + (dMTotalBadLastPrdDiscount - dMCurTotalBadPrdDiscount);
		double dACurCalculateSum = ((dBalance + dInterest) - (dLastBalance + dLastInterest)) * dExchangeRate + (dATotalBadLastPrdDiscount - dACurTotalBadPrdDiscount);
		
		//当计算结果大于0，则管理层口径正常贷款本期计提减值准备和审计口径正常贷款本期计提减值准备都为计算结果
		if(dMCurCalculateSum > 0)
		{
			dMBadReserveSum = dMCurCalculateSum;
		}
		else //反之，管理层口径正常贷款本期冲销减值准备和审计口径正常贷款本期冲销减值准备都为计算结果
		{
			dMBadMinusSum = -dMCurCalculateSum;
		}
		//审计计算结果
		if(dACurCalculateSum > 0)
		{
			dABadReserveSum = dACurCalculateSum;
		}
		else //反之，管理层口径正常贷款本期冲销减值准备和审计口径正常贷款本期冲销减值准备都为计算结果
		{
			dABadMinusSum = -dACurCalculateSum;
		}

		//根据计算公式（上期现金流本期折现值-上期现金流折现值）获得管理层口径不良贷款本期转回减值准备和审计口径不良贷款本期转回减值准备
		dMBadRetSum = dMTotalBadLastPrdDiscount - dMLastTotalBadPrdDiscount;
		dABadRetSum = dATotalBadLastPrdDiscount - dALastTotalBadPrdDiscount;
				
		//根据计算公式（（本期汇率-上期汇率）×(上期本金+上期利息调整)）获得管理层口径汇兑损益和审计口径汇兑损益
		dAExforLoss = (dExchangeRate - dLastExchangeRate) * (dLastBalance + dLastInterest);
		dMExforLoss = (dExchangeRate - dLastExchangeRate) * (dLastBalance + dLastInterest);
				
		//将上述计算获得的数据存放在alReserveCalculateData中
		alReserveCalculateData.add(0, String.valueOf(dMCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dACancelReserveSum));
		alReserveCalculateData.add(2, String.valueOf(dMExforLoss));	
		alReserveCalculateData.add(3, String.valueOf(dAExforLoss));	
		alReserveCalculateData.add(4, String.valueOf(dMBadReserveSum));
		alReserveCalculateData.add(5, String.valueOf(dMBadMinusSum));
		alReserveCalculateData.add(6, String.valueOf(dMBadRetSum));		
		alReserveCalculateData.add(7, String.valueOf(dABadReserveSum));
		alReserveCalculateData.add(8, String.valueOf(dABadMinusSum));
		alReserveCalculateData.add(9, String.valueOf(dABadRetSum));		
		alReserveCalculateData.add(10, String.valueOf(dMNormalReserveSum));		
		alReserveCalculateData.add(11, String.valueOf(dMNormalMinusSum));		
		alReserveCalculateData.add(12, String.valueOf(dANormalReserveSum));
		alReserveCalculateData.add(13, String.valueOf(dANormalMinusSum));		
		
		return alReserveCalculateData;
	}

	/**
	 * 当某笔贷款上期为不良贷款，本期为不良贷款时，获得审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 * @param alLastReserveTotal 会计月份（上一期）对应的贷款数据库基础数据、alCurReserveTotal 会计月份（本期）对应的贷款数据库基础数据
	 * @return ArrayList 依次为：审计口径本期核销减值准备、管理层口径本期核销减值准备、......
	 */
	public ArrayList ReserveCalculateFormula7(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal, String sScope,String sBusinessFlag) throws Exception
	{
		//定义变量
		ArrayList alReserveCalculateData = new ArrayList();//存放减值准备的相关信息
		ArrayList alReservePara = new ArrayList();//存放减值准备的参数
		String sCurAccountMonth = "";//当前会计月份
		String sLastAccountMonth = "";//上期会计月份
		String sLoanAccountNo = "";//贷款帐号
		double dBalance = 0.0;//本期的目前余额（原币）
		double dInterest = 0.0;//本期的利息调整
		double dExchangeRate = 0.0;//本期汇率
		double dCurTotalBadPrdDiscount = 0.0;//本期现金流折现值
		double dTotalBadLastPrdDiscount = 0.0;//上期现金流本期折现值		
		double dLastTotalBadPrdDiscount = 0.0;//上期现金流折现值
		double dLastBalance = 0.0;//上期的目前余额（原币）
		double dLastInterest = 0.0;//上期的利息调整
		double dLastExchangeRate = 0.0;//上期的汇率
						
		//以下字段为贷款数据库中的要素	
		double dCancelReserveSum = 0.0;//本期核销减值准备
		double dExforLoss = 0.0;//汇兑损益	
		double dBadReserveSum = 0.0;//不良贷款本期计提减值准备
		double dBadMinusSum = 0.0;//不良贷款本期冲销减值准备
		double dBadRetSum = 0.0;//不良贷款本期转回减值准备
		double dNormalReserveSum = 0.0;//正常贷款本期计提减值准备
		double dNormalMinusSum = 0.0;//正常贷款本期冲销减值准备
        
        String sCurBusinessFlag = "";//本期业务标识 1-对公贷款   2-个人贷款
        String sLastBusinessFlag = "";//上期业务标识 1-对公贷款   2-个人贷款
		
		//获取当前的会计月份
		sCurAccountMonth = (String)alCurReserveTotal.get(0);
		sLoanAccountNo = (String)alCurReserveTotal.get(1);//获取贷款帐号
		//获得相应会计月份的减值准备参数
        if("1".equals(sBusinessFlag)){
    		ReservePara reservePara = new ReservePara(this.Sqlca);
    		alReservePara = reservePara.getReservePara(sCurAccountMonth);
    		if(!alReservePara.isEmpty())
    			sLastAccountMonth = (String)alReservePara.get(30);
        }else{
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(11);
        }
        sLastBusinessFlag = (String)alLastReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款
        sCurBusinessFlag = (String)alCurReserveTotal.get(71);//业务标识 1-对公贷款   2-个人贷款

		//获得本期现金流折现值
		dCurTotalBadPrdDiscount = getTotalBadPrdDiscount(sCurAccountMonth,sLoanAccountNo,sCurBusinessFlag);
		if(sScope.equals("M")){//管理层
			if(((String)alCurReserveTotal.get(34)).equals("05")){
				dCurTotalBadPrdDiscount = 0.0;
			}
		}else{//审计层
			if(((String)alCurReserveTotal.get(35)).equals("05")){
				dCurTotalBadPrdDiscount = 0.0;
			}			
		}
		//获得上期现金流折现值
		dLastTotalBadPrdDiscount = getTotalBadPrdDiscount(sLastAccountMonth,sLoanAccountNo,sLastBusinessFlag);
		if(sScope.equals("M")){//管理层
			if(((String)alLastReserveTotal.get(34)).equals("05")){
				dLastTotalBadPrdDiscount = 0.0;
			}
		}else{//审计层
			if(((String)alLastReserveTotal.get(35)).equals("05")){
				dLastTotalBadPrdDiscount = 0.0;
			}			
		}
		//获得上期现金流本期折现值
		dTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sCurAccountMonth,sLoanAccountNo,(String)alCurReserveTotal.get(71));
		if(sScope.equals("M")){//管理层
			if(((String)alLastReserveTotal.get(34)).equals("05")){
				dTotalBadLastPrdDiscount = 0.0;
			}
		}else{//审计层
			if(((String)alLastReserveTotal.get(35)).equals("05")){
				dTotalBadLastPrdDiscount = 0.0;
			}			
		}
		
		//获得上期的目前余额（原币）
		dLastBalance = DataConvert.toDouble((String)alLastReserveTotal.get(30));
		//获得上期的利息调整
		dLastInterest = DataConvert.toDouble((String)alLastReserveTotal.get(37));
		//获得上期的汇率
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));
		//获得本期的目前余额（原币）
		dBalance = DataConvert.toDouble((String)alCurReserveTotal.get(30));
		//获得本期的利息调整
		dInterest = DataConvert.toDouble((String)alCurReserveTotal.get(37));
		//获得本期汇率
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));
		
		//根据计算公式（[（本期本金+本期利息调整）-（上期本金+上期利息调整）]×本期汇率+（上期现金流本期折现值-本期现金流折现值））获得计算结果
		//dCurCalculateSum = ((dBalance + dInterest) - (dLastBalance + dLastInterest)) * dExchangeRate + (dTotalBadLastPrdDiscount - dCurTotalBadPrdDiscount);
		double dCurCalculateSum = ((dBalance + dInterest) - (dLastBalance + dLastInterest)) * dExchangeRate + (dTotalBadLastPrdDiscount - dCurTotalBadPrdDiscount);
		
		//当计算结果大于0，则管理层口径正常贷款本期计提减值准备和审计口径正常贷款本期计提减值准备都为计算结果
		if(dCurCalculateSum > 0)
		{
			dBadReserveSum = dCurCalculateSum;
		}
		else //反之，管理层口径正常贷款本期冲销减值准备和审计口径正常贷款本期冲销减值准备都为计算结果
		{
			dBadMinusSum = -dCurCalculateSum;
		}
		//根据计算公式（上期现金流本期折现值-上期现金流折现值）获得管理层口径不良贷款本期转回减值准备和审计口径不良贷款本期转回减值准备
		dBadRetSum = dTotalBadLastPrdDiscount - dLastTotalBadPrdDiscount;
				
		//根据计算公式（（本期汇率-上期汇率）×(上期本金+上期利息调整)）获得管理层口径汇兑损益和审计口径汇兑损益
		dExforLoss = (dExchangeRate - dLastExchangeRate) * (dLastBalance + dLastInterest);
				
		//将上述计算获得的数据存放在alReserveCalculateData中
		alReserveCalculateData.add(0, String.valueOf(dCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dExforLoss));	
		alReserveCalculateData.add(2, String.valueOf(dBadReserveSum));
		alReserveCalculateData.add(3, String.valueOf(dBadMinusSum));
		alReserveCalculateData.add(4, String.valueOf(dBadRetSum));		
		alReserveCalculateData.add(5, String.valueOf(dNormalReserveSum));		
		alReserveCalculateData.add(6, String.valueOf(dNormalMinusSum));		
		
		return alReserveCalculateData;
	}

	/**
	 * 计算本期的累计收回金额
	 * @param sLastAccountMonth  上期会计月份
	 * @param sAccountMonth      本期会计月份
	 * @param sLoanAccountNo     贷款帐号
	 * @return
	 * @throws Exception
	 */
	public double calRetSum(String sLastAccountMonth, String sAccountMonth, String sLoanAccountNo) throws Exception{
		//定义变量
		String sSql = "";
		ASResultSet rs = null;
		double dRetSum = 0.0;
		
		sSql = 	" select sum(MonthRetSum) from RESERVE_TOTAL "+
				" where (AccountMonth <= '"+sAccountMonth+"' "+
				" and AccountMonth > '"+sLastAccountMonth+"') "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dRetSum = rs.getDouble(1);
		}
		rs.getStatement().close();
		
		return dRetSum;
	}
	
	/**
	 * 计算本期的累计核销金额
	 * @param sLastAccountMonth  上期会计月份
	 * @param sAccountMonth      本期会计月份
	 * @param sLoanAccountNo     贷款帐号
	 * @return
	 * @throws Exception
	 */
	public double calOmitSum(String sLastAccountMonth, String sAccountMonth, String sLoanAccountNo) throws Exception{
		//定义变量
		String sSql = "";
		ASResultSet rs = null;
		double dOmitSum = 0.0;
		
		sSql = 	" select sum(MonthOmitSum) from RESERVE_TOTAL "+
				" where (AccountMonth <= '"+sAccountMonth+"' "+
				" and AccountMonth > '"+sLastAccountMonth+"') "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dOmitSum = rs.getDouble(1);
		}
		rs.getStatement().close();
		
		return dOmitSum;
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

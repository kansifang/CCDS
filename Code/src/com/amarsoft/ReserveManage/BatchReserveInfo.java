package com.amarsoft.ReserveManage;
/**
 * 特别注意：
 *   1、sAuditRate:贷款实际年利率核心无法获取，故简单赋值为贷款年利率
 *   2、sPdgSum:  贷款发生费用，由于核心无法获取，故简单赋值为＝0
 *   3、sGuarantyDiscountValue,抵押物公允价值，无法获取，故简单赋值为 ＝sGuarantyNowValue (抵质押物现评估值)
 */
import java.util.ArrayList;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;


public class BatchReserveInfo {

	private Transaction Sqlca = null;
	private boolean debug = true;
		
	public BatchReserveInfo(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;		
	}



	/**
	 * 更新贷款数据库中会计月份和贷款帐号相对应记录的减值计提数据信息
	 * @param 
	 * @return 
	 */
	public void runCalculateData(String sAccountMonth,String sLoanAccountNo,String sManageStatFlag,String sBusinessFlag) throws Exception
	{
        //定义变量			
		ArrayList alReserveTotal = new ArrayList();//存放贷款数据库的减值计提信息

		try
		{		        
			ReserveTotal reserveTotal = new ReserveTotal(this.Sqlca);	
            if("1".equals(sManageStatFlag)){
                alReserveTotal = this.BatchCalculateData(sAccountMonth,sLoanAccountNo,sBusinessFlag);
            }else{
                alReserveTotal = this.singleCalculateData(sAccountMonth,sLoanAccountNo,sBusinessFlag);
            }
			if(!alReserveTotal.isEmpty())
				reserveTotal.updateReserveTotal(alReserveTotal);				
		}catch(Exception e)
		{
			e.printStackTrace();
			System.out.println("--------BatchReserveInfo.runCalculateData--------"+e.toString());
		}
	}
			


    /**
     * 组合计提批量计算接口，调用相应的公式获得相应口径的减值计提数据
     * @param sLoanAccountNo 贷款帐号
     * @return ArrayList 依次为：核销减值准备、本期贷款汇兑损益、管理层口径上期预测现金流本期贴现值、......
     */
    private ArrayList BatchCalculateData(String sAccountMonth,String sLoanAccountNo,String sBusinessFlag) throws Exception
    {
        //定义变量
        ArrayList alReserveTotal = new ArrayList();//存放减值准备的贷款数据库计算数据信息
        ArrayList alReserveBasicData = new ArrayList();//存放减值准备的贷款数据库基础数据信息
        ArrayList alLastReserveBasicData = new ArrayList();//存放减值准备的贷款数据库基础数据信息（上一期）
        ArrayList alReserveCalculateData = new ArrayList();//存放减值准备的贷款数据库减值计提信息（根据公式计算） 
        ArrayList alReservePara = new ArrayList();//存放当前会计月份的减值准备参数
        ArrayList alLastPredictCapital = new ArrayList();//存放管理层口径和审计口径的不良贷款上期预测现金流本期折现值信息
        boolean bExistFlag = true;//贷款数据库中是否存在本期贷款帐户的标志（即是否已经处理过）
        String sLastAccountMonth = "";//减值计提准备参数表中的上期会计月份       
        String sMFiveClassify = "";//本期管理层五级分类
        String sAFiveClassify = "";//本期审计五级分类
        String sManageStatFlag = "";//本期计提方式
        String sLastMFiveClassify = "";//上期管理层五级分类
        String sLastAFiveClassify = "";//上期审计五级分类
        String sLastManageStatFlag = "";//上期计提方式
        
        double dLastBalance = 0.0;//上期贷款余额
        double dBalance = 0.0;//本期贷款余额
        double dRetSum = 0.0;//本期收回金额
        double dOmitSum = 0.0;//本期核销金额
        
        //以下字段为贷款数据库中的要素
        String sMCancelReserveSum = "0.0";//管理层口径核销减值准备
        String sACancelReserveSum = "0.0";//审计口径核销减值准备
        String sMExforLoss = "0.0";//管理层口径本期贷款汇兑损益
        String sAExforLoss = "0.0";//审计口径本期贷款汇兑损益
        String sMBadLastPrdDiscount = "0.0";//管理层口径上期预测现金流本期贴现值
        String sMBadPrdDiscount = "0.0";//管理层口径不良贷款本期预测现金流贴现值
        String sMBadReserveSum = "0.0";//管理层口径不良贷款本期计提减值准备
        String sMBadMinusSum = "0.0";//管理层口径不良贷款本期冲销减值准备
        String sMBadRetSum = "0.0";//管理层口径不良贷款本期转回减值准备
        String sMBadReserveBalance = "0.0";//管理层口径不良贷款本期减值准备余额
        String sABadLastprdDiscount = "0.0";//审计口径不良贷款上期预测现金流本期贴现值
        String sABadPrdDiscount = "0.0";//审计口径不良贷款本期预测现金流贴现值
        String sABadReserveSum = "0.0";//审计口径不良贷款本期计提减值准备
        String sABadMinusSum = "0.0";//审计口径不良贷款本期冲销减值准备
        String sABadRetSum = "0.0";//审计口径不良贷款本期转回减值准备
        String sABadReserveBalance = "0.0";//审计口径不良贷款本期减值准备余额
        String sMNormalReserveSum = "0.0";//管理层口径正常贷款本期计提减值准备
        String sMNormalMinusSum = "0.0";//管理层口径正常贷款本期冲销减值准备
        String sMNormalReserveBalance = "0.0";//管理层口径正常贷款本期减值准备余额
        String sANormalReserveSum = "0.0";//审计口径正常贷款本期计提减值准备
        String sANormalMinusSum = "0.0";//审计口径正常贷款本期冲销减值准备
        String sANormalReserveBalance = "0.0";//审计口径正常贷款本期减值准备余额
        
        
        //获取相应会计月份的减值计提参数信息
        if("1".equals(sBusinessFlag)){
            ReservePara reservePara = new ReservePara(this.Sqlca);
            alReservePara = reservePara.getReservePara(sAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(30);
        }else{
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(11);
        }
        
        //在RESERVE_TOTAL中检查本期基础数据中是否存在该贷款帐号的信息
        ReserveTotal reserveTotal = new ReserveTotal(this.Sqlca);
        bExistFlag = reserveTotal.findExistReserveTotal(sAccountMonth,sLoanAccountNo);
        if(bExistFlag == true) //贷款数据库中存在本期的贷款帐户信息
        {
            ReserveCalculate reserveCalculate = new ReserveCalculate(this.Sqlca);
            //获取本期贷款数据库基础数据
            alReserveBasicData = reserveTotal.selectReserveTotal(sAccountMonth,sLoanAccountNo);
            //获取上期贷款数据库基础数据
            alLastReserveBasicData = reserveTotal.selectReserveTotal(sLastAccountMonth,sLoanAccountNo);
            if(!alLastReserveBasicData.isEmpty()){
                //上期贷款余额为零，不计算其减值准备
                if(Double.parseDouble((String)alLastReserveBasicData.get(30)) == 0 ){
                    return alReserveTotal;
                }
            }
            //获取本期贷款数据库基础数据
            sMFiveClassify = (String)alReserveBasicData.get(34);//本期管理层五级分类     
            sAFiveClassify = (String)alReserveBasicData.get(35);//本期审计五级分类
            sManageStatFlag = (String)alReserveBasicData.get(70);//本期记提方式 
            //获取上期贷款数据库基础数据
            if(!alLastReserveBasicData.isEmpty()){
               sLastMFiveClassify = (String)alLastReserveBasicData.get(34);//上期管理层五级分类      
               sLastAFiveClassify = (String)alLastReserveBasicData.get(35);//上期审计五级分类
               sLastManageStatFlag = (String)alLastReserveBasicData.get(70);//上期记提方式 
            }
            //将空值转换为空字符串
            if(sMFiveClassify == null) sMFiveClassify = "";
            if(sAFiveClassify == null) sAFiveClassify = "";
            if(sLastMFiveClassify == null) sLastMFiveClassify = "";
            if(sLastAFiveClassify == null) sLastAFiveClassify = "";
            //获取本期收回金额和本期核销金额
            dRetSum = reserveCalculate.calRetSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//本期收回金额
            dOmitSum = reserveCalculate.calOmitSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//本期核销金额

            if(debug)System.out.println("111111111111111");     
            if(alLastReserveBasicData.isEmpty()) //该笔贷款为本期新增贷款
            {
                if(debug)System.out.println("111111111111111-----------1111111111");    
                //调用ReserveCalculate的计算公式ReserveCalculateFormula1
                alReserveCalculateData = reserveCalculate.ReserveCalculateFormula1(alReserveBasicData);
                if(!alReserveCalculateData.isEmpty())
                {
                    sMNormalReserveSum = (String)alReserveCalculateData.get(10);//管理层口径正常贷款本期计提减值准备
                    sMNormalReserveBalance = (String)alReserveCalculateData.get(10);//管理层口径正常贷款本期减值准备余额
                    sANormalReserveSum = (String)alReserveCalculateData.get(12);//审计口径正常贷款本期计提减值准备
                    sANormalReserveBalance = (String)alReserveCalculateData.get(12);//审计口径正常贷款本期减值准备余额
                }
            }else
            {
                dLastBalance = Double.parseDouble((String)alLastReserveBasicData.get(30));//上期贷款余额
                dBalance = Double.parseDouble((String)alReserveBasicData.get(30));//本期贷款余额
                dRetSum = reserveCalculate.calRetSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//本期收回金额
                dOmitSum = reserveCalculate.calOmitSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//本期核销金额
                
                if(dRetSum > 0 && dLastBalance > 0 && dRetSum == dLastBalance && dBalance == 0)//本期全部收回
                {
                    //调用ReserveCalculate的计算公式ReserveCalculateFormula2
                    alReserveCalculateData = reserveCalculate.ReserveCalculateFormula2(alLastReserveBasicData,alReserveBasicData);
                    if(!alReserveCalculateData.isEmpty())
                    {
                        alLastPredictCapital = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData);
                        if(!alLastPredictCapital.isEmpty())
                        {
                            sMBadLastPrdDiscount = (String)alLastPredictCapital.get(0);//管理层口径不良贷款上期预测现金流本期贴现值
                            sABadLastprdDiscount = (String)alLastPredictCapital.get(1);//审计口径不良贷款上期预测现金流本期贴现值
                        }
                        sMExforLoss = (String)alReserveCalculateData.get(2);//管理层口径本期贷款汇兑损益
                        sAExforLoss = (String)alReserveCalculateData.get(3);//审计口径本期贷款汇兑损益                          
                        sMBadMinusSum = (String)alReserveCalculateData.get(5);//管理层口径不良贷款本期冲销减值准备   
                        sMBadRetSum = (String)alReserveCalculateData.get(6);//管理层口径不良贷款本期转回减值准备
                        sABadMinusSum = (String)alReserveCalculateData.get(8);//审计口径不良贷款本期冲销减值准备
                        sABadRetSum = (String)alReserveCalculateData.get(9);//审计口径不良贷款本期转回减值准备
                        sMNormalMinusSum = (String)alReserveCalculateData.get(11);//管理层口径正常贷款本期冲销减值准备
                        sANormalMinusSum = (String)alReserveCalculateData.get(13);//审计口径正常贷款本期冲销减值准备
                    }
                }else if(dOmitSum > 0 && dLastBalance > 0 && dOmitSum == dLastBalance && dBalance == 0)//本期全部核销
                {
                    //调用ReserveCalculate的计算公式ReserveCalculateFormula3
                    alReserveCalculateData = reserveCalculate.ReserveCalculateFormula3(alLastReserveBasicData,alReserveBasicData);
                    if(!alReserveCalculateData.isEmpty())
                    {
                        //不良贷款上期预测现金流本期折现值
                        alLastPredictCapital = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData);
                        if(!alLastPredictCapital.isEmpty())
                        {
                            sMBadLastPrdDiscount = (String)alLastPredictCapital.get(0);//管理层口径不良贷款上期预测现金流本期贴现值
                            sABadLastprdDiscount = (String)alLastPredictCapital.get(1);//审计口径不良贷款上期预测现金流本期贴现值
                        }
                        sMCancelReserveSum = (String)alReserveCalculateData.get(0);//管理层口径核销减值准备
                        sACancelReserveSum = (String)alReserveCalculateData.get(1);//审计口径核销减值准备
                        sMExforLoss = (String)alReserveCalculateData.get(2);//管理层口径本期贷款汇兑损益
                        sAExforLoss = (String)alReserveCalculateData.get(3);//审计口径本期贷款汇兑损益
                    }
                }else 
                {
                    //该笔贷款上期为单笔计提，本期为组合计提
                    if(sLastManageStatFlag.equals("2") && sManageStatFlag.equals("1"))
                    {
                        //不良贷款上期预测现金流本期折现值
                        sMBadLastPrdDiscount = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData, "M") + "";
                        //调用ReserveCalculate的计算公式ReserveCalculateFormula5
                        alReserveCalculateData = reserveCalculate.ReserveCalculateFormula5(alLastReserveBasicData,alReserveBasicData, "M");
                        if(!alReserveCalculateData.isEmpty())
                        {
                            sMExforLoss = (String)alReserveCalculateData.get(1);//管理层口径本期贷款汇兑损益
                            //sAExforLoss = (String)alReserveCalculateData.get(3);//审计口径本期贷款汇兑损益
                            sMBadMinusSum = (String)alReserveCalculateData.get(3);//管理层口径不良贷款本期冲销减值准备
                            sMBadRetSum = (String)alReserveCalculateData.get(4);//管理层口径不良贷款本期转回减值准备
                            //sABadMinusSum = (String)alReserveCalculateData.get(8);//审计口径不良贷款本期冲销减值准备                                  
                            sMNormalReserveSum = (String)alReserveCalculateData.get(5);//管理层口径正常贷款本期计提减值准备                                  
                            sMNormalReserveBalance = (String)alReserveCalculateData.get(5);//管理层口径正常贷款本期减值准备余额
                            //sANormalReserveSum = (String)alReserveCalculateData.get(12);//审计口径正常贷款本期计提减值准备                                    
                            //sANormalReserveBalance = (String)alReserveCalculateData.get(12);//审计口径正常贷款本期减值准备余额
                        }
                    }else
                    {
                        //某笔贷款上期为正常贷款，本期为正常贷款
                        if(sLastManageStatFlag.equals("1") && sManageStatFlag.equals("1"))
                        {
                            //调用ReserveCalculate的计算公式ReserveCalculateFormula6
                            alReserveCalculateData = reserveCalculate.ReserveCalculateFormula6(alLastReserveBasicData,alReserveBasicData, "M");
                            if(!alReserveCalculateData.isEmpty())
                            {
                                sMExforLoss = (String)alReserveCalculateData.get(1);//管理层口径本期贷款汇兑损益
                                //sAExforLoss = (String)alReserveCalculateData.get(3);//审计口径本期贷款汇兑损益
                                sMNormalReserveSum = (String)alReserveCalculateData.get(5);//管理层口径正常贷款本期计提减值准备
                                sMNormalMinusSum = (String)alReserveCalculateData.get(6);//管理层口径正常贷款本期冲销减值准备
                                if(sMFiveClassify.equals("01")) //正常类
                                    sMNormalReserveBalance = String.valueOf(reserveCalculate.getACompReserveSum(alReserveBasicData,sAccountMonth,"M"));//管理层口径正常贷款本期减值准备余额
                                if(sMFiveClassify.equals("02")) //关注类
                                    sMNormalReserveBalance = String.valueOf(reserveCalculate.getBCompReserveSum(alReserveBasicData,sAccountMonth,"M"));//管理层口径正常贷款本期减值准备余额
                                //sANormalReserveSum = (String)alReserveCalculateData.get(12);//审计口径正常贷款本期计提减值准备
                                //sANormalMinusSum = (String)alReserveCalculateData.get(13);//审计口径正常贷款本期冲销减值准备
                                //if(sAFiveClassify.equals("01")) //正常类
                                    //sANormalReserveBalance = String.valueOf(reserveCalculate.getACompReserveSum(alReserveBasicData,sAccountMonth,"A"));//审计口径正常贷款本期减值准备余额
                                //if(sAFiveClassify.equals("02")) //关注类
                                    //sANormalReserveBalance = String.valueOf(reserveCalculate.getBCompReserveSum(alReserveBasicData,sAccountMonth,"A"));//审计口径正常贷款本期减值准备余额
                            }
                        }
                    }
                
                    
                    /**以下为审计口径进行处理**/
                    //该笔贷款上期为单笔计提，本期为组合计提
                    if(sLastManageStatFlag.equals("2") && sManageStatFlag.equals("1"))
                    {
                        //不良贷款上期预测现金流本期折现值
                        sABadLastprdDiscount = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData, "A") + "";
                        //调用ReserveCalculate的计算公式ReserveCalculateFormula5
                        alReserveCalculateData = reserveCalculate.ReserveCalculateFormula5(alLastReserveBasicData,alReserveBasicData, "A");
                        if(!alReserveCalculateData.isEmpty())
                        {
                            sAExforLoss = (String)alReserveCalculateData.get(1);//审计口径本期贷款汇兑损益
                            sABadMinusSum = (String)alReserveCalculateData.get(3);//审计口径不良贷款本期冲销减值准备
                            sABadRetSum = (String)alReserveCalculateData.get(4);//审计口径不良贷款本期转回减值准备
                            sANormalReserveSum = (String)alReserveCalculateData.get(5);//审计口径正常贷款本期计提减值准备                                   
                            sANormalReserveBalance = (String)alReserveCalculateData.get(5);//审计口径正常贷款本期减值准备余额
                        }
                    }else
                    {
                        //某笔贷款上期为正常贷款，本期为正常贷款
                        if(sLastManageStatFlag.equals("1") && sManageStatFlag.equals("1"))
                        {
                            //调用ReserveCalculate的计算公式ReserveCalculateFormula6
                            alReserveCalculateData = reserveCalculate.ReserveCalculateFormula6(alLastReserveBasicData,alReserveBasicData, "A");
                            if(!alReserveCalculateData.isEmpty())
                            {
                                sAExforLoss = (String)alReserveCalculateData.get(1);//审计口径本期贷款汇兑损益
                                sANormalReserveSum = (String)alReserveCalculateData.get(5);//审计口径正常贷款本期计提减值准备
                                sANormalMinusSum = (String)alReserveCalculateData.get(6);//审计口径正常贷款本期冲销减值准备
                                if(sAFiveClassify.equals("01")) //正常类
                                    sANormalReserveBalance = String.valueOf(reserveCalculate.getACompReserveSum(alReserveBasicData,sAccountMonth,"A"));//审计口径正常贷款本期减值准备余额
                                if(sAFiveClassify.equals("02")) //关注类
                                    sANormalReserveBalance = String.valueOf(reserveCalculate.getBCompReserveSum(alReserveBasicData,sAccountMonth,"A"));//审计口径正常贷款本期减值准备余额
                            }
                        }
                    }
                 }
            }           
        }
        //将上述获得的信息存放在贷款数据库对象alReserveTotal中
        alReserveTotal.add(0, sAccountMonth); //会计月份
        alReserveTotal.add(1, sLoanAccountNo); //贷款帐号
        alReserveTotal.add(2, sMCancelReserveSum); //管理层口径核销减值准备
        alReserveTotal.add(3, sACancelReserveSum); //审计口径核销减值准备
        alReserveTotal.add(4, sMExforLoss); //管理层口径汇兑损益
        alReserveTotal.add(5, sAExforLoss); //审计口径汇兑损益
        alReserveTotal.add(6, sMBadLastPrdDiscount); //管理层口径上期预测现金流本期贴现值
        alReserveTotal.add(7, sMBadPrdDiscount); //管理层口径不良贷款本期预测现金流贴现值
        alReserveTotal.add(8, sMBadReserveSum); //管理层口径不良贷款本期计提减值准备
        alReserveTotal.add(9, sMBadMinusSum); //管理层口径不良贷款本期冲销减值准备
        alReserveTotal.add(10, sMBadRetSum); //管理层口径不良贷款本期转回减值准备
        alReserveTotal.add(11, sMBadReserveBalance); //管理层口径不良贷款本期减值准备余额
        alReserveTotal.add(12, sABadLastprdDiscount); //审计口径不良贷款上期预测现金流本期贴现值
        alReserveTotal.add(13, sABadPrdDiscount); //审计口径不良贷款本期预测现金流贴现值
        alReserveTotal.add(14, sABadReserveSum); //审计口径不良贷款本期计提减值准备
        alReserveTotal.add(15, sABadMinusSum); //审计口径不良贷款本期冲销减值准备
        alReserveTotal.add(16, sABadRetSum); //审计口径不良贷款本期转回减值准备
        alReserveTotal.add(17, sABadReserveBalance); //审计口径不良贷款本期减值准备余额
        alReserveTotal.add(18, sMNormalReserveSum); //管理层口径正常贷款本期计提减值准备
        alReserveTotal.add(19, sMNormalMinusSum); //管理层口径正常贷款本期冲销减值准备
        alReserveTotal.add(20, sMNormalReserveBalance); //管理层口径正常贷款本期减值准备余额
        alReserveTotal.add(21, sANormalReserveSum); //审计口径正常贷款本期计提减值准备
        alReserveTotal.add(22, sANormalMinusSum); //审计口径正常贷款本期冲销减值准备
        alReserveTotal.add(23, sANormalReserveBalance); //审计口径正常贷款本期减值准备余额
        alReserveTotal.add(24, dRetSum+""); //本期收回金额
        alReserveTotal.add(25, dOmitSum+""); //本期核销金额
        
        return alReserveTotal;
    }   
    
    /**
     * 单笔计提计算公式，调用相应的公式获得相应口径的减值计提数据
     * @param sLoanAccountNo 贷款帐号
     * @return ArrayList 依次为：核销减值准备、本期贷款汇兑损益、管理层口径上期预测现金流本期贴现值、......
     */
    private ArrayList singleCalculateData(String sAccountMonth,String sLoanAccountNo,String sBusinessFlag) throws Exception
    {
        //定义变量
        ArrayList alReserveTotal = new ArrayList();//存放减值准备的贷款数据库计算数据信息
        ArrayList alReserveBasicData = new ArrayList();//存放减值准备的贷款数据库基础数据信息
        ArrayList alLastReserveBasicData = new ArrayList();//存放减值准备的贷款数据库基础数据信息（上一期）
        ArrayList alReserveCalculateData = new ArrayList();//存放减值准备的贷款数据库减值计提信息（根据公式计算） 
        ArrayList alReservePara = new ArrayList();//存放当前会计月份的减值准备参数
        ArrayList alCurPredictCapital = new ArrayList();//存放管理层口径和审计口径的不良贷款本期预测现金流信息
        boolean bExistFlag = true;//贷款数据库中是否存在本期贷款帐户的标志（即是否已经处理过）
        String sLastAccountMonth = "";//减值计提准备参数表中的上期会计月份       
        String sMFiveClassify = "";//本期管理层五级分类
        String sAFiveClassify = "";//本期审计五级分类
        String sManageStatFlag = "";//本期计提方式
        String sLastMFiveClassify = "";//上期管理层五级分类
        String sLastAFiveClassify = "";//上期审计五级分类
        String sLastManageStatFlag = "";//上期计提方式
        double dLastBalance = 0.0;//上期贷款余额
        double dBalance = 0.0;//本期贷款余额
        double dRetSum = 0.0;//本期收回金额
        double dOmitSum = 0.0;//本期核销金额
        
        //以下字段为贷款数据库中的要素
        String sMCancelReserveSum = "0.0";//管理层口径核销减值准备
        String sACancelReserveSum = "0.0";//审计口径核销减值准备
        String sMExforLoss = "0.0";//管理层口径本期贷款汇兑损益
        String sAExforLoss = "0.0";//审计口径本期贷款汇兑损益
        String sMBadLastPrdDiscount = "0.0";//管理层口径上期预测现金流本期贴现值
        String sMBadPrdDiscount = "0.0";//管理层口径不良贷款本期预测现金流贴现值
        String sMBadReserveSum = "0.0";//管理层口径不良贷款本期计提减值准备
        String sMBadMinusSum = "0.0";//管理层口径不良贷款本期冲销减值准备
        String sMBadRetSum = "0.0";//管理层口径不良贷款本期转回减值准备
        String sMBadReserveBalance = "0.0";//管理层口径不良贷款本期减值准备余额
        String sABadLastprdDiscount = "0.0";//审计口径不良贷款上期预测现金流本期贴现值
        String sABadPrdDiscount = "0.0";//审计口径不良贷款本期预测现金流贴现值
        String sABadReserveSum = "0.0";//审计口径不良贷款本期计提减值准备
        String sABadMinusSum = "0.0";//审计口径不良贷款本期冲销减值准备
        String sABadRetSum = "0.0";//审计口径不良贷款本期转回减值准备
        String sABadReserveBalance = "0.0";//审计口径不良贷款本期减值准备余额
        String sMNormalReserveSum = "0.0";//管理层口径正常贷款本期计提减值准备
        String sMNormalMinusSum = "0.0";//管理层口径正常贷款本期冲销减值准备
        String sMNormalReserveBalance = "0.0";//管理层口径正常贷款本期减值准备余额
        String sANormalReserveSum = "0.0";//审计口径正常贷款本期计提减值准备
        String sANormalMinusSum = "0.0";//审计口径正常贷款本期冲销减值准备
        String sANormalReserveBalance = "0.0";//审计口径正常贷款本期减值准备余额
        
                
        //获取相应会计月份的减值计提参数信息
        ReservePara reservePara = new ReservePara(this.Sqlca);
        alReservePara = reservePara.getReservePara(sAccountMonth);
        if(!alReservePara.isEmpty())
            sLastAccountMonth = (String)alReservePara.get(30);
                
        //在RESERVE_TOTAL中检查本期基础数据中是否存在该贷款帐号的信息
        ReserveTotal reserveTotal = new ReserveTotal(this.Sqlca);
        bExistFlag = reserveTotal.findExistReserveTotal(sAccountMonth,sLoanAccountNo);
        if(bExistFlag == true) //贷款数据库中存在本期的贷款帐户信息
        {
            ReserveCalculate reserveCalculate = new ReserveCalculate(this.Sqlca);
            //获取本期贷款数据库基础数据
            alReserveBasicData = reserveTotal.selectReserveTotal(sAccountMonth,sLoanAccountNo);
            //获取上期贷款数据库基础数据
            alLastReserveBasicData = reserveTotal.selectReserveTotal(sLastAccountMonth,sLoanAccountNo);
            if(!alLastReserveBasicData.isEmpty()){
                //上期贷款余额为零，不计算其减值准备
                if(Double.parseDouble((String)alLastReserveBasicData.get(30)) == 0 ){
                    return alReserveTotal;
                }
            }
            //获取本期贷款数据库基础数据
            sMFiveClassify = (String)alReserveBasicData.get(34);//本期管理层五级分类     
            sAFiveClassify = (String)alReserveBasicData.get(35);//本期审计五级分类
            sManageStatFlag = (String)alReserveBasicData.get(70);//本期记提方式 
            //获取上期贷款数据库基础数据
            if(!alLastReserveBasicData.isEmpty()){
               sLastMFiveClassify = (String)alLastReserveBasicData.get(34);//上期管理层五级分类      
               sLastAFiveClassify = (String)alLastReserveBasicData.get(35);//上期审计五级分类
               sLastManageStatFlag = (String)alLastReserveBasicData.get(70);//上期记提方式 
            }
            //将空值转换为空字符串
            if(sMFiveClassify == null) sMFiveClassify = "";
            if(sAFiveClassify == null) sAFiveClassify = "";
            if(sManageStatFlag == null) sManageStatFlag = "";
            if(sLastMFiveClassify == null) sLastMFiveClassify = "";
            if(sLastAFiveClassify == null) sLastAFiveClassify = "";
            if(sLastManageStatFlag == null) sLastManageStatFlag = "";
            //获取本期收回金额和本期核销金额
            dRetSum = reserveCalculate.calRetSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//本期收回金额
            dOmitSum = reserveCalculate.calOmitSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//本期核销金额

            if(debug)System.out.println("111111111111111");     
            if(alLastReserveBasicData.isEmpty()) //该笔贷款为本期新增贷款
            {
                if(debug)System.out.println("111111111111111-----------1111111111");    
                //调用ReserveCalculate的计算公式ReserveCalculateFormula1
                alReserveCalculateData = reserveCalculate.ReserveCalculateFormula1(alReserveBasicData);
                if(!alReserveCalculateData.isEmpty())
                {
                    //本期不良贷款需要计算本期现金流折现值
                    alCurPredictCapital = reserveCalculate.getCurPredictCapital(alReserveBasicData);
                    if(!alCurPredictCapital.isEmpty())
                    {
                        sMBadPrdDiscount = (String)alCurPredictCapital.get(0);//管理层口径不良贷款本期预测现金流贴现值
                        sABadPrdDiscount = (String)alCurPredictCapital.get(1);//审计口径不良贷款本期预测现金流贴现值
                    }
                    if(debug)System.out.println("111111111111111-----------333333333"); 
                    sMBadReserveSum = (String)alReserveCalculateData.get(4);//管理层口径不良贷款本期计提减值准备
                    sMBadReserveBalance = (String)alReserveCalculateData.get(4);//管理层口径不良贷款本期减值准备余额
                    sABadReserveSum = (String)alReserveCalculateData.get(7);//审计口径不良贷款本期计提减值准备
                    sABadReserveBalance = (String)alReserveCalculateData.get(7);//审计口径不良贷款本期减值准备余额
                    sMNormalReserveSum = (String)alReserveCalculateData.get(10);//管理层口径正常贷款本期计提减值准备
                    sMNormalReserveBalance = (String)alReserveCalculateData.get(10);//管理层口径正常贷款本期减值准备余额
                    sANormalReserveSum = (String)alReserveCalculateData.get(12);//审计口径正常贷款本期计提减值准备
                    sANormalReserveBalance = (String)alReserveCalculateData.get(12);//审计口径正常贷款本期减值准备余额
                }
            }else
            {
                dLastBalance = Double.parseDouble((String)alLastReserveBasicData.get(30));//上期贷款余额
                dBalance = Double.parseDouble((String)alReserveBasicData.get(30));//本期贷款余额
                dRetSum = reserveCalculate.calRetSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//本期收回金额
                dOmitSum = reserveCalculate.calOmitSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//本期核销金额
                
                //该笔贷款上期为组合计提，本期为单笔计提
                if(sLastManageStatFlag.equals("1")&& sManageStatFlag.equals("2"))
                {
                    //本期不良贷款需要计算本期现金流折现值
                    sMBadPrdDiscount = reserveCalculate.getCurPredictCapital(alReserveBasicData, "M")+"";//管理层口径不良贷款本期预测现金流贴现值
                    //调用ReserveCalculate的计算公式ReserveCalculateFormula4
                    alReserveCalculateData = reserveCalculate.ReserveCalculateFormula4(alLastReserveBasicData,alReserveBasicData, "M");
                    if(!alReserveCalculateData.isEmpty())
                    {                               
                        sMExforLoss = (String)alReserveCalculateData.get(1);//管理层口径本期贷款汇兑损益
                        //sAExforLoss = (String)alReserveCalculateData.get(3);//审计口径本期贷款汇兑损益
                        sMBadReserveSum = (String)alReserveCalculateData.get(2);//管理层口径不良贷款本期计提减值准备
                        sMBadReserveBalance = String.valueOf(reserveCalculate.getSingleReserveSum(alReserveBasicData,"M"));//管理层口径不良贷款本期减值准备余额
                        //sABadReserveSum = (String)alReserveCalculateData.get(7);//审计口径不良贷款本期计提减值准备
                        //sABadReserveBalance = String.valueOf(reserveCalculate.getSingleReserveSum(alReserveBasicData,"A"));//审计口径不良贷款本期减值准备余额
                        sMNormalMinusSum = (String)alReserveCalculateData.get(6);//管理层口径正常贷款本期冲销减值准备
                        //sANormalMinusSum = (String)alReserveCalculateData.get(13);//审计口径正常贷款本期冲销减值准备
                    }
                }else 
                {
                    //某笔贷款上期为单笔计提，本期为单笔计提
                    if(sLastManageStatFlag.equals("2")&& sManageStatFlag.equals("2"))
                    {
                        //不良贷款上期预测现金流本期折现值
                        sMBadLastPrdDiscount = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData, "M") + "";
                        //本期不良贷款需要计算本期现金流折现值
                        sMBadPrdDiscount = reserveCalculate.getCurPredictCapital(alReserveBasicData, "M") + "";
                        //调用ReserveCalculate的计算公式ReserveCalculateFormula7
                        alReserveCalculateData = reserveCalculate.ReserveCalculateFormula7(alLastReserveBasicData,alReserveBasicData, "M",sBusinessFlag);
                        if(!alReserveCalculateData.isEmpty())
                        {
                            sMExforLoss = (String)alReserveCalculateData.get(1);//管理层口径本期贷款汇兑损益
                            sMBadReserveSum = (String)alReserveCalculateData.get(2);//管理层口径不良贷款本期计提减值准备
                            sMBadMinusSum = (String)alReserveCalculateData.get(3);//管理层口径不良贷款本期冲销减值准备
                            sMBadRetSum = (String)alReserveCalculateData.get(4);//管理层口径不良贷款本期转回减值准备
                            sMBadReserveBalance = String.valueOf(reserveCalculate.getSingleReserveSum(alReserveBasicData,"M"));//管理层口径不良贷款本期减值准备余额
                        }
                    }   
                
                }
                
                /**以下为审计口径进行处理**/
                //该笔贷款上期为组合计提，本期为单笔计提
                if(sLastManageStatFlag.equals("1")&& sManageStatFlag.equals("2"))
                {
                    //本期不良贷款需要计算本期现金流折现值
                    sABadPrdDiscount = reserveCalculate.getCurPredictCapital(alReserveBasicData, "A")+"";//审计层口径不良贷款本期预测现金流贴现值
                    //调用ReserveCalculate的计算公式ReserveCalculateFormula4
                    alReserveCalculateData = reserveCalculate.ReserveCalculateFormula4(alLastReserveBasicData,alReserveBasicData, "A");
                    if(!alReserveCalculateData.isEmpty())
                    {                               
                        sAExforLoss = (String)alReserveCalculateData.get(1);//审计口径本期贷款汇兑损益
                        sABadReserveSum = (String)alReserveCalculateData.get(2);//审计口径不良贷款本期计提减值准备
                        sABadReserveBalance = String.valueOf(reserveCalculate.getSingleReserveSum(alReserveBasicData,"A"));//审计口径不良贷款本期减值准备余额
                        sANormalMinusSum = (String)alReserveCalculateData.get(6);//审计口径正常贷款本期冲销减值准备
                    }
                }else 
                {
                    //某笔贷款上期为单笔计提贷款，本期为单笔计提贷款
                    if(sLastManageStatFlag.equals("2")&& sManageStatFlag.equals("2"))
                    {
                        //不良贷款上期预测现金流本期折现值
                        sABadLastprdDiscount = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData, "A") + "";
                        //本期不良贷款需要计算本期现金流折现值
                        sABadPrdDiscount = reserveCalculate.getCurPredictCapital(alReserveBasicData, "A") + "";
                        //调用ReserveCalculate的计算公式ReserveCalculateFormula7
                        alReserveCalculateData = reserveCalculate.ReserveCalculateFormula7(alLastReserveBasicData,alReserveBasicData, "A",sBusinessFlag);
                        if(!alReserveCalculateData.isEmpty())
                        {
                            sAExforLoss = (String)alReserveCalculateData.get(1);//审计口径本期贷款汇兑损益
                            sABadReserveSum = (String)alReserveCalculateData.get(2);//审计口径不良贷款本期计提减值准备
                            sABadMinusSum = (String)alReserveCalculateData.get(3);//审计口径不良贷款本期冲销减值准备
                            sABadRetSum = (String)alReserveCalculateData.get(4);//审计口径不良贷款本期转回减值准备
                            sABadReserveBalance = String.valueOf(reserveCalculate.getSingleReserveSum(alReserveBasicData,"A"));//审计口径不良贷款本期减值准备余额
                        }
                    }
                 }         
            }           
        }
        //将上述获得的信息存放在贷款数据库对象alReserveTotal中
        alReserveTotal.add(0, sAccountMonth); //会计月份
        alReserveTotal.add(1, sLoanAccountNo); //贷款帐号
        alReserveTotal.add(2, sMCancelReserveSum); //管理层口径核销减值准备
        alReserveTotal.add(3, sACancelReserveSum); //审计口径核销减值准备
        alReserveTotal.add(4, sMExforLoss); //管理层口径汇兑损益
        alReserveTotal.add(5, sAExforLoss); //审计口径汇兑损益
        alReserveTotal.add(6, sMBadLastPrdDiscount); //管理层口径上期预测现金流本期贴现值
        alReserveTotal.add(7, sMBadPrdDiscount); //管理层口径不良贷款本期预测现金流贴现值
        alReserveTotal.add(8, sMBadReserveSum); //管理层口径不良贷款本期计提减值准备
        alReserveTotal.add(9, sMBadMinusSum); //管理层口径不良贷款本期冲销减值准备
        alReserveTotal.add(10, sMBadRetSum); //管理层口径不良贷款本期转回减值准备
        alReserveTotal.add(11, sMBadReserveBalance); //管理层口径不良贷款本期减值准备余额
        alReserveTotal.add(12, sABadLastprdDiscount); //审计口径不良贷款上期预测现金流本期贴现值
        alReserveTotal.add(13, sABadPrdDiscount); //审计口径不良贷款本期预测现金流贴现值
        alReserveTotal.add(14, sABadReserveSum); //审计口径不良贷款本期计提减值准备
        alReserveTotal.add(15, sABadMinusSum); //审计口径不良贷款本期冲销减值准备
        alReserveTotal.add(16, sABadRetSum); //审计口径不良贷款本期转回减值准备
        alReserveTotal.add(17, sABadReserveBalance); //审计口径不良贷款本期减值准备余额
        alReserveTotal.add(18, sMNormalReserveSum); //管理层口径正常贷款本期计提减值准备
        alReserveTotal.add(19, sMNormalMinusSum); //管理层口径正常贷款本期冲销减值准备
        alReserveTotal.add(20, sMNormalReserveBalance); //管理层口径正常贷款本期减值准备余额
        alReserveTotal.add(21, sANormalReserveSum); //审计口径正常贷款本期计提减值准备
        alReserveTotal.add(22, sANormalMinusSum); //审计口径正常贷款本期冲销减值准备
        alReserveTotal.add(23, sANormalReserveBalance); //审计口径正常贷款本期减值准备余额
        alReserveTotal.add(24, dRetSum+""); //本期收回金额
        alReserveTotal.add(25, dOmitSum+""); //本期核销金额
        
        return alReserveTotal;
    }
		
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			java.sql.Connection conn = ConnectionManager.getConnection("jdbc:informix-sqli://38.19.7.31:1526/als6hs:INFORMIXSERVER=hsxd_kf",
					"com.informix.jdbc.IfxDriver", "informix", "informix");
			Transaction Sqlca = new Transaction(conn);
			BatchReserveInfo bri = new BatchReserveInfo(Sqlca);
	
			String sql = "select * from reserve_total where accountmonth = '2008/05' ";
			ASResultSet rs = Sqlca.getASResultSet(sql);
			while(rs.next()){
               System.out.println("运算借据"+ rs.getString("LoanAccount"));
			   bri.runCalculateData(rs.getString("AccountMonth"), rs.getString("LoanAccount"),rs.getString("ManageStatFlag"),rs.getString("BusinessFlag"));
			}
			rs.getStatement().close();

			//bri.runCalculateData("2006/12", "01090302900113001000619");
			//bri.runCheckBasicData();
			Sqlca.conn.commit();
			
		}catch(Exception e)
		{
			e.printStackTrace();
			System.out.println(e.toString());
		}
	}
}

package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;

/**
 * 迁徙矩阵迁徙率的计算
 * 可以根据管理与审计口径、全额与净额口径、按借据与按客户不同的口径分别计算迁徙率
 * @author ycsun 此java类作用是按逾期天数来统计迁徙率
 *
 */
public class TransferRateCalInd {
	private Transaction Sqlca = null;
	private String sBeginAccountMonth;//期初日期
	private String sEndAccountMonth;//期末日期
	private String sMAScope;      //M-管理层口径, A-审计层口径   
	private String sANScope;     //A-按全额统计, N-按净额统计
	private String sDCScope;    //D-按借据， C-按客户
	private double dABalance;//起初正常贷款余额
	private double dBBalance;//起初小于30天贷款余额
	private double dCBalance;//起初31到90天贷款余额
	private double dDBalance;//起初91到180天贷款余额
	private double dEBalance;//起初181天到360天贷款余额
	private double dFBalance;//起初大于360天贷款余额

	
	private String sScopeField = "BusinessFlag";
	private String sFiveField = "AFiveClassify";

	/**
	 * 对该类进行初始化，默认为按审计口径进行统计
	 * @param Sqlca
	 * @param sBeginAccountMonth
	 * @param sEndAccountMonth
	 * @param sMAScope
	 * @param sANScope
	 * @param sDCScope
	 */
	public TransferRateCalInd(Transaction Sqlca, String sBeginAccountMonth, String sEndAccountMonth, String sMAScope, String sDCScope, String sANScope)throws Exception{
		this.Sqlca = Sqlca;
		this.sBeginAccountMonth = sBeginAccountMonth;
		this.sEndAccountMonth = sEndAccountMonth;
		this.sANScope = sANScope;
		this.sDCScope = sDCScope;
		this.sMAScope = sMAScope;
		if(this.sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			//sScopeField = "ManageStatFlag";
		}
	}
 
	/**
	 * 计算单个期初逾期天数分类，期末逾期天数分类的迁徙率
	 * @param sBeginStatus
	 * @param sEndStatus
	 * @return
	 * @throws Exception
	 */
	public double calSingleTransferRateForOverDueDays(String sBeginStatus, String sEndStatus) throws Exception{
		double dBeginBalance = 0.0;
		if(sBeginStatus.equals("1")){
			dBeginBalance = dABalance;
		}else if(sBeginStatus.equals("2")){
			dBeginBalance = dBBalance;
		}else if(sBeginStatus.equals("3")){
			dBeginBalance = dCBalance;
		}else if(sBeginStatus.equals("4")){
			dBeginBalance = dDBalance;
		}else if(sBeginStatus.equals("5")){
			dBeginBalance = dEBalance;
		}else if(sBeginStatus.equals("6")){
		    dBeginBalance = dFBalance;
		}
		double rate = calEndFiveBalanceForOverDueDays(sBeginStatus, sEndStatus) * 100/dBeginBalance;
		return rate;
	}
	/**
	 * 计算单个期初逾期天数分类，期末逾期天数分类的迁徙率
	 * @param sBeginStatus
	 * @param sEndStatus
	 * @return
	 * @throws Exception
	 */
	public double calSingleTransferRate(String sBeginStatus, String sEndStatus) throws Exception{
	    double dBeginBalance = 0.0;
	    if(sBeginStatus.equals("1")){
	        dBeginBalance = dABalance;
	    }else if(sBeginStatus.equals("2")){
	        dBeginBalance = dBBalance;
	    }else if(sBeginStatus.equals("3")){
	        dBeginBalance = dCBalance;
	    }else if(sBeginStatus.equals("4")){
	        dBeginBalance = dDBalance;
	    }else if(sBeginStatus.equals("5")){
	        dBeginBalance = dEBalance;
	    }else if(sBeginStatus.equals("6")){
            dBeginBalance = dFBalance;
        }
	    double rate = calEndFiveBalanceForOverDueDays(sBeginStatus, sEndStatus) * 100/dBeginBalance;
	    return rate;
	}
	
	/**
	 * 得到所有的迁徙率，默认的是本期迁徙率
	 * @return
	 * @throws Exception
	 */
	public ArrayList getTransferRate()throws Exception{
		ArrayList al = new ArrayList();
		String sSelSql = "select AtoA, AtoB, AtoC, AtoD, AtoE, AtoF " 
		        + ", BtoA, BtoB, BtoC, BtoD, BtoE ,BtoF "
		        + ", CtoA, CtoB, CtoC, CtoD, CtoE ,CtoF "
		        + ", DtoA, DtoB, DtoC, CtoD, DtoE ,DtoF "
		        + ", EtoA, EtoB, EtoC, EtoD, EtoE ,EtoF "
		        + ", FtoA, FtoB, FtoC, FtoD, FtoE ,FtoF "
		        + ", AFinalRate, BFinalRate, CFinalRate, DFinalRate, EFinalRate ,FFinalRate"
		        + ", AtoARate, AtoBRate, AtoCRate, AtoDRate, AtoERate ,AtoFRate"
		        + ", AtoAWRate, AtoBWRate, AtoCWRate, AtoDWRate, AtoEWRate,AtoFWRate "
		        + ", BtoARate, BtoBRate, BtoCRate, BtoDRate, BtoERate ,BtoFRate"
		        + ", BtoAWRate, BtoBWRate, BtoCWRate, BtoDWRate, BtoEWRate,BtoFWRate "
		        + " from Reserve_TransferInd "
				+ " where BeginAccountMonth = '" + this.sBeginAccountMonth
				+ "'" + " and EndAccountMonth = '" + this.sEndAccountMonth
				+ "'" + " and MAScope = '" + this.sMAScope + "'"
				+ " and DCScope = '" + this.sDCScope + "'" + " and ANScope = '"
				+ this.sANScope + "'";
		ASResultSet rs = Sqlca.getASResultSet(sSelSql);
		if (rs.next()) {
			for(int i=1; i<=50; i++)
			  al.add(rs.getString(i));
		}
		rs.getStatement().close();
		return al;
	}

	/**
	 * 得到所有的迁徙率，
	 * @param sBeginMonth
	 * @param sEndMonth
	 * @return
	 * @throws Exception
	 */
	public ArrayList getTransferRate(String sBeginMonth, String sEndMonth)throws Exception{
		ArrayList al = new ArrayList();
		String sSelSql = "select AtoA, AtoB, AtoC, AtoD, AtoE ,AtoF " 
		        + ", BtoA, BtoB, BtoC, BtoD, BtoE ,BtoF"
		        + ", CtoA, CtoB, CtoC, CtoD, CtoE ,CtoF"
		        + ", DtoA, DtoB, DtoC, CtoD, DtoE ,DtoF"
		        + ", EtoA, EtoB, EtoC, EtoD, EtoE ,EtoF"
                + ", FtoA, FtoB, FtoC, FtoD, FtoE ,FtoF "
		        + ", AFinalRate, BFinalRate, CFinalRate, DFinalRate, EFinalRate ,FFinalRate"
		        + ", AtoARate, AtoBRate, AtoCRate, AtoDRate, AtoERate,AtoFRate "
		        + ", AtoAWRate, AtoBWRate, AtoCWRate, AtoDWRate, AtoEWRate,AtoFWRate "
		        + ", BtoARate, BtoBRate, BtoCRate, BtoDRate, BtoERate ,BtoFRate"
		        + ", BtoAWRate, BtoBWRate, BtoCWRate, BtoDWRate, BtoEWRate,BtoFWRate "
		        + " from Reserve_TransferInd "
				+ " where BeginAccountMonth = '" + sBeginMonth
				+ "'" + " and EndAccountMonth = '" + sEndMonth
				+ "'" + " and MAScope = '" + this.sMAScope + "'"
				+ " and DCScope = '" + this.sDCScope + "'" + " and ANScope = '"
				+ this.sANScope + "'";
		ASResultSet rs = Sqlca.getASResultSet(sSelSql);
		if (rs.next()) {
			for(int i=1; i<=50; i++)
			  al.add(rs.getString(i)== null ? "" : rs.getString(i));
		}
		rs.getStatement().close();
		return al;
	}
    
    /**
     * 获取本期贷款总额
     * @param sAccountMonth
     * @return
     * @throws Exception
     */
    public double getTotalBalance(String sAccountMonth)throws Exception{
        ASResultSet rs = null;
        String sSql = "";
        double dLoanBalance = 0.0;
        
        sSql =  " select nvl(sum(RMBBalance),0.0) "+
                " from RESERVE_TOTAL "+
                " where AccountMonth = '"+sAccountMonth+"' and businessFlag='2' ";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
        {
            dLoanBalance = rs.getDouble(1);
        }
        rs.getStatement().close();
        return dLoanBalance;        
    }

	/**
	 * 计算本期(期间为一年）贷款的平均迁徙率及加权迁徙率，并更新到数据库中
	 * @throws Exception
	 */
    public void updateWeightMatrixRate()throws Exception{
    	//获取本期会计年份
    	int iYear = Integer.parseInt(this.sEndAccountMonth.substring(0,4));
    	int iLastYear = iYear -1;
    	int iSecLastYear = iYear - 2;
     	
    	//获取前年迁徙率
    	ArrayList alSecLastRate = getTransferRate((iSecLastYear - 1)+"/12", iSecLastYear+"/12");
    	//获取去年迁徙率
    	ArrayList alLastRate = getTransferRate((iLastYear - 1)+"/12", iLastYear+"/12");
        //获取本期一年为期间的迁徙率
    	ArrayList alRate = getTransferRate(iLastYear + this.sEndAccountMonth.substring(4), this.sEndAccountMonth);
    	
    	//对空值进行初始化
     	if(alRate.isEmpty()){
     	   	for(int i=0; i< 30; i++)alRate.add(0.0+"");
    	}
    	if(alLastRate.isEmpty()){
     	   	for(int i=0; i< 30; i++)alLastRate.add(0.0+"");
    	}
     	if(alSecLastRate.isEmpty()){
     	   	for(int i=0; i< 30; i++)alSecLastRate.add(0.0+"");
    	}
   	
    	//获取前年个人贷款总额
    	double dSecLastBalance = this.getTotalBalance(iSecLastYear+"/12");
    	//获取去年个人贷款总额
    	double dLastBalance = this.getTotalBalance(iLastYear+"/12");
    	//获取本期个人贷款总额
    	double dBalance = this.getTotalBalance(this.sEndAccountMonth);
    	
    	//正常类转关注类平均迁徙率为：
        double dTotal = dSecLastBalance + dLastBalance + dBalance;
        if(dTotal<=0){
            dTotal = 1;
        }
    	double AtoARate = 0.0;
    	double AtoAWRate = 0.0;
    	
    	double AtoBRate = (Double.parseDouble((String)alRate.get(1)) + 
    	                   Double.parseDouble((String)alLastRate.get(1))+
    	                   Double.parseDouble((String)alSecLastRate.get(1)))/3.0;
        //正常类转关注类加权迁徙率为：
    	double AtoBWRate = (Double.parseDouble((String)alSecLastRate.get(1)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(1)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(1)) * dBalance)/dTotal;
    	//正常类转次级类平均迁徙率为：
    	double AtoCRate = (Double.parseDouble((String)alRate.get(2)) + 
    	                   Double.parseDouble((String)alLastRate.get(2))+
    	                   Double.parseDouble((String)alSecLastRate.get(2)))/3.0;
        //正常类转次级类加权迁徙率为：
    	double AtoCWRate = (Double.parseDouble((String)alSecLastRate.get(2)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(2)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(2))  * dBalance)/dTotal;
    	//正常类转可疑类平均迁徙率为：
    	double AtoDRate = (Double.parseDouble((String)alRate.get(3)) + 
    	                   Double.parseDouble((String)alLastRate.get(3))+
    	                   Double.parseDouble((String)alSecLastRate.get(3)))/3.0;
        //正常类转可疑类加权迁徙率为：
    	double AtoDWRate = (Double.parseDouble((String)alSecLastRate.get(3)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(3)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(3)) * dBalance)/dTotal;
    	//正常类转损失类平均迁徙率为：
    	double AtoERate = (Double.parseDouble((String)alRate.get(4)) + 
    	                   Double.parseDouble((String)alLastRate.get(4))+
    	                   Double.parseDouble((String)alSecLastRate.get(4)))/3.0;
        //正常类转损失类加权迁徙率为：
    	double AtoEWRate = (Double.parseDouble((String)alSecLastRate.get(4)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(4)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(4)) * dBalance)/dTotal;
    	//正常类转损失类平均迁徙率为：
    	double AtoFRate = (Double.parseDouble((String)alRate.get(5)) + 
    	        Double.parseDouble((String)alLastRate.get(5))+
    	        Double.parseDouble((String)alSecLastRate.get(6)))/3.0;
    	//正常类转损失类加权迁徙率为：
    	double AtoFWRate = (Double.parseDouble((String)alSecLastRate.get(6)) * dSecLastBalance + 
    	        Double.parseDouble((String)alLastRate.get(6)) * dLastBalance + 
    	        Double.parseDouble((String)alRate.get(6)) * dBalance)/dTotal;
    	
    	double BtoARate = 0.0;
    	double BtoAWRate = 0.0;
    	double BtoBRate = 0.0;
    	double BtoBWRate = 0.0;
    	//关注类转次级类平均迁徙率为：
    	double BtoCRate = (Double.parseDouble((String)alRate.get(8)) + 
    	                   Double.parseDouble((String)alLastRate.get(8))+
    	                   Double.parseDouble((String)alSecLastRate.get(8)))/3.0;
        //关注类转次级类加权迁徙率为：
    	double BtoCWRate = (Double.parseDouble((String)alSecLastRate.get(8)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(8)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(8)) * dBalance)/
    			           (dSecLastBalance + dLastBalance + dBalance);
    	//关注类转可疑类平均迁徙率为：
    	double BtoDRate = (Double.parseDouble((String)alRate.get(9)) + 
    	                   Double.parseDouble((String)alLastRate.get(9))+
    	                   Double.parseDouble((String)alSecLastRate.get(9)))/3.0;
        //关注类转可疑类加权迁徙率为：
    	double BtoDWRate = (Double.parseDouble((String)alSecLastRate.get(9)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(9)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(9)) * dBalance)/
    			           (dSecLastBalance + dLastBalance + dBalance);
    	//关注类转损失类平均迁徙率为：
    	double BtoERate = (Double.parseDouble((String)alRate.get(10)) + 
    	                   Double.parseDouble((String)alLastRate.get(10))+
    	                   Double.parseDouble((String)alSecLastRate.get(10)))/3.0;
        //关注类转损失类加权迁徙率为：
    	double BtoEWRate = (Double.parseDouble((String)alSecLastRate.get(10)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(10)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(10)) * dBalance)/
    			           (dSecLastBalance + dLastBalance + dBalance);
    	double BtoFRate = (Double.parseDouble((String)alRate.get(11)) + 
    	        Double.parseDouble((String)alLastRate.get(11))+
    	        Double.parseDouble((String)alSecLastRate.get(11)))/3.0;
    	double BtoFWRate = (Double.parseDouble((String)alSecLastRate.get(11)) * dSecLastBalance + 
    	        Double.parseDouble((String)alLastRate.get(11)) * dLastBalance + 
    	        Double.parseDouble((String)alRate.get(11)) * dBalance)/
    	        (dSecLastBalance + dLastBalance + dBalance);
    	
    	String 	sSql = "UPDATE Reserve_TransferInd set"  +
            " AtoARate = " + AtoARate + 
            ", AtoBRate = " + AtoBRate + 
            ", AtoCRate = " + AtoCRate + 
            ", AtoDRate = " + AtoDRate + 
            ", AtoERate = " + AtoERate + 
            ", AtoFRate = " + AtoFRate + 
            
            ", AtoAWRate = " + AtoAWRate + 
            ", AtoBWRate = " + AtoBWRate + 
            ", AtoCWRate = " + AtoCWRate + 
            ", AtoDWRate = " + AtoDWRate + 
            ", AtoEWRate = " + AtoEWRate + 
            ", AtoFWRate = " + AtoFWRate + 
            
            ", BtoARate = " + BtoARate + 
            ", BtoBRate = " + BtoBRate + 
            ", BtoCRate = " + BtoCRate + 
            ", BtoDRate = " + BtoDRate + 
            ", BtoERate = " + BtoERate + 
            ", BtoFRate = " + BtoFRate + 
            
            ", BtoAWRate = " + BtoAWRate + 
            ", BtoBWRate = " + BtoBWRate + 
            ", BtoCWRate = " + BtoCWRate + 
            ", BtoDWRate = " + BtoDWRate + 
            ", BtoEWRate = " + BtoEWRate + 
            ", BtoFWRate = " + BtoFWRate  
			+ " where BeginAccountMonth = '" + (iLastYear + this.sEndAccountMonth.substring(4))	+ "'" 
			+ " and EndAccountMonth = '" + this.sEndAccountMonth + "'"  
			+ " and MAScope = '" + this.sMAScope + "'"
			+ " and DCScope = '" + this.sDCScope + "'" 
			+ " and ANScope = '" + this.sANScope + "'";
       Sqlca.executeSQL(sSql);
  	
    }
	
	/**
	 * 计算不同阶段逾期天数的所有迁徙率，并保存到数据库中
	 * @throws Exception
	 */
	public void calMatrixRate()throws Exception{
		//正常类贷款各级迁徙率
		double AASum = calEndFiveBalanceForOverDueDays("1", "1"); 
		double ABSum = calEndFiveBalanceForOverDueDays("1", "2"); 
		double ACSum = calEndFiveBalanceForOverDueDays("1", "3"); 
		double ADSum = calEndFiveBalanceForOverDueDays("1", "4"); 
		double AESum = calEndFiveBalanceForOverDueDays("1", "5"); 
		double AFSum = calEndFiveBalanceForOverDueDays("1", "6"); 
        
		double AtoA = AASum * 100/dABalance;
		double AtoB = ABSum * 100/dABalance;
		double AtoC = ACSum * 100/dABalance;
		double AtoD = ADSum * 100/dABalance;
		double AtoE = AESum * 100/dABalance;
		double AtoF = AFSum * 100/dABalance;
		//关注类贷款各级迁徙率
		double BASum = calEndFiveBalanceForOverDueDays("2", "1"); 
		double BBSum = calEndFiveBalanceForOverDueDays("2", "2"); 
		double BCSum = calEndFiveBalanceForOverDueDays("2", "3"); 
		double BDSum = calEndFiveBalanceForOverDueDays("2", "4"); 
		double BESum = calEndFiveBalanceForOverDueDays("2", "5"); 
		double BFSum = calEndFiveBalanceForOverDueDays("2", "6"); 

		double BtoA = BASum * 100/dBBalance;
		double BtoB = BBSum * 100/dBBalance;
		double BtoC = BCSum * 100/dBBalance;
		double BtoD = BDSum * 100/dBBalance;
		double BtoE = BESum * 100/dBBalance;
		double BtoF = BFSum * 100/dBBalance;
		//次级类贷款各级迁徙率
		double CASum = calEndFiveBalanceForOverDueDays("3", "1"); 
		double CBSum = calEndFiveBalanceForOverDueDays("3", "2"); 
		double CCSum = calEndFiveBalanceForOverDueDays("3", "3"); 
		double CDSum = calEndFiveBalanceForOverDueDays("3", "4"); 
		double CESum = calEndFiveBalanceForOverDueDays("3", "5"); 
		double CFSum = calEndFiveBalanceForOverDueDays("3", "6"); 

		double CtoA = CASum * 100/dCBalance;
		double CtoB = CBSum * 100/dCBalance;
		double CtoC = CCSum * 100/dCBalance;
		double CtoD = CDSum * 100/dCBalance;
		double CtoE = CESum * 100/dCBalance;
		double CtoF = CFSum * 100/dCBalance;
        
		//可疑类贷款各级迁徙率
		double DASum = calEndFiveBalanceForOverDueDays("4", "1"); 
		double DBSum = calEndFiveBalanceForOverDueDays("4", "2"); 
		double DCSum = calEndFiveBalanceForOverDueDays("4", "3"); 
		double DDSum = calEndFiveBalanceForOverDueDays("4", "4"); 
		double DESum = calEndFiveBalanceForOverDueDays("4", "5"); 
		double DFSum = calEndFiveBalanceForOverDueDays("4", "6"); 

		double DtoA = DASum * 100/dDBalance;
		double DtoB = DBSum * 100/dDBalance;
		double DtoC = DCSum * 100/dDBalance;
		double DtoD = DDSum * 100/dDBalance;
		double DtoE = DESum * 100/dDBalance;
		double DtoF = DFSum * 100/dDBalance;
        
		//损失类贷款各级迁徙率
		double EASum = calEndFiveBalanceForOverDueDays("5", "1"); 
		double EBSum = calEndFiveBalanceForOverDueDays("5", "2"); 
		double ECSum = calEndFiveBalanceForOverDueDays("5", "3"); 
		double EDSum = calEndFiveBalanceForOverDueDays("5", "4"); 
		double EESum = calEndFiveBalanceForOverDueDays("5", "5"); 
		double EFSum = calEndFiveBalanceForOverDueDays("5", "6"); 

		double EtoA = EASum * 100/dEBalance;
		double EtoB = EBSum * 100/dEBalance;
		double EtoC = ECSum * 100/dEBalance;
		double EtoD = EDSum * 100/dEBalance;
		double EtoE = EESum * 100/dEBalance;
		double EtoF = EFSum * 100/dEBalance;
        
		//损失类贷款各级迁徙率
		double FASum = calEndFiveBalanceForOverDueDays("6", "1"); 
		double FBSum = calEndFiveBalanceForOverDueDays("6", "2"); 
		double FCSum = calEndFiveBalanceForOverDueDays("6", "3"); 
		double FDSum = calEndFiveBalanceForOverDueDays("6", "4"); 
		double FESum = calEndFiveBalanceForOverDueDays("6", "5"); 
		double FFSum = calEndFiveBalanceForOverDueDays("6", "6"); 
		
		double FtoA = FASum * 100/dFBalance;
		double FtoB = FBSum * 100/dFBalance;
		double FtoC = FCSum * 100/dFBalance;
		double FtoD = FDSum * 100/dFBalance;
		double FtoE = FESum * 100/dFBalance;
		double FtoF = FFSum * 100/dFBalance;
		
		//损失类贷款最终迁徙率＝100％
		double dEFinalRate = 100.00;
		//可疑类贷款最终迁徙率＝可疑转损失迁徙率
		double dDFinalRate = DtoE;
		//次级类贷款最终迁徙率＝次级转可疑迁徙率X可疑类贷款最终迁徙率+次级转损失迁徙率
		double dCFinalRate = CtoD * dDFinalRate/100.0 + CtoE;
		//关注类贷款最终迁徙率＝关注转次级迁徙率X次级类贷款最终迁徙率+关注转可疑迁徙率X可疑类贷款最终迁徙率+关注转损失迁徙率
		double dBFinalRate = BtoC * dCFinalRate/100.0 + BtoD * dDFinalRate/100.0 + BtoE;
		//正常类贷款最终迁徙率＝正常转关注迁徙率X关注类贷款最终迁徙率+正常转次级迁徙率X次级类贷款最终迁徙率+正常转可疑迁徙率X可疑类贷款最终迁徙率+正常转损失迁徙率
		double dAFinalRate = AtoB * dBFinalRate/100.0 + AtoC * dCFinalRate/100.0 + AtoD * dDFinalRate/100.0 + AtoE;
        
        double dFFinalRate =0.0;


		String sSelSql = "select count(*) from Reserve_TransferInd " +
		                 " where BeginAccountMonth = '" + this.sBeginAccountMonth + "'" +
		                 " and EndAccountMonth = '" + this.sEndAccountMonth + "'" +
		                 " and MAScope = '" + this.sMAScope + "'" +
		                 " and DCScope = '" + this.sDCScope + "'" +
		                 " and ANScope = '" + this.sANScope + "'" ;
		ASResultSet rs = Sqlca.getASResultSet(sSelSql);
		if(rs.next()){
		   if(rs.getInt(1)>0){
			   String sDel = "delete from Reserve_TransferInd" +
	                 " where BeginAccountMonth = '" + this.sBeginAccountMonth + "'" +
	                 " and EndAccountMonth = '" + this.sEndAccountMonth + "'" +
	                 " and MAScope = '" + this.sMAScope + "'" +
	                 " and DCScope = '" + this.sDCScope + "'" +
	                 " and ANScope = '" + this.sANScope + "'" ;
			   Sqlca.executeSQL(sDel);
		   }
		}
		rs.getStatement().close();
		
		String sSql = " insert into Reserve_TransferInd (" +
					" BEGINACCOUNTMONTH" + 
					", ENDACCOUNTMONTH" + 
					", MASCOPE" + 
					", DCSCOPE" + 
					", ANSCOPE" + 
					", ATOA" + 
					", ATOB" + 
					", ATOC" + 
					", ATOD" + 
					", ATOE" + 
					", ATOF" + 
                    
					", BTOA" + 
					", BTOB" + 
					", BTOC" + 
					", BTOD" + 
					", BTOE" + 
					", BTOF" + 
                    
					", CTOA" + 
					", CTOB" + 
					", CTOC" + 
					", CTOD" + 
					", CTOE" + 
					", CTOF" + 
                    
					", DTOA" + 
					", DTOB" + 
					", DTOC" + 
					", DTOD" + 
					", DTOE" + 
					", DTOF" + 
                    
					", ETOA" + 
					", ETOB" + 
					", ETOC" + 
					", ETOD" + 
					", ETOE" + 
					", ETOF" +
                    
					", FTOA" + 
					", FTOB" + 
					", FTOC" + 
					", FTOD" + 
					", FTOE" + 
					", FTOF" +
                    
					", AASUM" + 
					", ABSUM" + 
					", ACSUM" + 
					", ADSUM" + 
					", AESUM" + 
					", AFSUM" + 
                    
					", BASUM" + 
					", BBSUM" + 
					", BCSUM" + 
					", BDSUM" + 
					", BESUM" + 
					", BFSUM" + 
                    
					", CASUM" + 
					", CBSUM" + 
					", CCSUM" + 
					", CDSUM" + 
					", CESUM" + 
					", CFSUM" + 
                    
					", DASUM" + 
					", DBSUM" + 
					", DCSUM" + 
					", DDSUM" + 
					", DESUM" + 
					", DFSUM" +
                    
					", EASUM" + 
					", EBSUM" + 
					", ECSUM" + 
					", EDSUM" + 
					", EESUM" + 
					", EFSUM" + 
                    
					", FASUM" + 
					", FBSUM" + 
					", FCSUM" + 
					", FDSUM" + 
					", FESUM" + 
					", FFSUM" + 
                    
					", AFINALRATE" + 
					", BFINALRATE" + 
					", CFINALRATE" + 
					", DFINALRATE" + 
					", EFINALRATE" + 		              
					", FFINALRATE" + 		              
				      ") values (" +
		              " '" + this.sBeginAccountMonth + "'" +
		              ", '" + this.sEndAccountMonth + "'" +
		              ", '" + this.sMAScope + "'" +
		              ", '" + this.sDCScope + "'" +
		              ", '" + this.sANScope + "'" +
		              ", " + AtoA + 
		              ", " + AtoB + 
		              ", " + AtoC + 
		              ", " + AtoD + 
		              ", " + AtoE + 
		              ", " + AtoF + 
                      
		              ", " + BtoA + 
		              ", " + BtoB + 
		              ", " + BtoC + 
		              ", " + BtoD + 
		              ", " + BtoE + 
		              ", " + BtoF + 
                      
		              ", " + CtoA + 
		              ", " + CtoB + 
		              ", " + CtoC + 
		              ", " + CtoD + 
		              ", " + CtoE +
		              ", " + CtoF +
                      
		              ", " + DtoA + 
		              ", " + DtoB + 
		              ", " + DtoC + 
		              ", " + DtoD + 
		              ", " + DtoE + 
		              ", " + DtoF + 
                      
		              ", " + EtoA + 
		              ", " + EtoB + 
		              ", " + EtoC + 
		              ", " + EtoD + 
		              ", " + EtoE +
		              ", " + EtoF +
                      
		              ", " + FtoA + 
		              ", " + FtoB + 
		              ", " + FtoC + 
		              ", " + FtoD + 
		              ", " + FtoE +
		              ", " + FtoF +
                      
		              ", " + AASum + 
		              ", " + ABSum + 
		              ", " + ACSum + 
		              ", " + ADSum + 
		              ", " + AESum + 
		              ", " + AFSum + 
                      
		              ", " + BASum + 
		              ", " + BBSum + 
		              ", " + BCSum + 
		              ", " + BDSum + 
		              ", " + BESum + 
		              ", " + BFSum + 
                      
		              ", " + CASum + 
		              ", " + CBSum + 
		              ", " + CCSum + 
		              ", " + CDSum + 
		              ", " + CESum + 
		              ", " + CFSum + 
                      
		              ", " + DASum + 
		              ", " + DBSum + 
		              ", " + DCSum + 
		              ", " + DDSum + 
		              ", " + DESum +
		              ", " + DFSum +
                      
		              ", " + EASum + 
		              ", " + EBSum + 
		              ", " + ECSum + 
		              ", " + EDSum + 
		              ", " + EESum + 
		              ", " + EFSum + 
                      
		              ", " + FASum + 
		              ", " + FBSum + 
		              ", " + FCSum + 
		              ", " + FDSum + 
		              ", " + FESum + 
		              ", " + FFSum + 
                      
		              ", " + dAFinalRate + 
		              ", " + dBFinalRate + 
		              ", " + dCFinalRate + 
		              ", " + dDFinalRate + 
		              ", " + dEFinalRate + 
		              ", " + dFFinalRate + 
		              ")";
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * 对期初最终余额进行初始化
	 * @throws Exception
	 */
	public void init() throws Exception{
		if(this.sDCScope.equals("D")){
			dABalance = getDBalance("1");
			dBBalance = getDBalance("2");
			dCBalance = getDBalance("3");
			dDBalance = getDBalance("4");
			dEBalance = getDBalance("5");
			dFBalance = getDBalance("6");
		}
		if(dABalance == 0.0 ){
			dABalance = 1;
		}
		if(dBBalance == 0.0 ){
			dBBalance = 1;
		}
		if(dCBalance == 0.0 ){
			dCBalance = 1;
		}
		if(dDBalance == 0.0 ){
			dDBalance = 1;
		}
		if(dEBalance == 0.0 ){
			dEBalance = 1;
		}
		if(dFBalance == 0.0 ){
		    dFBalance = 1;
		}
 	}
	
	/**
	 * 对私有参数进行清空处理
	 * @throws Exception
	 */
	public void clear() throws Exception{
		dABalance = 0.0;//
		dBBalance = 0.0;//
		dCBalance = 0.0;//
		dDBalance = 0.0;//
		dEBalance = 0.0;//
        dFBalance = 0.0;//
        
	}
   
	/**
	 * 根据期初逾期天数分类，期末逾期天数分类计算迁徙后的贷款余额
	 * @param sBeginStatus
	 * @param sEndStatus
	 * @return
	 * @throws Exception
	 */
	private double calEndFiveBalanceForOverDueDays(String sBeginStatus, String sEndStatus) throws Exception{
	    double dEndBalance = 0.0;
	    if(this.sDCScope.equals("D")){
	        dEndBalance = CalDMatrixForOverDueDays(sBeginStatus, sEndStatus);
	    }
	    return dEndBalance;
	}


	
	/**
	 * 根据借据口径计算某类逾期天数分类从起初到期末的贷款的迁徙率
	 * @param sBeginStatus  期初逾期天数分类
	 * @param sEndStatus    期末逾期天数分类
	 * @return
	 */
	private double CalDMatrixForOverDueDays(String sBeginStatus, String sEndStatus)throws Exception {
	    double dEndBalance = 0.0;
	    //获取期末迁徙后逾期天数对应阶段的余额
	    String	sSql = " select nvl(sum(decode(getOverDueDaysStatus(RT2.overduedays),'"+sEndStatus+"',1)*(case when RT2.RMBBalance> RT1.RMBBalance then RT1.RMBBalance else RT2.RMBBalance End)),0) as EndBalance "+
	    " from Reserve_Total RT1,Reserve_Total RT2 "+
	    " where RT1.AccountMonth='"+sBeginAccountMonth+"' "+
	    " and RT1.LoanAccount = RT2.LoanAccount and RT1."+sScopeField + "= '2' " +  
	    " and RT2.AccountMonth='"+sEndAccountMonth+"' and getOverDueDaysStatus(RT1.overduedays)='"+sBeginStatus+"' ";
	    ASResultSet rs = Sqlca.getASResultSet(sSql);
	    if (rs.next()) {
	        dEndBalance = rs.getDouble("EndBalance");
	    }
	    // 关闭rs
	    rs.getStatement().close();
	    return dEndBalance;
	}

	/**
	 * 获取按借据统计的五级分类贷款余额
	 * @param sFiveClassify
	 * @return
	 * @throws Exception
	 */
	private double getDBalance(String sOverDueDaysStatus)throws Exception{
		double dBeginBalance = 0.0;
		//获取期初对应逾期天数阶段的分类余额
		String sSql = " select nvl(sum(RMBBalance),0) as BeginBalance " +
				 " from Reserve_Total " + " where AccountMonth = '" + sBeginAccountMonth + "'" + 
				 " and getOverDueDaysStatus(overduedays) ='" + sOverDueDaysStatus + "' " + 
				 " and "+sScopeField + "= '2' ";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) {
			dBeginBalance = rs.getDouble("BeginBalance");
		}
		// 关闭rs
		rs.getStatement().close();
		
		return dBeginBalance;
	}

	
	public static void main(String[] args){
		try
		{
			java.sql.Connection conn = ConnectionManager.getConnection("jdbc:informix-sqli://38.19.7.31:1526/als6hs:INFORMIXSERVER=hsxd_kf",
					"com.informix.jdbc.IfxDriver", "informix", "informix");
			Transaction Sqlca = new Transaction(conn);
			TransferRateCalInd t = new TransferRateCalInd(Sqlca, "2008/04", "2008/05", "A", "D", "A");
			
			t.init();
			t.calMatrixRate();
			t.clear();
			ArrayList al = t.getTransferRate();
			
			Sqlca.conn.commit();
			for(int i =0; i< al.size(); i++){
				System.out.println(al.get(i));
			}
			
			
		}catch(Exception e)
		{
			e.printStackTrace();
			System.out.println(e.toString());
		}		
	}
}

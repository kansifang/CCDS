package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;

/**
 * 迁徙矩阵迁徙率的计算
 * 可以根据管理与审计口径、全额与净额口径、按借据与按客户不同的口径分别计算迁徙率
 * 注意：按客户统计的前提条件为：客户的期初所有的贷款五级分类与期末所有的贷款五级分类有且仅有同一种分类结果，
 *      期初的分类结果可以与期末不同。
 * @author xhwang1
 * @modify ycsun 2008/10/24 增加个人业务
 */
public class TransferRateCal {
	private Transaction Sqlca = null;
	private String sBeginAccountMonth;//期初日期
	private String sEndAccountMonth;//期末日期
	private String sMAScope;      //M-管理层口径, A-审计层口径   
	private String sANScope;     //A-按全额统计, N-按净额统计
	private String sDCScope;    //D-按借据， C-按客户
    private String sTable = "Reserve_Transfer";//modify by ycsun 2008/10/24 区分对公和个人业务，两个业务保存在不同的表中
    private String sBusinessFlag;// modify by ycsun 2008/10/24 业务标识，1为对公，2为个人
	private double dABalance;//起初正常贷款余额
	private double dBBalance;//起初关注贷款余额
	private double dCBalance;//起初次级贷款余额
	private double dDBalance;//起初可疑贷款余额
	private double dEBalance;//起初损失贷款余额
	
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
	public TransferRateCal(Transaction Sqlca, String sBeginAccountMonth, String sEndAccountMonth, String sMAScope, String sDCScope, String sANScope,String sBusinessFlag)throws Exception{
		this.Sqlca = Sqlca;
		this.sBeginAccountMonth = sBeginAccountMonth;
		this.sEndAccountMonth = sEndAccountMonth;
		this.sANScope = sANScope;
		this.sDCScope = sDCScope;
		this.sMAScope = sMAScope;
        this.sBusinessFlag = sBusinessFlag;
		if(this.sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			//sScopeField = "ManageStatFlag";
		}
        if("2".equals(sBusinessFlag)){
            sTable = "Reserve_Transfer1"; //modify by ycsun 2008/10/24  当业务为个人业务时，改变运算或取数的表
        }
	}
 
	/**
	 * 计算单个期初五级分类，期末五级分类的迁徙率
	 * @param sBeginStatus
	 * @param sEndStatus
	 * @return
	 * @throws Exception
	 */
	public double calSingleTransferRate(String sBeginStatus, String sEndStatus) throws Exception{
		double dBeginBalance = 0.0;
		if(sBeginStatus.equals("01")){
			dBeginBalance = dABalance;
		}else if(sBeginStatus.equals("02")){
			dBeginBalance = dBBalance;
		}else if(sBeginStatus.equals("03")){
			dBeginBalance = dCBalance;
		}else if(sBeginStatus.equals("04")){
			dBeginBalance = dDBalance;
		}else if(sBeginStatus.equals("05")){
			dBeginBalance = dEBalance;
		}
		double rate = calEndFiveBalance(sBeginStatus, sEndStatus) * 100/dBeginBalance;
		return rate;
	}
	
	/**
	 * 得到所有的迁徙率，默认的是本期迁徙率
	 * @return
	 * @throws Exception
	 */
	public ArrayList getTransferRate()throws Exception{
		ArrayList al = new ArrayList();
		String sSelSql = "select AtoA, AtoB, AtoC, AtoD, AtoE  " 
		        + ", BtoA, BtoB, BtoC, BtoD, BtoE "
		        + ", CtoA, CtoB, CtoC, CtoD, CtoE "
		        + ", DtoA, DtoB, DtoC, CtoD, DtoE "
		        + ", EtoA, EtoB, EtoC, EtoD, EtoE "
		        + ", AFinalRate, BFinalRate, CFinalRate, DFinalRate, EFinalRate "
		        + ", AtoARate, AtoBRate, AtoCRate, AtoDRate, AtoERate "
		        + ", AtoAWRate, AtoBWRate, AtoCWRate, AtoDWRate, AtoEWRate "
		        + ", BtoARate, BtoBRate, BtoCRate, BtoDRate, BtoERate "
		        + ", BtoAWRate, BtoBWRate, BtoCWRate, BtoDWRate, BtoEWRate "
		        + " from "+ sTable  
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
		String sSelSql = "select AtoA, AtoB, AtoC, AtoD, AtoE  " 
		        + ", BtoA, BtoB, BtoC, BtoD, BtoE "
		        + ", CtoA, CtoB, CtoC, CtoD, CtoE "
		        + ", DtoA, DtoB, DtoC, CtoD, DtoE "
		        + ", EtoA, EtoB, EtoC, EtoD, EtoE "
		        + ", AFinalRate, BFinalRate, CFinalRate, DFinalRate, EFinalRate "
		        + ", AtoARate, AtoBRate, AtoCRate, AtoDRate, AtoERate "
		        + ", AtoAWRate, AtoBWRate, AtoCWRate, AtoDWRate, AtoEWRate "
		        + ", BtoARate, BtoBRate, BtoCRate, BtoDRate, BtoERate "
		        + ", BtoAWRate, BtoBWRate, BtoCWRate, BtoDWRate, BtoEWRate "
		        + " from  "+sTable
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
   	
    	//获取前年公司贷款总额
    	double dSecLastBalance = this.getTotalBalance(iSecLastYear+"/12");
    	//获取去年公司贷款总额
    	double dLastBalance = this.getTotalBalance(iLastYear+"/12");
    	//获取本期公司贷款总额
    	double dBalance = this.getTotalBalance(this.sEndAccountMonth);
    	
    	//正常类转关注类平均迁徙率为：
    	double AtoARate = 0.0;
    	double AtoAWRate = 0.0;
    	
        
    	double AtoBRate = (Double.parseDouble((String)alRate.get(1)) + 
    	                   Double.parseDouble((String)alLastRate.get(1))+
    	                   Double.parseDouble((String)alSecLastRate.get(1)))/3.0;
        //正常类转关注类加权迁徙率为：
       double dTotal = dSecLastBalance + dLastBalance + dBalance;
       if(dTotal<=0){
           dTotal = 1;
       }
       System.out.println("~~~~~~~~~~~"+dTotal);
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
    	
    	double BtoARate = 0.0;
    	double BtoAWRate = 0.0;
    	double BtoBRate = 0.0;
    	double BtoBWRate = 0.0;
    	//关注类转次级类平均迁徙率为：
    	double BtoCRate = (Double.parseDouble((String)alRate.get(7)) + 
    	                   Double.parseDouble((String)alLastRate.get(7))+
    	                   Double.parseDouble((String)alSecLastRate.get(7)))/3.0;
        //关注类转次级类加权迁徙率为：
    	double BtoCWRate = (Double.parseDouble((String)alSecLastRate.get(7)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(7)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(7)) * dBalance)/dTotal;
    	//关注类转可疑类平均迁徙率为：
    	double BtoDRate = (Double.parseDouble((String)alRate.get(8)) + 
    	                   Double.parseDouble((String)alLastRate.get(8))+
    	                   Double.parseDouble((String)alSecLastRate.get(8)))/3.0;
        //关注类转可疑类加权迁徙率为：
    	double BtoDWRate = (Double.parseDouble((String)alSecLastRate.get(8)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(8)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(8)) * dBalance)/dTotal;
    	//关注类转损失类平均迁徙率为：
    	double BtoERate = (Double.parseDouble((String)alRate.get(9)) + 
    	                   Double.parseDouble((String)alLastRate.get(9))+
    	                   Double.parseDouble((String)alSecLastRate.get(9)))/3.0;
        //关注类转损失类加权迁徙率为：
    	double BtoEWRate = (Double.parseDouble((String)alSecLastRate.get(9)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(9)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(9)) * dBalance)/dTotal;
    	
    	String 	sSql = "UPDATE "+sTable+" set"  +
            " AtoARate = " + AtoARate + 
            ", AtoBRate = " + AtoBRate + 
            ", AtoCRate = " + AtoCRate + 
            ", AtoDRate = " + AtoDRate + 
            ", AtoERate = " + AtoERate + 
            ", AtoAWRate = " + AtoAWRate + 
            ", AtoBWRate = " + AtoBWRate + 
            ", AtoCWRate = " + AtoCWRate + 
            ", AtoDWRate = " + AtoDWRate + 
            ", AtoEWRate = " + AtoEWRate + 
            ", BtoARate = " + BtoARate + 
            ", BtoBRate = " + BtoBRate + 
            ", BtoCRate = " + BtoCRate + 
            ", BtoDRate = " + BtoDRate + 
            ", BtoERate = " + BtoERate + 
            ", BtoAWRate = " + BtoAWRate + 
            ", BtoBWRate = " + BtoBWRate + 
            ", BtoCWRate = " + BtoCWRate + 
            ", BtoDWRate = " + BtoDWRate + 
            ", BtoEWRate = " + BtoEWRate  
			+ " where BeginAccountMonth = '" + (iLastYear + this.sEndAccountMonth.substring(4))	+ "'" 
			+ " and EndAccountMonth = '" + this.sEndAccountMonth + "'"  
			+ " and MAScope = '" + this.sMAScope + "'"
			+ " and DCScope = '" + this.sDCScope + "'" 
			+ " and ANScope = '" + this.sANScope + "'";
       Sqlca.executeSQL(sSql);
  	
    }
	
    public double getTotalBalance(String sAccountMonth)throws Exception{
        ASResultSet rs = null;
        String sSql = "";
        double dLoanBalance = 0.0;
        
        sSql =  " select nvl(sum(RMBBalance),0.0) "+
                " from RESERVE_TOTAL "+
                " where AccountMonth = '"+sAccountMonth+"' and BusinessFlag='"+ this.sBusinessFlag +"' ";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
        {
            dLoanBalance = rs.getDouble(1);
        }
        rs.getStatement().close();
        return dLoanBalance;        
    }
    
	/**
	 * 计算五级分类的所有迁徙率，并保存到数据库中
	 * @throws Exception
	 */
	public void calMatrixRate()throws Exception{
		//正常类贷款各级迁徙率
		double AASum = calEndFiveBalance("01", "01"); 
		double ABSum = calEndFiveBalance("01", "02"); 
		double ACSum = calEndFiveBalance("01", "03"); 
		double ADSum = calEndFiveBalance("01", "04"); 
		double AESum = calEndFiveBalance("01", "05"); 
		double AtoA = AASum * 100/dABalance;
		double AtoB = ABSum * 100/dABalance;
		double AtoC = ACSum * 100/dABalance;
		double AtoD = ADSum * 100/dABalance;
		double AtoE = AESum * 100/dABalance;
		//关注类贷款各级迁徙率
		double BASum = calEndFiveBalance("02", "01"); 
		double BBSum = calEndFiveBalance("02", "02"); 
		double BCSum = calEndFiveBalance("02", "03"); 
		double BDSum = calEndFiveBalance("02", "04"); 
		double BESum = calEndFiveBalance("02", "05"); 

		double BtoA = BASum * 100/dBBalance;
		double BtoB = BBSum * 100/dBBalance;
		double BtoC = BCSum * 100/dBBalance;
		double BtoD = BDSum * 100/dBBalance;
		double BtoE = BESum * 100/dBBalance;
		//次级类贷款各级迁徙率
		double CASum = calEndFiveBalance("03", "01"); 
		double CBSum = calEndFiveBalance("03", "02"); 
		double CCSum = calEndFiveBalance("03", "03"); 
		double CDSum = calEndFiveBalance("03", "04"); 
		double CESum = calEndFiveBalance("03", "05"); 

		double CtoA = CASum * 100/dCBalance;
		double CtoB = CBSum * 100/dCBalance;
		double CtoC = CCSum * 100/dCBalance;
		double CtoD = CDSum * 100/dCBalance;
		double CtoE = CESum * 100/dCBalance;
		//可疑类贷款各级迁徙率
		double DASum = calEndFiveBalance("04", "01"); 
		double DBSum = calEndFiveBalance("04", "02"); 
		double DCSum = calEndFiveBalance("04", "03"); 
		double DDSum = calEndFiveBalance("04", "04"); 
		double DESum = calEndFiveBalance("04", "05"); 

		double DtoA = DASum * 100/dDBalance;
		double DtoB = DBSum * 100/dDBalance;
		double DtoC = DCSum * 100/dDBalance;
		double DtoD = DDSum * 100/dDBalance;
		double DtoE = DESum * 100/dDBalance;
		//损失类贷款各级迁徙率
		double EASum = calEndFiveBalance("05", "01"); 
		double EBSum = calEndFiveBalance("05", "02"); 
		double ECSum = calEndFiveBalance("05", "03"); 
		double EDSum = calEndFiveBalance("05", "04"); 
		double EESum = calEndFiveBalance("05", "05"); 

		double EtoA = EASum * 100/dEBalance;
		double EtoB = EBSum * 100/dEBalance;
		double EtoC = ECSum * 100/dEBalance;
		double EtoD = EDSum * 100/dEBalance;
		double EtoE = EESum * 100/dEBalance;;
		
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


		String sSelSql = "select count(*) from "+sTable + 
		                 " where BeginAccountMonth = '" + this.sBeginAccountMonth + "'" +
		                 " and EndAccountMonth = '" + this.sEndAccountMonth + "'" +
		                 " and MAScope = '" + this.sMAScope + "'" +
		                 " and DCScope = '" + this.sDCScope + "'" +
		                 " and ANScope = '" + this.sANScope + "'" ;
		ASResultSet rs = Sqlca.getASResultSet(sSelSql);
		if(rs.next()){
		   if(rs.getInt(1)>0){
			   String sDel = "delete from "+sTable +
	                 " where BeginAccountMonth = '" + this.sBeginAccountMonth + "'" +
	                 " and EndAccountMonth = '" + this.sEndAccountMonth + "'" +
	                 " and MAScope = '" + this.sMAScope + "'" +
	                 " and DCScope = '" + this.sDCScope + "'" +
	                 " and ANScope = '" + this.sANScope + "'" ;
			   Sqlca.executeSQL(sDel);
		   }
		}
		rs.getStatement().close();
		
		String sSql = " insert into "+sTable + "(" +
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
					", BTOA" + 
					", BTOB" + 
					", BTOC" + 
					", BTOD" + 
					", BTOE" + 
					", CTOA" + 
					", CTOB" + 
					", CTOC" + 
					", CTOD" + 
					", CTOE" + 
					", DTOA" + 
					", DTOB" + 
					", DTOC" + 
					", DTOD" + 
					", DTOE" + 
					", ETOA" + 
					", ETOB" + 
					", ETOC" + 
					", ETOD" + 
					", ETOE" + 
					", AASUM" + 
					", ABSUM" + 
					", ACSUM" + 
					", ADSUM" + 
					", AESUM" + 
					", BASUM" + 
					", BBSUM" + 
					", BCSUM" + 
					", BDSUM" + 
					", BESUM" + 
					", CASUM" + 
					", CBSUM" + 
					", CCSUM" + 
					", CDSUM" + 
					", CESUM" + 
					", DASUM" + 
					", DBSUM" + 
					", DCSUM" + 
					", DDSUM" + 
					", DESUM" + 
					", EASUM" + 
					", EBSUM" + 
					", ECSUM" + 
					", EDSUM" + 
					", EESUM" + 
					", AFINALRATE" + 
					", BFINALRATE" + 
					", CFINALRATE" + 
					", DFINALRATE" + 
					", EFINALRATE" + 		              
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
		              ", " + BtoA + 
		              ", " + BtoB + 
		              ", " + BtoC + 
		              ", " + BtoD + 
		              ", " + BtoE + 
		              ", " + CtoA + 
		              ", " + CtoB + 
		              ", " + CtoC + 
		              ", " + CtoD + 
		              ", " + CtoE + 
		              ", " + DtoA + 
		              ", " + DtoB + 
		              ", " + DtoC + 
		              ", " + DtoD + 
		              ", " + DtoE + 
		              ", " + EtoA + 
		              ", " + EtoB + 
		              ", " + EtoC + 
		              ", " + EtoD + 
		              ", " + EtoE +
		              ", " + AASum + 
		              ", " + ABSum + 
		              ", " + ACSum + 
		              ", " + ADSum + 
		              ", " + AESum + 
		              ", " + BASum + 
		              ", " + BBSum + 
		              ", " + BCSum + 
		              ", " + BDSum + 
		              ", " + BESum + 
		              ", " + CASum + 
		              ", " + CBSum + 
		              ", " + CCSum + 
		              ", " + CDSum + 
		              ", " + CESum + 
		              ", " + DASum + 
		              ", " + DBSum + 
		              ", " + DCSum + 
		              ", " + DDSum + 
		              ", " + DESum + 
		              ", " + EASum + 
		              ", " + EBSum + 
		              ", " + ECSum + 
		              ", " + EDSum + 
		              ", " + EESum + 
		              ", " + dAFinalRate + 
		              ", " + dBFinalRate + 
		              ", " + dCFinalRate + 
		              ", " + dDFinalRate + 
		              ", " + dEFinalRate + 
		              ")";
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * 对期初最终余额进行初始化
	 * @throws Exception
	 */
	public void init() throws Exception{
		if(this.sDCScope.equals("D")){
			dABalance = getDBalance("01");
			dBBalance = getDBalance("02");
			dCBalance = getDBalance("03");
			dDBalance = getDBalance("04");
			dEBalance = getDBalance("05");
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
 	}
	
	/**
	 * 对私有参数进行清空处理
	 * @throws Exception
	 */
	public void clear() throws Exception{
		dABalance = 0.0;//起初正常贷款余额
		dBBalance = 0.0;//起初关注贷款余额
		dCBalance = 0.0;//起初次级贷款余额
		dDBalance = 0.0;//起初可疑贷款余额
		dEBalance = 0.0;//起初损失贷款余额
	}

	/**
	 * 根据期初五级分类，期末五级分类计算迁徙后的贷款余额
	 * @param sBeginStatus
	 * @param sEndStatus
	 * @return
	 * @throws Exception
	 */
	private double calEndFiveBalance(String sBeginStatus, String sEndStatus) throws Exception{
		double dEndBalance = 0.0;
		if(this.sDCScope.equals("D")){
			dEndBalance = CalDMatrix(sBeginStatus, sEndStatus);
		}
		return dEndBalance;
	}

	/**
	 * 根据借据口径计算某类五级分类从起初到期末的贷款的迁徙率
	 * @param sBeginStatus  期初五级分类
	 * @param sEndStatus    期末五级分类
	 * @return
	 */
	private double CalDMatrix(String sBeginStatus, String sEndStatus)throws Exception {
		double dEndBalance = 0.0;
		//获取期末迁徙后五级分类的余额
		 String	sSql = " select nvl(sum(decode(RT2."+sFiveField+",'"+sEndStatus+"',1)*(case when RT2.RMBBalance> RT1.RMBBalance then RT1.RMBBalance else RT2.RMBBalance End)),0) as EndBalance "+
				" from Reserve_Total RT1,Reserve_Total RT2 "+
				" where RT1.AccountMonth='"+sBeginAccountMonth+"' "+
				" and RT1.LoanAccount = RT2.LoanAccount and RT1."+sScopeField + "= '"+this.sBusinessFlag +"'"+
				" and RT2.AccountMonth='"+sEndAccountMonth+"' and RT1." + sFiveField+ "='"+sBeginStatus+"' ";
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
	private double getDBalance(String sFiveClassify)throws Exception{
		double dBeginBalance = 0.0;
		//获取期初对应五级分类的分类类余额
		String sSql = " select nvl(sum(RMBBalance),0) as BeginBalance " +
				 " from Reserve_Total " + " where AccountMonth = '" + sBeginAccountMonth + "'" + 
				 " and " + sFiveField + " ='" + sFiveClassify + "' " + 
				 " and "+sScopeField + "= '"+this.sBusinessFlag+"'";
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
			TransferRateCal t = new TransferRateCal(Sqlca, "2008/04", "2008/05", "A", "D", "A","2");
			
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

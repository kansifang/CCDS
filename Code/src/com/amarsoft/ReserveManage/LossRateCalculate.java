package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;

/**
 * @author ycsun 2008/12/17 损失率计算
 * 根据各级次向下迁徙率,通过输入贷款的回收率来计算倒推各级次的损失率
 * 例：已知贷款的回收率为22.65% 则可疑贷款损失率=从期初到期末可疑到损失的迁徙率*(1-22.65%)
 * 注意：系统默认按管理口径(sMAScope=M)，按全额统计(sANScope=A),按借据(sDCScope=D)进行统计计算
 */
public class LossRateCalculate {
	private Transaction Sqlca = null;
	private String sBeginAccountMonth;//期初日期
	private String sEndAccountMonth;//期末日期
	private String sMAScope;      //M-管理层口径, A-审计层口径   
	private String sANScope;     //A-按全额统计, N-按净额统计
	private String sDCScope;    //D-按借据， C-按客户
    private String sBusinessFlag;// modify by ycsun 2008/10/24 业务标识，1为对公，2为个人
	private double dABalance;//期初正常贷款余额
	private double dBBalance;//期初关注贷款余额
	private double dCBalance;//期初次级贷款余额
	private double dDBalance;//期初可疑贷款余额
	private double dEBalance;//期初损失贷款余额
    
    private double dALossRate ; //正常贷款损失率
    private double dBLossRate ; //正常贷款损失率
    private double dCLossRate ; //正常贷款损失率
    private double dDLossRate ; //正常贷款损失率
    private double dELossRate ; //正常贷款损失率
	
	private String sScopeField = "BusinessFlag";
	private String sFiveField = "AFiveClassify";

	/**
	 * 对该类进行初始化，默认为按审计口径进行统计
	 * @param Sqlca
	 * @param sBeginAccountMonth  期初月份
	 * @param sEndAccountMonth    期末月份
	 * @param sMAScope             
	 * @param sANScope
	 * @param sDCScope
     * 
	 */
	public LossRateCalculate(Transaction Sqlca, String sBeginAccountMonth, String sEndAccountMonth, String sMAScope, String sDCScope, String sANScope,String sBusinessFlag,double dInComingRate)throws Exception{
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
			LossRateCalculate t = new LossRateCalculate(Sqlca, "2008/04", "2008/05", "A", "D", "A","1",22.65);
			
			t.init();
			t.calMatrixRate();
			t.clear();			
			
		}catch(Exception e)
		{
			e.printStackTrace();
			System.out.println(e.toString());
		}		
	}
}

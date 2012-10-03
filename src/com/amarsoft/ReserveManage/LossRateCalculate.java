package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;

/**
 * @author ycsun 2008/12/17 ��ʧ�ʼ���
 * ���ݸ���������Ǩ����,ͨ���������Ļ����������㵹�Ƹ����ε���ʧ��
 * ������֪����Ļ�����Ϊ22.65% ����ɴ�����ʧ��=���ڳ�����ĩ���ɵ���ʧ��Ǩ����*(1-22.65%)
 * ע�⣺ϵͳĬ�ϰ�����ھ�(sMAScope=M)����ȫ��ͳ��(sANScope=A),�����(sDCScope=D)����ͳ�Ƽ���
 */
public class LossRateCalculate {
	private Transaction Sqlca = null;
	private String sBeginAccountMonth;//�ڳ�����
	private String sEndAccountMonth;//��ĩ����
	private String sMAScope;      //M-�����ھ�, A-��Ʋ�ھ�   
	private String sANScope;     //A-��ȫ��ͳ��, N-������ͳ��
	private String sDCScope;    //D-����ݣ� C-���ͻ�
    private String sBusinessFlag;// modify by ycsun 2008/10/24 ҵ���ʶ��1Ϊ�Թ���2Ϊ����
	private double dABalance;//�ڳ������������
	private double dBBalance;//�ڳ���ע�������
	private double dCBalance;//�ڳ��μ��������
	private double dDBalance;//�ڳ����ɴ������
	private double dEBalance;//�ڳ���ʧ�������
    
    private double dALossRate ; //����������ʧ��
    private double dBLossRate ; //����������ʧ��
    private double dCLossRate ; //����������ʧ��
    private double dDLossRate ; //����������ʧ��
    private double dELossRate ; //����������ʧ��
	
	private String sScopeField = "BusinessFlag";
	private String sFiveField = "AFiveClassify";

	/**
	 * �Ը�����г�ʼ����Ĭ��Ϊ����ƿھ�����ͳ��
	 * @param Sqlca
	 * @param sBeginAccountMonth  �ڳ��·�
	 * @param sEndAccountMonth    ��ĩ�·�
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
	 * ���㵥���ڳ��弶���࣬��ĩ�弶�����Ǩ����
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
	 * �����弶���������Ǩ���ʣ������浽���ݿ���
	 * @throws Exception
	 */
	public void calMatrixRate()throws Exception{
		//������������Ǩ����
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
		//��ע��������Ǩ����
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
		//�μ���������Ǩ����
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
		//������������Ǩ����
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
		//��ʧ��������Ǩ����
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
	 * ���ڳ����������г�ʼ��
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
	 * ��˽�в���������մ���
	 * @throws Exception
	 */
	public void clear() throws Exception{
		dABalance = 0.0;//��������������
		dBBalance = 0.0;//�����ע�������
		dCBalance = 0.0;//����μ��������
		dDBalance = 0.0;//������ɴ������
		dEBalance = 0.0;//�����ʧ�������
	}

	/**
	 * �����ڳ��弶���࣬��ĩ�弶�������Ǩ���Ĵ������
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
	 * ���ݽ�ݿھ�����ĳ���弶������������ĩ�Ĵ����Ǩ����
	 * @param sBeginStatus  �ڳ��弶����
	 * @param sEndStatus    ��ĩ�弶����
	 * @return
	 */
	private double CalDMatrix(String sBeginStatus, String sEndStatus)throws Exception {
		double dEndBalance = 0.0;
		//��ȡ��ĩǨ����弶��������
		 String	sSql = " select nvl(sum(decode(RT2."+sFiveField+",'"+sEndStatus+"',1)*(case when RT2.RMBBalance> RT1.RMBBalance then RT1.RMBBalance else RT2.RMBBalance End)),0) as EndBalance "+
				" from Reserve_Total RT1,Reserve_Total RT2 "+
				" where RT1.AccountMonth='"+sBeginAccountMonth+"' "+
				" and RT1.LoanAccount = RT2.LoanAccount and RT1."+sScopeField + "= '"+this.sBusinessFlag +"'"+
				" and RT2.AccountMonth='"+sEndAccountMonth+"' and RT1." + sFiveField+ "='"+sBeginStatus+"' ";
		 ASResultSet rs = Sqlca.getASResultSet(sSql);
		 if (rs.next()) {
			dEndBalance = rs.getDouble("EndBalance");
         }
		// �ر�rs
		rs.getStatement().close();
		return dEndBalance;
	}


	/**
	 * ��ȡ�����ͳ�Ƶ��弶����������
	 * @param sFiveClassify
	 * @return
	 * @throws Exception
	 */
	private double getDBalance(String sFiveClassify)throws Exception{
		double dBeginBalance = 0.0;
		//��ȡ�ڳ���Ӧ�弶����ķ��������
		String sSql = " select nvl(sum(RMBBalance),0) as BeginBalance " +
				 " from Reserve_Total " + " where AccountMonth = '" + sBeginAccountMonth + "'" + 
				 " and " + sFiveField + " ='" + sFiveClassify + "' " + 
				 " and "+sScopeField + "= '"+this.sBusinessFlag+"'";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) {
			dBeginBalance = rs.getDouble("BeginBalance");
		}
		// �ر�rs
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

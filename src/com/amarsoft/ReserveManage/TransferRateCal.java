package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;

/**
 * Ǩ�����Ǩ���ʵļ���
 * ���Ը��ݹ�������ƿھ���ȫ���뾻��ھ���������밴�ͻ���ͬ�Ŀھ��ֱ����Ǩ����
 * ע�⣺���ͻ�ͳ�Ƶ�ǰ������Ϊ���ͻ����ڳ����еĴ����弶��������ĩ���еĴ����弶�������ҽ���ͬһ�ַ�������
 *      �ڳ��ķ�������������ĩ��ͬ��
 * @author xhwang1
 * @modify ycsun 2008/10/24 ���Ӹ���ҵ��
 */
public class TransferRateCal {
	private Transaction Sqlca = null;
	private String sBeginAccountMonth;//�ڳ�����
	private String sEndAccountMonth;//��ĩ����
	private String sMAScope;      //M-�����ھ�, A-��Ʋ�ھ�   
	private String sANScope;     //A-��ȫ��ͳ��, N-������ͳ��
	private String sDCScope;    //D-����ݣ� C-���ͻ�
    private String sTable = "Reserve_Transfer";//modify by ycsun 2008/10/24 ���ֶԹ��͸���ҵ������ҵ�񱣴��ڲ�ͬ�ı���
    private String sBusinessFlag;// modify by ycsun 2008/10/24 ҵ���ʶ��1Ϊ�Թ���2Ϊ����
	private double dABalance;//��������������
	private double dBBalance;//�����ע�������
	private double dCBalance;//����μ��������
	private double dDBalance;//������ɴ������
	private double dEBalance;//�����ʧ�������
	
	private String sScopeField = "BusinessFlag";
	private String sFiveField = "AFiveClassify";

	/**
	 * �Ը�����г�ʼ����Ĭ��Ϊ����ƿھ�����ͳ��
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
            sTable = "Reserve_Transfer1"; //modify by ycsun 2008/10/24  ��ҵ��Ϊ����ҵ��ʱ���ı������ȡ���ı�
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
	 * �õ����е�Ǩ���ʣ�Ĭ�ϵ��Ǳ���Ǩ����
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
	 * �õ����е�Ǩ���ʣ�
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
	 * ���㱾��(�ڼ�Ϊһ�꣩�����ƽ��Ǩ���ʼ���ȨǨ���ʣ������µ����ݿ���
	 * @throws Exception
	 */
    public void updateWeightMatrixRate()throws Exception{
    	//��ȡ���ڻ�����
    	int iYear = Integer.parseInt(this.sEndAccountMonth.substring(0,4));
    	int iLastYear = iYear -1;
    	int iSecLastYear = iYear - 2;
     	
    	//��ȡǰ��Ǩ����
    	ArrayList alSecLastRate = getTransferRate((iSecLastYear - 1)+"/12", iSecLastYear+"/12");
    	//��ȡȥ��Ǩ����
    	ArrayList alLastRate = getTransferRate((iLastYear - 1)+"/12", iLastYear+"/12");
        //��ȡ����һ��Ϊ�ڼ��Ǩ����
    	ArrayList alRate = getTransferRate(iLastYear + this.sEndAccountMonth.substring(4), this.sEndAccountMonth);
    	
    	//�Կ�ֵ���г�ʼ��
     	if(alRate.isEmpty()){
     	   	for(int i=0; i< 30; i++)alRate.add(0.0+"");
    	}
    	if(alLastRate.isEmpty()){
     	   	for(int i=0; i< 30; i++)alLastRate.add(0.0+"");
    	}
     	if(alSecLastRate.isEmpty()){
     	   	for(int i=0; i< 30; i++)alSecLastRate.add(0.0+"");
    	}
   	
    	//��ȡǰ�깫˾�����ܶ�
    	double dSecLastBalance = this.getTotalBalance(iSecLastYear+"/12");
    	//��ȡȥ�깫˾�����ܶ�
    	double dLastBalance = this.getTotalBalance(iLastYear+"/12");
    	//��ȡ���ڹ�˾�����ܶ�
    	double dBalance = this.getTotalBalance(this.sEndAccountMonth);
    	
    	//������ת��ע��ƽ��Ǩ����Ϊ��
    	double AtoARate = 0.0;
    	double AtoAWRate = 0.0;
    	
        
    	double AtoBRate = (Double.parseDouble((String)alRate.get(1)) + 
    	                   Double.parseDouble((String)alLastRate.get(1))+
    	                   Double.parseDouble((String)alSecLastRate.get(1)))/3.0;
        //������ת��ע���ȨǨ����Ϊ��
       double dTotal = dSecLastBalance + dLastBalance + dBalance;
       if(dTotal<=0){
           dTotal = 1;
       }
       System.out.println("~~~~~~~~~~~"+dTotal);
    	double AtoBWRate = (Double.parseDouble((String)alSecLastRate.get(1)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(1)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(1)) * dBalance)/dTotal;
    	//������ת�μ���ƽ��Ǩ����Ϊ��
    	double AtoCRate = (Double.parseDouble((String)alRate.get(2)) + 
    	                   Double.parseDouble((String)alLastRate.get(2))+
    	                   Double.parseDouble((String)alSecLastRate.get(2)))/3.0;
        //������ת�μ����ȨǨ����Ϊ��
    	double AtoCWRate = (Double.parseDouble((String)alSecLastRate.get(2)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(2)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(2))  * dBalance)/dTotal;
    	//������ת������ƽ��Ǩ����Ϊ��
    	double AtoDRate = (Double.parseDouble((String)alRate.get(3)) + 
    	                   Double.parseDouble((String)alLastRate.get(3))+
    	                   Double.parseDouble((String)alSecLastRate.get(3)))/3.0;
        //������ת�������ȨǨ����Ϊ��
    	double AtoDWRate = (Double.parseDouble((String)alSecLastRate.get(3)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(3)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(3)) * dBalance)/dTotal;
    	//������ת��ʧ��ƽ��Ǩ����Ϊ��
    	double AtoERate = (Double.parseDouble((String)alRate.get(4)) + 
    	                   Double.parseDouble((String)alLastRate.get(4))+
    	                   Double.parseDouble((String)alSecLastRate.get(4)))/3.0;
        //������ת��ʧ���ȨǨ����Ϊ��
    	double AtoEWRate = (Double.parseDouble((String)alSecLastRate.get(4)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(4)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(4)) * dBalance)/dTotal;
    	
    	double BtoARate = 0.0;
    	double BtoAWRate = 0.0;
    	double BtoBRate = 0.0;
    	double BtoBWRate = 0.0;
    	//��ע��ת�μ���ƽ��Ǩ����Ϊ��
    	double BtoCRate = (Double.parseDouble((String)alRate.get(7)) + 
    	                   Double.parseDouble((String)alLastRate.get(7))+
    	                   Double.parseDouble((String)alSecLastRate.get(7)))/3.0;
        //��ע��ת�μ����ȨǨ����Ϊ��
    	double BtoCWRate = (Double.parseDouble((String)alSecLastRate.get(7)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(7)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(7)) * dBalance)/dTotal;
    	//��ע��ת������ƽ��Ǩ����Ϊ��
    	double BtoDRate = (Double.parseDouble((String)alRate.get(8)) + 
    	                   Double.parseDouble((String)alLastRate.get(8))+
    	                   Double.parseDouble((String)alSecLastRate.get(8)))/3.0;
        //��ע��ת�������ȨǨ����Ϊ��
    	double BtoDWRate = (Double.parseDouble((String)alSecLastRate.get(8)) * dSecLastBalance + 
    			           Double.parseDouble((String)alLastRate.get(8)) * dLastBalance + 
    			           Double.parseDouble((String)alRate.get(8)) * dBalance)/dTotal;
    	//��ע��ת��ʧ��ƽ��Ǩ����Ϊ��
    	double BtoERate = (Double.parseDouble((String)alRate.get(9)) + 
    	                   Double.parseDouble((String)alLastRate.get(9))+
    	                   Double.parseDouble((String)alSecLastRate.get(9)))/3.0;
        //��ע��ת��ʧ���ȨǨ����Ϊ��
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
		
		//��ʧ���������Ǩ���ʣ�100��
		double dEFinalRate = 100.00;
		//�������������Ǩ���ʣ�����ת��ʧǨ����
		double dDFinalRate = DtoE;
		//�μ����������Ǩ���ʣ��μ�ת����Ǩ����X�������������Ǩ����+�μ�ת��ʧǨ����
		double dCFinalRate = CtoD * dDFinalRate/100.0 + CtoE;
		//��ע���������Ǩ���ʣ���עת�μ�Ǩ����X�μ����������Ǩ����+��עת����Ǩ����X�������������Ǩ����+��עת��ʧǨ����
		double dBFinalRate = BtoC * dCFinalRate/100.0 + BtoD * dDFinalRate/100.0 + BtoE;
		//�������������Ǩ���ʣ�����ת��עǨ����X��ע���������Ǩ����+����ת�μ�Ǩ����X�μ����������Ǩ����+����ת����Ǩ����X�������������Ǩ����+����ת��ʧǨ����
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
